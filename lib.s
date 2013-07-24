.code16
.section .text
.globl _start
#
# start
#
_start:
    call _test
    jmp .
#
# %esi - string
# %ecx - length
#
.globl _echo
.type _echo, @function
_echo:
    movb $0x0e, %ah
_do_echo:
    lodsb
    int $0x10
    loop _do_echo
    ret

.globl _echo_ln
.type _echo_ln, @function
_echo_ln:
    movb $0x0e, %ah
    movb $0x0d, %al
    int $0x10
    movb $0x0a, %al
    int $0x10
    ret

#
# %si hex
# %ax char
#
.globl _hex_to_char
.type _hex_to_char, @function
_hex_to_char:
    pushl %esi
    pushl %ebx
    andl $0x0f, %esi
    movl $character_table, %ebx
    movb (%ebx, %esi), %al
    popl %ebx
    popl %esi
    ret

character_table:
    .ascii "0123456789abcdef"

# 32-bits
# %esi byte
# %edi string
#
.globl _long_to_string
.type _long_to_string, @function
_long_to_string:
    pushl %ecx
    movl $8, %ecx
_do_long_to_string:
    roll $4, %esi
    call _hex_to_char
    movb %al, (%edi)
    inc %edi
    dec %ecx
    jnz _do_long_to_string
    popl %ecx
    ret

# print register value
# %eax, %ebx, %ecx, %edx
#
.globl _print_register_value
.type _print_register_value, @function
_print_register_value:
    pushl %esi
    pushl %edi
    pushl %ecx

    # print %eax
    movl %eax, %esi
    movl $register_value_address, %edi
    call _long_to_string
    movl $register_message_eax, %esi
    movl $register_message_eax_length, %ecx
    call _echo
    movl $register_value_address, %esi
    movl $register_value_address_length, %ecx
    call _echo
    call _echo_ln
    # print %ebx
    movl %ebx, %esi
    movl $register_value_address, %edi
    call _long_to_string
    movl $register_message_ebx, %esi
    movl $register_message_ebx_length, %ecx
    call _echo
    movl $register_value_address, %esi
    movl $register_value_address_length, %ecx
    call _echo
    call _echo_ln
    # print %ecx
    popl %ecx
    movl %ecx, %esi
    movl $register_value_address, %edi
    call _long_to_string
    movl $register_message_ecx, %esi
    movl $register_message_ecx_length, %ecx
    call _echo
    movl $register_value_address, %esi
    movl $register_value_address_length, %ecx
    call _echo
    call _echo_ln
    # print %edx
    movl %edx, %esi
    movl $register_value_address, %edi
    call _long_to_string
    movl $register_message_edx, %esi
    movl $register_message_edx_length, %ecx
    call _echo
    movl $register_value_address, %esi
    movl $register_value_address_length, %ecx
    call _echo
    call _echo_ln

    popl %edi
    popl %esi
    ret

register_message_eax:
    .ascii "%eax : 0x"
register_message_eax_end:
    .equ register_message_eax_length, register_message_eax_end - register_message_eax
register_message_ebx:
    .ascii "%ebx : 0x"
register_message_ebx_end:
    .equ register_message_ebx_length, register_message_ebx_end - register_message_ebx
register_message_ecx:
    .ascii "%ecx : 0x"
register_message_ecx_end:
    .equ register_message_ecx_length, register_message_ecx_end - register_message_ecx
register_message_edx:
    .ascii "%edx : 0x"
register_message_edx_end:
    .equ register_message_edx_length, register_message_edx_end - register_message_edx
register_value_address:
    .space 8, 0x00
register_value_address_end:
    .equ register_value_address_length, register_value_address_end - register_value_address


