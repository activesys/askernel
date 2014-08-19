/* vim: ft=gas :
*/
/*
 * Setup kernel 
 */
.set ALIGN,     1<<0
.set MEMINFO,   1<<1
.set FLAGS,     ALIGN|MEMINFO
.set MAGIC,     0x1badb002
.set CHECKSUM,  -(MAGIC + FLAGS)

################################
# GRUB header and page directory
#
.section .text
.global page_dir
page_dir:
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

################################
# Page table
#
.org 0x1000
.global page_table_0
page_table_0:
.org 0x2000
.global page_table_1
page_table_1:
.org 0x3000
.global page_table_2
page_table_2:
.org 0x4000
.global page_table_3
page_table_3:

################################
# Kernel stack
#
.org 0x5000
.global stack_top
stack_top:
.org 0x6000
.global stack_bottom
stack_bottom:

################################
# GDT and IDT
#
.org 0x7000
.global gdt, idt
idt:
    .fill 256, 8, 0x00

gdt:
    .quad 0x0000000000000000    /* null descriptor */
    .quad 0x00c09a0000000fff
    .quad 0x00c0920000000fff
    .quad 0x0000000000000000
    .fill 252, 8, 0x00  

################################
# Entery point
#
.org 0x8000
.section .text
.global _start, _end
.type _start, @function
_start:
    cli
    call setup_gdt
    call setup_idt

    # set segment
    movl $0x10, %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
    movl stack_bottom, %esp

_end:
    jmp .

################################
# Setup GDT and IDT
#
setup_gdt:
    lgdt gdt_descriptor
    ret

setup_idt:
    leal default_interrupt_handler, %edx
    movl $0x00080000, %eax
    movw %dx, %ax
    movw $0x8e00, %dx

    leal idt, %edi
    movl $256, %ecx
setup_idt_repeat:
    movl %eax, (%edi)
    movl %edx, 4(%edi)
    addl $8, %edi
    dec  %ecx
    jne  setup_idt_repeat
    lidt idt_descriptor
    ret

# default interrupt handler
default_interrupt_handler_message:
    .asciz  "Unknown interrupt!\r\n"
default_interrupt_handler:
    pushl %eax
    pushl %ecx
    pushl %edx
    pushw %ds
    pushw %es
    pushw %fs

    movl $0x10, %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    pushl $default_interrupt_handler_message
    #call printk
    popl %eax

    popw %fs
    popw %es
    popw %ds
    popl %edx
    popl %ecx
    popl %eax
    iret

# descriptor of GDT and IDT
.align 4
gdt_descriptor:
    .short 256*8-1
    .long  gdt

.align 4
idt_descriptor:
    .short  256*8-1
    .long   idt

