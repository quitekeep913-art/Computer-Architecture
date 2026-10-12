global _main
extern _printf

section .data
    ; One byte for the final result.
    result db 0
    format db "AL = %d, BL = %d, Memory = %d", 10, 0

section .text
_main:
    ; Step 1: put 10 into AL.
    mov al, 10

    ; Step 2: add 20  (30).
    add al, 20

    ; Step 3: subtract 5  (25).
    sub al, 5

    ; Step 4: store the result in memory.
    mov [result], al

    ; Step 5: read it back into BL.
    mov bl, [result]

    ; Step 6: prepare 32-bit values for printf.
    movzx eax, al
    movzx ecx, bl
    movzx edx, byte [result]

    ; Push arguments right to left.
    push edx
    push ecx
    push eax
    push format
    call _printf
    ; 4 x 4 bytes = 16 bytes.
    add esp, 16

    xor eax, eax
    ret
