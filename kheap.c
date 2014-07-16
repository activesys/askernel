#include "kheap.h"

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
