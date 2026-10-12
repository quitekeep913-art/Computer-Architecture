; Task 10: Load-to-store forwarding             (with forwarding)
;
; LW has its data at the end of MEM. SW needs the data at the start of its
; own MEM, which is the very next cycle. A MEM->MEM bypass gives 0 stalls.

LW R1, 0(R2)
SW R1, 0(R3)        ; memory-to-memory copy, 0 stalls
