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

class control_processor {
    
public:
    control_processor(dnn_config const * const cfg, datapath * dp, dram_interface * dram_if);
    ~control_processor();

    void cycle();
    
    void test();
    
private:
    
    bool do_cp_inst(cp_inst *inst);
    
    dnn_config const * m_dnn_config;
    
    dram_interface *m_dram_interface;
    datapath *m_datapath;

    std::queue<memory_fetch *> m_mem_requests;

    std::queue<cp_inst> m_inst_queue;
};

#endif
