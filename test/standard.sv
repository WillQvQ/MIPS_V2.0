`timescale 1ns / 1ps

module simulation();
logic clk;
logic reset;
logic [31:0]writedata, dataadr;
logic       memwrite;
logic [5:0] pclow;
top top(clk, reset, writedata, dataadr, memwrite, datapc, pclow);
initial begin
       reset <= 1; #22; reset <= 0;
    end    
    always begin
        clk <= 1; #5 clk <= 0; #5;
    end
    always @(negedge clk) begin
        if (memwrite) begin
            if (dataadr === 84 & writedata === 7)begin
                $display("LOG:Simulation succeeded");
                $stop;
            end
            else if (dataadr !== 80) begin
                $display("LOG:Simulation failed");
                $stop;
            end 
        end
    end

endmodule  