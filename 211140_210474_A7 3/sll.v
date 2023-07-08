`timescale 1ps/1ps

module sll (
    input [31:0]a, input [4:0]shift_amt, output [31:0] ans
);

assign ans= a<<shift_amt;
    
endmodule