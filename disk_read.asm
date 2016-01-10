;
;   Disk read function
;   Reads sectors off the disk
;   expects a number of sectors to read in dh
;   throws an error if read fails
;

read_disk:
    push dx
    mov ah, 0x02
    mov al, dh
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    mov bx, WRITE_AREA
    int 0x13
    jc read_error   ; if carry flag was set, something went wrong
    pop dx
    cmp dh, al
    jne read_error
    ret

read_error:
    mov bx, DISK_ERROR_MSG
    call print
    jmp $

DISK_ERROR_MSG:
    db 'There was an error reading from the disk.',0
