global _main
extern _printf

section .data
    ; %d tells printf to display a decimal number.
    format db "Value in AL = %d", 10, 0

section .text
_main:
    ; Put decimal 10 into AL (8-bit register).
    mov al, 10

    ; MOVZX copies AL into EAX and fills the remaining bits with zeros.
    movzx eax, al

    ; Arguments are pushed right to left.
    push eax
    push format
    call _printf

    ; Two 32-bit values were pushed: remove 8 bytes.
    add esp, 8

    xor eax, eax
    ret
