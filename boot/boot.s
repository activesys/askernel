# boot.s
# boot system, read kernel from disk to 0x1000

.include "boot.inc"

.code16
.section .text
.global _start
_start:
    movw $BOOT_SEGMENT, %ax
    movw %ax, %ds
    xorw %si, %si
    movw $INIT_SEGMENT, %ax
    movw %ax, %es
    xorw %di, %di
    movw $0x100, %cx
    rep movsw

    ljmp $INIT_SEGMENT, $_go-_start
_go:
    movw %cs, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss
    movw $0x0400, %sp


# print kernel message
_print_copyright:
    call _clr_msg
    movw $0x2a, %cx
    movw $_booting_msg, %bp
    call _print_msg
    call _print_nl
    call _print_nl

# load kernel to 0x8000
_load_setup:
    movw $0x09, %cx
    movw $_loadding_msg, %bp
    call _print_msg
    movw $0x09, %cx
    movw $_kernel_msg, %bp
    call _print_msg
    call _print_nl


# load kernel user int $0x13 extended function
_load_kernel:
    movw $_int0x13_extended, %si
    movw $_sector_count, %dx
    movw $0x80, (%edx)
    movw $_buffer_segment, %dx
    movw $KERNEL_TEMP_SEGMENT, (%edx)
    movw $_buffer_offset, %dx
    movw $0x00, (%edx)
    movw $0x4200, %ax
    int $0x13

    cli
_move_kernel:
    cld
    xorw %ax, %ax
    movw %ax, %es
    movw %ax, %di
    movw $KERNEL_TEMP_SEGMENT, %ax
    movw %ax, %ds
    xorw %si, %si
    movw $0x8000, %cx
    rep movsw

_setup_dt:
    movw $INIT_SEGMENT, %ax
    movw %ax, %ds

    lgdt _load_gdt
    lidt _load_idt

_reinit_8259a:
_master_icw1:
    movb $0x11, %al
    outb %al, $0x20
    jmp _slave_icw1
_slave_icw1:
    outb %al, $0xa0
    jmp _master_icw2
_master_icw2:
    movb $0x20, %al
    outb %al, $0x21
    jmp _slave_icw2
_slave_icw2:
    movb $0x28, %al
    outb %al, $0xa1
    jmp _master_icw3
_master_icw3:
    movb $0x04, %al
    outb %al, $0x21
    jmp _slave_icw3
_slave_icw3:
    movb $0x02, %al
    outb %al, $0xa1
    jmp _master_icw4
_master_icw4:
    movb $0x01, %al
    outb %al, $0x21
    jmp _slave_icw4
_slave_icw4:
    outb %al, $0xa1
    jmp _master_ocw1
_master_ocw1:
    movb $0xff, %al
    outb %al, $0x21
    jmp _slave_ocw1
_slave_ocw1:
    outb %al, $0xa1
    jmp _switch_to_protected

_switch_to_protected:
    movl %cr0, %eax
    xorl $0x01, %eax
    movl %eax, %cr0

    ljmp $0x08, $0x00


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

# print %dx as hex
_print_hex:
    movw $0x04, %cx
_print_digit:
    rol $0x04, %dx
    movb $0x0e, %ah
    movb %dl, %al
    andb $0x0f, %al
    addb $0x30, %al
    cmp $0x39, %al
    jbe _good_digit
    addb $0x41 - 0x30 - 0x0a, %al
_good_digit:
    int $0x10
    loop _print_digit
    ret

_gdt:
    .quad   0x0000000000000000
    .quad   0x00c09a00000007ff
    .quad   0x00c09200000007ff

_load_idt:
    .short  0x0000
    .long   0x00000000

_load_gdt:
    .short  0x0800
    .long   0x90000 + _gdt - _start

# int $0x13 extended
_int0x13_extended:
    .byte   0x10
    .byte   0x00
_sector_count:
    .short  0x00
_buffer_segment:
    .short  0x00
_buffer_offset:
    .short  0x00
_block_number:
    .quad   0x0000000000000001

# message
_failed_msg:
    .ascii "failed!"
_loadding_msg:
    .ascii "Loadding "
_kernel_msg:
    .ascii "kernel..."
_booting_msg:
    .ascii "Booting askernel-0.1 (C) 2014 activesys.wb"

_magic_number:
    .space 510-(.-_start), 0x00
    .short 0xaa55
