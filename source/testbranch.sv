`timescale 1ns / 1ps

module testbench(
    input   logic 	reset,clken,
    input   logic 	CLK100MHZ,
    output  logic 	[6:0]seg,
    output  logic 	[7:0]an,
    output  logic 	[5:0]pclow
);
	logic clk,CLK380,CLK48,CLK04;

	logic [31:0]writedata, dataadr;
	logic       memwrite;
	logic [31:0]datapc;
	logic [2:0]cnt;
	logic [3:0]digit;   
	logic [31:0]data;   
	logic [31:0]datamem;
	clkdiv clkdiv(CLK100MHZ,CLK380,CLK48,CLK04);
	assign clk = CLK04 & clken;
	top top(clk, reset, writedata, dataadr, memwrite, datapc, pclow);
	assign data = memwrite?datamem:datapc;
	initial cnt=2'b0;
	initial datamem=32'b0;
	always@(posedge CLK380)  
		begin  
			if (memwrite) begin
				datamem[31:28] = 14;
				datamem[27:24] = 14;
				datamem[23:16] = dataadr[7:0];
				datamem[15:0] = writedata[15:0];
			end
			an=8'b11111111;   
			an[cnt]=0;  
			case(cnt)   
				0:digit=data[3:0];
				1:digit=data[7:4];
				2:digit=data[11:8];
				3:digit=data[15:12];
				4:digit=data[19:16];
				5:digit=data[23:20];
				6:digit=data[27:24];
				7:digit=data[31:28];  
				default:digit=4'b0;  
			endcase  
			case(digit)  
				0:seg=   7'b1000000;  
				1:seg=   7'b1111001;  
				2:seg=   7'b0100100;       
				3:seg=   7'b0110000;  
				4:seg=   7'b0011001;  
				5:seg=   7'b0010010;  
				6:seg=   7'b0000010;  
				7:seg=   7'b1111000;  
				8:seg=   7'b0000000;  
				9:seg=   7'b0010000;  
				10:seg=  7'b0001000;
				11:seg=  7'b0000011;
				12:seg=  7'b1000110;
				13:seg=  7'b0010001;
				14:seg=  7'b0000110;
				15:seg=  7'b0001110;
				default:seg=7'b1111110;  
			endcase 
			cnt <=cnt+1'b1; 
		end  

endmodule  