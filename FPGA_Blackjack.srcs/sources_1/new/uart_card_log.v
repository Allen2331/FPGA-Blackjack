`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// UART logger for Blackjack game
// Prints:
//
//   BET:25
//   P:K
//   P:8
//   D:10
//
// Triggered on:
//   - Start button  → prints bet
//   - Player hit    → prints player card
//   - Dealer hit    → prints dealer card
//
//////////////////////////////////////////////////////////////////////////////////

module uart_card_log(
    input               clk,
    input               rst,
    input               player_hit,
    input               dealer_hit,
    input  [3:0]        card_value,
    output              tx_pin,
    input               button_start,
    input  [15:0]       player_bet
);

    //---------------------------------------------------------
    // REGISTERS FOR BET PRINTING
    //---------------------------------------------------------
    reg [15:0] saved_bet;
    reg        trigger_bet_print;
    reg        start_prev;

    always @(posedge clk) begin
        if (rst) begin
            start_prev         <= 0;
            trigger_bet_print  <= 0;
            saved_bet          <= 0;
        end
        else begin
            start_prev <= button_start;

            // Detect rising edge of start button
            if (button_start && !start_prev) begin
                saved_bet         <= player_bet;
                trigger_bet_print <= 1;
            end else begin
                trigger_bet_print <= 0;
            end
        end
    end

    //---------------------------------------------------------
    // REGISTERS FOR CARD PRINTING (PLAYER/DEALER)
    //---------------------------------------------------------
    reg [3:0] saved_card;
    reg       is_dealer;
    reg       trigger_print;

    reg player_prev, dealer_prev;

    always @(posedge clk) begin
        if (rst) begin
            player_prev   <= 0;
            dealer_prev   <= 0;
            trigger_print <= 0;
        end else begin
            player_prev <= player_hit;
            dealer_prev <= dealer_hit;

            if (player_hit && !player_prev) begin
                saved_card    <= card_value;
                is_dealer     <= 0;
                trigger_print <= 1;
            end
            else if (dealer_hit && !dealer_prev) begin
                saved_card    <= card_value;
                is_dealer     <= 1;
                trigger_print <= 1;
            end
            else begin
                trigger_print <= 0;
            end
        end
    end

    //---------------------------------------------------------
    // UART TX SETUP
    //---------------------------------------------------------
    reg  [7:0] send_data;
    reg        send_pulse;
    wire       tx_busy;

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

    //---------------------------------------------------------
    // STATES
    //---------------------------------------------------------
    localparam IDLE        = 4'd0;
    localparam COLON       = 4'd1;
    localparam VALUE       = 4'd2;
    localparam VALUE_10    = 4'd3;
    localparam CARRIAGE    = 4'd4;
    localparam NEWLINE     = 4'd5;

    // BET STATES
    localparam BET_B       = 4'd6;
    localparam BET_E       = 4'd7;
    localparam BET_T       = 4'd8;
    localparam BET_COLON   = 4'd9;
    localparam BET_DIGIT_1 = 4'd10;
    localparam BET_DIGIT_2 = 4'd11;
    localparam BET_CR      = 4'd12;
    localparam BET_NL      = 4'd13;

    reg [3:0] state;

    //---------------------------------------------------------
    // UART PRINTING FSM
    //---------------------------------------------------------
    always @(posedge clk) begin
        if (rst) begin
            state      <= IDLE;
            send_pulse <= 0;
        end
        else begin
            send_pulse <= 0;

            case (state)

            //-------------------------------------------------
            // IDLE - Decide if printing card or bet
            //-------------------------------------------------
            IDLE: begin
                if (trigger_bet_print) begin
                    send_data  <= "B";
                    send_pulse <= 1;
                    state      <= BET_E;
                end
                else if (trigger_print) begin
                    send_data  <= (is_dealer ? "D" : "P");
                    send_pulse <= 1;
                    state      <= COLON;
                end
            end

            //-------------------------------------------------
            // CARD LOG PRINTING
            //-------------------------------------------------
            COLON: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= ":";
                    send_pulse <= 1;
                    state      <= VALUE;
                end
            end

            VALUE: begin
                if (!tx_busy && !send_pulse) begin
                    send_pulse <= 1;

                    case (saved_card)
                        1:  begin send_data <= "A"; state <= CARRIAGE; end
                        11: begin send_data <= "J"; state <= CARRIAGE; end
                        12: begin send_data <= "Q"; state <= CARRIAGE; end
                        13: begin send_data <= "K"; state <= CARRIAGE; end
                        10: begin send_data <= "1"; state <= VALUE_10; end
                        default: begin
                            send_data <= saved_card + 8'd48;
                            state     <= CARRIAGE;
                        end
                    endcase
                end
            end

            VALUE_10: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= "0";
                    send_pulse <= 1;
                    state      <= CARRIAGE;
                end
            end

            CARRIAGE: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= 8'd13;
                    send_pulse <= 1;
                    state      <= NEWLINE;
                end
            end

            NEWLINE: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= 8'd10;
                    send_pulse <= 1;
                    state      <= IDLE;
                end
            end

            //-------------------------------------------------
            // BET PRINTING STATES
            //-------------------------------------------------
            BET_E: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= "E";
                    send_pulse <= 1;
                    state      <= BET_T;
                end
            end

            BET_T: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= "T";
                    send_pulse <= 1;
                    state      <= BET_COLON;
                end
            end

            BET_COLON: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= ":";
                    send_pulse <= 1;
                    state      <= BET_DIGIT_1;
                end
            end

            BET_DIGIT_1: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= (saved_bet / 10) + 8'd48;
                    send_pulse <= 1;
                    state      <= BET_DIGIT_2;
                end
            end

            BET_DIGIT_2: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= (saved_bet % 10) + 8'd48;
                    send_pulse <= 1;
                    state      <= BET_CR;
                end
            end

            BET_CR: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= 8'd13;
                    send_pulse <= 1;
                    state      <= BET_NL;
                end
            end

            BET_NL: begin
                if (!tx_busy && !send_pulse) begin
                    send_data  <= 8'd10;
                    send_pulse <= 1;
                    state      <= IDLE;
                end
            end

            endcase
        end
    end

endmodule

