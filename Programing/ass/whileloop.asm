; while (condition) {
;     body of loop;
; }

while:
    jxx endwhile                ; xx is jump if xx
    ; body of loop
    jmp while
endwhile:
