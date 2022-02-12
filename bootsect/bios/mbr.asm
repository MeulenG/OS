[BITS   16]     ;16 bit real mode
[ORG    0x7c00] ; Greeted by bios at 0x7c00

mbr_start:
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7c00

TestDiskExtention:
    mov [DRIVE], dl
    mov ah, 0x41
    mov bx, 0x55aa
    int 0x13
    jc NotSupported
    cmp bx, 0xaa55
    jne NotSupported

Printstring:
    mov ah, 0x13 ; Function code
    mov al, 1 ; Cursor gets placed at the end of the string
    mov bx, 0xd ;0xa means it will be printed in green
    xor dx, dx ; Prints message at the beginning of the screen so we set it to 0
    mov bp, Message ;Message displayed
    mov cx, MessageLen ; Copies the characters to cx
    int 0x10 ;interrupt

NotSupported:
mbr_end:
    hlt 
    jmp mbr_end

DRIVE db 0
Message: db "Disk Extention is supported"
MessageLen: equ $-Message

times (0x1be-($-$$)) db 0 ;Starts at the address 0x1be and fills it with 0'es until the end of the message/start of our code
; offsides of 0x1be is other partions

    db 80h
    db 0,2,0
    db 0f0h
    db 0ffh,0ffh,0ffh
    dd 1
    dd (20*16*63-1)
	
    times (16*3) db 0 ;mimics the boot process of a harddisk and not a floppy disk

    db 0x55
    db 0xaa

;This file cannot exceed 512 bytes else you wont have the signed Boot Signature and it will fuck everything