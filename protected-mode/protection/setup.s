.include "common.inc"

.code16
.section .text
.globl _start
_start:
    cli

    # move protect mode code to 0x7000
    movw $_setup_length, %cx
    movw $_setup, %si
    movw $SETUP_BASE, %di
    rep movsb

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
    setup_gdt $DATA_BASE, $DATA_LIMIT, $DATA_ATTR
    addl $8, %edi
    setup_gdt $STACK_BASE, $STACK_LIMIT, $STACK_ATTR
    addl $8, %edi
    setup_gdt $SETUP_BASE, $SETUP_LIMIT, $SETUP_ATTR
    addl $8, %edi
    setup_gdt $INT_STACK_BASE, $INT_STACK_LIMIT, $INT_STACK_ATTR
    addl $8, %edi
    setup_gdt $VIDEO_BASE, $VIDEO_LIMIT, $VIDEO_ATTR
    addl $8, %edi
    setup_gdt $SUPER_BASE, $SUPER_LIMIT, $SUPER_ATTR

    # load GDT
    lgdt GDT_POINTER

    # switch to protected-mode
    movl %cr0, %eax
    orl $1, %eax
    movl %eax, %cr0

    # far jmp
    ljmp $SETUP_SELECTOR, $0x00

GDT_POINTER:
    .short 0x48
    .int   0x0800
IDT_POINTER:
    .short 0x7ff
    .int   0x00

.type _setup, @function
_setup:
    # copy code and date to appropriate address use super data segment.
    xorl %eax, %eax
    movw $SUPER_SELECTOR, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw $NULL_SELECTOR, %ax
    movw %ax, %ss

    # copy intrrupt code
    /*
    movl $_int, %esi
    movl $INT_HANDLER_BASE, %edi
    movl _int_end - _int, %ecx
    rep movsb
    */

    # copy main code
    movl $_main, %esi
    movl $CODE_MAIN_BASE, %edi
    movl $_main_end, %ecx
    subl $_main, %ecx
    rep movsb

    # initialize interrupt environment
    xorl %eax, %eax
    movw $INT_STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $INT_STACK_INIT_ESP, %esp
    pushl %eax

    # initialize protected-mode environment
    xorl %eax, %eax
    movw $DATA_SELECTOR, %ax
    movw %ax, %ds
    movw $VIDEO_SELECTOR, %ax
    movw %ax, %es
    movw $STACK_SELECTOR, %ax
    movw %ax, %ss
    movl $STACK_INIT_ESP, %esp
    movw $NULL_SELECTOR, %ax
    movw %ax, %gs
    movw %ax, %ss

    jmp .

_setup_end:
    .equ _setup_length, _setup_end - _setup

