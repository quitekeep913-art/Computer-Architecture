; Lab 4: Memory Writeback Cycle (Store from Register to RAM)
; Objective: Write data from a CPU register into a destination address in RAM.
; Expected output: Memory Target after Writeback: 95
global _main
extern _printf

section .data
    target dd 0             ; Destination memory initialized to 0
    msg db "Memory Target after Writeback: %d", 10, 0

section .text
_main:
    mov eax, 95             ; Load 95 into register EAX
    mov [target], eax       ; Write EAX into RAM at label 'target'

    push dword [target]
    push msg
    call _printf
    add esp, 8

    xor eax, eax
    ret
