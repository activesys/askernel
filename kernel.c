#if !defined(__cplusplus)
#include <stdbool.h>
#endif
#include <stddef.h>

#include "common.h"
#include "monitor.h"
#include "descriptor_tables.h"
#include "timer.h"

#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble."
#endif

#if !defined(__i386__)
#error "This kernel needs to be compiled with x86-elf compiler."
#endif

#if defined(__cplusplus)
extern "C"
#endif
void kernel_main()
{
    monitor_clear();
    monitor_write("Hello ASKernel\n");
    monitor_write("Hello World!\n");
    monitor_write_hex(0x01234567);
    monitor_write("\n");
    monitor_write_hex(0x89abcdef);
    monitor_write("\n");
    monitor_write_dec(0xffffffff);
    monitor_write("\n");
    monitor_write_dec(189064);
    monitor_write("\n");

    init_descriptor_tables();

    __asm__ __volatile__("int $0x03");
    __asm__ __volatile__("int $0x04");

    init_timer(50);

    __asm__ __volatile__("sti");
}
