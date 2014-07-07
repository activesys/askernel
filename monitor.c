#include "monitor.h"
#include "common.h"


static uint16_t cursor_x = 0;
static uint16_t cursor_y = 0;
static uint16_t* video_memory = 0x0b8000;

enum monitor_color {
    COLOR_BLACK = 0,
    COLOR_BLUE = 1,
    COLOR_GREEN = 2,
    COLOR_CYAN = 3,
    COLOR_RED = 4,
    COLOR_MAGENTA = 5,
    COLOR_BROWN = 6,
    COLOR_LIGHT_GREY = 7,
    COLOR_DARK_GREY = 8,
    COLOR_LIGHT_BLUE = 9,
    COLOR_LIGHT_GREEN = 10,
    COLOR_LIGHT_CYAN = 11,
    COLOR_LIGHT_RED = 12,
    COLOR_LIGHT_MAGENTA = 13,
    COLOR_LIGHT_BROWN = 14,
    COLOR_WHITE = 15,
};

static void move_cursor()
{
    uint16_t cursor_location = cursor_y * 80 + cursor_x;
    outb(0x3d4, 14);
    outb(0x3d5, cursor_location >> 8);
    outb(0x3d4, 14);
    outb(0x3d5, cursor_location);
}

static void scroll()
{
    uint8_t attr = (COLOR_BLACK << 4) | COLOR_WHITE;
    uint16_t blank = 0x20 | attr << 8;

    if (cursor_y >= 25) {
        int i = 0;
        for (i =  0; i < 24*80; ++i) {
            video_memory[i] = video_memory[i+80];
        }

        for (i = 24*80; i < 25*80; ++i) {
            video_memory[i] = blank;
        }

        cursor_y = 24;
    }
}

void monitor_put(char c)
{
    uint16_t attr = ((COLOR_BLACK << 4) | COLOR_WHITE) << 8;
    uint16_t* location = 0;

    if (c == 0x08 && cursor_x) {
        cursor_x--;
    } else if (c == 0x09) {
        cursor_x = (cursor_x + 8) & ~(8-1);
    } else if (c == 0x0d) {
        cursor_x = 0;
    } else if (c == 0x0a) {
        cursor_x = 0;
        cursor_y++;
    } else if (c >= 0x20) {
        location = video_memory + (cursor_y*80 + cursor_x);
        *location = c | attr;
        cursor_x++;
    }

    if (cursor_x >= 80) {
        cursor_x = 0;
        cursor_y++;
    }

    scroll();
    move_cursor();
}

void monitor_clear()
{
    uint8_t attr = (COLOR_BLACK << 4) | COLOR_WHITE;
    uint16_t blank = 0x20 | attr << 8;

    int i = 0;
    for (i = 0; i < 80*25; ++i) {
        video_memory[i] = blank;
    }

    cursor_x = cursor_y = 0;
    move_cursor();
}

void monitor_write(char* s)
{
    int i = 0;
    while (s[i]) {
        monitor_put(s[i++]);
    }
}
