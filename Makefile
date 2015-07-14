
CC=gcc
CPP=g++
CFLAGS= 
LDFLAGS=-lpthread
DEBUG?=0

TARGET=dnn-sim
SRC=src
OBJ=obj


CPP_FILES=$(wildcard $(SRC)/*.cpp)
OBJ_FILES=$(addprefix $(OBJ)/,$(notdir $(CPP_FILES:.cpp=.o)))

ifeq ($(DEBUG), 1)
	CFLAGS+=-g
else
	CFLAGS+=-O3
endif

all: dir $(TARGET)

dir:
	@mkdir -p $(OBJ)

$(OBJ)/%.o: $(SRC)/%.cpp
	$(CPP) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJ_FILES)
	$(CPP) -o $@ $^ $(LDFLAGS)

clean:
	rm -rf $(TARGET) $(OBJ) *~
