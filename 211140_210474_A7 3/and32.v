`timescale 1ps/1ps

module and32 (
    input [31:0]a, b, output [31:0]log_a
);

genvar i;
generate
for ( i= 0;i<32 ;i= i+1 ) begin
    
    and t (log_a[i], a[i], b[i]);

end
endgenerate
    
endmodule