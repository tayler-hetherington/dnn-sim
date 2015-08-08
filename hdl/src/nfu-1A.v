//----------------------------------------------//
//----------------------------------------------//
// Tayler Hetherington
// 2015
// NFU-1A: Pre-NFU-1 stage to remove zero 
//         value multiplications.
//----------------------------------------------//
//----------------------------------------------//



module nfu_1A_D3_W4 (
        i_cur_inputs,
        i_repl_cands,
        i_sel_lines,
        o_nfu1B_out          
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;
    parameter D = 3;
    parameter W = 4;
    parameter W_DIV2_H = 2;
    parameter W_DIV2_L = 2;


    parameter NUM_REPL_CANDS = D*(W+1); 

    parameter SEL_WIDTH = 4;
    parameter NUM_MUX_INPUTS = (1 << SEL_WIDTH);
    
    //------------ Inputs ------------//
    input [ (BIT_WIDTH*Tn) - 1 : 0 ]        i_cur_inputs;
    input [ (BIT_WIDTH*Tn*D) - 1 : 0 ]      i_repl_cands;
    input [ (SEL_WIDTH*TnxTn) - 1 : 0 ]     i_sel_lines;

    //------------ Outputs ------------//
    output [ (BIT_WIDTH*TnxTn) - 1 : 0 ]    o_nfu1B_out;


    //------------ Internals ------------//
    
    
    //------------- Code Start -------------//
    genvar i, j;
    generate
        for(i=0; i<Tn; i=i+1) begin : l1
            // For each current input neruon, need to generate Tn multiplexers with the same 
            // inputs but different select lines / outputs
            
            for(j=0; j<Tn; j=j+1) begin : l2

                //if ( ((i-W_DIV2_L) >= 0) && ((i+W_DIV2_H) < Tn)) begin
                if ( (i >= W_DIV2_L) && ( (i+W_DIV2_H) < Tn) ) begin : l2a
                    // No overflow at the edges
                    mux_16_to_1 M0 (
                        i_sel_lines[ ((i*Tn) + j + 1)*SEL_WIDTH - 1 :  ((i*Tn) + j)*SEL_WIDTH  ],   // Select lines
                        {   // Input bus
                            i_cur_inputs[ (i + 1)*BIT_WIDTH - 1 : i*BIT_WIDTH ], 
                            // Replacement candidates
                            i_repl_cands[ (i + 1 + W_DIV2_H)*D*BIT_WIDTH - 1 : (i - W_DIV2_L)*BIT_WIDTH*D ]
                        }, 
                        o_nfu1B_out[ ((i*Tn) + j + 1)*BIT_WIDTH - 1 : ((i*Tn) + j)*BIT_WIDTH ]      // Output bus slice
                    );
                end
                else if ( i < W_DIV2_L) begin : l2b
                    // Overflow at the front
                    mux_16_to_1 M1 (
                        i_sel_lines[ ((i*Tn) + j + 1)*SEL_WIDTH - 1 :  ((i*Tn) + j)*SEL_WIDTH  ],   // Select lines

                        {   // Input bus
                            i_cur_inputs[ (i + 1)*BIT_WIDTH - 1 : i*BIT_WIDTH ], 
                            // Replacement candidates
                            i_repl_cands[ (i + 1 + W_DIV2_H)*D*BIT_WIDTH - 1 : 0 ], 
                            i_repl_cands[ (Tn*D*BIT_WIDTH) - 1 : (((i-W_DIV2_L)*D) + Tn*D)*BIT_WIDTH ]
                            //i_repl_cands[ (Tn*D*BIT_WIDTH) - 1 : (((i-W_DIV2_L)*D) % (Tn*D))*BIT_WIDTH ]
                        },

                        o_nfu1B_out[ ((i*Tn) + j + 1)*BIT_WIDTH - 1 : ((i*Tn) + j)*BIT_WIDTH ]      // Output bus slice
                    );

                end
                else begin : l2c
                    // Overflow at the end
                    mux_16_to_1 M2 (
                        i_sel_lines[ ((i*Tn) + j + 1)*SEL_WIDTH - 1 :  ((i*Tn) + j)*SEL_WIDTH  ],   // Select lines
                        {   // Input bus
                            i_cur_inputs[ (i + 1)*BIT_WIDTH - 1 : i*BIT_WIDTH ], 
                            // Replacement candidates
                            i_repl_cands[ (((i+1+W_DIV2_H)*D) % (Tn*D)) * BIT_WIDTH - 1 : 0 ], 
                            i_repl_cands[ (Tn*D*BIT_WIDTH) - 1 : (i - W_DIV2_L)*BIT_WIDTH*D ]
                        },
                        o_nfu1B_out[ ((i*Tn) + j + 1)*BIT_WIDTH - 1 : ((i*Tn) + j)*BIT_WIDTH ]      // Output bus slice
                    );
                end
            end
        end
    endgenerate

endmodule

    

module nfu_1A_D1_W0 (
        i_cur_inputs,
        i_repl_cands,
        i_sel_lines,
        o_nfu1B_out          
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;
    parameter D = 1;
    parameter W = 0;

    parameter NUM_REPL_CANDS = D*(W+1); 

    parameter SEL_WIDTH = 1;
    parameter NUM_MUX_INPUTS = (1 << SEL_WIDTH);
    
    //------------ Inputs ------------//
    input [ (BIT_WIDTH*Tn) - 1 : 0 ]        i_cur_inputs;
    input [ (BIT_WIDTH*Tn*D) - 1 : 0 ]      i_repl_cands;
    input [ (SEL_WIDTH*TnxTn) - 1 : 0 ]     i_sel_lines;

    //------------ Outputs ------------//
    output [ (BIT_WIDTH*TnxTn) - 1 : 0 ]    o_nfu1B_out;


    //------------ Internals ------------//
    
    
    //------------- Code Start -------------//
    genvar i, j;
    generate
        for(i=0; i<Tn; i=i+1) begin : l1
            // For each current input neruon, need to generate Tn multiplexers with the same 
            // inputs but different select lines / outputs
            
            for(j=0; j<Tn; j=j+1) begin : l2

                mux_2_to_1 M0 (
                    i_sel_lines[ ((i*Tn) + j + 1)*SEL_WIDTH - 1 : ((i*Tn) + j)*SEL_WIDTH ],
                    {
                        i_cur_inputs[ (i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH ],
                        i_repl_cands[ (i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH ]
                    },
                    o_nfu1B_out[ ((i*Tn) + j + 1)*BIT_WIDTH - 1 : ((i*Tn) + j)*BIT_WIDTH ]      // Output bus slice
                );
            end
        end
    endgenerate

endmodule

// D=5,W=15
module nfu_1A_D5_W15 (
        i_cur_inputs,
        i_repl_cands,
        i_sel_lines,
        o_nfu1B_out          
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;
    parameter D = 5;
    parameter W = 15;

    parameter NUM_REPL_CANDS = D*(W+1); 

    parameter SEL_WIDTH = 7;
    parameter NUM_MUX_INPUTS = (1 << SEL_WIDTH);
    
    //------------ Inputs ------------//
    input [ (BIT_WIDTH*Tn) - 1 : 0 ]        i_cur_inputs;
    input [ (BIT_WIDTH*Tn*D) - 1 : 0 ]      i_repl_cands;
    input [ (SEL_WIDTH*TnxTn) - 1 : 0 ]     i_sel_lines;

    //------------ Outputs ------------//
    output [ (BIT_WIDTH*TnxTn) - 1 : 0 ]    o_nfu1B_out;


    //------------ Internals ------------//
    
    
    //------------- Code Start -------------//
    genvar i, j;
    generate
        for(i=0; i<Tn; i=i+1) begin : l1
            // For each current input neruon, need to generate Tn multiplexers with the same 
            // inputs but different select lines / outputs
            
            for(j=0; j<Tn; j=j+1) begin : l2
                mux_81_to_1 M0 (
                    i_sel_lines[ ((i*Tn) + j + 1)*SEL_WIDTH - 1 : ((i*Tn) + j)*SEL_WIDTH ],
                    {
                        i_cur_inputs[ (i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH ],
                        i_repl_cands[ (i+1)*D*BIT_WIDTH - 1 : i*D*BITWIDTH ]
                    }
                    o_nfu1B_out[ ((i*Tn) + j + 1)*BIT_WIDTH - 1 : ((i*Tn) + j)*BIT_WIDTH ]      // Output bus slice
                );
            end
        end
    endgenerate

endmodule

