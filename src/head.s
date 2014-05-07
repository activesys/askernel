# head.s

######## define ########
LATCH       = 11930
SCRN_SEL    = 0x18
TSS0_SEL    = 0x20
LDT0_SEL    = 0x28
TSS1_SEL    = 0x30
LDT1_SEL    = 0x38
TSS2_SEL    = 0x40
LDT2_SEL    = 0x48
TSS3_SEL    = 0x50
LDT3_SEL    = 0x58


.code32
.section .text
.global _start
_start:
    movl $0x10, %eax
    movw %ax, %ds
    lss _init_stack, %esp
    call _setup_idt
    call _setup_gdt
    movl $0x10, %eax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    lss _init_stack, %esp

    movb $0x36, %al
    movl $0x43, %edx
    outb %al, %dx
    movl $LATCH, %eax
    movl $0x40, %edx
    outb %al, %dx
    movb %ah, %al
    outb %al, %dx

    movl $0x00080000, %eax
    movw $_timer_interrupt, %ax
    movw $0x8e00, %dx
    movl $0x08, %ecx
    leal _idt(, %ecx, 8), %esi
    movl %eax, (%esi)
    movl %edx, 4(%esi)

    movw $_system_interrupt, %ax
    movw $0xef00, %dx
    movl $0x80, %ecx
    leal _idt(, %ecx, 8), %esi
    movl %eax, (%esi)
    movl %edx, 4(%esi)

    pushfl
    andl $0xffffbfff, (%esp)
    popfl
    movl $TSS0_SEL, %eax
    ltr %ax
    movl $LDT0_SEL, %eax
    lldt %ax
    movl $0, _current
    sti
    pushl $0x17
    pushl $_init_stack
    pushfl
    pushl $0x0f
    pushl $_task0
    iret

######## common function ########
_setup_gdt:
    lgdt _gdt_pointer
    ret

_setup_idt:
    leal _default_interrupt, %edx
    movl $0x00080000, %eax
    movw %dx, %ax
    movw $0x8e00, %dx
    leal _idt, %edi
    movl $256, %ecx
_rp_idt:
    movl %eax, (%edi)
    movl %edx, 4(%edi)
    addl $8, %edi
    decl %ecx
    jne _rp_idt
    lidt _idt_pointer
    ret

_writer_char:
    push %gs
    pushl %ebx
    movl $SCRN_SEL, %ebx
    movw %bx, %gs
    movl _scr_loc, %ebx
    shll $1, %ebx
    movb %al, %gs:(%ebx)
    shrl $1, %ebx
    incl %ebx
    cmpl $2000, %ebx
    jb 1f
    movl $0, %ebx
1:  movl %ebx, _scr_loc
    popl %ebx
    pop %gs
    ret

######## interrupt handler ########
.align 4
_default_interrupt:
    push %ds
    pushl %eax
    movl $0x10, %eax
    movw %ax, %ds
    movl $88, %eax
    call _writer_char
    popl %eax
    pop %ds
    iret

.align 4
_timer_interrupt:
    push %ds
    pushl %eax
    movl $0x10, %eax
    movw %ax, %ds
    movb $0x20, %al
    outb %al, $0x20
    movl $0, %eax
    cmpl %eax, _current
    je 1f
    movl $1, %eax
    cmpl %eax, _current
    je 2f
    movl $2, %eax
    cmpl %eax, _current
    je 3f
    movl $0, _current
    ljmp $TSS0_SEL, $0x00
    jmp _end
1:  movl $1, _current
    ljmp $TSS1_SEL, $0x00
    jmp _end
2:  movl $2, _current
    ljmp $TSS2_SEL, $0x00
    jmp _end
3:  movl $3, _current
    ljmp $TSS3_SEL, $0x00
_end:
    popl %eax
    pop %ds
    iret

.align 4
_system_interrupt:
    push %ds
    pushl %edx
    pushl %ecx
    pushl %ebx
    pushl %eax
    movl $0x10, %edx
    movw %dx, %ds
    call _writer_char
    popl %eax
    popl %ebx
    popl %ecx
    popl %edx
    pop %ds
    iret

######## data area ########
_current:
    .int    0
_scr_loc:
    .int    0

.align 4
_idt_pointer:
    .short  256*8-1
    .int    _idt
