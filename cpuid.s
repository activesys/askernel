.code16
.section .text
.globl test
test:
    movw $test_message, %ax
    movw $length, %cx
    call _echo

    ret

test_message:
    .ascii "Test message!"
test_message_end:
    .equ length, test_message - test_message_end

