module tag_validator (
    input  [7:0] tag_id,
    output       tag_valid
);

assign tag_valid = (tag_id != 8'd0);

endmodule
