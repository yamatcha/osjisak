; nasmfunc.asm
; TAB=4

bits 32
global io_hlt
global write_mem8
global io_cli
global io_sti
global io_stihlt
global io_in8
global io_in16
global io_in32
global io_out8
global io_out16
global io_out32
global io_load_eflags
global io_store_eflags
global load_gdtr
global load_idtr

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