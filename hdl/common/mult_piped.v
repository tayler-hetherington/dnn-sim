
module mult_piped (
        clk,
        a_in,
        b_in,
        y_out
    );

    parameter N = 16;
    parameter NUM_PIPE_REGS = 2;

    input           clk;     
    input [N-1:0]   a_in, b_in;
    output [N-1:0]  y_out;

    wire [N-1:0]    mult_out;


    // Now pushing the pipeline registers UP to before the multipliers
    // no additional pipelineing here. See if this still works
    assign y_out = mult_out;
    
    m_mult MULT (
        a_in,
        b_in,
        mult_out
    );

endmodule
