`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2025 08:47:37 AM
// Design Name: 
// Module Name: hand_logic_tb
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


module hand_logic_tb();

    reg clk;
    reg rst;
    reg add_card_en;
    reg [3:0] card_value_in;
    wire [4:0] score;
    
    hand_logic hand_logic_tb (
    .clk(clk),
    .rst(rst),
    .add_card_en(add_card_en),
    .card_value_in(card_value_in),
    .score(score)
    );
    
    initial clk = 1;
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        add_card_en = 0;
        card_value_in = 2;
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 1;
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 10;
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 5;
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 11;   
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 12;
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 13;     
        #10
        rst = 0;
        add_card_en = 1;
        card_value_in = 0;     
        $finish;   
    end

endmodule
