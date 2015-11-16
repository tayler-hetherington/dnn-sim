//----------------------------------------------//
//----------------------------------------------//
// NFU-2: Convolution addition trees
// Tayler Hetherington
// 2015
//----------------------------------------------//
//----------------------------------------------//

//---------------------------------------------//
// 16, 16-bit adder trees with 15 adders each. 
// Input is Tn x Tx 16-bit multiplication results.
// Each group of 16 needs to be added. Result
// is 16, 16-bit values to be fed into NFU-3.
//---------------------------------------------//

module Tn_adder_tree_pipe (
        clk,
        i_nfu1,         // New multiplication data from NFU-1
        i_nbout,        // Partial SUM from NBOut
        o_results
    );


    parameter N = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;


    //----------- Input Ports ---------------//
    input                           clk;

    input [(N*Tn)-1:0]              i_nfu1;   // Tn x Tn inputs
    input [N-1:0]                   i_nbout;     // Tn partial sums
    
    //----------- Output Ports ---------------//
    output [N-1:0]                  o_results;
    
    //----------- Internal Signals ---------------//
    
    // Adder tree connection wires
    wire [ (TnxTn/2)-1 : 0 ]        level_0_out;    // 8 buses
    wire [ (TnxTn/4)-1 : 0 ]        level_1_out;    // 4 busses
    wire [ (TnxTn/8)-1 : 0 ]        level_2_out;    // 2 busses
    wire [ (TnxTn/16)-1 : 0 ]       level_3_out;    // 1 bus
    
    wire [ (N-1) : 0 ]              partial_sum_out; // 1 bus from partial sum add
    
    reg [ (TnxTn/4)-1 : 0 ]         level_1_reg;    // 4 busses pipe reg

    //------------------------------------------//
    //------------- Code Start -----------------//
    //------------------------------------------//
   
    // Internal pipe register (2 pipe stages)
    always @(posedge clk) begin
        level_1_reg <= level_1_out;
    end
    
    // Construct the adder tree
    adder_array #(.W(8), .N(16)) L0 (i_nfu1, level_0_out);
    adder_array #(.W(4), .N(16)) L1 (level_0_out, level_1_out); // Separated here with pipeline reg
    adder_array #(.W(2), .N(16)) L2 (level_1_reg, level_2_out); // ---
    adder_array #(.W(1), .N(16)) L3 (level_2_out, level_3_out);
    
    // Level 4: 
    //     DianNao paper only mentions 16 x 15 adders in the tree. But since adders are only
    //     2 input, we have Tn (16) values per neuron to add (15 adders) plus the partial sum (16 adders)
    m_addr L4 (
        level_3_out,
        i_nbout,
        partial_sum_out
    );
    
    // Output
    assign o_results = partial_sum_out;
    
endmodule 

module adder_array (
        i_vals,
        o_res
    );

    parameter W = 8;
    parameter N = 16;

    input   [(2*W*N) - 1 : 0] i_vals;
    output  [(W*N) - 1 : 0]   o_res;

    // Create W adders and add each pair of values from i_vals and store in o_res
    // (e.g., [0]+[1], [2]+[3] ... [W-2]+[W-1] )
    genvar j;
    generate
        for(j=0; j<W; j=j+1) begin : adder_array
            m_addr ADD_ARRAY (
                    i_vals  [ ((2*j)+1)*N - 1 : (2*j)*N       ],
                    i_vals  [ ((2*j)+2)*N - 1 : ( (2*j)+1 )*N ],
                    o_res   [ (j+1)*N - 1     : j*N           ]
            );
        end
    endgenerate

endmodule

//---------------------------------------------//
// Main NFU-2 module
//---------------------------------------------//
module nfu_2_pipe (
        clk,
        i_nfu1_out,
        i_nbout,
        o_nfu2_out
    );

    parameter N = 16;
    parameter Tn = 16;
    parameter TnxTn = Tn*Tn;

    //----------- Input Ports ---------------//
    input clk;
    
    input [ ((N*TnxTn) - 1) : 0 ]   i_nfu1_out;
    input [ ((N*Tn) - 1) : 0 ]      i_nbout;
    
    //----------- Output Ports ---------------//
    output [ ((N*Tn) - 1) : 0 ]     o_nfu2_out;
    
    //------------- Code Start -----------------//
    // Tn adder trees
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : ADDER_TREES
            Tn_adder_tree_pipe T (
                clk,
                i_nfu1_out[ ((i+1)*Tn*N) - 1  : (i*Tn*N)  ],
                i_nbout[ ((i+1)*N) - 1  : (i*N) ],
                o_nfu2_out [ ((i+1)*N) - 1  : (i*N) ]
            );
        end
    endgenerate
    
endmodule // End module nfu_2







