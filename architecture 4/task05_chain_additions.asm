; Task 5: Chain of cumulative additions         (no forwarding)
;
; Every ADD depends on the one right before it and there is no independent
; instruction to fill the gap, so each link costs 2 NOPs (4 NOPs in total).

ADD R1, R1, R2
NOP
NOP
ADD R1, R1, R3
NOP
NOP
ADD R1, R1, R4
