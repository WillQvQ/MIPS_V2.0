`timescale 1ns / 1ps

module simulation();
    logic clk;
    logic reset;
    logic [31:0]writedata, dataadr;
    logic       memwrite;
    logic [31:0]datapc;
    logic [9:0] cnt;

    top top(clk, reset, writedata, dataadr, memwrite, readdata);
    
    initial begin
        cnt <= 7'b0;
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
//        cnt = cnt + 1;
//        if(cnt === 32)
//            $stop;
    end

endmodule  