module vga_driver_test (
    input clk,
    output [3:0] red_out,    // 红色输出
    output [3:0] green_out,  // 绿色输出
    output [3:0] blue_out,   // 蓝色输出
    output hor_sync,       // 水平同步信号
    output ver_sync        // 垂直同步信号
);

    wire vga_clk;
    wire col_address;
    wire row_address;
    wire pixel_data = col_address >= 480 ? 12'hFFF : (col_address >= 320 ? 12'h0F0 : (col_address >= 160 ? 12'hF00 : 12'h00F)); // 简单的测试数据

    clk_wiz_vga clk_wiz_vga_inst (
        .clk_vga(vga_clk), // 25.125MHz
        .reset(1'b0),
        .locked(),
        .clk(clk)
    );

    vga_driver vga_driver_inst (
        .vga_clk(vga_clk),
        .reset(1'b0),
        .pixel_data(pixel_data), // 测试时使用固定像素数据
        .row_address(row_address),  // 显存行地址 (480 行)
        .col_address(col_address),  // 显存列地址 (640 列)
        .read_pixel_n(),
        .red_out(red_out),        // 红色输出
        .green_out(green_out),    // 绿色输出
        .blue_out(blue_out),      // 蓝色输出
        .hor_sync(hor_sync),       // 水平同步信号
        .ver_sync(ver_sync)        // 垂直同步信号
    );

endmodule