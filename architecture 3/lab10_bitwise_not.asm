; Lab 10: ALU Bitwise NOT (Inverter Gate Logic)
; Objective: Perform one's complement bitwise inversion across an 8-bit sub-register.
; Expected output: Input: 0xAA -> Inverted (NOT): 0x55
global _main
extern _printf

section .data
    msg db "Input: 0x%02X -> Inverted (NOT): 0x%02X", 10, 0

section .text
_main:
    mov al, 0xAA            ; 10101010b
    not al                  ; Inverts all bits to 01010101b (0x55)

    movzx eax, al           ; Zero-extend for printf
    push eax
    push 0xAA
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret
