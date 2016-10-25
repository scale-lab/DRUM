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

module DRUM5_16_u(a, b, r);
input [15:0]a,b;
output [31:0]r;

wire [3:0]k1,k2;
wire [2:0]m,n;
wire [15:0]l1,l2;
wire [9:0]tmp;
wire [3:0]p,q;
wire [4:0]sum;
wire [4:0]mm,nn;
LOD u1(.in_a(a),.out_a(l1));
LOD u2(.in_a(b),.out_a(l2));
P_Encoder u3(.in_a(l1), .out_a(k1));
P_Encoder u4(.in_a(l2), .out_a(k2));
Mux_16_3 u5(.in_a(a), .select(k1), .out(m));
Mux_16_3 u6(.in_a(b), .select(k2), .out(n));
assign p=(k1>4)?k1-4:0;
assign q=(k2>4)?k2-4:0;
assign mm=(k1>4)?({1'b1,m,1'b1}):a[4:0];
assign nn=(k2>4)?({1'b1,n,1'b1}):b[4:0];
assign tmp=mm*nn;
assign sum=p+q;

Barrel_Shifter u7(.in_a(tmp), .count(sum), .out_a(r));

endmodule

//------------------------------------------------------------
module LOD (in_a, out_a);
input [15:0]in_a;
output reg [15:0]out_a;

integer k,j;
reg [15:0]w;

always @(*)
    begin
        out_a[15]=in_a[15];
        w[15]=in_a[15]?0:1;
        for (k=14;k>=0;k=k-1)
	        begin
	        w[k]=in_a[k]?0:w[k+1];
	        out_a[k]=w[k+1]&in_a[k];
	        end
	end

endmodule
//--------------------------------
module P_Encoder (in_a, out_a);
input [15:0]in_a;
output reg [3:0]out_a;

always @(*)
begin
	case(in_a)
	16'h0001: out_a=4'h0;
	16'h0002: out_a=4'h1;
	16'h0004: out_a=4'h2;
	16'h0008: out_a=4'h3;
	16'h0010: out_a=4'h4;
	16'h0020: out_a=4'h5;
	16'h0040: out_a=4'h6;
	16'h0080: out_a=4'h7;
	16'h0100: out_a=4'h8;
	16'h0200: out_a=4'h9;
	16'h0400: out_a=4'ha;
	16'h0800: out_a=4'hb;
	16'h1000: out_a=4'hc;
	16'h2000: out_a=4'hd;
	16'h4000: out_a=4'he;
	16'h8000: out_a=4'hf;
	default: out_a=4'h0;
	endcase
end

endmodule
//--------------------------------
module Barrel_Shifter (in_a, count, out_a);
input [4:0]count;
input [9:0]in_a;
output [31:0]out_a;

assign out_a=(in_a<<count);

endmodule
//--------------------------------
module Mux_16_3 (in_a, select, out);
input [3:0]select;
input [15:0]in_a;
output reg [2:0]out;

always @(*)
begin
	case(select)
	4'h5: begin out={in_a[4],in_a[3],in_a[2]}; end
	4'h6: begin out={in_a[5],in_a[4],in_a[3]}; end
	4'h7: begin out={in_a[6],in_a[5],in_a[4]}; end
	4'h8: begin out={in_a[7],in_a[6],in_a[5]}; end
	4'h9: begin out={in_a[8],in_a[7],in_a[6]}; end
	4'ha: begin out={in_a[9],in_a[8],in_a[7]}; end
	4'hb: begin out={in_a[10],in_a[9],in_a[8]}; end
	4'hc: begin out={in_a[11],in_a[10],in_a[9]}; end
	4'hd: begin out={in_a[12],in_a[11],in_a[10]}; end
	4'he: begin out={in_a[13],in_a[12],in_a[11]}; end
	4'hf: begin out={in_a[14],in_a[13],in_a[12]}; end
	default: begin out=3'b000; end
	endcase
end

endmodule
