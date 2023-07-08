
`timescale 1ns / 1ps

`include "1_bit_adder.v"

module bit32a (
   output [31:0] sum, output c_out, input [31:0] a, b
) ;

   genvar i;
   wire [31:0] carry;
    
    generate
   for ( i=0; i<32; i=i+1)
   begin
    if (i==0)
 bit1_adder f (.sum(sum[0]), .c_out(carry[0]), .a(a[0]), .b(b[0]), .c_in(1'b0));
 else
       bit1_adder f(.sum(sum[i]), .c_out(carry[i]), .a(a[i]), .b(b[i]), .c_in(carry[i-1]));
       
        end
           assign c_out= carry[31];
       endgenerate
  
endmodule

