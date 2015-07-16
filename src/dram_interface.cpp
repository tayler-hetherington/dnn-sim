////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// dram.cpp
// DRAM interface. Current version implements a simple
// interface with a fixed latency access.
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "dram_interface.h"



dram_interface::dram_interface(unsigned access_latency, unsigned max_pending_req) :
    m_access_latency(access_latency), m_max_pending_req(max_pending_req), m_cur_dram_cycle(0), m_num_reads(0), m_num_writes(0){
    
    
    
}

dram_interface::~dram_interface(){
    
}

void dram_interface::cycle(){
    
    memory_fetch *mf = NULL;
    m_cur_dram_cycle++;
    
    mf = m_mem_queue.front();
    if(m_cur_dram_cycle >= mf->m_access_complete_cycle){ // Memory request has compeleted
        
        // Increment stats
        if(mf->m_type == READ) m_num_reads++;
        else m_num_writes++;
                
        // Set completed
        mf->m_is_complete = true;
        
        // Pop from queue
        m_mem_queue.pop_front();
    }
    
}

bool dram_interface::do_access(memory_fetch *mf){
    
    // If there's space in the queue
    if(m_mem_queue.size() < m_max_pending_req){
        // Set the completion cycle timestamp
        mf->m_access_complete_cycle = (m_cur_dram_cycle + m_access_latency);
        mf->m_is_complete = false;

        // Push into the memory access queue
        m_mem_queue.push_back(mf);
        return true;
    }else{
        // Queue is full, don't accept this cycle
        return false;
    }
}

unsigned dram_interface::get_num_reads(){
    return m_num_reads;
}
unsigned dram_interface::get_num_writes(){
    return m_num_writes;
}

