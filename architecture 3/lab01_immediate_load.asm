; Lab 1: Immediate to Register Load (Instruction Fetch & Decode)
; Objective: Load an immediate constant into a CPU general-purpose register.
; Expected output: Register EAX = 25
global _main
extern _printf

section .data
    msg db "Register EAX = %d", 10, 0

section .text
_main:
    mov eax, 25             ; Place immediate value 25 into register EAX

    push eax
    push msg
    call _printf
    add esp, 8

    xor eax, eax
    ret
