; Task 17: Branch delay slot, NOP fallback
;
; SUB produces R4 and BEQ tests R4, so SUB cannot be moved into the slot
; (the branch would test the OLD R4). No other instruction is available,
; so the slot is filled with a NOP.
;
; Extra note: because the branch is resolved in ID, BEQ also needs R4 from
; the SUB just before it -> the simulator reports 1 data stall here. The PDF
; only talks about the delay slot, this stall is a separate effect.

SUB R4, R4, 1
BEQ R4, R0, EXIT
NOP                 ; delay slot fallback
