; Task 11: Arithmetic expression scheduling: (A + B) + (C + D)   (with forwarding)
;
; The two inner additions are independent, so the second one sits between
; the first addition and the final addition and spaces them out.
; (Needs ALU->ALU forwarding for the last ADD, which this section assumes.)

ADD R5, R1, R2      ; R5 = A + B
ADD R6, R3, R4      ; R6 = C + D
ADD R7, R5, R6      ; R7 = R5 + R6
