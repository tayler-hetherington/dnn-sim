
module nb_test (
        clk,
        i_data,
        i_wen,
        i_addr,
        i_wr_addr,
        o_data
    );

    //parameter N=16;
    parameter N=16;
    parameter Tn=16;
    parameter ADDR=6;

    input               clk;
    input [Tn-1:0]      i_wen;
    input [Tn*ADDR-1:0] i_addr, i_wr_addr;
    input [Tn*N-1:0]    i_data;

    output [Tn*N-1:0]   o_data;

    wire [Tn*N-1:0]     mem_out;

    /*
    mem_64x256b MEM (
        clk,
        i_data,
        i_wen,
        i_addr,
        mem_out
    );
    */
    /*
    mem_64x64b MEM (
        clk,
        i_data,
        i_wen,
        i_addr,
        mem_out
    );
    */

    latch_off_64x64b LATCH_ARRAY (
        clk,
        i_data,
        i_wen,
        i_addr,
        i_wr_addr,
        mem_out
    );
   assign o_data = mem_out;  


endmodule



module mem_64x256b (
        clk,
        i_data,
        i_wen,
        i_addr,
        o_data
    );

    parameter N=16;
    parameter Tn=16;
    parameter ADDR=6;
    parameter NUM_WORDS=64;

    input               clk;
    input [Tn-1:0]      i_wen;
    input [Tn*ADDR-1:0] i_addr;
    input [Tn*N-1:0]    i_data;
    output [Tn*N-1:0]   o_data;

    wire [Tn*N-1:0]     mem_out;

    // Necessary signals for the RF memory -> CEN = 0 so chip is enabled
    wire [2:0]     ema = 3'b000;
    wire           retn = 1'b1;
    wire           cen = 1'b0;

    // N-bit output (256-bits)
    assign o_data = mem_out;



    //---------- NBin ----------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : NB_IN
            nb_64x16b NB_RF (
                .Q(mem_out[ (i+1)*N - 1 : i*N ]),
                .CLK(clk),
                .CEN(cen),
                .WEN(i_wen[i : i]),
                .A(i_addr[ (i+1)*ADDR - 1 : i*ADDR ] ),
                .D(i_data[ (i+1)*N-1 : i*N ]),
                .EMA(ema),
                .RETN(retn)
            );
        end
    endgenerate

endmodule

module mem_64x64b (
        clk,
        i_data,
        i_wen,
        i_addr,
        o_data
    );

    parameter N=8;
    parameter Tn=16;
    parameter ADDR=5;
    parameter NUM_WORDS=32;

    input               clk;
    input [Tn-1:0]      i_wen;
    input [Tn*ADDR-1:0] i_addr;
    input [Tn*N-1:0]    i_data;
    output [Tn*N-1:0]   o_data;

    wire [Tn*N-1:0]     mem_out;

    // Necessary signals for the RF memory -> CEN = 0 so chip is enabled
    wire [2:0]     ema = 3'b000;
    wire           retn = 1'b1;
    wire           cen = 1'b0;

    // N-bit output (64-bits)
    assign o_data = mem_out;



    //---------- NBin ----------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : NB_IN
            off_32x8b NB_RF (
                .Q(mem_out[ (i+1)*N - 1 : i*N ]),
                .CLK(clk),
                .CEN(cen),
                .WEN(i_wen[i : i]),
                .A(i_addr[ (i+1)*ADDR - 1 : i*ADDR ] ),
                .D(i_data[ (i+1)*N-1 : i*N ]),
                .EMA(ema),
                .RETN(retn)
            );
        end
    endgenerate

endmodule

module latch_off_64x64b (
        clk,
        i_data,
        i_wen,
        i_addr,
        i_wr_addr,
        o_data
    );

    parameter N=16;
    parameter Tn=16;
    parameter ADDR=6;
    parameter NUM_WORDS=64;

    input               clk;
    input [Tn-1:0]      i_wen;
    input [Tn*ADDR-1:0] i_addr, i_wr_addr;
    input [Tn*N-1:0]    i_data;
    output [Tn*N-1:0]   o_data;

    wire [Tn*N-1:0]     mem_out;

    // Necessary signals for the RF memory -> CEN = 0 so chip is enabled
    wire [2:0]     ema = 3'b000;
    wire           retn = 1'b1;
    wire           cen = 1'b0;

    // N-bit output (64-bits)
    assign o_data = mem_out;



    //---------- NBin ----------//
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : OFF_BUFFER
            offset_latch #(.N(N), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) OFF_LATCH (
                clk,
                i_data[ (i+1)*N-1 : i*N ],
                i_addr[ (i+1)*ADDR - 1 : i*ADDR ],
                i_wr_addr[ (i+1)*ADDR - 1 : i*ADDR ],
                i_wen[i : i],
                o_data[ (i+1)*N - 1 : i*N ]
            );
        end
    endgenerate

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
