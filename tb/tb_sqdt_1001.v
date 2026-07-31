module tb_sqdt_1001;
reg clk;
reg rstn;
reg in;

wire detect_mly_nonovr;
wire detect_mly_ovr;
wire detect_moore_nonovr;
wire detect_moore_ovr;


// DUT instantiation

sqdt_1001_mly_nonovr dut1(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect_mly_nonovr)
);


sqdt_1001_mly_ovr dut2(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect_mly_ovr)
);


sqdt_1001_moore_nonovr dut3(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect_moore_nonovr)
);


sqdt_1001_moore_ovr dut4(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect_moore_ovr)
);


// clock generation

always #5 clk = ~clk;


// task to send bits

task send_bit(input bit b);
begin
    @(negedge clk);
    in = b;
end
endtask



// reset

task reset;
begin
    rstn = 0;
    in = 0;
    #20;
    rstn = 1;
end
endtask



// stimulus

initial begin

    clk = 0;
    rstn = 0;
    in = 0;


    reset();


    // Test 1001
    // expected detection after last 1

    send_bit(1);
    send_bit(0);
    send_bit(0);
    send_bit(1);


    #10;


    // Test overlapping sequence
    // 1001001 contains two detections

    send_bit(1);
    send_bit(0);
    send_bit(0);
    send_bit(1);
    send_bit(0);
    send_bit(0);
    send_bit(1);


    #20;


    // Random testing

    send_bit(1);
    send_bit(1);
    send_bit(0);
    send_bit(1);
    send_bit(0);
    send_bit(0);
    send_bit(1);


    #50;

    $finish;

end



// monitor

initial begin

$monitor(
"time=%0t in=%b | Mealy_NON=%b Mealy_OVR=%b Moore_NON=%b Moore_OVR=%b",
$time,
in,
detect_mly_nonovr,
detect_mly_ovr,
detect_moore_nonovr,
detect_moore_ovr
);

end


endmodule
