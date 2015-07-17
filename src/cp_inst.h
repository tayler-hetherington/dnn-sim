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
std::ostream& operator<<( std::ostream& oss, const cp_inst::cp_inst_op op ) {
  switch (op) {
    case cp_inst::NOP:     oss << "NOP"; break;
    case cp_inst::LOAD:    oss << "LOAD"; break;
    case cp_inst::STORE:   oss << "STORE"; break;
    case cp_inst::READ:    oss << "READ"; break;
    case cp_inst::WRITE:   oss << "WRITE"; break;
    case cp_inst::MULT:    oss << "MULT"; break;
    case cp_inst::ADD:     oss << "ADD"; break;
    case cp_inst::RESET:   oss << "RESET"; break;
    case cp_inst::NBOUT:   oss << "NBOUT"; break;
    case cp_inst::NFU3:    oss << "NFU3"; break;
    case cp_inst::SIGMOID: oss << "SIGMOID"; break;
    case cp_inst::INVALID: oss << "INVALID"; break;
    default:      oss << "UNDEFINED"; break;
  }
  return oss;
}

std::istream& operator>>( std::istream &is, cp_inst::cp_inst_op& op ) {
  std::string str;
  is >> str;
  if      (str == "NOP")      op = cp_inst::NOP;
  else if (str == "LOAD")     op = cp_inst::LOAD;
  else if (str == "STORE")    op = cp_inst::STORE;
  else if (str == "READ")     op = cp_inst::READ;
  else if (str == "WRITE")    op = cp_inst::WRITE;
  else if (str == "MULT")     op = cp_inst::MULT;
  else if (str == "ADD")      op = cp_inst::ADD;
  else if (str == "RESET")    op = cp_inst::RESET;
  else if (str == "NBOUT")    op = cp_inst::NBOUT;
  else if (str == "NFU3")     op = cp_inst::NFU3;
  else if (str == "SIGMOID")  op = cp_inst::SIGMOID;
  else op = cp_inst::INVALID;
  return is;
}
// cp_inst serializer functions

std::ostream& operator<<( std::ostream& oss, const cp_inst& ins ) {
  oss << " | "  << ins.cp_end;
  oss << " || " << ins.sb_read_op;
  oss << " | "  << ins.sb_reuse;
  oss << " | "  << ins.sb_address;
  oss << " | "  << ins.sb_size;
  oss << " || " << ins.nbin_read_op;
  oss << " | "  << ins.nbin_reuse;
  oss << " | "  << ins.nbin_stride;
  oss << " | "  << ins.nbin_stride_begin;
  oss << " | "  << ins.nbin_stride_end;
  oss << " | "  << ins.nbin_address;
  oss << " | "  << ins.nbin_size;
  oss << " || " << ins.nbout_read_op;
  oss << " | "  << ins.nbout_write_op;
  oss << " | "  << ins.nbout_address;
  oss << " | "  << ins.nbout_size;
  oss << " || " << ins.nfu_nfu1_op;
  oss << " | "  << ins.nfu_nfu2_op;
  oss << " | "  << ins.nfu_nfu2_in;
  oss << " | "  << ins.nfu_nfu2_out;
  oss << " | "  << ins.nfu_nfu3_op;
  oss << " | "  << ins.nfu_output_begin;
  oss << " | "  << ins.nfu_output_end;
  oss << " | ";
}

std::istream & operator>>( std::istream& is, cp_inst& ins ) {
  std::string dummy;
  is >> dummy >> ins.cp_end;            
  is >> dummy >> ins.sb_read_op;
  is >> dummy >> ins.sb_reuse;
  is >> dummy >> ins.sb_address;
  is >> dummy >> ins.sb_size;
  is >> dummy >> ins.nbin_read_op;
  is >> dummy >> ins.nbin_reuse;
  is >> dummy >> ins.nbin_stride;
  is >> dummy >> ins.nbin_stride_begin;
  is >> dummy >> ins.nbin_stride_end;
  is >> dummy >> ins.nbin_address;
  is >> dummy >> ins.nbin_size;
  is >> dummy >> ins.nbout_read_op;
  is >> dummy >> ins.nbout_write_op;
  is >> dummy >> ins.nbout_address;
  is >> dummy >> ins.nbout_size;
  is >> dummy >> ins.nfu_nfu1_op;
  is >> dummy >> ins.nfu_nfu2_op;
  is >> dummy >> ins.nfu_nfu2_in;
  is >> dummy >> ins.nfu_nfu2_out;
  is >> dummy >> ins.nfu_nfu3_op;
  is >> dummy >> ins.nfu_output_begin;
  is >> dummy >> ins.nfu_output_end;
  is >> dummy;
  return is;
}  

#endif //__CP_INST_H__
