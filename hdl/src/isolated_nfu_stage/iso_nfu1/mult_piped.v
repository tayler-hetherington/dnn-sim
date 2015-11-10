
module mult_piped (
        clk,
        a_in,
        b_in,
        y_out
    );

    parameter BIT_WIDTH = 16;
    parameter NUM_PIPE_REGS = 2;

    parameter Q=10;
    parameter N=16;

    input clk;     
    input [BIT_WIDTH-1:0] a_in, b_in;
    output [BIT_WIDTH-1:0] y_out;
    

    reg [BIT_WIDTH-1 : 0] a_reg [NUM_PIPE_REGS-1 : 0];
    reg [BIT_WIDTH-1 : 0] b_reg [NUM_PIPE_REGS-1 : 0];
    reg [BIT_WIDTH-1 : 0] y_reg [NUM_PIPE_REGS-1 : 0];


    wire [BIT_WIDTH-1:0] mult_out;

    // Registers after
    assign y_out = y_reg[1];

    qmult #(.Q(Q), .N(N)) MULT (
        a_reg[0],
        b_reg[0],
        mult_out
    );
    
    always @ (posedge clk) begin // pipeline_stages
        a_reg[1] = a_reg[0];
        b_reg[1] = b_reg[0];
        y_reg[1] = y_reg[0];

        // multiply result (a_in*b_in) appears after +clk
        a_reg[0] = a_in;
        b_reg[0] = b_in;
        y_reg[0] = mult_out;
    end

endmodule


