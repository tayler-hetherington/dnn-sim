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
    pipe_stage(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size);
    ~pipe_stage();

    bool push_op(pipe_op *op);
    pipe_op *pop_op();

protected:
    // Input/output queues shared between stages
    std::queue<pipe_op *> *input_op;
    std::queue<pipe_op *> *output_op;

    unsigned q_size;

};



// Set of multipliers - Multiply image and filters
class nfu_1 : public pipe_stage {
public:
    nfu_1(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size);
    ~nfu_1();
};

// Set of adders - Add results from nfu_1
class nfu_2 : public pipe_stage {
public:
    nfu_2(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size);
    ~nfu_2();
};

// Multipliers + adders + small SRAM - Compute sigmoid
class nfu_3 : public pipe_stage {
public:
    nfu_3(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size);
    ~nfu_3();
};






#endif
