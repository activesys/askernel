#ifndef __KHEAP_H__
#define __KHEAP_H__

#include "common.h"

extern uint32_t placement_address;

uint32_t kmalloc(uint32_t size);
uint32_t kmalloc_a(uint32_t size);
uint32_t kmalloc_p(uint32_t size, uint32_t* phys);
uint32_t kmalloc_ap(uint32_t size, uint32_t* phys);

#endif /* __KHEAP_H__ */
