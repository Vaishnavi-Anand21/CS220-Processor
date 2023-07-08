`timescale 1ps/1ps

module or32 (
    input [31:0]a, b, output [31:0]log_or
);

genvar i;

generate
for ( i= 0;i<32 ;i=i+1 ) begin
    
    or t (log_or[i], a[i], b[i]);

end
endgenerate
    
endmodule