

module top_level (
        clk,
        i_inputs,
        i_sel,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter SEL_WIDTH = 1;
    parameter NUM_INPUTS = 1 << SEL_WIDTH;

    input clk;
    input [(NUM_INPUTS*BIT_WIDTH)-1:0] i_inputs;
    input [(SEL_WIDTH-1):0] i_sel;
    output [(BIT_WIDTH-1):0] o_outputs;


    reg [(SEL_WIDTH-1):0] sel;
    reg [(BIT_WIDTH - 1):0] in1, in2;
    reg [(BIT_WIDTH - 1):0] out1;
    
    wire [(BIT_WIDTH - 1):0] t_o;

    
    mux_2_to_1 M0 (
        sel,
        in1,
        in2, 
        t_o
    );

    assign o_outputs = out1;
    
    always @(posedge clk) begin
        sel <= i_sel;
        in1 <= i_inputs[BIT_WIDTH-1:0];
        in2 <= i_inputs[2*BIT_WIDTH - 1: BIT_WIDTH];
        out1 <= t_o;
    end
/*
    my_mux M0 (
        i_sel,
        i_inputs[BIT_WIDTH-1:0],
        i_inputs[2*BIT_WIDTH - 1: BIT_WIDTH],
        o_outputs
    );
*/
/*    
    mux_4_to_1 M0 (
        i_sel,
        i_inputs[BIT_WIDTH-1:0],
        i_inputs[2*BIT_WIDTH - 1: BIT_WIDTH],
        i_inputs[3*BIT_WIDTH - 1: 2*BIT_WIDTH],
        i_inputs[4*BIT_WIDTH - 1: 3*BIT_WIDTH],
        o_outputs
    );
*/

endmodule
