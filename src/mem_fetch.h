////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// mem_fetch.h
// Memory request object
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __MEM_FETCH_H__
#define __MEM_FETCH_H__

#include "common.h"

// Forward declaration of the backwards pipe_op pointer
class pipe_op;

/*
 *   A memory request object to fill SRAMs from DRAM
 */
class memory_fetch {
public:
    memory_fetch(mem_addr addr, unsigned size, mem_access_type type, sram_type s_type);
    ~memory_fetch();
    
    mem_addr m_addr;          // Address to access
    unsigned m_size;          // Bytes
    mem_access_type m_type;   // Read or write
    unsigned long long m_access_complete_cycle; // Fixed-latency memory request completion cycle

    sram_type m_sram_type;
    
    bool m_is_complete;       // If the operation has compeleted. Used to writeback to SRAM on a read
};

#endif