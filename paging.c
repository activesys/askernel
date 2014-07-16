#include "monitor.h"
#include "paging.h"
#include "kheap.h"

uint32_t* frames;
uint32_t  nframes;

#define INDEX_FROM_BIT(a)   ((a)/(8*4))
#define OFFSET_FROM_BIT(a)  ((a)%(8*4))

static void set_frame(uint32_t frame_addr)
{
    uint32_t frame = frame_addr / 0x1000;
    uint32_t index = INDEX_FROM_BIT(frame);
    uint32_t offset = OFFSET_FROM_BIT(frame);
    frames[index] |= (0x01u << offset);
}

static void clear_frame(uint32_t frame_addr)
{
    uint32_t frame = frame_addr / 0x1000;
    uint32_t index = INDEX_FROM_BIT(frame);
    uint32_t offset = OFFSET_FROM_BIT(frame);
    frames[index] &= ~(0x01 << offset);
}

static uint32_t test_frame(uint32_t frame_addr)
{
    uint32_t frame = frame_addr / 0x1000;
    uint32_t index = INDEX_FROM_BIT(frame);
    uint32_t offset = OFFSET_FROM_BIT(frame);
    return frames[index] & (0x01 << offset);
}

static uint32_t first_frame()
{
    uint32_t i, j;
    for (i = 0; i < INDEX_FROM_BIT(nframes); ++i) {
        if (frames[i] != 0xffffffff) {
            for (j = 0; j < 32; ++j) {
                uint32_t test = 0x1 << j;
                if (!(frames[i] & test)) {
                    return i*4*8 + j;
                }
            }
        }
    }

    return (uint32_t)-1;
}

void alloc_frame(page_t* page, int is_kernel, int is_writeable)
{
    if (page->frame != 0) {
        return;
    } else {
        uint32_t index = first_frame();
        if (index != (uint32_t)-1) {
            set_frame(index * 0x1000);
            page->present = 1;
            page->rw = (is_writeable) ? 1 : 0;
            page->user = (is_kernel) ? 1 : 0;
            page->frame = index;
        }
    }
}

void free_frame(page_t* page)
{
    uint32_t frame = 0;
    if (!(frame = page->frame)) {
        return;
    } else {
        clear_frame(frame);
        page->frame = 0x00;
    }
}

void init_paging()
{
    uint32_t i = 0;
    page_directory_t* kernel_directory = 0;

    uint32_t mem_end_page = 0x01000000;
    nframes = mem_end_page / 0x1000;
    frames = (uint32_t*)kmalloc(INDEX_FROM_BIT(nframes));

    for (i = 0; i < INDEX_FROM_BIT(nframes); ++i) {
        frames[i] = 0x00;
    }

    kernel_directory = (page_directory_t*)kmalloc_a(sizeof(page_directory_t));
    for (i = 0; i < sizeof(page_directory_t); ++i) {
        ((uint8_t*)(kernel_directory))[i] = 0x00;
    }

    /* from 1M address */
    i = 0x00;
    while (i < placement_address) {
        alloc_frame(get_page(i, 1, kernel_directory), 0, 0);
        i += 0x1000;
    }

    register_interrupt_handler(14, page_fault);

    switch_page_directory(kernel_directory);
}

page_t* get_page(uint32_t address, int make, page_directory_t* dir)
{
    address /= 0x1000;

    uint32_t index = address / 1024;
    if (dir->tables[index]) {
        return &dir->tables[index]->pages[address % 1024];
    } else if (make) {
        uint32_t tmp;
        dir->tables[index] = (page_table_t*)kmalloc_ap(sizeof(page_table_t), &tmp);
        uint32_t i = 0;
        for (i = 0; i < 4096; ++i) {
            ((uint8_t*)(dir->tables[index]))[i] = 0x00;
        }
        dir->tables_physical[index] = tmp | 0x07;
        return &dir->tables[index]->pages[address % 1024];
    } else {
        return 0;
    }
}

void switch_page_directory(page_directory_t* dir)
{
    uint32_t cr0;
    __asm__ __volatile__("movl %0, %%cr3" :: "r"(dir->tables_physical));
    __asm__ __volatile__("movl %%cr0, %0" : "=r"(cr0));
    cr0 |= 0x80000000;
    __asm__ __volatile__("movl %0, %%cr0" :: "r"(cr0));
}

void page_fault(registers_t regs)
{
    uint32_t faulting_address;
    __asm__ __volatile__("movl %%cr2, %0" : "=r"(faulting_address));

    int present = !(regs.err_code & 0x01);
    int rw = regs.err_code & 0x02;
    int us = regs.err_code & 0x04;
    int reserved = regs.err_code & 0x08;
    int id = regs.err_code & 0x10;

    monitor_write("Page Fault! ( ");
    if (present) {
        monitor_write("present ");
    }
    if (rw) {
        monitor_write("read-only ");
    }
    if (us) {
        monitor_write("user-mode ");
    }
    if (reserved) {
        monitor_write("reserved ");
    }
    if (id) {
        monitor_write("id ");
    }
    monitor_write(") at");
    monitor_write_hex(faulting_address);
    monitor_write("\n");
}
