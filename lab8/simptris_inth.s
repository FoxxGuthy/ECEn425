; Generated by c86 (BYU-NASM) 5.1 (beta) from simptris_inth.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
gameOverISRC:
	; >>>>> Line:	11
	; >>>>> void gameOverISRC(void) { 
	jmp	L_simptris_inth_1
L_simptris_inth_2:
	; >>>>> Line:	12
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_simptris_inth_1:
	push	bp
	mov	bp, sp
	jmp	L_simptris_inth_2
L_simptris_inth_4:
	DB	"NP ISRC ",0xD,0xA,0
	ALIGN	2
newPieceISRC:
	; >>>>> Line:	15
	; >>>>> void newPieceISRC(void) { 
	jmp	L_simptris_inth_5
L_simptris_inth_6:
	; >>>>> Line:	16
	; >>>>> printString("NP ISRC \r\n"); 
	mov	ax, L_simptris_inth_4
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	17
	; >>>>> YKSemPost(NPSemPtr); 
	push	word [NPSemPtr]
	call	YKSemPost
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_simptris_inth_5:
	push	bp
	mov	bp, sp
	jmp	L_simptris_inth_6
	ALIGN	2
receivedCommandISRC:
	; >>>>> Line:	20
	; >>>>> void receivedCommandISRC(void) { 
	jmp	L_simptris_inth_8
L_simptris_inth_9:
	; >>>>> Line:	21
	; >>>>> YKSemPost(RCSemPtr); 
	push	word [RCSemPtr]
	call	YKSemPost
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_simptris_inth_8:
	push	bp
	mov	bp, sp
	jmp	L_simptris_inth_9
	ALIGN	2
touchdownISRC:
	; >>>>> Line:	24
	; >>>>> void touchdownISRC(void) { 
	jmp	L_simptris_inth_11
L_simptris_inth_12:
	; >>>>> Line:	26
	; >>>>> } 
	mov	sp, bp
	pop	bp
	ret
L_simptris_inth_11:
	push	bp
	mov	bp, sp
	jmp	L_simptris_inth_12
	ALIGN	2
lineclearISRC:
	; >>>>> Line:	28
	; >>>>> vo 
	jmp	L_simptris_inth_14
L_simptris_inth_15:
	; >>>>> Line:	30
	; >>>>> } 
	mov	sp, bp
	pop	bp
	ret
L_simptris_inth_14:
	push	bp
	mov	bp, sp
	jmp	L_simptris_inth_15
