`timescale 1ns/1ns
module uart_tx
#(
parameter Baud_Rate = 9600,
parameter Clk_Freq = 50_000_000,
parameter DATA_LEN = 8
)
(
input clk_sys,
input rst_n,
input [7:0] tx_dat,
input tx_en,
output reg uart_tx
);

parameter Sample = Clk_Freq / Baud_Rate;
parameter IDLE = 4'd0,START = 4'd1, DAT0 = 4'd2, DAT1 = 4'd3, DAT2 = 4'd4, 
DAT3 = 4'd5, DAT4 = 4'd6, DAT5 = 4'd7, DAT6 = 4'd8, DAT7 = 4'd9, STOP = 4'd10;

reg [3:0]state, nstate;
reg [31:0] clk_cnt;
always @(posedge clk_sys or negedge rst_n) begin

	if(!rst_n) state <= IDLE;
	else state <= nstate;
end

always @(*) begin
	nstate = IDLE;
	case(state)
		IDLE: nstate = tx_en?START:IDLE;
		START: nstate = (clk_cnt == Sample)?DAT0:START;
		DAT0: nstate = (clk_cnt == Sample)?DAT1:DAT0;
		DAT1: nstate = (clk_cnt == Sample)?DAT2:DAT1;
		DAT2: nstate = (clk_cnt == Sample)?DAT3:DAT2;
		DAT3: nstate = (clk_cnt == Sample)?DAT4:DAT3;
		DAT4: nstate = (clk_cnt == Sample)?DAT5:DAT4;
		DAT5: nstate = (clk_cnt == Sample)?DAT6:DAT5;
		DAT6: nstate = (clk_cnt == Sample)?DAT7:DAT6;
		DAT7: nstate = (clk_cnt == Sample)?STOP:DAT7;
		STOP: nstate = (clk_cnt == Sample)?IDLE:STOP;
		default: nstate = IDLE;
	endcase
end

always @(posedge clk_sys or negedge rst_n) begin

	if(!rst_n) begin
		uart_tx <= 1'b0;
		clk_cnt <= 32'd0;
	end
	else begin
		case(state)
			IDLE:begin
				uart_tx <= 1'b1;
				clk_cnt <= 32'd0;
			end
			START:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= 1'b0;
			end
			DAT0:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[0];			
			end
			DAT1:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[1];
			end
			DAT2:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[2];
			end
			DAT3:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[3];
			end
			DAT4:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[4];
			end
			DAT5:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[5];
			end
			DAT6:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[6];
			end
			DAT7:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= tx_dat[7];
			end
			STOP:begin
				if(clk_cnt == Sample) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
				uart_tx <= 1'b1;
			end
		endcase
	end
end
endmodule