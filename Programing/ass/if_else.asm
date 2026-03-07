; if ( EAX == 0 )
;    EBX = 1;
; else
;    EBX = 2;

segment .data

segment .text
global main
main:
    cmp eax, 0                  ; 1) if (eax == 0)
    jz  if
    mov ebx, 2                  ; 3) else ebx = 2
    jmp endif                   ; end the if_else
if:
    mov ebx, 1                  ; 2) ebx = 1
endif:
