; Generated by c86 (BYU-NASM) 5.1 (beta) from lab8app.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
nextMsg:
	DW	0
L_lab8app_3:
	DB	"  addToQ: queue overflow! ",0xA,0
L_lab8app_2:
	DB	" DIR:",0
L_lab8app_1:
	DB	"ATQ: CMD:",0
	ALIGN	2
addToQueue:
	; >>>>> Line:	51
	; >>>>> void addToQueue(int pieceID, int cmd, int direction){ 
	jmp	L_lab8app_4
L_lab8app_5:
	; >>>>> Line:	53
	; >>>>> MsgArray[nextMsg].pieceID = pieceID; 
	mov	ax, word [nextMsg]
	mov	cx, 6
	imul	cx
	mov	si, ax
	add	si, MsgArray
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	54
	; >>>>> MsgArray[nextMsg].cmd = cmd; 
	mov	ax, word [nextMsg]
	mov	cx, 6
	imul	cx
	add	ax, MsgArray
	mov	si, ax
	add	si, 2
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	55
	; >>>>> MsgArray[nextMsg].direction = direction; 
	mov	ax, word [nextMsg]
	mov	cx, 6
	imul	cx
	add	ax, MsgArray
	mov	si, ax
	add	si, 4
	mov	ax, word [bp+8]
	mov	word [si], ax
	; >>>>> Line:	56
	; >>>>> printString("ATQ: CMD:"); 
	mov	ax, L_lab8app_1
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	57
	; >>>>> printInt(cmd); 
	push	word [bp+6]
	call	printInt
	add	sp, 2
	; >>>>> Line:	58
	; >>>>> printString(" DIR:"); 
	mov	ax, L_lab8app_2
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	59
	; >>>>> printInt(direction); 
	push	word [bp+8]
	call	printInt
	add	sp, 2
	; >>>>> Line:	60
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	62
	; >>>>> if (YKQPost(MsgQPtr, (void *) &(MsgArray[nextMsg])) == 0) 
	mov	ax, word [nextMsg]
	mov	cx, 6
	imul	cx
	add	ax, MsgArray
	push	ax
	push	word [MsgQPtr]
	call	YKQPost
	add	sp, 4
	test	ax, ax
	jne	L_lab8app_6
	; >>>>> Line:	63
	; >>>>> printString("  addToQ: queue overflow! \n"); 
	mov	ax, L_lab8app_3
	push	ax
	call	printString
	add	sp, 2
	jmp	L_lab8app_7
L_lab8app_6:
	; >>>>> Line:	64
	; >>>>> else if (++nextMsg >= 20) 
	mov	ax, word [nextMsg]
	inc	ax
	mov	word [nextMsg], ax
	cmp	ax, 20
	jl	L_lab8app_8
	; >>>>> Line:	65
	; >>>>> nextMsg = 0; 
	mov	word [nextMsg], 0
L_lab8app_8:
L_lab8app_7:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_4:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_5
	ALIGN	2
setOrientation:
	; >>>>> Line:	69
	; >>>>> void setOrientation(int Orientation){ 
	jmp	L_lab8app_10
L_lab8app_11:
	; >>>>> Line:	72
	; >>>>> switch(dif) { 
	mov	ax, word [NewPieceOrientation]
	sub	ax, word [bp+4]
	mov	word [bp-2], ax
	; >>>>> Line:	72
	; >>>>> switch(dif) { 
	mov	ax, word [bp-2]
	sub	ax, -3
	je	L_lab8app_14
	dec	ax
	je	L_lab8app_15
	dec	ax
	je	L_lab8app_16
	dec	ax
	je	L_lab8app_17
	dec	ax
	je	L_lab8app_18
	dec	ax
	je	L_lab8app_19
	dec	ax
	je	L_lab8app_20
	jmp	L_lab8app_13
L_lab8app_14:
	; >>>>> Line:	74
	; >>>>> addToQueue(NewPieceID, 1, 1); 
	mov	ax, 1
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	75
	; >>>>> break; 
	jmp	L_lab8app_12
L_lab8app_15:
	; >>>>> Line:	77
	; >>>>> addToQueue(NewPieceID, 1, 0); 
	xor	ax, ax
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	78
	; >>>>> addToQueue(NewPieceID, 1, 0); 
	xor	ax, ax
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	79
	; >>>>> break; 
	jmp	L_lab8app_12
L_lab8app_16:
	; >>>>> Line:	81
	; >>>>> addToQueue(NewPieceID, 1, 0); 
	xor	ax, ax
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	82
	; >>>>> break; 
	jmp	L_lab8app_12
L_lab8app_17:
	; >>>>> Line:	84
	; >>>>> break; 
	jmp	L_lab8app_12
L_lab8app_18:
	; >>>>> Line:	86
	; >>>>> addToQueue(NewPieceID, 1, 1); 
	mov	ax, 1
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	87
	; >>>>> break; 
	jmp	L_lab8app_12
L_lab8app_19:
	; >>>>> Line:	89
	; >>>>> addToQueue(NewPieceID, 1, 1); 
	mov	ax, 1
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	90
	; >>>>> addToQueue(NewPieceID, 1, 1); 
	mov	ax, 1
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
	; >>>>> Line:	91
	; >>>>> break; 
	jmp	L_lab8app_12
L_lab8app_20:
	; >>>>> Line:	93
	; >>>>> addToQueue(NewPieceID, 1, 0); 
	xor	ax, ax
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
L_lab8app_13:
L_lab8app_12:
	; >>>>> Line:	94
	; >>>>> break; 
L_lab8app_21:
	; >>>>> Line:	99
	; >>>>> return ; 
	mov	sp, bp
	pop	bp
	ret
L_lab8app_10:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_lab8app_11
	ALIGN	2
setColumn:
	; >>>>> Line:	102
	; >>>>> void setColumn(int Column){ 
	jmp	L_lab8app_23
L_lab8app_24:
	; >>>>> Line:	105
	; >>>>> if(NewPieceColumn > Column){ 
	mov	word [bp-2], 0
	; >>>>> Line:	105
	; >>>>> if(NewPieceColumn > Column){ 
	mov	ax, word [NewPieceColumn]
	cmp	ax, word [bp+4]
	jbe	L_lab8app_25
	; >>>>> Line:	106
	; >>>>> dif = NewPieceColumn - Column; 
	mov	ax, word [NewPieceColumn]
	sub	ax, word [bp+4]
	mov	word [bp-4], ax
	; >>>>> Line:	107
	; >>>>> for(i=0;i<dif;i++){ 
	mov	word [bp-2], 0
	jmp	L_lab8app_27
L_lab8app_26:
	; >>>>> Line:	108
	; >>>>> addToQueue(NewPieceID, 0, 0); 
	xor	ax, ax
	push	ax
	xor	ax, ax
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
L_lab8app_29:
	inc	word [bp-2]
L_lab8app_27:
	mov	ax, word [bp-4]
	cmp	ax, word [bp-2]
	jg	L_lab8app_26
L_lab8app_28:
	jmp	L_lab8app_30
L_lab8app_25:
	; >>>>> Line:	110
	; >>>>> }else if(NewPieceColumn < Column){ 
	mov	ax, word [NewPieceColumn]
	cmp	ax, word [bp+4]
	jae	L_lab8app_31
	; >>>>> Line:	111
	; >>>>> dif = Column - NewPieceColumn; 
	mov	ax, word [bp+4]
	sub	ax, word [NewPieceColumn]
	mov	word [bp-4], ax
	; >>>>> Line:	112
	; >>>>> for(i=0;i<dif;i++){ 
	mov	word [bp-2], 0
	jmp	L_lab8app_33
L_lab8app_32:
	; >>>>> Line:	113
	; >>>>> addToQueue(NewPieceID, 0, 1); 
	mov	ax, 1
	push	ax
	xor	ax, ax
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
L_lab8app_35:
	inc	word [bp-2]
L_lab8app_33:
	mov	ax, word [bp-4]
	cmp	ax, word [bp-2]
	jg	L_lab8app_32
L_lab8app_34:
L_lab8app_31:
L_lab8app_30:
L_lab8app_36:
	; >>>>> Line:	118
	; >>>>> return ; 
	mov	sp, bp
	pop	bp
	ret
L_lab8app_23:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_lab8app_24
L_lab8app_39:
	DB	" D: ",0
L_lab8app_38:
	DB	"C: ",0
	ALIGN	2
SimpCommTask:
	; >>>>> Line:	122
	; >>>>> { 
	jmp	L_lab8app_40
L_lab8app_41:
	; >>>>> Line:	124
	; >>>>> while (1) 
	jmp	L_lab8app_43
L_lab8app_42:
	; >>>>> Line:	126
	; >>>>> YKSemPend(RCSemPtr); 
	push	word [RCSemPtr]
	call	YKSemPend
	add	sp, 2
	; >>>>> Line:	127
	; >>>>> tmp = (struct msg *) YKQPend(MsgQPtr); 
	push	word [MsgQPtr]
	call	YKQPend
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	128
	; >>>>> printString("C:  
	mov	ax, L_lab8app_38
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	129
	; >>>>> printInt(tmp->cmd); 
	mov	si, word [bp-2]
	add	si, 2
	push	word [si]
	call	printInt
	add	sp, 2
	; >>>>> Line:	130
	; >>>>> printString(" D: "); 
	mov	ax, L_lab8app_39
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	131
	; >>>>> printInt(tmp->direction); 
	mov	si, word [bp-2]
	add	si, 4
	push	word [si]
	call	printInt
	add	sp, 2
	; >>>>> Line:	132
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	133
	; >>>>> if(tmp->cmd == 0){ 
	mov	si, word [bp-2]
	add	si, 2
	mov	ax, word [si]
	test	ax, ax
	jne	L_lab8app_45
	; >>>>> Line:	134
	; >>>>> SlidePiece(tmp->pieceID, tmp->direction); 
	mov	si, word [bp-2]
	add	si, 4
	push	word [si]
	mov	si, word [bp-2]
	push	word [si]
	call	SlidePiece
	add	sp, 4
	jmp	L_lab8app_46
L_lab8app_45:
	; >>>>> Line:	136
	; >>>>> RotatePiece(tmp->pieceID, tmp->direction); 
	mov	si, word [bp-2]
	add	si, 4
	push	word [si]
	mov	si, word [bp-2]
	push	word [si]
	call	RotatePiece
	add	sp, 4
L_lab8app_46:
L_lab8app_43:
	jmp	L_lab8app_42
L_lab8app_44:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_40:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_lab8app_41
	ALIGN	2
getFirstOne:
	; >>>>> Line:	141
	; >>>>> int getFirstOne(int column){ 
	jmp	L_lab8app_48
L_lab8app_49:
	; >>>>> Line:	145
	; >>>>> for(i=15;i>=0;i--){ 
	mov	word [bp-4], 1
	; >>>>> Line:	145
	; >>>>> for(i=15;i>=0;i--){ 
	mov	word [bp-2], 15
	jmp	L_lab8app_51
L_lab8app_50:
	; >>>>> Line:	146
	; >>>>> if((tmp & column)==tmp){ 
	mov	ax, word [bp-4]
	and	ax, word [bp+4]
	mov	dx, word [bp-4]
	cmp	dx, ax
	jne	L_lab8app_54
	; >>>>> Line:	147
	; >>>>> return i+1; 
	mov	ax, word [bp-2]
	inc	ax
	jmp	L_lab8app_55
	jmp	L_lab8app_56
L_lab8app_54:
	; >>>>> Line:	149
	; >>>>> tmp = tmp<<1; 
	mov	ax, word [bp-4]
	shl	ax, 1
	mov	word [bp-4], ax
L_lab8app_56:
L_lab8app_53:
	dec	word [bp-2]
L_lab8app_51:
	cmp	word [bp-2], 0
	jge	L_lab8app_50
L_lab8app_52:
	; >>>>> Line:	152
	; >>>>> return i+1; 
	mov	ax, word [bp-2]
	inc	ax
L_lab8app_55:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_48:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_lab8app_49
L_lab8app_60:
	DB	" B1:",0
L_lab8app_59:
	DB	"B0:",0
L_lab8app_58:
	DB	"NP NPTSK ",0xD,0xA,0
	ALIGN	2
NewPieceTask:
	; >>>>> Line:	156
	; >>>>> { 
	jmp	L_lab8app_61
L_lab8app_62:
	; >>>>> Line:	166
	; >>>>> while(1){ 
	mov	byte [bp-13], 0
	mov	byte [bp-14], 0
	; >>>>> Line:	166
	; >>>>> while(1){ 
	jmp	L_lab8app_64
L_lab8app_63:
	; >>>>> Line:	167
	; >>>>> YKSemPend(NPSemPtr); 
	push	word [NPSemPtr]
	call	YKSemPend
	add	sp, 2
	; >>>>> Line:	168
	; >>>>> printString("NP NPTSK \r\n"); 
	mov	ax, L_lab8app_58
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	169
	; >>>>> col0Level = getFirstOne(ScreenBitMap0); 
	push	word [ScreenBitMap0]
	call	getFirstOne
	add	sp, 2
	mov	word [bp-2], ax
	; >>>>> Line:	170
	; >>>>> col1Level = getFirstOne(ScreenBitMap1); 
	push	word [ScreenBitMap1]
	call	getFirstOne
	add	sp, 2
	mov	word [bp-4], ax
	; >>>>> Line:	171
	; >>>>> col2Level = getFirstOne(ScreenBitMap2); 
	push	word [ScreenBitMap2]
	call	getFirstOne
	add	sp, 2
	mov	word [bp-6], ax
	; >>>>> Line:	172
	; >>>>> col3Level = getFirstOne(ScreenBitMap3); 
	push	word [ScreenBitMap3]
	call	getFirstOne
	add	sp, 2
	mov	word [bp-8], ax
	; >>>>> Line:	173
	; >>>>> col4Level = getFirstOne(ScreenBitMap4); 
	push	word [ScreenBitMap4]
	call	getFirstOne
	add	sp, 2
	mov	word [bp-10], ax
	; >>>>> Line:	174
	; >>>>> col5Level = getFirstOne(ScreenBitMap5); 
	push	word [ScreenBitMap5]
	call	getFirstOne
	add	sp, 2
	mov	word [bp-12], ax
	; >>>>> Line:	175
	; >>>>> printInt(col0Level); 
	push	word [bp-2]
	call	printInt
	add	sp, 2
	; >>>>> Line:	176
	; >>>>> printInt(col1Level); 
	push	word [bp-4]
	call	printInt
	add	sp, 2
	; >>>>> Line:	177
	; >>>>> printInt(col2Level); 
	push	word [bp-6]
	call	printInt
	add	sp, 2
	; >>>>> Line:	178
	; >>>>> printInt(col3Level); 
	push	word [bp-8]
	call	printInt
	add	sp, 2
	; >>>>> Line:	179
	; >>>>> pr 
	push	word [bp-10]
	call	printInt
	add	sp, 2
	; >>>>> Line:	180
	; >>>>> printInt(col5Level); 
	push	word [bp-12]
	call	printInt
	add	sp, 2
	; >>>>> Line:	181
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	182
	; >>>>> if((col0Level == col1Level) && (col1Level==col2Level)){ 
	mov	ax, word [bp-4]
	cmp	ax, word [bp-2]
	jne	L_lab8app_66
	mov	ax, word [bp-6]
	cmp	ax, word [bp-4]
	jne	L_lab8app_66
	; >>>>> Line:	183
	; >>>>> bin0 = 0; 
	mov	byte [bp-13], 0
	jmp	L_lab8app_67
L_lab8app_66:
	; >>>>> Line:	185
	; >>>>> bin0 = 1; 
	mov	byte [bp-13], 1
L_lab8app_67:
	; >>>>> Line:	187
	; >>>>> if((col3Level == col4Level) && (col4Level==col5Level)){ 
	mov	ax, word [bp-10]
	cmp	ax, word [bp-8]
	jne	L_lab8app_68
	mov	ax, word [bp-12]
	cmp	ax, word [bp-10]
	jne	L_lab8app_68
	; >>>>> Line:	188
	; >>>>> bin1 = 0; 
	mov	byte [bp-14], 0
	jmp	L_lab8app_69
L_lab8app_68:
	; >>>>> Line:	190
	; >>>>> bin1 = 1; 
	mov	byte [bp-14], 1
L_lab8app_69:
	; >>>>> Line:	192
	; >>>>> printString("B0:"); 
	mov	ax, L_lab8app_59
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	193
	; >>>>> printInt(bin0); 
	mov	al, byte [bp-13]
	cbw
	push	ax
	call	printInt
	add	sp, 2
	; >>>>> Line:	194
	; >>>>> printString(" B1:"); 
	mov	ax, L_lab8app_60
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	195
	; >>>>> printInt(bin1); 
	mov	al, byte [bp-14]
	cbw
	push	ax
	call	printInt
	add	sp, 2
	; >>>>> Line:	196
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	199
	; >>>>> if(NewPieceColumn==0){ 
	mov	ax, word [NewPieceColumn]
	test	ax, ax
	jne	L_lab8app_70
	; >>>>> Line:	200
	; >>>>> setColumn(1); 
	mov	ax, 1
	push	ax
	call	setColumn
	add	sp, 2
	jmp	L_lab8app_71
L_lab8app_70:
	; >>>>> Line:	201
	; >>>>> }else if(NewPieceColumn==5){ 
	cmp	word [NewPieceColumn], 5
	jne	L_lab8app_72
	; >>>>> Line:	202
	; >>>>> setColumn(4); 
	mov	ax, 4
	push	ax
	call	setColumn
	add	sp, 2
L_lab8app_72:
L_lab8app_71:
	; >>>>> Line:	205
	; >>>>> if(NewPi 
	cmp	word [NewPieceType], 1
	jne	L_lab8app_73
	; >>>>> Line:	207
	; >>>>> if(NewPieceOrientation==1){ 
	cmp	word [NewPieceOrientation], 1
	jne	L_lab8app_74
	; >>>>> Line:	208
	; >>>>> addToQueue(NewPieceID, 1, 1); 
	mov	ax, 1
	push	ax
	mov	ax, 1
	push	ax
	push	word [NewPieceID]
	call	addToQueue
	add	sp, 6
L_lab8app_74:
	; >>>>> Line:	210
	; >>>>> if(bin0==0){ 
	mov	al, byte [bp-13]
	test	al, al
	jne	L_lab8app_75
	; >>>>> Line:	211
	; >>>>> setColumn(1); 
	mov	ax, 1
	push	ax
	call	setColumn
	add	sp, 2
L_lab8app_75:
	; >>>>> Line:	213
	; >>>>> if(bin1==0){ 
	mov	al, byte [bp-14]
	test	al, al
	jne	L_lab8app_76
	; >>>>> Line:	214
	; >>>>> setColumn(4); 
	mov	ax, 4
	push	ax
	call	setColumn
	add	sp, 2
L_lab8app_76:
	jmp	L_lab8app_77
L_lab8app_73:
	; >>>>> Line:	219
	; >>>>> if((bin0==0) && (bin1==0)){ 
	mov	al, byte [bp-13]
	test	al, al
	jne	L_lab8app_78
	mov	al, byte [bp-14]
	test	al, al
	jne	L_lab8app_78
	; >>>>> Line:	220
	; >>>>> if(col0Level < col5Level){ 
	mov	ax, word [bp-12]
	cmp	ax, word [bp-2]
	jle	L_lab8app_79
	; >>>>> Line:	221
	; >>>>> setOrientation(0); 
	xor	ax, ax
	push	ax
	call	setOrientation
	add	sp, 2
	; >>>>> Line:	222
	; >>>>> setColumn(0); 
	xor	ax, ax
	push	ax
	call	setColumn
	add	sp, 2
	jmp	L_lab8app_80
L_lab8app_79:
	; >>>>> Line:	224
	; >>>>> setOrientation(1); 
	mov	ax, 1
	push	ax
	call	setOrientation
	add	sp, 2
	; >>>>> Line:	225
	; >>>>> setColumn(5); 
	mov	ax, 5
	push	ax
	call	setColumn
	add	sp, 2
L_lab8app_80:
L_lab8app_78:
	; >>>>> Line:	228
	; >>>>> if(bin0 != 0){ 
	mov	al, byte [bp-13]
	test	al, al
	je	L_lab8app_81
	; >>>>> Line:	229
	; >>>>> setOrientation(2); 
	mov	ax, 2
	push	ax
	call	setOrientation
	add	sp, 2
	; >>>>> Line:	230
	; >>>>> setColumn(1); 
	mov	ax, 1
	push	ax
	call	setColumn
	add	sp, 2
	jmp	L_lab8app_82
L_lab8app_81:
	; >>>>> Line:	232
	; >>>>> leCount = YKIdleCou 
	mov	ax, 3
	push	ax
	call	setOrientation
	add	sp, 2
	; >>>>> Line:	233
	; >>>>> setColumn(4); 
	mov	ax, 4
	push	ax
	call	setColumn
	add	sp, 2
L_lab8app_82:
L_lab8app_77:
L_lab8app_64:
	jmp	L_lab8app_63
L_lab8app_65:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_61:
	push	bp
	mov	bp, sp
	sub	sp, 14
	jmp	L_lab8app_62
L_lab8app_86:
	DB	"% >",0xD,0xA,0
L_lab8app_85:
	DB	", CPU: ",0
L_lab8app_84:
	DB	"<CS: ",0
	ALIGN	2
StatsTask:
	; >>>>> Line:	240
	; >>>>> { 
	jmp	L_lab8app_87
L_lab8app_88:
	; >>>>> Line:	244
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	245
	; >>>>> YKDelayTask(5); 
	mov	ax, 5
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	246
	; >>>>> max = YKIdleCount / 25; 
	mov	ax, word [YKIdleCount]
	cwd
	mov	cx, 25
	idiv	cx
	mov	word [bp-2], ax
	; >>>>> Line:	248
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	250
	; >>>>> YKNewTask(SimpCommTask, (void *) &SimpCommTaskStk[512], 30); 
	mov	al, 30
	push	ax
	mov	ax, (SimpCommTaskStk+1024)
	push	ax
	mov	ax, SimpCommTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	251
	; >>>>> YKNewTask(NewPieceTask, (void *) &NewPieceTaskStk[512], 10); 
	mov	al, 10
	push	ax
	mov	ax, (NewPieceTaskStk+1024)
	push	ax
	mov	ax, NewPieceTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	252
	; >>>>> StartSimptris(); 
	call	StartSimptris
	; >>>>> Line:	254
	; >>>>> while (1) 
	jmp	L_lab8app_90
L_lab8app_89:
	; >>>>> Line:	256
	; >>>>> YKDelayTask(20); 
	mov	ax, 20
	push	ax
	call	YKDelayTask
	add	sp, 2
	; >>>>> Line:	258
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	259
	; >>>>> switchCount = YKCtxSwCount; 
	mov	ax, word [YKCtxSwCount]
	mov	word [bp-4], ax
	; >>>>> Line:	260
	; >>>>> idleCount = YKIdleCou 
	mov	ax, word [YKIdleCount]
	mov	word [bp-6], ax
	; >>>>> Line:	261
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	263
	; >>>>> printString("<CS: "); 
	mov	ax, L_lab8app_84
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	264
	; >>>>> printInt((int)switchCount); 
	push	word [bp-4]
	call	printInt
	add	sp, 2
	; >>>>> Line:	265
	; >>>>> printString(", CPU: "); 
	mov	ax, L_lab8app_85
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	266
	; >>>>> tmp = (int) (idleCount/max); 
	mov	ax, word [bp-6]
	xor	dx, dx
	div	word [bp-2]
	mov	word [bp-8], ax
	; >>>>> Line:	267
	; >>>>> printInt(100-tmp); 
	mov	ax, 100
	sub	ax, word [bp-8]
	push	ax
	call	printInt
	add	sp, 2
	; >>>>> Line:	268
	; >>>>> printString("% >\r\n"); 
	mov	ax, L_lab8app_86
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	270
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	271
	; >>>>> YKCtxSwCount = 0; 
	mov	word [YKCtxSwCount], 0
	; >>>>> Line:	272
	; >>>>> YKIdleCount = 0; 
	mov	word [YKIdleCount], 0
	; >>>>> Line:	273
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
L_lab8app_90:
	jmp	L_lab8app_89
L_lab8app_91:
	mov	sp, bp
	pop	bp
	ret
L_lab8app_87:
	push	bp
	mov	bp, sp
	sub	sp, 8
	jmp	L_lab8app_88
	ALIGN	2
main:
	; >>>>> Line:	279
	; >>>>> { 
	jmp	L_lab8app_93
L_lab8app_94:
	; >>>>> Line:	280
	; >>>>> YKInitialize(); 
	call	YKInitialize
	; >>>>> Line:	282
	; >>>>> MsgQPtr = YKQCreate(MsgQ, 10); 
	mov	ax, 10
	push	ax
	mov	ax, MsgQ
	push	ax
	call	YKQCreate
	add	sp, 4
	mov	word [MsgQPtr], ax
	; >>>>> Line:	284
	; >>>>> YKNewTask(StatsTask, (void *) &StatsTaskStk[512], 50); 
	mov	al, 50
	push	ax
	mov	ax, (StatsTaskStk+1024)
	push	ax
	mov	ax, StatsTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	286
	; >>>>> SeedSimptris(10947); 
	mov	ax, 10947
	xor	dx, dx
	push	dx
	push	ax
	call	SeedSimptris
	add	sp, 4
	; >>>>> Line:	288
	; >>>>> NPSemPtr = YKSemCreate(0); 
	xor	ax, ax
	push	ax
	call	YKSemCreate
	add	sp, 2
	mov	word [NPSemPtr], ax
	; >>>>> Line:	289
	; >>>>> RCSemPtr = YKSemCreate(1); 
	mov	ax, 1
	push	ax
	call	YKSemCreate
	add	sp, 2
	mov	word [RCSemPtr], ax
	; >>>>> Line:	291
	; >>>>> YKRun(); 
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_lab8app_93:
	push	bp
	mov	bp, sp
	jmp	L_lab8app_94
	ALIGN	2
MsgArray:
	TIMES	120 db 0
SimpCommTaskStk:
	TIMES	1024 db 0
NewPieceTaskStk:
	TIMES	1024 db 0
StatsTaskStk:
	TIMES	1024 db 0
MsgQ:
	TIMES	20 db 0
MsgQPtr:
	TIMES	2 db 0
RCSemPtr:
	TIMES	2 db 0
NPSemPtr:
	TIMES	2 db 0
