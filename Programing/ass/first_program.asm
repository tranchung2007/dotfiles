segment .data ; initialized data
prompt1 db "Enter a number: ", 0
segment .bss ; uninitialized data

segment .text
global main
main:
    L1 db 10
