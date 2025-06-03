module ps2_recorder_test(
    input   clk,
    input   ps2_clk,
    input   ps2_data,
    input   BTN,
    output  seg_clk,
    output  seg_clrn,
    output  seg_sout,
    output  seg_PEN
);

    wire [31:0] div_res;
    
    clkdiv u_clkdiv (
        .clk     (clk),
        .rst     (1'b0),
        .div_res (div_res)
    );

    wire [31:0] mouse_display_data;

    ps2_recorder u_ps2_recorder (
        .clk     (clk),
        .reset   (~BTN),
        .ps2_clk (ps2_clk),
        .ps2_data(ps2_data),
        .record  (mouse_display_data),
        .finished()
    );

    Sseg_Dev u_Sseg_Dev (
        .clk     (clk),
        .start   (div_res[20]),
        .hexs    (mouse_display_data),
        .points  (8'h00),
        .LEs     (8'h00),
        .sclk    (seg_clk),
        .sclrn   (seg_clrn),
        .sout    (seg_sout),
        .EN      (seg_PEN)
    );

endmodule