_gdt_pointer:
    .short  _gdt_end-_gdt-1
    .int    _gdt

.align 8
_idt:
    .fill   256, 8, 0
_gdt:
    .quad   0x0000000000000000
    .quad   0x00c09a00000007ff
    .quad   0x00c09200000007ff
    .quad   0x00c0920b80000002
    .short  0x68, _tss0, 0xe900, 0x00
    .short  0x40, _ldt0, 0xe200, 0x00
    .short  0x68, _tss1, 0xe900, 0x00
    .short  0x40, _ldt1, 0xe200, 0x00
    .short  0x68, _tss2, 0xe900, 0x00
    .short  0x40, _ldt2, 0xe200, 0x00
    .short  0x68, _tss3, 0xe900, 0x00
    .short  0x40, _ldt3, 0xe200, 0x00
_gdt_end:

    .fill   128, 4, 0
_init_stack:
    .int    _init_stack
    .short  0x10

.align 8
_ldt0:
    .quad 0x0000000000000000
    .quad 0x00c0fa00000003ff
    .quad 0x00c0f200000003ff

_tss0:
    .int    0x00
    .int    _krn_stk0, 0x10
    .int    0x00, 0x00, 0x00, 0x00, 0x00
    .int    0x00, 0x00, 0x00, 0x00, 0x00
    .int    0x00, 0x00, 0x00, 0x00, 0x00
    .int    0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    .int    LDT0_SEL, 0x8000000

    .fill 128, 4, 0
_krn_stk0:

.align 8
_ldt1:
    .quad 0x0000000000000000
    .quad 0x00c0fa00000003ff
    .quad 0x00c0f200000003ff

_tss1:
    .int    0x00
    .int    _krn_stk1, 0x10
    .int    0x00, 0x00, 0x00, 0x00, 0x00
    .int    _task1, 0x200
    .int    0x00, 0x00, 0x00, 0x00
    .int    _usr_stk1, 0x00, 0x00, 0x00
    .int    0x17, 0x0f, 0x17, 0x17, 0x17, 0x17
    .int    LDT1_SEL, 0x8000000

    .fill 128, 4, 0
_krn_stk1:

.align 8
_ldt2:
    .quad 0x0000000000000000
    .quad 0x00c0fa00000003ff
    .quad 0x00c0f200000003ff

_tss2:
    .int    0x00
    .int    _krn_stk2, 0x10
    .int    0x00, 0x00, 0x00, 0x00, 0x00
    .int    _task2, 0x200
    .int    0x00, 0x00, 0x00, 0x00
    .int    _usr_stk2, 0x00, 0x00, 0x00
    .int    0x17, 0x0f, 0x17, 0x17, 0x17, 0x17
    .int    LDT2_SEL, 0x8000000

    .fill 128, 4, 0
_krn_stk2:

.align 8
_ldt3:
    .quad 0x0000000000000000
    .quad 0x00c0fa00000003ff
    .quad 0x00c0f200000003ff

_tss3:
    .int    0x00
    .int    _krn_stk3, 0x10
    .int    0x00, 0x00, 0x00, 0x00, 0x00
    .int    _task3, 0x200
    .int    0x00, 0x00, 0x00, 0x00
    .int    _usr_stk3, 0x00, 0x00, 0x00
    .int    0x17, 0x0f, 0x17, 0x17, 0x17, 0x17
    .int    LDT3_SEL, 0x8000000

    .fill 128, 4, 0
_krn_stk3:

_task0:
    movl $0x17, %eax
    movw %ax, %ds
    movb $65, %al
    int $0x80
    movl $0x0fff, %ecx
1:  loop 1b
    jmp _task0

_task1:
    movb $66, %al
    int $0x80
    movl $0x0fff, %ecx
1:  loop 1b
    jmp _task1

    .fill 128, 4, 0
_usr_stk1:

_task2:
    movb $67, %al
    int $0x80
    movl $0x0fff, %ecx
1:  loop 1b
    jmp _task2

    .fill 128, 4, 0
_usr_stk2:

_task3:
    movb $68, %al
    int $0x80
    movl $0x0fff, %ecx
1:  loop 1b
    jmp _task3

    .fill 128, 4, 0
_usr_stk3:

