;
;   Print function
;   Expects bx to point to a null-terminated string
;   Prints the string to the console
;

print:
    push ax
    push bx
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
    pop bx
    pop ax
    ret

;
; Calls print, appends newline
;

println:
    call print
    push bx
    mov bx, NWLN
    call print
    pop bx
    ret


;	PrintHex function
;	Prints out the hexidecimal number
;	stored in the dx register
;

print_hex:
	pusha				; setup registers
	mov ax, 0xf000
	mov cl, 12
	mov bx, HEX_VALUE
	add bx, 2
.adjust_hex_value:
	push dx				; save original value for later use
	and dx, ax			; isolate four appropriate bits
	shr dx, cl
	cmp dx, 0xa
	jl .was_just_digit
	add dx, 39			; some number voodoo for ascii
.was_just_digit:
	add [bx], dx		; edit character the bytes in bx represent
	shr ax, 4			; increment to next bits
	sub cl, 4
	add bx, 1
	pop dx
	test ax, ax
	jne .adjust_hex_value
	mov bx, HEX_VALUE
	call print
    add bx, 2
.zero_out_hex_value:
	mov byte [bx], '0'
	inc bx
    mov al, [bx]
    test al, al
    jnz .zero_out_hex_value
	popa
	ret

;
;   PrintHex Newline function
;   Prints hexadecimal number, followed by newline
;

print_hexln:
    push dx
    call print_hex
    mov bx, NWLN
    call print
    pop dx
    ret

NWLN:
    db 0xa,0xd,0

HEX_VALUE:
	db '0x0000',0
