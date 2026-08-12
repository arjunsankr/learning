module sqdt_1001_mly_nonovr(
    input clk,
    input rstn,
    input in,
    output detect
);

reg [1:0] n_state, p_state;

parameter [1:0] S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11
// current state logic

always @(posedge clk or negedge rstn) begin
    if(!rstn)
        p_state <= 2'b00;
    else
        p_state <= n_state;
end

// next state logic

always @(*) begin
    n_state = 2'b00;

    case(p_state)

        S0: begin
            if(in)
                n_state = S1;
            else
                n_state = S0;
        end

        S1: begin
            if(in)
                n_state = S1;
            else
                n_state = S2;
        end

        S2: begin
            if(in)
                n_state = S3;
            else
                n_state = ;
        end

        S3: begin
            if(in)
                n_state = S0;   // non-overlapping
            else
                n_state = S0;
        end

        default: n_state = S0;

    endcase
end

// output logic

    assign detect = (p_state == S3 && in);

endmodule
