
module top_level (
        clk,
        i_nfu1,
        i_partial_sum,
        i_l1_sel_lines,
        i_l2_sel_lines,
        i_buf_read_addr,
        i_buf_write_addr,
        i_write_en,
        o_nfu2B
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter OUT_LIMIT = 2;
    parameter IN_LIMIT = 3;

    parameter ADDR_SIZE   = 2;
    parameter NUM_BUFFERS = 1 << ADDR_SIZE;

    parameter L1_SEL_WIDTH = 4;
    parameter L1_NUM_INPUTS = 1 << L1_SEL_WIDTH;

    // OUT_LIMIT = 1
    // parameter L2_SEL_WIDTH = 5;

    // OUT_LIMIT = 2
    parameter L2_SEL_WIDTH = 6;

    parameter L2_NUM_INPUTS = 1 << L2_SEL_WIDTH;
    
    //------------ Inputs ------------//
    input clk;

    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ]                 i_nfu1;
    input [ (Tn*OUT_LIMIT*L1_SEL_WIDTH) - 1 : 0 ]       i_l1_sel_lines;
    input [ (Tn*IN_LIMIT*L2_SEL_WIDTH) - 1 : 0 ]        i_l2_sel_lines;

    input [ ((BIT_WIDTH*Tn) - 1) : 0 ] i_partial_sum; // Partial sum from NBout (nfu2/nfu3 pipe reg)


    input [ (Tn*ADDR_SIZE) - 1 : 0 ]                    i_buf_read_addr;
    input [ (Tn*ADDR_SIZE) - 1 : 0 ]                    i_buf_write_addr;

    input [ Tn-1 : 0 ]                                  i_write_en;

    output [ (Tn*BIT_WIDTH) - 1 : 0 ] o_nfu2B;

    //wire [ (TnxTn + IN_LIMIT)*BIT_WIDTH - 1 : 0 ]     o_nfu2A;
    wire [ (Tn*IN_LIMIT)*BIT_WIDTH - 1 : 0 ] o_nfu2A;


    nfu_2A #(.OUT_LIMIT(OUT_LIMIT), .IN_LIMIT(IN_LIMIT), .L2_SEL_WIDTH(L2_SEL_WIDTH) ) N0 (
        clk,
        i_nfu1,
        i_l1_sel_lines,
        i_l2_sel_lines,
        i_buf_read_addr,
        i_buf_write_addr,
        i_write_en,
        o_nfu2A
    );

    nfu_2B #(.IN_LIMIT(IN_LIMIT) ) N1 (
       clk,
       i_nfu1,
       o_nfu2A,
       i_partial_sum,
       o_nfu2B
    );








//    assign o_out = reg_out;

/*
always @(posedge clk) begin
    reg_cur_inputs <= i_cur_inputs;
    reg_repl_cands <= i_repl_cands;
    reg_out        <= mux_tree_out;
end
*/

endmodule

