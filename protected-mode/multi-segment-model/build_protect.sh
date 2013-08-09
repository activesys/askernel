#!/bin/sh

# build protect
as -o protect.o protect.s
ld -Ttext 0x7c00 -o protect protect.o
objcopy -O binary protect protect.bin
dd if=protect.bin of=protect.img count=1
chmod -x protect.img
rm -f protect protect.o protect.bin
