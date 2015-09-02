// Rotating Barrel Shifter
// from
// http://stackoverflow.com/questions/20357390/how-can-i-make-my-verilog-shifter-more-general

module shifter #( parameter CTRL=3, parameter WIDTH=2**CTRL )
    ( input wire [WIDTH-1:0] in,
      input wire [ CTRL-1:0] shift,
      output wire [WIDTH-1:0] out );
    wire [WIDTH-1:0] tmp [CTRL:0];
    assign tmp[CTRL] = in;
    assign out = tmp[0];
    genvar i;
    generate
        for (i = 0; i < CTRL; i = i + 1) begin
        mux_2to1 #(.WIDTH(WIDTH)) g(
                .in0(tmp[i+1]),
                .in1({tmp[i+1][WIDTH-(2**i)-1:0],tmp[i+1][WIDTH-1:WIDTH-(2**i)]}),
                .sel(shift[i]),
                .out(tmp[i]) );
        end 
    endgenerate
endmodule

module mux_2to1 #( parameter WIDTH=8 )
    ( input wire [WIDTH-1:0] in0, in1,
      input wire             sel,
      output wire [WIDTH-1:0] out );
    assign out = sel ? in1 : in0;
endmodule
