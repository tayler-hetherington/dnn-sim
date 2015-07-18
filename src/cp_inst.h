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

#include <iostream>
#include <string>



class cp_inst {
  public:

    // TODO: Add to the state when necessary
    enum cp_inst_state {
      LOAD_NBIN = 0,
      LOAD_SB,
      DO_OP,
      STORE_NBOUT
    };

    cp_inst_state   m_state;

    enum cp_inst_op {
      NOP,
      LOAD,
      STORE,
      READ,
      WRITE,
      MULT,
      ADD,
      RESET,
      NBOUT,
      NFU3,
      SIGMOID,
      INVALID
    };

    cp_inst_op      cp_end; 
    cp_inst_op      sb_read_op;
    int             sb_reuse;
    int             sb_address;
    int             sb_size;
    cp_inst_op      nbin_read_op;
    int             nbin_reuse;
    int             nbin_stride;
    int             nbin_stride_begin;
    int             nbin_stride_end;
    int             nbin_address;
    int             nbin_size;
    cp_inst_op      nbout_read_op;
    cp_inst_op      nbout_write_op;
    int             nbout_address;
    int             nbout_size;
    cp_inst_op      nfu_nfu1_op;
    cp_inst_op      nfu_nfu2_op;
    cp_inst_op      nfu_nfu2_in;
    cp_inst_op      nfu_nfu2_out;
    cp_inst_op      nfu_nfu3_op;
    int             nfu_output_begin;
    int             nfu_output_end;
};

// cp_inst_op serializer functions
std::ostream& operator<<( std::ostream& oss, const cp_inst::cp_inst_op op );
std::istream& operator>>( std::istream &is, cp_inst::cp_inst_op& op );
// cp_inst serializer functions
std::ostream& operator<<( std::ostream& oss, const cp_inst& ins );
std::istream & operator>>( std::istream& is, cp_inst& ins );

#endif //__CP_INST_H__
