////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// pipe_stage.h
// DianNao pipeline stage
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "common.h"
#include "pipe_operation.h"
#include "functional_unit.h"

#ifndef __PIPELINE_STAGE_H__
#define __PIPELINE_STAGE_H__


class pipe_stage {

public:
    pipe_stage(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size, unsigned num_int_pipeline_stages);
    virtual ~pipe_stage();
    void register_requests(pipe_reg *i_op);
    bool push_op(pipe_op *op);
    pipe_op *pop_op();

    virtual void cycle() = 0;
    virtual void print_internal_pipeline();
    
    unsigned get_num_ops(functional_unit **func_unit, unsigned num_units);
    
protected:

    bool is_pipe_reg_full(pipe_reg *reg);
    
    // Input/output queues shared between stages
    pipe_reg *input_op;
    pipe_reg *output_op;
    
    // Max size of input/ouput queues
    unsigned q_size;
    
    // Internal pipeline stages
    unsigned n_int_pipeline_stages;
    pipe_op **int_pipeline;
    
    
};



// Set of multipliers - Multiply image and filters
class nfu_1 : public pipe_stage {
public:
    nfu_1(pipe_reg *i_op, pipe_reg *o_op, pipe_reg *requests_reg,
          unsigned queue_size, unsigned num_int_pipeline_stages,
          unsigned num_multipliers);
     nfu_1(pipe_reg *i_op, pipe_reg *o_op, 
          unsigned queue_size, unsigned num_int_pipeline_stages,
          unsigned num_multipliers);
    virtual ~nfu_1();

    virtual void cycle();
    virtual void print_internal_pipeline();
    
    unsigned get_num_mult_ops();
    
private:
    // Functional units
    pipe_reg* m_requests;
    unsigned m_num_multipliers;
    functional_unit **m_multipliers;    // Multipliers
};

// Set of adders - Add results from nfu_1
class nfu_2 : public pipe_stage {
public:
    nfu_2(pipe_reg *i_op, pipe_reg *o_op,
          unsigned queue_size, unsigned num_int_pipeline_stages,
          unsigned num_adders, unsigned num_shifters, unsigned num_max);
    virtual ~nfu_2();

    virtual void cycle();
    virtual void print_internal_pipeline();
    
    unsigned get_num_add_ops();
    unsigned get_num_shift_ops();
    unsigned get_num_max_ops();
    
private:
    // Functional units
    unsigned m_num_adders;
    unsigned m_num_shifters;
    unsigned m_num_max;
    functional_unit **m_adders;     // Adder trees
    functional_unit **m_shifters;   // Shifter
    functional_unit **m_max;        // Max operator
};

// Multipliers + adders + small SRAM - Compute sigmoid
class nfu_3 : public pipe_stage {
public:
    nfu_3(pipe_reg *i_op, pipe_reg *o_op,
          unsigned queue_size, unsigned num_int_pipeline_stages,
          unsigned num_multipliers, unsigned num_adders);
    virtual ~nfu_3();

    virtual void cycle();
    virtual void print_internal_pipeline();
    
    unsigned get_num_mult_ops();
    unsigned get_num_add_ops();
private:
    // Functional units
    unsigned m_num_multipliers;
    unsigned m_num_adders;
    functional_unit **m_multipliers;    // Multipliers
    functional_unit **m_adders;         // Adders
};






#endif
