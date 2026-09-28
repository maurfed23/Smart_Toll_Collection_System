`timescale 1ns/1ps

module input_register (
    input  logic        clk,
    input  logic        rst,

    input  logic        transaction_valid,
    input  logic [7:0]  tag_id,
    input  logic [1:0]  vehicle_type,
    input  logic [11:0] balance,

    output logic        transaction_valid_reg,
    output logic [7:0]  tag_id_reg,
    output logic [1:0]  vehicle_type_reg,
    output logic [11:0] balance_reg
);

    always_ff @(posedge clk) begin

        if (rst) begin
            transaction_valid_reg <= 1'b0;
            tag_id_reg            <= 8'd0;
            vehicle_type_reg      <= 2'b00;
            balance_reg           <= 12'd0;
        end
        else begin

            // Register the transaction request
            transaction_valid_reg <= transaction_valid;

            // Capture transaction information
            if (transaction_valid) begin
                tag_id_reg       <= tag_id;
                vehicle_type_reg <= vehicle_type;
                balance_reg      <= balance;
            end

        end

    end

endmodule
