#
# Makefile for boot
#

AS = as
LD = ld
OBJCOPY = objcopy

# target
all: boot.image head.image

# implicit rules
%o:%s
	$(AS) -o $@ $<

# rules
boot.image: boot.o
	$(LD) -Ttext 0x00 -o boot.bin boot.o
	$(OBJCOPY) -O binary boot.bin boot.image
# rules
head.image: head.o
	$(LD) -Ttext 0x00 -o head.bin head.o
	$(OBJCOPY) -O binary head.bin head.image

clean:
	rm -f *.o *.bin *.image
