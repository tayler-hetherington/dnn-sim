
module top_level_test (
        clk,
        i_vals,
        o_res
    );

    parameter N = 16;
    parameter Tn = 16;

    // Inputs
    input                   clk;
    input [Tn*Tn*N-1:0]     i_vals;
    
    // Outputs
    output [Tn*N-1:0]       o_res;

    reg [Tn*Tn*N-1:0]          vals_reg;
    reg [Tn*N-1:0]             res_reg;

    wire [Tn*N-1:0]            add_tree_out;

    n1_cluster ADDER_TREES (
        clk,
        i_vals,
        add_tree_out
    );

    always @(posedge clk) begin
        vals_reg    = i_vals;
        res_reg     = add_tree_out;
    end
            
    assign o_res = add_tree_out;

endmodule
