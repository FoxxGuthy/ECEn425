YKEnterMutex:
	cli				; disable interrupts

YKExitMutex:
	sti				; enable interrupts

YKDispatcher:

	;push	ip		; instruction pointer ; these 3 need to go first
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

	mov	[currentTask + 4], sp		; set sp and ip in TCB of currentTask
	;mov [currentTask + 6], ip		;
		
	mov sp, [nextTask + 4]		; restore context of nextTask by getting sp from TB of nextTask

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
