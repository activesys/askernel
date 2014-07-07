#if !defined(__cplusplus)
#include <stdbool.h>
#endif
#include <stddef.h>

#include "common.h"
#include "monitor.h"

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
    int i = 0;
    for (i = 0; i < 20; ++i) {
        monitor_write("Hello ASKernel\n");
        monitor_write("Hello World!\n");
    }
}
