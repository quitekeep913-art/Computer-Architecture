global _main
extern _printf

section .data
    format db "AL = %d, BL = %d", 10, 0

section .text
_main:
    mov al, 10
    ; Copy AL into BL (AL is not destroyed).
    mov bl, al

    movzx ecx, bl
    movzx eax, al

    push ecx
    push eax
    push format
    call _printf
    ; Three values pushed: 3 x 4 = 12 bytes.
    add esp, 12

    xor eax, eax
    ret
