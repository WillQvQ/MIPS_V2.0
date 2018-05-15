`timescale 1ns / 1ps

module controller(
    input   logic       clk, reset,
    input   logic [5:0] op, funct,
    input   logic       zero,
    output  logic       pcen, memwrite, irwrite, regwrite,
    output  logic       iord, memtoreg, regdst, alusrca,
    output  logic [2:0] alusrcb, // ANDI
    output  logic [1:0] pcsrc,
    output  logic [2:0] alucontrol,
    output  logic [1:0] lb,      // LB/LB
    output  logic [4:0] state
); 
    logic [2:0] aluop;
    logic       branch, pcwrite;
    logic       bne; // BNE
    // Main Decoder and ALU Decoder subunits.
    maindec maindec(clk, reset, op, pcwrite, memwrite, 
                irwrite, regwrite, branch, iord, memtoreg, regdst,
                alusrca, alusrcb, pcsrc, aluop, bne, lb, state); //BNE, LBU
    aludec aludec(funct, aluop, alucontrol);
    assign pcen = pcwrite | (branch & zero) | (bne & ~zero); // BNE
endmodule