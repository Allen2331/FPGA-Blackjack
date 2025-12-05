`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2025 09:53:33 PM
// Design Name: 
// Module Name: vga_core
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


module vga_core(
    input               sys_clk,
    input               rst,
    output [3:0]        red,
    output [3:0]        green,
    output [3:0]        blue,
    output              hsync,
    output              vsync
    );
    
    
    wire clk_25mhz;
    clk_wiz_0 clk_25mhz_div (
    .clk_in1(sys_clk),
    .reset(rst),
    .locked(),
    .clk_25mhz(clk_25mhz)
    );
    
    reg [9:0]           horizontal_counter;
    reg [9:0]           vertical_counter;
    
    always @(posedge clk_25mhz) begin
        if (horizontal_counter < 799) 
            horizontal_counter <= horizontal_counter + 1;
        else
            horizontal_counter <= 0;
    end
    
    always @(posedge clk_25mhz) begin
        if (horizontal_counter == 799) // Only starts counting once horizontal finishes counting 800
            begin
                if (vertical_counter < 525) 
                    vertical_counter <= vertical_counter + 1;
                else
                    vertical_counter <= 0;
            end
    end
    
    assign hsync = (horizontal_counter < 96) ? 1'b1 : 1'b0;
    assign vsync = (vertical_counter < 2) ? 1'b1 : 1'b0;
    
endmodule
