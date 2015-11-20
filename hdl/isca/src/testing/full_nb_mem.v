
module nb_test (
        clk,
        i_data,
        i_wen,
        i_addr,
        o_data
    );

    parameter N=16;
    parameter Tn=16;
    parameter ADDR=6;

    input clk, i_wen;
    input [ADDR-1:0] i_addr;
    input [Tn*N-1:0] i_data;

    output [Tn*N-1:0] o_data;

    wire [Tn*N-1:0] mem_out;

    mem_64x256b MEM (
        clk,
        i_data,
        i_wen,
        i_addr,
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
    parameter NxTn = N*Tn;
    parameter W=(NxTn/2);
    parameter ADDR=6;
    parameter NUM_WORDS=64;

    input               clk;
    input               i_wen;
    input [ADDR-1:0]    i_addr;
    input [NxTn-1:0]    i_data;
    output [NxTn-1:0]   o_data;

    wire [NxTn-1:0]     mem_out;

    // Necessary signals for the RF memory -> CEN = 0 so chip is enabled
    wire [2:0]     ema = 3'b000;
    wire           retn = 1'b1;
    wire           cen = 1'b0;

    // N-bit output (256-bits)
    assign o_data = mem_out;

    // W-bit output (128-bits)
    nb_64x128b RF0 (
        .Q(mem_out[W-1:0]),
        .CLK(clk),
        .CEN(cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_data[W-1:0]),
        .EMA(ema),
        .RETN(retn)
    );

    // W-bit output (128-bits)
    nb_64x128b RF1 (
        .Q(mem_out[NxTn-1:W]),
        .CLK(clk),
        .CEN(cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_data[NxTn-1:W]),
        .EMA(ema),
        .RETN(retn)
    );

endmodule
