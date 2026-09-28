`timescale 1ns/1ps

module output_register (
    input        clk,
    input        rst,

    input        transaction_done_in,
    input        transaction_accepted_in,
    input        error_in,
    input  [1:0] error_code_in,

    output reg   transaction_done,
    output reg   transaction_accepted,
    output reg   error,
    output reg [1:0] error_code
);

always @(posedge clk) begin

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
