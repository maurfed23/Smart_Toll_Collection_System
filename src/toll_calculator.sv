`timescale 1ns/1ps

module toll_calculator (
    input  logic [1:0]  vehicle_type,
    output logic [11:0] toll_value
);

    always_comb begin

        case (vehicle_type)

            2'b00: toll_value = 12'd50;   // Car
            2'b01: toll_value = 12'd100;  // Bus
            2'b10: toll_value = 12'd150;  // Truck
            2'b11: toll_value = 12'd200;  // Heavy vehicle

            default:
                toll_value = 12'd0;

        endcase

    end

endmodule
