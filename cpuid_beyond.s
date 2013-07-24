.code16
.section .text
.globl _test
.type _test, @function
_test:
    # %eax == $0x0d
    movl $cpuid_leaf_0x0d, %esi
    movl $cpuid_leaf_0x0d_length, %ecx
    call _echo
    call _echo_ln
    movl $0x0d, %eax
    cpuid
    call _print_register_value

    # %eax == $0x0f
    movl $cpuid_leaf_0x0f, %esi
    movl $cpuid_leaf_0x0f_length, %ecx
    call _echo
    call _echo_ln
    movl $0x0f, %eax
    cpuid
    call _print_register_value

    # %eax == $0x80000008
    movl $cpuid_leaf_ext_0x08, %esi
    movl $cpuid_leaf_ext_0x08_length, %ecx
    call _echo
    call _echo_ln
    movl $0x80000008, %eax
    cpuid
    call _print_register_value

    # %eax == 0x80000009
    movl $cpuid_leaf_ext_0x09, %esi
    movl $cpuid_leaf_ext_0x09_length, %ecx
    call _echo
    call _echo_ln
    movl $0x80000009, %eax
    cpuid
    call _print_register_value

    ret

cpuid_leaf_0x0d:
    .ascii "---- Now : %eax = $0x0d ----"
cpuid_leaf_0x0d_end:
    .equ cpuid_leaf_0x0d_length, cpuid_leaf_0x0d_end - cpuid_leaf_0x0d
cpuid_leaf_0x0f:
    .ascii "---- Now : %eax = $0x0f ----"
cpuid_leaf_0x0f_end:
    .equ cpuid_leaf_0x0f_length, cpuid_leaf_0x0f_end - cpuid_leaf_0x0f
cpuid_leaf_ext_0x08:
    .ascii "---- Now : %eax = $0x80000008 ----"
cpuid_leaf_ext_0x08_end:
    .equ cpuid_leaf_ext_0x08_length, cpuid_leaf_ext_0x08_end - cpuid_leaf_ext_0x08
cpuid_leaf_ext_0x09:
    .ascii "---- Now : %eax = $0x80000009 ----"
cpuid_leaf_ext_0x09_end:
    .equ cpuid_leaf_ext_0x09_length, cpuid_leaf_ext_0x09_end - cpuid_leaf_ext_0x09

dummy:
    .space 1024-(.-_test), 0x00

