`timescale 1ns/1ps

module tag_validator (
    input  logic [7:0] tag_id,
    output logic       tag_valid
);

    always_comb begin

        if (tag_id == 8'd0)
            tag_valid = 1'b0;
        else
            tag_valid = 1'b1;

    end

endmodule
