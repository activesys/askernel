#include "isr.h"
#include "monitor.h"

static isr_t interrupt_handlers[256];

void isr_handler(registers_t regs)
{
    monitor_write("received interrupt: ");
    monitor_write_hex(regs.int_no);
    monitor_put('\n');

    if (interrupt_handlers[regs.int_no] != 0) {
        isr_t handler = interrupt_handlers[regs.int_no];
        handler(regs);
    }

    if (regs.int_no == 13) {
        monitor_write("gp error : ");
        monitor_write_hex(regs.err_code);
        monitor_write("\n");
    }
}

void irq_handler(registers_t regs)
{
    if (regs.int_no >= 40) {
        outb(0xa0, 0x20);
    }
    outb(0x20, 0x20);

    if (interrupt_handlers[regs.int_no] != 0) {
        isr_t handler = interrupt_handlers[regs.int_no];
        handler(regs);
    }
}

void register_interrupt_handler(uint8_t n, isr_t handler)
{
    interrupt_handlers[n] = handler;
}

