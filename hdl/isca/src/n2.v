
// This module implements a single 16-1 adder tree
//
//

module n2 (
        i_vals,
        o_res
    );

    parameter N = 16;
    parameter Tn = 16;

    parameter NxTn = 256;

    input   [NxTn-1:0] i_vals;
    output  [N-1:0] o_res;

    //----------- Internal Signals ---------------//

    // Adder tree connection wires
    wire [ (NxTn/2) - 1 : 0 ]   level_0_out;    // 8 buses
    wire [ (NxTn/4) - 1 : 0 ]   level_1_out;    // 4 busses
    wire [ (NxTn/8) - 1 : 0 ]   level_2_out;    // 2 busses
    wire [ (NxTn/16) - 1 : 0 ]  level_3_out;    // 1 bus


    adder_array #(.W(8), .N(16)) L0 (i_vals, level_0_out);
    adder_array #(.W(4), .N(16)) L1 (level_0_out, level_1_out);
    adder_array #(.W(2), .N(16)) L2 (level_1_out, level_2_out);
    adder_array #(.W(1), .N(16)) L3 (level_2_out, level_3_out);
 
    assign o_res = level_3_out;

endmodule



module adder_array (
        i_vals,
        o_res
    );
    
    parameter W = 8;
    parameter N = 16;

    input   [W*N - 1 : 0]       i_vals;
    output  [(W*N)/2 - 1 : 0]   o_res;

    genvar j;
    generate
        for(j=0; j<W; j=j+1) begin : Level1_i
            m_adder ADD_ARRAY (
                    i_vals[ ((2*j)+1)*N - 1  : (2*j)*N ],
                    i_vals[ ((2*j)+2)*N - 1  : ( (2*j)+1 )*N  ],
                    o_res[ (j+1)*N - 1 : j*N ]
            );
        end
    endgenerate    



endmodule;
