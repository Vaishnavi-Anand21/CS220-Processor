`timescale 1ns / 1ps

module bit1_adder (
    sum, c_out, a, b, c_in
); 

    output sum, c_out;
    input a, b, c_in;
    wire h_sum;
    wire i1, i2, i3;

    // to find sum- c^(a^b)
    xor p1 (h_sum, a, b); //a^b
    xor p2 (sum, h_sum, c_in); // a^b^c_in

    // to find carry out - ab+ c(a^b)
    and t1 (i1, a, b);           // ab
    xor t2 (i2, a, b);          // a^b
    and t3 (i3, c_in, i2);     // c(a^b)
    or  t4 (c_out, i3, i1);   //ab + c(a^b)

endmodule



// module test_bench ;

// reg a, b, c_in;
// wire sum, c_out;

// bit1_adder ans(.sum(sum), .c_out(c_out), .a(a), .b(b), .c_in(c_in));



//  initial begin a=1'b1;  #4; a=1'b0;#10 $stop();end
//   initial begin b=1'b1; forever #2 b=~b;end
//   initial begin c_in=1'b1;forever #1 c_in=~c_in; #10 $stop();end

// // monitor all the input and output ports at times 
// // when any of the input changes its state

// //  initial begin $monitor(" time=%0d A=%b B=%b 
// //                           Cin=%b Sum=%b Cout=%b",$time,a,b,c_in,sum,c_out);end
// initial begin
// // $monitor("time=%0d A=%b B=%b Cin=%b Sum=%b Cout=%b",$time,a,b,c_in,sum,c_out);
// end
    
// endmodule