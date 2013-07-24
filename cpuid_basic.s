.code16
.section .text
.globl _test
.type _test, @function
_test:
    # %eax == $0x00
    movl $cpuid_leaf_0x00, %esi
    movl $cpuid_leaf_0x00_length, %ecx
    call _echo
    call _echo_ln
    movl $0x00, %eax
    cpuid
    call _print_register_value

    # %eax == $0x01
    movl $cpuid_leaf_0x01, %esi
    movl $cpuid_leaf_0x01_length, %ecx
    call _echo
    call _echo_ln
    movl $0x01, %eax
    cpuid
    call _print_register_value

    # %eax == $0x02
    movl $cpuid_leaf_0x02, %esi
    movl $cpuid_leaf_0x02_length, %ecx
    call _echo
    call _echo_ln
    movl $0x02, %eax
    cpuid
    call _print_register_value

    # %eax == 0x03
    movl $cpuid_leaf_0x03, %esi
    movl $cpuid_leaf_0x03_length, %ecx
    call _echo
    call _echo_ln
    movl $0x03, %eax
    cpuid
    call _print_register_value

    # %eax == $0x80000001
    movl $cpuid_leaf_ext_0x01, %esi
    movl $cpuid_leaf_ext_0x01_length, %ecx
    call _echo
    call _echo_ln
    movl $0x80000001, %eax
    cpuid
    call _print_register_value

    ret

cpuid_leaf_0x00:
    .ascii "---- Now : %eax = $0x00 ----"
cpuid_leaf_0x00_end:
    .equ cpuid_leaf_0x00_length, cpuid_leaf_0x00_end - cpuid_leaf_0x00
cpuid_leaf_0x01:
    .ascii "---- Now : %eax = $0x01 ----"
cpuid_leaf_0x01_end:
    .equ cpuid_leaf_0x01_length, cpuid_leaf_0x01_end - cpuid_leaf_0x01
cpuid_leaf_0x02:
    .ascii "---- Now : %eax = $0x02 ----"
cpuid_leaf_0x02_end:
    .equ cpuid_leaf_0x02_length, cpuid_leaf_0x02_end - cpuid_leaf_0x02
cpuid_leaf_0x03:
    .ascii "---- Now : %eax = $0x03 ----"
cpuid_leaf_0x03_end:
    .equ cpuid_leaf_0x03_length, cpuid_leaf_0x03_end - cpuid_leaf_0x03
cpuid_leaf_ext_0x01:
    .ascii "---- Now : %eax = $0x80000001 ----"
cpuid_leaf_ext_0x01_end:
    .equ cpuid_leaf_ext_0x01_length, cpuid_leaf_ext_0x01_end - cpuid_leaf_ext_0x01

dummy:
    .space 1024-(.-_test), 0x00

