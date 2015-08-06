

module top_level (
        i_inputs,
        i_sel,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter SEL_WIDTH = 1;
    parameter NUM_INPUTS = 1 << SEL_WIDTH;

    input [(NUM_INPUTS*BIT_WIDTH)-1:0] i_inputs;
    input [(SEL_WIDTH-1):0] i_sel;
    output [(BIT_WIDTH-1):0] o_outputs;

/*
   mux_N  #(.BIT_WIDTH(BIT_WIDTH), .SEL_WIDTH(SEL_WIDTH), .NUM_INPUTS(NUM_INPUTS)) M0 (
       i_sel,
       i_inputs,
       o_outputs
   );
*/
    mux_2_to_1 M0 (
        i_sel,
        i_inputs[BIT_WIDTH-1:0],
        i_inputs[2*BIT_WIDTH - 1: BIT_WIDTH],
        o_outputs
    );


endmodule
