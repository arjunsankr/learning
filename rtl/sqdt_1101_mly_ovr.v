  module sqdt_1101_mly_ovr(input clk,rstn,
                         input in,
                         output detect);
  
  reg [1:0]n_state,p_state;
  
      
      //current state logic 
      
  always@(posedge clk or negedge rstn) begin
    if(!rstn)
    p_state<=2'b00;
    else
      p_state<=n_state;
  end
      
      //next state logic
      
      always@(*)begin
        n_state=2'b00;
        case(p_state)
          2'b00:begin
            if(in==1'b1)
              n_state=2'b01;
            else
              n_state=2'b00;
          end
          2'b01:begin
            if(in==1'b1)
              n_state=2'b10;
            else
              n_state=2'b00;
          end
          2'b10:begin
            if(in==1'b0)
              n_state=2'b11;
            else
              n_state=2'b10;
          end
          2'b11:begin
            if(in==1'b1)
              n_state=2'b01;
            else
              n_state=2'b00;
          end
        default:n_state=2'b00;
          endcase
      end
          
          //output logic

  assign detect=(p_state==2'b11 && in==1'b1);
          endmodule
