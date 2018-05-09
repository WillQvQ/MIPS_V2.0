`timescale 1ns / 1ps


module alu#(parameter N = 32)(
    input   logic [N-1:0] alu_a,alu_b,
    input   logic [2:0]   alu_control,
    output  logic [N-1:0] alu_y,
    output  logic         zero
);
    parameter S_OR = 3'b001;
    parameter S_AND = 3'b000;
    parameter S_PLUS = 3'b010;
    parameter S_UNUSED = 3'b011;
    parameter S_AND_NEG = 3'b100;
    parameter S_MINUS_NE = 3'b101;
    parameter S_MINUS = 3'b110;
    parameter S_STL = 3'b111;

    always_comb begin
        case(alu_control)
            S_AND:      alu_y = alu_a & alu_b;
            S_OR:       alu_y = alu_a | alu_b;
            S_PLUS:     alu_y = alu_a + alu_b;
            S_AND_NEG:  alu_y = alu_a &~alu_b;
            S_MINUS_NE: alu_y = (alu_a - alu_b == 0 )? 1 : 0;
            S_MINUS:    alu_y = alu_a - alu_b;
            S_STL:      alu_y = alu_a < alu_b;
            S_UNUSED:   alu_y = 0;
        endcase
    end
    assign zero = alu_y==0 ? 1 : 0;
endmodule