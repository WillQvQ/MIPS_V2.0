`timescale 1ns / 1ps


module maindec(
    input   logic       clk, reset,   
    input   logic [5:0] op,
    output  logic       pcwrite, memwrite, irwrite, regwrite,
    output  logic       branch, iord, memtoreg, regdst, alusrca, 
    output  logic [2:0] alusrcb, // ANDI
    output  logic [1:0] pcsrc,
    output  logic [2:0] aluop,
    output  logic       bne, // BNE
    output  logic [1:0] lb,
    output  logic [4:0] stateshow
); // LB/LBU
    typedef enum logic [4:0] {FETCH, DECODE, MEMADR,//2
            MEMRD, MEMWB, MEMWR, RTYPEEX, RTYPEWB, BEQEX,//8
            ADDIEX, ADDIWB, JEX, ANDIEX, ANDIWB,//13
            BNEEX, LBURD, LBRD, ORIEX, ORIWB,//18
            SLTIEX, SLTIWB} statetype;//20
    statetype state, nextstate;
    assign stateshow = state;
    parameter RTYPE = 6'b000000;
    parameter LW    = 6'b100011;
    parameter SW    = 6'b101011;
    parameter BEQ   = 6'b000100;
    parameter ADDI  = 6'b001000;
    parameter J     = 6'b000010;
    parameter BNE   = 6'b000101;
    parameter LBU   = 6'b100100;
    parameter LB    = 6'b100000;
    parameter ANDI  = 6'b001100;
    parameter ORI   = 6'b001101;
    parameter SLTI  = 6'b001010;
    logic [19:0] controls; // ANDI, BNE, LBU
    // state register
    always_ff @(posedge clk or posedge reset) begin
        $display("State is %d",state);
        if(reset) state <= FETCH;
        else state <= nextstate;
    end
    // next state logic
    always_comb
        case(state)
            FETCH: nextstate <= DECODE;
            DECODE: case(op)
                LW: nextstate <= MEMADR;
                SW: nextstate <= MEMADR;
                LB: nextstate <= MEMADR; // LB
                LBU: nextstate <= MEMADR; // LBU
                RTYPE: nextstate <= RTYPEEX;
                BEQ: nextstate <= BEQEX;
                ADDI: nextstate <= ADDIEX;
                J: nextstate <= JEX;
                BNE: nextstate <= BNEEX; // BNE
                ANDI: nextstate <= ANDIEX; // ANDI
                ORI: nextstate <= ORIEX; // ORI
                SLTI: nextstate <= SLTIEX; // SLTI
                // STLI: nextstate <= ANDIEX;
                default: nextstate <= FETCH;
            endcase
            MEMADR: case(op)
                LW: nextstate <= MEMRD;
                SW: nextstate <= MEMWR;
                LBU: nextstate <= LBURD; // LBU
                LB: nextstate <= LBRD; // LB
                default: nextstate <= FETCH;
            endcase
            // MEMRD : MEM Read
            MEMRD: nextstate <= MEMWB;
            // MEMWB : MEM Writeback
            MEMWB: nextstate <= FETCH;
            // MEMWR ：MEM Write
            MEMWR: nextstate <= FETCH;
            RTYPEEX: nextstate <= RTYPEWB;
            RTYPEWB: nextstate <= FETCH;
            BEQEX: nextstate <= FETCH;
            ADDIEX: nextstate <= ADDIWB;
            ADDIWB: nextstate <= FETCH;
            JEX: nextstate <= FETCH;
            ANDIEX: nextstate <= ANDIWB; // ANDI
            ANDIWB: nextstate <= FETCH; // ANDI
            ORIEX: nextstate <= ORIWB; // ORI
            ORIWB: nextstate <= FETCH; // ORI
            SLTIEX: nextstate <= SLTIWB; // ORI
            SLTIWB: nextstate <= FETCH; // ORI
            BNEEX: nextstate <= FETCH; // BNE
            LBURD: nextstate <= MEMWB; // LBU
            LBRD: nextstate <= MEMWB; // LB
            default: nextstate <= FETCH;
        // should never happen
        endcase
    assign {pcwrite, memwrite, irwrite, regwrite,
            alusrca, branch, iord, memtoreg, regdst,
            bne, alusrcb, pcsrc, aluop, lb} = controls; 
    always_comb
        case(state)
            FETCH:  controls <= 20'b1010_00000_0_001_00_000_00;
            DECODE: controls <= 20'b0000_00000_0_011_00_000_00;
            MEMADR: controls <= 20'b0000_10000_0_010_00_000_00;
            MEMRD:  controls <= 20'b0000_00100_0_000_00_000_00;
            MEMWB:  controls <= 20'b0001_00010_0_000_00_000_00;
            MEMWR:  controls <= 20'b0100_00100_0_000_00_000_00;
            RTYPEEX:controls <= 20'b0000_10000_0_000_00_010_00;
            RTYPEWB:controls <= 20'b0001_00001_0_000_00_000_00;
            BEQEX:  controls <= 20'b0000_11000_0_000_01_001_00;
            ADDIEX: controls <= 20'b0000_10000_0_010_00_000_00;
            ADDIWB: controls <= 20'b0001_00000_0_000_00_000_00;
            JEX:    controls <= 20'b1000_00000_0_000_10_000_00;
            ANDIEX: controls <= 20'b0000_10000_0_100_00_011_00; // ANDI
            ANDIWB: controls <= 20'b0001_00000_0_000_00_000_00; // ANDI
            ORIEX:  controls <= 20'b0000_10000_0_100_00_100_00; // ORI
            ORIWB:  controls <= 20'b0001_00000_0_000_00_000_00; // ORI
            SLTIEX: controls <= 20'b0000_10000_0_010_00_101_00; // SLTI
            SLTIWB: controls <= 20'b0001_00000_0_000_00_000_00; // SLTI
            BNEEX:  controls <= 20'b0000_10000_1_000_01_001_00; // BNE
            LBURD:  controls <= 20'b0000_00100_0_000_00_000_01; // LBU
            LBRD:   controls <= 20'b0000_00100_0_000_00_000_10; // LB
            default:controls <= 20'b0000_xxxxx_x_xxx_xx_xxx_xx;
        // should never happen
        endcase
endmodule