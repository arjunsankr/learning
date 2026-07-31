module sqdt_1101_moore_nonovr(
    input clk,
    input rstn,
    input in,
    output detect
);

reg [2:0] n_state, p_state;

// current state logic

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        p_state <= 3'b000;
    else
        p_state <= n_state;
end

// next state logic

always @(*) begin
    n_state = 3'b000;

    case(p_state)

        3'b000: begin
            if(in)
                n_state = 3'b001;
            else
                n_state = 3'b000;
        end

        3'b001: begin
            if(in)
                n_state = 3'b010;
            else
                n_state = 3'b000;
        end

        3'b010: begin
            if(in)
                n_state = 3'b010;
            else
                n_state = 3'b011;
        end

        3'b011: begin
            if(in)
                n_state = 3'b100;
            else
                n_state = 3'b000;
        end

        3'b100: begin
            if(in)
                n_state = 3'b000;
            else
                n_state = 3'b000;
        end

        default: n_state = 3'b000;

    endcase
end

// output logic

assign detect = (p_state == 3'b100);

endmodule
