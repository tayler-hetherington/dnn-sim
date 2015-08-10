
module top_level (
        clk,
        i_cur_inputs,
        i_repl_cands,
        i_sel_lines,
        o_out
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;
  
    parameter D = 3;
    parameter W = 4;

    parameter SEL_WIDTH = 4;
    parameter NUM_MUX_INPUTS = (1 << SEL_WIDTH);

    
    //------------ Inputs ------------//
    input clk;
    input [ (BIT_WIDTH*Tn) - 1 : 0 ]        i_cur_inputs;
    input [ (BIT_WIDTH*Tn*D) - 1 : 0 ]      i_repl_cands;
    input [ (SEL_WIDTH*TnxTn) - 1 : 0 ]     i_sel_lines;

    //------------ Outputs ------------//
    output [ (BIT_WIDTH*TnxTn) - 1 : 0 ]    o_out;

    reg [ (BIT_WIDTH*Tn) - 1 : 0 ]          reg_cur_inputs;
    reg [ (BIT_WIDTH*Tn*D) - 1 : 0 ]        reg_repl_cands;

    // Reg for select lines?

    wire [ (BIT_WIDTH*TnxTn) - 1 : 0 ]      mux_tree_out;
    reg [ (BIT_WIDTH*TnxTn) - 1 : 0 ]       reg_out;

    assign o_out = reg_out;

    /*
    nfu_1A_D5_W15 MOD3 (
        reg_cur_inputs,
        reg_repl_cands,
        i_sel_lines,
        mux_tree_out
    );
    */
 
    nfu_1A_D3_W4 MOD2 (
        reg_cur_inputs,
        reg_repl_cands,
        i_sel_lines,
        mux_tree_out
    );
    
    /*
    nfu_1A_D1_W0 MOD1 (
        reg_cur_inputs,
        reg_repl_cands,
        i_sel_lines,
        mux_tree_out
    );
    */

    always @(posedge clk) begin
        reg_cur_inputs <= i_cur_inputs;
        reg_repl_cands <= i_repl_cands;
        reg_out        <= mux_tree_out;
    end

endmodule

