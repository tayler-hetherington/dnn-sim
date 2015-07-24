////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// control_processor.h
// Control Processor
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __CONTROL_PROCESSOR_H__
#define __CONTROL_PROCESSOR_H__

#include "common.h"

#include "config.h"
#include "cp_inst.h"
#include "mem_fetch.h"
#include "dram_interface.h"
#include "datapath.h"
#include "cp_inst.h"

#include <DRAMSim.h>

class control_processor {
    
public:
    control_processor(dnn_config const * const cfg, datapath * dp, dram_interface * dram_if);
    ~control_processor();

    void cycle(); 
    void test(cp_inst *inst);
    bool is_test_done();

    // DRAM
    void read_complete_callback(unsigned id, mem_addr address, uint64_t clock_cycle);
    void write_complete_callback(unsigned id, mem_addr address, uint64_t clock_cycle);

private:
    
    bool do_cp_inst(cp_inst *inst);
    
    dnn_config const * m_dnn_config;
    
    // DRAM
    dram_interface *m_dram_interface;
    std::deque<memory_fetch *> m_mem_requests;
    DRAMSim::TransactionCompleteCB *m_read_callback;
    DRAMSim::TransactionCompleteCB *m_write_callback;

    datapath *m_datapath;

   
    std::queue<cp_inst> m_inst_queue;


};

#endif
