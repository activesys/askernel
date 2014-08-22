/*
 * main initialize function for kernel
 */

static int main_memory_start = 0x200000;     /* 2M */
static int main_memory_end   = 0x1000000;    /* 16M */

void main(void)
{
    main_memory_start = 0;
    main_memory_end = 0;
}

