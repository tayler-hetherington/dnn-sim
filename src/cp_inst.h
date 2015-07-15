////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// cp_inst.h
// Control Processor Instruction
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __CP_INST_H__
#define __CP_INST_H__

#include "common.h"


enum READ_OP {
    NOP = 0,
    LOAD = 1,
    READ = 2
};

enum WRITE_OP {
    NOP = 0,
    STORE = 1,
    WRITE = 2
};

enum NFU_OP {
    MULT = 0,
    ADD = 1,
    SIGMOID = 2
};

// Control processor instruction format taken from Table 4 of DianNao paper
class cp_inst {
    
    // SB
    READ_OP     sb_read_op;
    bool        sb_reuse;
    mem_addr    sb_addr;
    unsigned    sb_size;
    
    // NBin
    READ_OP     nbin_read_op;
    bool        nbin_resuse;
    unsigned    nbin_stride;
    unsigned    nbin_stride_begin;
    unsigned    nbin_stride_end;
    mem_addr    nbin_addr;
    unsigned    nbin_size;
    
    // NBout
    READ_OP     nbout_read_op;
    WRITE_OP    nbout_write_op;
    mem_addr    nbout_addr;
    unsigned    nbout_size;
    
    // NFU
    NFU_OP      nfu1_op;
    NFU_OP      nfu2_op;

    // NFU-2 IN == RESET/NBOUT
    // NFU-2 OUT == NBOUT/NFU3
    
    NFU_OP      nfu3_op;
    unsigned    output_begin;
    unsigned    output_end;
    
};

#endif