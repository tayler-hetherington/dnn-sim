

module m1 (
        clk,
        i_nbout,
        i_addr,
        o_nbout
    );

    parameter N         = 16;
    parameter Tn        = 16;
    parameter ADDR_SIZE = 4;

    input                   clk;
    input [Tn*Tn*N-1:0]     i_nbout;
    input [ADDR_SIZE-1:0]   i_addr;

    output reg [Tn*Tn*N-1:0]    o_nbout;

    // FIXME: Replace with SRAM
    always @(posedge clk) begin
        o_nbout <= i_nbout;
    end

endmodule
