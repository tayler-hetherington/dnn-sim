
module top_pipe (
        clk,
        i_nfu1,
        i_partial_sum,
        i_load_partial_sum,
        o_output
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = Tn*Tn;
    
    //------------ Inputs ------------//
    input clk;
    input i_load_partial_sum;
    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ]     i_nfu1;
    input [ ((Tn*BIT_WIDTH) - 1) : 0 ]      i_partial_sum; // Partial sum from NBout (nfu2/nfu3 pipe reg)

    output [ (Tn*BIT_WIDTH) - 1 : 0 ]       o_output;
    
    wire [ (Tn*BIT_WIDTH) - 1 : 0 ]         o_nfu2B;

    // Registers
    //      - nfu1  (From multiplication output)
    //      - Parital sum   (actually NFU-2/NFU-3 pipe register)

    reg [ (TnxTn)*BIT_WIDTH - 1 : 0 ]                 nfu1_reg;
    reg [ ((Tn*BIT_WIDTH) - 1) : 0 ]                  partial_sum_reg; // Partial sum from NBout (nfu2/nfu3 pipe reg)

    nfu_2_pipe #(.Tn(Tn), .TnxTn(TnxTn)) N0 (
        clk,
        nfu1_reg,
        partial_sum_reg,
        o_nfu2B
    );

    assign o_output = partial_sum_reg;

    // Latch the inputs and outputs for timing constraints
    always @(posedge clk) begin
        nfu1_reg <= i_nfu1;
   
        if(i_load_partial_sum == 1) begin
            partial_sum_reg <= i_partial_sum;
        end else begin
            partial_sum_reg <= o_nfu2B;
        end
    end


endmodule

