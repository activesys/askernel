# boot.s
# boot system, read kernel from disk to 0x1000

.equ BOOTSEG,   0x07c0
.equ SYSSEG,    0x1000
.equ SYSLEN,    20

.code16
.section .text
.global _start
_start:
    ljmp $BOOTSEG, $_go-_start
_go:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0x0400, %sp


# print kernel message
    call _clr_msg
    movw $0x2a, %cx
    movw $_booting_msg, %bp
    call _print_msg
    call _print_nl
    call _print_nl

# load setup to 0x10000
_load_system:
    movw $0x09, %cx
    movw $_loadding_msg, %bp
    call _print_msg
    movw $0x08, %cx
    movw $_setup_msg, %bp
    call _print_msg
    call _print_nl

    movw $0x0000, %dx
    movw $0x0002, %cx
    movw $SYSSEG, %ax
    movw %ax, %es
    xorw %bx, %bx
    movw $0x0200 + SYSLEN, %ax
    int  $0x13

# loop forever
    jmp  .


# print message
# msg at bp
_clr_msg:
    movw $0x0600, %ax
    movb $0x07, %bh
    movw $0x00, %cx
    movw $0x174f, %dx
    int $0x10
    movw $0x00, %dx
    movw $0x0200, %ax
    int $0x10
    ret

_print_msg:
    movw %cx, %si
    movw $0x0300, %ax
    int $0x10
    movw %si, %cx
    movw $0x0007, %bx
    movw $0x1301, %ax
    int $0x10
    ret

_print_nl:
    movw $0x0e0d, %ax
    int $0x10
    movb $0x0a, %al
    int $0x10
    ret

# message
_loadding_msg:
    .ascii "Loadding "
_setup_msg:
    .ascii "setup..."
_kernel_msg:
    .ascii "kernel"
_booting_msg:
    .ascii "Booting askernel-0.1 (C) 2014 activesys.wb"

_magic_number:
    .space 510-(.-_start), 0x00
    .short 0xaa55
