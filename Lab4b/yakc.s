; Generated by c86 (BYU-NASM) 5.1 (beta) from yakc.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
L_yakc_1:
	DB	"IN YKINITIALIZE",0
	ALIGN	2
YKInitialize:
	; >>>>> Line:	14
	; >>>>> void YKInitialize(void){ 
	jmp	L_yakc_2
L_yakc_3:
	; >>>>> Line:	17
	; >>>>> printString("IN YKINITIALIZE"); 
	mov	ax, L_yakc_1
	push	ax
	call	printString
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_yakc_2:
	push	bp
	mov	bp, sp
	jmp	L_yakc_3
	ALIGN	2
TCBArray:
	TIMES	30 db 0
