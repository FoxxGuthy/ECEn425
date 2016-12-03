gameOverISR:
    push 	bp
    mov 	bp, sp
    call gameOverISRC

newPeiceISR:
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
    call	newPeiceISRC
    cli
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

receivedCommandISR:
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
    call	receivedCommandISRC
    cli
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

touchdownISR:
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
    call	touchdownISRC
    cli
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

lineclearISR:
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
    call	lineclearISRC
    cli
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
