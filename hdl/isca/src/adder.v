

module m_addr (
        i_A,
        i_B,
        o_C
    );
    
    parameter N = 16;

    input [N-1:0] i_A, i_B;
    output [N-1:0] o_C;


    // Change adder implementation here
    assign o_C = i_A + i_B;

endmodule
