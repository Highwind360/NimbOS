[org 0x7c00]

mov ah, 0x0e ; for teletype mode

mov al, 'H' ; characters to be printed go in lower half of the register
int 0x10
mov al, 'e'
int 0x10
mov al, 'l'
int 0x10
mov al, 'l'
int 0x10
mov al, 'o'
int 0x10
mov al, ' '
int 0x10
mov al, 'W'
int 0x10
mov al, 'o'
int 0x10
mov al, 'r'
int 0x10
mov al, 'l'
int 0x10
mov al, 'd'
int 0x10

jmp $ 		; loop to ensure program execution 
			; doesn't tear off into the nether

times 510 - ($ - $$) db 0 ; ensure program is 512 bytes

dw 0Xaa55 ; magic number makes program a boot sector
