; Task 20: Combined load-use and branch hazard  (with forwarding, branch in ID)
;
; LW has its data at the end of MEM (CC4). The branch needs R1 inside its ID
; stage, so ID must be at CC5 or later -> 2 stall cycles between LW and BEQ.

LW  R1, 0(R2)
NOP                 ; stall 1
NOP                 ; stall 2
BEQ R1, R0, TARGET  ; ID at CC5, uses forwarded data
