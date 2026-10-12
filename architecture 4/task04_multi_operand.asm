; Task 4: Multi-operand hazard                  (no forwarding)
;
; The stall is decided by the YOUNGEST producer (smallest distance).
; R2 (distance 1) needs 2 NOPs, which also covers R1 (distance 2).

ADD R1, R3, R4      ; producer 1 (distance 2 from the consumer)
ADD R2, R5, R6      ; producer 2 (distance 1 from the consumer)
NOP
NOP
ADD R7, R1, R2      ; reads both R1 and R2 safely
