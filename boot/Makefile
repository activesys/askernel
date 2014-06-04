#
# Makefile for boot
#

AS = as
LD = ld
OBJCOPY = objcopy

# target
all: boot.image

# implicit rules
%o:%s
	$(AS) -o $@ $<

# rules
boot.image: boot.o
	$(LD) -Ttext 0x00 -o boot.bin boot.o
	$(OBJCOPY) -O binary boot.bin boot.image

clean:
	rm -f boot.o boot.bin boot.image
