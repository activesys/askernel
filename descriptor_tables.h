#ifndef __DESCRIPTOR_TABLES_H__
#define __DESCRIPTOR_TABLES_H__

#include "common.h"

struct gdt_entry {
    uint16_t    limit_low;
    uint16_t    base_low;
    uint8_t     base_middle;
    uint8_t     access;
    uint8_t     granularity;
    uint8_t     base_high;
}__attribute__((packed));
typedef struct gdt_entry gdt_entry_t;

struct gdt_ptr {
    uint16_t    limit;
    uint32_t    base;
}__attribute__((packed));
typedef struct gdb_ptr_t;

void init_descriptor_tables();

#endif /* __DESCRIPTOR_TABLES_H__ */
