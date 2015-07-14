////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// functional_unit.cpp
// Functional unit structures
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "functional_unit.h"

functional_unit::functional_unit(double op_latency, double freq) : m_latency(op_latency) {
    m_busy = false;
    m_num_ops = 0;

    // Calculate number of cycles for this op based on frequency (Hz) and op latency (s)
    m_cur_cycle = 0;
    m_num_cycles = ceil(m_latency * freq);

}

functional_unit::~functional_unit(){

}

void functional_unit::cycle(){
    if(m_busy && (m_cur_cycle < m_num_cycles)){
        // If not complete, increment cycle count
        m_cur_cycle++;
    }else{
        // Else, increment number of completed ops and reset state
        m_num_ops++;
        m_busy = false; 
        m_cur_cycle = 0;
    }
}

bool functional_unit::do_op(){

    if(m_busy){
        return false;
    }else{
        m_busy = true;
        return true;
    }

}

unsigned functional_unit::get_stats(){
    return m_num_ops;
}