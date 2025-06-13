module game(
    input clk,        // 时钟信号
    input reset,      // 重置信号
    input is_pause,      // 暂停信号
    input [11:0] x_pos, // 鼠标X坐标
    input [11:0] y_pos, // 鼠标Y坐标
    input left_btn, // 鼠标左键
    input right_btn, // 鼠标右键
    input clk_vga, // VGA时钟
    input [10:0] screen_row_address, // 屏幕行地址
    input [10:0] screen_col_address, // 屏幕列地址
    output [5:0] note, // 蜂鸣器
    output [31:0] seg_data, // 七段数码管数据
    output [11:0] pixel_data // 像素数据输出（bgr）
);

    wire [11:0] mouse_click_mole; // 鼠标是否击中地鼠
    wire mouse_click; // 鼠标是否点击
    wire mouse_right_click; // 鼠标右键点击
    wire [15:0] random_number; // 随机数生成器输出

    reg is_start; // 是否开始游戏
    reg [15:0] score; // 分数
    reg [31:0] time_left; // 剩余时间
    reg [11:0] mole_up; // 地鼠是否出现
    reg [3:0] level; // 游戏等级
    reg [2:0] live; // 生命值
    wire is_win = (level > 7); // 是否胜利
    wire is_lose = (live == 0); // 是否失败
    
    // 主循环
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            is_start <= 0;
            score <= 0;
            time_left <= 0; // 时间
            mole_up <= 0; // 地鼠初始状态为不出现
            level <= 1; // 初始等级为1
            live <= 5; // 初始生命值为5
        end else if (!is_start) begin
            if (mouse_click) begin
                is_start <= 1; // 开始游戏
            end
        end else if (is_pause) begin
             // 暂停状态下不进行任何操作
        end else if (is_win || is_lose) begin
            if (mouse_right_click) begin
                is_start <= 0; // 重置游戏
                score <= 0; // 重置分数
                time_left <= 0; // 重置时间
                mole_up <= 0; // 重置地鼠状态
                level <= 1; // 重置等级
                live <= 5; // 重置生命值
            end
        end else begin
            if (time_left > 0) begin
                time_left <= time_left - 1; // 每个时钟周期减少1
            end else begin
                if (|mole_up) begin
                    live <= live - 1; // 如果地鼠还在，生命值减少
                    mole_up <= 0; // 地鼠消失
                    time_left <= {(random_number % 50 + 25) / level, 22'b0}; // 重置时间
                end else begin
                    mole_up[random_number % 12] <= 1; // 随机出现一个地鼠
                    time_left <= {(random_number % 200 + 100) / level, 22'b0}; // 重置时间
                end
            end

            if (|(mouse_click_mole & mole_up)) begin
                // 如果鼠标点击地鼠且地鼠出现，增加分数
                score <= score + level * time_left[31:22];
                mole_up <= 0; // 地鼠消失
                time_left <= {(random_number % 50 + 25) / level, 22'b0}; // 重置时间
                if (score >= 300 * level) begin
                    level <= level + 1; // 升级
                end
            end
        end
    end

    buzzer_controller buzzer_controller_inst (
        .clk(clk),
        .score(score),
        .mouse_click(mouse_click),
        .is_win(is_win),
        .is_lose(is_lose),
        .live(live),
        .enabled(1), // 蜂鸣器启用
        .reset(reset),
        .note(note)
    );

    mouse_monitor mouse_monitor_inst (
        .clk(clk),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .left_btn(left_btn),
        .right_btn(right_btn),
        .mouse_click_mole(mouse_click_mole),
        .mouse_click(mouse_click),
        .mouse_right_click(mouse_right_click)
    );

    random_generator random_generator_inst (
        .clk(clk),
        .random_number(random_number)
    );

    display_manager display_manager_inst (
        .clk(clk),
        .clk_vga(clk_vga),
        .reset(reset),
        .mouse_x_pos(x_pos),
        .mouse_y_pos(y_pos),
        .is_start(is_start),
        .is_pause(is_pause),
        .mole_up(mole_up),
        .live(live),
        .is_win(is_win),
        .is_lose(is_lose),
        .screen_row_address(screen_row_address),
        .screen_col_address(screen_col_address),
        .pixel_data(pixel_data)
    );

    assign seg_data = {
        level,
        1'b0, live,
        8'b0,
        score
    };

endmodule