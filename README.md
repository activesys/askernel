askernel
========

学习kernel写的一些代码

kernel的内存映射结构

内存布局, 16M以后的内存都没有用到

+----------------+ <-- 0x1000000(16M) (main memory end)
|                |
|                |
|                |
|                |
+----------------+ <-- 0x200000(2M) (kernel code end, main memory start)
|                |
+----------------+ <-- 0x7000 _start (kernel code start)
|                |
+----------------+ <-- 0x6000 stack_bottom, idt/gdt
|                |
+----------------+ <-- 0x5000 stack_top
|                |
+----------------+ <-- 0x4000 paging_table_3
|                |
+----------------+ <-- 0x3000 paging_table_2
|                |
+----------------+ <-- 0x2000 paging_table_1
|                |
+----------------+ <-- 0x1000 paging_table_0
|                |
+----------------+ <-- 0x00 paging_dir


