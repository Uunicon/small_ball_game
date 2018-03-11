`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/12 20:40:08
// Design Name: 
// Module Name: seven_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "Definition.h"
module seven_seg(
     input clk,
	 input rst,
	 input lose,
	 input goal,
	 input hard,
	 input start,
	 input [3:0] bar_move_speed,
    output reg [7:0] select,
    output reg [6:0] seg
    );

reg [3:0] num0 = 4'b0;

reg [3:0] num1 = 4'b0;

reg [3:0] num2 = 4'b0;

reg [3:0] num3 = 4'b0;

reg [3:0] num4 = 4'b0;

reg [3:0] num5 = 4'b0;

reg [3:0] num6 = 4'b0;

reg [3:0] num7 = 4'b0;

reg [5:0] max = 0; 
reg [5:0] score;
  
reg [3:0] cnt = 0;

reg [7:0] clk_cnt = 0;

reg sclk = 0;

always@(posedge clk)
begin
	if(clk_cnt == 8'd255)
	begin
		sclk <= ~sclk;
		clk_cnt <= 0;
	end
	else
		clk_cnt <= clk_cnt + 1;
end

wire [6:0] out0;
wire [6:0] out1;
wire [6:0] out2;
wire [6:0] out3;
wire [6:0] out4;
wire [6:0] out5;
wire [6:0] out6;
wire [6:0] out7;

seg_decoder seg0(
	.clk(clk),
	.num(num0),
	.code(out0)
	);

seg_decoder seg1(
	.clk(clk),
	.num(num1),
	.code(out1)
	);

seg_decoder seg2(
	.clk(clk),
	.num(num2),
	.code(out2)
	);

seg_decoder seg3(
	.clk(clk),
	.num(num3),
	.code(out3)
	);
	
seg_decoder seg4(
    .clk(clk),
    .num(num4),
    .code(out4)
    );
    
seg_decoder seg5(
    .clk(clk),
    .num(num5),
    .code(out5)
    );
    
seg_decoder seg6(
    .clk(clk),
    .num(num6),
    .code(out6)
    );
    
seg_decoder seg7(
    .clk(clk),
    .num(num7),
    .code(out7)
    );
	
// Display eight  seg
always@(posedge sclk)
begin
	if(!rst) //low active
	begin
		cnt <= 0;
	end
	else
	begin
		case(cnt)
		4'b0000:
		begin
			seg <= out0;
			select <= 8'b1111_1110;
		end	
		4'b0001:
		begin
			seg <= out1;
			select <= 8'b1111_1101;
		end
		4'b0010:
		begin
			seg <= out2;
			select <= 8'b1111_1011;
		end
		4'b0011:
		begin
			seg <= out3;
			select <= 8'b1111_0111;
		end
		4'b0100:
                begin
                    seg <= out4;
                    select <= 8'b1110_1111;
                end    
                4'b0101:
                begin
                    seg <= out5;
                    select <= 8'b1101_1111;
                end
                4'b0110:
                begin
                    seg <= out6;
                    select <= 8'b1011_1111;
                end
                4'b111:
                begin
                    seg <= out7;
                    select <= 8'b0111_1111;
                end
		endcase
		cnt <= cnt + 1;	
		if(cnt == 3'b111)
			cnt<=0;
	end
end


// Flush data each time you lose
always@(negedge rst or posedge lose or posedge goal or posedge start or negedge start)
begin
	if(!rst||lose||!start)
	begin
		if(!rst)
		begin
		  num0 = 0;
          num1 = 0;
          num2 = 0;
          num3 = 0;
          max =0 ;
		end
		else
		begin
		  num0 = 0;
          num1 = 0;
          num2 = 0;
          num3 = 0;
          score = 0;
          num4 = max % 10;
          num5 = (max/10) % 10;
          num6 = (max/100) % 10;
		end
	end
	else if(goal)
	begin
	   
	   if(hard) score = score + 2*bar_move_speed;
       else     score = score + bar_move_speed;
    if(max <= score)   max = score;
    num0 = score % 10;
    num1 = (score/10) % 10;
    num2 = (score/100) % 10;
    num3 = (score/1000) % 10;
    num4 = max % 10;
    num5 = (max/10) % 10;
    num6 = (max/100) % 10;
    num7 = (max/1000) % 10;
    end

    
end

endmodule
