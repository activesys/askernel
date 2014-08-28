#
# Makefile for askernel.
#

CC = i686-elf-gcc
AS = i686-elf-as
CPPFLAGS = -I include
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
MM	 = mm/mm.a
OBJS = setup.o $(MAIN) $(MM)

$(MAIN):
	(cd main; make)
$(MM):
	(cd mm; make)

askernel.img: $(OBJS) askernel.lds
	$(CC) $(LDFLAGS) -T askernel.lds -o askernel.img $(OBJS) -lgcc

all: askernel.iso

iso: askernel.iso

img: askernel.img

clean:
	rm -f *.o *.img *.iso $(ISOBOOT)/*.img
	(cd main; make clean)
	(cd mm; make clean)

remake:
	make clean; make

