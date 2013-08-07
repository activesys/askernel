.code16
.section .text
.globl _int0x80
.type _int0x80, @function
_int0x80:
    movw $int0x80_msg, %si
    movw $int0x80_msg_length, %cx
    call _int_echo

    iret

.type _int_echo, @function
_int_echo:
    movb $0x0e, %ah
_do_echo:
    lodsb
    int $0x10
    loop _do_echo

    movb $0x0e, %ah
    movb $0x0d, %al
    int $0x10
    movb $0x0a, %al
    int $0x10
    ret

int0x80_msg:
    .ascii "In interrupt 0x80 handler."
int0x80_msg_end:
    .equ int0x80_msg_length, int0x80_msg_end - int0x80_msg

dummy:
    .space 512-(.-_int0x80), 0x00
