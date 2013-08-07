.code16
.section .text
.equ IVT_OLD_ADDRESS, 0x00
.equ IVT_NEW_ADDRESS, 0x2000
.equ IVT_ENTRY_COUNT, 256
.equ INT_0X80_OFFSET, 0x2200

.globl _test
.type _test, @function
_test:
    movw $msg2, %si
    movw $msg2_length, %cx
    call _echo
    call _echo_ln

    sidt old_IVT_pointer

    pushw %es
    pushw %ds
    movw $0x00, %ax
    movw %ax, %ds
    movw %ax, %es
    movw $IVT_ENTRY_COUNT, %cx
    movw $IVT_OLD_ADDRESS, %si
    movw $IVT_NEW_ADDRESS, %di
    rep movsl
    popw %ds
    popw %es

    lidt new_IVT_pointer

    movw $msg1, %si
    movw $msg1_length, %cx
    call _echo
    call _echo_ln

    # test int n
    movl $INT_0X80_OFFSET, %edx
    movl int0x80_vector, %eax
    movl %eax, (%edx)
    int $0x80

    lidt old_IVT_pointer

    movw $msg2, %si
    movw $msg2_length, %cx
    call _echo
    call _echo_ln

    ret

old_IVT_pointer:
    .short 0x00
    .int 0x00
new_IVT_pointer:
    .short 0x03ff
    .int 0x2000
int0x80_vector:
    .int 0x800

msg1:
    .ascii "now : IDTR.base = 0x2000"
msg1_end:
    .equ msg1_length, msg1_end - msg1
msg2:
    .ascii "now : IDTR.base = 0x00"
msg2_end:
    .equ msg2_length, msg2_end - msg2

dummy:
    .space 1024-(.-_test), 0x00

