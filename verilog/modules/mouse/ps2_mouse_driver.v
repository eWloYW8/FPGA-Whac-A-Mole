module ps2_mouse_driver (
    input clk,              // 系统时钟
    input reset,            // 同步复位，高电平有效
    input ps2_clk,          // PS/2 时钟线
    input ps2_data,         // PS/2 数据线
    output reg [11:0] x_pos, // 鼠标X坐标（0~639）
    output reg [11:0] y_pos, // 鼠标Y坐标（0~479）
    output reg [31:0] seg_data, // 七段数码管数据
    output reg left_btn,    // 鼠标左键
    output reg right_btn    // 鼠标右键
);

    localparam MAX_X = 12'd639; // X坐标最大值
    localparam MAX_Y = 12'd479;  // Y坐标最大值
    localparam INIT_X = 12'd320; // 初始X坐标
    localparam INIT_Y = 12'd240;  // 初始Y坐标

    wire [31:0] record; // 用于存储接收到的PS/2数据包
    wire finished; // 接收完成信号

    ps2_recorder recorder (
        .clk(clk),
        .reset(reset),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .record(record),
        .finished(finished)
    );

    reg prev_finished; // 上一个时钟周期的finished信号

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 复位：初始化坐标和按钮状态
            x_pos <= INIT_X;
            y_pos <= INIT_Y;
            left_btn <= 0;
            right_btn <= 0;
            prev_finished <= 0;
        end else begin
            // 检查是否完成接收数据包
            if (finished && !prev_finished) begin
                // 更新鼠标状态
                left_btn <= record[16];          // 左键状态
                right_btn <= record[17];         // 右键状态


                if (x_pos + $signed({{4{record[15]}}, record[15:8]}) > MAX_X && record[15] == 0) begin
                    x_pos <= MAX_X; // 限制X坐标不超过最大值
                end else if (x_pos + $signed({{4{record[15]}}, record[15:8]}) > MAX_X && record[15] == 1) begin
                    x_pos <= 0; // 限制X坐标不小于0
                end else begin
                    x_pos <= x_pos + $signed({{4{record[15]}}, record[15:8]});
                end

                if (y_pos + $signed({{4{record[7]}}, record[7:0]}) > MAX_Y && record[7] == 0) begin
                    y_pos <= MAX_Y; // 限制Y坐标不超过最大值
                end else if (y_pos + $signed({{4{record[7]}}, record[7:0]}) > MAX_Y && record[7] == 1) begin
                    y_pos <= 0; // 限制Y坐标不小于0
                end else begin
                    y_pos <= y_pos + $signed({{4{record[7]}}, record[7:0]});
                end

                // 限制坐标范围
                if ($signed(x_pos) > MAX_X) x_pos <= MAX_X;
                if ($signed(y_pos) > MAX_Y) y_pos <= MAX_Y;
                if ($signed(x_pos) < 0) x_pos <= 0;
                if ($signed(y_pos) < 0) y_pos <= 0;
            end
            
            prev_finished <= finished; // 更新上一个时钟周期的finished信号
        end
    end

endmodule