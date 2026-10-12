; Lab 14: ALU Zero Flag (ZF) Generation
; Objective: Detect when an ALU operation produces a zero result by inspecting the Zero Flag.
; Expected output: Subtraction 15 - 15 = 0 -> Zero Flag (ZF) = 1
global _main
extern _printf

section .data
    msg db "Subtraction 15 - 15 = %d -> Zero Flag (ZF) = %d", 10, 0

section .text
_main:
    mov eax, 15
    sub eax, 15             ; 15 - 15 = 0, ALU sets Zero Flag (ZF = 1)

    pushfd
    pop ebx                 ; Read flags register into EBX

    shr ebx, 6              ; Shift bit 6 (ZF) to bit position 0
    and ebx, 1              ; Isolate the single bit

    push ebx                ; ZF value (1)
    push eax                ; Result (0)
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret
