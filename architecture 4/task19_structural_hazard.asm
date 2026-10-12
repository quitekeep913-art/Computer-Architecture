; Task 19: Structural hazard (single unified memory)
;
; LW uses data memory in MEM at CC4, while the 4th instruction (AND) is
; fetched in IF at CC4. One memory port cannot serve both -> conflict.
; Fix: split L1 caches (separate I-cache and D-cache, Harvard style).
; Run the simulator with --unified-memory to see the conflict.

LW  R1, 0(R2)       ; CC4: MEM uses memory
ADD R3, R4, R5
SUB R6, R7, R8
AND R9, R10, R11    ; CC4: IF needs memory too -> conflict
