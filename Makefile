#
# Makefile for askernel.
#

CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -g -std=gnu99 -ffreestanding -Wall -Wextra
ASFLAGS = -g
LD = i686-elf-ld
LDFLAGS = -g -ffreestanding -nostdlib
MKISO = grub-mkrescue
ISODIR = isodir
ISOBOOT = $(ISODIR)/boot
MV = mv

askernel.iso: askernel.img
	$(MV) askernel.img $(ISOBOOT)
	$(MKISO) -o askernel.iso $(ISODIR)

MAIN = main/main.a
OBJS = setup.o $(MAIN)

$(MAIN):
	(cd main; make)

askernel.img: $(OBJS) askernel.lds
	$(CC) $(LDFLAGS) -T askernel.lds -o askernel.img $(OBJS) -lgcc

all: askernel.iso

iso: askernel.iso

img: askernel.img

clean:
	rm -f *.o *.img *.iso $(ISOBOOT)/*.img
	(cd main; make clean)

remake:
	make clean; make

