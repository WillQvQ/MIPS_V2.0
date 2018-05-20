`timescale 1ns / 1ps

module aludec(
    input   logic [5:0] funct,
    input   logic [2:0] aluop,
    output  logic [2:0] alucontrol
);
    always_comb
        case(aluop)
            3'b000: alucontrol <= 3'b010; // add
            3'b001: alucontrol <= 3'b110; // sub
            3'b011: alucontrol <= 3'b000; // and
            3'b100: alucontrol <= 3'b001; // or
            3'b101: alucontrol <= 3'b111; // slt
            3'b010: case(funct) // RTYPE
                6'b100000: alucontrol <= 3'b010; // ADD
                6'b100010: alucontrol <= 3'b110; // SUB
                6'b100100: alucontrol <= 3'b000; // AND
                6'b100101: alucontrol <= 3'b001; // OR
                6'b101010: alucontrol <= 3'b111; // SLT
                default: alucontrol <= 3'bxxx; 
            endcase
            default: alucontrol <= 3'bxxx; 
        endcase
endmodule