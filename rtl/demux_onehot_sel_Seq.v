module dmux_256(
    input  [31:0]  in,
    input          clk,
    input          rstn,
    input          in_vld,
    input  [7:0]   onehot_sel,
    output reg [255:0] dmux_out,
    output reg [7:0]   out_vld
);

integer i;

always @(posedge clk) begin
    if (!rstn) begin
        dmux_out <= 256'd0;
    end
    else if (in_vld) begin
        for (i = 0; i < 8; i = i + 1) begin
            if (onehot_sel[i])
                dmux_out[i*32 +: 32] <= in;
        end
    end
end

always @(posedge clk) begin
    if (!rstn) begin
        out_vld <= 8'd0;
    end
    else if (in_vld) begin
        out_vld <= onehot_sel;
    end
    else begin
        out_vld <= 8'd0;
    end
end

endmodule
