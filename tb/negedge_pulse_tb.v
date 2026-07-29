module falling_edge_detect_tb;
  reg clk;
  reg rstn;
  reg in0;
  wire o_p;
  
  
  flling_edge_detect dut(clk,rstn,in0,op0);
  always #5 clk=~clk;
  
  initial begin
    clk=0;
    repeat(2) @(posedge clk);
    rstn=1'b0;
    @(posedge clk);begin
    in0=1;
      rstn=1;end
    repeat(3) @(posedge clk);
    in0=0;
    @(posedge clk);
    in0=1;
    repeat(3) @(posedge clk);
    in0=0;
    @(posedge clk);
    in0=1;
    #50 $finish;
  end
  
  initial begin
    $dumpfile("dumo.vcd");$dumpvars;end
endmodule
