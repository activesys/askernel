#ifndef __MM_H__
#define __MM_H__

#define LOW_MEMORY      0x100000
extern unsigned long    HIGH_MEMORY;

#define PAGING_MEMORY   (15*1024*1024)
#define PAGING_PAGES    (PAGING_MEMORY>>12)
#define MAP_NR(addr)    (((addr)-LOW_MEMORY)>>12)
#define PAGING_USED     100

extern unsigned char    mem_map[PAGING_PAGES];

void mem_init(unsigned long mem_start, unsigned long mem_end);

#endif /* __MM_H__ */

