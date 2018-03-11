module SBgame(
			input clk_in,    
			input rst,
			input to_left,
			input to_right,
			input [3:0] bar_move_speed,
			input start,
			input hard,
            input two,
            input to_left_2,
            input to_right_2,
            output HSync,         
            output [3:0] OutBlue,
            output [3:0] OutGreen, 
            output [3:0] OutRed,         
            output VSync,
			output [7:0] seg_select,
			output [6:0] seg_LED
    );


wire mclk;
wire lose;
wire goal;

clk_vag clk
 (
 // Clock in ports
  .clk_in(clk_in),
  // Clock out ports
  .clk_out(mclk),
  // Status and control signals
  .resetn(rst)
 );

VGA_Dispay u_VGA_Disp(
	.clk(mclk),
	.to_left(to_left),
	.to_right(to_right),
	.bar_move_speed(bar_move_speed),
	.start(start),
	.hard(hard),
	.hs(HSync),
	.Blue(OutBlue),
	.Green(OutGreen),
	.Red(OutRed),
	.vs(VSync),
	.lose(lose),
	.goal(goal),
	.rst(rst),
	.two(two),
	.to_left_2(to_left_2),
	.to_right_2(to_right_2)
	);
	
seven_seg score_board(
	.clk(mclk),
	.rst(rst),
	.goal(goal),
	.hard(hard),
	.lose(lose),
	.start(start),
	.select(seg_select),
	.seg(seg_LED),
    .bar_move_speed(bar_move_speed)
	);
	

endmodule