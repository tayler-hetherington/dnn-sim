
CC=gcc
CPP=g++
CFLAGS= 
DRAM_SIM=./DRAMSim2/
LDFLAGS=-lpthread -ldramsim -Wl,-rpath=$(DRAM_SIM)
DEBUG?=0

TARGET=dnn-sim
SRC=src
OBJ=obj

CPP_FILES=$(wildcard $(SRC)/*.cpp)
OBJ_FILES=$(addprefix $(OBJ)/,$(notdir $(CPP_FILES:.cpp=.o)))
DEP_FILES=$(addprefix $(OBJ)/,$(notdir $(CPP_FILES:.cpp=.d)))

ifeq ($(DEBUG), 1)
	CFLAGS+=-g
else
	CFLAGS+=-O3
endif


all: dir DRAMSim $(TARGET)

dir:
	@mkdir -p $(OBJ)

$(OBJ)/%.o: $(SRC)/%.cpp
	$(CPP) $(CFLAGS) -I$(DRAM_SIM) -MMD -c $< -o $@

DRAMSim:
	@echo "Building DRAMSim"
	make -C DRAMSim2/ 
	make libdramsim.so -C DRAMSim2/

$(TARGET): $(OBJ_FILES)
	$(CPP) -o $@ $^ $(LDFLAGS) -L$(DRAM_SIM) 


clean:
	rm -rf $(TARGET) $(OBJ) *~
	make clean -C DRAMSim2/


-include $(DEP_FILES)
