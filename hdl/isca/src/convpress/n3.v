

module n3_cluster ( 
        clk,
        rst,
        i_data,
        i_base_addr,
        o_final_addr,
        o_offset
    );

    parameter N = 16;
    parameter Tn = 16;
    parameter ADDR_SIZE = 16; // FIXME: Based on actual SRAM size

    // Inputs
    input                      clk, rst;
    input [Tn*N-1:0]           i_data;
    input [ADDR_SIZE-1:0]   i_base_addr;
    
    // Outputs
    output [Tn*ADDR_SIZE-1:0]  o_final_addr;
    output [Tn*N-1:0]          o_offset;

    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : COMP_ARRAY
            n3 COMP (
                clk,
                rst,
                i_data [ (i+1)*N - 1 : i*N ],
                i_base_addr,
                o_final_addr [ (i+1)*N - 1 : i*N ],
                o_offset [ (i+1)*N - 1 : i*N ]
            );

        end
    endgenerate



endmodule

module n3 (
        clk,
        rst,
        i_data,
        i_base_addr,
        o_final_addr,
        o_offset
    );

    parameter N = 16;
    parameter ADDR_SIZE = 16; // FIXME: Based on actual SRAM size

    // Inputs
    input                   clk, rst;
    input [N-1:0]           i_data;
    input [ADDR_SIZE-1:0]   i_base_addr;
    
    // Outputs
    output [ADDR_SIZE-1:0]  o_final_addr;
    output [N-1:0]          o_offset;

    // Internal signals
    reg [ADDR_SIZE-1:0]     idx_reg;        // Registers for Index
    reg [N-1:0]             offset_reg;     // Register for Offset

    wire [ADDR_SIZE-1:0]    rst_idx, next_idx, inc_idx;
    wire [N-1:0]            rst_offset, next_offset, inc_offset;

    wire                    is_zero;   // Indicates whether the input data is all zero or not

    //////////////////////////////////////////////////
    /////////////////// Code Start ///////////////////
    //////////////////////////////////////////////////
    
    // Update registers
    always @(posedge clk) begin
        idx_reg     <= rst_idx;
        offset_reg  <= rst_offset;
    end

    // Output logic
    assign o_final_addr = i_base_addr + idx_reg; // Final address for SRAM is base_addr + index (address offset)
    assign o_offset     = offset_reg;

    // Reset logic
    assign rst_idx      = (rst) ? (16'b0) : (next_idx);
    assign rst_offset   = (rst) ? (16'b0) : (next_offset);

    // Zero calculation
    assign is_zero      = ~(|i_data); // Inverted OR reduction

    // Offset increment logic (+1)
    assign inc_offset   = offset_reg + 1'b1;
    assign next_offset  = inc_offset;

    // Idx increment logic (+2)
    assign inc_idx      = idx_reg + 2'b10;
    assign next_idx     = (is_zero) ? (idx_reg) : (inc_idx); // If is_zero, keep the same idx. Otherwise, add 2
    
endmodule
