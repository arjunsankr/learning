module dmux_256(input [31:0]in,
                input clk,
                input rstn,
                input in_vld,
                input [7:0]onehot_sel,
                output reg [255:0]dmux_out,
                output reg [7:0]out_vld);
  
  always@(posedge clk)begin
    if(!rstn)begin
    dmux_out<=256'd0;
    out_vld<=8'd0;
    end
    else begin
      if(in_vld)begin
        out_vld<=onehot_sel;
        case(onehot_sel) 
          8'b00000001:dmux_out[31:0]=in;
          8'b00000010:dmux_out[63:32]=in;
          8'b00000100:dmux_out[95:64]=in;
          8'b00001000:dmux_out[127:96]=in;
          8'b00010000:dmux_out[159:128]=in;
          8'b00100000:dmux_out[191:160]=in;
          8'b01000000:dmux_out[223:192]=in;
          8'b10000000:dmux_out[255:224]=in;
      default:begin
        dmux_out<=dmux_out;
        out_vld<=out_vld;
      end
    endcase
  end
        
          
  
                       
