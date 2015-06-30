
CC=gcc
CPP=g++
CFLAGS=
LDFLAGS=
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
	@rm -rf $(OBJ)
	@mkdir -p $(OBJ)

$(OBJ)/%.o: $(SRC)/%.cpp
	$(CPP) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJ_FILES)
	$(CPP) $(LDFLAGS) -o $@ $^

clean:
	rm -rf $(TARGET) $(OBJ) *~
