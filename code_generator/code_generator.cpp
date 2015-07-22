////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Siu Pak Mok
// 2015
// classify.cpp
// Code generator function
// Generate classify-layer code and print to stdout
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include <stdio.h>
#include <iostream>
#include <string>
#include <sstream>
#include <algorithm>

#include "../src/cp_inst.h"
#include "code_generator.h"

cp_inst load_instruction(unsigned num_sb_to_load,
                         unsigned num_input_to_load,
                         unsigned sb_addr,
                         unsigned nbin_addr,
                         unsigned word_size) {

    cp_inst inst;

    inst.cp_end            = cp_inst::NOP;
    inst.sb_read_op        = cp_inst::LOAD;
    inst.sb_reuse          = 0;
    inst.sb_address        = sb_addr;
    inst.sb_size           = num_sb_to_load * word_size;
    inst.nbin_read_op      = cp_inst::LOAD;
    inst.nbin_reuse        = 1;
    inst.nbin_stride       = 0;
    inst.nbin_stride_begin = 0;
    inst.nbin_stride_end   = 0;
    inst.nbin_address      = nbin_addr;
    inst.nbin_size         = num_input_to_load * word_size;
    inst.nbout_read_op     = cp_inst::NOP;
    inst.nbout_write_op    = cp_inst::WRITE;
    inst.nbout_address     = 0;
    inst.nbout_size        = 0;
    inst.nfu_nfu1_op       = cp_inst::MULT;
    inst.nfu_nfu2_op       = cp_inst::ADD;
    inst.nfu_nfu2_in       = cp_inst::RESET;
    inst.nfu_nfu2_out      = cp_inst::NBOUT;
    inst.nfu_nfu3_op       = cp_inst::SIGMOID;
    inst.nfu_output_begin  = 1;
    inst.nfu_output_end    = 0;

    return inst;
}

cp_inst classify_compute_instruction(unsigned num_sb_to_load,
                                     unsigned sb_addr,
                                     bool is_first_compute,
                                     unsigned word_size) {

    cp_inst inst;

    inst.cp_end            = cp_inst::NOP;
    inst.sb_read_op        = cp_inst::LOAD;
    inst.sb_reuse          = 0;
    inst.sb_address        = sb_addr;
    inst.sb_size           = num_sb_to_load * word_size;
    inst.nbin_read_op      = cp_inst::LOAD;
    inst.nbin_reuse        = 1;
    inst.nbin_stride       = 0;
    inst.nbin_stride_begin = 0;
    inst.nbin_stride_end   = 0;
    inst.nbin_address      = 0;
    inst.nbin_size         = 0;
    inst.nbout_read_op     = cp_inst::NOP;
    inst.nbout_write_op    = cp_inst::WRITE;
    inst.nbout_address     = 0;
    inst.nbout_size        = 0;
    inst.nfu_nfu1_op       = cp_inst::MULT;
    inst.nfu_nfu2_op       = cp_inst::ADD;

    // input to NFU2 comes from NBOut if this instruction is not the first
    // compute instruction
    inst.nfu_nfu2_in       = is_first_compute ? cp_inst::RESET : cp_inst::NBOUT;
    inst.nfu_nfu2_out      = cp_inst::NBOUT;
    inst.nfu_nfu3_op       = cp_inst::SIGMOID;
    inst.nfu_output_begin  = 0;
    inst.nfu_output_end    = 0;

    return inst;
}

cp_inst output_instruction(unsigned num_nbout_to_write,
                           unsigned nbout_addr,
                           unsigned word_size) {

    cp_inst inst;

    inst.cp_end            = cp_inst::NOP;
    inst.sb_read_op        = cp_inst::LOAD;
    inst.sb_reuse          = 0;
    inst.sb_address        = 0;
    inst.sb_size           = 0;
    inst.nbin_read_op      = cp_inst::LOAD;
    inst.nbin_reuse        = 1;
    inst.nbin_stride       = 0;
    inst.nbin_stride_begin = 0;
    inst.nbin_stride_end   = 0;
    inst.nbin_address      = 0;
    inst.nbin_size         = 0;
    inst.nbout_read_op     = cp_inst::READ;
    inst.nbout_write_op    = cp_inst::STORE;
    inst.nbout_address     = nbout_addr;
    inst.nbout_size        = num_nbout_to_write * word_size;
    inst.nfu_nfu1_op       = cp_inst::MULT;
    inst.nfu_nfu2_op       = cp_inst::ADD;
    inst.nfu_nfu2_in       = cp_inst::NBOUT;
    inst.nfu_nfu2_out      = cp_inst::NFU3;
    inst.nfu_nfu3_op       = cp_inst::SIGMOID;
    inst.nfu_output_begin  = 1;
    inst.nfu_output_end    = 0;

    return inst;
}

