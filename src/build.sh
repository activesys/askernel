#!/bin/sh

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
chmod -x boot.img
rm -f boot boot.o boot.bin

as -o head.o head.s
ld -Ttext 0x00 -o head head.o
objcopy -O binary head head.bin
dd if=head.bin of=boot.img count=20 seek=1
rm -f head.o head head.bin

exit 0

