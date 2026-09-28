`timescale 1ns/1ps

module smart_toll_top (

    input  logic        clk,
    input  logic        rst,

    input  logic        transaction_valid,
    input  logic [7:0]  tag_id,
    input  logic [1:0]  vehicle_type,
    input  logic [11:0] balance,

    output logic [11:0] toll_amount,
    output logic [11:0] remaining_balance,

    output logic        transaction_done,
    output logic        transaction_accepted,

    output logic        error,
    output logic [1:0]  error_code
);


    //==========================================================
    // REGISTERED INPUTS
    //==========================================================

    logic        transaction_valid_reg;
    logic [7:0]  tag_id_reg;
    logic [1:0]  vehicle_type_reg;
    logic [11:0] balance_reg;


    //==========================================================
    // DATAPATH SIGNALS
    //==========================================================

    logic        tag_valid;

    logic [11:0] calculated_toll;

    logic        balance_sufficient;


    //==========================================================
    // CONTROLLER SIGNALS
    //==========================================================

    logic toll_register_enable;
    logic perform_deduction;

    logic controller_done;
    logic controller_accepted;
    logic controller_error;
    logic [1:0] controller_error_code;


    //==========================================================
    // INPUT REGISTER
    //==========================================================

    input_register u_input_register (

        .clk                   (clk),
        .rst                   (rst),

        .transaction_valid     (transaction_valid),
        .tag_id                (tag_id),
        .vehicle_type          (vehicle_type),
        .balance               (balance),

        .transaction_valid_reg (transaction_valid_reg),
        .tag_id_reg            (tag_id_reg),
        .vehicle_type_reg      (vehicle_type_reg),
        .balance_reg           (balance_reg)

    );


    //==========================================================
    // TAG VALIDATOR
    //==========================================================

    tag_validator u_tag_validator (

        .tag_id    (tag_id_reg),
        .tag_valid (tag_valid)

    );


    //==========================================================
    // TOLL CALCULATOR
    //==========================================================

    toll_calculator u_toll_calculator (

        .vehicle_type (vehicle_type_reg),
        .toll_value   (calculated_toll)

    );


    //==========================================================
    // TOLL AMOUNT REGISTER
    //==========================================================

    always_ff @(posedge clk) begin

        if (rst) begin

            toll_amount <= 12'd0;

        end
        else if (toll_register_enable) begin

            toll_amount <= calculated_toll;

        end

    end


    //==========================================================
    // BALANCE COMPARATOR
    //==========================================================

    always_comb begin

        if (balance_reg >= toll_amount)
            balance_sufficient = 1'b1;
        else
            balance_sufficient = 1'b0;

    end


    //==========================================================
    // TOLL CONTROLLER
    //==========================================================

    toll_controller u_toll_controller (

        .clk                    (clk),
        .rst                    (rst),

        .transaction_valid      (transaction_valid_reg),
        .tag_valid              (tag_valid),
        .balance_sufficient     (balance_sufficient),

        .toll_register_enable   (toll_register_enable),
        .perform_deduction      (perform_deduction),

        .transaction_done       (controller_done),
        .transaction_accepted   (controller_accepted),
        .error                   (controller_error),
        .error_code              (controller_error_code)

    );


    //==========================================================
    // TRANSACTION PROCESSOR
    //==========================================================

    transaction_processor u_transaction_processor (

        .clk                (clk),
        .rst                (rst),

        .perform_deduction  (perform_deduction),

        .balance            (balance_reg),
        .toll_amount        (toll_amount),

        .remaining_balance  (remaining_balance)

    );


    //==========================================================
    // OUTPUT REGISTER
    //==========================================================

    output_register u_output_register (

        .clk                     (clk),
        .rst                     (rst),

        .transaction_done_in     (controller_done),
        .transaction_accepted_in (controller_accepted),
        .error_in                (controller_error),
        .error_code_in           (controller_error_code),

        .transaction_done        (transaction_done),
        .transaction_accepted    (transaction_accepted),
        .error                   (error),
        .error_code              (error_code)

    );


endmodule
