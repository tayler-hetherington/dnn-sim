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
#include "mem_fetch.h"


#include <DRAMSim.h>
#include <string>

/*
 *   DRAM interface using DRAMSim2
 */
class dram_interface {
public:
    
    dram_interface(const std::string& dram_config_file,
                    const std::string& system_config,
                    const std::string& dram_sim_dir,
                    const std::string& prog_name,
                    unsigned memory_size);

    ~dram_interface();

    void cycle();
    bool can_accept_request() const;
    void push_request(mem_addr addr, bool is_write);

    void set_callbacks(DRAMSim::TransactionCompleteCB *read_callback, 
                       DRAMSim::TransactionCompleteCB *write_callback);

private:

    DRAMSim::MultiChannelMemorySystem *m_dram_sim;

};


#if 0
// Old simple DRAM interface
class dram_interface {
  
public:
    
    // FIXME: Access latency is currently independent of the request size.
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




#endif
