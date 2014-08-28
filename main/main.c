/*
 * main initialize function for kernel
 */

#include "headers.h"

static int buffer_memory_start  = 0x100000;     /* 1M */
static int buffer_memory_end    = 0x400000;     /* 4M */
static int main_memory_start    = 0x400000;     /* 4M */
static int main_memory_end      = 0x1000000;    /* 16M */

void main(void)
{
    mem_init(main_memory_start, main_memory_end);
}

