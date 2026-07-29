module rising_edge_detect(input 
                     clk,
                     input rstn,
                     input in0,
                     output reg op0);
  
  reg o1;
  
  always @(posedge clk)
    begin
      if(!rstn)
        o1<=0;
      else begin
        o1<=in0;
        op0<=in0&~o1;
      end
    end  
endmodule
        
