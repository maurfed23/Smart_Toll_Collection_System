`timescale 1ns/1ps
module toll_controller (
    input        clk,
    input        rst,

    input        transaction_valid,
    input        tag_valid,
    input        balance_sufficient,

    output reg   toll_register_enable,
    output reg   perform_deduction,

    output reg   transaction_done,
    output reg   transaction_accepted,

    output reg   error,
    output reg [1:0] error_code
);

reg [2:0] current_state;
reg [2:0] next_state;


/* State encoding */

parameter IDLE          = 3'd0;
parameter INPUT_CAPTURE = 3'd1;
parameter TAG_VALIDATE  = 3'd2;
parameter TOLL_CALC     = 3'd3;
parameter BALANCE_CHECK = 3'd4;
parameter DEDUCT        = 3'd5;
parameter DONE          = 3'd6;
parameter ERROR_STATE   = 3'd7;


/* State register */

always @(posedge clk) begin
    if (rst)
        current_state <= IDLE;
    else
        current_state <= next_state;
end


/* Next-state logic */

always @(*) begin

    next_state = current_state;

    case (current_state)

        IDLE: begin
            if (transaction_valid)
                next_state = INPUT_CAPTURE;
            else
                next_state = IDLE;
        end

        INPUT_CAPTURE: begin
            next_state = TAG_VALIDATE;
        end

        TAG_VALIDATE: begin
            if (tag_valid)
                next_state = TOLL_CALC;
            else
                next_state = ERROR_STATE;
        end

        TOLL_CALC: begin
            next_state = BALANCE_CHECK;
        end

        BALANCE_CHECK: begin
            if (balance_sufficient)
                next_state = DEDUCT;
            else
                next_state = ERROR_STATE;
        end

        DEDUCT: begin
            next_state = DONE;
        end

        DONE: begin
            next_state = IDLE;
        end

        ERROR_STATE: begin
            next_state = IDLE;
        end

        default: begin
            next_state = IDLE;
        end

    endcase

end


/* Output/control logic */

always @(*) begin

    toll_register_enable = 1'b0;
    perform_deduction    = 1'b0;

    transaction_done     = 1'b0;
    transaction_accepted = 1'b0;

    error                = 1'b0;
    error_code           = 2'b00;

    case (current_state)

        TOLL_CALC: begin
            toll_register_enable = 1'b1;
        end

        DEDUCT: begin
            perform_deduction = 1'b1;
        end

        DONE: begin
            transaction_done     = 1'b1;
            transaction_accepted = 1'b1;
            error_code           = 2'b00;
        end

        ERROR_STATE: begin
            transaction_done = 1'b1;
            error             = 1'b1;

            if (!tag_valid)
                error_code = 2'b01;   // Invalid tag
            else
                error_code = 2'b10;   // Insufficient balance
        end

        default: begin
            transaction_done     = 1'b0;
            transaction_accepted = 1'b0;
            error                = 1'b0;
            error_code           = 2'b00;
        end

    endcase

end

endmodule
