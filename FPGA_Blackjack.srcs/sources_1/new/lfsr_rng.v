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
    
    reg [31:0] lfsr;
    
    wire feedback = lfsr[31] ^ lfsr[16] ^ lfsr[17] ^ lfsr[0];
    
    always @(posedge clk) begin
        if (rst) 
            lfsr <= 32'hACEEEECA;
        else if (en) begin
            lfsr <= {lfsr[30:0], feedback};
        end
    end
    
    wire [3:0] raw_card = (lfsr[15:0] % 13) + 1;
    assign card_out = raw_card;
    
endmodule
