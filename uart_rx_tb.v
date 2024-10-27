`timescale 1ns/1ns

module uart_rx_tb();

reg clk_sys;
reg rst_n;
reg uart_rx;
reg [7:0] tx_dat_reg;
wire [7:0] rx_dat;
wire [31:0] clk_cnt;
wire [3:0] state;
wire [3:0] nstate;
wire data_rdy;

wire uart_tx;
uart_rx  #(.Clk_Freq(50_000_000),.Baud_Rate(115200),.DATA_LEN(8)) 
uart_rx_inst
(
.clk_sys(clk_sys),
.rst_n(rst_n),
.uart_rx(uart_rx),
.rx_dat(rx_dat),
.data_rdy(data_rdy)

);

uart_tx
#(
 .Baud_Rate(115200),
 .Clk_Freq(50_000_000),
 .DATA_LEN(8)
)
uart_tx_inst
(
.clk_sys(clk_sys),
.rst_n(rst_n),
.tx_dat(tx_dat_reg),
.tx_en(data_rdy),
.uart_tx(uart_tx),
.state(state),
.nstate(nstate),
.clk_cnt(clk_cnt)
);

always @(posedge clk_sys or negedge rst_n )begin
    if(!rst_n) tx_dat_reg <= 8'd0;
    else begin
        if(data_rdy == 1'b1) tx_dat_reg <= rx_dat;
    end
end
initial begin
clk_sys = 1'b0;
rst_n = 1'b0;
uart_rx = 1'b1;
#8680 rst_n = 1'b1;
#8680 uart_rx = 1'b0;
#8680 uart_rx = 1'b1;
#8680 uart_rx = 1'b0;
#8680 uart_rx = 1'b1;
#8680 uart_rx = 1'b0;
#8680 uart_rx = 1'b1;
#8680 uart_rx = 1'b0;
#8680 uart_rx = 1'b1;
#8680 uart_rx = 1'b0;
#8680 uart_rx = 1'b0;
#8680 uart_rx = 1'b1;
end

always #10 clk_sys = ~clk_sys;

endmodule