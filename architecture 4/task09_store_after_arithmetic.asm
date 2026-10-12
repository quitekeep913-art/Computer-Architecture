; Task 9: Store after arithmetic                (with forwarding)
;
; ADD finishes R4 at the end of EX. SW only needs the data word in its MEM
; stage, which is later, so EX->MEM forwarding gives 0 stalls.

ADD R4, R2, R3
SW  R4, 0(R5)       ; hazard-free
