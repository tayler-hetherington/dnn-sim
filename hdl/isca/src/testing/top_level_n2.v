
module top_level_test (
        clk,
        i_X,
        i_coef,
        i_load_coef,
        o_Y
    );

    parameter N = 16;

    // Inputs
    input                   clk;
    input [N-1:0]           i_X;
    input [2*N-1:0]         i_coef;
    input                   i_load_coef;
    
    // Outputs
    output [N-1:0]          o_Y;
 
    reg [N-1:0]             X_reg;
    reg [2*N-1:0]           coef_reg;
    reg                     load_coef_reg;
    reg [N-1:0]             Y_reg;

    wire [N-1:0]            n3_out;


    assign o_Y = Y_reg;

    n3  N3 (
        clk,
        X_reg,
        coef_reg,
        load_coef_reg,
        n3_out
    );

    always @(posedge clk) begin
        X_reg           = i_X;
        coef_reg        = i_coef;
        load_coef_reg   = i_load_coef;
        Y_reg           = n3_out;
    end
            


endmodule
