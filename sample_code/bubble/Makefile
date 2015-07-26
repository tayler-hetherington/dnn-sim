CC=g++
CFLAGS=-I. -std=c++0x
EXES=conv

ifeq ($(DEBUG),1)
	CFLAGS+=-O0 -g
endif

all: $(EXES)

$(LAYER): $(TYPE).cpp $(LAYER).h
		$(CC) -o $@ $(filter %.cpp, $^) $(CFLAGS)

conv: conv.cpp config.h 
		$(CC) -o $@ $(filter %.cpp, $^) $(CFLAGS)

clean:
	rm -f *.o $(EXES)
