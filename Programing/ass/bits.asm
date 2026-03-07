%include "io.inc"

segment .data                   ; initialized data will put in here

segment .bss                    ; uninitialized data will put in here

global main
segment .text                   ; code will put in here
main:

    exit
