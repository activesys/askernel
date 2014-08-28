#
# Makefile for mm.
#

AR = i686-elf-ar
CC = i686-elf-gcc
AS = i686-elf-as
CPPFLAGS = -I ../include
CFLAGS = -g -std=gnu99 -ffreestanding -Wall -Wextra
ASFLAGS = -g
ARFLAGS = rcs
MV = mv

%.a:%.o
	$(AR) $(ARFLAGS) $@ $<

OBJS = mm.o

mm.a: $(OBJS)

all: mm.a

clean:
	rm -f *.o *.a 

remake:
	make clean; make

