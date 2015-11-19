// Testing SRAM with flip-flops. Shared read/write port. 
module top_sram_test (
        clk,
        i_data,
        i_wen,
        i_addr,
        o_data
    );
   
    parameter N=256;
    parameter ADDR=3;       // 6
    parameter NUM_WORDS=8;  // 64

    input               clk;
    input               i_wen;
    input [ADDR-1:0]    i_addr;
    input [N-1:0]       i_data;

    output [N-1:0]      o_data;

    reg [N-1:0] i_reg;
    reg [N-1:0] o_reg;
    reg               wen_reg;
    reg [ADDR-1:0]    addr_reg;

    wire [N-1:0] mem_out;

    always @(posedge clk) begin
        i_reg <= i_data;
        wen_reg <= i_wen;
        addr_reg <= i_addr;
        o_reg <= mem_out;
    end
    
    assign o_data = o_reg;

    sp_sram #(.N(N), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) SRAM (
        clk,
        i_reg,
        addr_reg,
        wen_reg,
        mem_out
    );

endmodule

module sp_sram (
        clk,
        i_data,
        i_addr,
        i_wen,
        o_data
    );
    
    parameter N=32;
    parameter ADDR=4;
    parameter NUM_WORDS=16;

    input clk, i_wen;
    input [N-1:0] i_data;
    input [ADDR-1:0] i_addr;

    reg [N-1:0] x;

    //output reg [N-1:0] o_data;
    output [N-1:0] o_data;

    reg [N-1:0] mem [NUM_WORDS-1:0];

    assign o_data = i_wen ? {(N){1'bz}} : x;

    always @(posedge clk) begin
        if(i_wen) begin
            mem[i_addr]     <= i_data;
            //o_data          <= {(N){1'bz}};
            //o_data          <= i_data;
        end else begin
            //o_data          <= mem[i_addr];
            x <= mem[i_addr];
        end
    end
endmodule


// Testing SRAM implemented with Latches. 1r1w port.
module top_sram_latch_test (
        clk,
        i_data,
        i_wen,
        i_rd_addr,
        i_wr_addr,
        o_data
    );
   
    parameter N=256;
    parameter ADDR=3;       // 6
    parameter NUM_WORDS=8;  // 64

    input               clk;
    input               i_wen;
    input [ADDR-1:0]    i_rd_addr, i_wr_addr;
    input [N-1:0]       i_data;

    output [N-1:0]      o_data;

    reg [N-1:0] i_reg;
    reg [N-1:0] o_reg;
    reg               wen_reg;
    reg [ADDR-1:0]    rd_addr_reg, wr_addr_reg;

    wire [N-1:0] mem_out;

    always @(posedge clk) begin
        i_reg <= i_data;
        wen_reg <= i_wen;
        rd_addr_reg <= i_rd_addr;
        wr_addr_reg <= i_wr_addr;
        o_reg <= mem_out;
    end
    
    assign o_data = o_reg;

    sp_sram_latch #(.N(N), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) SRAM (
        clk,
        i_reg,
        rd_addr_reg,
        wr_addr_reg,
        wen_reg,
        mem_out
    );

endmodule

module sp_sram_latch (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );
    
    parameter N=32;
    parameter ADDR=4;
    parameter NUM_WORDS=16;

    input clk, i_wen;
    input [N-1:0] i_data;
    input [ADDR-1:0] i_rd_addr, i_wr_addr;

    reg [N-1:0] x;

    output [N-1:0] o_data;

    reg [N-1:0] mem [NUM_WORDS-1:0];

    reg [ADDR-1:0] rd_addr_reg;

    assign o_data = mem[rd_addr_reg];

    always @(posedge clk) begin
        rd_addr_reg             <= i_rd_addr;
        if(i_wen) begin
            mem[i_wr_addr]      <= i_data;
        end 
    end
endmodule


module top_nbin(
        clk,
        i_data,
        i_cen,
        i_wen,
        i_addr,
        i_wr_addr,
        o_data
    );
   
    parameter N=128;
    parameter ADDR=6;
    parameter NUM_WORDS=64;

    output [2*N-1:0]   o_data;
    input           clk;
    input           i_cen;
    input           i_wen;
    input [ADDR-1:0]     i_addr;
    input [ADDR-1:0]     i_wr_addr;
    input [2*N-1:0]    i_data;

    //reg [N-1:0] mem_out;
    //wire [N-1:0] t;


    reg [N-1:0] i_reg1, i_reg2;
    reg [2*N-1:0] o_reg;
    reg               wen_reg;
    reg [ADDR-1:0]    addr_reg;
    reg           retn_reg;
    reg           cen_reg;


    wire [N-1:0] mem_out1, mem_out2;
    wire [2:0]     ema = 3'b000;
    wire           retn = 1'b1;

    always @(posedge clk) begin
        i_reg1 <= i_data[2*N-1 : N];
        i_reg2 <= i_data[N-1: 0];
        wen_reg <= i_wen;
        addr_reg <= i_addr;
        cen_reg <= i_cen;
        o_reg <= {mem_out2, mem_out1};
    end
    
    assign o_data = o_reg;

    sram_test RF1 (
        .Q(mem_out1),
        .CLK(clk),
        .CEN(cen_reg),
        .WEN(wen_reg),
        .A(addr_reg),
        .D(i_reg1),
        .EMA(ema),
        .RETN(retn)
    );

    sram_test RF2 (
        .Q(mem_out2),
        .CLK(clk),
        .CEN(cen_reg),
        .WEN(wen_reg),
        .A(addr_reg),
        .D(i_reg2),
        .EMA(ema),
        .RETN(retn)
    );
/*
    test_sram #(.N(N), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) NBIN (
        clk,
        i_data, 
        i_addr,
        i_wr_addr,
        i_wen,
        t
    );

    assign o_data = mem_out;
    always @(posedge clk) begin
        mem_out <= t;
    end
*/
/*
    diannao_nbin NBIN(
        .Q(o_data),
        .CLK(clk),
        .CEN(i_cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_data),
        .EMA(i_ema),
        .RETN(i_retn)
    );
    */
    /*
    rf_sp_unit_nbin NBIN (
        .Q(o_data),
        .CLK(clk),
        .CEN(i_cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_data),
        .EMA(i_ema),
        .RETN(i_retn)
    );
    */
    /*
    rf_unit_nbin_2 NBIN (
        .Q(o_data),
        .CLK(clk),
        .CEN(i_cen),
        .WEN(i_wen),
        .A(i_addr),
        .D(i_data),
        .EMA(i_ema),
        .RETN(i_retn)
    );
    */

endmodule

module top_nbout(
        clk,
        i_data,
        i_cen,
        i_wen,
        i_addr,
        i_wr_addr,
        o_data
    );
   
    parameter N=128;
    parameter ADDR=4;
    parameter NUM_WORDS=16;

    output [2*N-1:0]   o_data;
    input           clk;
    input           i_cen;
    input           i_wen;
    input [ADDR-1:0]     i_addr;
    input [ADDR-1:0]     i_wr_addr;
    input [2*N-1:0]    i_data;



    reg [N-1:0] i_reg1, i_reg2;
    reg [2*N-1:0] o_reg;
    reg               wen_reg;
    reg [ADDR-1:0]    addr_reg;
    reg           retn_reg;
    reg           cen_reg;


    wire [N-1:0] mem_out1, mem_out2;
    wire [2:0]     ema = 3'b000;
    wire           retn = 1'b1;

    always @(posedge clk) begin
        i_reg1 <= i_data[2*N-1 : N];
        i_reg2 <= i_data[N-1: 0];
        wen_reg <= i_wen;
        addr_reg <= i_addr;
        cen_reg <= i_cen;
        o_reg <= {mem_out2, mem_out1};
    end
    
    assign o_data = o_reg;

    nbout_2x RF1 (
        .Q(mem_out1),
        .CLK(clk),
        .CEN(cen_reg),
        .WEN(wen_reg),
        .A(addr_reg),
        .D(i_reg1),
        .EMA(ema),
        .RETN(retn)
    );

    nbout_2x RF2 (
        .Q(mem_out2),
        .CLK(clk),
        .CEN(cen_reg),
        .WEN(wen_reg),
        .A(addr_reg),
        .D(i_reg2),
        .EMA(ema),
        .RETN(retn)
    );

endmodule

module test_sram (
        clk,
        i_data,
        i_rd_addr,
        i_wr_addr,
        i_wen,
        o_data
    );
    
    parameter N=32;
    parameter ADDR=4;
    parameter NUM_WORDS=16;

    input clk, i_wen;
    input [N-1:0] i_data;
    input [ADDR-1:0] i_rd_addr;
    input [ADDR-1:0] i_wr_addr;
    output [N-1:0] o_data;
    
    reg [ADDR-1:0] rd_addr_reg;
    reg [N-1:0] mem [NUM_WORDS-1:0];

    assign o_data = mem[rd_addr_reg];

    always @(posedge clk) begin
        rd_addr_reg <= i_rd_addr;
        if(i_wen) begin
            mem[i_wr_addr] <= i_data;
        end 
    end
endmodule

module top_nbin2(
        clk,
        i_data1,
        i_data2,
        i_wen1,
        i_wen2,
        i_addr1,
        i_addr2,
        o_data1,
        o_data2
    );
   
    parameter N=64;
    parameter ADDR=6;
    parameter NUM_WORDS=64;

    output [N-1:0]   o_data1, o_data2;
    input           clk;
    input           i_wen1, i_wen2;
    input [ADDR-1:0]     i_addr1, i_addr2;
    input [N-1:0]    i_data1, i_data2;

    reg [N-1:0] mem_out1, mem_out2;
    wire [N-1:0] t1, t2;

    true_dpram_sclk #(.N(N), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) RAM (
        i_data1, 
        i_data2,
        i_addr1, 
        i_addr2,
        i_wen1, 
        i_wen2,
        clk,
        t1, 
        t2
    );

    /*
    test_sram2 #(.N(N), .ADDR(ADDR), .NUM_WORDS(NUM_WORDS)) NBIN (
        clk,
        i_data1, 
        i_data2,
        i_addr1,
        i_addr2,
        i_wen1,
        i_wen2,
        t1,
        t2
    );
*/
    assign o_data1 = mem_out1;
    assign o_data2 = mem_out2;
    always @(posedge clk) begin
        mem_out1 <= t1;
        mem_out2 <= t2;
    end

