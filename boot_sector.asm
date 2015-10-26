[org 0x7c00]			; Tell assembler to correct the offsets

;
;	Main method
;	Prints welcome and exit messages
;

mov bx, HELLO_MSG
call PRINT_FUNC

mov bx, GOODBYE_MSG
call PRINT_FUNC

jmp $ 					; Hang

;
;	Print function
;	Takes parameters via bx
;	Returns nothing
;	Preserves registers
;

PRINT_FUNC:
	pusha
	mov ah, 0x0e		; scrolling teletype bios routine
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
;	Globals
;

HELLO_MSG:
	db 'Salutations. Welcome to NimbOS.',0

GOODBYE_MSG:
	db 'Farewell. Bntil next time',0

;
;	Magic number and padding
;

times 510-($-$$) db 0
dw 0xaa55
