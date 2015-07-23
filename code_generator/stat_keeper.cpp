////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Siu Pak Mok
// 2015
// stat_keeper.cpp
// Keep stat about the instructions
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include <sstream>
#include <algorithm>

#include "stat_keeper.h"

// Constructor
stat_keeper::stat_keeper() {

  byte_read = 0;         // number of bytes read from memory for one instruction
  byte_write = 0;        // number of bytes written to memory for one instruction
  cycles = 0;            // cycles needed to execute current control instruction
  
  total_byte_read = 0;   // total number of bytes read from memory
  total_byte_write = 0;  // total number of bytes written to memory
  total_cycles = 0;      // total number of cycles executed
                         // cycle count exclude pipeline and memory latency
  bandwidth = 0;         // average bandwidth needed for current control instruction
  max_bandwidth = 0;     // max bandwidth needed for all control instruction

}


void stat_keeper::update(cp_inst inst, unsigned cycle_count) {

  // stat for current instruction
  cycles     = cycle_count;
  byte_read  = inst.sb_size + inst.nbin_size;
  byte_write = inst.nbout_size;
  bandwidth  = (byte_read + byte_write) / cycles;

  // accumulate the performance counters
  total_cycles     += cycles;
  total_byte_read  += byte_read;
  total_byte_write += byte_write;
  max_bandwidth = std::max(max_bandwidth, bandwidth);

}

std::string stat_keeper::inst_report(bool verbose) {

  if (!verbose) return "";

  std::stringstream ss;
  ss << " # Cycles: " << cycles << " Bandwidth: " << bandwidth;

  return ss.str();

}

std::string stat_keeper::code_report(bool verbose) {

  if (!verbose) return "";

  std::stringstream ss;
  ss <<  std::endl;
  ss << "# Total # of Cycles: " << total_cycles << std::endl;
  ss << "# Total # of Bytes Read: " << total_byte_read << std::endl;
  ss << "# Total # of Bytes Wrote: " << total_byte_write << std::endl;
  ss << "# Max Bandwidth Used: " << max_bandwidth << std::endl;

  return ss.str();

}
