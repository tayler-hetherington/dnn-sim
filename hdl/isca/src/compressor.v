

module compressor (
        i_clk,
        i_rst,
        i_data,
        i_base_addr,
        o_final_addr,
        o_offset
    );

    parameter N = 16;
    parameter ADDR_SIZE = 16; // FIXME: Based on actual SRAM size

    // Inputs
    input                   i_clk, i_rst;
    input [N-1:0]           i_data;
    input [ADDR_SIZE-1:0]   i_base_addr;
    
    // Outputs
    output [ADDR_SIZE-1:0]  o_final_addr;
    output [N-1:0]          o_offset;

    // Internal signals
    reg [ADDR_SIZE-1:0]     idx;        // Registers for Index
    reg [N-1:0]             offset;     // Register for Offset

    wire [ADDR_SIZE-1:0]    rst_idx, next_idx, inc_idx;
    wire [N-1:0]            rst_offset, next_offset, inci_offset;

    wire is_zero;   // Indicates whether the input data is all zero or not

    /////////////////////////////////////////////
    /////////////////// Logic ///////////////////
    /////////////////////////////////////////////

    // Output logic
    assign o_final_addr = i_base_addr + idx; // Final address for SRAM is base_addr + index (address offset)
    assign o_offset     = offset;

    // Reset logic
    assign rst_idx      = (i_rst) ? (ADDR_SIZE'b0) : (next_idx);
    assign rst_offset   = (i_rst) ? (N'b0) : (next_offset);

    // Zero calculation
    assign is_zero      = ~(|i_data); // Inverted OR reduction

    // Offset increment logic (+1)
    assign inc_offset   = offset + 1'b1;
    assign next_offset  = inc_offset;

    // Idx increment logic (+2)
    assign inc_idx      = idx + 2'b2;
    assign next_idx     = (is_zero) ? (idx) : (inc_idx); // If is_zero, keep the same idx. Otherwise, add 2
    
    // Update registers
    always @(posedge i_clk) begin
        idx     = rst_idx;
        offset  = rst_offset;
    end
        

endmodule
