; Task 3: Manual NOP insertion, distance 2      (no forwarding)
;
; One independent instruction (AND) already sits between producer and
; consumer, so only 1 more NOP is needed so that OR reaches ID at CC5.

ADD R2, R4, R5
AND R6, R7, R8      ; useful, independent instruction hides 1 cycle
NOP                 ; the one extra cycle still needed
OR  R9, R2, R10     ; ID at CC5, reads R2 safely
