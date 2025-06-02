module P2S
    #(parameter BIT_WIDTH = 7) (
    input clk,
    input start,
    input [BIT_WIDTH-1:0] par_in,
    output sclk,
    output sclrn,
    output sout,
    output EN
);

    wire[BIT_WIDTH:0] Q;
    wire q;
    wire finish;

    SR_Latch SR_Latch(
        .S(start & finish),
        .R(~finish),
        .Q(q),
        .Qn()
    );

    ShiftReg #(.BIT_WIDTH(BIT_WIDTH+1)) ShiftReg (
        .clk(clk),
        .shiftn_loadp(q),
        .shift_in(1),
        .par_in({1'b0, par_in}),
        .Q(Q[BIT_WIDTH:0])
    );

    assign finish = &Q[BIT_WIDTH:1];

    assign EN = !start && finish;
    assign sclk = finish | ~clk;
    assign sclrn = 1'b1;
    assign sout = Q[0];

endmodule