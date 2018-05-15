`timescale 1ns / 1ps

module mips#(parameter N = 32)(
    input   logic       clk, reset,
    output  logic[N-1:0]dataadr, writedata,
    output  logic       memwrite,
    input   logic[N-1:0]readdata,
    output  logic [7:0] pclow,
    output  logic [4:0] state
);
    logic       pcen, irwrite, iord, lbu;
    logic       memtoreg, regdst, regwrite, zero;
    logic       alusrca;    
    logic [2:0] alusrcb;    
    logic [2:0] alucontrol;
    logic [1:0] pcsrc, lb;         
    logic [5:0] op, funct;
    controller controller(clk, reset, op, funct, zero,
                        pcen, memwrite, irwrite, regwrite,
                        iord, memtoreg, regdst, alusrca,
                        alusrcb, pcsrc, alucontrol, lb, state);
    datapath datapath(clk, reset, pcen, irwrite, regwrite,
                    iord, memtoreg, regdst, alusrca, alusrcb, 
                    pcsrc, alucontrol, lb, op, funct,
                    zero, dataadr, writedata, readdata, pclow);
endmodule