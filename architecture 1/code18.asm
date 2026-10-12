global _main
extern _printf

section .data
    ; One byte in memory containing 10.
    number db 10
    format db "New memory value = %d", 10, 0

section .text
_main:
    mov bl, 5

    ; Read-modify-write: memory = memory + BL  (10 + 5 = 15)
    add byte [number], bl

    movzx eax, byte [number]
    push eax
    push format
    call _printf
    add esp, 8

    xor eax, eax
    ret
