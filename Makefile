#
# Makefile for askernel.
#

CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
ASFLAGS =
LD = i686-elf-gcc
LDFLAGS = -ffreestanding -O2 -nostdlib

%o%c:
	$(CC) $(CFLAGS) -o $@ $<

%o%s:
	$(AS) $(ASFLAGS) -o $@ $<

all: askernel.image

askernel.image: boot.o kernel.o linker.ld
	$(LD) $(LDFLAGS) -T linker.ld -o askernel.image boot.o kernel.o -lgcc

clean:
	rm -f *.o askernel.image

remake:
	make clean; make

