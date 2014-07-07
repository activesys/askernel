#ifndef __COMMON_H__
#define __COMMON_H__

typedef unsigned char   uint8_t;
typedef char            int8_t;
typedef unsigned short  uint16_t;
typedef short           int16_t;
typedef unsigned int    uint32_t;
typedef int             int32_t;

void outb(uint16_t port, uint8_t value);
uint8_t inb(uint16_t port);
uint16_t inw(uint16_t port);

#endif /* __COMMON_H__ */
