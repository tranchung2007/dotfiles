segment .data                   ; initialized data will put in here

segment .bss                    ; uninitialized data will put in here

segment .text                   ; code will put in here
global main

main:

    mov eax, 0                  ; return back to C
    leave
    ret
