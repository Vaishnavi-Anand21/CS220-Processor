`timescale 1ps/1ps
`include "ALU.v"

module tb ;

reg [31:0]a, b, ins;
wire c_out;
wire [31:0] c, pc;


 ALU a1 (.a(a), .b(b), .ins(ins), .pc(pc), .c_out(c_out), .c(c));


 initial begin
    ins=32'd0;
    a=32'd0;
    b=32'd0;

#10
ins= 32'd1;
a= 32'd2;
b=32'd4;


 end   
initial begin
 $monitor(" A=%d B=%b Sum=%d Cout=%d",a,b,c,c_out);
end
endmodule