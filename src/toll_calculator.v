module toll_calculator (
    input  [1:0]  vehicle_type,
    output reg [11:0] calculated_toll
);

always @(*) begin
    case (vehicle_type)

        2'b00: calculated_toll = 12'd50;   // Car
        2'b01: calculated_toll = 12'd100;  // Bus
        2'b10: calculated_toll = 12'd150;  // Truck
        2'b11: calculated_toll = 12'd200;  // Heavy Vehicle

        default: calculated_toll = 12'd0;

    endcase
end

endmodule
