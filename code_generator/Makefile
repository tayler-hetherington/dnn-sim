
CC=gcc
CPP=g++
CFLAGS= 
LDFLAGS=-lpthread
DEBUG?=0

TARGET=classify
SRC=.
OBJ=obj

CPP_FILES=$(wildcard *.cpp)
OBJ_FILES=$(addprefix $(OBJ)/,$(notdir $(CPP_FILES:.cpp=.o)))
DEP_FILES=$(addprefix $(OBJ)/,$(notdir $(CPP_FILES:.cpp=.d)))

ifeq ($(DEBUG), 1)
	CFLAGS+=-g
else
	CFLAGS+=-O3
endif


all: dir $(TARGET)

dir:
	@mkdir -p $(OBJ)

$(OBJ)/%.o: $(SRC)/%.cpp
	$(CPP) $(CFLAGS) -MMD -c $< -o $@

$(TARGET): $(OBJ_FILES) 
	$(CPP) -o $@ $^ ../obj/cp_inst.o $(LDFLAGS)

clean:
	rm -rf $(TARGET) $(OBJ) *~


-include $(DEP_FILES)
