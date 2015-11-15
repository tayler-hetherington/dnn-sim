
module top_level_test (
        clk,
        i_vals,
        o_res
    );

    parameter N = 16;
    parameter Tn = 16;
    parameter NxTn = 256;

    // Inputs
    input                   clk;
    input [NxTn-1:0]        i_vals;
    
    // Outputs
    output [N-1:0]          o_res;

    reg [NxTn-1:0]          vals_reg;
    reg [N-1:0]             res_reg;

    wire [N-1:0]            add_tree_out;

    n2 ADD_TREE (
        i_vals,
        add_tree_out
    );

    always @(posedge clk) begin
        vals_reg    = i_vals;
        res_reg     = add_tree_out;
    end
            
    assign o_res = add_tree_out;

endmodule