endmodule

module test_sram2 (
        clk,
        i_data1,
        i_data2,
        i_addr1,
        i_addr2,
        i_wen1,
        i_wen2,
        o_data1,
        o_data2
    );
    
    parameter N=32;
    parameter ADDR=4;
    parameter NUM_WORDS=16;

    input clk, i_wen1, i_wen2;
    input [N-1:0] i_data1, i_data2;
    input [ADDR-1:0] i_addr1, i_addr2;
    output reg [N-1:0] o_data1, o_data2;

    reg [N-1:0] mem [NUM_WORDS-1:0];



    /*
    always @(posedge clk) begin
        if(i_wen1) begin
            mem[i_addr1] <= i_data1;
        end else begin
            o_data1 <= mem[i_addr1];
        end
    end

    always @(posedge clk) begin
//        if(i_wen2) begin
//            mem[i_addr2] <= i_data2;
//        end else begin
            o_data2 <= mem[i_addr2];
//        end       
    end
    */


endmodule

module true_dpram_sclk(
    data_a, data_b,
    addr_a, addr_b,
    we_a, we_b, clk,
    q_a, q_b
);

    parameter N=16;
    parameter ADDR=6;
    parameter NUM_WORDS=64;

    input [N-1:0] data_a, data_b;
    input [ADDR-1:0] addr_a, addr_b;
    input we_a, we_b, clk;
    output reg [N-1:0] q_a, q_b;
   

    // Declare the RAM variable
    reg [N-1:0] ram[NUM_WORDS-1:0];

    always @ (posedge clk)
    begin
        if (we_a && !we_b)  begin
            ram[addr_a] <= data_a;
            q_a <= data_a;
            q_b <= ram[addr_b];
        end else if (we_b && !we_a) begin
            ram[addr_b] <= data_b;
            q_b <= data_b;
            q_a <= ram[addr_a];
        end
        else begin
            q_a <= ram[addr_a];
            q_b <= ram[addr_b];
        end
    end

    /*
    
    // Port A
    always @ (posedge clk)
    begin
        if (we_a) 
        begin
            ram[addr_a] <= data_a;
            q_a <= data_a;
        end
        else 
        begin
            q_a <= ram[addr_a];
        end
    end
    
    // Port B
    always @ (posedge clk)
    begin
        if (we_b)
        begin
            ram[addr_b] <= data_b;
            q_b <= data_b;
        end
        else
        begin
            q_b <= ram[addr_b];
        end
    end
    */

endmodule



