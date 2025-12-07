`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2025 08:57:04 AM
// Design Name: 
// Module Name: fsm_tb
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


module fsm_tb();

    reg clk;
    reg rst;
    reg button_start;
    reg button_hit;
    reg button_stand;
    reg [15:0] sw_bet;
    reg [4:0] dealer_score;
    reg [4:0] player_score;
    
    wire reset_hands;
    wire player_hit;
    wire dealer_hit;
    wire [15:0] money_out;
    wire rgb_r, rgb_g, rgb_b;

    fsm #(.DEALER_SPEED(5), .CARD_SPEED(5)) card_fsm_tb 
    (
    .clk(clk),
    .rst(rst),
    .button_start(button_start),
    .button_stand(button_stand),
    .button_hit(button_hit),
    .sw_bet(sw_bet),
    .dealer_score(dealer_score),
    .player_score(player_score),
    .reset_hands(reset_hands),
    .player_hit(player_hit),
    .dealer_hit(dealer_hit),
    .money_out(money_out),
    .rgb_r(rgb_r),
    .rgb_g(rgb_g),
    .rgb_b(rgb_b)
    );

    initial clk = 1;
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        button_stand = 0;
        button_hit = 0;
        button_start = 0;
        sw_bet = 0;
        dealer_score = 0;
        player_score = 0;
        #12 
        
        rst = 0;
        
        // Game start (betting phase)
        sw_bet = 10;
        button_start = 1;
        #10 
        button_start = 0;
        #600
        
        // Player wins (dealer can't hit anymore)
        player_score = 20;
        dealer_score = 17;
        button_stand = 1;
        #10
        button_stand = 0;
        #200
        
        // Bring game back to idle
        button_start = 1;
        #10
        button_start = 0;
        #10
        
        // Betting phase
        sw_bet = 10;
        button_start = 1;
        #10
        button_start = 0;
        #600
        
        // Player loses 
        player_score = 22;
        dealer_score = 21;
        #200
        
        // Back to idle
        button_start = 1;
        #10
        button_start = 0;
        #10
        
        // Betting phase
        sw_bet = 10;
        button_start = 1;
        #10
        button_start = 0;
        #600
        
        player_score = 10;
        dealer_score = 17;
        #100
        button_hit = 1;
        #10
        button_hit = 0;
        player_score = 20;
        #50
        button_stand = 1;
        #10
        button_stand = 0;
        #10
        
        // Betting phase
        sw_bet = 10;
        button_start = 1;
        #10
        button_start = 0;
        #600
        
        // Tie
        player_score = 21;
        dealer_score = 21;
        #100
        
        // Back to idle
        button_start = 1;
        #10
        button_start = 0;
        
        // Betting phase
        sw_bet = 10;
        button_start = 1;
        #10
        button_start = 0;
        #100
        
        player_score = 15;
        dealer_score = 10;
        #100
        
        button_stand = 1;
        #10
        button_stand = 0;
        #100
        $finish;
            
    end

endmodule
