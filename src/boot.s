# boot.s

.equ BOOTSEG,   0x07c0
.equ SYSSEG,    0x1000
.equ SYSLEN,    17

.code16
.section .text
.global _start
_start:
    ljmp $BOOTSEG, $_go-_start
_go:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw $0x0400, %sp

# load kernel to 0x10000
_load_system:
    movw $0x0000, %dx
    movw $0x0002, %cx
    movw $SYSSEG, %ax
    movw %ax, %es
    xorw %bx, %bx
    movw $0x0200 + SYSLEN, %ax
    int  $0x13
    jnc  _load_ok

_die:
    jmp  _die

# move kernel to address 0
_load_ok:
    cli
    movw $SYSSEG, %ax
    movw %ax, %ds
    xorw %ax, %ax
    movw %ax, %es
    movw $0x1000, %cx
    xorw %si, %si
    xorw %di, %di
    rep movsw

# set IDT and GDT
_set_idt_gdt:
    movw $BOOTSEG, %ax
    movw %ax, %ds
    lidt _idt_pointer
    lgdt _gdt_pointer

# set cr0 move to protected mode
    movw $0x0001, %ax
    lmsw %ax

    ljmp $0x08, $0x00

_gdt:
    .quad 0x0000000000000000
    .quad 0x00c09a00000007ff
    .quad 0x00c09200000007ff

_idt_pointer:
    .short 0x00
    .int   0x00
_gdt_pointer:
    .short 0x07ff
    .int   _gdt

_magic_number:
    .short 0xaa55

