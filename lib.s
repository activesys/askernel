.code16
.section .text
.globl _start
.globl _echo
#
# start
#
_start:
    movw $lib_message, %ax
    movw $length, %cx
    call _echo
    jmp .
#
# %ax - string
# %cx - length
#
_echo:
    movw %ax, %bp
    movw $0x1301, %ax
    movw $0x0c, %bx
    movw $0x00, %dx
    int $0x10

    ret

lib_message:
    .ascii "Lib message!"
lib_message_end:
    .equ length, lib_message_end - lib_message

dummy:
    .space 512-(.-_start), 0

