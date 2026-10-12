; Task 7: Load-use with independent work        (with forwarding)
;
; The compiler schedules an independent instruction (SUB) right after the
; load. It fills the load-use delay slot, so the stall disappears.

LW  R1, 0(R2)
SUB R5, R6, R7      ; useful work, no penalty
ADD R3, R1, R4      ; R1 forwarded from MEM/WB
