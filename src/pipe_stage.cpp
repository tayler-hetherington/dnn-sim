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



pipe_stage::pipe_stage(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size){

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

//////////////////
// NFU-1 Stage
//////////////////
nfu_1::nfu_1(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size) : pipe_stage(i_op, o_op, queue_size){

}

nfu_1::~nfu_1(){

}

void nfu_1::cycle(){
    pipe_op *op;
//    std::cout << "NFU_1: cycle" << std::endl;
    if(!input_op->empty()){
        // Only push through if both SRAM reads are complete
        std::cout << "NFU_1: input non-empty" << std::endl;
        op = input_op->front();
        if( op->is_read_complete() ){
            std::cout << "NFU_1: SRAM reads complete, pushing through" << std::endl;
            input_op->pop();
            output_op->push(op);
        }
    }   
}

//////////////////
// NFU-2 Stage
//////////////////
nfu_2::nfu_2(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size) : pipe_stage(i_op, o_op, queue_size){

}
nfu_2::~nfu_2(){

}
void nfu_2::cycle(){
    pipe_op *op;
//    std::cout << "NFU_2: cycle" << std::endl;
    if(!input_op->empty()){
        std::cout << "NFU_2: input non-empty" << std::endl;
        op = input_op->front();
        input_op->pop();
        output_op->push(op);
    }
}

//////////////////
// NFU-3 Stage
//////////////////
nfu_3::nfu_3(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size) : pipe_stage(i_op, o_op, queue_size){

}
nfu_3::~nfu_3(){

}
void nfu_3::cycle(){
    pipe_op *op;
//    std::cout << "NFU_3: cycle" << std::endl;
    if(!input_op->empty()){
        std::cout << "NFU_3: input non-empty" << std::endl;
        op = input_op->front();
        input_op->pop();
        op->set_write();
        output_op->push(op);
    }
}
