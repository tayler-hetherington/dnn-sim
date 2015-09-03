
module top_level (
        clk,
        i_nfu1,
        i_partial_sum,
        i_load_partial_sum,
        i_l1_sel_lines,
        i_l2_sel_lines,
        i_extra_l2_bits,
        o_l2_bits,
        o_output

    );

    parameter BIT_WIDTH = 16;
    
    parameter Tn = 16;
    parameter G = 4;
    parameter TnxTn = Tn*G;


    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter L1_SEL_WIDTH = 4;
    parameter L1_NUM_INPUTS = 1 << L1_SEL_WIDTH;

    parameter L2_SEL_WIDTH = 2; // OUT_LIMIT = 1
    //parameter L2_SEL_WIDTH = 3; // OUT_LIMIT = 2


    parameter L2_NUM_INPUTS = 1 << L2_SEL_WIDTH;
    
    parameter EXTRA_L2_BITS = 2;

    //------------ Inputs ------------//
    input clk;
    input i_load_partial_sum;
    input [ (Tn/G)*(TnxTn)*BIT_WIDTH - 1 : 0 ]                 i_nfu1;
    input [ (Tn/G)*(G*OUT_LIMIT*L1_SEL_WIDTH) - 1 : 0 ]       i_l1_sel_lines;
    input [ (Tn/G)*(G*IN_LIMIT*L2_SEL_WIDTH) - 1 : 0 ]        i_l2_sel_lines;

    input [ (Tn/G)*(G*IN_LIMIT*EXTRA_L2_BITS) - 1 : 0 ]       i_extra_l2_bits;
    output [ (Tn/G)*(G*IN_LIMIT*EXTRA_L2_BITS) - 1 : 0 ]      o_l2_bits;

    input [ (Tn/G)*G*BIT_WIDTH - 1 : 0 ] i_partial_sum; // Partial sum from NBout (nfu2/nfu3 pipe reg)


    output [ (Tn/G)*(G*BIT_WIDTH) - 1 : 0 ] o_output;
    
    wire [ (Tn/G)*(G*BIT_WIDTH) - 1 : 0 ] o_nfu2B;

    //wire [ (TnxTn + IN_LIMIT)*BIT_WIDTH - 1 : 0 ]     o_nfu2A;
    wire [ (Tn/G)*(G*IN_LIMIT)*BIT_WIDTH - 1 : 0 ] o_nfu2A;


    // Registers
    //      - nfu1  (From multiplication output)
    //      - L1 and L2 sel lines (For internal muxes)
    //      - Parital sum   (actually NFU-2/NFU-3 pipe register)

    reg [ (Tn/G)*(TnxTn)*BIT_WIDTH - 1 : 0 ]                nfu1_reg;
    reg [ (Tn/G)*G*BIT_WIDTH - 1 : 0 ]                      partial_sum_reg; // Partial sum from NBout (nfu2/nfu3 pipe reg)


    genvar i;
    generate
        for(i=0; i<(Tn/G); i=i+1) begin : TOP_GEN_G

            nfu_2A #(.OUT_LIMIT(OUT_LIMIT), .IN_LIMIT(IN_LIMIT), .L2_SEL_WIDTH(L2_SEL_WIDTH), .Tn(Tn), .TnxTn(TnxTn), .G(G) ) N0 (
                clk,
                nfu1_reg[ (i+1)*Tn*G*BIT_WIDTH - 1 : i*Tn*G*BIT_WIDTH  ],
                i_l1_sel_lines[ (i+1)*G*L1_SEL_WIDTH*OUT_LIMIT - 1 :  i*G*L1_SEL_WIDTH*OUT_LIMIT ],
                i_l2_sel_lines[ (i+1)*G*L2_SEL_WIDTH*IN_LIMIT - 1 :  i*G*L2_SEL_WIDTH*IN_LIMIT ],
                o_nfu2A[ (i+1)*G*IN_LIMIT*BIT_WIDTH - 1 : i*G*IN_LIMIT*BIT_WIDTH ]
            );

            nfu_2B #(.IN_LIMIT(IN_LIMIT), .Tn(Tn), .TnxTn(TnxTn), .G(G) ) N1 (
                clk,
                nfu1_reg[ (i+1)*Tn*G*BIT_WIDTH - 1 : i*Tn*G*BIT_WIDTH  ],
                o_nfu2A[ (i+1)*G*IN_LIMIT*BIT_WIDTH - 1 : i*G*IN_LIMIT*BIT_WIDTH ],
                partial_sum_reg[ (i+1)*G*BIT_WIDTH - 1 : i*G*BIT_WIDTH ],
                o_nfu2B[ (i+1)*G*BIT_WIDTH - 1 : i*G*BIT_WIDTH ]
            );
        end
    endgenerate

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



module top_level_base (
        clk,
        i_nfu1,
        i_partial_sum,
        i_load_partial_sum,
        o_output
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 4;

    parameter TnxTn = Tn*G;

    //------------ Inputs ------------//
    input clk;
    input i_load_partial_sum;
    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ]     i_nfu1;
    input [ ((G*BIT_WIDTH) - 1) : 0 ]      i_partial_sum; // Partial sum from NBout (nfu2/nfu3 pipe reg)

    output [ (G*BIT_WIDTH) - 1 : 0 ]       o_output;
    
    wire [ (G*BIT_WIDTH) - 1 : 0 ]         o_nfu2B;

    // Registers
    //      - nfu1  (From multiplication output)
    //      - Parital sum   (actually NFU-2/NFU-3 pipe register)

    reg [ (TnxTn)*BIT_WIDTH - 1 : 0 ]                 nfu1_reg;
    reg [ ((G*BIT_WIDTH) - 1) : 0 ]                  partial_sum_reg; // Partial sum from NBout (nfu2/nfu3 pipe reg)

    nfu_2 #(.Tn(Tn), .TnxTn(TnxTn), .G(G)) N0 (
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

