; Task 1: Spot the RAW Dependency            (no forwarding)
;
; Producer ADD writes R1 in WB (stage 5).
; Consumer SUB reads R1 in ID (stage 2), only 3 cycles after ADD's ID.
; Result: SUB would read a stale R1 -> RAW (Read-After-Write) hazard.

ADD R1, R2, R3
SUB R4, R1, R5      ; RAW hazard on R1
