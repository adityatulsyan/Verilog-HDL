module DECODER(out, a, b, c);

	input a, b, c;
	output [0:7]out;
	wire x, y, z;

	not n1(x, a);
	not n2(y, b);
	not n3(z, c);

	and a1(out[0], x, y, z);
	and a2(out[1], x, y, c);
	and a3(out[2], x, b, z);
	and a4(out[3], x, b, c);
	and a5(out[4], a, y, z);
	and a6(out[5], a, y, c);
	and a7(out[6], a, b, z);
	and a8(out[7], a, b, c);

endmodule

module FADDER(s, c, a, b, cin);
	input a, b, cin;
	output s, c;
	wire [0:7] d;

	DECODER dec(d, a, b, cin);
	assign sum = d[1] | d[2] | d[4] | d[7];
	assign c = d[3] | d[5] | d[6] | d[7];
endmodule

module FADDER8(sum, carry, A, B, Cin);
	input [7:0]A, B;
	input Cin;
	output [7:0]sum;
	output carry;
	wire a, b, c, d, e, f, g, h;

	FADDER f1(sum[0], a, A[0], B[0], Cin);
	FADDER f2(sum[1], b, A[1], B[1], a);
	FADDER f3(sum[2], c, A[2], B[2], b);
	FADDER f4(sum[3], d, A[3], B[3], c);
	FADDER f5(sum[4], e, A[4], B[4], d);
	FADDER f6(sum[5], f, A[5], B[5], e);
	FADDER f7(sum[6], g, A[6], B[6], f);
	FADDER f8(sum[7], h, A[7], B[7], g);
endmodule

module testbench_8BFA;
  reg [7:0] A, B;
  reg CarryIn;
  wire  [7:0]Sum;
  wire  Carry;
  integer i, j;
  FADDER8 mod(Sum, Carry, A, B, CarryIn);
  
  initial
    begin
      $monitor($time," A = %b, B = %b, Carry In = %b, Carry = %b, Sum = %b.", A, B, CarryIn, Carry, Sum);
      #0  A=8'b00000000;  B=8'b00000000;  CarryIn=1'b0;
      for(i=0; i<256; i=i+1)
        begin
          for(j=0; j<256; j=j+1)
            begin
              #3  CarryIn = CarryIn+1'b1;
              B=B+8'b00000001;
            end
            A=A+8'b00000001;
        end
    end
endmodule

