module tb_demux_onehot_sel_comb;

reg [31:0] in;
reg        in_vld;
reg [7:0]  onehot_sel;

wire [255:0] dmux_out;
wire [7:0]   out_vld;

demux_onehot_sel_comb dut (
    .in(in),
    .in_vld(in_vld),
    .onehot_sel(onehot_sel),
    .dmux_out(dmux_out),
    .out_vld(out_vld)
);

initial begin
    $dumpfile("demux_onehot_sel_comb.vcd");
    $dumpvars(0, tb_demux_onehot_sel_comb);
end

task drive_input;
input [31:0] data;
input [7:0] sel;
begin
    in = data;
    onehot_sel = sel;
    in_vld = 1'b1;

    #1;

    $display("time=%0t in=%h sel=%b dmux_out=%h out_vld=%b",
             $time, in, onehot_sel, dmux_out, out_vld);

    #9;

    in_vld = 1'b0;
    onehot_sel = 8'b0;

    #1;

    $display("time=%0t in=%h sel=%b dmux_out=%h out_vld=%b",
             $time, in, onehot_sel, dmux_out, out_vld);
end
endtask

initial begin
    in_vld = 1'b0;
    in = 32'b0;
    onehot_sel = 8'b0;

    #10;

    drive_input(32'h12345678, 8'b00000001);
    drive_input(32'hAABBCCDD, 8'b00000010);
    drive_input(32'h11223344, 8'b00000100);
    drive_input(32'h55667788, 8'b00001000);
    drive_input(32'hDEADBEEF, 8'b00010000);
    drive_input(32'hCAFEBABE, 8'b00100000);
    drive_input(32'hABCDEF01, 8'b01000000);
    drive_input(32'hFEDCBA98, 8'b10000000);

    drive_input(32'h12345678, 8'b10101010);
    drive_input(32'hA5A5A5A5, 8'b01010101);

    #10;

    $finish;
end

endmodule
