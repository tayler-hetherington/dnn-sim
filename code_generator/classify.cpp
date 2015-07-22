////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Siu Pak Mok
// 2015
// classify.cpp
// A simple test program
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>

#include "code_generator.h"

int main(int argc, char **argv){

 if (argc != 12) {
   std::cout << "Found " << argc-1 << " arguments" << std::endl;
   std::cout << "Order of Arguments:" << std::endl;
   std::cout << "num_input_neurons" << std::endl;
   std::cout << "num_output_neurons" << std::endl;
   std::cout << "num_input_neurons_per_entry" << std::endl;
   std::cout << "num_output_neurons_per_entry" << std::endl;
   std::cout << "num_sb_entries" << std::endl;
   std::cout << "num_nbin_entries" << std::endl;
   std::cout << "num_nbout_entries" << std::endl;
   std::cout << "bit_width" << std::endl;
   std::cout << "sb_addr" << std::endl;
   std::cout << "nbin_addr" << std::endl;
   std::cout << "nbout_addr" << std::endl;

   return 4;
 }

 unsigned num_input_neurons = atoi(argv[1]);
 unsigned num_output_neurons = atoi(argv[2]);
 unsigned num_input_neurons_per_entry = atoi(argv[3]);
 unsigned num_output_neurons_per_entry = atoi(argv[4]);
 unsigned num_sb_entries = atoi(argv[5]);
 unsigned num_nbin_entries = atoi(argv[6]);
 unsigned num_nbout_entries = atoi(argv[7]);
 unsigned bit_width = atoi(argv[8]);
 unsigned sb_addr = atoi(argv[9]);
 unsigned nbin_addr = atoi(argv[10]);
 unsigned nbout_addr = atoi(argv[11]);

 std::string entry = generate_classify_layer_code ( num_input_neurons,
                                                    num_output_neurons,
                                                    num_input_neurons_per_entry,
                                                    num_output_neurons_per_entry,
                                                    num_sb_entries,
                                                    num_nbin_entries,
                                                    num_nbout_entries,
                                                    bit_width,
                                                    sb_addr,
                                                    nbin_addr,
                                                    nbout_addr);

 std::cout << entry << std::endl;

 return 0;
}
