module mouse_test(
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

    wire [9:0] x_pos;
    wire [9:0] y_pos;
    wire left_btn;
    wire right_btn;

    ps2_mouse_driver u_ps2_mouse_driver (
        .clk     (clk),
        .reset   (~BTN),
        .ps2_clk (ps2_clk),
        .ps2_data(ps2_data),
        .x_pos   (x_pos),
        .y_pos   (y_pos),
        .left_btn(left_btn),
        .right_btn(right_btn)
    );

    // Display the mouse position and button states on the 7-segment display
    wire [31:0] mouse_display_data = {
        3'b0, left_btn,         // bit 31: left_btn
        3'b0, right_btn,        // bit 27: right_btn
        2'b0, x_pos[9:0],       // bits 25:16: x_pos
        2'b0, y_pos[9:0]        // bits 15:7: y_pos
    };
    
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