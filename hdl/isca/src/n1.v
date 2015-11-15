
// This module implements the single multiplier and adder/accumulator 
//
//

module n1 (
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
    m_addr #(N) A0 (mult_out, i_nbout, adder_out);

    assign o_res = adder_out;

endmodule
