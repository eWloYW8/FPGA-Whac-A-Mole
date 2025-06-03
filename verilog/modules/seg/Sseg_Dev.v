module Sseg_Dev(
    input clk,
    input start,
    input [31:0] hexs,
    input [7:0] points,
    input [7:0] LEs,
    output sclk,
    output sclrn,
    output sout,
    output EN
);

    wire [63:0] seg_data;
    HexsTo8Seg u_HexsTo8Seg (
        .hexs(hexs),
        .points(points),
        .LEs(LEs),
        .seg_data(seg_data)
    );

    P2S #(.BIT_WIDTH(64)) u_P2S (
        .clk(clk),
        .start(start),
        .par_in(seg_data),
        .sclk(sclk),
        .sclrn(sclrn),
        .sout(sout),
        .EN(EN)
    );

endmodule