`timescale 1ns/1ns

module uart_rxdata_shell(
input clk_sys,
input rst_n,
input data_rdy,
input [7:0] uart_rxdata,
output reg [31:0] data

);

always @(posedge clk_sys or negedge rst_n) begin

	if(!rst_n) begin
		data <= 32'd0;
	end
	else begin
		if(data_rdy) data <= {data[23:0], uart_rxdata[7:0]};
	end
end
endmodule