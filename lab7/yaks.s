YKEnterMutex:
	cli				; disable interrupts
	ret

YKExitMutex:
	sti				; enable interrupts
	ret

YKsavecontext:
	pushf	    	; push the flags
	push	cs		; code segment (segment to which IP refers)
	; PUSH THE INSTRUCTION POINTER
	push word [bp+2]
	labelSaveCtx:
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

	mov bx, [taskSaveCTX]		; save currentTask
	mov	[bx], sp		; set sp and TCB of currentTask
	jmp YKrestorecontext

YKDispatcher:
	labelDispatcher:
	push 	bp					
	mov 	bp, sp
	push 	ax
	mov 	ax, word [bp+4]
	cmp		al, 1 ;Not sure why it cannot move the whole register over... simple fix for now
	pop 	ax
	je 		YKsavecontext

YKrestorecontext:
	mov bx, [nextTask]		; save nextTask
	mov sp, [bx]		; restore context of nextTask by getting sp from TB of nextTask

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
