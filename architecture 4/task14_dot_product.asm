; Task 14: Dot product element interleaving     (with forwarding)
;
; The next element (X1) is pre-fetched while MUL/ADD of the current pair run,
; so the memory port and the ALU both stay busy.
; (The simulator treats MUL as a 1-cycle ALU operation.)

LW  R3, 0(R1)       ; X0
LW  R4, 0(R2)       ; Y0
LW  R5, 4(R1)       ; X1 (pre-fetch)
MUL R6, R3, R4      ; X0 * Y0
ADD R10, R10, R6    ; accumulate
