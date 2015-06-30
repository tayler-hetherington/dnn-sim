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

#ifndef __PIPELINE_STAGE_H__
#define __PIPELINE_STAGE_H__


class pipe_stage {

public:
    pipe_stage(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size);
    virtual ~pipe_stage();

    bool push_op(pipe_op *op);
    pipe_op *pop_op();

    virtual void cycle() = 0;

protected:
    // Input/output queues shared between stages
    pipe_reg *input_op;
    pipe_reg *output_op;

    unsigned q_size;

};



// Set of multipliers - Multiply image and filters
class nfu_1 : public pipe_stage {
public:
    nfu_1(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size);
    virtual ~nfu_1();

    virtual void cycle();
};

// Set of adders - Add results from nfu_1
class nfu_2 : public pipe_stage {
public:
    nfu_2(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size);
    virtual ~nfu_2();

    virtual void cycle();
};

// Multipliers + adders + small SRAM - Compute sigmoid
class nfu_3 : public pipe_stage {
public:
    nfu_3(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size);
    virtual ~nfu_3();

    virtual void cycle();
};






#endif
