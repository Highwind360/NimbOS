org 0x7c00              ; set offset

;
;   main function
;

; must first load messages referenced
;mov bx, GREETING_MSG
;call println
;
;mov bx, PRINT_MSG
;call print
;
;mov dx, 0xa3df
;call print_hex
;
;mov dx, 0x5432
;call print_hexln
;
;mov bx, GOODBYE_MSG
;call print

jmp $

;
;   Includes
;

;include "print_functions.asm"

times 510-($-$$) db 0
dw 0xaa55

;
; Messages section
;

GREETING_MSG:
    db 'Welcome to NimbOS. There is nothing here right now.',0

PRINT_MSG:
    db 'Printing 0xa3df and 0x5432: ',0

GOODBYE_MSG:
    db 'Goodbye!',0

times 512-($-$$) db 0
