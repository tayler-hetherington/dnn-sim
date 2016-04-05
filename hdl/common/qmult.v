`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////
// Author: Tom Burke
// URL: http://opencores.org/project,verilog_fixed_point_math_library
// Fixed-point Verilog math library.
///////////////////////////////////////////////////////////////////////

module qmult(
        a,
        b,
        c
    );

    //Parameterized values
	parameter Q = 15;
	parameter N = 32;
    
    input [N-1:0] a;
    input [N-1:0] b;
    output [N-1:0] c;

	wire [2*N-1:0] a_ext;
	wire [2*N-1:0] b_ext;
	wire [2*N-1:0] r_ext;
	
	reg [2*N-1:0] a_mult;
	reg [2*N-1:0] b_mult;
	reg [2*N-1:0] result;
	reg [N-1:0] retVal;
	

	//qtwosComp #(Q,N) comp_a (a[30:0], a_ext);
    qtwosComp #(Q,N) comp_a (a[(N-2):0], a_ext);

	//qtwosComp #(Q,N) comp_b (b[30:0], b_ext);
	qtwosComp #(Q,N) comp_b (b[(N-2):0], b_ext);

	qtwosComp #(Q,N) comp_r (result[N-2+Q:Q], r_ext);
	
	assign c = retVal;
	
	always @(a_ext,b_ext)
	begin
		if(a[N-1] == 1)
			a_mult <= a_ext;
		else
			a_mult <= a;
			
		if(b[N-1] == 1)
			b_mult <= b_ext;
		else
			b_mult <= b;		
	end 
	
	always @(a_mult,b_mult)
	begin
		result <= a_mult * b_mult;
	end
	
	always @(result,r_ext)
	begin		
		//sign
		if((a[N-1] == 1 && b[N-1] == 0) || (a[N-1] == 0 && b[N-1] == 1)) begin
			retVal[N-1] <= 1;
			retVal[N-2:0] <= r_ext[N-2:0];
		end
		else begin
			retVal[N-1] <= 0;
			retVal[N-2:0] <= result[N-2+Q:Q];
		end
	end

endmodule
