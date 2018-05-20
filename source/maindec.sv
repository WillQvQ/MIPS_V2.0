`timescale 1ns / 1ps


module maindec(
    input   logic       clk, reset,   
    input   logic [5:0] op,
    output  logic       pcwrite, memwrite, irwrite, regwrite,
    output  logic       branch, iord, memtoreg, regdst, alusrca, 
    output  logic [2:0] alusrcb,
    output  logic [1:0] pcsrc,
    output  logic [2:0] aluop,
    output  logic       bne, 
    output  logic [1:0] lb,
    output  logic [4:0] stateshow
); 
    typedef enum logic [4:0] {IF, ID, EX_LS,
            MEM_LW, WB_L, MEM_SW, EX_RTYPE, WB_RTYPE, EX_BEQ,
            EX_ADDI, WB_ADDI, EX_J, EX_ANDI, WB_ANDI,
            EX_BNE, MEM_LBU, MEM_LB, EX_ORI, WB_ORI,
            EX_SLTI, WB_SLTI} statetype;
    statetype state, nextstate;
    assign stateshow = state;
    parameter RTYPE = 6'b000000;
    parameter LW    = 6'b100011;
    parameter LBU   = 6'b100100;
    parameter LB    = 6'b100000;
    parameter SW    = 6'b101011;
    parameter BEQ   = 6'b000100;
    parameter BNE   = 6'b000101;
    parameter J     = 6'b000010;
    parameter ADDI  = 6'b001000;
    parameter ANDI  = 6'b001100;
    parameter ORI   = 6'b001101;
    parameter SLTI  = 6'b001010;
    logic [19:0] controls; 
    always_ff @(posedge clk or posedge reset) begin
        $display("State is %d",state);
        if(reset) state <= IF;
        else state <= nextstate;
    end
    always_comb
        case(state)
            IF: nextstate <= ID;
            ID: case(op)
                LW:     nextstate <= EX_LS;
                SW:     nextstate <= EX_LS;
                LB:     nextstate <= EX_LS; 
                LBU:    nextstate <= EX_LS; 
                RTYPE:  nextstate <= EX_RTYPE;
                J:      nextstate <= EX_J;
                BNE:    nextstate <= EX_BNE;
                BEQ:    nextstate <= EX_BEQ;
                ADDI:   nextstate <= EX_ADDI;
                ANDI:   nextstate <= EX_ANDI;
                ORI:    nextstate <= EX_ORI; 
                SLTI:   nextstate <= EX_SLTI; 
                default:nextstate <= IF;
            endcase
            EX_LS: case(op)
                LW:     nextstate <= MEM_LW;
                SW:     nextstate <= MEM_SW;
                LBU:    nextstate <= MEM_LBU; 
                LB:     nextstate <= MEM_LB;
                default:nextstate <= IF;
            endcase
            MEM_LW:     nextstate <= WB_L;
            WB_L:       nextstate <= IF;
            MEM_SW:     nextstate <= IF;
            EX_RTYPE:   nextstate <= WB_RTYPE;
            WB_RTYPE:   nextstate <= IF;
            EX_BEQ:     nextstate <= IF;
            EX_BNE:     nextstate <= IF;
            EX_J:       nextstate <= IF;
            EX_ADDI:    nextstate <= WB_ADDI;
            WB_ADDI:    nextstate <= IF;
            EX_ANDI:    nextstate <= WB_ANDI; 
            WB_ANDI:    nextstate <= IF; 
            EX_ORI:     nextstate <= WB_ORI;
            WB_ORI:     nextstate <= IF;
            EX_SLTI:    nextstate <= WB_SLTI;
            WB_SLTI:    nextstate <= IF; 
            MEM_LBU:    nextstate <= WB_L;
            MEM_LB:     nextstate <= WB_L;
            default:    nextstate <= IF;
        endcase
    assign {pcwrite, memwrite, irwrite, regwrite,
            alusrca, branch, iord, memtoreg, regdst,
            bne, alusrcb, pcsrc, aluop, lb} = controls; 
    always_comb
        case(state)
            IF:         controls <= 20'b1010_00000_0_001_00_000_00;
            ID:         controls <= 20'b0000_00000_0_011_00_000_00;
            EX_LS:      controls <= 20'b0000_10000_0_010_00_000_00;
            MEM_LW:     controls <= 20'b0000_00100_0_000_00_000_00;
            WB_L:       controls <= 20'b0001_00010_0_000_00_000_00;
            MEM_SW:     controls <= 20'b0100_00100_0_000_00_000_00;
            EX_RTYPE:   controls <= 20'b0000_10000_0_000_00_010_00;
            WB_RTYPE:   controls <= 20'b0001_00001_0_000_00_000_00;
            EX_BEQ:     controls <= 20'b0000_11000_0_000_01_001_00;
            EX_BNE:     controls <= 20'b0000_10000_1_000_01_001_00;
            EX_J:       controls <= 20'b1000_00000_0_000_10_000_00;
            EX_ADDI:    controls <= 20'b0000_10000_0_010_00_000_00;
            WB_ADDI:    controls <= 20'b0001_00000_0_000_00_000_00;
            EX_ANDI:    controls <= 20'b0000_10000_0_100_00_011_00; 
            WB_ANDI:    controls <= 20'b0001_00000_0_000_00_000_00; 
            EX_ORI:     controls <= 20'b0000_10000_0_100_00_100_00; 
            WB_ORI:     controls <= 20'b0001_00000_0_000_00_000_00; 
            EX_SLTI:    controls <= 20'b0000_10000_0_010_00_101_00; 
            WB_SLTI:    controls <= 20'b0001_00000_0_000_00_000_00; 
            default:    controls <= 20'b0000_xxxxx_x_xxx_xx_xxx_xx;
        endcase
endmodule