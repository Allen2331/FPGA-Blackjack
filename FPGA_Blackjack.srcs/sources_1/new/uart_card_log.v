`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 05:27:36 PM
// Design Name: 
// Module Name: uart_card_log
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


module uart_card_log(
    input               clk,
    input               rst,
    input               player_hit,
    input               dealer_hit,
    input [3:0]         card_value,
    output              tx_pin
    );
    
    reg                 [3:0] saved_card;
    reg                 is_dealer;
    reg                 trigger_print;
    
    reg player_prev, dealer_prev;
    always @(posedge clk) begin
        if (rst) begin
            player_prev <= 0;
            dealer_prev <= 0;
            trigger_print <= 0;
        end else begin
            player_prev <= player_hit;
            dealer_prev <= dealer_hit;
            
            if (player_hit && !player_prev) begin
                saved_card <= card_value;
                is_dealer <= 0;
                trigger_print <= 1;
            end else if (dealer_hit && !dealer_prev) begin
                saved_card <= card_value;
                is_dealer <= 1;
                trigger_print <= 1;
            end else begin
                trigger_print <= 0;
            end
        end
    end
    
    reg [3:0]           saved_print;
    reg [7:0]           send_data;
    reg                 send_pulse;
    wire                tx_busy;
    
    wire uart_tx_en;
    baud_rate_gen baud_rate_unit (
    .clk_100mhz(clk),
    .rst(rst),
    .tx_en(uart_tx_en)
    );
    
    uart_tx transmitter_log (
    .clk_100m(clk),
    .din(send_data),
    .wr_en(send_pulse),
    .clken(uart_tx_en),
    .tx(tx_pin),
    .tx_busy(tx_busy)
    );
    
    localparam IDLE = 0;
    localparam DEALER_PLAYER = 1;
    localparam COLON = 2;
    localparam VALUE = 3;
    localparam VALUE_10 = 4;
    localparam CARRIAGE = 5;
    localparam NEWLINE = 6;
    
    reg [2:0] state; 
    
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            send_pulse <= 0;
    end else begin
        send_pulse <= 0;
        case (state) 
            IDLE: begin
                if (trigger_print) begin
                    state <= COLON;
                    send_data <= is_dealer ? "D" : "P";
                    send_pulse <= 1;
                end
            end
            
            COLON: begin
                if (!tx_busy && !send_pulse) begin
                    state <= VALUE;
                    send_data <= ":";
                    send_pulse <= 1;
                end
            end
            
            VALUE: begin
                if (!tx_busy && !send_pulse) begin
                    if (saved_card == 1) begin
                        send_data <= "A";
                    end else if (saved_card == 11) begin
                        send_data <= "J";
                    end else if (saved_card == 12) begin
                        send_data <= "Q";
                    end else if (saved_card == 13) begin
                        send_data <= "K";
                    end else if (saved_card == 10) begin
                        send_data <= "1";
                    end else begin
                        send_data <= saved_card + 48;
                        send_pulse <= 1;
                        if (saved_card == 10) begin
                            state <= VALUE_10;
                        end else begin
                            state <= CARRIAGE;
                        end
                    end
                end
            end
            
            VALUE_10: begin
                if (!tx_busy && !send_pulse) begin
                    send_data <= "0";
                    state <= CARRAIGE;
                    send_pulse <= 1;
                    end
                end                
            end
            
            CARRIAGE: begin
                if (!tx_busy && !send_pulse) begin
                    send_data <= 13;
                    state <= NEWLINE;
                    send_pulse <= 1;
                end               
            end
            
            NEWLINE: begin
                if (!tx_busy && !send_pulse) begin
                    send_data <= 10;
                    state <= IDLE;
                    send_pulse <= 1;
                end               
            end            
        endcase
    end
end
endmodule
