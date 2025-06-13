module vga_driver (
    input        vga_clk,        // VGA 时钟 (25.125MHz)
    input        reset,        // 异步复位 (低电平有效)
    input [11:0] pixel_data,     // 像素数据 bbbb_gggg_rrrr
    output reg [8:0] row_address,  // 显存行地址 (480 行)
    output reg [9:0] col_address,  // 显存列地址 (640 列)
    output reg   read_pixel_n,   // 显存读取使能 (低电平有效)
    output reg [3:0] red_out,    // 红色输出
    output reg [3:0] green_out,  // 绿色输出
    output reg [3:0] blue_out,   // 蓝色输出
    output reg   hor_sync,       // 水平同步信号
    output reg   ver_sync        // 垂直同步信号
);

    // 水平计数器 (0-799)
    reg [9:0] hor_counter;
    // 垂直计数器 (0-524)
    reg [9:0] ver_counter;
    
    // 生成水平计数器
    always @(posedge vga_clk) begin
        if (!reset) begin
            hor_counter <= 10'd0;
        end
        else if (hor_counter == 10'd799) begin
            hor_counter <= 10'd0;
        end
        else begin 
            hor_counter <= hor_counter + 10'd1;
        end
    end

    // 生成垂直计数器
    always @(posedge vga_clk or negedge reset) begin
        if (!reset) begin
            ver_counter <= 10'd0;
        end
        else if (hor_counter == 10'd799) begin  // 每行结束时递增
            if (ver_counter == 10'd524) begin
                ver_counter <= 10'd0;
            end
            else begin
                ver_counter <= ver_counter + 10'd1;
            end
        end
    end

    // 计算显存坐标
    wire [9:0] mem_row = ver_counter - 10'd35;   // 垂直后沿偏移
    wire [9:0] mem_col = hor_counter - 10'd144;  // 水平后沿偏移

    // 生成控制信号
    wire       is_display_area = (hor_counter >= 10'd143) && 
                                (hor_counter <= 10'd782) && // 640 像素显示区
                                (ver_counter >= 10'd35)  && 
                                (ver_counter <= 10'd514);   // 480 行显示区
                                
    wire       hor_sync_sig = (hor_counter > 10'd95);  // 96-799: 有效水平同步
    wire       ver_sync_sig = (ver_counter > 10'd1);   // 2-524: 有效垂直同步

    // 驱动输出信号
    always @(posedge vga_clk) begin
        // 显存地址输出
        row_address <= mem_row[8:0];    // 取低9位 (0-511)
        col_address <= mem_col;         // 直接输出 (0-1023)
        
        // 控制信号输出
        read_pixel_n <= ~is_display_area;  // 显示区外禁用读取
        hor_sync     <= hor_sync_sig;
        ver_sync     <= ver_sync_sig;
        
        // RGB 数据输出 (非显示区输出黑色)
        red_out   <= read_pixel_n ? 4'd0 : pixel_data[3:0];
        green_out <= read_pixel_n ? 4'd0 : pixel_data[7:4];
        blue_out  <= read_pixel_n ? 4'd0 : pixel_data[11:8];
    end

endmodule