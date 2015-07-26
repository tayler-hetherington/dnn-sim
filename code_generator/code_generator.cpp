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
#include "stat_keeper.h"

void load_sb(cp_inst& inst,
             unsigned num_sb_to_load,
             unsigned sb_addr,
             bool reuse,
             unsigned word_size) {

    inst.sb_read_op        = cp_inst::LOAD;
    inst.sb_reuse          = reuse ? 1 : 0;
    inst.sb_address        = sb_addr;
    inst.sb_size           = num_sb_to_load * word_size;
}

void load_nbin(cp_inst& inst,
               unsigned num_nbin_to_load,
               unsigned nbin_addr,
               bool reuse,
               unsigned word_size) {

    inst.nbin_read_op      = cp_inst::LOAD;
    inst.nbin_reuse        = reuse ? 1 : 0;
    inst.nbin_stride       = 0;
    inst.nbin_stride_begin = 0;
    inst.nbin_stride_end   = 0;
    inst.nbin_address      = nbin_addr;
    inst.nbin_size         = num_nbin_to_load * word_size;
}

void read_nbin(cp_inst& inst,
               unsigned nbin_addr,
               bool reuse,
               unsigned word_size) {

    inst.nbin_read_op      = cp_inst::READ;
    inst.nbin_reuse        = reuse ? 1 : 0;
    inst.nbin_stride       = 0;
    inst.nbin_stride_begin = 0;
    inst.nbin_stride_end   = 0;
    inst.nbin_address      = nbin_addr;
    inst.nbin_size         = 0;
}


void partial_sum_NFU(cp_inst& inst, cp_inst::cp_inst_op nfu2_in) {

    inst.nfu_nfu1_op       = cp_inst::MULT;
    inst.nfu_nfu2_op       = cp_inst::ADD;
    inst.nfu_nfu2_in       = nfu2_in;
    inst.nfu_nfu2_out      = cp_inst::NBOUT;
    inst.nfu_nfu3_op       = cp_inst::SIGMOID;
}

void sigmoid_NFU(cp_inst& inst, cp_inst::cp_inst_op nfu2_in) {

    inst.nfu_nfu1_op       = cp_inst::MULT;
    inst.nfu_nfu2_op       = cp_inst::ADD;
    inst.nfu_nfu2_in       = nfu2_in;
    inst.nfu_nfu2_out      = cp_inst::NFU3;
    inst.nfu_nfu3_op       = cp_inst::SIGMOID;
}

void output_NBout(cp_inst& inst,
                  unsigned num_nbout_to_write,
                  unsigned nbout_addr,
                  unsigned word_size) {

    inst.nbout_read_op     = cp_inst::READ;
    inst.nbout_write_op    = cp_inst::STORE;
    inst.nbout_address     = nbout_addr;
    inst.nbout_size        = num_nbout_to_write * word_size;
    inst.nfu_output_begin  = 1;
    inst.nfu_output_end    = 0;
}

void nop_NBout(cp_inst& inst) {

    inst.nbout_read_op     = cp_inst::NOP;
    inst.nbout_write_op    = cp_inst::WRITE;
    inst.nbout_address     = 0;
    inst.nbout_size        = 0;
    inst.nfu_output_begin  = 0;
    inst.nfu_output_end    = 0;
}


