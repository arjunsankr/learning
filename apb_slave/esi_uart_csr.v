`define ADDR_CTRL         6'h0c  
`define ADDR_STATUS       6'h08  
`define ADDR_DATA         6'h00  

`define TXE    0   
`define TXF    1   
`define TXO    2   
`define RXE    3   
`define RXF    4
`define RXO    5
`define RXP    6
`define RXB    7
`define FE     8   
`define PE     9   
`define RLR    10  
`define RT     11  
`define TXAE   14  
`define RXAF   15  


module uart_csr (
    input         PCLK,
    input         PRESETn,
    input         PSEL,
    input         PENABLE,
    input         PWRITE,
    input  [5:0]  PADDR,
    input  [31:0] PWDATA,
    output reg [31:0] PRDATA,
    output        PREADY,

    input         hw_tx_empty,
    input         hw_tx_full,
    input         hw_tx_overrun,
    input         hw_rx_empty,
    input         hw_rx_full,
    input         hw_rx_overrun,
    input         hw_rx_parity_err,
    input         hw_rx_break,
    input         hw_framing_err,
    input         hw_parity_err,
    input         hw_rlr,
    input         hw_rx_timeout,
    input         hw_tx_almost_empty,
    input         hw_rx_almost_full,
    
    output [31:0] ctrl_reg_out
);

    reg [31:0] ctrl_reg;
    reg [15:0] status_reg; 

    assign PREADY = 1'b1; 
    
    wire [5:0] reg_addr = PADDR; 
    wire apb_write = PSEL && PENABLE && PWRITE;
    wire apb_read  = PSEL && !PWRITE;

    assign ctrl_reg_out = ctrl_reg;

    always @(*) begin
        if (apb_read) begin
            case (reg_addr)
                `ADDR_CTRL:   PRDATA = ctrl_reg;
                `ADDR_STATUS: PRDATA = {16'b0, status_reg}; 
                default:      PRDATA = 32'b0;
            endcase
        } else begin
            PRDATA = 32'b0;
        end
    end

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            ctrl_reg   <= 32'b0;
            status_reg <= 16'b0;
            status_reg[`TXE] <= 1'b1;
            status_reg[`RXE] <= 1'b1;
        end 
        else begin
            if (apb_write && (reg_addr == `ADDR_CTRL)) begin
                ctrl_reg <= PWDATA;
            end

            // Read-Only Status Updates
            status_reg[`TXE]  <= hw_tx_empty;
            status_reg[`TXF]  <= hw_tx_full;
            status_reg[`RXE]  <= hw_rx_empty;
            status_reg[`RXF]  <= hw_rx_full;
            status_reg[`RXB]  <= hw_rx_break;
            status_reg[`RLR]  <= hw_rlr;
            status_reg[`RT]   <= hw_rx_timeout;
            status_reg[`TXAE] <= hw_tx_almost_empty;
            status_reg[`RXAF] <= hw_rx_almost_full;

            // Write-1-to-Clear (W1C) Error Management
            if (hw_tx_overrun)
                status_reg[`TXO] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`TXO])
                status_reg[`TXO] <= 1'b0;

            if (hw_rx_overrun)
                status_reg[`RXO] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`RXO])
                status_reg[`RXO] <= 1'b0;

            if (hw_rx_parity_err)
                status_reg[`RXP] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`RXP])
                status_reg[`RXP] <= 1'b0;

            if (hw_framing_err)
                status_reg[`FE] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`FE])
                status_reg[`FE] <= 1'b0;

            if (hw_parity_err)
                status_reg[`PE] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`PE])
                status_reg[`PE] <= 1'b0;
        end
    end

endmodule
