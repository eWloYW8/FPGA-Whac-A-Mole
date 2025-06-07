module vga_driver_test (
    input wire clk,            // 100MHz系统时钟
    input wire reset_n,        // 系统复位（高电平有效）
    output [3:0] red_out,    // 红色输出
    output [3:0] green_out,  // 绿色输出
    output [3:0] blue_out,   // 蓝色输出
    output hor_sync,       // 水平同步信号
    output ver_sync        // 垂直同步信号
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
        .reset(reset_n),
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
        (col_addr < 100) ? 12'hF00 :  // 红色 (R=1111, G=0000, B=0000)
        (col_addr < 200) ? 12'h0F0 :  // 绿色 (R=0000, G=1111, B=0000)
        (col_addr < 300) ? 12'h00F :  // 蓝色 (R=0000, G=0000, B=1111)
        (col_addr < 400) ? 12'hFF0 :  // 黄色 (R=1111, G=1111, B=0000)
        (col_addr < 500) ? 12'hF0F :  // 紫色 (R=1111, G=0000, B=1111)
        (col_addr < 600) ? 12'h0FF :  // 青色 (R=0000, G=1111, B=1111)
                          12'hFFF;   // 白色 (R=1111, G=1111, B=1111)

endmodule