module demux_onehot_sel_comb(
    input  [31:0] in,
    input         in_vld,
    input  [7:0]  onehot_sel,
    output reg [255:0] dmux_out,
    output reg [7:0]   out_vld
);

integer i;

always @(*) begin
    // Default assignment
    dmux_out = 256'd0;

    if (in_vld) begin
        for (i = 0; i < 8; i = i + 1) begin
            if (onehot_sel[i])
                dmux_out[i*32 +: 32] = in;
        end
    end
end


always @(*) begin
    // Default assignment
    out_vld = 8'd0;

    if (in_vld) begin
        out_vld = onehot_sel;
    end
end

endmodule
