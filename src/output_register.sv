`timescale 1ns/1ps

module output_register (
    input  logic       clk,
    input  logic       rst,

    input  logic       transaction_done_in,
    input  logic       transaction_accepted_in,
    input  logic       error_in,
    input  logic [1:0] error_code_in,

    output logic       transaction_done,
    output logic       transaction_accepted,
    output logic       error,
    output logic [1:0] error_code
);

    always_ff @(posedge clk) begin

        if (rst) begin

            transaction_done     <= 1'b0;
            transaction_accepted <= 1'b0;
            error                <= 1'b0;
            error_code           <= 2'b00;

        end
        else begin

            transaction_done     <= transaction_done_in;
            transaction_accepted <= transaction_accepted_in;
            error                <= error_in;
            error_code           <= error_code_in;

        end

    end

endmodule
