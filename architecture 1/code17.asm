global _main
extern _printf

section .data
    number db 0
    format db "Value loaded into BL = %d", 10, 0

section .text
_main:
    ; Store 42 in memory.
    mov byte [number], 42

    ; Memory read: copy the byte into BL.
    mov bl, [number]

    movzx eax, bl
    push eax
    push format
    call _printf
    add esp, 8

    xor eax, eax
    ret
