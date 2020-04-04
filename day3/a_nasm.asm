GLOBAL api_putchar
GLOBAL api_end
GLOBAL api_putstr0

SECTION .text

api_putchar:
    MOV EDX,1
    MOV AL,[ESP+4]
    INT 0x40
    RET

api_end:
    MOV EDX,4
    INT 0x40

api_putstr0:
    PUSH EBX
    MOV EDX,2
    MOV EBX,[ESP+8]
    INT 0x40
    POP EBX
    RET