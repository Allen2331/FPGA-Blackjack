`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 01:28:32 PM
// Design Name: 
// Module Name: hand_logic
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


module hand_logic(
    input               clk,
    input               rst,
    input               add_card_en,
    input [3:0]         card_value_in,
    output reg [4:0]    score
    );
    
    reg [3:0] card_val;
    reg ace;
    
    always @(*) begin
        if (card_value_in == 0 || card_value_in > 13) begin
            card_val = 1; 
            ace = 1;
        end else if (card_value_in >= 10) begin
            card_val = 10; 
            ace = 0;
        end else if (card_value_in == 1) begin
            card_val = 1;
            ace = 0;
        end else begin
            card_val = card_value_in;
            ace = 0;
        end
    end
    
    reg [2:0] ace_count;
    always @(posedge clk) begin
        if (rst) begin
            score <= 0;
            ace_count <= 0;
        end else if (add_card_en) begin
            if (ace) begin
                score <= score + 11;
                ace_count <= ace_count + 1;
            end else begin
                score <= score + card_val;
            end
        end else begin
            if (score > 21 && ace_count > 0) begin
                score <= score - 10;
                ace_count <= ace_count -1;
            end
        end
    end
    
endmodule
