org 0x7c00              ; set offset

;
;   main function
;

mov bx, GREETING_MSG
call println

mov bx, GOODBYE_MSG
call print

;
;   Print function
;   Takes pointer to a string via bx
;   Returns void
;   Preserves registers
;   Uses bios interrupt routine 10,
;   scrolling teletype
;

print:
    push ax
    push cx
    mov ah, 0x0e        ; scrolling teletype routine
.print_char:
    mov cx, [bx]
    test cx, cx
    je .exit
    add bx, 1
    mov al, cl
    int 0x10
.exit:
    pop cx
    pop ax
    ret

;
;   Print with newline function
;   Wrapper for print
;   Appends newline
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

GREETING_MSG:
    db 'Welcome to NimbOS. There is nothing here right now.',0

GOODBYE_MSG:
    db 'Goodbye!',0

;
;   padding and boot sector number
;

times 510-($-$$) db 0
dw 0xaa55
