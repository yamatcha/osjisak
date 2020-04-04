; nasmfunc.asm
; TAB=4

bits 32
GLOBAL	io_hlt, io_cli, io_sti, io_stihlt
GLOBAL	io_in8,  io_in16,  io_in32
GLOBAL	io_out8, io_out16, io_out32
GLOBAL	io_load_eflags, io_store_eflags
GLOBAL	load_gdtr, load_idtr
GLOBAL	asm_inthandler21, asm_inthandler27, asm_inthandler2c, asm_inthandler20
GLOBAL load_cr0, store_cr0
GLOBAL memtest_sub
GLOBAL load_tr, taskswitch4, taskswitch3,farjmp
GLOBAL asm_cons_putchar, asm_hrb_api
GLOBAL farcall 
GLOBAL start_app
EXTERN	inthandler21, inthandler27, inthandler2c, inthandler20
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
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
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
.from_app:
;	アプリが動いているときに割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX			; とりあえずDSだけOS用にする
		MOV		ECX,[0xfe4]		; OSのESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; 割り込まれたときのSSを保存
		MOV		[ECX  ],ESP		; 割り込まれたときのESPを保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler21
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SSをアプリ用に戻す
		MOV		ESP,ECX			; ESPもアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
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
.from_app:
;	アプリが動いているときに割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX			; とりあえずDSだけOS用にする
		MOV		ECX,[0xfe4]		; OSのESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; 割り込まれたときのSSを保存
		MOV		[ECX  ],ESP		; 割り込まれたときのESPを保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler27
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SSをアプリ用に戻す
		MOV		ESP,ECX			; ESPもアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
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
.from_app:
;	アプリが動いているときに割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX			; とりあえずDSだけOS用にする
		MOV		ECX,[0xfe4]		; OSのESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; 割り込まれたときのSSを保存
		MOV		[ECX  ],ESP		; 割り込まれたときのESPを保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler2c
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SSをアプリ用に戻す
		MOV		ESP,ECX			; ESPもアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
	MOV EAX, ESP
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
.from_app:
;	アプリが動いているときに割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX			; とりあえずDSだけOS用にする
		MOV		ECX,[0xfe4]		; OSのESP
		ADD		ECX,-8
		MOV		[ECX+4],SS		; 割り込まれたときのSSを保存
		MOV		[ECX  ],ESP		; 割り込まれたときのESPを保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	inthandler20
		POP		ECX
		POP		EAX
		MOV		SS,AX			; SSをアプリ用に戻す
		MOV		ESP,ECX			; ESPもアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
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
		MOV		EAX,1*8
		MOV		DS,AX			; とりあえずDSだけOS用にする
		MOV		ECX,[0xfe4]		; OSのESP
		ADD		ECX,-40
		MOV		[ECX+32],ESP	; アプリのESPを保存
		MOV		[ECX+36],SS		; アプリのSSを保存

; PUSHADした値をシステムのスタックにコピーする
		MOV		EDX,[ESP   ]
		MOV		EBX,[ESP+ 4]
		MOV		[ECX   ],EDX	; hrb_apiに渡すためコピー
		MOV		[ECX+ 4],EBX	; hrb_apiに渡すためコピー
		MOV		EDX,[ESP+ 8]
		MOV		EBX,[ESP+12]
		MOV		[ECX+ 8],EDX	; hrb_apiに渡すためコピー
		MOV		[ECX+12],EBX	; hrb_apiに渡すためコピー
		MOV		EDX,[ESP+16]
		MOV		EBX,[ESP+20]
		MOV		[ECX+16],EDX	; hrb_apiに渡すためコピー
		MOV		[ECX+20],EBX	; hrb_apiに渡すためコピー
		MOV		EDX,[ESP+24]
		MOV		EBX,[ESP+28]
		MOV		[ECX+24],EDX	; hrb_apiに渡すためコピー
		MOV		[ECX+28],EBX	; hrb_apiに渡すためコピー

		MOV		ES,AX			; 残りのセグメントレジスタもOS用にする
		MOV		SS,AX
		MOV		ESP,ECX
		STI			; やっと割り込み許可

		CALL	hrb_api

		MOV		ECX,[ESP+32]	; アプリのESPを思い出す
		MOV		EAX,[ESP+36]	; アプリのSSを思い出す
		CLI
		MOV		SS,AX
		MOV		ESP,ECX
		POPAD
		POP		ES
		POP		DS
		IRETD		; この命令が自動でSTIしてくれる

start_app:		; void start_app(int eip, int cs, int esp, int ds);
		PUSHAD		; 32ビットレジスタを全部保存しておく
		MOV		EAX,[ESP+36]	; アプリ用のEIP
		MOV		ECX,[ESP+40]	; アプリ用のCS
		MOV		EDX,[ESP+44]	; アプリ用のESP
		MOV		EBX,[ESP+48]	; アプリ用のDS/SS
		MOV		[0xfe4],ESP		; OS用のESP
		CLI			; 切り替え中に割り込みが起きてほしくないので禁止
		MOV		ES,BX
		MOV		SS,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
		MOV		ESP,EDX
		STI			; 切り替え完了なので割り込み可能に戻す
		PUSH	ECX				; far-CALLのためにPUSH（cs）
		PUSH	EAX				; far-CALLのためにPUSH（eip）
		CALL	FAR [ESP]		; アプリを呼び出す

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