// Address Offsets
`define ADDR_CTRL         2'b00  
`define ADDR_STATUS       2'b01  
`define ADDR_DATA         2'b10  

// Status Register Flags (Bit Mapping)
`define STATUS_TX_EN       0  // RW
`define STATUS_RX_EN       1  // RW
`define STATUS_BREAK       2  // RO
`define STATUS_FIFO_FULL   3  // RO
`define STATUS_FIFO_EMPTY  4  // RO


module uart_csr (
    // APB Interface
    input         PCLK,
    input         PRESETn,
    input         PSEL,
    input         PENABLE,
    input         PWRITE,
    input  [5:0] PADDR,
    input  [31:0] PWDATA,
    output reg [31:0] PRDATA,
    output        PREADY,

    // Hardware Interface (To/From Core)
    input         hw_break,
    input         hw_fifo_full,
    input         hw_fifo_empty,
    
    output [31:0] ctrl_reg_out,
    output        tx_enabled,
    output        rx_enabled
);

    // Internal Registers
    reg [31:0] ctrl_reg;
    reg [7:0]  status_reg;

    
    wire [5:0] reg_addr = PADDR 
    wire apb_write = PSEL && PENABLE && PWRITE;
    wire apb_read  = PSEL && !PWRITE;


    assign tx_enabled   = status_reg[`STATUS_TX_EN];
    assign rx_enabled   = status_reg[`STATUS_RX_EN];
    assign ctrl_reg_out = ctrl_reg;

    // APB Read Address Decoder
    always @(*) begin
        if (apb_read) begin
            case (reg_addr)
                `ADDR_CTRL:   PRDATA = ctrl_reg;
                `ADDR_STATUS: PRDATA = {24'b0, status_reg}; 
                default:      PRDATA = 32'b0;
            endcase
        } else begin
            PRDATA = 32'b0;
        end
    end

  
    // APB Write & Hardware Status Update Logic
  
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            ctrl_reg   <= 32'b0;
            status_reg <= 8'b0;
            status_reg[`STATUS_FIFO_EMPTY] <= 1'b1; 
        end 
        else begin
            if (apb_write && (reg_addr == `ADDR_CTRL)) begin
                ctrl_reg <= PWDATA;
            end

            if (apb_write && (reg_addr == `ADDR_STATUS)) begin
                status_reg[`STATUS_TX_EN] <= PWDATA[`STATUS_TX_EN];
                status_reg[`STATUS_RX_EN] <= PWDATA[`STATUS_RX_EN];
            end

            status_reg[`STATUS_BREAK]      <= hw_break;
            status_reg[`STATUS_FIFO_FULL]  <= hw_fifo_full;
            status_reg[`STATUS_FIFO_EMPTY] <= hw_fifo_empty;

            if (hw_overrun_err)
                status_reg[`STATUS_OVERRUN] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`STATUS_OVERRUN])
                status_reg[`STATUS_OVERRUN] <= 1'b0;

            // Parity Flag
            if (hw_parity_err)
                status_reg[`STATUS_PARITY_ERR] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`STATUS_PARITY_ERR])
                status_reg[`STATUS_PARITY_ERR] <= 1'b0;

            // Framing Flag
            if (hw_framing_err)
                status_reg[`STATUS_FRAMING_ERR] <= 1'b1;
            else if (apb_write && (reg_addr == `ADDR_STATUS) && PWDATA[`STATUS_FRAMING_ERR])
                status_reg[`STATUS_FRAMING_ERR] <= 1'b0;
        end
    end

endmodule
