module Top (
    input wire clk,                // 时钟信号
    input wire SW1,              // 重置信号
    input wire SW2,              // 暂停信号
    input wire ps2_clk,           // PS/2 时钟线
    input wire ps2_data,          // PS/2 数据线
    output wire beep,               // 蜂鸣器输出
    output wire [3:0] red_out,         // 红色输出
    output wire [3:0] green_out,       // 绿色输出
    output wire [3:0] blue_out,        // 蓝色输出
    output wire hor_sync,            // 水平同步信号
    output wire ver_sync,            // 垂直同步信号
    output seg_clk,               // 串行时钟输出
    output seg_clrn,              // 串行清除输出
    output seg_sout,              // 串行输出
    output seg_PEN              // 使能输出
);

    // 鼠标驱动模块
    wire [11:0] mouse_x_pos;        // 鼠标X坐标
    wire [11:0] mouse_y_pos;        // 鼠标Y坐标
    wire left_btn;                  // 鼠标左键状态
    wire right_btn;                 // 鼠标右键状态

    ps2_mouse_driver mouse_driver (
        .clk(clk),
        .reset(reset),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .x_pos(mouse_x_pos),
        .y_pos(mouse_y_pos),
        .left_btn(left_btn),
        .right_btn(right_btn)
    );

    // 蜂鸣器驱动模块
    wire [5:0] note;                // 音调信号

    buzzer_driver buzzer (
        .clk(clk),
        .note(note),
        .beep(beep)
    );

    // VGA驱动模块
    wire [11:0] pixel_data;         // 像素数据输出
    wire [10:0] row_address;
    wire [10:0] col_address;
    wire vga_clk;
    clk_wiz_vga clk_wiz_vga_inst (
        .clk_vga(vga_clk), // 25.125MHz
        .reset(1'b0),
        .locked(),
        .clk(clk)
    );

    vga_driver vga (
        .vga_clk(vga_clk),              // VGA时钟
        .reset(reset),              // 异步复位
        .pixel_data(pixel_data),    // 像素数据输入
        .row_address(row_address),   // 显存行地址
        .col_address(col_address),   // 显存列地址
        .read_pixel_n(0),             // 显存读取使能
        .red_out(red_out),           // 红色输出
        .green_out(green_out),       // 绿色输出
        .blue_out(blue_out),         // 蓝色输出
        .hor_sync(hor_sync),         // 水平同步信号
        .ver_sync(ver_sync)          // 垂直同步信号
    );

    // 七段数码管驱动模块
    wire [31:0] div_res;
    wire [31:0] seg_data;           // 数码管显示数据

    clkdiv u_clkdiv (
        .clk     (clk),
        .rst     (1'b0),
        .div_res (div_res)
    );

    Sseg_Dev u_Sseg_Dev (
        .clk     (clk),
        .start   (div_res[20]),
        .hexs    (seg_data),
        .points  (8'h00),
        .LEs     (8'h00),
        .sclk    (seg_clk),
        .sclrn   (seg_clrn),
        .sout    (seg_sout),
        .EN      (seg_PEN)
    );

    // 游戏逻辑模块
    game game_logic (
        .clk(clk),
        .clk_vga(vga_clk), // VGA时钟
        .reset(SW1),
        .is_pause(SW2),
        .x_pos(mouse_x_pos),
        .y_pos(mouse_y_pos),
        .seg_data(seg_data),
        .left_btn(left_btn),
        .right_btn(right_btn),
        .screen_row_address(row_address),
        .screen_col_address(col_address),
        .note(note),
        .pixel_data(pixel_data)
    );

endmodule