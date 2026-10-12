; Lab 3: Memory Read Cycle (Fetch from RAM to Register)
; Objective: Read a 32-bit integer from memory using the system data bus.
; Expected output: Loaded from RAM: 48
global _main
extern _printf

section .data
    val dd 48               ; Variable defined in RAM
    msg db "Loaded from RAM: %d", 10, 0

section .text
_main:
    mov eax, [val]          ; Assert address of 'val' on bus; load contents into EAX

    push eax
    push msg
    call _printf
    add esp, 8

    xor eax, eax
    ret
