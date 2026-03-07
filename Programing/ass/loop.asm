; sum = 0;
; for ( i = 10; i > 0; i--) {
;     sum += i;
; }
segment .data

segment .text
global main
main:
    mov eax, 0                  ; eax is sum
    mov ebx, 10                 ; ebx is i
loop_start:
    add eax, ebx
    loop loop_start
