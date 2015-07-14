////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// functional_unit.h
// Functional unit structures
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#ifndef __FUNCTIONAL_UNIT_H__
#define __FUNCTIONAL_UNIT_H__

#include "common.h"

class functional_unit {
public:
    functional_unit(double op_latency, double freq);
    ~functional_unit();

    void cycle();
    
    bool do_op();
    bool is_busy();

    unsigned get_stats();

private:
 
    bool m_busy;            // If the functional unit is busy or not
    double m_latency;       // Latency to perform the operation. Used to calculate number of cycles based on the operating frequency. 
    unsigned m_num_cycles;
    unsigned m_cur_cycle;


    unsigned m_num_ops;     // Performance counter for the number of operations performed. 


};

#endif