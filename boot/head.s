#
# askernel head
#

.include "boot.inc"

.code32
.text
.global _start
_start:
_pg_dir:
    movl $0x10, %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    lss _load_start, %esp

    # reload gdt and idt
    call _setup_idt
    call _setup_gdt
    movl $0x10, %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    lss _load_start, %esp

    jmp _after_page_tables

_setup_idt:
    leal _default_int, %edx
    movl $0x00080000, %eax
    movw %dx, %ax
    movw $0x8e00, %dx
    leal _idt, %edi
    movl $256, %ecx
_rp_sidt:
    movl %eax, (%edi)
    movl %edx, 4(%edi)
    movl $8, %edi
    decl %ecx
    jne _rp_sidt
    lidt _load_idt
    ret

_setup_gdt:
    lgdt _load_gdt
    ret

# kernel page table
.org 0x1000
_pg0:

.org 0x2000
_pg1:

.org 0x3000
_pg2:

.org 0x4000
_pg3:

.org 0x5000

_after_page_tables:
    pushl $0x00
    pushl $0x00
    pushl $0x00
    pushl $L6
    #pushl $_main
    jmp _setup_paging
L6:
    jmp L6

# default interrupt handler
_int_msg:
    .asciz  "Unknown interrupt\n\r"
.balign 4
_default_int:
    pushl %eax
    pushl %ecx
    pushl %edx
    push %ds
    push %es
    push %fs
    movl $0x10, %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    pushl $_int_msg
    #call _printk
    #popl %eax
    pop %fs
    pop %es
    pop %ds
    popl %edx
    popl %ecx
    popl %eax
    iret

# setup paging
.balign 4
_setup_paging:
    movl $1024*5, %ecx
    xorl %eax, %eax
    xorl %edi, %edi
    cld
    rep stosl
    movl $_pg0 + 7, _pg_dir
    movl $_pg1 + 7, _pg_dir + 4
    movl $_pg2 + 7, _pg_dir + 8
    movl $_pg3 + 7, _pg_dir + 12
    movl $_pg3 + 4092, %edi
    movl $0xfff007, %eax
    std
1:  stosl
    subl $0x1000, %eax
    jge 1b

    xorl %eax, %eax
    movl %eax, %cr3
    movl %cr0, %eax
    orl $0x80000000, %eax
    movl %eax, %cr0
    ret


.balign 4
_load_idt:
    .short 256*8-1
    .long _idt

.balign 4
_load_gdt:
    .short  256*8-1
    .long   _gdt

.balign 8
_idt:
    .fill 256, 8, 0x00
_gdt:
    .quad 0x0000000000000000
    .quad 0x00c09a0000000fff
    .quad 0x00c0920000000fff
    .fill 252, 8, 0x00

_load_start:
    .long   _stack_start - _start
    .short  0x10

    .fill 512, 8, 0x00
_stack_start:
