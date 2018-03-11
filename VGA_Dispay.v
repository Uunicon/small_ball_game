`include "Definition.h"

module VGA_Dispay(
    input clk,
	 input to_left,
	 input to_right,
	 input [3:0] bar_move_speed,
	 input start,
	 input hard,
	 input rst,
     input two,
     input to_left_2,
     input to_right_2,
     output hs,
     output vs,
     output reg [3:0] Red,
     output reg [3:0] Green,
     output reg [3:0] Blue,
	 output  lose,
	 output reg goal
    );
    
     //bound
       parameter UP_BOUND = 10;    
       parameter DOWN_BOUND = 480;  
       parameter LEFT_BOUND = 20;  
       parameter RIGHT_BOUND = 630;
   
       // Radius of the ball
       parameter ball_r = 10;
       parameter block = 15;
       // The position of the downside bar
       reg [9:0] up_pos = 400;
       reg [9:0] down_pos = 417;
       // The position of the upside bar
	   reg [9:0] up_pos_2 = 50;
       reg [9:0] down_pos_2 = 67;
       
	//end game
	reg end_g_b=0;
	reg end_g_k=0;
	wire end_g;
	assign end_g = end_g_b | end_g_k;
	//lose
	reg lose_b =0;
	reg lose_k =0;
    assign lose = lose_b | lose_k;

	//register definition
	wire [9:0] Hcnt;      // horizontal counter  if = PLD-1 -> Hcnt <= 0
	wire [9:0] Vcnt;      // verical counter  if = LFD-1 -> Vcnt <= 0

	reg h_speed = `RIGHT;
	reg v_speed = `UP; 
	
	//block
	reg h_speed_b = `RIGHT;
    reg v_speed_b = `UP; 

	// The position of the bar

	reg [9:0] left_pos = 280;
	reg [9:0] right_pos = 380;  
    reg [9:0] left_pos_2 = 280;
    reg [9:0] right_pos_2 = 380;  
	

		
	// The circle heart position of the ball / beginning
	reg [9:0] ball_x_pos = 330;
	reg [9:0] ball_y_pos = 390;
	
	// The center position of the block / beginning
	reg [9:0] block_x_pos = 100;
    reg [9:0] block_y_pos = 100;
	
//--------------generate hs vs----------------	
	VGA_H_V_Ctrl generate_vga_t(
	.clk(clk),
    .Hcnt(Hcnt),
    .Vcnt(Vcnt),
    .hs(hs),
    .vs(vs)
	);
	

//---------------color control-----------------------	
            //Display the downside bar and the ball
always @ (posedge clk)   
begin  
                if(!two)
                begin   
                // Display the downside bar
                if (Vcnt>=up_pos && Vcnt<=down_pos  
                        && Hcnt>=left_pos && Hcnt<=right_pos) 
                  if(hard)
                    begin
                       Red <= 4'b1000;  
                       Green <= 4'b1111;  
                       Blue <= 4'b1111;
                    end
                  else
                    begin  
                      Red <= 4'b1111;  
                      Green <= 4'b1111;  
                      Blue <= 4'b0000; 
                    end  
                // Display the ball
                else if ( (Hcnt - ball_x_pos)*(Hcnt - ball_x_pos) + (Vcnt - ball_y_pos)*(Vcnt - ball_y_pos) <= (ball_r * ball_r)) 
                if (hard)
                begin
                  Red <= 4'b0111;  
                  Green <= 4'b0000;  
                  Blue <= 4'b0111;  
                end
                else 
                  begin  
                    Red <= 4'b0000;  
                    Green <= 4'b1111;  
                    Blue <= 4'b1111;  
                  end  
                // Display the block
                else if((Hcnt - block_x_pos)*(Hcnt - block_x_pos)<= block*block && (Vcnt - block_y_pos)*(Vcnt - block_y_pos)<= block*block  )
                begin
                  //hard mode    
                  if(hard)    
                  begin
                    Red <= 4'b0000;  
                    Green <= 4'b1110;  
                    Blue <= 4'b1110;  
                  end
                end
                else 
                begin  
                    Red <= 4'b0000;  
                    Green <= 4'b0000;  
                    Blue <= 4'b0000;  
                end
              end 
              else//two mode
              begin
                // Display the upside bar
                              if (Vcnt>=up_pos_2 && Vcnt<=down_pos_2  
                                                        && Hcnt>=left_pos_2 && Hcnt<=right_pos_2) 
                                if(hard)
                                  begin
                                     Red <= 4'b1000;  
                                     Green <= 4'b1111;  
                                     Blue <= 4'b1111;
                                  end
                                else
                                  begin  
                                    Red <= 4'b1100;  
                                    Green <= 4'b1110;  
                                    Blue <= 4'b0000; 
                                  end 
                               // Display the upside bar
                               else if (Vcnt>=up_pos && Vcnt<=down_pos  
                                        && Hcnt>=left_pos && Hcnt<=right_pos) 
                                  if(hard)
                                    begin
                                      Red <= 4'b1000;  
                                      Green <= 4'b1111;  
                                      Blue <= 4'b1111;
                                    end
                                  else
                                    begin  
                                      Red <= 4'b1100;  
                                      Green <= 4'b1110;  
                                      Blue <= 4'b0000; 
                                    end 
                              // Display the ball
                              else if ( (Hcnt - ball_x_pos)*(Hcnt - ball_x_pos) + (Vcnt - ball_y_pos)*(Vcnt - ball_y_pos) <= (ball_r * ball_r)) 
                              if (hard)
                              begin
                                Red <= 4'b0111;  
                                Green <= 4'b0000;  
                                Blue <= 4'b0111;  
                              end
                              else 
                                begin  
                                  Red <= 4'b0110;  
                                  Green <= 4'b1101;  
                                  Blue <= 4'b1101;  
                                end  
                              // Display the block
                              else if((Hcnt - block_x_pos)*(Hcnt - block_x_pos)<= block*block && (Vcnt - block_y_pos)*(Vcnt - block_y_pos)<= block*block  )
                              begin
                                //hard mode    
                                if(hard)    
                                begin
                                  Red <= 4'b0000;  
                                  Green <= 4'b1110;  
                                  Blue <= 4'b1110;  
                                end
                              end
                              else 
                              begin  
                                  Red <= 4'b0000;  
                                  Green <= 4'b0000;  
                                  Blue <= 4'b0000;  
                              end
              end        
end

//------------------------position control-------
	always @ (posedge vs)  
   begin 
   if(!start||end_g==1)
      begin
        left_pos = 280;
        right_pos = 380;
        ball_y_pos = 390;
        ball_x_pos = 330;
        //hard mode	
        if(hard)    
          begin
            block_x_pos <= 100;
            block_y_pos <= 100;
          end
        //two players
        if(two)
        begin
          left_pos_2 = 280;
          right_pos_2 = 380;
        end  
      end
    else if(start)
      begin
		    // movement of the downside bar
            if (to_left && left_pos >= LEFT_BOUND) 
	        begin  
	        	 if(hard)
	        	 begin
	        	   left_pos <= left_pos - 2*bar_move_speed;  
                   right_pos <= right_pos - 2*bar_move_speed;
	        	 end
	        	 else
	        	 begin
		       	   left_pos <= left_pos - bar_move_speed;  
			       right_pos <= right_pos - bar_move_speed;
			     end  
             end  
            else if(to_right && right_pos <= RIGHT_BOUND)
            begin
              if(hard)
                 begin
                 left_pos <= left_pos + 2*bar_move_speed; 
                 right_pos <= right_pos + 2*bar_move_speed; 
                 end
              else
		         begin  		
			     left_pos <= left_pos + bar_move_speed; 
			     right_pos <= right_pos + bar_move_speed;  
                 end  
            end
            
            //movement of the upside bar
            if(two)
            begin
                        if (to_left_2 && left_pos_2 >= LEFT_BOUND) 
                        begin  
                             if(hard)
                             begin
                               left_pos_2 <= left_pos_2 - 3*bar_move_speed;  
                               right_pos_2 <= right_pos_2 - 3*bar_move_speed;
                             end
                             else
                             begin
                               left_pos_2 <= left_pos_2 - 2*bar_move_speed;  
                               right_pos_2 <= right_pos_2 - 2*bar_move_speed;
                             end  
                         end  
                        else if(to_right_2 && right_pos_2 <= RIGHT_BOUND)
                        begin
                          if(hard)
                             begin
                             left_pos_2 <= left_pos_2 + 3*bar_move_speed; 
                             right_pos_2 <= right_pos_2 + 3*bar_move_speed; 
                             end
                          else
                             begin          
                             left_pos_2 <= left_pos_2 + 2*bar_move_speed; 
                             right_pos_2 <= right_pos_2 + 2*bar_move_speed;  
                             end  
                        end
            end
            
		    //movement of the ball
		     if (v_speed == `UP) // go up 
			     ball_y_pos <= ball_y_pos - bar_move_speed;  
             else //go down
			     ball_y_pos <= ball_y_pos + bar_move_speed;  
		     if (h_speed == `RIGHT) // go right 
			     ball_x_pos <= ball_x_pos + bar_move_speed;  
             else //go down
			     ball_x_pos <= ball_x_pos - bar_move_speed;  
			
             //hard mode	
             if(hard)	
                begin
		       //movement of the block
		        if (v_speed_b == `UP) // go down 
                   block_y_pos <= block_y_pos - bar_move_speed;  
                else //go down
                   block_y_pos <= block_y_pos + bar_move_speed;  
                if (h_speed_b == `RIGHT) // go left 
                   block_x_pos <= block_x_pos + bar_move_speed;  
                else //go left
                   block_x_pos <= block_x_pos - bar_move_speed;
                 end	
        end 
     end



//------------ball directions control --------------------
//change directions when reach the edge or crush the bar
	always @ (negedge vs)  
   begin
        if(!two)
        begin
		    if (ball_y_pos <= UP_BOUND)   // Here, all the jugement should use >= or <= instead of ==
		    begin	
		      goal = 0;
			  v_speed <= 1;              // Because when the offset is more than 1, the axis may step over the line
			  lose_b <= 0;
		    end

		    //downside
		    else if (ball_y_pos >= (up_pos - ball_r) && ball_x_pos <= right_pos && ball_x_pos >= left_pos)  
		    begin
		      goal <= 1;
              v_speed <= 0;
              end_g_b <= 1'b0; 
            end  
            //downside
		    else if (ball_y_pos >= down_pos && ball_y_pos < (DOWN_BOUND - ball_r))
		    begin
		        // miss the ball
		    	//end game
			  goal <= 0;
			  end_g_b <= 1'b1;  
		   	  lose_b <= 1;
		    end
		    else if (ball_y_pos >= (DOWN_BOUND - ball_r + 1))
			   v_speed <= 0; 
            else  
              begin
                goal <=0;
                v_speed <= v_speed;  
                end_g_b <= 1'b0; 
              end
                  
            if (ball_x_pos <= LEFT_BOUND)  
                h_speed <= 1;  
            else if (ball_x_pos >= RIGHT_BOUND)  
                h_speed <= 0;  
            else  
                h_speed <= h_speed;  
       end 
       else//two mode
       begin
       // upside 
           if (ball_y_pos <= UP_BOUND)   // Here, all the jugement should use >= or <= instead of ==
              begin    
                    goal = 0;
                    v_speed <= 1;              // Because when the offset is more than 1, the axis may step over the line
                    lose_b <= 0;
              end
          else if (ball_y_pos<= (down_pos_2+ball_r) &&ball_y_pos >= (up_pos_2+10) && ball_x_pos <= right_pos_2 && ball_x_pos >= left_pos_2)   
                  begin    
                    goal <=1;
                    v_speed <= 1;            
                    lose_b <= 0;
                  end
          else if(ball_y_pos <= ( up_pos_2+10 - 1)&& (ball_x_pos >= right_pos_2+1 || ball_x_pos <= left_pos_2-1))
            begin
               // miss the ball
               //end game
               goal <= 0;
               end_g_b <= 1'b1;  
               lose_b <= 1;
            end
         //downside
         else if ( ball_y_pos >= (up_pos - ball_r) && ball_x_pos <= right_pos && ball_x_pos >= left_pos)  
                        begin
                          goal <= 1;
                          v_speed <= 0;
                          end_g_b <= 1'b0; 
                        end  
                        //downside
         else if ( ball_y_pos >= down_pos && ball_y_pos < (DOWN_BOUND - ball_r))
                        begin
                            // miss the ball
                            //end game
                          goal <= 0;
                          end_g_b <= 1'b1;  
                             lose_b <= 1;
                        end
         else if (ball_y_pos >= (DOWN_BOUND - ball_r + 1))
                           v_speed <= 0; 
         else  
                          begin
                            goal <=0;
                            v_speed <= v_speed;  
                            end_g_b <= 1'b0; 
                          end
                              
         if (ball_x_pos <= LEFT_BOUND)  
                            h_speed <= 1;  
         else if (ball_x_pos >= RIGHT_BOUND)  
                            h_speed <= 0;  
         else  
                            h_speed <= h_speed;  
       end
  end
  
//  //------------------block control-----------------
 
  //change directions block
always @ (negedge vs)  
begin
  if(hard)
  begin
       if(!two)
       begin
          if (block_y_pos <= UP_BOUND)   
            begin
              v_speed_b <= 1;   
              lose_k <= 0;
              end_g_k <= 1'b0;
            end           
          else if (block_y_pos >= (up_pos + 2) && block_x_pos <= right_pos  && block_x_pos >= left_pos) 
            begin  //touch the block
           v_speed_b <= 0;  
           end_g_k <= 1'b1;
           lose_k <= 1;
            end
          else if(block_y_pos >= DOWN_BOUND)
            v_speed_b <= 0;
          else  
            begin
             v_speed_b <= v_speed_b;  
             lose_k <= 0;
             end_g_k <= 1'b0;
            end
                
          if (block_x_pos <= LEFT_BOUND)  
           h_speed_b <= 1;  
        else if (block_x_pos >= RIGHT_BOUND)  
           h_speed_b <= 0;  
        else  
           h_speed_b <= h_speed_b;  
        
        end
      else //two mode
        begin
          // upside 
                   if (block_y_pos <= UP_BOUND)   // Here, all the jugement should use >= or <= instead of ==
                      begin    
                        v_speed_b <= 1;   
                        lose_k <= 0;
                        end_g_k <= 1'b0;
                      end
                  else if (block_y_pos<= (down_pos_2+block) &&block_y_pos >= (up_pos_2+10) && block_x_pos <= right_pos_2 && block_x_pos >= left_pos_2)   
                       begin    
                         v_speed_b <= 0;  
                         end_g_k <= 1'b1;
                         lose_k <= 1;
                       end
                  else if(block_y_pos >= (up_pos + 2) && block_x_pos <= right_pos  && block_x_pos >= left_pos)
                       begin
                         v_speed_b <= 0;  
                         end_g_k <= 1'b1;
                         lose_k <= 1;
                       end
                  else if(block_y_pos >= DOWN_BOUND)
                                  v_speed_b <= 0;
                  else  
                        begin
                          v_speed_b <= v_speed_b;  
                          lose_k <= 0;
                          end_g_k <= 1'b0;
                        end
                                      
                                if (block_x_pos <= LEFT_BOUND)  
                                 h_speed_b <= 1;  
                              else if (block_x_pos >= RIGHT_BOUND)  
                                 h_speed_b <= 0;  
                              else  
                                 h_speed_b <= h_speed_b;  
        end
  end
end 

endmodule