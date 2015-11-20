

module n3_cluster ( 
        clk,
        rst,
        i_data,
        o_data,
        o_idx,
        o_offset
    );

    parameter N         = 16;
    parameter Tn        = 16;
    parameter OFFSET_SZ = 4;

    // Inputs
    input                      clk, rst;
    input [Tn*N-1:0]           i_data;
    
    // Outputs
    output [Tn*N-1:0]          o_data;
    output [Tn*OFFSET_SZ-1:0]  o_idx;
    output [Tn*OFFSET_SZ-1:0]  o_offset;

    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : COMP_ARRAY
            n3 #(.N(N), .OFFSET_SZ(OFFSET_SZ)) COMP (
                clk,
                rst,
                i_data   [ (i+1)*N - 1 : i*N ],
                o_data   [ (i+1)*N - 1 : i*N ],
                o_idx    [ (i+1)*OFFSET_SZ - 1 : i*OFFSET_SZ ],
                o_offset [ (i+1)*OFFSET_SZ - 1 : i*OFFSET_SZ ]
            );
        end
    endgenerate

endmodule

module n3 (
        clk,
        rst,
        i_data,
        o_data,
        o_idx,
        o_offset
    );
    
    parameter N         = 16;
    parameter OFFSET_SZ = 4;

    // Inputs
    input                   clk, rst;
    input [N-1:0]           i_data;
    
    // Outputs
    output [N-1:0]          o_data;
    output [OFFSET_SZ-1:0]  o_idx;
    output [OFFSET_SZ-1:0]  o_offset;

    // Internal signals
    reg [OFFSET_SZ-1:0]     idx_reg;        // Registers for Index
    reg [OFFSET_SZ-1:0]     offset_reg;     // Register for Offset
    reg [N-1:0]             data_reg;


    wire [OFFSET_SZ-1:0]    rst_idx, next_idx, inc_idx;
    wire [OFFSET_SZ-1:0]    rst_offset, next_offset, inc_offset;

    wire                    is_zero;   // Indicates whether the input data is all zero or not

    //////////////////////////////////////////////////
    /////////////////// Code Start ///////////////////
    //////////////////////////////////////////////////
    
    //--------- Update registers
    always @(posedge clk) begin
        data_reg    <= i_data;
        idx_reg     <= rst_idx;
        offset_reg  <= rst_offset;
    end

    //--------- Output logic
    assign o_data       = data_reg;
    assign o_idx        = idx_reg; 
    assign o_offset     = offset_reg;

    //--------- Reset logic
    assign rst_idx      = (rst) ? ({OFFSET_SZ{1'b0}}) : (next_idx);
    assign rst_offset   = (rst) ? ({OFFSET_SZ{1'b0}}) : (next_offset);

    //--------- Zero calculation
    assign is_zero      = ~(|i_data); // Inverted OR reduction

    //--------- Offset increment logic (+1)
    assign inc_offset   = offset_reg + 1'b1;
    assign next_offset  = inc_offset;

    //--------- Idx increment logic (+2)
    assign inc_idx      = idx_reg + 1'b1;
    assign next_idx     = (is_zero) ? (idx_reg) : (inc_idx); // If is_zero, keep the same idx. Otherwise, increment
    
endmodule
