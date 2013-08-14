.code16
.section .text

.include "common.inc"

.globl _start
_start:
    #
    # read sector.
    #
    read_sector $SETUP_SEG, $0x02, $0x04
    jc no_test

    ljmp $0x00, $SETUP_SEG

no_test:
    #
    # show message.
    #
    movw $boot_message, %si
    movw $boot_message_length, %cx
    call _echo

    jmp .

.include "echo.inc"

boot_message:
    .ascii "No test to be execute!"
boot_message_end:
    .equ boot_message_length, boot_message_end - boot_message

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

