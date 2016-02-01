

module m0 (
        clk,
        i_nbin_data,
        i_offset_data,
        i_wen,
        i_addr,
        o_nbin_data,
        o_offset_data
    );

    parameter N         = 16;
    parameter Tn        = 16;
    parameter W         = (N*Tn)/2;
    parameter OFFSET_SZ = 4;

    parameter ADDR_SZ   = 6;
    parameter NUM_WORDS = 64;

    input                       clk;
    input [Tn*N-1:0]            i_nbin_data;
    input [Tn*OFFSET_SZ-1:0]    i_offset_data;
    input                       i_wen;
    input [ADDR_SZ-1:0]         i_addr;

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
    // W-bit output (128-bits)
    nb_64x128b RF0 (
        .Q(nbin_out[W-1:0]),
        .CLK(clk),
        .CEN(cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_nbin_data[W-1:0]),
        .EMA(ema),
        .RETN(retn)
    );

    // W-bit output (128-bits)
    nb_64x128b RF1 (
        .Q(nbin_out[(N*Tn)-1:W]),
        .CLK(clk),
        .CEN(cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_nbin_data[(N*Tn)-1:W]),
        .EMA(ema),
        .RETN(retn)
    ); 

    //--------- Offsets ----------//
    // Tn*OFFSET_SZ bit output (64-bits)
    off_64x64b RF2 (
        .Q(offset_out),
        .CLK(clk),
        .CEN(cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_offset_data),
        .EMA(ema),
        .RETN(retn)
    ); 


endmodule
