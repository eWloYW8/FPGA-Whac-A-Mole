module buzzer_controller(
    input wire clk,        // 时钟信号
    input wire [11:0] mouse_click_mole, // 鼠标是否击中地鼠
    input wire [11:0] mole_up, // 地鼠是否出现
    input wire mouse_click_pausebutton, // 鼠标是否点击暂停按钮
    input wire mouse_click, // 鼠标是否点击
    input wire is_win,
    input wire is_lose,
    input wire [2:0] live, // 生命值
    input wire enabled, // 蜂鸣器是否启用
    input wire reset, // 重置信号
    output reg [5:0] note // 6位音调，支持更多低音
);

    reg is_playing = 0; // 蜂鸣器是否正在播放
    reg prev_is_win = 0; // 上一帧是否胜利状态
    reg prev_is_lose = 0; // 上一帧是否失败状态
    reg [2:0] prev_live = 3'd0; // 上一帧的生命值
    
    reg [383:0] current_notelist; // 当前音符列表 384 = 64 * 6
    reg [383:0] current_notelist_length; // 当前音符列表长度

    reg [31:0] current_playtime; // 当前播放时间

    wire [31:0] div_res;

    clkdiv u_clkdiv (
        .clk(clk),
        .rst(reset),
        .div_res(div_res)
    );

    always @(posedge div_res[17]) begin
        if (reset) begin
            is_playing <= 0;
            note <= 6'd0;
            current_playtime <= 32'd0;
        end else if (enabled) begin
            if (is_playing) begin
                current_playtime <= current_playtime + 1;
                if (current_playtime >= current_notelist_length[5:0]) begin // 此处待分频
                    current_notelist_length <= current_notelist_length >> 6; // 每次播放完一段音符，长度右移6位，播放下一段
                    current_notelist <= current_notelist >> 6;
                    current_playtime <= 32'd0; // 重置播放时间
                    if (current_notelist_length == 0) begin
                        is_playing <= 0; // 如果没有音符了，停止播放
                        note <= 6'd0;
                    end else begin
                        note <= current_notelist[5:0]; // 获取当前音符
                    end
                end
            end else if (is_win && !prev_is_win) begin
                // 播放胜利音效
                is_playing <= 1;
                current_notelist <= {6'd10, 6'd10, 6'd11, 6'd11, 6'd12, 6'd12}; // 示例音符列表
                current_notelist_length <= {6'd60, 6'd60, 6'd60, 6'd60, 6'd60, 6'd60}; // 示例长度
                current_playtime <= 32'd0;
            end else if (is_lose && !prev_is_lose) begin
                // 播放失败音效
                is_playing <= 1;
                current_notelist <= {6'd12, 6'd12, 6'd11, 6'd11, 6'd10, 6'd10}; // 示例音符列表
                current_notelist_length <= {6'd60, 6'd60, 6'd60, 6'd60, 6'd60, 6'd60}; // 示例长度
                current_playtime <= 32'd0;
            end else if (|(mouse_click_mole & mole_up) != 0) begin
                is_playing <= 1;
                current_notelist <= {6'd6, 6'd5, 6'd4, 6'd3, 6'd2, 6'd1};
                current_notelist_length <= {6'd30, 6'd30, 6'd30, 6'd30, 6'd30, 6'd30}; // 示例长度
                current_playtime <= 32'd0;
            end else if (prev_live < live) begin
                is_playing <= 1;
                current_notelist <= {6'd1, 6'd2, 6'd3, 6'd4, 6'd5, 6'd6};
                current_notelist_length <= {6'd30, 6'd30, 6'd30, 6'd30, 6'd30, 6'd30}; // 示例长度
                current_playtime <= 32'd0;
            end else if (mouse_click) begin
                // 播放点击音效
                is_playing <= 1;
                current_notelist <= {6'd3, 6'd1, 6'd2}; // 示例音符列表
                current_notelist_length <= {6'd20, 6'd20, 6'd20}; // 示例长度
                current_playtime <= 32'd0;
            end else begin
                is_playing <= 0;
                note <= 6'd0;
            end
        end else begin
            is_playing <= 0;
            note <= 6'd0;
            current_playtime <= 32'd0;
        end
        prev_is_win <= is_win; // 更新上一帧的胜利状态
        prev_is_lose <= is_lose; // 更新上一帧的失败状态
        prev_live <= live; // 更新上一帧的生命值
    end

endmodule