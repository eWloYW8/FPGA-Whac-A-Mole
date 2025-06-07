module mouse_vga_driver_test(
    input   clk,
    input   ps2_clk,
    input   ps2_data,
    input   BTN,
    output  seg_clk,
    output  seg_clrn,
    output  seg_sout,
    output  seg_PEN,
    output [3:0] red_out,
    output [3:0] green_out,
    output [3:0] blue_out,
    output hor_sync,
    output ver_sync
);

    wire [31:0] div_res;
    
    clkdiv u_clkdiv (
        .clk     (clk),
        .rst     (1'b0),
        .div_res (div_res)
    );

    wire [11:0] x_pos;
    wire [11:0] y_pos;
    wire left_btn;
    wire right_btn;

    ps2_mouse_driver u_ps2_mouse_driver (
        .clk     (clk),
        .reset   (BTN),
        .ps2_clk (ps2_clk),
        .ps2_data(ps2_data),
        .x_pos   (x_pos),
        .y_pos   (y_pos),
        .left_btn(left_btn),
        .right_btn(right_btn)
    );

    // Display the mouse position and button states on the 7-segment display
    wire [31:0] mouse_display_data = {
        3'b0, left_btn,
        3'b0, right_btn,
        x_pos[11:0],
        y_pos[11:0]
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


    wire vga_clk;
    clk_wiz_vga clk_wiz_vga_inst (
        .clk_vga(vga_clk), // 25.125MHz
        .reset(1'b0),
        .locked(),
        .clk(clk)
    );

    // VGA驱动接口信号
    wire [10:0] row_addr;
    wire [10:0] col_addr;
    wire read_pixel_n;
    wire [3:0] red, green, blue;
    wire [11:0] pixel_data;

    // 实例化VGA驱动模块
    vga_driver vga_inst (
        .vga_clk(vga_clk),
        .reset(BTN),
        .pixel_data(pixel_data),
        .row_address(row_addr),
        .col_address(col_addr),
        .read_pixel_n(read_pixel_n),
        .red_out(red),
        .green_out(green),
        .blue_out(blue),
        .hor_sync(hor_sync),
        .ver_sync(ver_sync)
    );

    // 连接VGA输出
    assign red_out = red;
    assign green_out = green;
    assign blue_out = blue;

    // 彩色条带生成
    assign pixel_data = 
        (col_addr > x_pos && col_addr < x_pos + 25 && 
         row_addr > y_pos && row_addr < y_pos + 25) ? 12'h888 : // 鼠标
        (col_addr < 100) ? 12'hF00 :  // 红色 (R=1111, G=0000, B=0000)
        (col_addr < 200) ? 12'h0F0 :  // 绿色 (R=0000, G=1111, B=0000)
        (col_addr < 300) ? 12'h00F :  // 蓝色 (R=0000, G=0000, B=1111)
        (col_addr < 400) ? 12'hFF0 :  // 黄色 (R=1111, G=1111, B=0000)
        (col_addr < 500) ? 12'hF0F :  // 紫色 (R=1111, G=0000, B=1111)
        (col_addr < 600) ? 12'h0FF :  // 青色 (R=0000, G=1111, B=1111)
                          12'hFFF;   // 白色 (R=1111, G=1111, B=1111)

endmodule