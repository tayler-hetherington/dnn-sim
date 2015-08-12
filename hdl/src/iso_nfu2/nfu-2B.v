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

module Tn_adder_tree (
        i_nfu1,         // New multiplication data from NFU-1
        i_nbout,        // Partial SUM from NBOut
        o_results
    );


    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;


    //----------- Input Ports ---------------//
    input [((BIT_WIDTH*Tn) - 1):0] i_nfu1;   // Tn x Tn inputs
    input [(BIT_WIDTH - 1):0] i_nbout;     // Tn partial sums
    
    //----------- Output Ports ---------------//
    output [(BIT_WIDTH - 1):0] o_results;
    
    //----------- Internal Signals ---------------//
    
    // Adder tree connection wires
    wire [ (BIT_WIDTH*(Tn/2)) - 1 : 0 ] level_1_out;    // 8 buses
    wire [ (BIT_WIDTH*(Tn/4)) - 1 : 0 ] level_2_out;    // 4 busses
    wire [ (BIT_WIDTH*(Tn/8)) - 1 : 0 ] level_3_out;    // 2 busses
    wire [ (BIT_WIDTH*(Tn/16)) - 1 : 0 ] level_4_out;   // 1 bus
    
    wire [ (BIT_WIDTH-1) : 0 ] partial_sum_out;         // 1 bus from partial sum add
    
    //------------- Code Start -----------------//
    
    // Level 1 - 8 adders (Tn/2 = 16/2 = 8)
    genvar j;
    generate
        for(j=0; j<(Tn/2); j=j+1) begin : Level1_i
            
            int_add L1 (
                    i_nfu1[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    i_nfu1[ (((2*j)+2)*BIT_WIDTH) - 1 :(((2*j)+1)*BIT_WIDTH)  ],
                    level_1_out[ ((j+1)*BIT_WIDTH) - 1: (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    // Level 2 - 4 adders (Tn/4 = 16/4 = 4)
    generate
        for(j=0; j<(Tn/4); j=j+1) begin : Level2_i
            
            int_add L2 (
                    level_1_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_1_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_2_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    
    // Level 3 - 2 adders (Tn/8 = 16/8 = 2)
    generate
        for(j=0; j<(Tn/8); j=j+1) begin : Level3_i
            
            int_add L3 (
                    level_2_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_2_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_3_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    // Level 4 - 1 adders (Tn/16 = 16/16 = 1)
    
    int_add L4 (
        level_3_out[ BIT_WIDTH - 1 : 0 ],
        level_3_out[ (2*BIT_WIDTH) - 1 : BIT_WIDTH  ],
        level_4_out
    );
    
    // Level 5 - Not sure if this is correct, but there needs to be an adder for the partial sum.
    //           DianNao paper only mentions 16 x 15 adders in the tree. But since adders are only
    //           2 input, we have Tn (16) values per neuron to add (15 adders) plus the partial sum (16 adders)
    
    int_add L5 (
        level_4_out,
        i_nbout,
        partial_sum_out
    );
    
    assign o_results = partial_sum_out;
    
endmodule // End module Tn_adder_tree



//---------------------------------------------//
// Main NFU-2 module
//---------------------------------------------//
module nfu_2 (
        clk,
        i_nfu1_out,
        i_nbout,
        o_nfu2_out
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 16;
    parameter TnxTn = Tn*G;

    //----------- Input Ports ---------------//
    input clk;
    
    input [ ((BIT_WIDTH*TnxTn) - 1) : 0 ] i_nfu1_out;
    input [ ((BIT_WIDTH*G) - 1) : 0 ] i_nbout;
    
    //----------- Output Ports ---------------//
    output [ ((BIT_WIDTH*G) - 1) : 0 ] o_nfu2_out;
    
    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<G; i=i+1) begin : ADDER_TREES
            Tn_adder_tree T (
                i_nfu1_out[ ((i+1)*Tn*BIT_WIDTH) - 1  : (i*Tn*BIT_WIDTH)  ],
                i_nbout[ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ],
                o_nfu2_out [ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ]
            );
        end
    endgenerate
    
endmodule // End module nfu_2



//---------------------------------------------//
//---------------------------------------------//
//---------------------------------------------//
//---------------------------------------------//
// Multiplication re-use optimization
//---------------------------------------------//
//---------------------------------------------//
//---------------------------------------------//
//---------------------------------------------//

module N1M1_adder_tree (
        i_nfu1,         // New multiplication data from NFU-1
        i_mux_inputs,
        i_partial_sum,        // Partial SUM from NBOut
        o_results
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 16;
    parameter TnxTn = Tn*G;

    parameter IN_LIMIT = 1;


    // 16 inputs (i_nfu1) = 4 levels of adderes
    // 1 input in mux_inputs + 1 input in partial_sum = 1 adder + additional level
    //
    // 5 levels total


    //----------- Input Ports ---------------//
    input [((BIT_WIDTH*Tn) - 1):0] i_nfu1;   // Tn x Tn inputs
    input [(BIT_WIDTH - 1):0] i_partial_sum;     // Tn partial sums
   
    input [ IN_LIMIT*BIT_WIDTH - 1 : 0 ] i_mux_inputs;
    //----------- Output Ports ---------------//
    output [(BIT_WIDTH - 1):0] o_results;
    
    //----------- Internal Signals ---------------//
    
    // Adder tree connection wires
    wire [ (BIT_WIDTH*(Tn/2)) - 1 : 0 ] level_1_out;    // 8 buses
    wire [ (BIT_WIDTH*(Tn/4)) - 1 : 0 ] level_2_out;    // 4 busses
    wire [ (BIT_WIDTH*(Tn/8)) - 1 : 0 ] level_3_out;    // 2 busses
    wire [ (BIT_WIDTH*(Tn/16)) - 1 : 0 ] level_4_out;   // 1 bus
    
    
    wire [ (BIT_WIDTH-1) : 0 ] mux_partial_out;
    
    wire [ (BIT_WIDTH-1) : 0 ] partial_sum_out;         // 1 bus from partial sum add
    

    //------------- Code Start -----------------//
    
    // Level 1 - 8 adders (Tn/2 = 16/2 = 8)
    genvar j;
    generate
        for(j=0; j<(Tn/2); j=j+1) begin : Level1_i
            int_add L1 (
                    i_nfu1[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    i_nfu1[ (((2*j)+2)*BIT_WIDTH) - 1 :(((2*j)+1)*BIT_WIDTH)  ],
                    level_1_out[ ((j+1)*BIT_WIDTH) - 1: (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    // Level 2 - 4 adders (Tn/4 = 16/4 = 4)
    generate
        for(j=0; j<(Tn/4); j=j+1) begin : Level2_i
            int_add L2 (
                    level_1_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_1_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_2_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    
    // Level 3 - 2 adders (Tn/8 = 16/8 = 2)
    generate
        for(j=0; j<(Tn/8); j=j+1) begin : Level3_i
            int_add L3 (
                    level_2_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_2_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_3_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
        end
    endgenerate
    
    // Level 4 - 1 adders (Tn/16 = 16/16 = 1)
    int_add L4A (
        level_3_out[ BIT_WIDTH - 1 : 0 ],
        level_3_out[ (2*BIT_WIDTH) - 1 : BIT_WIDTH  ],
        level_4_out
    );
    
    // Level 4B/5 - Not sure if this is correct, but there needs to be an adder for the partial sum.
    //           DianNao paper only mentions 16 x 15 adders in the tree. But since adders are only
    //           2 input, we have Tn (16) values per neuron to add (15 adders) plus the partial sum (16 adders)
    
    int_add L4B (
        i_mux_inputs,
        i_partial_sum,
        mux_partial_out
    );
    
    int_add L5 (
        level_4_out,
        mux_partial_out,
        partial_sum_out
    );
    
    assign o_results = partial_sum_out;
    
endmodule // End module Tn_adder_tree



module N2M4_adder_tree (
        i_nfu1,         // New multiplication data from NFU-1
        i_mux_inputs,
        i_partial_sum,        // Partial SUM from NBOut
        o_results
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter IN_LIMIT = 4;


    // 16 inputs (i_nfu1) = 4 levels of adderes
    // 1 input in mux_inputs + 1 input in partial_sum = 1 adder + additional level
    //
    // 5 levels total


    //----------- Input Ports ---------------//
    input [((BIT_WIDTH*Tn) - 1):0] i_nfu1;   // Tn x Tn inputs
    input [(BIT_WIDTH - 1):0] i_partial_sum;     // Tn partial sums
   
    input [ IN_LIMIT*BIT_WIDTH - 1 : 0 ] i_mux_inputs;
    //----------- Output Ports ---------------//
    output [(BIT_WIDTH - 1):0] o_results;
    
    //----------- Internal Signals ---------------//
    
    // Adder tree connection wires
    wire [ (BIT_WIDTH*(Tn/2)) - 1 : 0 ] level_1_out;    // 8 buses
    wire [ (BIT_WIDTH*(Tn/4)) - 1 : 0 ] level_2_out;    // 4 busses
    wire [ (BIT_WIDTH*(Tn/8)) - 1 : 0 ] level_3_out;    // 2 busses
    wire [ (BIT_WIDTH*(Tn/16)) - 1 : 0 ] level_4_out;   // 1 bus
    

    wire [ 2*BIT_WIDTH - 1 : 0 ]    m01_m23;
    wire [ BIT_WIDTH - 1 : 0 ]      m0123;
    
    wire [ BIT_WIDTH - 1 : 0 ]      m0123_partial;
    
    wire [ (BIT_WIDTH-1) : 0 ]      partial_sum_out;         // 1 bus from partial sum add
    

    //------------- Code Start -----------------//
    
    // Level 1 - 8 adders (Tn/2 = 16/2 = 8)
    genvar j;
    generate
        for(j=0; j<(Tn/2); j=j+1) begin : Level1_i
            int_add L1 (
                    i_nfu1[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    i_nfu1[ (((2*j)+2)*BIT_WIDTH) - 1 :(((2*j)+1)*BIT_WIDTH)  ],
                    level_1_out[ ((j+1)*BIT_WIDTH) - 1: (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    // Level 2 - 4 adders (Tn/4 = 16/4 = 4)
    generate
        for(j=0; j<(Tn/4); j=j+1) begin : Level2_i
            int_add L2A (
                    level_1_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_1_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_2_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    
    // Level 3 - 2 adders (Tn/8 = 16/8 = 2)
    generate
        for(j=0; j<(Tn/8); j=j+1) begin : Level3_i
            int_add L3A (
                    level_2_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_2_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_3_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
        end
    endgenerate
    
    // Level 4 - 1 adders (Tn/16 = 16/16 = 1)
    int_add L4A (
        level_3_out[ BIT_WIDTH - 1 : 0 ],
        level_3_out[ (2*BIT_WIDTH) - 1 : BIT_WIDTH  ],
        level_4_out
    );
    
    // Level 4B/5 - Not sure if this is correct, but there needs to be an adder for the partial sum.
    //           DianNao paper only mentions 16 x 15 adders in the tree. But since adders are only
    //           2 input, we have Tn (16) values per neuron to add (15 adders) plus the partial sum (16 adders)
    
    int_add L2B (
        i_mux_inputs[2*BIT_WIDTH-1 : BIT_WIDTH],
        i_mux_inputs[BIT_WIDTH-1 : 0],
        m01_m23 [BIT_WIDTH - 1 : 0 ]
    );
    
    int_add L2C (
        i_mux_inputs[4*BIT_WIDTH-1 : 3*BIT_WIDTH],
        i_mux_inputs[3*BIT_WIDTH-1 : 2*BIT_WIDTH],
        m01_m23 [2*BIT_WIDTH - 1 : BIT_WIDTH ]
    );

    
    int_add L3B (
        m01_m23 [2*BIT_WIDTH - 1 : BIT_WIDTH ],
        m01_m23 [BIT_WIDTH - 1 : 0 ],
        m0123
    );

    int_add L4B (
        m0123,
        i_partial_sum,
        m0123_partial
    );
 
    int_add L5 (
        level_4_out,
        m0123_partial,
        partial_sum_out
    );
    
    assign o_results = partial_sum_out;
    
endmodule // End module N2M4_adder_tree



module N2M3_adder_tree (
        i_nfu1,         // New multiplication data from NFU-1
        i_mux_inputs,
        i_partial_sum,        // Partial SUM from NBOut
        o_results
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter IN_LIMIT = 3;


    // 16 inputs (i_nfu1) = 4 levels of adderes
    // 1 input in mux_inputs + 1 input in partial_sum = 1 adder + additional level
    //
    // 5 levels total


    //----------- Input Ports ---------------//
    input [((BIT_WIDTH*Tn) - 1):0] i_nfu1;   // Tn x Tn inputs
    input [(BIT_WIDTH - 1):0] i_partial_sum;     // Tn partial sums
   
    input [ IN_LIMIT*BIT_WIDTH - 1 : 0 ] i_mux_inputs;
    //----------- Output Ports ---------------//
    output [(BIT_WIDTH - 1):0] o_results;
    
    //----------- Internal Signals ---------------//
    
    // Adder tree connection wires
    wire [ (BIT_WIDTH*(Tn/2)) - 1 : 0 ] level_1_out;    // 8 buses
    wire [ (BIT_WIDTH*(Tn/4)) - 1 : 0 ] level_2_out;    // 4 busses
    wire [ (BIT_WIDTH*(Tn/8)) - 1 : 0 ] level_3_out;    // 2 busses
    wire [ (BIT_WIDTH*(Tn/16)) - 1 : 0 ] level_4_out;   // 1 bus
    
    wire [ 2*BIT_WIDTH - 1 : 0 ] l1_mux_partial_out;
    wire [ (BIT_WIDTH-1) : 0 ] l2_mux_partial_out;
    
    wire [ (BIT_WIDTH-1) : 0 ] partial_sum_out;         // 1 bus from partial sum add
    

    //------------- Code Start -----------------//
    
    // Level 1 - 8 adders (Tn/2 = 16/2 = 8)
    genvar j;
    generate
        for(j=0; j<(Tn/2); j=j+1) begin : Level1_i
            int_add L1 (
                    i_nfu1[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    i_nfu1[ (((2*j)+2)*BIT_WIDTH) - 1 :(((2*j)+1)*BIT_WIDTH)  ],
                    level_1_out[ ((j+1)*BIT_WIDTH) - 1: (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    // Level 2 - 4 adders (Tn/4 = 16/4 = 4)
    generate
        for(j=0; j<(Tn/4); j=j+1) begin : Level2_i
            int_add L2 (
                    level_1_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_1_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_2_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
            
        end
    endgenerate
    
    
    // Level 3 - 2 adders (Tn/8 = 16/8 = 2)
    generate
        for(j=0; j<(Tn/8); j=j+1) begin : Level3_i
            int_add L3A (
                    level_2_out[ (((2*j)+1)*BIT_WIDTH) - 1 : ((2*j)*BIT_WIDTH)   ],
                    level_2_out[ (((2*j)+2)*BIT_WIDTH) - 1 : (((2*j)+1)*BIT_WIDTH)  ],
                    level_3_out[ ((j+1)*BIT_WIDTH) - 1 : (j*BIT_WIDTH) ]
            );
        end
    endgenerate
    
    // Level 4 - 1 adders (Tn/16 = 16/16 = 1)
    int_add L4A (
        level_3_out[ BIT_WIDTH - 1 : 0 ],
        level_3_out[ (2*BIT_WIDTH) - 1 : BIT_WIDTH  ],
        level_4_out
    );
    
    // Level 4B/5 - Not sure if this is correct, but there needs to be an adder for the partial sum.
    //           DianNao paper only mentions 16 x 15 adders in the tree. But since adders are only
    //           2 input, we have Tn (16) values per neuron to add (15 adders) plus the partial sum (16 adders)
    
    //wire [ 2*BIT_WIDTH - 1 : 0 ] l1_mux_partial_out;
    //wire [ (BIT_WIDTH-1) : 0 ] l2_mux_partial_out;
    int_add L3B (
        i_mux_inputs[3*BIT_WIDTH-1 : 2*BIT_WIDTH],
        i_mux_inputs[2*BIT_WIDTH-1 : BIT_WIDTH],
        l1_mux_partial_out[BIT_WIDTH-1:0]
    );

    
    int_add L3C (
        i_mux_inputs[BIT_WIDTH-1:0],
        i_partial_sum,
        l1_mux_partial_out[2*BIT_WIDTH-1:BIT_WIDTH]
    );

    // L4B
    int_add L4B (
        l1_mux_partial_out[BIT_WIDTH-1:0], 
        l1_mux_partial_out[2*BIT_WIDTH-1:BIT_WIDTH],
        l2_mux_partial_out
    );

    int_add L5 (
        level_4_out,
        l2_mux_partial_out,
        partial_sum_out
    );
    
    assign o_results = partial_sum_out;
    
endmodule // End module N2M3_adder_tree

module nfu_2B (
        clk,
        i_inputs,
        i_mux_inputs,
        i_partial_sum,
        o_nfu2_out
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 16;
    parameter TnxTn = Tn*G;

    parameter IN_LIMIT = 1;

    //----------- Input Ports ---------------//
    input clk;
    
    input [ ((BIT_WIDTH*TnxTn) - 1) : 0 ] i_inputs; // Inputs from NFU-1 multiplications
    input [ (BIT_WIDTH*G*IN_LIMIT) - 1 : 0 ] i_mux_inputs; // IN_LIMIT mux inputs per tree

    input [ ((BIT_WIDTH*G) - 1) : 0 ] i_partial_sum; // Partial sum from NBout (nfu2/nfu3 pipe reg)
    
    //----------- Output Ports ---------------//
    output [ ((BIT_WIDTH*G) - 1) : 0 ] o_nfu2_out;
    
    //------------- Code Start -----------------//
    genvar i;
    generate
        for(i=0; i<G; i=i+1) begin : ADDER_TREES
           
            /*
            N1M1_adder_tree N1M1 (
                i_inputs[ ((i+1)*Tn*BIT_WIDTH) - 1  : (i*Tn*BIT_WIDTH)  ],
                i_mux_inputs[ (i+1)*IN_LIMIT*BIT_WIDTH - 1 : i*IN_LIMIT*BIT_WIDTH ],
                i_partial_sum[ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ],
                o_nfu2_out [ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ]
            );
            */
            
            
            /*
            N2M3_adder_tree N2M3 (
                i_inputs[ ((i+1)*Tn*BIT_WIDTH) - 1  : (i*Tn*BIT_WIDTH)  ],
                i_mux_inputs[ (i+1)*IN_LIMIT*BIT_WIDTH - 1 : i*IN_LIMIT*BIT_WIDTH ],
                i_partial_sum[ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ],
                o_nfu2_out [ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ]
            );
            */

            
            N2M4_adder_tree N2M4 (
                i_inputs[ ((i+1)*Tn*BIT_WIDTH) - 1  : (i*Tn*BIT_WIDTH)  ],
                i_mux_inputs[ (i+1)*IN_LIMIT*BIT_WIDTH - 1 : i*IN_LIMIT*BIT_WIDTH ],
                i_partial_sum[ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ],
                o_nfu2_out [ ((i+1)*BIT_WIDTH) - 1  : (i*BIT_WIDTH) ]
            );
            
            

           
            
        end
    endgenerate
    
endmodule // End module nfu_2B



