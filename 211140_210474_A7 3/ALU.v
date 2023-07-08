`timescale 1ps/1ps
`include "32_bit_adder.v"
`include "32_bit_subtractor.v"
`include "and32.v"
`include "sll.v"
`include "or32.v"


module ALU (
    input [31:0]a , b , ins, pc, output reg [31:0] c, output reg c_out, jump
);

wire [31:0]out_a, next_a;
wire [31:0]out_s;
wire [31:0]log_a, log_or, log_sll, log_srl;
wire c_out_a, c_out_s, c_out_ad;
wire eq, gt, ge, lt, le;
reg jump_a;
assign gt = (a>b) ? (1'b1): (1'b0);
assign lt = (a<b) ? (1'b1) : (1'b0);
assign le = (a<=b) ? (1'b1) : (1'b0);
assign ge = (a>=b) ? (1'b1) : (1'b0);
assign eq = (a==b) ? (1'b1) : (1'b0);
bit32a z6 (.a(pc), .b({16'b0, ins[15:0]}), .sum(next_a), .c_out(c_out_ad) );
 bit32a z1 (.a(a), .b(b), .sum(out_a), .c_out(c_out_a));
 bit32s z2 (.a(a), .b(b), .diff(out_s), .b_out(c_out_s));
 and32 z3 (.a(a), .b(b), .log_a(log_a));
 or32 z4 (.a(a), .b(b), .log_or(log_or));
 sll z5 (.a(a), .shift_amt(ins[10:6]), .ans(log_sll));

always@(*) begin
    jump<=1'b0;
    
    case (ins[31:26])
        6'd1: begin /////add
            c<= out_a;
            jump<=1'b0;
            c_out<=c_out_a;
        end

        6'd2: begin  ///////sub
        jump<=1'b0;
          c<= out_s;
          c_out<= c_out_s;
        end

        6'd3: begin ////////add unsigned
        jump<=1'b0;
            c<=out_a;
            c_out<=c_out_a;
        end

        6'd4: begin  /////////sub unsigned
        jump<=1'b0;
            c<= out_s;
            c_out<= c_out_s;
        end

        6'd10: begin  //////addi
         jump<=1'b0;
            c<= out_a; 
            c_out<=c_out_a;
        end                
        6'd11: begin /////subi
        jump<=1'b0;
            c<=out_s;
            c_out<= c_out_s;
        end

        6'd5: begin // and
        jump<=1'b0;
            c<= log_a;
            c_out<=0;
         end
        6'd6:  begin /////or
        jump<=1'b0;
            c<=log_or;
            c_out<=0;
        end
        6'd12: begin//andi
           c<= log_a;
           jump<=1'b0;
            c_out<=0;
        end
        6'd13: begin//ori
        jump<=1'b0;
          c<=log_or;
          c_out<=0;
        end
        6'd7: begin//sll
          c<=log_sll;
          jump<=1'b0;
          c_out<=0;
        end
        6'd8: begin //srl
            c<= log_srl;
            jump<=1'b0;
            c_out<=0;
        end 
         6'd14: begin//lw
         c<= a + {16'b0, ins[15:0]};
         jump<=1'b0;
         c_out<=0;
         end
        6'd15: begin//sw
          c<=  a + {16'b0, ins[15:0]};
         jump<=1'b0;
         c_out<= 0;
        end
        6'd16:begin //beq
             if(eq)  begin
                c<= next_a;
                c_out=c_out_ad;
                jump<=1'b1;
             end
             else begin
                c<=32'b0;
                c_out<=0;
                jump<=1'b0;
             end
        end
        6'd17:begin //bne
               if (eq) begin
                 c<=pc+32'd4;
                c_out<=0;
               jump<=1'b0;
               end
               else begin
                c<=next_a;
                c_out=c_out_ad;
                 jump<=1'b1;
               end
        end
        6'd18: begin //bgt
              if (gt) begin
                jump<=1'b1;
                 c<=next_a ; 
            c_out<=c_out_ad;
              end
              else begin
                jump<=1'b0;
                 c<=pc+32'd4;
                c_out<=0;
              end
        end
        6'd19: begin //bgte
            if (ge) begin
                 jump<=1'b1;
                 c<=next_a ; 
            c_out<=c_out_ad;
              end
              else begin
                jump<=1'b0;
                 c<=pc+32'd4;
                c_out<=0;
              end
        end 
        6'd20: begin //ble
            if (lt) begin
                 jump<=1'b1;
                 c<=next_a ; 
            c_out<=c_out_ad;
              end
              else begin
                 c<=pc+32'd4;
                 jump<=1'b0;
                c_out<=0;
              end
        end
        6'd21: begin //bleq
            if (le) begin

                 jump<=1'b1;
                 c<= next_a ; 
                 c_out<=c_out_ad;
              end
              else begin
                jump<=1'b0;
                 c<=pc+32'b0;
                c_out<=0;
              end
        end

        6'd23: begin //j
            jump<=1'b1;
            c <= {6'b0, ins[25:0]};
            c_out<=0;
        end
        
        6'd24: begin ///jr
            jump<=1'b1;
            c<=a;
            c<=1'b0;
          
        end

        6'd25: begin //jal
            jump<=1'b1;
            c<={6'b0, ins[25:0]};
            c_out<=1'b0;
        end

        6'd9: begin //slt
          if (a<b) c<=32'b1;
          else c<=32'b0;
          c_out<=1'b0;
        end

        6'd22:begin //slti
          if (ins[20:16]<ins[15:0] ) c<=a;
          else c<=32'b0;
        end
    
        default: begin
            c_out<=1'bx;
            c<=32'bx;
            jump<=1'b0;
        end
        
    endcase

end
    
endmodule