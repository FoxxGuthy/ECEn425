; Modify AsmFunction to perform the calculation gvar+(a*(b+c))/(d-e).
; Keep in mind the C declaration:
; int AsmFunction(int a, char b, char c, int d, int e);

	CPU	8086
	align	2

AsmFunction:

	; char is 8 bits (b, c)
	; ints are 16 bits (gvar, a, d, e)

	label1:
	push 	bp					; save bp. What does push do?
	mov 	bp, sp				; set bp for referencing stack
	
	push bx

	mov ax, 0					; clear return reg
	mov al, byte [bp + 6]		; move b
					
	add al, byte [bp + 8]		; add b + c
	cbw							; sign extend
	imul word [bp + 4]			; multiply a * (b + c)

	mov bx, word [bp + 10]		; load d into bx
	sub bx, word [bp + 12]		; subtract (d-e)

	idiv bx						; divide [a * (b + c)] / (d - e)
	add ax, [gvar]				; add gvar

	pop		bx
    pop     bp                  ; (6) restore bp
    ret 
