org 0x7c00              ; set offset

;
;   main function
;

begin_execution:
    mov bx, GREETING_MSG
    call println

    mov dh, 1           ; read one sector
    call read_disk

succesfully_read_disk:
    mov bx, PRINT_MSG
    call print
    
    mov dx, 0xa3df
    call print_hexln
    
    mov bx, GOODBYE_MSG
    call print

    jmp $

;
;   Printing functions
;

include "print_functions.asm"

;
;   Disk read functions
;

include "disk_read.asm"

;
;   Messages section
;

GREETING_MSG:
    db 'Welcome to NimbOS. There is nothing here right now.',0

PRINT_MSG:
    db 'Printing 0xa3df: ',0

GOODBYE_MSG:
    db 'Goodbye!',0

times 510-($-$$) db 0
dw 0xaa55

WRITE_AREA:

;
;   Hex printing functions
;

include "print_hex_functions.asm"
