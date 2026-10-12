global _main
extern _printf

section .data
    ; Reserve one byte in memory, initial value 0.
    number db 0
    format db "Value in memory = %d", 10, 0

section .text
_main:
    ; Store 42 at the memory location "number".
    mov byte [number], 42

    ; Read the byte back and widen it to 32 bits.
    movzx eax, byte [number]

    push eax
    push format
    call _printf
    add esp, 8

    xor eax, eax
    ret
