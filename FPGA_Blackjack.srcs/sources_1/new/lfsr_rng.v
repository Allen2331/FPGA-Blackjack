`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 01:30:10 PM
// Design Name: 
// Module Name: lfsr_rng
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


module lfsr_rng(
    input           clk,
    input           rst,
    input           en,
    output [3:0]    card_out
    );
    
    reg [15:0] lfsr;
    
    always @(posedge clk) begin
        if (rst) 
            lfsr <= 16'hACEE;
        else if (en) begin
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        end
    end
    
    assign card_out = lfsr[3:0];
    
endmodule
