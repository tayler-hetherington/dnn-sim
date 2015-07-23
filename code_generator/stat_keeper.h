////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Siu Pak Mok
// 2015
// stat_keeper.h
// Keep stat about the instructions
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __STAT_KEEPER_H__
#define __STAT_KEEPER_H__

#include <iostream>
#include <string>

#include "../src/cp_inst.h"

class stat_keeper {

  private:

    unsigned byte_read;         // number of bytes read from memory for one instruction
    unsigned byte_write;        // number of bytes written to memory for one instruction
    unsigned cycles;            // cycles needed to execute current control instruction

    unsigned total_byte_read;   // total number of bytes read from memory
    unsigned total_byte_write;  // total number of bytes written to memory
    unsigned total_cycles;      // total number of cycles executed
                                // cycle count exclude pipeline and memory latency
    unsigned bandwidth;         // average bandwidth needed for current control instruction
    unsigned max_bandwidth;     // max bandwidth needed for all control instruction

  public:

   // Constructor
   stat_keeper();

   // update the counters for each instruction
   void update(cp_inst inst, unsigned cycle_count);

   // report relavent data for the instruction just updated
   std::string inst_report(bool verbose = true);

   // report a summary for all the instructions so far
   std::string code_report(bool verbose = true);

};

#endif
