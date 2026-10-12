; Lab 13: Shifter Unit - Shift Right (Divide by Powers of 2)
; Objective: Shift data lines to the right to implement unsigned division by 2.
; Expected output: Original: 64 | SHR 1 (/2): 32 | SHR 2 (/4): 16
global _main
extern _printf

section .data
    msg db "Original: %d | SHR 1 (/2): %d | SHR 2 (/4): %d", 10, 0

section .text
_main:
    mov eax, 64             ; Base value
    mov ebx, eax
    shr ebx, 1              ; Shift right 1 bit = 64 / 2 = 32

    mov ecx, eax
    shr ecx, 2              ; Shift right 2 bits = 64 / 4 = 16

    push ecx
    push ebx
    push eax
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret
