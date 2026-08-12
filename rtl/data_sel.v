module data_sel (
  input  [31:0] d0,d1,d2,d3,
  input  [1:0]  sel,
    input         d0_val,d1_val,d2_val,d3_val,
    input  [2:0]  count,
    input         clk,rst_n,
    output reg [31:0] dout,
    output reg        dout_val
);

    reg [31:0] data_reg;
    reg [2:0]  count_reg;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg  <= 32'b0;
            count_reg <= 3'b0;
            busy      <= 1'b0;
            dout      <= 32'b0;
            dout_val  <= 1'b0;
        end
        else begin
            dout_val <= 1'b0;
          
            if (!busy) begin
                case (sel)
                    2'b00: begin
                        if (d0_val) begin
                            data_reg  <= d0;
                            count_reg <= count;
                            busy      <= 1'b1;
                        end
                    end

                    2'b01: begin
                        if (d1_val) begin
                            data_reg  <= d1;
                            count_reg <= count;
                            busy      <= 1'b1;
                        end
                    end

                    2'b10: begin
                        if (d2_val) begin
                            data_reg  <= d2;
                            count_reg <= count;
                            busy      <= 1'b1;
                        end
                    end

                    2'b11: begin
                        if (d3_val) begin
                            data_reg  <= d3;
                            count_reg <= count;
                            busy      <= 1'b1;
                        end
                    end
                endcase
            end
            else begin
                if (count_reg != 0) begin
                    count_reg <= count_reg - 1'b1;
                end
                else begin
                    dout     <= data_reg;
                    dout_val <= 1'b1;
                    busy     <= 1'b0;
                end
            end
        end
    end

endmodule
