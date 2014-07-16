.set ALIGN,     1<<0
.set MEMINFO,   1<<1
.set FLAGS,     ALIGN|MEMINFO
.set MAGIC,     0x1badb002
.set CHECKSUM,  -(MAGIC + FLAGS)

.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

.global stack_top, stack_bottom 
.section .bootstrap_stack, "aw", @nobits
stack_bottom:
.skip 4096
stack_top:  

.section .text
.global _start
.type _start, @function
_start:
    movl $stack_top, %esp
    pushl %ebx              # push mulitboot header pointer into stack.
    cli
    call kernel_main
    hlt
.lhang:
    jmp .lhang

.size _start, . - _start
