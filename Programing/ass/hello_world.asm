; section .data
;     message db "Hello World!", 10
;     msg_len equ $ - message

; section .text
; global main
; main:
;     ; ssize_t write(int fd, const void buf[.count], size_t count)
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, message
;     mov rdx, msg_len
;     syscall

;     ; [[noreturn]] void _exit(int status)
;     mov rax, 60
;     xor rdi, rdi
;     syscall

section .text                   ; This is 32bit version of this fk code
global main      ;must be declared for linker (gcc)
main:            ;tell linker entry point
   mov  edx,len  ;message length
   mov  ecx,msg  ;message to write
   mov  ebx,1    ;file descriptor (stdout)
   mov  eax,4    ;system call number (sys_write)
   int  0x80     ;call kernel

   mov  edx,len2   ;message length
   mov  ecx,s2   ;message to write
   mov  ebx,1    ;file descriptor (stdout)
   mov  eax,4    ;system call number (sys_write)
   int  0x80     ;call kernel

   mov  eax,1    ;system call number (sys_exit)
   int  0x80     ;call kernel

section .data
msg db 'Displaying 10 stars',0xa ;a message
len equ $ - msg  ;length of message
s2 times 0xa db '*'
len2 equ $ - len ;length of message
