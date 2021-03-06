; nasmfunc.asm
; TAB=4

bits 32
GLOBAL	io_hlt, io_cli, io_sti, io_stihlt
GLOBAL	io_in8,  io_in16,  io_in32
GLOBAL	io_out8, io_out16, io_out32
GLOBAL	io_load_eflags, io_store_eflags
GLOBAL	load_gdtr, load_idtr
GLOBAL	asm_inthandler21, asm_inthandler27, asm_inthandler2c, asm_inthandler20, asm_inthandler0d, asm_inthandler0c
GLOBAL load_cr0, store_cr0
GLOBAL memtest_sub
GLOBAL load_tr, taskswitch4, taskswitch3,farjmp,asm_end_app
GLOBAL asm_cons_putchar, asm_hrb_api
GLOBAL farcall 
GLOBAL start_app
EXTERN	inthandler21, inthandler27, inthandler2c, inthandler20, inthandler0d, inthandler0c
EXTERN cons_putchar, hrb_api

section .text

io_hlt:
	HLT
	RET

write_mem8:
	MOV ECX, [ESP+4]
	MOV AL, [ESP+8]
	MOV [ECX], AL
	RET

io_cli:
	CLI
	RET
io_sti:
	STI
	RET
io_stihlt:
	STI
	HLT
	RET
io_in8:
	MOV EDX,[ESP+4]
	MOV EAX,0
	IN AL,DX
	RET
io_in16:
	MOV EDX,[ESP+4]
	MOV EAX,0
	IN AX,DX
	RET
io_in32:
	MOV EDX,[ESP+4]
	IN EAX,DX
	RET
io_out8:
	MOV EDX,[ESP+4]
	MOV AL,[ESP+8]
	OUT DX,AL
	RET
io_out16:
	MOV EDX,[ESP+4]
	MOV AL,[ESP+8]
	OUT DX,AX
	RET	
io_out32:
	MOV EDX,[ESP+4]
	MOV AL,[ESP+8]
	OUT DX,EAX
	RET
io_load_eflags:
	PUSHFD
	POP EAX
	RET
io_store_eflags:
	MOV EAX, [ESP+4]
	PUSH EAX
	POPFD
	RET
load_gdtr:		; void load_gdtr(int limit, int addr)
		mov		ax, [esp + 4]		; limit
		mov 	[esp + 6], ax
		lgdt	[esp + 6]
		ret

load_idtr:		; void load_idtr(int limit, int addr)
		mov		ax, [esp + 4]		; limit
		mov 	[esp + 6], ax
		lidt	[esp + 6]
		ret


asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler21
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler27
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH	EAX
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	inthandler2c
		POP		EAX
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		EAX,ESP
		PUSH EAX
		MOV AX,SS
		MOV DS,AX
		MOV ES,AX
		CALL inthandler20
		POP EAX
		POPAD
		POP DS
		POP ES
		IRETD

asm_inthandler0d:
		STI
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV EAX,ESP
		PUSH EAX
		MOV AX,SS
		MOV DS,AX
		MOV ES,AX
		CALL inthandler0d
		CMP EAX,0
		JNE end_app
		POP EAX
		POP DS
		POP ES
		ADD ESP,4
		IRETD

asm_inthandler0c:
	STI
	PUSH ES
	PUSH DS
	PUSHAD
	MOV EAX,ESP
	PUSH EAX
	MOV AX,SS
	MOV DS,AX
	MOV ES,AX
	CALL inthandler0c
	CMP EAX,0
	JNE end_app
	POP EAX
	POPAD
	POP DS
	POP ES
	ADD ESP,4
	IRETD

load_cr0: 
	MOV EAX, CR0
	RET

store_cr0: 
	MOV EAX,[ESP+4]
	MOV CR0,EAX
	RET

memtest_sub:	; unsigned int memtest_sub(unsigned int start, unsigned int end)
		PUSH	EDI						; （EBX, ESI, EDI も使いたいので）
		PUSH	ESI
		PUSH	EBX
		MOV		ESI,0xaa55aa55			; pat0 = 0xaa55aa55;
		MOV		EDI,0x55aa55aa			; pat1 = 0x55aa55aa;
		MOV		EAX,[ESP+12+4]			; i = start;
mts_loop:
		MOV		EBX,EAX
		ADD		EBX,0xffc				; p = i + 0xffc;
		MOV		EDX,[EBX]				; old = *p;
		MOV		[EBX],ESI				; *p = pat0;
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		EDI,[EBX]				; if (*p != pat1) goto fin;
		JNE		mts_fin
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		ESI,[EBX]				; if (*p != pat0) goto fin;
		JNE		mts_fin
		MOV		[EBX],EDX				; *p = old;
		ADD		EAX,0x1000				; i += 0x1000;
		CMP		EAX,[ESP+12+8]			; if (i <= end) goto mts_loop;
		JBE		mts_loop
		POP		EBX
		POP		ESI
		POP		EDI
		RET
mts_fin:
		MOV		[EBX],EDX				; *p = old;
		POP		EBX
		POP		ESI
		POP		EDI
		RET

load_tr: ;void load_tr(int tr);
	LTR [ESP+4] 
	RET

farjmp: ;void farjmp(int eip, int cs);
	JMP FAR [ESP+4] ; eip cs
	RET

; needless
taskswitch3: ; void taskswitch3(void);
	JMP 3*8:0
	RET
	
taskswitch4: ; void taskswitch4(void);
	JMP 4*8:0
	RET

asm_cons_putchar:
	STI
	PUSHAD
	PUSH 1
	AND EAX, 0xff
	PUSH EAX
	PUSH DWORD [0x0fec]
	CALL cons_putchar
	ADD ESP,12
	POPAD
	IRETD

farcall:
	CALL FAR[ESP+4]
	RET

asm_hrb_api:
	STI
	PUSH DS
	PUSH ES
		PUSHAD		; 保存のためのPUSH
		PUSHAD
		MOV AX,SS
		MOV DS,AX
		MOV ES,AX
		CALL	hrb_api
		CMP EAX,0
		JNE end_app
		ADD ESP,32
		POPAD
		POP ES
		POP ds
		IRETD		; この命令が自動でSTIしてくれる
end_app:
	MOV ESP,[EAX]
	POPAD
	RET

start_app:		; void start_app(int eip, int cs, int esp, int ds);
		PUSHAD		; 32ビットレジスタを全部保存しておく
		MOV		EAX,[ESP+36]	; アプリ用のEIP
		MOV		ECX,[ESP+40]	; アプリ用のCS
		MOV		EDX,[ESP+44]	; アプリ用のESP
		MOV		EBX,[ESP+48]	; アプリ用のDS/SS
		MOV		EBP,[ESP+52]	; tss.esp0
		MOV		[EBP],ESP		; OS用のESP
		MOV		[EBP+4],SS
		MOV		ES,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
		OR ECX,3
		OR EBX,3
		PUSH EBX
		PUSH EDX
		PUSH	ECX				; far-CALLのためにPUSH（cs）
		PUSH	EAX				; far-CALLのためにPUSH（eip）
		RETF

;	アプリが終了するとここに帰ってくる

		MOV		EAX,1*8			; OS用のDS/SS
		CLI			; また切り替えるので割り込み禁止
		MOV		ES,AX
		MOV		SS,AX
		MOV		DS,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		ESP,[0xfe4]
		STI			; 切り替え完了なので割り込み可能に戻す
		POPAD	; 保存しておいたレジスタを回復
		RET

asm_end_app:
	MOV ESP,[EAX]
	MOV DWORD [EAX+4],0
	POPAD
	RET