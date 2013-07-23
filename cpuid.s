.code16
.section .text
.globl _test
.type _test, @function
_test:
    pushf
    movl (%esp), %eax
    xorl $0x200000, (%esp)
    popf
    pushf
    movl (%esp), %ebx
    cmpl %eax, %ebx
    jnz support
not_support:
    movl $not_support_cpuid, %esi
    movl $not_support_cpuid_length, %ecx
    jmp print_message
support:
    movl $support_cpuid, %esi
    movl $support_cpuid_length, %ecx
print_message:
    call _echo

    ret

support_cpuid:
    .ascii "OK! support CPUID instruction!"
support_cpuid_end:
    .equ support_cpuid_length, support_cpuid_end - support_cpuid
not_support_cpuid:
    .ascii "NO! not support CPUID instruction!"
not_support_cpuid_end:
    .equ not_support_cpuid_length, not_support_cpuid_end - not_support_cpuid

dummy:
    .space 512-(.-_test), 0x00

