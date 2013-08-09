# content address.
.equ BOOT_SEG,  0x7c00
.equ SETUP_SEG, 0x7000

# for null descriptor
.equ NULL_DESCRIPTOR_BASE,  0x00
.equ NULL_DESCRIPTOR_LIMIT, 0x00
.equ NULL_DESCRIPTOR_ATTR,  0x00
.equ NULL_SELECTOR,         0x00

# interrupt and exception handler
# attr = 0x5098(G=0,D/B=1,L=0,AVL=1,P=1,DPL=00,S=1,TYPE=1000)
.equ INT_HANDLER_BASE,     0x1000
.equ INT_HANDLER_LIMIT,    0x0fff
.equ INT_HANDLER_ATTR,     0x409a
.equ INT_HANDLER_SELECTOR, 0x08

# main code segment
# attr = 0x5098(G=0,D/B=1,L=0,AVL=1,P=1,DPL=00,S=1,TYPE=1000)
.equ CODE_MAIN_BASE,       0x2000
.equ CODE_MAIN_LIMIT,      0x05ff
.equ CODE_MAIN_ATTR,       0x409a
.equ CODE_MAIN_SELECTOR,   0x10

# function code segment
# attr = 0x5098(G=0,D/B=1,L=0,AVL=1,P=1,DPL=00,S=1,TYPE=1000)
.equ CODE_FUN_BASE,        0x2600
.equ CODE_FUN_LIMIT,       0x05ff
.equ CODE_FUN_ATTR,        0x409a
.equ CODE_FUN_SELECTOR,    0x18

# data segment
# attr = 0x5090(G=0,D/B=1,L=0,AVL=1,P=1,DPL=00,S=1,TYPE=0000)
.equ DATA_BASE,            0x3000
.equ DATA_LIMIT,           0x1ff
.equ DATA_ATTR,            0x4090
.equ DATA_SELECTOR,        0x20

# stack segment
# attr = 0x5092(G=0,D/B=1,L=0,AVL=1,P=1,DPL=00,S=1,TYPE=0010)
.equ STACK_BASE,           0x3200
.equ STACK_LIMIT,          0xffff
.equ STACK_ATTR,           0x4092
.equ STACK_SELECTOR,       0x28

# invalid selector
.equ INVALID_SELECTOR,     0x100

# for IDT
.equ INT_0X80_OFFSET,      0x00
.equ INT_0X90_OFFSET,      0x20
.equ INT_0XFF_OFFSET,      0x40
.equ EXCEPTION_GP_OFFSET,  0x60

.equ GDT_BASE,             0x0800
.equ IDT_BASE,             0x00

# for access data
.equ MAIN_MES_OFFSET,      0x00
.equ FUN_MSG_OFFSET,       0x80 
.equ END_MSG_OFFSET,       0x100
.equ MAIN_MSG_LEN_OFFSET,  0x180
.equ FUN_MSG_LEN_OFFSET,   0x182
.equ END_MSG_LEN_OFFSET,   0x184

# %edi is address, %ebx, %edx is temp
.macro setup_gdt base, offset, attr
    movl \base, %ebx
    andl $0x0000ffff, %ebx
    shll $16, %ebx
    movl \offset, %edx
    andl $0x0000ffff, %edx
    orl %ebx, %edx
    movl %edx, (%edi)

    movl \base, %ebx
    andl $0x00ff0000, %ebx
    shrl $16, %ebx
    movl %ebx, %edx
    movl \base, %ebx
    andl $0xff000000, %ebx
    orl %ebx, %edx
    movl \offset, %ebx
    andl $0x000f0000, %ebx
    orl %ebx, %edx
    movl \attr, %ebx
    andl $0x0000fff0ff, %ebx
    shll $8, %ebx
    orl %ebx, %edx
    movl %edx, 4(%edi)
.endm

# %edi is address, %ebx, %edx is temp
.macro setup_idt num, offset
    pushl %edi
    movl \num, %ebx
    shll $3, %ebx
    addl %ebx, %edi

    # attr = 0x8e00(P=1,DPL=00,D=1)
    movl $INT_HANDLER_SELECTOR, %edx
    shll $16, %edx
    movl \offset, %ebx
    andl $0x0000ffff, %ebx
    orl %ebx, %edx
    movl %edx, (%edi)

    movl \offset, %edx
    andl $0xffff0000, %edx
    orl $0x8e00, %edx
    movl %edx, 4(%edi)

    popl %edi
.endm

.macro read_sector add, sector, count
    movb $0x02, %ah
    movb \count, %al
    movb $0x00, %ch
    movb \sector, %cl
    movb $0x00, %dh
    movb $0x00, %dl
    movw \add, %bx
    int $0x13
.endm

