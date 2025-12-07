`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 05:12:47 PM
// Design Name: 
// Module Name: baud_rate_gen
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


module baud_rate_gen(
    input               clk_100mhz,
    input               rst,
    output reg          tx_en
    );
    
    localparam DIV = 868; // 100 MHz / 115200 ~ 868
    reg [9:0] counter = 0;
    
    always @(posedge clk_100mhz) begin
        if (rst) begin
            counter <= 0;
            tx_en <= 1;
        end else begin
            if (counter == DIV-1) begin
                counter <= 0;
                tx_en <= 1;
            end else begin
                counter <= counter + 1;
                tx_en <= 0;
            end
        end
    end
endmodule
