`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 01:32:25 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input           clk,
    input           rst,
    input           button_in,
    output reg      button_out
    );
    
    reg [21:0] counter;
    
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            button_out <= 0;
        end else begin
            if (button_in && counter == 0) begin
                button_out <= 1;
                counter <= 22'd2500000;
            end else begin
                button_out <= 0;
                if (counter > 0)
                    counter <= counter - 1;
            end
        end
    end
    
endmodule
