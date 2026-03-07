%macro print 2
    mov rax, 1                  ; write
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

%macro read 2
    mov  rax, 0          ; System call number for sys_read
    mov  rdi, 0          ; File descriptor (e.g., 0 for stdin)
    mov  rsi, %1         ; Buffer address
    mov  rdx, %2         ; Count/buffer size
    syscall              ; Call the kernel
%endmacro

%macro exit 0
    mov rax, 60
    xor rdi, rdi
    syscall
%endmacro
