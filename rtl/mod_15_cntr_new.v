module counter
  ( input   clk,
   input rstn,
   output out_8_15,
   output out_12_15);
  
  //internal count
  reg [3:0]count;

  always @ (posedge clk) begin
    if (!rstn) begin
      count <= 0;
    end else begin
      if (count == 15)
        count <= 0;
      else
        count <= count + 1;
    end
  end
  
assign out_8_15=(count[3]);
assign out_12_15=(count[3]&&count[2]);
endmodule
