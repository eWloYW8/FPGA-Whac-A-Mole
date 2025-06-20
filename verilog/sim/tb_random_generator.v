`timescale 1ns / 1ps

module tb_random_generator;

    reg clk = 0;
    wire [15:0] random_number;

    random_generator uut (
        .clk(clk),
        .random_number(random_number)
    );

    always #5 clk = ~clk;

    initial begin

        #2000;

        $finish;
    end

endmodule
