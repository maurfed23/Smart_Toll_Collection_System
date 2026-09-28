module transaction_processor (
    input         clk,
    input         rst,
    input         perform_deduction,

    input  [11:0] balance,
    input  [11:0] toll_amount,

    output reg [11:0] remaining_balance
);

always @(posedge clk) begin

    if (rst) begin
        remaining_balance <= 12'd0;
    end

    else if (perform_deduction) begin
        remaining_balance <= balance - toll_amount;
    end

end

endmodule
