
// Main n0 cluster module:
//       Cluster of 16 units
//
module n0_cluster (
        clk,
        i_nbin,
        i_sb,
        o_n0
    );

    parameter N    = 16;
    parameter Tn   = 16;
    parameter TnxTn = Tn*Tn; 


    // Need to instantiate:
    //      (1) 16 NBin = 16 entries * 1 wide * 16-bits each -> 1 per unit (16 per cluster)
    //      (2) 16 NBout = 4 entries * 16 wide * 16-bits each -> 1 per unit (16 per cluster)
    //      (3) 256 lanes = 16 units, 16 lanes per unit

    input                       clk;
    input [N*Tn - 1 : 0]        i_nbin;        // Tn values read from NBin SRAM
    input [N*TnxTn - 1 : 0]     i_sb;          // Tn x Tn values read from SB eDRAM
    output [N*TnxTn - 1 : 0]    o_n0;

    wire [N*TnxTn - 1 : 0]      unit_out;       // Tn x Tn values to writeback to NBout

    // Output assignment
    assign o_n0 = unit_out;

    // (3) Main Unit gen
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : UNIT_gen
            n0_unit UNIT (
                clk,
                i_nbin      [ (i+1)*N - 1    : i*N    ],
                i_sb        [ (i+1)*N*Tn - 1 : i*N*Tn ],
                unit_out    [ (i+1)*N*Tn - 1 : i*N*Tn ]
            );
        end
    endgenerate

endmodule


// Stage one unit:
//      16 lanes each performing a (hopefully) pipied fixed-point multiply
module n0_unit (
        clk,
        i_nbin,
        i_sb,
        o_res
    );

    parameter N  = 16;
    parameter Tn = 16;

    input               clk;
    input   [N-1:0]     i_nbin; 
    input   [Tn*N-1:0]  i_sb;
    output  [Tn*N-1:0]  o_res;


    // Add pipelineing registers here to try and autopipeline - putting it in the multiplier fails
    reg     [N-1:0]     nb_reg [1:0];
    reg     [Tn*N-1:0]  sb_reg [1:0];

    always @(posedge clk) begin
        nb_reg[1] <= nb_reg[0];
        sb_reg[1] <= sb_reg[0]; 
        nb_reg[0] <= i_nbin;
        sb_reg[0] <= i_sb;
    end

    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : mult
            n0_lane_mult LANE (
                clk,
                nb_reg[1],
                sb_reg[1][ (i+1)*N - 1 : i*N ],
                o_res    [ (i+1)*N - 1 : i*N ]
            );
        end
    endgenerate

endmodule




// Implements a single multiplier and accumulator 
module n0_lane_mult (
        clk,
        i_nbin,
        i_sb,
        o_res
    );

    parameter N = 16;

    input           clk;
    input   [N-1:0] i_nbin, i_sb;
    output  [N-1:0] o_res;

    wire    [N-1:0] mult_out;

    assign o_res = mult_out;

    mult_piped MULT_PIPE (
        clk,
        i_nbin,
        i_sb,
        mult_out
    );

endmodule
