`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2025 09:31:50 PM
// Design Name: 
// Module Name: top
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


module top (
    input                   sys_clk, sys_rst,
    input [15:0]            sw_bet,
    input                   button_start_unbounced,
    input                   button_hit_unbounced,
    input                   button_stand_unbounced,
    output [15:0]           LED,
    output [7:0]            anode,
    output [6:0]            seg,
    output                  rgb_r, rgb_g, rgb_b,
    output                  uart_txd_in
);

    wire reset = sys_rst;
    wire button_start, button_hit, button_stand;
    debouncer db1 (
    .clk(sys_clk),
    .rst(reset),
    .button_in(button_start_unbounced),
    .button_out(button_start_db)
    );
    
    debouncer db2 (
    .clk(sys_clk),
    .rst(reset),
    .button_in(button_hit_unbounced),
    .button_out(button_hit_db)
    );
    
    debouncer db3 (
    .clk(sys_clk),
    .rst(reset),
    .button_in(button_stand_unbounced),
    .button_out(button_stand_db)
    );    
    
    reg button_start_prev, button_hit_prev, button_stand_prev;
    wire button_start_pulse, button_hit_pulse, button_stand_pulse;
    
    always @(posedge sys_clk) begin
        if (reset) begin
            button_start_prev <= 0;
            button_hit_prev <= 0;
            button_stand_prev <= 0;
        end else begin
            button_start_prev <= button_start_db;
            button_hit_prev <= button_hit_db;
            button_stand_prev <= button_stand_db;
        end
    end 
    
    assign button_start_pulse = button_start_db & ~button_start_prev;
    assign button_hit_pulse = button_hit_db & ~button_hit_prev;
    assign button_stand_pulse = button_stand_db & ~button_stand_prev;
    
    wire [3:0] rng_card;
    lfsr_rng rng (
    .clk(sys_clk),
    .rst(reset),
    .en(1'b1),
    .card_out(rng_card)
    );
    
    wire reset_hands;
    wire player_hit, dealer_hit;
    wire [4:0] player_score, dealer_score;
    
    hand_logic player (
    .clk(sys_clk),
    .rst(reset_hands),
    .add_card_en(player_hit),
    .card_value_in(rng_card),
    .score(player_score)
    );
    
    hand_logic dealer (
    .clk(sys_clk),
    .rst(reset_hands),
    .add_card_en(dealer_hit),
    .card_value_in(rng_card),
    .score(dealer_score)
    );
    
    fsm blackjack_fsm (
    .clk(sys_clk),
    .rst(reset),
    .button_start(button_start_pulse),
    .button_hit(button_hit_pulse),
    .button_stand(button_stand_pulse),
    .sw_bet(sw_bet),
    .player_score(player_score),
    .dealer_score(dealer_score),
    .reset_hands(reset_hands),
    .player_hit(player_hit),
    .dealer_hit(dealer_hit),
    .money_out(LED),
    .rgb_r(rgb_r),
    .rgb_g(rgb_g),
    .rgb_b(rgb_b)
    );
    
    display_driver seven_seg (
    .clk(sys_clk),
    .rst(reset),
    .left_val(dealer_score),
    .right_val(player_score),
    .anode(anode),
    .seg(seg)
    );
    
    uart_card_log card_logger (
    .clk(sys_clk),
    .rst(reset),
    .player_hit(player_hit),
    .dealer_hit(dealer_hit),
    .card_value(rng_card),
    .tx_pin(uart_txd_in)
    );
    
endmodule
