; Lab 6: Basic ALU Subtraction (Two's Complement Subtractor)
; Objective: Subtract one register from another using two's complement inversion.
; Expected output: ALU Subtraction: 50 - 18 = 32
global _main
extern _printf

section .data
    msg db "ALU Subtraction: %d - %d = %d", 10, 0

section .text
_main:
    mov eax, 50             ; Minuend
    mov ebx, 18             ; Subtrahend
    sub eax, ebx            ; ALU computes 50 - 18 = 32

    push eax
    push ebx
    push 50
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret
