
module top_level_test (
        clk,
        i_nbin,
        i_sb,
        i_nbout,
        o_res
    );

    parameter N = 16;

    // Inputs
    input                   clk;
    input [N-1:0]           i_nbin, i_sb, i_nbout;
    
    // Outputs
    output [N-1:0]          o_res;

    reg [N-1:0]             nbin_reg, sb_reg, nbout_reg;
    reg [N-1:0]             res_reg;

    wire [N-1:0]            n1_out;

    n1 MULT_ADD (
        nbin_reg,
        sb_reg,
        nbout_reg,
        n1_out
    );

    always @(posedge clk) begin
        nbin_reg    = i_nbin;
        sb_reg      = i_sb;
        nbout_reg   = i_nbout;
        res_reg     = res_reg;
    end
            


endmodule
