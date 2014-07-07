#
# Makefile for askernel.
#

CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -std=gnu99 -ffreestanding -O2 -Wall -Wextra
ASFLAGS =
LD = i686-elf-gcc
LDFLAGS = -ffreestanding -O2 -nostdlib
MKISO = grub-mkrescue
ISODIR = isodir
ISOBOOT = $(ISODIR)/boot
MV = mv

%o%c:
	$(CC) $(CFLAGS) -o $@ $<

%o%s:
	$(AS) $(ASFLAGS) -o $@ $<

askernel.iso: askernel.img
	$(MV) askernel.img $(ISOBOOT)
	$(MKISO) -o askernel.iso $(ISODIR)

OBJS = boot.o common.o monitor.o kernel.o

askernel.img: $(OBJS) linker.ld
	$(LD) $(LDFLAGS) -T linker.ld -o askernel.img $(OBJS) -lgcc

all: askernel.iso

iso: askernel.iso

img: askernel.img

clean:
	rm -f *.o *.img *.iso $(ISOBOOT)/*.img

remake:
	make clean; make

