global _main
extern _printf

section .data
    format db "EAX = 0x%08X, EBX = 0x%08X", 10, 0

section .text
_main:
    mov eax, 0x12345678

    ; PUSH places EAX on the stack.
    push eax
    ; POP removes the top of the stack into EBX.
    pop ebx

    ; Both registers now hold the same value.
    push ebx
    push eax
    push format
    call _printf
    add esp, 12

    xor eax, eax
    ret
