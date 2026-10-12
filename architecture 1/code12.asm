global _main
extern _printf

section .data
    format db "Result = %d", 10, 0

section .text
_main:
    ; 5 = 00000101
    mov al, 5
    ; 8 = 00001000  ->  OR gives 00001101 = 13
    or al, 8

    movzx eax, al
    push eax
    push format
    call _printf
    add esp, 8

    xor eax, eax
    ret
