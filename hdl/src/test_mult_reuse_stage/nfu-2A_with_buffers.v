



module nfu_2A (
        clk,
        i_nfu1,
        i_l1_sel_lines,
        i_l2_sel_lines,
        i_buf_read_addr,
        i_buf_write_addr,
        i_write_en,
        o_nfu2A
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter ADDR_SIZE   = 2;
    parameter NUM_BUFFERS = 1 << ADDR_SIZE;

    parameter L1_SEL_WIDTH = 4;
    parameter L1_NUM_INPUTS = 1 << L1_SEL_WIDTH;

    parameter L2_SEL_WIDTH = 5;
    parameter L2_NUM_INPUTS = 1 << L2_SEL_WIDTH;

    input clk;

    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ]                 i_nfu1;
    input [ (Tn*OUT_LIMIT*L1_SEL_WIDTH) - 1 : 0 ]       i_l1_sel_lines;
    input [ (Tn*IN_LIMIT*L2_SEL_WIDTH) - 1 : 0 ]        i_l2_sel_lines;


    input [ (Tn*ADDR_SIZE) - 1 : 0 ]                    i_buf_read_addr;
    input [ (Tn*ADDR_SIZE) - 1 : 0 ]                    i_buf_write_addr;

    input [ Tn-1 : 0 ]                                  i_write_en;

    //output [ (TnxTn + IN_LIMIT)*BIT_WIDTH - 1 : 0 ]     o_nfu2A;
    output [ (Tn*IN_LIMIT)*BIT_WIDTH - 1 : 0 ] o_nfu2A;


    // Tn Internal buffers
    reg [ BIT_WIDTH - 1 : 0 ]          internal_regs [0 : Tn-1][0 : NUM_BUFFERS-1];

    // 2 stages. (L1, L2)
    //  Pass through the main multiplication results (i_nfu1) as before, also add more inputs
    //wire [ (Tn*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ]; // Tn*IN_LIMIT Tn:1  multiplexers

    wire [ (Tn*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ] L1_out;
    wire [ (Tn*IN_LIMIT)*BIT_WIDTH - 1 : 0 ] L2_out;

    //reg [ Tn*BIT_WIDTH - 1 : 0 ] buffers_out;
    wire [ Tn*BIT_WIDTH - 1 : 0 ] buffers_out;

    // Assign output
    assign o_nfu2A = L2_out;

    // Level 1 stage, output muxes from multipliers. 
    nfu_2A_L1 #(.OUT_LIMIT(OUT_LIMIT), .IN_LIMIT(IN_LIMIT) ) L1 (
        i_nfu1,
        i_l1_sel_lines,
        L1_out
    );
    
    // Level 2 stage, input muxes to adder tree. 
    nfu_2A_L2 #(.OUT_LIMIT(OUT_LIMIT), .IN_LIMIT(IN_LIMIT), .L2_SEL_WIDTH(L2_SEL_WIDTH)) L2 (
        L1_out,
        buffers_out,
        i_l2_sel_lines,
        L2_out
    );

    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : REG_GEN
        
            always @(posedge clk) begin
                if( i_write_en[i] == 1'b1 ) begin
                    internal_regs[i][i_buf_write_addr[ (i+1)*ADDR_SIZE - 1: i*ADDR_SIZE] ] <= L1_out[ (i+1)*OUT_LIMIT*BIT_WIDTH - 1 : i*OUT_LIMIT*BIT_WIDTH ];
                end
            end
            // Constantly read out 
            assign buffers_out[ (i+1)*BIT_WIDTH - 1 : i*BIT_WIDTH ] = internal_regs[i][i_buf_read_addr[ (i+1)*ADDR_SIZE - 1: i*ADDR_SIZE] ] ;

        end
    endgenerate

endmodule



module nfu_2A_L1(
        i_inputs,
        i_sel_lines,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter L1_SEL_WIDTH = 4;
    parameter L1_NUM_INPUTS = 1 << L1_SEL_WIDTH;

    input [ (TnxTn)*BIT_WIDTH - 1 : 0 ] i_inputs;
    input [ (Tn*OUT_LIMIT*L1_SEL_WIDTH) - 1 : 0 ] i_sel_lines;

    output [(Tn*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ] o_outputs;


    genvar i, j;
    generate
        for(i=0; i<Tn; i=i+1) begin : GEN_MUX_L1
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
        i_l1_buffer,
        
        i_sel_lines,
        o_outputs
    );

    parameter BIT_WIDTH = 16;
    parameter Tn = 16;
    parameter TnxTn = 256;

    parameter OUT_LIMIT = 1;
    parameter IN_LIMIT = 1;

    parameter L2_SEL_WIDTH = 5;
    parameter L2_NUM_INPUTS = Tn + (Tn-1)*OUT_LIMIT; 

    input [ (Tn*OUT_LIMIT)*BIT_WIDTH - 1 : 0 ]      i_l1_mux;
    input [ Tn*BIT_WIDTH - 1  : 0 ]                 i_l1_buffer;


    input [ (Tn*IN_LIMIT*L2_SEL_WIDTH) - 1 : 0 ]    i_sel_lines;

    output [(Tn*IN_LIMIT)*BIT_WIDTH - 1 : 0 ]       o_outputs;

    
    // # muxes = IN_LIMIT * Tn
    // # inputs = ((Tn-1)*OUT_LIMIT) First level muxes + (Tn) buffers
    //      # inputs = (16-1)*OUT_LIMIT + 16
    //
    
    genvar i, j;
    generate
        for(i=0; i<Tn; i=i+1) begin : GEN_MUX_L2
            for(j=0; j<IN_LIMIT; j=j+1) begin : GEN_IN_LIMIT
                // N=1, M=1        
                if(i == 0) begin : GEN_I0
                    mux_mod M0 (
                        i_sel_lines[ (i*IN_LIMIT + (j+1))*L2_SEL_WIDTH - 1 : (i*IN_LIMIT + j)*L2_SEL_WIDTH  ],
                        {
                            i_l1_buffer,
                            i_l1_mux [Tn*OUT_LIMIT*BIT_WIDTH - 1 : OUT_LIMIT*BIT_WIDTH]
                        },
                        o_outputs[ (i*IN_LIMIT + (j+1))*BIT_WIDTH - 1 : (i*IN_LIMIT + j)*BIT_WIDTH ]
                    );
                
                end else if (i == (Tn-1)) begin : GEN_I15
                    mux_mod M1 (
                        i_sel_lines[ (i*IN_LIMIT + (j+1))*L2_SEL_WIDTH - 1 : (i*IN_LIMIT + j)*L2_SEL_WIDTH  ],
                        {
                            i_l1_buffer,
                            i_l1_mux [(Tn-1)*OUT_LIMIT*BIT_WIDTH - 1 : 0]
                        },
                        o_outputs[ (i*IN_LIMIT + (j+1))*BIT_WIDTH - 1 : (i*IN_LIMIT + j)*BIT_WIDTH ]
                    );                
                end else begin : GEN_I
                    mux_mod M2 (
                        i_sel_lines[ (i*IN_LIMIT + (j+1))*L2_SEL_WIDTH - 1 : (i*IN_LIMIT + j)*L2_SEL_WIDTH  ],
                        {
                            i_l1_buffer,
                            {
                                i_l1_mux [Tn*BIT_WIDTH*OUT_LIMIT - 1 : (i+1)*OUT_LIMIT*BIT_WIDTH ],
                                i_l1_mux [ i*OUT_LIMIT*BIT_WIDTH - 1 : 0 ] 
                            }
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


    /* 
    // OUT_LIMIT = 2
    // IN_LIMIT = 1
    //      # inputs = (Tn-1)*OUT_LIMIT [muxes] + Tn [buffers]
    //               = (16-1)*2 + 16
    //               = 46
    //               = 1 32:1 mux, 1 16:1 mux, 1 2:1 mux
    parameter NUM_INPUTS = 46;
    parameter NUM_MUX_OUT = 30;
    parameter NUM_BUF_OUT = 16;
    parameter SEL_WIDTH = 6;
    


    input [SEL_WIDTH-1:0]               i_sel_lines;
    input [(NUM_INPUTS*BIT_WIDTH)-1:0]  i_inputs;
    output [BIT_WIDTH-1 : 0 ]           o_outputs;

    wire [BIT_WIDTH-1 : 0] m_16x1_out, m_32x1_out;

    mux_32_to_1_v2 M0 (
        i_sel_lines[ SEL_WIDTH-2 : 0 ],
        {
            i_inputs[ NUM_MUX_OUT*BIT_WIDTH - 1 : 0 ],
            32'h00000000
        },
        m_32x1_out
    );

    mux_16_to_1_v2 M1 (
        i_sel_lines[ SEL_WIDTH-3 : 0 ],
        i_inputs[ (NUM_MUX_OUT+NUM_BUF_OUT)*BIT_WIDTH - 1 : NUM_MUX_OUT*BIT_WIDTH ],
        m_16x1_out
    );

    mux_2_to_1_v2 M3 (
        i_sel_lines[ SEL_WIDTH-1 : SEL_WIDTH-1 ],
        {
            m_32x1_out,
            m_16x1_out
        },
        o_outputs
    );
    */
    //-------------------------------------------------//
    //-------------------------------------------------//
    //-------------------------------------------------//

    
    // OUT_LIMIT = 1
    // IN_LIMIT = 1
       // # inputs = (16-1)*OUT_LIMIT + 16 => 15 + 16 = 31; 
    parameter NUM_INPUTS = 31;
    parameter SEL_WIDTH = 5;

    input [SEL_WIDTH-1:0]               i_sel_lines;
    input [(NUM_INPUTS*BIT_WIDTH)-1:0]  i_inputs;
    output [BIT_WIDTH-1 : 0 ]           o_outputs;

    
    mux_32_to_1_v2 mux0 (
        i_sel_lines,
        {
            i_inputs,   // 31 inputs
            16'h0000    // 32nd input
        },
        o_outputs
    );
    
    


endmodule
