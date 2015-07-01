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



pipe_stage::pipe_stage(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size, unsigned num_int_pipeline_stages) :
                       input_op(i_op), output_op(o_op), q_size(queue_size), n_int_pipeline_stages(num_int_pipeline_stages) {

    int_pipeline = new pipe_op *[n_int_pipeline_stages];
    for(unsigned i=0; i<n_int_pipeline_stages; ++i){
        int_pipeline[i] = NULL;
    }
    
}

pipe_stage::~pipe_stage(){
    
    if(int_pipeline)
        delete[] int_pipeline;   
    
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

bool pipe_stage::is_pipe_reg_full(pipe_reg *reg){
    if(reg->size() >= q_size)
        return true;
    else
        return false;
}

void pipe_stage::print_internal_pipeline(){
    pipe_op *op = NULL;
    if(!input_op->empty())
        op = input_op->front();
    
    std::cout << " | " << op << " | ";
    for(unsigned i=0; i<n_int_pipeline_stages; ++i){
        std::cout << int_pipeline[i] << " | ";
    }
    std::cout << std::endl;
    
}


//////////////////
// NFU-1 Stage
//////////////////
nfu_1::nfu_1(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size, unsigned num_int_pipeline_stages) :
            pipe_stage(i_op, o_op, queue_size, num_int_pipeline_stages){

}

nfu_1::~nfu_1(){

}

void nfu_1::cycle(){
    pipe_op *op;
    // std::cout << "NFU_1: cycle" << std::endl;

    if(!is_pipe_reg_full(output_op)){ // If there's space to push the operation to the next pipeline stage
        
        // Push first operation to next pipeline stage, if any
        op = int_pipeline[n_int_pipeline_stages-1];
        if(op)
            output_op->push(op);
        
        // Progress internal stage pipeline
        for(int i=n_int_pipeline_stages-1; i>0; --i){
            int_pipeline[i] = int_pipeline[i-1];
        }
        int_pipeline[0] = NULL;
        
        if(!input_op->empty()){
            // Only push through if both SRAM reads are complete
            std::cout << "NFU_1: input non-empty" << std::endl;
            op = input_op->front();
            if( op->is_read_complete() ){
                std::cout << "NFU_1: SRAM reads complete, pushing through" << std::endl;
                input_op->pop();
                int_pipeline[0] = op;
            }
        }
    }
    
}

void nfu_1::print_internal_pipeline(){
    std::cout << "NFU-1: ";
    pipe_stage::print_internal_pipeline();
}

//////////////////
// NFU-2 Stage
//////////////////
nfu_2::nfu_2(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size, unsigned num_int_pipeline_stages) :
            pipe_stage(i_op, o_op, queue_size, num_int_pipeline_stages){

}
nfu_2::~nfu_2(){

}
void nfu_2::cycle(){
    
    pipe_op *op;
    // std::cout << "NFU_1: cycle" << std::endl;
    if(!is_pipe_reg_full(output_op)){ // If there's space to push the operation to the next pipeline stage
        
        // Push first operation to next pipeline stage, if any
        op = int_pipeline[n_int_pipeline_stages-1];
        if(op)
            output_op->push(op);
        
        // Progress internal stage pipeline
        for(int i=n_int_pipeline_stages-1; i>0; --i){
            int_pipeline[i] = int_pipeline[i-1];
        }
        int_pipeline[0] = NULL;
        
        if(!input_op->empty()){
            std::cout << "NFU_2: input non-empty" << std::endl;
            op = input_op->front();
            input_op->pop();
            int_pipeline[0] = op;
        }
    }
    
}

void nfu_2::print_internal_pipeline(){
    std::cout << "NFU-2: ";
    pipe_stage::print_internal_pipeline();
}

//////////////////
// NFU-3 Stage
//////////////////
nfu_3::nfu_3(pipe_reg *i_op, pipe_reg *o_op, unsigned queue_size, unsigned num_int_pipeline_stages) :
            pipe_stage(i_op, o_op, queue_size, num_int_pipeline_stages){

}
nfu_3::~nfu_3(){

}

void nfu_3::cycle(){
    pipe_op *op;
    // std::cout << "NFU_3: cycle" << std::endl;
    if(!is_pipe_reg_full(output_op)){ // If there's space to push the operation to the next pipeline stage
        
        // Push first operation to next pipeline stage, if any
        op = int_pipeline[n_int_pipeline_stages-1];
        if(op)
            output_op->push(op);
        
        // Progress internal stage pipeline
        for(int i=n_int_pipeline_stages-1; i>0; --i){
            int_pipeline[i] = int_pipeline[i-1];
        }
        int_pipeline[0] = NULL;
        
        if(!input_op->empty()){
            std::cout << "NFU_3: input non-empty" << std::endl;
            op = input_op->front();
            input_op->pop();
            op->set_write();
            int_pipeline[0] = op;
        }
    }
}

void nfu_3::print_internal_pipeline(){
    std::cout << "NFU-3: ";
    pipe_stage::print_internal_pipeline();
}
