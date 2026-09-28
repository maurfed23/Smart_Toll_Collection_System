`timescale 1ns/1ps

module toll_controller (
    input  logic       clk,
    input  logic       rst,

    input  logic       transaction_valid,
    input  logic       tag_valid,
    input  logic       balance_sufficient,

    output logic       toll_register_enable,
    output logic       perform_deduction,

    output logic       transaction_done,
    output logic       transaction_accepted,
    output logic       error,
    output logic [1:0] error_code
);

    //==========================================================
    // ERROR CODES
    //==========================================================

    localparam logic [1:0] NO_ERROR             = 2'b00;
    localparam logic [1:0] INVALID_TAG          = 2'b01;
    localparam logic [1:0] INSUFFICIENT_BALANCE = 2'b10;


    //==========================================================
    // FSM STATES
    //==========================================================

    typedef enum logic [2:0] {

        IDLE          = 3'd0,
        INPUT_CAPTURE = 3'd1,
        TAG_VALIDATE  = 3'd2,
        TOLL_CALC     = 3'd3,
        BALANCE_CHECK = 3'd4,
        DEDUCT        = 3'd5,
        DONE          = 3'd6,
        ERROR_STATE   = 3'd7

    } state_t;


    state_t current_state;
    state_t next_state;


    //==========================================================
    // STATE REGISTER
    //==========================================================

    always_ff @(posedge clk) begin

        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;

    end


    //==========================================================
    // NEXT STATE LOGIC
    //==========================================================

    always_comb begin

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


    //==========================================================
    // FSM CONTROL OUTPUTS
    //==========================================================

    always_comb begin

        toll_register_enable = 1'b0;
        perform_deduction    = 1'b0;

        transaction_done     = 1'b0;
        transaction_accepted = 1'b0;

        error                = 1'b0;
        error_code           = NO_ERROR;


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

            end


            ERROR_STATE: begin

                transaction_done = 1'b1;
                error            = 1'b1;

                if (!tag_valid)
                    error_code = INVALID_TAG;
                else
                    error_code = INSUFFICIENT_BALANCE;

            end


            default: begin

                // No control action.

            end

        endcase

    end

endmodule
