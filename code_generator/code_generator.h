////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Siu Pak Mok
// 2015
// code_generator.h
// Code generator function
// Generate classify-layer code and print to stdout
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __CODE_GEN_H__
#define __CODE_GEN_H__

#include <iostream>
#include <string>

#include "../src/cp_inst.h"

// initialize SB part of the instruction for loading
void load_sb(cp_inst& inst,
             unsigned num_sb_to_load,
             unsigned sb_addr,
             bool reuse,
             unsigned word_size);

// load instruction for NBin part of the instruction
void load_nbin(cp_inst& inst,
               unsigned num_nbin_to_load,
               unsigned nbin_addr,
               bool reuse,
               unsigned word_size);

// read instruction for NBin part of the instruction
void read_nbin(cp_inst& inst,
               unsigned nbin_addr,
               bool reuse,
               unsigned word_size);

// NFU op code for computing partial sum
void partial_sum_NFU(cp_inst& inst, cp_inst::cp_inst_op nfu2_in);

// NFU op code for sigmoid and the final sum
void sigmoid_NFU(cp_inst& inst, cp_inst::cp_inst_op nfu2_in);

// output NBout content
void output_NBout(cp_inst& inst,
                  unsigned num_nbout_to_write,
                  unsigned nbout_addr,
                  unsigned word_size);

// NOP for NBout
void nop_NBout(cp_inst& inst);

unsigned div_roundup(unsigned n, unsigned divisor);

// generate classify layer instructions
std::string generate_classify_layer_code (unsigned num_input_neurons,
                                          unsigned num_output_neurons,
                                          unsigned num_input_neurons_per_entry,
                                          unsigned num_output_neurons_per_entry,
                                          unsigned num_sb_entries,
                                          unsigned num_nbin_entries,
                                          unsigned num_nbout_entries,
                                          unsigned bit_width,
                                          unsigned sb_addr,
                                          unsigned nbin_addr,
                                          unsigned nbout_addr,
                                          bool verbose = true);

#endif
