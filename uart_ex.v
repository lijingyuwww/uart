`timescale 1ns/1ns

module uart_ex(
input clk_sys,
input rst_n,
input uart_rx,
output uart_tx

);

reg [7:0]tx_dat_reg;
wire data_rdy;
wire [7:0] rx_dat;

uart_rx
#(
.Baud_Rate(115200),
.Clk_Freq(50_000_000),
.DATA_LEN(8)
)
uart_rx_inst
(
.clk_sys(clk_sys),
.rst_n(rst_n),
.uart_rx(uart_rx),
.rx_dat(rx_dat),
.data_rdy(data_rdy)
//input read_empty
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
.uart_tx(uart_tx)
);

always @(posedge clk_sys or negedge rst_n) begin
	if(!rst_n) tx_dat_reg <= 8'd0;
	else begin
		if(data_rdy) tx_dat_reg <= rx_dat;
	end
end
wire clk_200;
ila_0 ILA_UART (
	.clk(clk_200), // input wire clk


	.probe0(uart_rx), // input wire [0:0]  probe0  
	.probe1(uart_tx), // input wire [0:0]  probe1 
	.probe2(rx_dat), // input wire [0:0]  probe2 
	.probe3(tx_dat_reg), // input wire [0:0]  probe3
	.probe4(data_rdy) // input wire [0:0]  probe4
);

clk_wiz_0 instance_name
   (
    // Clock out ports
    .clk_out1(clk_200),     // output clk_out1
   // Clock in ports
    .clk_in1(clk_sys)      // input clk_in1
);
endmodule