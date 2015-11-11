org 0x7c00				; Tell assembler to correct the offsets

;
;	Main method
;	Prints welcome and exit messages
;

mov bx, HELLO_MSG
call PRINT_FUNC

mov bx, PROCESS_MSG
call PRINT_FUNC

mov dx, 0x1fb6
call PRINT_HEX
mov ax, 0x4000
mov bx, 0
mov es, ax
mov dh, 2
call READ_DISK

mov bx, GOODBYE_MSG
call PRINT_FUNC

jmp $ 					; Hang

;
;	Print function
;	Takes parameters via bx
;	Returns nothing
;	Preserves registers
;
;	Prints out the null terminated
;	string stored at address in bx
;

PRINT_FUNC:
	pusha
	mov ah, 0x0e			; scrolling teletype bios routine
.eval_char:
	mov cx, [bx]
	test cl, cl			; check to see if string has terminated
	je .done
	mov al, cl
	int 0x10
	add bx, 1			; move to the next character
	jmp .eval_char
.done:
	popa
	ret

;
;	PrintHex function
;	Takes parameters via dx
;	Returns nothing
;	Preserves registers
;	Uses global HEX_VALUE
;	
;	Prints out the hexidecimal 
;	stored in the dx register
;

PRINT_HEX:
	pusha				; setup registers
	mov ax, 0xf000
	mov cl, 12
	mov bx, HEX_VALUE
	add bx, 2
.adjust_hex_value:
	push dx				; save original value for later use
	and dx, ax			; isolate four appropriate bits
	shr dx, cl ; shift right by 12?
	cmp dx, 0xa
	jl .was_just_digit
	add dx, 39			; some number voodoo for ascii
.was_just_digit:
	add [bx], dx			; edit character the bytes in bx represent
	shr ax, 4			; increment to next bits
	sub cl, 4
	add bx, 1
	pop dx
	test ax, ax
	jne .adjust_hex_value
	mov bx, HEX_VALUE
	call PRINT_FUNC
	popa
	ret

HEX_VALUE:
	db '0x0000',0xa,0xd,0

;
;	ReadDisk option
;	Takes number of sectors to read via dh
;	Returns nothing
;	Does not preserve registers
;	Reads in a number of sectors from
;	the boot medium, immediately following
;	the boot sector itself
;	Loads the sectors to ES:BX
;

READ_DISK:

	mov ax, bx			; inform user of disk readx
	mov bx, DISK_LOADING_MSG
	call PRINT_FUNC
	mov bx, ax

	push dx
	mov ah, 0x02			; BIOS read sector function
	mov al, dh			; reads DH sectors
	mov ch, 0x00			; cylinder 0
	mov dh, 0x00			; head 0
	mov cl, 0x02			; sector 2

	int 0x013

	jc .disk_error			; if carry flag set, jump to error handler

	pop dx				; restore original dx
	cmp dh, al			; if sectors read != sectors requested:
	jne .disk_error			;   jump to error handler
	
	mov bx, DISK_SUCCESS_MSG
	jmp PRINT_FUNC

	ret
.disk_error:
	mov bx, DISK_ERROR_MSG		; inform user of failure
	call PRINT_FUNC
	jmp $				; Hang on error

;
;	Globals
;

PROCESS_MSG:
	db 'Currently printing a hex number...Should be 0x1fb6: ',0

DISK_LOADING_MSG:
	db 'Reading sectors from disk...',0xa,0xd,0

DISK_ERROR_MSG:
	db 'Disk read error.',0

DISK_SUCCESS_MSG:
	db 'Sectors read to memory',0xa,0xd,0

HELLO_MSG:
	db 'Salutations. Welcome to NimbOS.',0xa,0xd,0

GOODBYE_MSG:
	db 'Farewell. Until next time.',0

;
;	Magic number and padding
;

times 510-($-$$) db 0
dw 0xaa55

;
;	Added a byte of gibberish to read from
;

times 256 dw 0xabab
times 256 dw 0xcdcd
