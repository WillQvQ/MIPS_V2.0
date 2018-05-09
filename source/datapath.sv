`timescale 1ns / 1ps

module datapath #(parameter N = 32, I = 16 ,B = 8)(
    input   logic       clk, reset,
    input   logic       pcen, irwrite,
    input   logic       regwrite,
    input   logic       iord, memtoreg, regdst, alusrca, 
    input   logic [2:0] alusrcb, // ANDI
    input   logic [1:0] pcsrc,
    input   logic [2:0] alucontrol,
    input   logic [1:0] lb, // LB/LBU
    output  logic [5:0] op, funct,
    output  logic       zero,
    output  logic [N-1:0]dataadr, writedata,
    input   logic [N-1:0]readdata
);
    // Internal signals of the datapath module
    logic [4:0]     writereg;
    logic [N-1:0]   pcnext, pc;
    logic [N-1:0]   instr, data, srca, srcb;
    logic [N-1:0]   rda;
    logic [N-1:0]   aluresult, aluout;
    logic [N-1:0]   signimm; // the sign-extended imm
    logic [N-1:0]   zeroimm; // the zero-extended imm // ANDI
    logic [N-1:0]   signimmsh; // the sign-extended imm << 2
    logic [N-1:0]   wd3, rd1, rd2;
    logic [N-1:0]   memdata, mbytezext, mbytesext; // LB / LBU
    logic [B-1:0]     mbyte; // LB / LBU
    // op and funct fields to controller
    assign op = instr[N-1:26];
    assign funct = instr[5:0];
    // datapath
    flopenr #(N)    pcreg(clk, reset, pcen, pcnext, pc);
    mux2 #(N)       adrmux(pc, aluout, iord, dataadr);
    flopenr #(N)    instrreg(clk, reset, irwrite, readdata, instr);
    // changes for LB / LBU
    mux4 #(B)       lbmux(readdata[N-1:24], readdata[23:16], readdata[15:8],
                        readdata[7:0], aluout[1:0], mbyte);
    zeroext #(B,N)  lbze(mbyte, mbytezext);
    signext #(B,N)  lbse(mbyte, mbytesext);
    mux3 #(N)       datamux(readdata, mbytezext, mbytesext, lb, memdata);
    flopr #(N)      datareg(clk, reset, memdata, data);
    //
    mux2 #(5)       regdstmux(instr[20:16],instr[15:11], regdst, writereg);
    mux2 #(N)       wdmux(aluout, data, memtoreg, wd3);
    regfile#(N,32)  regfile(clk, regwrite, instr[25:21], instr[20:16],
                        writereg, wd3, rd1, rd2);
    flopr #(N)      rdareg(clk, reset, rd1, rda);
    flopr #(N)      wdreg(clk, reset, rd2, writedata);
    //
    signext#(I,N)   signext(instr[15:0], signimm);
    zeroext#(I,N)   zeroext(instr[15:0], zeroimm); // ANDI
    sl2             immsh(signimm, signimmsh);
    mux2 #(N)       srcamux(pc, rda, alusrca, srca);
    mux5 #(N)       srcbmux(writedata, 32'b100, signimm, signimmsh, zeroimm, alusrcb, srcb);
    alu             alu(srca, srcb, alucontrol, aluresult, zero);
    flopr #(N)      alureg(clk, reset, aluresult, aluout);
    mux3 #(N)       pcmux(aluresult, aluout, {pc[31:28], instr[25:0], 2'b00},pcsrc, pcnext);
endmodule
