; Task 2: Manual NOP insertion, distance 1      (no forwarding)
;
; ADD is in WB at CC5 and writes the register file in the first half.
; A dependent instruction may read in the second half of CC5 (its ID at CC5).
; Right after the producer an instruction would reach ID at CC3,
; so it must wait 2 cycles  ->  2 NOPs.
;
;               CC1 CC2 CC3 CC4 CC5 CC6 CC7 CC8
; ADD R1,R2,R3  IF  ID  EX  MEM WB
; NOP               IF  ID  EX  MEM WB
; NOP                   IF  ID  EX  MEM WB
; SUB R4,R1,R5              IF  ID  EX  MEM WB   (ID at CC5: safe read)

ADD R1, R2, R3
NOP
NOP
SUB R4, R1, R5
