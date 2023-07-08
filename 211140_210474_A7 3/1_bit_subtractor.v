`timescale 1ns / 1ps


module bit1_subtractor (
    diff, b_out, a, b, b_in
); 

    output diff, b_out;
    input a, b, b_in;
    wire i1, i2, i3, i4;
    wire b_c, a_c;

    // to find diff- a^b^(b_in)
    not n1 (a_c, a);
    not n2 (b_c, b);
                   
    xor q1 (i1, a, b); //a^b
    xor q2 (diff, i1, b_in);  //(a^b)^b_in

    
    // to find borrow out - (~a)b +bc+ (~a)c
    and t1 (i2, a_c, b);          // (~a)b
    or t2 (i3, b, a_c);          // (~a)+b
    and t3 (i4, b_in, i3);      // c(b+(~a))
    or t4 (b_out, i2, i4);     // (~a)b +bc+ (~a)c

endmodule



// module test_bench ;

// reg a, b, b_in;
// wire diff, b_out;

// bit1_subtractor ans(.diff(diff), .b_out(b_out), .a(a), .b(b), .b_in(b_in));



//  initial begin a=1'b1;  #4; a=1'b0;#10 $stop();end
//   initial begin b=1'b1; forever #2 b=~b;end
//   initial begin b_in=1'b1;forever #1 b_in=~b_in; #10 $stop();end

// // monitor all the input and output ports at times 
// // when any of the input changes its state

// //  initial begin $monitor(" time=%0d A=%b B=%b 
// //                           Cin=%b Sum=%b Cout=%b",$time,a,b,c_in,sum,c_out);end
// initial begin
// $monitor("time=%0d A=%b B=%b Bin=%b Diff=%b Bout=%b",$time,a,b,b_in,diff,b_out);
// end
    
// endmodule