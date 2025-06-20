`timescale 1ns / 1ps

module tb_P2S;

    parameter BIT_WIDTH = 7;
    reg clk = 0;
    reg start = 0;
    reg [BIT_WIDTH-1:0] par_in;
    wire sclk, sclrn, sout, EN;

    P2S #(BIT_WIDTH) uut (
        .clk(clk),
        .start(start),
        .par_in(par_in),
        .sclk(sclk),
        .sclrn(sclrn),
        .sout(sout),
        .EN(EN)
    );

    always #5 clk = ~clk;

    initial begin
        start = 0;
        par_in = 7'b0;

        #100;

        par_in = 7'b0101001;

        #10;
        start = 1;
        #10;
        start = 0;

        #200;

        par_in = 7'b0011100;
        #10;
        start = 1;
        #10;
        start = 0;

        #200;

    end
endmodule
