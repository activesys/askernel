.code16
.section .text

.include "common.inc"

.globl _start
_start:
    cli

    #
    # read interrupt handler to handler base address
    #
    read_sector $INT_HANDLER_BASE, $0x06, $0x01
    jc no_test

    #
    # read main code
    #
    read_sector $CODE_MAIN_BASE, $0x07, $0x01
    jc no_test

    #
    # read function code
    #
    read_sector $CODE_FUN_BASE, $0x08, $0x01
    jc no_test

    #
    # read data
    #
    read_sector $DATA_BASE, $0x09, $0x01
    jc no_test

    #
    # setup idt
    #
    movl $IDT_BASE, %edi
    setup_idt $13, $EXCEPTION_GP_OFFSET
    setup_idt $0x80, $INT_0X80_OFFSET
    setup_idt $0x90, $INT_0X90_OFFSET
    setup_idt $0xff, $INT_0XFF_OFFSET

    # load IDT
    lidt IDT_POINTER

    #
    # setup gdt
    #
    movl $GDT_BASE, %edi
    setup_gdt $NULL_DESCRIPTOR_BASE, $NULL_DESCRIPTOR_LIMIT, $NULL_DESCRIPTOR_ATTR
    addl $8, %edi
    setup_gdt $INT_HANDLER_BASE, $INT_HANDLER_LIMIT, $INT_HANDLER_ATTR
    addl $8, %edi
    setup_gdt $CODE_MAIN_BASE, $CODE_MAIN_LIMIT, $CODE_MAIN_ATTR
    addl $8, %edi
    setup_gdt $CODE_FUN_BASE, $CODE_FUN_LIMIT, $CODE_FUN_ATTR
    addl $8, %edi
    setup_gdt $DATA_BASE, $DATA_LIMIT, $DATA_ATTR
    addl $8, %edi
    setup_gdt $STACK_BASE, $STACK_LIMIT, $STACK_ATTR

    # load GDT
    lgdt GDT_POINTER

    # check gdtr and idtr
    sgdt GDTR_CHECK
    sidt IDTR_CHECK

    # switch to protected-mode
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    # far jmp
    ljmp $CODE_MAIN_SELECTOR, $0x00

no_test:
    #
    # show message.
    #
    movw $boot_message, %si
    movw $boot_message_length, %cx
    call _echo

    jmp .

.include "echo.inc"

GDT_POINTER:
    .short 0x30
    .int   0x0800
GDTR_CHECK:
    .short 0x00
    .int   0x00
IDT_POINTER:
    .short 0x7ff
    .int   0x00
IDTR_CHECK:
    .short 0x00
    .int   0x00

boot_message:
    .ascii "No test to be execute!"
boot_message_end:
    .equ boot_message_length, boot_message_end - boot_message
end_msg:
    .ascii "        THE END"
end_msg_end:
    .equ end_msg_length, end_msg_end - end_msg

dummy:
    .space 2048-(.-_start), 0

