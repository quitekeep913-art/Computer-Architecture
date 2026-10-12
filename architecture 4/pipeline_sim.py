#!/usr/bin/env python3
"""
Tiny 5-stage pipeline model (IF, ID, EX, MEM, WB) for the pipelining tasks.

Usage:
    python pipeline_sim.py task02_nop_distance1.asm --mode nofwd
    python pipeline_sim.py task06_load_use_stall.asm --mode fwd
    python pipeline_sim.py task06_load_use_stall.asm --mode fwd --strip-nops
    python pipeline_sim.py task15_branch_penalty.asm --mode fwd --branch-resolve ex
    python pipeline_sim.py task19_structural_hazard.asm --mode fwd --unified-memory

Rules used (same as the PDF):
  nofwd : register file is written in the first half of WB and read in the
          second half of ID, so a consumer's ID must be >= producer's WB.
  fwd   : ALU result is available at the end of EX, a LOAD result at the end
          of MEM. Consumers get it from the pipeline registers.
          - ALU inputs are needed at the start of EX
          - store data is needed at the start of MEM
          - branch operands are needed at the start of ID
  Stalls are inserted in ID. A NOP is an ordinary 1-cycle instruction.
"""
import argparse
import re

ALU_OPS = {"ADD", "SUB", "AND", "OR", "XOR", "SLT", "MUL", "ADDI", "SLL", "SRL"}
BRANCH_OPS = {"BEQ", "BNE"}
JUMP_OPS = {"J"}


class Ins:
    def __init__(self, text, op, ops):
        self.text = text
        self.op = op
        self.dest = None        # register written
        self.src_ex = []        # registers needed at start of EX
        self.src_mem = []       # registers needed at start of MEM (store data)
        self.src_id = []        # registers needed at start of ID (branches)
        self.is_load = op == "LW"
        self.is_store = op == "SW"
        self.is_branch = op in BRANCH_OPS or op in JUMP_OPS
        # filled by simulation
        self.id_first = self.id = 0


def is_reg(tok):
    return re.fullmatch(r"R\d+", tok.strip().upper()) is not None and tok.strip().upper() != "R0"


def regs_in(tokens):
    return [t.strip().upper() for t in tokens if is_reg(t)]


def parse(path, strip_nops=False):
    prog = []
    for raw in open(path, encoding="utf-8"):
        line = raw.split(";")[0].split("//")[0].split("#")[0].strip()
        if not line:
            continue
        if re.fullmatch(r"\w+:", line):          # label on its own line
            continue
        line = re.sub(r"^\w+:\s*", "", line)     # label followed by instruction
        parts = line.replace(",", " , ").split(None, 1)
        op = parts[0].upper()
        ops = [o.strip() for o in parts[1].split(",")] if len(parts) > 1 else []
        if op == "NOP" and strip_nops:
            continue
        ins = Ins(line, op, ops)
        if op in ALU_OPS:
            ins.dest = ops[0].upper() if is_reg(ops[0]) else None
            ins.src_ex = regs_in(ops[1:])
        elif op == "LW":
            ins.dest = ops[0].upper() if is_reg(ops[0]) else None
            base = re.search(r"\((R\d+)\)", ops[1].upper())
            ins.src_ex = regs_in([base.group(1)]) if base else []
        elif op == "SW":
            base = re.search(r"\((R\d+)\)", ops[1].upper())
            ins.src_ex = regs_in([base.group(1)]) if base else []
            ins.src_mem = regs_in([ops[0]])
        elif op in BRANCH_OPS:
            ins.src_id = regs_in(ops[:2])
        prog.append(ins)
    return prog


def simulate(prog, mode):
    last_writer = {}
    prev_id = 1                                   # first instruction: IF=1, ID=2
    prev_id_first = 1
    total_stalls = 0
    for ins in prog:
        nominal = prev_id + 1
        need = nominal

        def wait_for(reg, stage):
            nonlocal need
            p = last_writer.get(reg)
            if p is None:
                return
            p_ex, p_mem, p_wb = p.id + 1, p.id + 2, p.id + 3
            if mode == "nofwd":
                need = max(need, p_wb)            # read in ID, after WB write
            else:
                avail = (p_mem + 1) if p.is_load else (p_ex + 1)   # first cycle value usable
                offset = {"id": 0, "ex": 1, "mem": 2}[stage]       # stage start = ID + offset
                need = max(need, avail - offset, 0)
                need = max(need, nominal)

        if mode == "nofwd":
            for r in ins.src_ex + ins.src_mem + ins.src_id:
                wait_for(r, "id")
        else:
            for r in ins.src_ex:
                wait_for(r, "ex")
            for r in ins.src_mem:
                wait_for(r, "mem")
            for r in ins.src_id:
                wait_for(r, "id")

        ins.id_first = nominal
        ins.id = need
        ins.stalls = need - nominal
        total_stalls += ins.stalls
        ins.if_start = prev_id_first if ins is not prog[0] else 1
        prev_id = need
        prev_id_first = nominal
        if ins.dest:
            last_writer[ins.dest] = ins
    return total_stalls


def diagram(prog):
    last = max(i.id + 3 for i in prog)
    width = 5
    head = "instruction".ljust(24) + "".join(str(c).rjust(width) for c in range(1, last + 1))
    lines = [head]
    for ins in prog:
        cells = {}
        for c in range(ins.if_start, ins.id_first):
            cells[c] = "IF"
        for c in range(ins.id_first, ins.id):
            cells[c] = "st"
        cells[ins.id] = "ID"
        cells[ins.id + 1] = "EX"
        cells[ins.id + 2] = "MEM"
        cells[ins.id + 3] = "WB"
        lines.append(ins.text.ljust(24)[:24] + "".join(cells.get(c, "").rjust(width) for c in range(1, last + 1)))
    return "\n".join(lines)


def structural_conflicts(prog):
    """Unified memory: a LW/SW in MEM at the same cycle another instruction is in IF."""
    found = []
    for k, a in enumerate(prog):
        if not (a.is_load or a.is_store):
            continue
        mem_cycle = a.id + 2
        for j, b in enumerate(prog):
            if j <= k:
                continue
            if b.id_first - 1 <= mem_cycle < b.id_first or (b.if_start <= mem_cycle < b.id_first):
                found.append((a.text, b.text, mem_cycle))
    return found


def branch_report(prog, resolve):
    base = 1 if resolve == "id" else 2
    out = []
    for k, ins in enumerate(prog):
        if not ins.is_branch:
            continue
        slot = prog[k + 1] if k + 1 < len(prog) else None
        useful = slot is not None and slot.op != "NOP"
        if slot is None:
            out.append((ins.text, base, "no delay slot instruction"))
        else:
            penalty = max(base - (1 if useful else 0), 0)
            out.append((ins.text, penalty, "delay slot is useful" if useful else "delay slot is a NOP"))
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("file")
    ap.add_argument("--mode", choices=["nofwd", "fwd"], default="fwd")
    ap.add_argument("--strip-nops", action="store_true", help="remove NOPs first to see how many stalls the hardware would need")
    ap.add_argument("--unified-memory", action="store_true")
    ap.add_argument("--branch-resolve", choices=["id", "ex"], default=None)
    ap.add_argument("--quiet", action="store_true")
    a = ap.parse_args()

    prog = parse(a.file, a.strip_nops)
    stalls = simulate(prog, a.mode)
    if not a.quiet:
        print(diagram(prog))
        print()
    print(f"mode={a.mode}  instructions={len(prog)}  data-hazard stall cycles={stalls}")
    if a.unified_memory:
        c = structural_conflicts(prog)
        print(f"structural conflicts (unified memory) = {len(c)}")
        for x, y, cyc in c:
            print(f"  CC{cyc}: '{x}' in MEM and '{y}' in IF need the same memory port")
    if a.branch_resolve:
        for text, pen, why in branch_report(prog, a.branch_resolve):
            print(f"branch '{text}' resolved in {a.branch_resolve.upper()}: penalty if taken = {pen} cycle(s) ({why})")
    return stalls


if __name__ == "__main__":
    main()
