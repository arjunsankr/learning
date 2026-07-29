module falling_edge_detect(input 
                     clk,
                     input rstn,
                     input in0,
                     output reg o_p);
  
  reg in0_1d;
  
  always @(posedge clk)
    begin
      if(!rstn)
        in0_1d<=0;
      else begin
        in0_1d<=in0;
        o_p<=~in0&in0_id;
      end
    end  
endmodule
        
