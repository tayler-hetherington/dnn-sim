`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////
// Author: Tom Burke
// URL: http://opencores.org/project,verilog_fixed_point_math_library
// Fixed-point Verilog math library.
///////////////////////////////////////////////////////////////////////

module qtwosComp(
        a,
        b
    );

	//Parameterized values
	parameter Q = 15;
	parameter N = 32;

    input [N-2:0] a;
    output [2*N-1:0] b;


	reg [2*N-1:0] data;
	reg [2*N-1:0] flip;
	reg [2*N-1:0] out;
	
	
	assign b = out;
	
	always @(a)
	begin
		data <= a;		//if you dont put the value into a 64b register, when you flip the bits it wont work right
	end
	
	always @(data)
	begin
		flip <= ~a;
	end
	
	always @(flip)
	begin
		out <= flip + 1;
	end

endmodule
