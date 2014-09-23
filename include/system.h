#ifndef __SYSTEM_H__
#define __SYSTEM_H__

#define __set_gate(gate_addr, type, dpl, addr)\
    __asm__("movw %%dx, %%ax\r\n"\
            "movw %0, %%dx\r\n"\
            "movl %%eax, %1\r\n"\
            "movl %%edx, %2\r\n"\
            :\
            : "i" ((short)(0x8000+(dpl<<13)+(type<<8))),\
              "o" (*((char*)(gate_addr))),\
              "o" (*(4+(char*)(gate_addr))),\
              "d" ((char*)(addr)),\
              "a" ((char*)(0x00080000))

#define __set_intr_gate(n, addr)\
    __set_gate(&idt[n], 14, 0, addr)
#define __set_trap_gate(n, addr)\
    __set_gate(&idt[n], 15, 0, addr)
#define __set_system_gate(n, addr)\
    __set_gate(&idt[n], 15, 3, addr)

#endif /* __SYSTEM_H__ */

