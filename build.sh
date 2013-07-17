#!/bin/sh
as -o boot.o boot.s
objcopy -O binary boot.o boot.bin
dd if=boot.bin of=boot.img count=1 skip=62