unsigned div_roundup(unsigned n, unsigned divisor) {
  return (n + divisor - 1) / divisor;
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

    // various performance counter
    unsigned cycles = 0;            // cycles needed to execute current control instruction
    stat_keeper stat;

    // intermediate data
    unsigned word_size = div_roundup(bit_width,8);

    unsigned remaining_input_neurons  = num_input_neurons;
    unsigned remaining_output_neurons = num_output_neurons;

    unsigned current_sb_pointer = sb_addr;
    unsigned current_nbin_pointer = nbin_addr;
    unsigned current_nbout_pointer = nbout_addr;

    unsigned num_nbout_to_write;

    do {

      bool is_new_block = true;
      remaining_input_neurons  = num_input_neurons;
      num_nbout_to_write = std::min(remaining_output_neurons, num_output_neurons_per_entry * num_nbout_entries);

      unsigned total_num_nbin_entry = div_roundup(num_input_neurons, num_input_neurons_per_entry);
      unsigned num_input_to_load = std::min(remaining_input_neurons, num_input_neurons_per_entry * num_nbin_entries);
      unsigned nbin_entry_loaded = 0;

      if (verbose) {
       unsigned output_from = num_output_neurons - remaining_output_neurons;
       unsigned output_to = output_from + num_nbout_to_write - 1;
       std::cout << std::endl << "Output Neuron " << output_from << " - " << output_to << std::endl;
      }

      // go through the neuron inputs an entry at a time
      for (int current_nbin_entry = 0;
           current_nbin_entry < total_num_nbin_entry; current_nbin_entry++) {

        // instruction to print out
        cp_inst inst;
        inst.cp_end = cp_inst::NOP;

        // calculate how many SB entries to load
        unsigned num_sb_to_load = num_input_neurons_per_entry * num_nbout_to_write;

        // load SB buffer
        load_sb(inst, num_sb_to_load, current_sb_pointer, false, word_size);

        // update SB pointer
        current_sb_pointer += num_sb_to_load * word_size;
        cycles = div_roundup(num_sb_to_load / num_input_neurons_per_entry,
                             num_output_neurons_per_entry);

        // check to see if NBin is filled or not
        // if not, fill it
        if (nbin_entry_loaded == 0) { 
          num_input_to_load = std::min(remaining_input_neurons, num_input_neurons_per_entry * num_nbin_entries);
          nbin_entry_loaded = div_roundup(num_input_to_load, num_input_neurons_per_entry);
          load_nbin(inst, num_input_to_load, current_nbin_pointer, true, word_size);

          if (verbose) {
           unsigned output_from = num_output_neurons - remaining_output_neurons;
           unsigned output_to = output_from + num_nbout_to_write - 1;
           unsigned input_from = num_input_neurons - remaining_input_neurons;
           unsigned input_to = input_from + num_input_to_load - 1;
           std::cout << std::endl << "Output Neuron " << output_from << " - " << output_to
                     << ": Input Neuron " << input_from << " - " << input_to << std::endl;
          }

          remaining_input_neurons  -= num_input_to_load;
        } else {
          read_nbin(inst, current_nbin_pointer, true, word_size);
        }

        // update counters
        nbin_entry_loaded--;
        current_nbin_pointer += num_input_neurons_per_entry * word_size;
        cycles = std::max(cycles,
            div_roundup(inst.nbin_size / word_size, num_input_neurons_per_entry));

        // prepare for output if it is last entry to finalize the sum
        if (current_nbin_entry == total_num_nbin_entry - 1) {

          sigmoid_NFU(inst, is_new_block ? cp_inst::RESET : cp_inst::NBOUT);
          output_NBout(inst, num_nbout_to_write, current_nbout_pointer, word_size);

          // update counters
          current_nbout_pointer += num_nbout_to_write * word_size;
          remaining_output_neurons -= num_nbout_to_write;

        } else {

          partial_sum_NFU(inst, is_new_block ? cp_inst::RESET : cp_inst::NBOUT);
          nop_NBout(inst);

        }

        // stat for the instruction
        cycles = std::max(cycles,
           div_roundup(num_nbout_to_write,num_output_neurons_per_entry));
        stat.update(inst,cycles);
        is_new_block = false;

        // output load instruction
        std::cout << inst << stat.inst_report(verbose) << std::endl;
      }

    } while (remaining_output_neurons > 0);

    // print out summary
    std::cout << stat.code_report(verbose);

    // config entry for classify layer
    std::stringstream ss;
    ss << "CLASS 0 0 0 0 " << num_input_neurons << " " << num_output_neurons << std::endl;

    return ss.str();
}
