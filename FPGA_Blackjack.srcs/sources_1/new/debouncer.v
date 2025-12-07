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
    reg button_sync0, button_sync1;
    
    always @(posedge clk) begin
        if (rst) begin
            button_sync0 <= 0;
            button_sync1 <= 0;
        end else begin
            button_sync0 <= button_in;
            button_sync1 <= button_sync0;
        end
    end
    
    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            button_out <= 0;
        end else begin
            if (button_sync1 != button_out) begin
                counter <= counter + 1;
                if (counter <= 22'd2500000) begin
                    button_out <= button_sync1;
                    counter <= 0;
                end else begin
                counter <= 0;
                end
            end
        end
    end
endmodule
