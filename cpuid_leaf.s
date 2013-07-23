.code16
.section .text
.globl _test
.type _test, @function
_test:
    # get basic leaf number
    xorl %eax, %eax
    cpuid
    movl %eax, %esi
    movl $value_address, %edi
    call _long_to_string
    movl $basic_message, %esi
    movl $basic_message_length, %ecx
    call _echo
    movl $value_address, %esi
    movl $value_address_length, %ecx
    call _echo
    call _echo_ln

    # get extened leaf number
    movl $0x80000000, %eax
    cpuid
    movl %eax, %esi
    movl $value_address, %edi
    call _long_to_string
    movl $extend_message, %esi
    movl $extend_message_length, %ecx
    call _echo
    movl $value_address, %esi
    movl $value_address_length, %ecx
    call _echo
    call _echo_ln
    
    ret

basic_message:
    .ascii "maximun basic function: 0x"
basic_message_end:
    .equ basic_message_length, basic_message_end - basic_message
extend_message:
    .ascii "maximun extended function: 0x"
extend_message_end:
    .equ extend_message_length, extend_message_end - extend_message
value_address:
    .space 8, 0x00
value_address_end:
    .equ value_address_length, value_address_end - value_address

dummy:
    .space 512-(.-_test), 0x00

