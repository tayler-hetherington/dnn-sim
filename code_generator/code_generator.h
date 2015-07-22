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

#include <iostream>
#include <string>

#include "../src/cp_inst.h"

cp_inst load_instruction(unsigned num_sb_to_load,
                         unsigned num_input_to_load,
                         unsigned sb_addr,
                         unsigned nbin_addr,
                         unsigned word_size);

cp_inst classify_compute_instruction(unsigned num_sb_to_load,
                                     unsigned sb_addr,
                                     bool is_first_compute,
                                     unsigned word_size);

cp_inst output_instruction(unsigned num_nbout_to_write,
                           unsigned nbout_addr,
                           unsigned word_size);

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

