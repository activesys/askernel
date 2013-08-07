.code16
.section .text
.equ BOOT_SEG, 0x7c00
.equ EXEC_SEG, 0x600
.equ INT_0X80_HANDLER, 0x800

.globl _start
_start:
    cli
    xor %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    sti

    #
    # read sector.
    #
    movb $0x02, %ah
    movb $0x02, %al
    movb $0x00, %ch
    movb $0x02, %cl
    movb $0x00, %dh
    movb $0x00, %dl
    movw $EXEC_SEG, %bx
    int $0x13
    jc no_test

    #
    # read int 0x80 handler
    #
    movb $0x02, %ah
    movb $0x01, %al
    movb $0x00, %ch
    movb $0x04, %cl
    movb $0x00, %dh
    movb $0x00, %dl
    movw $INT_0X80_HANDLER, %bx
    int $0x13
    jc no_test

    ljmp $0x00, $EXEC_SEG

no_test:
    #
    # show message.
    #
    movw $boot_message, %ax
    movw %ax, %bp
    movw $0x1301, %ax
    movw $len, %cx
    movw $0x0c, %bx
    movw $0x00, %dx
    int $0x10

    jmp .

boot_message:
    .ascii "No test to be execute!"
boot_message_end:
    .equ len, boot_message_end - boot_message

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

