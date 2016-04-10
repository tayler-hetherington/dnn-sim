module nfu_3_top (
        clk,    
        i_nfu2_out,
        i_coef,
        i_load_coef,
        i_max,
        i_min,
        i_offset,
        o_nfu3_out
    );

    parameter N  = 16;
    parameter Tn = 16;
    parameter BIT_IDX = 4;
    
    input                       clk;
    input                       i_load_coef;
    input [((2*N)-1):0]         i_coef;
    
    input [ (Tn*N) - 1 : 0 ]    i_nfu2_out;

    // control signals for rounder
    input [N-1:0]           i_max;
    input [N-1:0]           i_min;
    input [BIT_IDX-1:0]     i_offset;  

    output [ (Tn*N) - 1 : 0 ]   o_nfu3_out;

    /*
    reg                       i_load_coef_reg;
    reg [((2*N)-1):0]         i_coef_reg;
    reg [ (Tn*N) - 1 : 0 ]    i_nfu2_out_reg;
    reg [N-1:0]           i_max_reg;
    reg [N-1:0]           i_min_reg;
    reg [BIT_IDX-1:0]     i_offset_reg;  
    reg [ (Tn*N) - 1 : 0 ]   nfu3_out_reg;
    */

    wire [ (Tn*N) - 1 : 0 ]   nfu3_out;
    
    ////////////////////////////////////////
    //assign o_nfu3_out = nfu3_out_reg;
    assign o_nfu3_out = nfu3_out;
    
    /*
    always @(posedge clk) begin
        i_load_coef_reg     <= i_load_coef;
        i_coef_reg          <= i_coef;
        i_nfu2_out_reg      <= i_nfu2_out;
        i_max_reg           <= i_max;
        i_min_reg           <= i_min;
        i_offset_reg        <= i_offset;
        nfu3_out_reg        <= nfu3_out;
    end

    nfu_3 NFU3(
        clk,    
        i_nfu2_out_reg,
        i_coef_reg,
        i_load_coef_reg,
        i_max_reg,
        i_min_reg,
        i_offset_reg,
        nfu3_out
    );
    */

   nfu_3 NFU3(
        clk,    
        i_nfu2_out,
        i_coef,
        i_load_coef,
        i_max,
        i_min,
        i_offset,
        nfu3_out
    );

endmodule
