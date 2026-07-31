`timescale 1ns/1ps

module tb_sqdt_1101;

reg clk;
reg rstn;
reg in;

wire detect_mly_nonovr;
wire detect_mly_ovr;
wire detect_moore_nonovr;
wire detect_moore_ovr;


// DUT instantiation

sqdt_1101_mly_nonovr dut1(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect)
);


sqdt_1101_mly_ovr dut2(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect)
);


sqdt_1101_moore_nonovr dut3(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect)
);


sqdt_1101_moore_ovr dut4(
    .clk(clk),
    .rstn(rstn),
    .in(in),
    .detect(detect)
);



// Clock generation

always #5 clk = ~clk;



// Send input bit

task send_bit(input bit b);
begin
    @(negedge clk);
    in = b;
end
endtask



// Reset

task reset;
begin
    rstn = 0;
    in = 0;
    #20;
    rstn = 1;
end
endtask



// Test sequence

initial begin

    clk = 0;
    rstn = 0;
    in = 0;


    reset();


    // Test 1101
    // Detection expected after input sequence 1-1-0-1

    send_bit(1);
    send_bit(1);
    send_bit(0);
    send_bit(1);


    #10;



    // Test overlapping
    // 1101101 contains two occurrences of 1101

    send_bit(1);
    send_bit(1);
    send_bit(0);
    send_bit(1);
    send_bit(1);
    send_bit(0);
    send_bit(1);


    #20;



    // Additional random cases

    send_bit(0);
    send_bit(1);
    send_bit(1);
    send_bit(0);
    send_bit(1);


    #50;

    $finish;

end



// Monitor outputs

initial begin

$monitor(
"time=%0t | input=%b | Mealy_NON=%b Mealy_OVR=%b Moore_NON=%b Moore_OVR=%b",
$time,
in,
detect,
detect,
detect,
detect
);

end


endmodule
