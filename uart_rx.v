
`timescale 1ns/1ns

//uart receiver:
//Clk_Frqe---input clk freq
//Baud_Rate---baudrate 4800,9600,115200
//DATA_LEN---length of data
//no parity
//1 bit stop bit


module uart_rx
#(
parameter Baud_Rate = 9600,
parameter Clk_Freq = 50_000_000,
parameter DATA_LEN = 8
)
(
input clk_sys,
input rst_n,
input uart_rx,
output reg [7:0]rx_dat,
output reg data_rdy
//input read_empty
);

parameter Sample = Clk_Freq / Baud_Rate;

parameter IDLE = 4'b0001, START = 4'b0010, RECV = 4'B0100, STOP = 4'b1000;


reg [3:0] state, nstate;
reg rx_en;
reg [31:0] clk_cnt;
reg [3:0] rx_cnt;
//reg [7:0] rx_dat;
//reg data_rdy;
reg [1:0] rx_reg;
wire rx_negedge;
always @(posedge clk_sys or negedge rst_n) begin

	if(!rst_n) state <= IDLE;
	else begin
		state <= nstate;
	end
end

always @(*) begin
	nstate = IDLE;
	case(state)
		IDLE: nstate = rx_negedge?START:IDLE;
		START: nstate = (clk_cnt == Sample/2)?RECV:START;
		RECV: nstate = (rx_cnt == DATA_LEN)?STOP:RECV;
		STOP: nstate = (clk_cnt == Sample)?IDLE:STOP;
		default:nstate = IDLE;
	endcase
end


always @(posedge clk_sys or negedge rst_n) begin

	if(!rst_n) begin
        clk_cnt <= 32'd0;
        rx_cnt <= 4'd0;
        rx_dat <= 8'd0;
	end
	else begin
		case(state)
			IDLE: begin
				clk_cnt <= 32'd0;
				rx_cnt <= 4'd0;
				rx_dat <= 8'd0;
				data_rdy <= 1'b0;
			end
			START:begin
				rx_cnt <= 4'd0;
				if(clk_cnt == Sample/2) clk_cnt <= 32'd0;
				else clk_cnt <= clk_cnt + 1'b1;
			end
			RECV:begin
				if(clk_cnt == Sample) begin
					clk_cnt <= 32'd0;
					rx_cnt <= rx_cnt + 1'b1;
					rx_dat[rx_cnt] <= uart_rx;
				end
				else clk_cnt <= clk_cnt + 1'b1;
			end
			STOP:begin
				//data_rdy <= 1'b1;
				if(clk_cnt == Sample) begin
					clk_cnt <= 32'd0;
					if(uart_rx == 1'b1) data_rdy <= 1'b1;
					else data_rdy <= 1'b0;
				end
				else begin
					clk_cnt <= clk_cnt + 1'b1;
				end
			end
			default:;
		endcase
	end
end


always @(posedge clk_sys or negedge rst_n) begin
	if(!rst_n) rx_reg <= 2'b11;
	else rx_reg <= {rx_reg[0], uart_rx};
end

assign rx_negedge = rx_reg[1] & ( ~rx_reg[0]);


endmodule