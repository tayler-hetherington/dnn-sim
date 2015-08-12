



module nfu_2A (
        clk,
        i_nfu1,
        i_l1_sel_lines,
        i_l2_sel_lines,
        o_nfu2A
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 16;
    parameter TnxTn = Tn*G;

    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter L1_SEL_WIDTH = 4;
    parameter L1_NUM_INPUTS = 1 << L1_SEL_WIDTH;

    parameter L2_SEL_WIDTH = 2;
    parameter L2_NUM_INPUTS = 1 << L2_SEL_WIDTH;

    input clk;

    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ]                 i_nfu1;
    input [ (G*OUT_LIMIT*L1_SEL_WIDTH) - 1 : 0 ]       i_l1_sel_lines;
    input [ (G*IN_LIMIT*L2_SEL_WIDTH) - 1 : 0 ]        i_l2_sel_lines;


    output [ (G*IN_LIMIT)*BIT_WIDTH - 1 : 0 ] o_nfu2A;


    // 2 stages. (L1, L2)
    //  Pass through the main multiplication results (i_nfu1) as before, also add more inputs
    //wire [ (Tn*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ]; // Tn*IN_LIMIT Tn:1  multiplexers

    wire [ (G*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ] L1_out;
    wire [ (G*IN_LIMIT)*BIT_WIDTH - 1 : 0 ] L2_out;

    //reg [ Tn*BIT_WIDTH - 1 : 0 ] buffers_out;
    wire [ G*BIT_WIDTH - 1 : 0 ] buffers_out;

    // Assign output
    assign o_nfu2A = L2_out;

    // Level 1 stage, output muxes from multipliers. 
    nfu_2A_L1 #(.OUT_LIMIT(OUT_LIMIT), .IN_LIMIT(IN_LIMIT), .Tn(Tn), .TnxTn(TnxTn), .G(G))  L1 (
        i_nfu1,
        i_l1_sel_lines,
        L1_out
    );
    
    // Level 2 stage, input muxes to adder tree. 
    nfu_2A_L2 #(.OUT_LIMIT(OUT_LIMIT), .IN_LIMIT(IN_LIMIT), .L2_SEL_WIDTH(L2_SEL_WIDTH), .Tn(Tn), .TnxTn(TnxTn), .G(G)) L2 (
        L1_out,
        i_l2_sel_lines,
        L2_out
    );

endmodule



