# $Id: Makefile,v 1.2 2004/10/12 09:06:17 marquet Exp $
##############################################################################

ROOTDIR=.
DIR=.

CC	= gcc
CFLAGS	= -Wall
CFLAGS  += -ansi
CFLAGS  += -pedantic
CFLAGS  += -g
LIBDIR  = $(ROOTDIR)/lib
INCDIR  = -I$(ROOTDIR)/include
LIBS    = -L$(LIBDIR) -lhardware

###------------------------------
### Main targets
###------------------------------------------------------------
BINARIES= vm
OBJECTS	= $(addsuffix .o,\
	  drive mbr)

all: $(BINARIES) $(OBJECTS)


###------------------------------
### Main rules
###------------------------------------------------------------
drive.o: drive.c drive.h mbr.h
	$(CC) $(CFLAGS) -c drive.c $(INCDIR)
mkhd.o:mkhd.c
	$(CC) $(CFLAGS) -c mkhd.c $(INCDIR)
mbr.o: drive.h mbr.h mbr.c
	$(CC) $(CFLAGS) -c mbr.c $(INCDIR)
vm.o: vm.c mbr.h drive.h
	$(CC) $(CFLAGS) -c vm.c $(INCDIR)


drive: drive.o mbr.o
	$(CC) $(CFLAGS) -o drive drive.o mbr.o $(LIBS)
mkhd:mkhd.o
	$(CC) $(CFLAGS) -o mkhd mkhd.o $(LIBS)
mbr:mbr.o drive.o
	$(CC) $(CFLAGS) -o mbr mbr.o drive.o $(LIBS)
vm:vm.o drive.o mbr.o
	$(CC) $(CFLAGS) -o vm vm.o drive.o mbr.o $(LIBS)

###------------------------------
### Misc.
###------------------------------------------------------------
.PHONY: clean realclean depend
clean:
	$(RM) *~ *# *.o $(BINARIES)
realclean: clean
	$(RM) vdiskA.bin vdiskB.bin

