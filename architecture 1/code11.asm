global _main
extern _printf

section .data
    format db "Result = 0x%02X", 10, 0

section .text
_main:
    ; AA = 10101010
    mov al, 0xAA
    ; Mask 0F = 00001111  ->  result 00001010 = 0x0A
    and al, 0x0F

    movzx eax, al
    push eax
    push format
    call _printf
    add esp, 8

    xor eax, eax
    ret
