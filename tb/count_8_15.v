module counter_tb;
  reg clk;
  reg rstn;
  wire out_8_15;
  wire out_12_15;
  
    counter  dut(.clk(clk),
              .rstn(rstn),
              .out_8_15(out_8_15),
              .out_12_15(out_12_15));
  
  always #5 clk=~clk;
  
  initial begin
    clk=0;
    rstn=0;
    repeat(2)@(posedge clk);
      rstn=1;
    repeat(30)@(posedge clk);
      $finish;
  end
  initial begin
     $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
  


