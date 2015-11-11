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
;	Globals
;

PROCESS_MSG:
	db 'Currently printing a hex number...Should be 0x1fb6: ',0

HELLO_MSG:
	db 'Salutations. Welcome to NimbOS.',0xa,0xd,0

GOODBYE_MSG:
	db 'Farewell. Until next time',0

;
;	Magic number and padding
;

times 510-($-$$) db 0
dw 0xaa55
