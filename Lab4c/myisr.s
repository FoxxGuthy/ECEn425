resetISR:
	push 	bp
	mov 	bp, sp
	call resetISRC

tickISR:
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	push	es
	push	ds

	call 	YKEnterISR		;call before enabling interrupts again
	sti
	call	tickISRC
	cli						; Note: due to notes in midterm review, EOI call and cli order have been swapped.
							; it previously was call signalEOI THEN cli
	call	signalEOI
	call 	YKExitISR

	pop		ds
	pop		es
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	iret
	

kbISR:
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	push	es
	push	ds

	call 	YKEnterISR
	sti
	call	kbISRC
	cli
	call	signalEOI
	call	YKExitISR

	pop		ds
	pop		es
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax
	iret
