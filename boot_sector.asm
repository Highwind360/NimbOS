org 0x7c00              ; set offset

;
;   main function
;

mov bx, GREETING_MSG
call println

mov bx, GOODBYE_MSG
call print

jmp $

;
;   Includes
;

include "print_functions.asm"

;
;   Data
;

GREETING_MSG:
    db 'Welcome to NimbOS. There is nothing here right now.',0

GOODBYE_MSG:
    db 'Goodbye!',0

;
;   padding and boot sector number
;

times 510-($-$$) db 0
dw 0xaa55
