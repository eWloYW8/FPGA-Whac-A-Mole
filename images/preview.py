from PIL import Image

def convert_to_12bit_640x480(input_path, output_path):
    # 打开图片并转换为RGB模式
    img = Image.open(input_path).convert("RGBA")
    # 调整分辨率为640x480
    img = img.resize((300, 250), Image.Resampling.LANCZOS)

    # 保存图片
    img.save(output_path)
    print(f"Converted 12bit image saved as {output_path}")

if __name__ == "__main__":
    import os
    for i in os.listdir('.'):
        if i.endswith('.png') and not i.startswith('12bit_') and not i.startswith('640x480_'):
            output_file_640x480 = f"300x250_{i}"
            convert_to_12bit_640x480(i, output_file_640x480)
            print(f"Processed {i} -> {output_file_640x480}")
