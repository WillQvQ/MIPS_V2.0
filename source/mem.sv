`timescale 1ns / 1ps

module mem#(parameter N = 32, L = 64)(
    input   logic           clk, we,
    input   logic [N-1:0]   a, wd,
    output  logic [N-1:0]   rd
);
    logic [N-1:0] RAM [L-1:0];
    initial
        $readmemh("C:/Users/will131/Documents/workspace/MIPS_V2.0/memfile.dat",RAM);
    assign rd = RAM[a[N-1:2]];
    always @(posedge clk)
        if (we)
            RAM[a[N-1:2]] <= wd;
endmodule