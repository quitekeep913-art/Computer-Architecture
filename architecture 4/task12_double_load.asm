; Task 12: Double load scheduling               (with forwarding)
;
; Second load fills the first load's delay slot, and the first ADD fills the
; second load's delay slot. No load-use stall at all.

LW  R1, 0(R4)       ; load A
LW  R6, 4(R4)       ; load B (covers the delay of A)
ADD R2, R1, R5      ; uses A (covers the delay of B)
ADD R7, R6, R8      ; uses B
