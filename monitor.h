#ifndef __MONITOR_H__
#define __MONITOR_H__

#include "common.h"

void monitor_put(char c);
void monitor_clear();
void monitor_write(char* s);
void monitor_write_hex(uint32_t n);
void monitor_write_dec(uint32_t n);

#endif /* __MONITOR_H__ */
