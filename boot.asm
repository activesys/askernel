    org 07c00h
    mov ax, cs
    mov ds, ax
    mov es, ax

    mov ax, BootMessage
    mov bp, ax
    mov cx, 16
    mov ax, 01301h
    mov bx, 000ch
    mov dl, 0
    int 10h

    jmp $

BootMessage:        db "Hello, OS world!"
times 510-($-$$)    db 0

dw 0xaa55

