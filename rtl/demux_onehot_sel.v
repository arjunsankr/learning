module dmux_256(
    input  [31:0] in,
    input         clk,
    input         rstn,
    input         in_vld,
    input  [7:0]  onehot_sel,
    output reg [255:0] dmux_out,
    output reg [7:0]   out_vld
);

integer i;

always @(posedge clk) begin
    if (!rstn) 
        dmux_out <= 256'd0;
    else begin
        if (in_vld) begin
            for (i = 0; i < 8; i = i + 1) begin
              if (onehot_sel[i])
                dmux_out[i*32 +: 32] <= in;
              else
                dmux_out<=dmux_out;
            end
        end
    end
end
  always@(posedge clk)begin
    if(!rstn)
    out_vld  <= 8'd0;
    else
      for (i = 0; i < 8; i = i + 1) begin
                if (onehot_sel[i])
                    out_vld  <= onehot_sel;
              else
                out_vld<=8'b0;

endmodule
