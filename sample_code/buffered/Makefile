CC=g++
CFLAGS=-I.
EXES=conv

ifeq ($(DEBUG),1)
	CFLAGS+=-O0 -g
endif

all: $(EXES)

$(LAYER): $(TYPE).cpp $(LAYER).h
		$(CC) -o $@ $(filter %.cpp, $^) $(CFLAGS)

conv: conv.cpp  
		$(CC) -o $@ $(filter %.cpp, $^) $(CFLAGS)

clean:
	rm -f *.o $(EXES)
