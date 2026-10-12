; Task 8: Back-to-back address dependency       (with forwarding)
;
; The second LW needs R1 as its BASE ADDRESS inside EX, exactly like a
; normal load-use hazard -> 1 mandatory stall. No instruction is available
; to reorder, so a NOP is used.

LW R1, 0(R2)        ; load the pointer
NOP                 ; stall
LW R3, 4(R1)        ; effective address = R1 + 4
