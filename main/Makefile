#
# Makefile for main.
#

AR = i686-elf-ar
CC = i686-elf-gcc
AS = i686-elf-as
CFLAGS = -g -std=gnu99 -ffreestanding -Wall -Wextra
ASFLAGS = -g
ARFLAGS = rcs
MV = mv

%.a:%.o
	$(AR) $(ARFLAGS) $@ $<

OBJS = main.o

main.a: $(OBJS)

all: main.a

clean:
	rm -f *.o *.a 

remake:
	make clean; make

