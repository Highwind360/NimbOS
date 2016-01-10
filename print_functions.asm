;
;   Print function
;   Expects bx to point to a null-terminated string
;   Prints the string to the console
;

print:
    push ax
    push bx
    push cx
    mov ah, 0x0e        ; scrolling teletype routine
.print_char:
    mov cx, [bx]
    test cl, cl
    je .exit
    add bx, 1
    mov al, cl
    int 0x10
    jmp .print_char
.exit:
    pop cx
    pop bx
    pop ax
    ret

;
; Calls print, appends newline
;

println:
    call print
    push bx
    mov bx, NWLN
    call print
    pop bx
    ret

NWLN:
    db 0xa,0xd,0
