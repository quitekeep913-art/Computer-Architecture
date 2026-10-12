; Task 16: Branch delay slot, moving an instruction from BEFORE the branch
;
; Originally:   ADD R1,R2,R3   then   BEQ R4,R5,TARGET
; ADD does not touch R4 or R5, so it can be moved into the delay slot.
; The slot instruction always executes, so the delay slot does useful work.

BEQ R4, R5, TARGET
ADD R1, R2, R3      ; delay slot, always executes
