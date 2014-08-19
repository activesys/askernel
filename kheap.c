#include "kheap.h"

static uint32_t find_smallest_hole(uint32_t size, uint8_t page_align, heap_t* heap)
{
    uint32_t i = 0;
    while (i < heap->index.size) {
        header_t* header = (header_t*)lookup_ordered_array(i, &heap->index);
        if (page_align > 0) {
            uint32_t location = (uint32_t)header;
            int32_t offset = 0;
            if ((location+sizeof(header_t)) & 0xfffff000 != 0) {
                offset = 0x1000 - (location + sizeof(header_t)) % 0x1000;
            }
            int32_t hole_size = (int32_t)header->size - offset;
            if (hole_size >= (int32_t)size) {
                break;
            }
        } else if (header->size >= size) {
            break;
        }

        i++;
    }

    if (i == heap->index.size) {
        return -1;
    } else {
        return i;
    }
}

static int8_t header_less_than(void* a, void* b)
{
    return ((header_t*)a)->size < ((header_t*)b)->size ? 1 : 0;
}

heap_t* create_heap(uint32_t start, uint32_t end_addr, uint32_t max, uint8_t supervisor, uint8_t readonly)
{
    heap_t* heap = (heap_t*)kmalloc(sizeof(heap_t));

    heap->index = place_ordered_array((void*)start, HEAP_INDEX_SIZE, &header_less_than);
    start += sizeof(type_t) * HEAP_INDEX_SIZE;
    if (start & 0xfffff000 != 0) {
        start &= 0xfffff000;
        start += 0x1000;
    }

    heap->start_address = start;
    heap->end_address = end_addr;
    heap->max_address = max;
    heap->supervisor = supervisor;
    heap->readonly = readonly;

    header_t* hole = (header_t*)start;
    hole->size = end_addr-start;
    hole->magic = HEAP_MAGIC;
    hole->is_hole = 1;
    insert_ordered_array((void*)hole, &heap->index);
}


uint32_t placement_address = 0x107000;

uint32_t kmalloc(uint32_t size)
{
    uint32_t tmp = placement_address;
    placement_address += size;
    return tmp;
}

uint32_t kmalloc_a(uint32_t size)
{
    uint32_t tmp = 0;

    if (placement_address & 0x0fff) {
        placement_address &= 0xfffff000;
        placement_address += 0x1000; 
    }

    tmp = placement_address;
    placement_address += size;
    return tmp;
}

uint32_t kmalloc_p(uint32_t size, uint32_t* phys)
{
    uint32_t tmp = 0;

    if (phys) {
        *phys = placement_address;
    }

    tmp = placement_address;
    placement_address += size;
    return tmp;
}

uint32_t kmalloc_ap(uint32_t size, uint32_t* phys)
{
    uint32_t tmp = 0;

    if (placement_address & 0x0fff) {
        placement_address &= 0xfffff000;
        placement_address += 0x1000;
    }

    if (phys) {
        *phys = placement_address;
    }

    tmp = placement_address;
    placement_address += size;
    return tmp;
}
