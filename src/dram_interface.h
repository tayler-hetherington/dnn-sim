////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// dram.h
// DRAM interface. Current version implements a simple
// interface with a fixed latency access.
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __DRAM_H__
#define __DRAM_H__

#include "common.h"
#include "pipe_operation.h"

/*
 *   A memory request object to fill SRAMs from DRAM
*/
class memory_fetch {
public:
    mem_addr addr;          // Address to access
    unsigned size;          // Bytes
    mem_access_type type;   // Read or write
    unsigned long long access_complete_cycle; // Fixed-latency memory request completion cycle
    pipe_op *op;            // Pointer to the pipe operation that generated this request
    
    bool is_complete;       // If the operation has compeleted. Used to writeback to SRAM on a read
};



/*
 *   DRAM interface
 */
class dram_interface {
  
public:
    
    dram_interface(unsigned access_latency, unsigned max_pending_req);
    ~dram_interface();
    
    void cycle();
    bool do_access(memory_fetch *mf);
    
    unsigned get_num_reads();
    unsigned get_num_writes();
    
private:
    
    unsigned m_access_latency;
    unsigned m_max_pending_req;
    unsigned long long m_cur_dram_cycle;    // Current cycle count for DRAM. Used to pop elements off of the fixed-latency access queue
    
    std::deque<memory_fetch *> m_mem_queue;      // Queue of pending requests

    // Stats
    unsigned m_num_reads;
    unsigned m_num_writes;
};



#endif