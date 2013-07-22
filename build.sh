#!/bin/sh
# $1 - input file must .s
if [ $# -ne 1 ]
then
    echo "We need a asm file to build."
    exit -1
fi

filename=${1%.*}
suffix=${1##*.}
if [ $suffix != "s" ]
then
    echo "We need a .s file to build."
    exit -2
fi

# build boot
as -o boot.o boot.s
ld -Ttext 0x7c00 -o boot boot.o
objcopy -O binary boot boot.bin
dd if=boot.bin of=boot.img count=1
chmod -x boot.img
#rm -f boot boot.o boot.bin

# build lib
#as -o lib.o lib.s
as -o $filename.o $1
ld -Ttext 0x600 -o $filename $filename.o #lib.o
objcopy -O binary $filename $filename.bin
dd if=$filename.bin of=boot.img count=1 seek=1
#rm -f lib.o $filename.o $filename $filename.bin

exit 0

