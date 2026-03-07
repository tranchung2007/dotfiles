%include "io.inc"

segment .data
    msg db "lo lo con cac", 0xa, 0xd
    msg_len equ $-msg

segment .bss
    guess resb 8
    limit resb 256
    lim_len equ $-limit

segment .text
global main
main:
    mov dword [guess], 5
