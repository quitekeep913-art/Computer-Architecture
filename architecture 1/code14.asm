global _main
extern _printf

section .data
    zeroMessage   db "No common 1 bits were found.", 10, 0
    commonMessage db "Common 1 bits were found.", 10, 0

section .text
_main:
    ; AL = 11110000
    mov al, 0xF0
    ; BL = 00001111
    mov bl, 0x0F

    ; TEST does a bitwise AND but only updates flags.
    test al, bl

    ; Jump if the result was zero.
    jz no_common_bits

common_bits:
    push commonMessage
    call _printf
    add esp, 4
    jmp finished

no_common_bits:
    push zeroMessage
    call _printf
    add esp, 4

finished:
    xor eax, eax
    ret
