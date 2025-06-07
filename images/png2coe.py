from PIL import Image

def convert_image_to_coe(image_path, output_path, resize=None, mode="RGB"):
    """
    将图像转换为 Vivado COE 文件，支持 RGB 或 RGBA 格式（每通道保留高4位）。
    
    参数:
        image_path: str，输入图像路径。
        output_path: str，输出 COE 文件路径。
        resize: (width, height)，图像调整尺寸（如 640×480），不填则保持原图。
        mode: "RGB" 或 "RGBA"，决定每像素使用 12 位还是 16 位。
    """
    assert mode in ["RGB", "RGBA"], "mode 参数必须为 'RGB' 或 'RGBA'"
    
    img = Image.open(image_path).convert(mode)
    if resize:
        img = img.resize(resize)
    
    pixels = list(img.getdata())

    def pack_pixel(p):
        if mode == "RGB":
            r, g, b = p
            return ((r >> 4) << 8) | ((g >> 4) << 4) | (b >> 4)  # 12-bit
        else:
            r, g, b, a = p
            return ((r >> 4) << 12) | ((g >> 4) << 8) | ((b >> 4) << 4) | (a >> 4)  # 16-bit

    radix = 16
    with open(output_path, "w") as f:
        f.write(f"memory_initialization_radix={radix};\n")
        f.write("memory_initialization_vector=\n")

        for i, p in enumerate(pixels):
            val = pack_pixel(p)
            hex_width = 3 if mode == "RGB" else 4
            f.write(f"{val:0{hex_width}X}")
            f.write(",\n" if i != len(pixels) - 1 else ";\n")
    
    print(f"✅ 成功生成 {mode} 模式的 COE 文件：{output_path}")

# 示例用法：
if __name__ == "__main__":
    # 生成 RGB 12bit 格式 COE
    convert_image_to_coe("background.png", "background.coe", resize=(640, 480), mode="RGB")

    # 生成 RGBA 16bit 格式 COE
    convert_image_to_coe("title.png", "title.coe", resize=(300, 250), mode="RGBA")
