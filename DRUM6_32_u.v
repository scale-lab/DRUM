/*
Copyright (c) 2015 Soheil Hashemi (soheil_hashemi@brown.edu)

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Approximate Multiplier Design Details Provided in:
Soheil Hashemi, R. Iris Bahar, and Sherief Reda, "DRUM: A Dynamic
Range Unbiased Multiplier for Approximate Applications" In
Proceedings of the IEEE/ACM International Conference on
Computer-Aided Design (ICCAD). 2015. 

*/

module DRUM6_32_u(a, b, r);
input [31:0]a,b;
output [63:0]r;

wire [4:0]k1,k2;
wire [3:0]m,n;
wire [31:0]l1,l2;
wire [11:0]tmp;
wire [4:0]p,q;
wire [5:0]sum;
wire [5:0]mm,nn;
LOD u1(.in_a(a),.out_a(l1));
LOD u2(.in_a(b),.out_a(l2));
P_Encoder u3(.in_a(l1), .out_a(k1));
P_Encoder u4(.in_a(l2), .out_a(k2));
Mux_16_3 u5(.in_a(a), .select(k1), .out(m));
Mux_16_3 u6(.in_a(b), .select(k2), .out(n));
assign p=(k1>5)?k1-5:0;
assign q=(k2>5)?k2-5:0;
assign mm=(k1>5)?({1'b1,m,1'b1}):a[5:0];
assign nn=(k2>5)?({1'b1,n,1'b1}):b[5:0];
assign tmp=mm*nn;
assign sum=p+q;

Barrel_Shifter u7(.in_a(tmp), .count(sum), .out_a(r));

endmodule

//------------------------------------------------------------
module LOD (in_a, out_a);
input [31:0]in_a;
output reg [31:0]out_a;

integer k,j;
reg [31:0]w;

always @(*)
    begin
        out_a[31]=in_a[31];
        w[31]=in_a[31]?0:1;
        for (k=30;k>=0;k=k-1)
	        begin
	        w[k]=in_a[k]?0:w[k+1];
	        out_a[k]=w[k+1]&in_a[k];
	        end
	end

endmodule
//--------------------------------
module P_Encoder (in_a, out_a);
input [31:0]in_a;
output reg [4:0]out_a;

always @(*)
begin
	case(in_a)
	32'h00000001: out_a=5'h00;
	32'h00000002: out_a=5'h01;
	32'h00000004: out_a=5'h02;
	32'h00000008: out_a=5'h03;
	32'h00000010: out_a=5'h04;
	32'h00000020: out_a=5'h05;
	32'h00000040: out_a=5'h06;
	32'h00000080: out_a=5'h07;
	32'h00000100: out_a=5'h08;
	32'h00000200: out_a=5'h09;
	32'h00000400: out_a=5'h0a;
	32'h00000800: out_a=5'h0b;
	32'h00001000: out_a=5'h0c;
	32'h00002000: out_a=5'h0d;
	32'h00004000: out_a=5'h0e;
	32'h00008000: out_a=5'h0f;
    32'h00010000: out_a=5'h10;
	32'h00020000: out_a=5'h11;
	32'h00040000: out_a=5'h12;
	32'h00080000: out_a=5'h13;
	32'h00100000: out_a=5'h14;
	32'h00200000: out_a=5'h15;
	32'h00400000: out_a=5'h16;
	32'h00800000: out_a=5'h17;
	32'h01000000: out_a=5'h18;
	32'h02000000: out_a=5'h19;
	32'h04000000: out_a=5'h1a;
	32'h08000000: out_a=5'h1b;
	32'h10000000: out_a=5'h1c;
	32'h20000000: out_a=5'h1d;
	32'h40000000: out_a=5'h1e;
	32'h80000000: out_a=5'h1f;

	default: out_a=5'h0;
	endcase
end

endmodule
//--------------------------------
module Barrel_Shifter (in_a, count, out_a);
input [5:0]count;
input [11:0]in_a;
output [63:0]out_a;

assign out_a=(in_a<<count);

endmodule
//--------------------------------
module Mux_16_3 (in_a, select, out);
input [4:0]select;
input [31:0]in_a;
output reg [3:0]out;

always @(*)
begin
	case(select)
	5'h06: begin out={in_a[5],in_a[4],in_a[3],in_a[2]}; end
	5'h07: begin out={in_a[6],in_a[5],in_a[4],in_a[3]}; end
	5'h08: begin out={in_a[7],in_a[6],in_a[5],in_a[4]}; end
	5'h09: begin out={in_a[8],in_a[7],in_a[6],in_a[5]}; end
	5'h0a: begin out={in_a[9],in_a[8],in_a[7],in_a[6]}; end
	5'h0b: begin out={in_a[10],in_a[9],in_a[8],in_a[7]}; end
	5'h0c: begin out={in_a[11],in_a[10],in_a[9],in_a[8]}; end
	5'h0d: begin out={in_a[12],in_a[11],in_a[10],in_a[9]}; end
	5'h0e: begin out={in_a[13],in_a[12],in_a[11],in_a[10]}; end
	5'h0f: begin out={in_a[14],in_a[13],in_a[12],in_a[11]}; end
	5'h10: begin out={in_a[15],in_a[14],in_a[13],in_a[12]}; end
        5'h11: begin out={in_a[16],in_a[15],in_a[14],in_a[13]}; end
        5'h12: begin out={in_a[17],in_a[16],in_a[15],in_a[14]}; end
        5'h13: begin out={in_a[18],in_a[17],in_a[16],in_a[15]}; end
        5'h14: begin out={in_a[19],in_a[18],in_a[17],in_a[16]}; end
        5'h15: begin out={in_a[20],in_a[19],in_a[18],in_a[17]}; end
	5'h16: begin out={in_a[21],in_a[20],in_a[19],in_a[18]}; end
	5'h17: begin out={in_a[22],in_a[21],in_a[20],in_a[19]}; end
	5'h18: begin out={in_a[23],in_a[22],in_a[21],in_a[20]}; end
	5'h19: begin out={in_a[24],in_a[23],in_a[22],in_a[21]}; end
	5'h1a: begin out={in_a[25],in_a[24],in_a[23],in_a[22]}; end
	5'h1b: begin out={in_a[26],in_a[25],in_a[24],in_a[23]}; end
	5'h1c: begin out={in_a[27],in_a[26],in_a[25],in_a[24]}; end
	5'h1d: begin out={in_a[28],in_a[27],in_a[26],in_a[25]}; end
	5'h1e: begin out={in_a[29],in_a[28],in_a[27],in_a[26]}; end
	5'h1f: begin out={in_a[30],in_a[29],in_a[28],in_a[27]}; end

	default: begin out=5'b00000; end
	endcase
end

endmodule
