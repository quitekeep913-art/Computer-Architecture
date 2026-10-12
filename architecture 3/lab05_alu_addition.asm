; Lab 5: Basic ALU Addition (Adder Unit)
; Objective: Perform a two-operand addition using the ALU adder circuit.
; Expected output: ALU Addition: 30 + 12 = 42
global _main
extern _printf

section .data
    msg db "ALU Addition: %d + %d = %d", 10, 0

section .text
_main:
    mov eax, 30             ; Input A
    mov ebx, 12             ; Input B
    add eax, ebx            ; Adder computes 30 + 12 = 42

    push eax                ; Result (42)
    push ebx                ; Input B (12)
    push 30                 ; Input A (30)
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret
