`timescale 1ns / 1ps

module mem#(parameter N = 32, L = 256)(
    input   logic           clk, 
    input   logic [1:0]     memwrite,
    input   logic [N-1:0]   dataadr, writedata,
    output  logic [N-1:0]   readdata,
    input   logic [7:0]     checka,
    output  logic [N-1:0]   check
);
    logic [N-1:0] RAM [L-1:0];
    initial
        $readmemh("C:/Users/will131/Documents/workspace/MIPS_V2.0/memfile.dat",RAM);
    assign readdata = RAM[dataadr[N-1:2]];
    assign check = RAM[checka];
    always @(posedge clk)
        begin
        if (memwrite==1)
            RAM[dataadr[N-1:2]] <= writedata;
        else if (memwrite==2) //B
                case (dataadr[1:0])
                    2'b11:  RAM[dataadr[N-1:2]][7:0]  <= writedata[7:0];
                    2'b10:  RAM[dataadr[N-1:2]][15:8] <= writedata[7:0];
                    2'b01:  RAM[dataadr[N-1:2]][23:16]<= writedata[7:0];
                    2'b00:  RAM[dataadr[N-1:2]][31:24]<= writedata[7:0];
                endcase
        else if (memwrite==3) //H
                case (dataadr[1])
                    1:  RAM[dataadr[N-1:2]][15:0]  <= writedata[15:0];
                    0:  RAM[dataadr[N-1:2]][31:16] <= writedata[15:0];
                endcase
        end 
endmodule