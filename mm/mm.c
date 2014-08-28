#include "headers.h"

unsigned long HIGH_MEMORY = 0;
unsigned char mem_map[PAGING_PAGES] = {0};

void mem_init(unsigned long mem_start, unsigned long mem_end)
{
    int i = 0;

    HIGH_MEMORY = mem_end;

    for (i = 0; i < PAGING_PAGES; ++i) {
        mem_map[i] = PAGING_USED;
    }

    i = MAP_NR(mem_start);
    mem_end -= mem_start;
    mem_end >>= 12;
    while (mem_end-- > 0) {
        mem_map[i++] = 0;
    }
}

