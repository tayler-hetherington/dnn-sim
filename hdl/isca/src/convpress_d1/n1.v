
// This module implements a single 16-1 adder tree + accumulator

module n1_cluster (
        clk,
        i_vals,
        i_partial_sum,
        o_res
    );

    parameter N  = 16;
    parameter Tn = 16;

    input                       clk;
    input   [Tn*Tn*N-1:0]       i_vals;
    input   [Tn*N-1:0]          i_partial_sum;
    output  [Tn*N-1:0]          o_res;

    wire    [Tn*Tn*N-1:0]       swizzle_vals;
    wire    [Tn*N-1:0]          addr_tree_out;


    // Swizzle
    genvar i;
    generate
        for(i=0; i<Tn*Tn; i=i+1) begin : SWIZ
            assign swizzle_vals [ (i+1)*N - 1: i*N ] = i_vals[ (i*N*Tn) % (Tn*Tn*N) + N*(i/N) + (N-1) : (i*N*Tn) % (Tn*Tn*N) + N*(i/N) ];
        end
    endgenerate

    
    // Create the Tn adder trees
    generate
        for(i=0; i<Tn; i=i+1) begin : ADDER_TREES
            adder_tree TREE (
                clk,
                swizzle_vals[ (i+1)*Tn*N - 1 : i*Tn*N ],
                addr_tree_out[ (i+1)*N-1 : i*N ]
            );
        end
    endgenerate

    // Add the partial sum at the end
    generate
        for(i=0; i<Tn; i=i+1) begin : ACCUMULATORS
            m_addr PARTIAL_SUM (
                addr_tree_out [ (i+1)*N - 1 : i*N ],
                i_partial_sum [ (i+1)*N - 1 : i*N ],
                o_res         [ (i+1)*N - 1 : i*N ]
            );
        end
    endgenerate

endmodule

module adder_tree (
        clk,
        i_vals,
        o_res
    );

    parameter N = 16;
    parameter Tn = 16;
    parameter NxTn = 256;

    input                       clk;
    input   [NxTn-1:0]          i_vals;
    output  [N-1:0]             o_res;

    //----------- Internal Signals ---------------//

    // Adder tree connection wires
    wire [ (NxTn/2) - 1 : 0 ]   level_0_out;    // 8 buses
    wire [ (NxTn/4) - 1 : 0 ]   level_1_out;    // 4 busses
    wire [ (NxTn/8) - 1 : 0 ]   level_2_out;    // 2 busses
    wire [ (NxTn/16) - 1 : 0 ]  level_3_out;    // 1 bus

    reg  [ (NxTn/4)-1 : 0]      level_1_reg;

    always @(posedge clk) begin
        level_1_reg <= level_1_out;
    end

    // Construct the adder tree
    adder_array #(.W(8), .N(16)) L0 (i_vals, level_0_out);
    adder_array #(.W(4), .N(16)) L1 (level_0_out, level_1_out);
    adder_array #(.W(2), .N(16)) L2 (level_1_reg, level_2_out);
    adder_array #(.W(1), .N(16)) L3 (level_2_out, level_3_out);
 
    assign o_res = level_3_out;

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
