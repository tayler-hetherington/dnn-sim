
module fixp_mult (
        i_A,
        i_B,
        o_C
    );

    parameter Q = 10;
    parameter N = 16;

    input [N-1:0] i_A, i_B;
    output [N-1:0] o_C;

    wire [(2*N) - 1 : 0] A, B, C;
   
    always @(i_A, i_B) begin
        A <= i_A;
        B <= i_B;
    end
    
    always @(A, B) begin
        C <= A * B;
    end

    always @(C) begin
        o_C <= C[N+Q-1 : Q]; // Truncate
    end

endmodule
