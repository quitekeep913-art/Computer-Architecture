; Task 13: Array element swapping               (with forwarding)
;
; Both loads go first, so the second load absorbs the delay of the first.
; Stores do not suffer load-use stalls when forwarding is present.

LW R3, 0(R2)        ; ValA
LW R4, 4(R2)        ; ValB
SW R3, 4(R2)        ; Memory[R2+4] = ValA
SW R4, 0(R2)        ; Memory[R2+0] = ValB
