#ifndef __KHEAP_H__
#define __KHEAP_H__

#include "common.h"
#include "ordered_array.h"

#define KHEAP_START         0xc0000000
#define KHEAP_INITIAL_SIZE  0x100000
#define HEAP_INDEX_SIZE     0x020000
#define HEAP_MAGIC          0x123890ab
#define HEAP_MIN_SIZE       0x07000

typedef struct _header {
    uint32_t    magic;
    uint8_t     is_hole;
    uint32_t    size;
} header_t;

typedef struct _footer {
    uint32_t    magic;
    header_t*   header;
} footer_t;

typedef struct _heap {
    ordered_array_t index;
    uint32_t        start_address;
    uint32_t        end_address;
    uint32_t        max_address;
    uint8_t         supervisor;
    uint8_t         readonly;
} heap_t;

heap_t* create_heap(uint32_t start, uint32_t end, uint32_t max, uint8_t supervisor, uint8_t readonly);
void* alloc(uint32_t size, uint8_t page_align, heap_t* heap);
void free(void* p, heap_t* heap);

extern uint32_t placement_address;

uint32_t kmalloc(uint32_t size);
uint32_t kmalloc_a(uint32_t size);
uint32_t kmalloc_p(uint32_t size, uint32_t* phys);
uint32_t kmalloc_ap(uint32_t size, uint32_t* phys);

#endif /* __KHEAP_H__ */
