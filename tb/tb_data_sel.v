`timescale 1ns/1ps

module tb_data_sel;

    reg [31:0] d0, d1, d2, d3;
    reg [1:0]  sel;
    reg        d0_val, d1_val, d2_val, d3_val;
    reg [2:0]  count;
    reg        clk;
    reg        rst_n;

    wire [31:0] dout;
    wire        dout_val;

    data_sel dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .d0_val(d0_val),
        .d1_val(d1_val),
        .d2_val(d2_val),
        .d3_val(d3_val),
        .count(count),
        .clk(clk),
      .rst_n(rst_n),
        .dout(dout),
        .dout_val(dout_val)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task reset_dut;
    begin
        rst_n   = 0;
        d0      = 0;
        d1      = 0;
        d2      = 0;
        d3      = 0;
        sel     = 0;
        d0_val  = 0;
        d1_val  = 0;
        d2_val  = 0;
        d3_val  = 0;
        count   = 0;

        repeat(2)
            @(posedge clk);

        rst_n = 1;
    end
    endtask

    task random_inputs;
    begin
        @(negedge clk);

        d0     = $random;
        d1     = $random;
        d2     = $random;
        d3     = $random;

        sel    = $random;
        count  = 3'b101;

        d0_val = $random;
        d1_val = $random;
        d2_val = $random;
        d3_val = $random;
    end
    endtask

    initial begin

        reset_dut;

        repeat(100) begin
            random_inputs;
        end

        #20;
        $finish;

    end

    always @(posedge clk) begin
        if (rst_n) begin
            $display(
                "TIME=%0t | sel=%b | d0=%h d1=%h d2=%h d3=%h | val=%b%b%b%b | count=%0d | dout=%h | dout_val=%b",
                $time,
                sel,
                d0, d1, d2, d3,
                d3_val, d2_val, d1_val, d0_val,
                count,
                dout,
                dout_val
            );
        end
    end
initial begin
  $dumpfile("waves.vcd");
            $dumpvars;
            end
endmodule
