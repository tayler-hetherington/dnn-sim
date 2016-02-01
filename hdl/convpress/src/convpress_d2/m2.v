

module m2 (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );
    
    parameter N         = 16;
    parameter Tn        = 16;
    parameter ADDR      = 2;
    parameter NUM_WORDS = 4;

    input                   clk;
    input   [N*Tn*Tn-1:0]   i_data;
    input   [ADDR*Tn-1:0]   i_rd_addr, i_wr_addr;   // Tn addresses and wen bits
    input   [Tn-1:0]        i_wen;                  
    output  [N*Tn*Tn-1:0]   o_data;

    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : M2_UNIT_GEN
            m2_unit #(.N(N), .Tn(Tn), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) M2_UNIT (
                clk,
                i_data   [ (i+1)*Tn*N-1 : i*Tn*N ],
                i_rd_addr[ (i+1)*ADDR-1 : i*ADDR ],
                i_wr_addr[ (i+1)*ADDR-1 : i*ADDR ],
                i_wen    [ i            : i      ],
                o_data   [ (i+1)*Tn*N-1 : i*Tn*N ]
            );

        end
    endgenerate

    
endmodule

module m2_unit (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );
    parameter N         = 16;
    parameter Tn        = 16;
    parameter ADDR      = 2;
    parameter NUM_WORDS = 4;

    input                   clk;
    input   [N*Tn-1:0]      i_data;
    input   [ADDR-1:0]      i_rd_addr, i_wr_addr;   
    input                   i_wen;                  
    output  [N*Tn-1:0]      o_data;
        
    sram_latch #(.N(N), .Tn(Tn), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) UNIT_FWD_BUFFER (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );

endmodule


module sram_latch (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );

    parameter N         = 16;
    parameter Tn        = 16;
    parameter ADDR      = 2;
    parameter NUM_WORDS = 4;

    input               clk, i_wen;
    input [Tn*N-1:0]    i_data;
    input [ADDR-1:0]    i_rd_addr, i_wr_addr;
    output [Tn*N-1:0]   o_data;

    reg [ADDR-1:0]      rd_addr_reg;
    reg [Tn*N-1:0] mem [NUM_WORDS-1:0];
    
    assign o_data = mem[rd_addr_reg];

    always @(posedge clk) begin
        rd_addr_reg             <= i_rd_addr;
        if(i_wen) begin
            mem[i_wr_addr]      <= i_data;
        end
    end

endmodule

