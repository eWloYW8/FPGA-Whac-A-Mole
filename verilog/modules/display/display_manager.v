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
    input wire [10:0] screen_col_address, // 屏幕列地址
    input wire [10:0] screen_row_address, // 屏幕行地址
    output wire [11:0] pixel_data // 像素数据输出（BGR格式）
);

    reg [71:0] mole_height = 72'h000000000000000000000000; // 地鼠高度，72位表示12个地鼠的高度

    wire [31:0] div_res;
    
    clkdiv u_clkdiv (
        .clk(clk),
        .rst(reset),
        .div_res(div_res)
    );

    always @(posedge div_res[17] or posedge reset) begin
        if (reset) begin
            mole_height <= 72'h000000000000000000000000; // 重置地鼠高度
        end else if (!is_pause) begin
            if (mole_up[0] && mole_height[5 : 0] != 8'd40) begin
                mole_height[5 : 0] <= mole_height[5 : 0] + 6'h1; // 地鼠上升
            end else if (!mole_up[0] && mole_height[5 : 0] != 4'h0) begin
                mole_height[5 : 0] <= mole_height[5 : 0] - 6'h1; // 地鼠下降
            end
            if (mole_up[1] && mole_height[11 : 6] != 8'd40) begin
                mole_height[11 : 6] <= mole_height[11 : 6] + 6'h1; // 地鼠上升
            end else if (!mole_up[1] && mole_height[11 : 6] != 4'h0) begin
                mole_height[11 : 6] <= mole_height[11 : 6] - 6'h1; // 地鼠下降
            end
            if (mole_up[2] && mole_height[17 : 12] != 8'd40) begin
                mole_height[17 : 12] <= mole_height[17 : 12] + 6'h1; // 地鼠上升
            end else if (!mole_up[2] && mole_height[17 : 12] != 4'h0) begin
                mole_height[17 : 12] <= mole_height[17 : 12] - 6'h1; // 地鼠下降
            end
            if (mole_up[3] && mole_height[23 : 18] != 8'd40) begin
                mole_height[23 : 18] <= mole_height[23 : 18] + 6'h1; // 地鼠上升
            end else if (!mole_up[3] && mole_height[23 : 18] != 4'h0) begin
                mole_height[23 : 18] <= mole_height[23 : 18] - 6'h1; // 地鼠下降
            end
            if (mole_up[4] && mole_height[29 : 24] != 8'd40) begin
                mole_height[29 : 24] <= mole_height[29 : 24] + 6'h1; // 地鼠上升
            end else if (!mole_up[4] && mole_height[29 : 24] != 4'h0) begin
                mole_height[29 : 24] <= mole_height[29 : 24] - 6'h1; // 地鼠下降
            end
            if (mole_up[5] && mole_height[35 : 30] != 8'd40) begin
                mole_height[35 : 30] <= mole_height[35 : 30] + 6'h1; // 地鼠上升
            end else if (!mole_up[5] && mole_height[35 : 30] != 4'h0) begin
                mole_height[35 : 30] <= mole_height[35 : 30] - 6'h1; // 地鼠下降
            end
            if (mole_up[6] && mole_height[41 : 36] != 8'd40) begin
                mole_height[41 : 36] <= mole_height[41 : 36] + 6'h1; // 地鼠上升
            end else if (!mole_up[6] && mole_height[41 : 36] != 4'h0) begin
                mole_height[41 : 36] <= mole_height[41 : 36] - 6'h1; // 地鼠下降
            end
            if (mole_up[7] && mole_height[47 : 42] != 8'd40) begin
                mole_height[47 : 42] <= mole_height[47 : 42] + 6'h1; // 地鼠上升
            end else if (!mole_up[7] && mole_height[47 : 42] != 4'h0) begin
                mole_height[47 : 42] <= mole_height[47 : 42] - 6'h1; // 地鼠下降
            end
            if (mole_up[8] && mole_height[53 : 48] != 8'd40) begin
                mole_height[53 : 48] <= mole_height[53 : 48] + 6'h1; // 地鼠上升
            end else if (!mole_up[8] && mole_height[53 : 48] != 4'h0) begin
                mole_height[53 : 48] <= mole_height[53 : 48] - 6'h1; // 地鼠下降
            end
            if (mole_up[9] && mole_height[59 : 54] != 8'd40) begin
                mole_height[59 : 54] <= mole_height[59 : 54] + 6'h1; // 地鼠上升
            end else if (!mole_up[9] && mole_height[59 : 54] != 4'h0) begin
                mole_height[59 : 54] <= mole_height[59 : 54] - 6'h1; // 地鼠下降
            end
            if (mole_up[10] && mole_height[65 : 60] != 8'd40) begin
                mole_height[65 : 60] <= mole_height[65 : 60] + 6'h1; // 地鼠上升
            end else if (!mole_up[10] && mole_height[65 : 60] != 4'h0) begin
                mole_height[65 : 60] <= mole_height[65 : 60] - 6'h1; // 地鼠下降
            end
            if (mole_up[11] && mole_height[71 : 66] != 8'd40) begin
                mole_height[71 : 66] <= mole_height[71 : 66] + 6'h1; // 地鼠上升
            end else if (!mole_up[11] && mole_height[71 : 66] != 4'h0) begin
                mole_height[71 : 66] <= mole_height[71 : 66] - 6'h1; // 地鼠下降
            end
        end
    end

    wire [11:0] background_data; // RGB

    // 实例化背景图像读取模块
    image_reader_background_rgb u_background (
        .clk(clk_vga),
        .x(screen_col_address[9:0]),
        .y(screen_row_address[8:0]),
        .pixel_rgb(background_data)
    );

    wire [15:0] title_data; // RGBA

    image_reader_title_rgba u_title (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd165),
        .y(screen_row_address[8:0] - 9'd70),
        .pixel_rgba(title_data)
    );

    wire [11:0] mixed_1 = (screen_col_address >= 11'd170 && screen_col_address < 11'd465 && screen_row_address >= 11'd70 && screen_row_address < 11'd320 && title_data[3:0] > 4'h7 && !is_start) ? 
    title_data[15:4] : background_data;




    wire [15:0] golang_logo_data_0; // RGBA
    wire [15:0] golang_logo_data_1; // RGBA
    wire [15:0] golang_logo_data_2; // RGBA
    wire [15:0] golang_logo_data_3; // RGBA
    wire [15:0] golang_logo_data_4; // RGBA
    wire [15:0] golang_logo_data_5; // RGBA
    wire [15:0] golang_logo_data_6; // RGBA
    wire [15:0] golang_logo_data_7; // RGBA
    wire [15:0] golang_logo_data_8; // RGBA
    wire [15:0] golang_logo_data_9; // RGBA
    wire [15:0] golang_logo_data_10; // RGBA
    wire [15:0] golang_logo_data_11; // RGBA

    image_reader_gologo_rgba u_gologo_0 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd108),
        .y(screen_row_address[8:0] - 9'd307 + mole_height[5:0]),
        .pixel_rgba(golang_logo_data_0)
    );

    wire [15:0] mixed_2_0 = (screen_col_address >= 11'd111 && screen_col_address < 11'd153 && screen_row_address >= 11'd307 - mole_height[5:0] && screen_row_address < 11'd307 && golang_logo_data_0[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_0[15:4] : mixed_1;

    image_reader_gologo_rgba u_gologo_1 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd227),
        .y(screen_row_address[8:0] - 9'd307 + mole_height[11:6]),
        .pixel_rgba(golang_logo_data_1)
    );

    wire [15:0] mixed_2_1 = (screen_col_address >= 11'd230 && screen_col_address < 11'd272 && screen_row_address >= 11'd307 - mole_height[11:6] && screen_row_address < 11'd307 && golang_logo_data_1[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_1[15:4] : mixed_2_0;

    image_reader_gologo_rgba u_gologo_2 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd346),
        .y(screen_row_address[8:0] - 9'd307 + mole_height[17:12]),
        .pixel_rgba(golang_logo_data_2)
    );

    wire [15:0] mixed_2_2 = (screen_col_address >= 11'd349 && screen_col_address < 11'd391 && screen_row_address >= 11'd307 - mole_height[17:12] && screen_row_address < 11'd307 && golang_logo_data_2[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_2[15:4] : mixed_2_1;

    image_reader_gologo_rgba u_gologo_3 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd465),
        .y(screen_row_address[8:0] - 9'd307 + mole_height[23:18]),
        .pixel_rgba(golang_logo_data_3)
    );

    wire [15:0] mixed_2_3 = (screen_col_address >= 11'd468 && screen_col_address < 11'd510 && screen_row_address >= 11'd307 - mole_height[23:18] && screen_row_address < 11'd307 && golang_logo_data_3[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_3[15:4] : mixed_2_2;

    image_reader_gologo_rgba u_gologo_4 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd95),
        .y(screen_row_address[8:0] - 9'd352 + mole_height[29:24]),
        .pixel_rgba(golang_logo_data_4)
    );

    wire [15:0] mixed_2_4 = (screen_col_address >= 11'd98 && screen_col_address < 11'd140 && screen_row_address >= 11'd352 - mole_height[29:24] && screen_row_address < 11'd352 && golang_logo_data_4[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_4[15:4] : mixed_2_3;

    image_reader_gologo_rgba u_gologo_5 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd223),
        .y(screen_row_address[8:0] - 9'd352 + mole_height[35:30]),
        .pixel_rgba(golang_logo_data_5)
    );

    wire [15:0] mixed_2_5 = (screen_col_address >= 11'd226 && screen_col_address < 11'd268 && screen_row_address >= 11'd352 - mole_height[35:30] && screen_row_address < 11'd352 && golang_logo_data_5[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_5[15:4] : mixed_2_4;

    image_reader_gologo_rgba u_gologo_6 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd351),
        .y(screen_row_address[8:0] - 9'd352 + mole_height[41:36]),
        .pixel_rgba(golang_logo_data_6)
    );

    wire [15:0] mixed_2_6 = (screen_col_address >= 11'd354 && screen_col_address < 11'd396 && screen_row_address >= 11'd352 - mole_height[41:36] && screen_row_address < 11'd352 && golang_logo_data_6[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_6[15:4] : mixed_2_5;

    image_reader_gologo_rgba u_gologo_7 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd480),
        .y(screen_row_address[8:0] - 9'd352 + mole_height[47:42]),
        .pixel_rgba(golang_logo_data_7)
    );

    wire [15:0] mixed_2_7 = (screen_col_address >= 11'd483 && screen_col_address < 11'd525 && screen_row_address >= 11'd352 - mole_height[47:42] && screen_row_address < 11'd352 && golang_logo_data_7[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_7[15:4] : mixed_2_6;

    image_reader_gologo_rgba u_gologo_8 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd77),
        .y(screen_row_address[8:0] - 9'd406 + mole_height[53:48]),
        .pixel_rgba(golang_logo_data_8)
    );

    wire [15:0] mixed_2_8 = (screen_col_address >= 11'd80 && screen_col_address < 11'd122 && screen_row_address >= 11'd406 - mole_height[53:48] && screen_row_address < 11'd406 && golang_logo_data_8[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_8[15:4] : mixed_2_7;

    image_reader_gologo_rgba u_gologo_9 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd218),
        .y(screen_row_address[8:0] - 9'd406 + mole_height[59:54]),
        .pixel_rgba(golang_logo_data_9)
    );

    wire [15:0] mixed_2_9 = (screen_col_address >= 11'd221 && screen_col_address < 11'd263 && screen_row_address >= 11'd406 - mole_height[59:54] && screen_row_address < 11'd406 && golang_logo_data_9[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_9[15:4] : mixed_2_8;

    image_reader_gologo_rgba u_gologo_10 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd357),
        .y(screen_row_address[8:0] - 9'd406 + mole_height[65:60]),
        .pixel_rgba(golang_logo_data_10)
    );

    wire [15:0] mixed_2_10 = (screen_col_address >= 11'd360 && screen_col_address < 11'd402 && screen_row_address >= 11'd406 - mole_height[65:60] && screen_row_address < 11'd406 && golang_logo_data_10[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_10[15:4] : mixed_2_9;

    image_reader_gologo_rgba u_gologo_11 (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd498),
        .y(screen_row_address[8:0] - 9'd406 + mole_height[71:66]),
        .pixel_rgba(golang_logo_data_11)
    );

    wire [15:0] mixed_2_11 = (screen_col_address >= 11'd501 && screen_col_address < 11'd543 && screen_row_address >= 11'd406 - mole_height[71:66] && screen_row_address < 11'd406 && golang_logo_data_11[3:0] > 4'h7 && is_start && !is_lose && !is_win) ?
    golang_logo_data_11[15:4] : mixed_2_10;



    wire [15:0] win_data; // RGBA

    image_reader_win_rgba u_win (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd165),
        .y(screen_row_address[8:0] - 9'd50),
        .pixel_rgba(title_data)
    );

    wire [11:0] mixed_3 = (screen_col_address >= 11'd170 && screen_col_address < 11'd465 && screen_row_address >= 11'd50 && screen_row_address < 11'd350 && title_data[3:0] > 4'h7 && is_win) ? 
    title_data[15:4] : mixed_2_11;


    wire [15:0] failed_data; // RGBA

    image_reader_failed_rgba u_failed (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - 10'd165),
        .y(screen_row_address[8:0] - 9'd50),
        .pixel_rgba(title_data)
    );

    wire [11:0] mixed_4 = (screen_col_address >= 11'd170 && screen_col_address < 11'd465 && screen_row_address >= 11'd50 && screen_row_address < 11'd350 && title_data[3:0] > 4'h7 && is_lose) ? 
    title_data[15:4] : mixed_3;


    wire [15:0] hammer_data; // RGBA

    image_reader_hammer_rgba u_hammer (
        .clk(clk_vga),
        .x(screen_col_address[9:0] - mouse_x_pos[9:0] + 10'd7),
        .y(screen_row_address[8:0] - mouse_y_pos[8:0] + 9'd15),
        .pixel_rgba(hammer_data)
    );

    wire [11:0] mixed_5 = (screen_col_address >= mouse_x_pos - 5 && screen_col_address < mouse_x_pos + 23 && screen_row_address >= mouse_y_pos - 15 && screen_row_address < mouse_y_pos + 15 && hammer_data[3:0] > 4'h7) ?
    hammer_data[15:4] : mixed_2_11;

    assign pixel_data = { 
        mixed_3[3:0],   // B
        mixed_3[7:4],   // G
        mixed_3[11:8]   // R
    };

endmodule
