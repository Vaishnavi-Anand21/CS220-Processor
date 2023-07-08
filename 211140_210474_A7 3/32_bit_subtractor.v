`timescale 1ns / 1ps

`include "1_bit_subtractor.v"

module bit32s (
   output [31:0] diff, output b_out, input [31:0] a, b
) ;

   genvar i;
   wire [31:0] borrow;
    
    generate
   for ( i=0; i<32; i=i+1)
   begin
    if (i==0)
 bit1_subtractor f (.diff(diff[0]), .b_out(borrow[0]), .a(a[0]), .b(b[0]), .b_in(1'b0));
 else
       bit1_subtractor f(.diff(diff[i]), .b_out(borrow[i]), .a(a[i]), .b(b[i]), .b_in(borrow[i-1]));
       
        end
           assign b_out= borrow[31];
       endgenerate
  
endmodule


// module test_bench2 ;
//          reg [31:0]a, b, out;
//          wire b_out;
//          wire [31:0] diff;
//          wire high;
//          reg clk;

//          bit32 uut (.diff(diff[31:0]), .b_out(b_out), .a(a[31:0]), .b(b[31:0]));

//          initial begin
//              clk <=0;
//         forever #5 clk=~clk;
//          end


//          initial begin
//             $dumpfile("32_bit_subtractor.vcd");
//             $dumpvars(0, uut);
//         a = 0;
//         b = 0;
        

//       //   $monitor("A = %b, B = %b, R = %b,borrow = %b", a, b, diff, b_out);

//       //   repeat(10) begin
//       //       a = $random;
//       //       b = $random;
//       //       #15;
//       //   end
     
//          end

//           always @(posedge clk ) begin
         
//        a=32'd15;
//        b= 32'd17;
//        out= 32'd32;
//        if (diff==out)  high=1; 
//       end

//       always @(negedge clk )begin
//          a=0;
//          b=0;
//          out=0;
//          high=0;
//       end
    

//          initial #100 $finish;
// endmodule
