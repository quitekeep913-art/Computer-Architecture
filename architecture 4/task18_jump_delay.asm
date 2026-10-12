; Task 18: Unconditional jump delay
;
; J is always taken, so the loop counter decrement can safely sit in the
; delay slot and runs on every iteration while the jump latency is hidden.

LOOP:
J   LOOP
SUB R1, R1, 1       ; delay slot, executes before the jump takes effect
