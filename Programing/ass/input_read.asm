segment .text
global main:
main:
    mov rax, 1                  ; write msg1
    mov rdi, 1
    mov rsi, msg1
    mov rdx, msg1_len
    syscall

    mov rax, 0                  ; read
    mov rdi, 0
    mov rsi, num
    mov rdx, 5                  ; 1 byte for sign, 4 bytes for number
    syscall

    mov rax, 1                  ; write msg2
    mov rdi, 1
    mov rsi, msg2
    mov rdx, msg2_len
    syscall

    mov rax, 1                  ; write number
    mov rdi, 1
    mov rsi, num
    mov rdx, 5
    syscall

    mov rax, 60                 ; exit
    xor rdi, rdi
    syscall

segment .data
    msg1 db "Enter a number: "
    msg1_len equ $ - msg1
    msg2 db "You entered: "
    msg2_len equ $ - msg2

segment .bss
    num resb 1                  ; reserve 5 bytes
