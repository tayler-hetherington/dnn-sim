
module mult_piped (
        clk,
        a_in,
        b_in,
        y_out
    );

    parameter N = 16;
    parameter NUM_PIPE_REGS = 2;

    input clk;     
    input [N-1:0] a_in, b_in;
    output [N-1:0] y_out;

    
    reg [N-1 : 0] y_reg [NUM_PIPE_REGS-1 : 0];
    wire [N-1:0] mult_out;

    m_mult MULT (
        a_in,
        b_in,
        mult_out 
    );

    always @ (posedge clk) begin
        y_reg[1] <= y_reg[0];
        y_reg[0] <= mult_out;
    end

    assign y_out = y_reg[1];


    /*
    reg [N-1 : 0] a_reg;
    reg [N-1 : 0] b_reg;

    reg [N-1 : 0] y_reg [NUM_PIPE_REGS-1 : 0];

    wire [N-1:0] mult_out;

    // Registers after
    assign y_out = y_reg[1];

    m_mult MULT (
        a_reg,
        b_reg,
        mult_out
    );

    // pipeline_stages
    always @ (posedge clk) begin
        y_reg[1] <= y_reg[0];

        // multiply result (a_in*b_in) appears after +clk
        a_reg <= a_in;
        b_reg <= b_in;
        y_reg[0] <= mult_out;
    end
    */

/*
    reg [N-1 : 0] a_reg [NUM_PIPE_REGS-1 : 0];
    reg [N-1 : 0] b_reg [NUM_PIPE_REGS-1 : 0];
    reg [N-1 : 0] y_reg [NUM_PIPE_REGS-1 : 0];

    wire [N-1:0] mult_out;

    // Registers after
    assign y_out = y_reg[1];

    m_mult MULT (
        a_reg[1],
        b_reg[1],
        mult_out
    );

    // pipeline_stages
    always @ (posedge clk) begin
        a_reg[1] <= a_reg[0];
        b_reg[1] <= b_reg[0];
        y_reg[1] <= y_reg[0];

        // multiply result (a_in*b_in) appears after +clk
        a_reg[0] <= a_in;
        b_reg[0] <= b_in;
        y_reg[0] <= mult_out;
    end
    */
endmodule


