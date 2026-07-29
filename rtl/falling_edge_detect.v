module falling_edge_detect(input 
                     clk,
                     input rstn,
                     input in0,
                     output reg o_p);
  
  reg in0_1d;
  
  always @(posedge clk)
    begin
      if(!rstn)begin
        in0_1d<=1'b0;
        o_p<=1'b0;
      end
      else begin
        in0_1d<=in0;
        o_p<=~in0&in0_id;
      end
    end  
endmodule
        