module nfu_2A_L1(
        i_inputs,
        i_sel_lines,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 16;
    parameter TnxTn = Tn*G;

    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter L1_SEL_WIDTH = 4;
    parameter L1_NUM_INPUTS = 1 << L1_SEL_WIDTH;

    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ] i_inputs;
    input [ (G*OUT_LIMIT*L1_SEL_WIDTH) - 1 : 0 ] i_sel_lines;

    output [(G*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ] o_outputs;


    genvar i, j;
    generate
        for(i=0; i<G; i=i+1) begin : GEN_MUX_L1
            for(j=0; j<OUT_LIMIT; j=j+1) begin : GEN_OUT_LIMIT
                mux_16_to_1_v2 M0 (
                    i_sel_lines[ (i*OUT_LIMIT + (j+1))*L1_SEL_WIDTH - 1 : (i*OUT_LIMIT + j)*L1_SEL_WIDTH ],
                    i_inputs[ (i+1)*Tn*BIT_WIDTH - 1 : i*Tn*BIT_WIDTH],
                    o_outputs[ (i*OUT_LIMIT + (j+1))*BIT_WIDTH - 1 : (i*OUT_LIMIT + j )*BIT_WIDTH]
                );
            end
        end
    endgenerate



endmodule

module nfu_2A_L2(
        i_l1_mux,
        i_sel_lines,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter G = 16;
    parameter TnxTn = Tn*G;

    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter L2_SEL_WIDTH = 2;
    parameter L2_NUM_INPUTS = (Tn-1)*OUT_LIMIT; 

    input [ (G*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ]      i_l1_mux;
    input [ (G*IN_LIMIT*L2_SEL_WIDTH) - 1 : 0 ]    i_sel_lines;
    output [(G*IN_LIMIT)*BIT_WIDTH - 1 : 0 ]       o_outputs;

    
    // # muxes = IN_LIMIT * Tn
    // # inputs = ((Tn-1)*OUT_LIMIT) First level muxes
    //      # inputs = (16-1)*OUT_LIMIT
    //
    
    genvar i, j;
    generate
        for(i=0; i<G; i=i+1) begin : GEN_MUX_L2
            for(j=0; j<IN_LIMIT; j=j+1) begin : GEN_IN_LIMIT
                // N=1, M=1        
                if(i == 0) begin : GEN_I0
                    mux_mod M0 (
                        i_sel_lines[ (i*IN_LIMIT + (j+1))*L2_SEL_WIDTH - 1 : (i*IN_LIMIT + j)*L2_SEL_WIDTH  ],
                        i_l1_mux [G*OUT_LIMIT*BIT_WIDTH - 1 : OUT_LIMIT*BIT_WIDTH],
                        o_outputs[ (i*IN_LIMIT + (j+1))*BIT_WIDTH - 1 : (i*IN_LIMIT + j)*BIT_WIDTH ]
                    );
                
                end else if (i == (G-1)) begin : GEN_I15
                    mux_mod M1 (
                        i_sel_lines[ (i*IN_LIMIT + (j+1))*L2_SEL_WIDTH - 1 : (i*IN_LIMIT + j)*L2_SEL_WIDTH  ],
                        i_l1_mux [(G-1)*OUT_LIMIT*BIT_WIDTH - 1 : 0],
                        o_outputs[ (i*IN_LIMIT + (j+1))*BIT_WIDTH - 1 : (i*IN_LIMIT + j)*BIT_WIDTH ]
                    );                
                end else begin : GEN_I
                    mux_mod M2 (
                        i_sel_lines[ (i*IN_LIMIT + (j+1))*L2_SEL_WIDTH - 1 : (i*IN_LIMIT + j)*L2_SEL_WIDTH  ],
                        {
                            i_l1_mux [G*BIT_WIDTH*OUT_LIMIT - 1 : (i+1)*OUT_LIMIT*BIT_WIDTH ],
                            i_l1_mux [ i*OUT_LIMIT*BIT_WIDTH - 1 : 0 ] 
                        },
                        o_outputs[ (i*IN_LIMIT + (j+1))*BIT_WIDTH - 1 : (i*IN_LIMIT + j)*BIT_WIDTH ]
                    );                   
                end

            end
        end
    endgenerate


endmodule


module mux_mod (
        i_sel_lines,
        i_inputs,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;

   
    
    // OUT_LIMIT = 2
    // IN_LIMIT = 1
    //      # inputs = (Tn-1)*OUT_LIMIT [muxes]
    //               = (16-1)*2
    //               = 30
    //               = 1 32:1 mux with 2 zero inputs
    parameter G = 4;               
    parameter NUM_INPUTS = 6;
    parameter NUM_MUX_OUT = 6;
    parameter SEL_WIDTH = 3;
    

    input [SEL_WIDTH-1:0]               i_sel_lines;
    input [(NUM_INPUTS*BIT_WIDTH)-1:0]  i_inputs;
    output [BIT_WIDTH-1 : 0 ]           o_outputs;


    mux_8_to_1_v2 M0 (
        i_sel_lines[ SEL_WIDTH-1 : 0 ],
        {
            i_inputs[ NUM_MUX_OUT*BIT_WIDTH - 1 : 0 ], // 6 inputs
            32'h00000000                               // 2 inputs
        },
        o_outputs
    );

    //-------------------------------------------------//
    //-------------------------------------------------//
    //-------------------------------------------------//


    /*
    // OUT_LIMIT = 1
    // IN_LIMIT = 1
       // # inputs = (4-1)*OUT_LIMIT => 3; 
    parameter G = 4;
    parameter NUM_INPUTS = G-1;
    parameter SEL_WIDTH = 2;

    input [SEL_WIDTH-1:0]               i_sel_lines;
    input [(NUM_INPUTS*BIT_WIDTH)-1:0]  i_inputs;
    output [BIT_WIDTH-1 : 0 ]           o_outputs;

    
    mux_4_to_1_v2 mux0 (
        i_sel_lines,
        {
            i_inputs,   // 3 inputs
            16'h0000    // 4th input
        },
        o_outputs
    );
    */

endmodule
