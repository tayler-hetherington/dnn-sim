
// Main n0 cluster module:
//       Cluster of 16 units
//
module n0_cluster (
        i_nbin,
        i_sb,
        i_nbout,
        o_n0
    );

    parameter N    = 16;
    parameter Tn   = 16;
    parameter TnxTn = Tn*Tn; 


    // Need to instantiate:
    //      (1) 16 NBin = 16 entries * 1 wide * 16-bits each -> 1 per unit (16 per cluster)
    //      (2) 16 NBout = 4 entries * 16 wide * 16-bits each -> 1 per unit (16 per cluster)
    //      (3) 256 lanes = 16 units, 16 lanes per unit

    input [N*Tn - 1 : 0]        i_nbin;        // Tn values read from NBin SRAM
    input [N*TnxTn - 1 : 0]     i_sb;          // Tn x Tn values read from SB eDRAM
    input [N*TnxTn - 1 : 0]     i_nbout;       // Tn x Tn partial sum values read from NBout
    output [N*TnxTn - 1 : 0]    o_n0;

    wire [N*TnxTn - 1 : 0]      unit_out;       // Tn x Tn values to writeback to NBout

    // Output assignment
    assign o_n0 = unit_out;

    // (3) Main Unit gen
    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : UNIT_gen
            n0_unit UNIT (
                i_nbin      [ (i+1)*N - 1 : i*N ],
                i_sb        [ (i+1)*N*Tn - 1 : i*N*Tn ],
                i_nbout     [ (i+1)*N*Tn - 1 : i*N*Tn ],
                unit_out    [ (i+1)*N*Tn - 1 : i*N*Tn ]
            );
        end
    endgenerate

endmodule


// Stage one unit:
//      16 lanes each performing multiply + accumulate
module n0_unit (
        i_nbin,
        i_sb,
        i_nbout,
        o_res
    );

    parameter N  = 16;
    parameter Tn = 16;

    input   [N-1:0]     i_nbin; 
    input   [Tn*N-1:0]  i_sb, i_nbout;
    output  [Tn*N-1:0]  o_res;

    genvar i;
    generate
        for(i=0; i<Tn; i=i+1) begin : mult
            n0_lane_mult_add LANE (
                i_nbin,
                i_sb    [ (i+1)*N - 1 : i*N ],
                i_nbout [ (i+1)*N - 1 : i*N ],
                o_res   [ (i+1)*N - 1 : i*N ]
            );
        end
    endgenerate

endmodule

// Implements a single multiplier and accumulator 
module n0_lane_mult_add (
        i_nbin,
        i_sb,
        i_nbout,
        o_res
    );

    parameter N = 16;

    input   [N-1:0] i_nbin, i_sb, i_nbout;
    output  [N-1:0] o_res;

    wire    [N-1:0] mult_out;
    wire    [N-1:0] adder_out;

    m_mult  #(N) M0 (i_nbin, i_sb, mult_out);
    m_addr  #(N) A0 (mult_out, i_nbout, adder_out);

    assign o_res = adder_out;

endmodule
