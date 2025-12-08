`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2025 02:00:57 PM
// Design Name: 
// Module Name: top_tb
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


module top_tb();
    
    reg sys_clk;
    reg sys_rst;
    reg [15:0] sw_bet;
    reg button_start_unbounced;
    reg button_hit_unbounced;
    reg button_stand_unbounced;
    wire [15:0] LED;
    wire [7:0] anode;
    wire [6:0] seg;
    wire rgb_r;
    wire rgb_g;
    wire rgb_b;
    wire uart_txd_in;

    top top_unit_tb (
    .sys_clk(sys_clk),
    .sys_rst(sys_rst),
    .sw_bet(sw_bet),
    .button_start_unbounced(button_start_unbounced),
    .button_hit_unbounced(button_hit_unbounced),
    .button_stand_unbounced(button_stand_unbounced),
    .LED(LED),
    .anode(anode),
    .seg(seg),
    .rgb_r(rgb_r),
    .rgb_b(rgb_b),
    .rgb_g(rgb_g),
    .uart_txd_in(uart_txd_in)
    );

    initial sys_clk = 0;
    always #5 sys_clk = ~sys_clk;

    integer i;

    initial begin
    sys_rst = 1;
    sw_bet = 0;
    button_start_unbounced = 0;
    button_hit_unbounced = 0;
    button_stand_unbounced = 0;
    #100
    
    sys_rst = 0;
    sw_bet = 50;
    #100
    
    for (i = 0; i < 16; i = i + 1) begin
        
        // --- Start Button Sequence ---
        button_start_unbounced = 1;
        #2000;
        button_start_unbounced = 0;
        #2000;
        
        // --- Hit Button Sequence ---
        button_hit_unbounced = 1;
        #2000;
        button_hit_unbounced = 0;
        #1000;
        
        // --- Stand Button Sequence ---
        button_stand_unbounced = 1;
        #2000;
        button_stand_unbounced = 0;
        #2000;
    end
    $finish;
    
    end
endmodule
