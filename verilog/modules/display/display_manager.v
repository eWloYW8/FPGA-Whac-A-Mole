module display_manager (
    input wire clk,
    input wire clk_vga, // VGA时钟
    input wire reset,
    input wire [9:0] mouse_x_pos,  // 鼠标X坐标
    input wire [8:0] mouse_y_pos,  // 鼠标Y坐标
    input wire is_start, // 是否开始游戏
    input wire is_pause, // 是否暂停游戏
    input wire [11:0] mole_up,  // 地鼠是否出现
    input wire [2:0] live,      // 生命值
    input wire is_win, // 是否胜利
    input wire is_lose, // 是否失败
    input wire [10:0] screen_row_address, // 屏幕行地址
    input wire [10:0] screen_col_address, // 屏幕列地址
    output wire [11:0] pixel_data // 像素数据输出（BGR格式）
);

    // 实例化背景图像读取模块
    image_reader_background_rgb u_background (
        .clk(clk_vga),
        .x(screen_col_address[9:0]),
        .y(screen_row_address[8:0]),
        .pixel_rgb({pixel_data[3:0], pixel_data[7:4], pixel_data[11:8]})
    );

endmodule



