`timescale 1ns/1ps

module smart_toll_top (
    input        clk,
    input        rst,

    input        transaction_valid,
    input  [7:0] tag_id,
    input  [1:0] vehicle_type,
    input  [11:0] balance,

    output reg [11:0] toll_amount,
    output [11:0] remaining_balance,

    output       transaction_done,
    output       transaction_accepted,

    output       error,
    output [1:0] error_code
);


/*--------------------------------------------------
    Internal signals
--------------------------------------------------*/

wire        transaction_valid_reg;
wire [7:0]  tag_id_reg;
wire [1:0]  vehicle_type_reg;
wire [11:0] balance_reg;

wire        tag_valid;

wire [11:0] calculated_toll;

wire        balance_sufficient;

wire        toll_register_enable;
wire        perform_deduction;

wire        controller_done;
wire        controller_accepted;
wire        controller_error;
wire [1:0]  controller_error_code;


/*--------------------------------------------------
    Input Register
--------------------------------------------------*/

input_register U_INPUT_REGISTER (

    .clk(clk),
    .rst(rst),

    .transaction_valid(transaction_valid),
    .tag_id(tag_id),
    .vehicle_type(vehicle_type),
    .balance(balance),

    .transaction_valid_reg(transaction_valid_reg),
    .tag_id_reg(tag_id_reg),
    .vehicle_type_reg(vehicle_type_reg),
    .balance_reg(balance_reg)

);


/*--------------------------------------------------
    Tag Validator
--------------------------------------------------*/

tag_validator U_TAG_VALIDATOR (

    .tag_id(tag_id_reg),

    .tag_valid(tag_valid)

);


/*--------------------------------------------------
    Toll Calculator
--------------------------------------------------*/

toll_calculator U_TOLL_CALCULATOR (

    .vehicle_type(vehicle_type_reg),

    .calculated_toll(calculated_toll)

);


/*--------------------------------------------------
    Toll Amount Register
--------------------------------------------------*/

always @(posedge clk) begin

    if (rst)
        toll_amount <= 12'd0;

    else if (toll_register_enable)
        toll_amount <= calculated_toll;

end


/*--------------------------------------------------
    Balance Comparator
--------------------------------------------------*/

assign balance_sufficient =
       (balance_reg >= toll_amount);


/*--------------------------------------------------
    Toll Controller
--------------------------------------------------*/

toll_controller U_TOLL_CONTROLLER (

    .clk(clk),
    .rst(rst),

    .transaction_valid(transaction_valid_reg),
    .tag_valid(tag_valid),
    .balance_sufficient(balance_sufficient),

    .toll_register_enable(toll_register_enable),
    .perform_deduction(perform_deduction),

    .transaction_done(controller_done),
    .transaction_accepted(controller_accepted),

    .error(controller_error),
    .error_code(controller_error_code)

);


/*--------------------------------------------------
    Transaction Processor
--------------------------------------------------*/

transaction_processor U_TRANSACTION_PROCESSOR (

    .clk(clk),
    .rst(rst),

    .perform_deduction(perform_deduction),

    .balance(balance_reg),
    .toll_amount(toll_amount),

    .remaining_balance(remaining_balance)

);


/*--------------------------------------------------
    Output Register
--------------------------------------------------*/

output_register U_OUTPUT_REGISTER (

    .clk(clk),
    .rst(rst),

    .transaction_done_in(controller_done),
    .transaction_accepted_in(controller_accepted),
    .error_in(controller_error),
    .error_code_in(controller_error_code),

    .transaction_done(transaction_done),
    .transaction_accepted(transaction_accepted),
    .error(error),
    .error_code(error_code)

);

endmodule
