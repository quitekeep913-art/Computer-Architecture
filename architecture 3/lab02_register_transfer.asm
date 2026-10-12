; Lab 2: Register-to-Register Transfer (Internal Data Bus)
; Objective: Route data from one register to another across the internal CPU bus.
; Expected output: EAX = 70, Copied to EBX = 70
global _main
extern _printf

section .data
    msg db "EAX = %d, Copied to EBX = %d", 10, 0

section .text
_main:
    mov eax, 70             ; Load 70 into EAX
    mov ebx, eax            ; Transfer value from EAX to EBX over internal bus

    push ebx
    push eax
    push msg
    call _printf
    add esp, 12

    xor eax, eax
    ret
