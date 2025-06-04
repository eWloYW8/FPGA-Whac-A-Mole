module game(
    input clk,        // 时钟信号
    input reset,      // 重置信号
    input [11:0] x_pos, // 鼠标X坐标
    input [11:0] y_pos, // 鼠标Y坐标
    input left_btn, // 鼠标左键
    input right_btn, // 鼠标右键
    input beep // 蜂鸣器
);

    wire [5:0] note; // 音调信号
    wire [11:0] mouse_click_mole; // 鼠标是否击中地鼠
    wire mouse_click_pausebutton; // 鼠标是否点击暂停按钮
    wire mouse_click; // 鼠标是否点击
    wire mouse_right_click; // 鼠标右键点击
    wire random_number; // 随机数生成器输出

    reg is_start; // 是否开始游戏
    reg is_pause; // 是否暂停游戏
    reg is_win; // 是否胜利
    reg [15:0] score; // 分数
    reg [15:0] time_left; // 剩余时间
    reg [11:0] mole_up; // 地鼠是否出现
    reg [3:0] level; // 游戏等级
    reg [2:0] live; // 生命值
    wire is_lose = (live == 0); // 是否失败
    
    // 主循环
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            is_start <= 0;
            is_pause <= 0;
            is_win <= 0;
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
            if (mouse_click_pausebutton) begin
                is_pause <= 0; // 继续游戏
            end
        end else if (!is_pause && mouse_click_pausebutton) begin
            is_pause <= 1; // 暂停游戏
        end else if (is_win || is_lose) begin
            if (mouse_click) begin
                is_start <= 0; // 重置游戏
                is_win <= 0; // 重置胜利状态
                score <= 0; // 重置分数
                time_left <= 0; // 重置时间
                mole_up <= 0; // 重置地鼠状态
                level <= 1; // 重置等级
                live <= 5; // 重置生命值
            end
        end else begin
            // 游戏进行中
            // 还没写完
        end
    end


    buzzer_driver buzzer_driver_inst (
        .clk(clk),
        .note(note),
        .beep(beep)
    );

    buzzer_controller buzzer_controller_inst (
        .clk(clk),
        .mouse_click_mole(mouse_click_mole),
        .mouse_click_pausebutton(mouse_click_pausebutton),
        .mouse_click(mouse_click),
        .is_win(is_win),
        .enabled(beep),
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
        .mouse_click_pausebutton(mouse_click_pausebutton),
        .mouse_click(mouse_click),
        .mouse_right_click(mouse_right_click)
    );

    random_generator random_generator_inst (
        .clk(clk),
        .max_value(6'd12), // 最大值为12，对应地鼠数量
        .random_number(random_number)
    );

endmodule