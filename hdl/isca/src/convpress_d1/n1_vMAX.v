
// This module implements a single 16-1 adder tree + accumulator

module n1_cluster_vMAX (
        clk,
        i_vals,
        i_partial_sum,
        i_op,
        o_res
    );

    parameter N  = 16;
    parameter Tn = 16;
    parameter N_OPS = 1;

    input                       clk;
    input [N_OPS-1:0]           i_op;

    input   [Tn*Tn*N-1:0]       i_vals;
    input   [Tn*N-1:0]          i_partial_sum;
    output  [Tn*N-1:0]          o_res;

    wire    [Tn*Tn*N-1:0]       swizzle_vals;
    wire    [Tn*N-1:0]          addr_tree_out;
    wire    [Tn*N-1:0]          max_tree_out;

    wire [ (Tn*N-1) : 0 ]       partial_sum_out; // 1 bus from partial sum add
    wire [ (Tn*N-1) : 0 ]       partial_max_out; // 1 bus from partial sum add

    // i_op == 0: Sum
    // i_op == 1: Max
    
    // Output
    assign o_res = (i_op) ? (partial_max_out) : (partial_sum_out);


    // Swizzle
    genvar i;
    generate
        for(i=0; i<Tn*Tn; i=i+1) begin : SWIZ
            assign swizzle_vals [ (i+1)*N - 1: i*N ] = i_vals[ (i*N*Tn) % (Tn*Tn*N) + N*(i/N) + (N-1) : (i*N*Tn) % (Tn*Tn*N) + N*(i/N) ];
        end
    endgenerate

    
    // Create the Tn adder/max trees (single internal pipe reg)
    generate
        for(i=0; i<Tn; i=i+1) begin : ADDER_MAX_TREES
            adder_max_tree TREE (
                clk,
                swizzle_vals[ (i+1)*Tn*N - 1 : i*Tn*N ],
                i_op,
                addr_tree_out[ (i+1)*N-1 : i*N ],
                max_tree_out[ (i+1)*N-1 : i*N ]
            );
        end
    endgenerate

    // Add the partial sum at the end
    generate
        for(i=0; i<Tn; i=i+1) begin : ACCUMULATORS
            m_addr L4_A (
                addr_tree_out   [ (i+1)*N - 1 : i*N ],
                i_partial_sum   [ (i+1)*N - 1 : i*N ],
                partial_sum_out [ (i+1)*N - 1 : i*N ]
            );
        end
    endgenerate
    
    // Compute the partial max at the end
    generate
        for(i=0; i<Tn; i=i+1) begin : FINAL_MAX
            max_op L4_M (
                max_tree_out    [ (i+1)*N - 1 : i*N ],
                i_partial_sum   [ (i+1)*N - 1 : i*N ],
                partial_max_out [ (i+1)*N - 1 : i*N ]
            );
        end
    endgenerate

endmodule

module adder_max_tree (
        clk,
        i_vals,
        i_op,
        o_addr_res,
        o_max_res
    );

    parameter N = 16;
    parameter Tn = 16;
    parameter NxTn = 256;
    parameter N_OPS = 1;

    input                           clk;
    input [N_OPS-1:0]               i_op;

    input   [NxTn-1:0]              i_vals;
    output  [N-1:0]                 o_addr_res;
    output  [N-1:0]                 o_max_res;

    //----------- Internal Signals ---------------//

    // Adder tree connection wires
    wire [ (NxTn/2)-1 : 0 ]        level_0_addr_out;    // 8 buses
    wire [ (NxTn/4)-1 : 0 ]        level_1_addr_out;    // 4 busses
    wire [ (NxTn/8)-1 : 0 ]        level_2_addr_out;    // 2 busses
    wire [ (NxTn/16)-1 : 0 ]       level_3_addr_out;    // 1 bus
    
    wire [ (NxTn/2)-1 : 0 ]        level_0_max_out;    // 8 buses
    wire [ (NxTn/4)-1 : 0 ]        level_1_max_out;    // 4 busses
    wire [ (NxTn/8)-1 : 0 ]        level_2_max_out;    // 2 busses
    wire [ (NxTn/16)-1 : 0 ]       level_3_max_out;    // 1 bus

    reg  [ (NxTn/4)-1 : 0]          level_1_reg;
    wire [ (NxTn/4)-1 : 0 ]         op_to_reg;
    
    // Output
    assign o_addr_res   = level_3_addr_out;
    assign o_max_res    = level_3_max_out;

    // Select addr or max to write to internal pip reg
    assign op_to_reg    = (i_op) ? (level_1_max_out) : (level_1_addr_out);

    always @(posedge clk) begin
        level_1_reg     <= op_to_reg;
    end

    //---------- Adder Tree ------------/
    // Construct the adder tree
    adder_array #(.W(8), .N(16)) L0_A (i_vals, level_0_addr_out);
    adder_array #(.W(4), .N(16)) L1_A (level_0_addr_out, level_1_addr_out); // Separated here with pipeline reg
    adder_array #(.W(2), .N(16)) L2_A (level_1_reg, level_2_addr_out);      // ---
    adder_array #(.W(1), .N(16)) L3_A (level_2_addr_out, level_3_addr_out);
    
    //------------ Max Tree -------------/
    // Construct the max tree
    max_array #(.W(8), .N(16)) L0_M (i_vals, level_0_max_out);
    max_array #(.W(4), .N(16)) L1_M (level_0_max_out, level_1_max_out); // Separated here with pipeline reg
    max_array #(.W(2), .N(16)) L2_M (level_1_reg, level_2_max_out); // ---
    max_array #(.W(1), .N(16)) L3_M (level_2_max_out, level_3_max_out); 
   

endmodule



module adder_array (
        i_vals,
        o_res
    );
    
    parameter W = 8;
    parameter N = 16;

    input   [(2*W*N) - 1 : 0]       i_vals;
    output  [(W*N) - 1 : 0]   o_res;


    // Create W adders and add each pair of values from i_vals and store in o_res 
    // (e.g., [0]+[1], [2]+[3] ... [W-2]+[W-1] )
    genvar j;
    generate
        for(j=0; j<W; j=j+1) begin : Level1_i
            m_addr ADD_ARRAY (
                    i_vals  [ ((2*j)+1)*N - 1 : (2*j)*N       ],
                    i_vals  [ ((2*j)+2)*N - 1 : ( (2*j)+1 )*N ],
                    o_res   [ (j+1)*N - 1     : j*N           ]
            );
        end
    endgenerate 


endmodule

module max_array(
        i_vals,
        o_res
    );

    parameter W = 8;
    parameter N = 16;

    input   [(2*W*N) - 1 : 0] i_vals;
    output  [(W*N) - 1 : 0]   o_res;

    // Create W max ops for each pair of values from i_vals and store in o_res
    // (e.g., [0]>[1], [2]>[3] ... [W-2]>[W-1] )
    genvar j;
    generate
        for(j=0; j<W; j=j+1) begin : adder_array
            max_op MAX_ARRAY (
                    i_vals  [ ((2*j)+1)*N - 1 : (2*j)*N     ],
                    i_vals  [ ((2*j)+2)*N - 1 : ((2*j)+1)*N ],
                    o_res   [ (j+1)*N - 1     : j*N         ]
            ); 
        end
    endgenerate

endmodule

module max_op (
        i_A,
        i_B,
        o_C
    );

    parameter N = 16;

    input   [N-1:0]     i_A, i_B;
    output  [N-1:0]     o_C;

    assign o_C = (i_A > i_B) ? (i_A) : (i_B);


endmodule    

