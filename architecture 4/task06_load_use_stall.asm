; Task 6: The classic load-use stall            (with forwarding)
;
; LW has its data only at the end of MEM (CC4).
; An ADD right behind it needs R1 at the start of its EX (CC4).
; Data cannot go backwards in time, so 1 bubble is unavoidable.

LW  R1, 0(R2)
NOP                 ; 1 stall bubble (hardware or compiler)
ADD R3, R1, R4      ; EX at CC5, gets R1 via MEM->EX forwarding
