`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2025 02:11:25 PM
// Design Name: 
// Module Name: display_driver
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


module display_driver(
    input               clk,
    input               rst,
    input [4:0]         left_val,
    input [4:0]         right_val,
    output reg [7:0]    anode,
    output reg [6:0]    seg
    );
    
    reg [16:0] refresh_cnt;
    wire tick = (refresh_cnt == 17'd100000);
    
    always @(posedge clk) begin 
        if(rst || tick) refresh_cnt <= 0;
        else refresh_cnt <= refresh_cnt + 1;
    end

    reg [1:0] digit_select;
    always @(posedge clk) begin
        if(rst) digit_select <= 0;
        else if(tick) digit_select <= digit_select + 1;
    end

    reg [3:0] hex_to_show;
    
    wire [3:0] l_tens = (left_val >= 20) ? 2 : (left_val >= 10) ? 1 : 0;
    wire [3:0] l_ones = left_val % 10;
    wire [3:0] r_tens = (right_val >= 20) ? 2 : (right_val >= 10) ? 1 : 0;
    wire [3:0] r_ones = right_val % 10;

    always @(*) begin
        anode = 8'hFF; // All off by default
        case (digit_select)
            2'd0: begin 
                anode = 8'b11111110; 
                hex_to_show = r_ones;
            end // Rightmost
            2'd1: begin 
                anode = 8'b11111101; 
                hex_to_show = r_tens; 
            end
            2'd2: begin 
                anode = 8'b10111111; 
                hex_to_show = l_ones; 
            end 
            2'd3: begin 
                anode = 8'b01111111; 
                hex_to_show = l_tens; 
            end // Leftmost active
        endcase
    end

    // Segment Decoder
    always @(*) begin
        case(hex_to_show)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            default: seg = 7'b1111111;
        endcase
    end
endmodule
