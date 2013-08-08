.code32
.section .text

.include "common.inc"

.globl _start
_start:
    # load data segment and stack segment
    movw $DATA_SELECTOR, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw $STACK_SELECTOR, %ax
    movw %ax, %ss

    sti

    movl $MAIN_MES_OFFSET, %eax
    movl $MAIN_MSG_LEN_OFFSET, %ebx
    leaw (%eax), %si
    movw (%ebx), %cx
    call _echo

    # generate #GP exception
    movw $INVALID_SELECTOR, %ax
    movw %ax, %gs

    # jmp to another code segment
    ljmp $CODE_FUN_BASE, $0x00

.include "echo.inc" 

dummy:
    .space 512-(.-_start), 0
    
