#ifndef __DESCRIPTOR_TABLES_H__
#define __DESCRIPTOR_TABLES_H__

#include "common.h"

struct _gdt_entry {
    uint16_t    limit_low;
    uint16_t    base_low;
    uint8_t     base_middle;
    uint8_t     access;
    uint8_t     granularity;
    uint8_t     base_high;
}__attribute__((packed));
typedef struct _gdt_entry   gdt_entry_t;

struct _gdt_ptr {
    uint16_t    limit;
    uint32_t    base;
}__attribute__((packed));
typedef struct _gdt_ptr     gdt_ptr_t;

struct _idt_entry {
    uint16_t    base_low;
    uint16_t    selector;
    uint8_t     reserved;
    uint8_t     flags;
    uint16_t    base_high;
}__attribute__((packed));
typedef struct _idt_entry   idt_entry_t;

struct _idt_ptr {
    uint16_t    limit;
    uint32_t    base;
}__attribute__((packed));
typedef struct _idt_ptr     idt_ptr_t;

void init_descriptor_tables();

extern void isr0();
extern void isr1();
extern void isr2();
extern void isr3();
extern void isr4();
extern void isr5();
extern void isr6();
extern void isr7();
extern void isr8();
extern void isr9();
extern void isr10();
extern void isr11();
extern void isr12();
extern void isr13();
extern void isr14();
extern void isr15();
extern void isr16();
extern void isr17();
extern void isr18();
extern void isr19();
extern void isr20();
extern void isr21();
extern void isr22();
extern void isr23();
extern void isr24();
extern void isr25();
extern void isr26();
extern void isr27();
extern void isr28();
extern void isr29();
extern void isr30();
extern void isr31();
extern void isr22();

#endif /* __DESCRIPTOR_TABLES_H__ */