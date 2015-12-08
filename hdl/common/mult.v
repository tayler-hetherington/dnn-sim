

module m_mult (
        i_A,
        i_B,
        o_C
    );
    
    parameter N = 16;
    parameter Q = 10;

    input [N-1:0] i_A, i_B;
    output [N-1:0] o_C;


    //------------- Change multiplier implementation here ------------//
    // Integer multiplier
    // assign o_C = i_A * i_B;

    // Online fixed-point multiplier
    qmult #(.Q(Q), .N(N)) MULT (
        i_A,
        i_B,
        o_C
    );

endmodule
