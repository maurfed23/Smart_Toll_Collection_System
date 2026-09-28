`timescale 1ns/1ps

module transaction_processor (
    input  logic        clk,
    input  logic        rst,

    input  logic        perform_deduction,

    input  logic [11:0] balance,
    input  logic [11:0] toll_amount,

    output logic [11:0] remaining_balance
);

    always_ff @(posedge clk) begin

        if (rst) begin

            remaining_balance <= 12'd0;

        end
        else if (perform_deduction) begin

            remaining_balance <= balance - toll_amount;

        end

    end

endmodule
