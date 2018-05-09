`timescale 1ns / 1ps

module top#(parameter N = 32)(
    input   logic        clk, reset,
    output  logic [N-1:0]writedata, dataadr,
    output  logic        memwrite,
    output  logic [N-1:0]readdata
);
    mips mips(clk, reset, dataadr, writedata,  memwrite, readdata);
    mem mem(clk,memwrite,dataadr,writedata,readdata);

endmodule