.code16
.section .text
.globl _int0x80
.type _int0x80, @function
_int0x80:
    movw $int0x80_msg, %si
    movw $int0x80_msg_length, %cx
    call _echo

    iret

dummy1:
    .space 0x20-(.-_int0x80), 0x00

.globl _int0x90
.type _int0x90, @function
_int0x90:
    movw $int0x90_msg, %si
    movw $int0x90_msg_length, %cx
    call _echo

    iret

dummy2:
    .space 0x40-(.-_int0x80), 0x00

.globl _int0xff
.type _int0xff, @function
_int0xff:
    movw $int0xff_msg, %si
    movw $int0xff_msg_length, %cx
    call _echo

    iret

dummy3:
    .space 0x60-(.-_int0x80), 0x00

.globl _gp_handler
.type _gp_handler, @function
_gp_handler:
    movw $gp_msg, %si
    movw $gp_msg_length, %cx
    call _echo

    iret

.include "echo.inc"

int0x80_msg:
    .ascii "--> IN INTERRUPT 0x80 HANDLER. <--"
int0x80_msg_end:
    .equ int0x80_msg_length, int0x80_msg_end - int0x80_msg
int0x90_msg:
    .ascii "--> IN INTERRUPT 0x90 HANDLER. <--"
int0x90_msg_end:
    .equ int0x90_msg_length, int0x90_msg_end - int0x90_msg
int0xff_msg:
    .ascii "--> IN INTERRUPT 0xff HANDLER. <--"
int0xff_msg_end:
    .equ int0xff_msg_length, int0xff_msg_end - int0xff_msg
gp_msg:
    .ascii "--> IN EXCEPTION #GP HANDLER. <--"
gp_msg_end:
    .equ gp_msg_length, gp_msg_end - gp_msg

dummy:
    .space 512-(.-_int0x80), 0x00

