
CC=gcc
CPP=g++
CFLAGS= 
LDFLAGS=-lpthread
DEBUG?=0

CLASSIFY=classify
SRC=src
OBJ=../obj

ifeq ($(DEBUG), 1)
	CFLAGS+=-g
else
	CFLAGS+=-O3
endif


all: $(CLASSIFY).o
	$(CPP) -o classify ../obj/cp_inst.o classify.o $(LDFLAGS)

$(CLASSIFY).o: classify.cpp
	$(CPP) -c -o $@ $^ $(LDFLAGS)

clean:
	rm -rf $(TARGET) $(OBJ) *~


-include $(DEP_FILES)
