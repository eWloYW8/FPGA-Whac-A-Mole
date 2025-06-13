module image_reader_background_rgb #(
    parameter WIDTH = 640,
    parameter HEIGHT = 480
)(
    input  wire clk,
    input  wire [9:0]  x,       // X坐标 0~639
    input  wire [8:0]  y,       // Y坐标 0~479
    output reg  [11:0] pixel_rgb
);

    // 计算线性地址 y*WIDTH + x
    wire [18:0] addr;
    assign addr = y * WIDTH + x;

    // Block Memory 输出数据线
    wire [11:0] dout;

    // 实例化Block Memory IP
    blk_mem_gen_background u_bram (
        .clka(clk),
        .wea(1'b0),           // 关闭写使能，只读
        .addra(addr),
        .dina(12'b0),         // 不写数据
        .douta(dout)
    );

    always @(posedge clk) begin
        pixel_rgb <= dout;
    end

endmodule
