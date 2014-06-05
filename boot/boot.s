# boot.s
# boot system, read kernel from disk to 0x1000

.include "boot.inc"

.code16
.section .text
.global _start
_start:
    ljmp $BOOT_SEGMENT, $_go-_start
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

# load setup to 0x8000
_load_setup:
    movw $0x09, %cx
    movw $_loadding_msg, %bp
    call _print_msg
    movw $0x08, %cx
    movw $_setup_msg, %bp
    call _print_msg
    call _print_nl

# read 1 sector, and calculate the size of setup.
# first byte of setup is the sector count of setup.
_load_setup_first_sector:
    xorw %dx, %dx
    movw $0x0002, %cx
    movw $SETUP_SEGMENT, %ax
    movw %ax, %es
    movw $0x00, %bx
    movw $0x0201, %ax
    int $0x13
    jc _load_setup_failed

_load_setup_remainder_sector:
    # get sector count of setup
    movw %es:(%bx), %dx
    call _print_setup_msg



# loop forever
_boot_end:
    jmp  .

_print_setup_msg:
    pushw %dx
    pushw %bx
    pushw %es
    movw %cs, %ax
    movw %ax, %es
    movw $0x03, %cx
    movw $_to_msg, %bp
    call _print_msg
    popw %dx
    call _print_hex
    movw $0x01, %cx
    movw $_colon_msg, %bp
    call _print_msg
    popw %dx
    call _print_hex
    movw $0x08, %cx
    movw $_length_msg, %bp
    call _print_msg
    popw %dx
    call _print_hex
    call _print_nl
    call _print_nl
    ret


# load setup failed
_load_setup_failed:
    movw $0x07, %cx
    movw $_failed_msg, %bp
    call _print_msg
    call _print_nl
    jmp .


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


# message
_length_msg:
    .ascii " length "
_colon_msg:
    .ascii ":"
_to_msg:
    .ascii "to "
_failed_msg:
    .ascii "failed!"
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
_test_message:
    .short 0x12ab
