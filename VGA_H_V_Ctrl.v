`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/12/16 16:05:45
// Design Name: 
// Module Name: VGA_H_V_Ctrl
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


module VGA_H_V_Ctrl(
    input clk,
    output reg [9:0] Hcnt,
    output reg [9:0] Vcnt,
    output reg hs,
    output reg vs
    );
    
    //parameter definition
        parameter PAL = 640;        //Pixels/Active Line (pixels) 
        parameter LAF = 480;        //Lines/Active Frame (lines)
        parameter PLD = 800;        //Pixel/Line Divider(Whole Line)
        parameter LFD = 521;        //Line/Frame Divider(Whole Frame)
        parameter HPW = 96;            //Horizontal synchro Sync Pulse Width (pixels)
        parameter HFP = 16;            //Horizontal synchro Front Porch (pixels)
        parameter VPW = 2;                //Verical synchro Sync Pulse Width (lines)
        parameter VFP = 10;            //Verical synchro Front Porch (lines)
/*generate the hs && vs timing*/
        always@(posedge(clk)) 
        begin
            /*conditions of reseting Hcnter && Vcnter*/
            if( Hcnt == PLD-1 ) //have reached the edge of one line
            begin
                Hcnt <= 0; //reset the horizontal counter
                if( Vcnt == LFD-1 ) //only when horizontal pointer reach the edge can the vertical counter ++
                    Vcnt <=0;
                else
                    Vcnt <= Vcnt + 1;
            end
            else
                Hcnt <= Hcnt + 1;
            
            /*generate hs timing*/
            if( Hcnt == PAL - 1 + HFP)
                hs <= 1'b0;
            else if( Hcnt == PAL - 1 + HFP + HPW )
                hs <= 1'b1;
            
            /*generate vs timing*/        
            if( Vcnt == LAF - 1 + VFP ) 
                vs <= 1'b0;
            else if( Vcnt == LAF - 1 + VFP + VPW )
                vs <= 1'b1;                    
        end    
    
endmodule
