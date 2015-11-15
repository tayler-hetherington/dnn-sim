
module top_level_test (
        clk,
        rst,
        data,
        base_addr,
        f_addr,
        offset
    );

    parameter N = 16;
    parameter ADDR_SIZE = 16; // FIXME: Based on actual SRAM size

    // Inputs
    input                   clk, rst;
    input [N-1:0]           data;
    input [ADDR_SIZE-1:0]   base_addr;
    
    // Outputs
    output [ADDR_SIZE-1:0]  f_addr;
    output [N-1:0]          offset;

    
    reg [N-1:0]             data_reg;
    reg [ADDR_SIZE-1:0]     base_addr_reg;

    n4 CMPR (
        clk,
        rst,
        data_reg,
        base_addr_reg,
        f_addr,
        offset
    );

    always @(posedge clk) begin
        data_reg        = data;
        base_addr_reg   = base_addr;
    end
            


endmodule
