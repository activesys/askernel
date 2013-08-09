.code16
.section .text
.globl _start
_start:
    cli
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    # move gdt to 0x0800
    /*
    movw $gdt_len, %cx
    movw $gdt_start, %si
    movw $0x800, %di
    rep movsb
    */
    # move protect mode code to 0x2000
    /*
    movw $_protect_length, %cx
    movw $_protect, %si
    movw $0x2000, %di
    rep movsb
    */

    lgdt gdt_pointer
    movl %cr0, %eax
    orl $0x01, %eax
    movl %eax, %cr0

    ljmp $0x08, $_protect


gdt_start:
null_descriptor:
    .quad 0x0000000000000000
code_descriptor:
    .quad 0x00cf9a000000ffff
data_descriptor:
    .quad 0x00cf92000000ffff
gdt_end:

.equ gdt_len, gdt_end - gdt_start

gdt_pointer:
    .short 0xffff
    .int   gdt_start

.equ code_selector, 0x08
.equ data_selector, 0x10

.code32
.type _protect, @function
_protect:
    movl $data_selector, %eax
    movl %eax, %ds
    movl %eax, %es
    movl %eax, %ss
    movl %eax, %fs
    movl %eax, %gs
    movl $0x7000, %esp

    sti

    jmp .
_protect_end:
.equ _protect_length, _protect_end - _protect

dummy:
    .space 510-(.-_start), 0

magic_number:
    .byte 0x55, 0xaa

