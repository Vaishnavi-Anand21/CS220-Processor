`include "ALU.v"


module Data_Memory (
    input clk, rst, write_enable, mode, input[31:0]adds, input[31:0]data_in, output reg[31:0] data_out
    );
    wire[31:0] a0,a1,a2,a3,a4,a5,a6, a7, a8, a9, a10;
    assign a0=mem[0];
    assign a1=mem[1];
    assign a2=mem[2];
    assign a3=mem[3];
    assign a4=mem[4];
    assign a5=mem[5];
    assign a6=mem[6];
    assign a7=mem[7];
    assign a8=mem[8];
    assign a9=mem[9];
    assign a10=mem[10];
    
    reg [31:0] mem[31:0];
// 4294967295
   
    reg [31:0] prev;

    initial begin
        mem[0]<= 32'd0;//zero
        mem[1]<= 32'd9;//n
        mem[2]<= 32'd9;//a starts
        mem[3]<= 32'd5;
        mem[4]<= 32'd1;
        mem[5]<= 32'd1;
        mem[6]<= 32'd7;
        mem[7]<= 32'd1;
        mem[8]<= 32'd2;
        mem[9] <= 32'd12;
        mem[10]<= 32'd1;
    end
    
    always@(data_in or posedge write_enable or adds) begin
        
        if (!mode && write_enable) begin
            data_out<=32'b0;
            #1
            mem[adds]<=data_in;
        end
        else begin
         data_out<=mem[adds];
        end
    end
    

    
endmodule



module Instruction_memory (
    input clk, rst, write_enable,mode, input[31:0]adds, input[31:0]data_in, output reg[31:0] data_out
);



reg[31:0] mem[31:0];
integer i;
wire [31:0] pc;
reg [31:0] decode;


initial begin
mem[0]={6'd14, 5'b0, 5'd1, 16'b0};///load_i
 mem[1]= {6'd14, 5'b0, 5'd3, 16'd1}; ///n
 mem[2]= {6'd11, 5'd3, 5'd3, 16'd1}; //n-1= n-1//subi
 mem[3]= {6'd16, 5'd1, 5'd3, 16'd16}; //beq i==n-1
 mem[4]= {6'd14, 5'b0, 5'd2, 16'd0}; ////load_j=
 mem[5]= {6'd2, 5'd3, 5'd1, 5'd4, 11'b0  }; /// n-i-1
 mem[6]= {6'd16, 5'd2, 5'd4, 16'd11}; // beq j==n-i-1 //loop 2
 mem[7]= {6'd14, 5'd2, 5'd5, 16'd2}; //load a[j]
 mem[8]= {6'd14, 5'd2, 5'd6, 16'd3}; //load a[j+1]
 mem[9]= {6'd21, 5'd5, 5'd6, 16'd6}; //bleq
 mem[10]= {6'd10, 5'd6, 5'd7, 16'd0 }; ////swap starts 
 mem[11]= {6'd10, 5'd5, 5'd6, 16'd0 };
 mem[12]= {6'd10, 5'd7, 5'd5, 16'd0 }; ///swap ends
 mem[13]= {6'd15, 5'd2, 5'd5, 16'd2}; //load a[j] back
 mem[14]= {6'd15, 5'd2, 5'd6, 16'd3}; //load a[j+1] back
 mem[15]= {6'd10, 5'd2, 5'd2, 16'd1}; // j=j+1
 mem[16]={6'd23, 26'd6}; // jloop2
 mem[17]= {6'd10, 5'd1, 5'd1, 16'd1}; //i =i+1
mem[18]= {6'd23, 26'd3};
mem[19]= {6'd14, 5'b0, 5'd1, 16'd2}; //load a[0]
mem[20]= {6'd14, 5'b0, 5'd2, 16'd3}; //load a[1]
mem[21]= {6'd14, 5'b0, 5'd3, 16'd4}; //load a[2]
mem[22]= {6'd14, 5'b0, 5'd4, 16'd5}; //load a[3]

 
  
 

end
always@( adds or mode or rst  )
begin
       
    if (rst)
    begin
      for (i=0; i<32; i=i+1) begin 
      mem[i]<=32'b0;
      end
    end
    else begin
    if (!mode && write_enable) begin
      mem[adds]<=data_in;
       data_out<=32'b0;
    end  
    else begin
       data_out<=mem[adds];
    end
    end
   
end
    
endmodule 


module Register_file (
    input [4:0] adds1, adds2,adds3, input write_reg, input [31:0]data_in, output reg [31:0] out1, out2
);


reg [31:0] regfile[31:0];
initial begin
    regfile[0]= 32'b0;
    regfile[31]= 32'b0;
end



always@( * ) begin

    if (write_reg) begin 
        regfile[adds3]<= data_in;
    end
    else begin
            out1<=regfile[adds1]; 
            out2<=regfile[adds2];
    end 
end
   
endmodule


module Control_Unit (
    input jump,reset_p, input [31:0]ins, pc,c,load, b_r, output reg write_data, write_reg,output reg [4:0]  out1_add, out2_add, reg_write, output reg [31:0] data_reg, data_mem, mem_write, new_pc
);

always@( pc or ins ) begin

    
    write_data=1'b0;
    write_reg=1'b0;
    if (ins[31:26]==6'd24) begin
        out1_add=5'b0;
    end
    else begin
    out1_add= ins[25:21];
    end
    out2_add= ins[20:16];
    if (ins[31:26]>=6'd10 && ins[31:26]<=6'd14) reg_write= ins[20:16];
    else reg_write= ins[15:11];
    if (ins[31:26]==6'd25) reg_write=5'b0;
      mem_write= c;
     
end
    
    always@(c) begin
         mem_write= c;

    end

    always@(c or load or jump or b_r ) begin

     new_pc = pc + 32'b1;

    if (jump) begin
           new_pc= c;
        end

        data_mem = b_r;

        if (ins[31:26]==6'd15) begin
              write_data=1'b1;
             
        end

      if ((ins[31:26]>=6'd10 && ins[31:26]<=6'd14 ) || (ins[31:26]>=6'd1 && ins[31:26]<=6'd9) || ins[31:26]==6'd25 )  begin
            write_reg=1'b1;
      end

      if (ins[31:26]==6'd14) begin
         data_reg= load;
      end

      else if (ins[31:26]==6'd25) begin
        data_reg= pc+ 32'b1;
      end

      else data_reg= c;


        
    end

    
    

    
endmodule

module Decipher_instructions (
    input[31:0] ins_w, address, input clk, reset_p, reset, mode, write_enable,  output reg [31:0] pc_out
);


wire it, jt, rt;
wire [31:0]ins;
reg [31:0] pc;
wire jump;
wire [31:0]a, b_r, c, data_in, temp, load;
wire write_reg, write_data;
wire [31:0] data_write, data_reg, data_mem, mem_write;
wire c_out;
wire [4:0]out1_add, out2_add, reg_write;
wire [31:0]new_pc, next_pc;
wire [31:0]b;
wire [31:0] fill;

always@(posedge clk)begin
     if (reset_p) begin
        pc=32'b0;
     end
     else  
        pc<=new_pc;
        pc_out<=new_pc;
   
end

Control_Unit c1 (.ins(ins), .reset_p(reset_p), .jump(jump), .pc(pc),.c(c), .load(load), .b_r(b_r), .write_data(write_data), .write_reg(write_reg), .out1_add(out1_add), .out2_add(out2_add), .reg_write(reg_write), .data_reg(data_reg), .data_mem(data_mem), .mem_write(mem_write), .new_pc(next_pc));

assign new_pc = (reset_p) ? (32'b0) : (next_pc);
Instruction_memory i1 (.clk(clk), .write_enable(write_enable), .rst(reset), .data_out(ins), .adds(fill), .data_in(ins_w), .mode(mode));
assign fill = (mode) ? (pc) : (address);

Register_file f1 (.adds1(out1_add), .adds2(out2_add), .write_reg(write_reg), .data_in(data_reg), .out1(a), .out2(b_r), .adds3(reg_write));

assign b= (ins[31:26]>=10 && ins[31:26]<=15) ? ({16'b0, ins[15:0]}) : (b_r);

Data_Memory da1 (.clk(clk), .rst(1'b0), .write_enable(write_data), .mode(1'b0), .adds(mem_write), .data_in(data_mem), .data_out(load));

ALU a1 (.a(a), .b(b), .ins(ins), .pc(pc), .c(c), .c_out(c_out), .jump(jump));

assign it= ((ins[31:26]>=6'd10 && ins[31:26]<=6'd22)? (1'b1) : (1'b0));
assign jt=  ((ins[31:26]>=6'd23) ? (1'b1) : (1'b0));
assign rt= (ins[31:26]<=6'd9 ? 1'd1: 1'b0);


endmodule

module tb ;

 reg[31:0] ins_w, address;
 reg clk, reset_p, reset, mode, write_enable;
  wire [31:0] pc_out;

  reg [31:0] ans;
  reg [4:0] adds;
  wire [31:0] out1, out2; 

initial begin
    clk<=1'b0;
    forever #10 clk=~clk;
end

Decipher_instructions d1 (
    .ins_w(ins_w), .address(address), .clk(clk), .reset_p(reset_p), .reset(reset), .mode(mode), .write_enable(write_enable), .pc_out(pc_out)
);

//  Register_file r1 (  .adds1(adds), .adds2(5'd1), .adds3(5'd1) , .write_reg(1'b0), .data_in(32'b0), .out1(out1), .out2(out2) );



initial begin
    $dumpfile("b.vcd");
    $dumpvars(0,tb);
end

initial begin
    // adds= 5'd2;
    reset_p=1'b1;
    // ins_w= 32'b0;
    // reset= 1'b0;
    // #10
    
    // // mode=1'b0;
    // // // ins_w= {6'd14, 5'b0, 5'b1, 16'b0}; //load word
    // // // address=32'b0;
    // // write_enable=1'b1;
    // #20
    
    // mode=1'b0;
    // ins_w<= {6'd14, 5'b0, 5'd2, 16'b1}; //load word
    // address<=32'b1;
    // write_enable<=1'b1;
    // #20
    // ins_w= {6'd23, 26'b1};//jump
    // address=32'd2;
    // #20
    // ins_w= {6'd1, 5'd2, 5'd1, 5'd2, 11'd0}; //add
    // address=32'd3;
    // write_enable=1'b1;
    // #20
    // ins_w= {6'd1, 5'd2, 5'd2, 5'd3, 11'd0}; //add
    // address=32'd4;
    // write_enable=1'b1;
    // #20
    mode=1'b1;
    #20
    reset_p=1'b0;
    #10000 $finish;
    
  



end

initial begin

//  $monitor("ans=%d", out1);
end
    
endmodule