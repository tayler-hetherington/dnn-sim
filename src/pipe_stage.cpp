////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// Tayler Hetherington
// 2015
// pipe_stage.cpp
// DianNao pipeline stage
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

#include "pipe_stage.h"



pipe_stage::pipe_stage(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size){

    input_op = i_op;
    output_op = o_op;

    q_size = queue_size;
}

pipe_stage::~pipe_stage(){

}

bool pipe_stage::push_op(pipe_op *op){
    if(input_op->size() < q_size){
        input_op->push(op);
        return true;
    }else {
        return false;
    }
}
pipe_op *pipe_stage::pop_op(){
    pipe_op *op = NULL;

    if(!output_op->empty()){
        op = output_op->front();
        output_op->pop();
    }

    return op;
}


nfu_1::nfu_1(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size) : pipe_stage(i_op, o_op, queue_size){

}
nfu_1::~nfu_1(){

}


nfu_2::nfu_2(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size) : pipe_stage(i_op, o_op, queue_size){

}
nfu_2::~nfu_2(){

}

nfu_3::nfu_3(std::queue<pipe_op *> *i_op, std::queue<pipe_op *> *o_op, unsigned queue_size) : pipe_stage(i_op, o_op, queue_size){

}
nfu_3::~nfu_3(){

}