// per_entry values must be less than or equal to the whole value
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
                                          bool verbose) {


    // instruction to print out
    cp_inst inst;

    // various performance counter
    unsigned byte_read = 0;         // number of bytes read from memory for one instruction
    unsigned byte_write = 0;        // number of bytes written to memory for one instruction
    unsigned total_byte_read = 0;   // total number of bytes read from memory
    unsigned total_byte_write = 0;  // total number of bytes written to memory
    unsigned cycles = 0;            // cycles needed to execute current control instruction
    unsigned total_cycles = 0;      // total number of cycles executed
                                    // cycle count exclude pipeline and memory latency
    unsigned bandwidth = 0;         // average bandwidth needed for current control instruction

    // intermediate data
    unsigned word_size = (bit_width + 7) / 8;

    unsigned remaining_input_neurons  = num_input_neurons;
    unsigned remaining_output_neurons = num_output_neurons;
    unsigned remaining_synapses = num_input_neurons * num_output_neurons;

    unsigned current_sb_pointer = sb_addr;
    unsigned current_nbin_pointer = nbin_addr;
    unsigned current_nbout_pointer = nbout_addr;

    unsigned num_nbout_to_write = std::min(remaining_output_neurons, num_output_neurons_per_entry * num_nbout_entries);

    bool is_new_block = true;

    do {

      remaining_synapses = num_input_neurons * num_output_neurons;

      unsigned num_input_to_load = std::min(remaining_input_neurons, num_input_neurons_per_entry * num_nbin_entries);
      unsigned num_sb_to_load = num_input_to_load * std::min(remaining_output_neurons, num_output_neurons_per_entry * num_nbout_entries);
      num_nbout_to_write = std::min(remaining_output_neurons, num_output_neurons_per_entry * num_nbout_entries);

      // initial load
      if (verbose)
        std::cout << std::endl << "# grab the next set of NBin and SB"  << std::endl;
      inst = load_instruction(num_sb_to_load, num_input_to_load, current_sb_pointer, current_nbin_pointer, word_size);

      // update counters
      current_sb_pointer += num_sb_to_load * word_size;
      current_nbin_pointer += num_input_to_load * word_size;
      remaining_input_neurons  -= num_input_to_load;
      remaining_synapses -= num_sb_to_load;

      // stat for the instruction
      cycles     = std::max(num_input_to_load / num_input_neurons_per_entry, num_sb_to_load / num_input_neurons_per_entry / num_output_neurons_per_entry);
      byte_read  = inst.sb_size + inst.nbin_size;
      byte_write = inst.nbout_size;
      bandwidth  = (byte_read + byte_write) / cycles;

      // accumulate the performance counters
      total_cycles     += cycles;
      total_byte_read  += byte_read;
      total_byte_write += byte_write;

      // output load instruction
      std::cout << inst;
      if (verbose)
        std::cout << " # Cycles: " << cycles << " Bandwidth: " << bandwidth;
      std::cout << std::endl;

      // go through all the entries in NBin before reloading
      // calculate how many NBin entries loaded into NBin
      unsigned nbin_entry_loaded = (num_input_to_load + num_input_neurons_per_entry - 1) / num_input_neurons_per_entry;
      if (verbose)
        std::cout << std::endl << "# Compute classify, one instruction per entry, loaded " << nbin_entry_loaded << " entries into NBin"  << std::endl;
      for (int current_nbin_entry = 0; current_nbin_entry < nbin_entry_loaded; current_nbin_entry++) {

        // don't pre-load synapses for the last entry, they will be loaded at
        // the next load instruction instead
        if (current_nbin_entry == nbin_entry_loaded - 1)
          num_sb_to_load = 0;

        // compute instruction 
        inst = classify_compute_instruction(num_sb_to_load, current_sb_pointer, is_new_block, word_size);

        // update counters
        current_sb_pointer += num_sb_to_load * word_size;
        remaining_synapses -= num_sb_to_load;
        is_new_block = false;
  
        // stat for instruction
        cycles     = std::max(num_nbout_to_write / num_output_neurons_per_entry, num_sb_to_load / num_input_neurons_per_entry / num_output_neurons_per_entry);
        byte_read  = inst.sb_size + inst.nbin_size;
        byte_write = inst.nbout_size;
        bandwidth  = (byte_read + byte_write) / cycles;
  
        // accumulate the performance counters
        total_cycles     += cycles;
        total_byte_read  += byte_read;
        total_byte_write += byte_write;
  
        // output compute instruction
        std::cout << inst;
        if (verbose)
          std::cout << " # Cycles: " << cycles << " Bandwidth: " << bandwidth;
        std::cout << std::endl;
      }
    } while (remaining_input_neurons > 0);

    // generate output instruction
    inst = output_instruction(num_nbout_to_write, current_nbout_pointer, word_size);

    // update counters
    remaining_output_neurons -= num_nbout_to_write;
    current_nbout_pointer += num_nbout_to_write * word_size;

    // stat for instruction
    cycles     = (num_nbout_to_write + num_output_neurons_per_entry - 1) / num_output_neurons_per_entry;
    byte_read  = inst.sb_size + inst.nbin_size;
    byte_write = inst.nbout_size;
    bandwidth  = (byte_read + byte_write) / cycles;

    // accumulate the performance counters
    total_cycles     += cycles;
    total_byte_read  += byte_read;
    total_byte_write += byte_write;

    if (verbose)
      std::cout << std::endl << "# Store NBout"  << std::endl;

    std::cout << inst;
    if (verbose)
      std::cout << " # Cycles: " << cycles << " Bandwidth: " << bandwidth;
    std::cout << std::endl;

    // print out summary
    std::cout <<  std::endl;
    std::cout << "# Total # of Cycles: " << total_cycles << std::endl;
    std::cout << "# Total # of Bytes Read: " << total_byte_read << std::endl;
    std::cout << "# Total # of Bytes Wrote: " << total_byte_write << std::endl;

    // config entry for classify layer
    std::stringstream ss;
    ss << "CLASS 0 0 0 0 " << num_input_neurons << " " << num_output_neurons << std::endl;

    return ss.str();

}

