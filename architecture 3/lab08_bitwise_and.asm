; Lab 8: ALU Bitwise AND (Logic Masking Unit)
; Objective: Isolate the lower nibble of an 8-bit value using an AND gate mask.
; Expected output: Input: 0x5A AND Mask: 0x0F -> Result: 0x0A
global _main
extern _printf

section .data
    msg db "Input: 0x%02X AND Mask: 0x%02X -> Result: 0x%02X", 10, 0

section .text
_main:
    mov eax, 0x5A           ; 01011010b
    mov ebx, 0x0F           ; Mask: 00001111b
    mov ecx, eax
    and ecx, ebx            ; Bitwise AND: clears upper 4 bits

    push ecx
    push ebx
    push eax
    push msg
    call _printf
    add esp, 16

    xor eax, eax
    ret
