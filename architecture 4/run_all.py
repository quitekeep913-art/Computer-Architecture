#!/usr/bin/env python3
"""
Checks all 20 pipelining tasks with pipeline_sim.py and prints a summary.

    python run_all.py            (works in CMD, PowerShell, Linux, Mac)
"""
import os
import sys

import pipeline_sim as sim

HERE = os.path.dirname(os.path.abspath(__file__))

# (task, file, mode, expected stalls as written, expected stalls with NOPs removed or None, note)
CHECKS = [
    (1,  "task01_raw_dependency.asm",          "nofwd", 2, None, "hazard without any fix: 2 stall cycles needed"),
    (2,  "task02_nop_distance1.asm",           "nofwd", 0, 2,    "2 NOPs"),
    (3,  "task03_nop_distance2.asm",           "nofwd", 0, 1,    "1 NOP"),
    (4,  "task04_multi_operand.asm",           "nofwd", 0, 2,    "2 NOPs (youngest producer decides)"),
    (5,  "task05_chain_additions.asm",         "nofwd", 0, 4,    "2 NOPs per link, 4 in total"),
    (6,  "task06_load_use_stall.asm",          "fwd",   0, 1,    "1 NOP (load-use)"),
    (7,  "task07_load_use_independent.asm",    "fwd",   0, None, "SUB hides the load-use delay"),
    (8,  "task08_address_dependency.asm",      "fwd",   0, 1,    "1 NOP (load -> load address)"),
    (9,  "task09_store_after_arithmetic.asm",  "fwd",   0, None, "EX->MEM forwarding, 0 stalls"),
    (10, "task10_load_to_store.asm",           "fwd",   0, None, "MEM->MEM forwarding, 0 stalls"),
    (11, "task11_expression_scheduling.asm",   "fwd",   0, None, "no stalls with ALU forwarding"),
    (12, "task12_double_load.asm",             "fwd",   0, None, "both load delays filled"),
    (13, "task13_array_swap.asm",              "fwd",   0, None, "no stalls"),
    (14, "task14_dot_product.asm",             "fwd",   0, None, "no stalls (MUL modelled as 1 cycle)"),
    (15, "task15_branch_penalty.asm",          "fwd",   0, None, "control hazard, branch penalty shown in brackets"),
    (16, "task16_delay_slot_from_before.asm",  "fwd",   0, None, "useful delay slot"),
    (17, "task17_delay_slot_nop.asm",          "fwd",   1, None, "NOP in slot + 1 data stall (branch in ID needs R4)"),
    (18, "task18_jump_delay.asm",              "fwd",   0, None, "useful delay slot"),
    (19, "task19_structural_hazard.asm",       "fwd",   0, None, "1 structural conflict with unified memory"),
    (20, "task20_load_and_branch.asm",         "fwd",   0, 2,    "2 NOPs (load -> branch in ID)"),
]


def run(path, mode, strip=False):
    prog = sim.parse(path, strip)
    stalls = sim.simulate(prog, mode)
    return prog, stalls


def main():
    bad = 0
    print(f"{'Task':<5}{'Mode':<7}{'Stalls':<8}{'Without NOPs':<14}Result / note")
    print("-" * 78)
    for task, fname, mode, exp, exp_strip, note in CHECKS:
        path = os.path.join(HERE, fname)
        prog, stalls = run(path, mode)
        ok = stalls == exp
        strip_txt = "-"
        if exp_strip is not None:
            _, s2 = run(path, mode, strip=True)
            strip_txt = str(s2)
            ok = ok and s2 == exp_strip
        extra = ""
        if task == 15:
            for r in ("id", "ex"):
                extra += f" [resolve in {r.upper()}: penalty {sim.branch_report(prog, r)[0][1]}]"
            ok = ok and sim.branch_report(prog, "id")[0][1] == 1 and sim.branch_report(prog, "ex")[0][1] == 2
        if task == 16:
            ok = ok and sim.branch_report(prog, "id")[0][1] == 0
        if task == 17:
            ok = ok and sim.branch_report(prog, "id")[0][1] == 1
        if task == 18:
            ok = ok and sim.branch_report(prog, "id")[0][1] == 0
        if task == 19:
            n = len(sim.structural_conflicts(prog))
            extra = f" [unified-memory conflicts: {n}]"
            ok = ok and n == 1
        bad += 0 if ok else 1
        print(f"{task:<5}{mode:<7}{stalls:<8}{strip_txt:<14}{'OK ' if ok else 'FAIL '}{note}{extra}")
    print("-" * 78)
    print("All 20 tasks match the PDF." if bad == 0 else f"{bad} task(s) did not match.")
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
