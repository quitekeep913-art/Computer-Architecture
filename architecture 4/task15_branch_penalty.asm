; Task 15: Branch stall penalty calculation
;
; Branch resolved in EX (stage 3): the right instruction is fetched at CC4,
;   so 2 wrong-path instructions are flushed -> penalty 2 cycles.
; Branch resolved in ID (stage 2): only 1 wrong-path instruction is flushed
;   -> penalty 1 cycle.
; Run the simulator with --branch-resolve id   or   --branch-resolve ex

BEQ R1, R2, TARGET
