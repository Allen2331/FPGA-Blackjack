`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 01:49:08 PM
// Design Name: 
// Module Name: fsm
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


module fsm(
    input               clk,
    input               rst,
    input               button_start,
    input               button_hit,
    input               button_stand,
    input [15:0]        sw_bet,
    input [4:0]         player_score,
    input [4:0]         dealer_score,
    
    output reg          reset_hands,
    output reg          player_hit,
    output reg          dealer_hit,
    output reg [15:0]   money_out,
    output reg          rgb_r, rgb_g, rgb_b
    );
    
    reg [2:0]           state;
    reg [15:0]          current_bet;
    reg [3:0]           deal_counter;
    reg [25:0]          delay;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
        state <= 3'b000;
        money_out <= 16'd100;
        reset_hands <= 1;
        player_hit <= 0;
        dealer_hit <= 0;
        rgb_r <= 0;
        rgb_g <= 0;
        rgb_b <= 0;
    end else begin
        reset_hands <= 0;
        player_hit <= 0;
        dealer_hit <= 0;
        
        case(state)
            3'b000: begin // Start mode
                rgb_r <= 0; 
                rgb_g <= 0;
                rgb_b <= 0;
                reset_hands <= 1;
                if (button_start) begin
                    if (money_out == 0) money_out <= 16'd100;
                    if (sw_bet > 0 && sw_bet <= money_out) begin
                        current_bet <= sw_bet;
                        state <= 3'b001;
                        deal_counter <= 0;
                        reset_hands <= 0;
                    end
                end
            end
            
            3'b001: begin // Initial bet
                deal_counter <= deal_counter + 1;
                if (deal_counter == 1) begin
                    player_hit <= 1;
                end else if (deal_counter == 5) begin
                    dealer_hit <= 1; 
                end else if (deal_counter == 10) begin 
                    player_hit <= 1;
                end else if (deal_counter == 15) begin
                    dealer_hit <= 1;
                    state <= 3'b010;
                end
            end
            
            3'b010: begin // Player turn
                rgb_r <= 1; rgb_g <= 0; rgb_b <= 0;
                if (player_score > 21) begin
                    state <= 3'b100;
                end else if (button_hit) begin
                    player_hit <= 1;
                end else if (button_stand) begin
                    state <= 3'b011;
                    delay <= 0;
                end
            end 
            
            3'b011: begin // Dealer turn
                rgb_r <= 1; rgb_g <= 0; rgb_b <= 1;
                if (dealer_score < 17) begin
                    if (delay < 26'd25000000) begin
                        delay <= delay + 1;
                    end else begin
                        dealer_hit <= 1;
                        delay <= 0;
                    end 
                    end else begin
                    state <= 3'd100;
                    end
                end
                
            3'b100: begin // Win/Lose stage
                if (player_score > 21) begin
                    rgb_r <= 1; rgb_g <= 0; rgb_b <= 0;
                    if (button_start) begin
                        money_out <= money_out - current_bet;
                        state <= 3'b000;
                    end
                end else if (dealer_score > 21) begin
                    rgb_r <= 0; rgb_g <= 1; rgb_b <= 0;
                    if (button_start) begin
                        money_out <= money_out + current_bet;
                        state <= 3'b000;
                    end
                end else if (player_score > dealer_score) begin
                    rgb_r <= 0; rgb_g <= 1; rgb_b <= 0;
                    if (button_start) begin
                        money_out <= money_out + current_bet;
                        state <= 3'b000;                    
                    end    
                end else if (player_score < dealer_score) begin
                    rgb_r <= 1; rgb_g <= 0; rgb_b <= 0;
                    if (button_start) begin
                        money_out <= money_out - current_bet;
                        state <= 3'b000;                
                    end
                end else begin
                rgb_r <= 0; rgb_g <= 0; rgb_b <= 1;
                if (button_start) begin
                    state <= 3'b000;
                    end
                end
            end
        endcase
        end
    end
endmodule
