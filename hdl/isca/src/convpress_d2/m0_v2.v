

module m0_v2 (
        clk,
        clk2,
        i_nbin_data,
        i_offset_data,
        i_wen,
        i_off_wen,
        i_addr,
        i_off_rd_addr,
        i_off_wr_addr,
        o_nbin_data,
        o_offset_data
    );

    parameter N         = 16;
    parameter Tn        = 16;
    parameter W         = (N*Tn)/2;
    parameter OFFSET_SZ = 4;

    parameter ADDR_SZ   = 6;
    parameter NUM_WORDS = 64;

    input                       clk, clk2;
    input [Tn*N-1:0]            i_nbin_data;
    input [Tn*OFFSET_SZ-1:0]    i_offset_data;
    input [Tn-1:0]              i_wen, i_off_wen;
    input [Tn*ADDR_SZ-1:0]      i_addr, i_off_rd_addr, i_off_wr_addr;

    output [Tn*N-1:0]           o_nbin_data;
    output [Tn*OFFSET_SZ-1:0]   o_offset_data;

    wire [Tn*N-1:0]             nbin_out;
    wire [Tn*OFFSET_SZ-1:0]     offset_out;

    // Necessary signals for the RF memory
    wire [2:0]  ema  = 3'b000;
    wire        retn = 1'b1;
    wire        cen  = 1'b0;

    // Output logic 
    assign o_nbin_data      = nbin_out;
    assign o_offset_data    = offset_out;
   

    //---------- NBin ----------//
    genvar i;
    generate 
        for(i=0; i<Tn; i=i+1) begin : NB_IN
            nb_64x16b NB_RF (
                .Q(nbin_out[ (i+1)*N - 1 : i*N ]),
                .CLK(clk2),
                .CEN(cen),
                .WEN(i_wen[i : i]),
                .A(i_addr[ (i+1)*ADDR_SZ - 1 : i*ADDR_SZ ] ),
                .D(i_nbin_data[ (i+1)*N-1 : i*N ]),
                .EMA(ema),
                .RETN(retn)
            );
        end
    endgenerate

    //--------- Offsets ----------//
    // Tn*OFFSET_SZ bit output (64-bits)
    generate 
        for(i=0; i<Tn; i=i+1) begin : OFF_BUFFER
            offset_latch #(.N(OFFSET_SZ), .ADDR(ADDR_SZ), .NUM_WORDS(NUM_WORDS)) OFF_LATCH (
                clk,
                i_offset_data[ (i+1)*OFFSET_SZ-1 : i*OFFSET_SZ ],
                i_off_rd_addr[ (i+1)*ADDR_SZ - 1 : i*ADDR_SZ ],
                i_off_wr_addr[ (i+1)*ADDR_SZ - 1 : i*ADDR_SZ ],
                i_off_wen[i : i],
                offset_out[ (i+1)*OFFSET_SZ - 1 : i*OFFSET_SZ ]
            );   
        end
    endgenerate

    // Can't actually go this small (4-bit wide)... So using the latch structure
    //      If this is too big, alternatively go to 8 bit, 32 deep, and then latch
    //      the second MSBs and only read on every second cycle.
    /*
    generate 
        for(i=0; i<Tn; i=i+1) begin : OFF_BUFFER
            nb_32x4b OFF_RF (
                .Q(offset_out[ (i+1)*OFFSET_SZ - 1 : i*OFFSET_SZ ]),
                .CLK(clk2),
                .CEN(cen),
                .WEN(i_wen[i : i]),
                .A(i_addr[ (i+1)*ADDR_SZ - 1 : i*ADDR_SZ ] ),
                .D(i_offset_data[ (i+1)*OFFSET_SZ : i*OFFSET_SZ ]),
                .EMA(ema),
                .RETN(retn)
            );
        end
    endgenerate
    */
    
    

endmodule


module offset_latch (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );

    parameter N         = 4;
    parameter ADDR      = 6;
    parameter NUM_WORDS = 64;

    input               clk, i_wen;
    input [N-1:0]       i_data;
    input [ADDR-1:0]    i_rd_addr, i_wr_addr;
    output [N-1:0]      o_data;

    reg [ADDR-1:0]      rd_addr_reg;
    reg [N-1:0] mem [NUM_WORDS-1:0];

    assign o_data = mem[rd_addr_reg];

    always @(posedge clk) begin
        rd_addr_reg             <= i_rd_addr;
        if(i_wen) begin
            mem[i_wr_addr]      <= i_data;
        end
    end

endmodule
