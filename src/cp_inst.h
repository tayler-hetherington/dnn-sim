////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// cp_inst.h
// Control Processor Instructions
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __CP_INST_H__
#define __CP_INST_H__

#include "common.h"

#include "dnn_sim.h"
#include "dram_interface.h"
#include "config.h"
#include "option_parser.h"


enum MEMORY_OP {
    NOP = 0,
    MEM_LOAD = 1,
    MEM_READ = 2,
    MEM_STORE = 3,
    MEM_WRITE = 4
};


enum NFU_OP {
    MULT = 0,
    ADD = 1,
    SIGMOID = 2
};

// TODO: Add to the state when necessary
enum CP_INST_STATE {
    LOAD_NBIN = 0,
    LOAD_SB,
    DO_OP,
    STORE_NBOUT
};

// Control processor instruction format taken from Table 4 of DianNao paper
class cp_inst {
public:
    CP_INST_STATE   m_state;
    
    
    // SB
    MEMORY_OP   sb_read_op;
    bool        sb_reuse;
    mem_addr    sb_addr;
    unsigned    sb_size;
    
    // NBin
    MEMORY_OP   nbin_read_op;
    bool        nbin_resuse;
    unsigned    nbin_stride;
    unsigned    nbin_stride_begin;
    unsigned    nbin_stride_end;
    mem_addr    nbin_addr;
    unsigned    nbin_size;
    
    // NBout
    MEMORY_OP   nbout_read_op;
    MEMORY_OP   nbout_write_op;
    mem_addr    nbout_addr;
    unsigned    nbout_size;
    
    // NFU
    NFU_OP      nfu1_op;
    NFU_OP      nfu2_op;

    // NFU-2 IN = RESET/NBOUT
    // NFU-2 OUT = NBOUT/NFU3
    
    NFU_OP      nfu3_op;
    unsigned    output_begin;
    unsigned    output_end;
    
};

#endif //__CP_INST_H__
