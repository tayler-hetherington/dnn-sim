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

// generate a load instruction that loads in SB and NBin
cp_inst load_instruction(unsigned num_sb_to_load,
                         unsigned num_input_to_load,
                         unsigned sb_addr,
                         unsigned nbin_addr,
                         unsigned word_size);

// generate a compute instruction for classify layer
cp_inst classify_compute_instruction(unsigned num_sb_to_load,
                                     unsigned sb_addr,
                                     bool is_first_compute,
                                     unsigned word_size);

// generate an output instruction that writes the content of NBout
cp_inst output_instruction(unsigned num_nbout_to_write,
                           unsigned nbout_addr,
                           unsigned word_size);

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
