org 0x7c00              ; set offset

;
;   main function
;

; must first load messages referenced
;mov bx, GREETING_MSG
;call println
;
;mov bx, GOODBYE_MSG
;call print

jmp $

;
;   Includes
;

<<<<<<< HEAD
print:
    push ax
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
    pop ax
    ret
=======
include "print_functions.asm"
>>>>>>> 6966e2db53b9fb0cc07c063e884baab6d2ac6a77

;
;   Data
;

<<<<<<< HEAD
println:
    call print
    push bx
    mov bx, NWLN
    call print
    pop bx
    ret

NWLN:
    db 0xa,0xd,0

;
; Messages section
;

=======
>>>>>>> 6966e2db53b9fb0cc07c063e884baab6d2ac6a77
GREETING_MSG:
    db 'Welcome to NimbOS. There is nothing here right now.',0

ASDF_MSG:
    db 'something is wrong',0

GOODBYE_MSG:
    db 'Goodbye!',0

times 512-($-$$) db 0
