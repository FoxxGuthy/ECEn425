resetISR:
	push	bp
	mov		bp, sp

	call resetHandler

	; pop		bx
	; pop 	bp
	; iret
	
tickISR:
	push 	ax
	push 	bx
	push	cx
	push	dx
	push 	si
	push	di
	push	bp
	push	es
	push	ds

	sti		; allow interrupts

	call tickHandler
	call signalEOI ; signal that the interrupt is done

	cli		; dis allow interrupts
		
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
	push 	ax
	push 	bx
	push	cx
	push	dx
	push 	si
	push	di
	push	bp
	push	es
	push	ds

	sti		; allow interrupts 

	call kbHandler
	call signalEOI ; signal that the interrupt is done

	cli		; dis allow interrupts

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
