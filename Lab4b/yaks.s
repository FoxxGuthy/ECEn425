YKEnterMutex:
	cli				; disable interrupts

YKExitMutex:
	sti				; enable interrupts

YKDispatcher:

	push	cs		; code segment (segment to which IP refers)
	pushf	    	; push the flags
	labelDispatch:
	push	ax
	push	bx
	push	cx
	push	dx
	push	si		; source index
	push	di		; destination index
	push	bp		; base
	push	es		; extra segment
	push	ds		; data segment

	; currentTask is first parameter passed, nextTask is 2nd passed
	; each TCB has 3 ints, 2 chars, and 1 struct pointer (6 things)

	mov bx, [currentTask]		; save currentTask
	mov	[bx + 2], sp		; set sp and TCB of currentTask
		
	mov bx, [nextTask]		; save nextTask
	mov sp, [bx + 2]		; restore context of nextTask by getting sp from TB of nextTask

	pop		ds		; pop everything but ip, cs, and flags (reverse order of course)
	pop		es
	pop		bp
	pop		di
	pop		si
	pop		dx
	pop		cx
	pop		bx
	pop		ax

	iret			; start next task. iret takes care of ip, cs, and flags
