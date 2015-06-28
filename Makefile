
CC = gcc
CPP = g++
CFLAGS=
DEBUG?=0

TARGET=dnn-sim

ifeq ($(DEBUG), 1)
	CFLAGS = -g
else
	CFLAGS = -O3
endif

all: $(TARGET)


$(TARGET): 

clean: 
	rm -rf $(TARGET) *~ *.o
