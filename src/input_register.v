module input_register (
    input        clk,
    input        rst,
    input        transaction_valid,
    input  [7:0]  tag_id,
    input  [1:0]  vehicle_type,
    input  [11:0] balance,

    output reg        transaction_valid_reg,
    output reg [7:0]  tag_id_reg,
    output reg [1:0]  vehicle_type_reg,
    output reg [11:0] balance_reg
);

always @(posedge clk) begin
    if (rst) begin
        transaction_valid_reg <= 1'b0;
        tag_id_reg            <= 8'd0;
        vehicle_type_reg      <= 2'd0;
        balance_reg           <= 12'd0;
    end
    else begin
        transaction_valid_reg <= transaction_valid;

        if (transaction_valid) begin
            tag_id_reg       <= tag_id;
            vehicle_type_reg <= vehicle_type;
            balance_reg      <= balance;
        end
    end
end

endmodule
