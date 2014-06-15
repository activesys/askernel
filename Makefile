#
# Makefile for askernel.
#

DD = dd

all: askernel.image

# Build boot.image
boot/boot.image:
	cd boot; make
boot/head.image:
	cd boot; make

askernel.image: boot/boot.image
	$(DD) if=boot/boot.image of=askernel.image count=1
	$(DD) if=boot/head.image of=askernel.image count=80 seek=1

clean:
	cd boot; make clean
	rm -f askernel.image

remake:
	make clean; make

