resetISR:
	push 	bp
	mov 	bp, sp
	call resetISRC

tickISR:
	tickLabel:
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	bp
	push	es
	push	ds
	sti

	call	tickISRC
	call	signalEOI
	cli
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

	sti
	call	kbISRC
	call	signalEOI
	cli
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
