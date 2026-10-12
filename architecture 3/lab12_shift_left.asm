; Lab 12: Shifter Unit - Shift Left (Multiply by Powers of 2)
; Objective: Shift data lines to the left to implement hardware multiplication.
; Expected output: Original: 7 | SHL 1 (x2): 14 | SHL 2 (x4): 28
global _main
extern _printf

section .data
    msg db "Original: %d | SHL 1 (x2): %d | SHL 2 (x4): %d", 10, 0

section .text
_main:
    mov eax, 7              ; Base value
    mov ebx, eax
    shl ebx, 1              ; Shift left 1 bit = 7 * 2 = 14

    mov ecx, eax
    shl ecx, 2              ; Shift left 2 bits = 7 * 4 = 28

    push ecx
    push ebx
    push eax
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret
