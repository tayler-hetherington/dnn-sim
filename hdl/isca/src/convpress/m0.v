

module m0 (
        clk,
        i_nbin_data,
        i_sb_data,
        i_addr,
        o_nbin_data,
        o_sb_data
    );

    parameter N         = 16;
    parameter Tn        = 16;
    parameter ADDR_SIZE = 4;

    input                   clk;
    input [Tn*N-1:0]        i_nbin_data;
    input [Tn*Tn*N-1:0]     i_sb_data;
    input [ADDR_SIZE-1:0]   i_addr;

    output reg [Tn*N-1:0]       o_nbin_data;
    output reg [Tn*Tn*N-1:0]    o_sb_data;

    // FIXME: Replace with SRAM 
    always @(posedge clk) begin     
        o_nbin_data <= i_nbin_data;
        o_sb_data   <= i_sb_data;
    end

endmodule
