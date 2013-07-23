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

