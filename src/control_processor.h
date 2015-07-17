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

#include "dnn_sim.h"
#include "dram_interface.h"
#include "config.h"
#include "option_parser.h"
#include "cp_inst.h"


class control_processor {
    
public:
    control_processor();
    ~control_processor();

    void cycle();
    
    void test();
    
private:
    
    void do_cp_inst(cp_inst *inst);
    
    dnn_sim *m_dnn_sim;
    dnn_config *m_dnn_config;
    dram_interface *m_dram_interface;
    
    std::queue<memory_fetch *> m_mem_requests;
};

#endif
