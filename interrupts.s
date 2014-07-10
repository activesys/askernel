.macro ISR_NO_ERROR n
.global isr\n
.type isr\n, @function
isr\n:
    cli
    pushl $0x00
    pushl $\n
    jmp isr_common_stub
.endm

.macro ISR_ERROR n
.global isr\n
.type isr\n, @function
isr\n:
    cli
    pushl $\n
    jmp isr_common_stub
.endm

.global isr_handler

.section .text
ISR_NO_ERROR 0
ISR_NO_ERROR 1
ISR_NO_ERROR 2
ISR_NO_ERROR 3
ISR_NO_ERROR 4
ISR_NO_ERROR 5
ISR_NO_ERROR 6
ISR_NO_ERROR 7
ISR_ERROR    8
ISR_NO_ERROR 9
ISR_ERROR    10
ISR_ERROR    11
ISR_ERROR    12
ISR_ERROR    13
ISR_ERROR    14
ISR_NO_ERROR 15
ISR_NO_ERROR 16
ISR_NO_ERROR 17
ISR_NO_ERROR 18
ISR_NO_ERROR 19
ISR_NO_ERROR 20
ISR_NO_ERROR 21
ISR_NO_ERROR 22
ISR_NO_ERROR 23
ISR_NO_ERROR 24
ISR_NO_ERROR 25
ISR_NO_ERROR 26
ISR_NO_ERROR 27
ISR_NO_ERROR 28
ISR_NO_ERROR 29
ISR_NO_ERROR 30
ISR_NO_ERROR 31


isr_common_stub:
    pusha

    movw %ds, %ax
    pushl %eax

    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %gs
    movw %ax, %fs

    call isr_handler

    popl %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %gs
    movw %ax, %fs

    popa
    addl $0x08, %esp
    sti
    iret
