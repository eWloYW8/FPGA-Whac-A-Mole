#import "template.typ": *
#import "@preview/lovelace:0.3.0": *

#let cover_comments = {
  v(2em)
  tablex(
    columns: (0.7fr, 0.7fr, 1.68fr, 0.7fr),
    align: center + horizon,
    stroke: 0pt,
    inset: 0.5pt,
    "",
    _underlined_cell([组$space.quad space.quad$长：], color: white),
    _underlined_cell("易好"),
    "",
    "",
    _underlined_cell([学$space.quad space.quad$号：], color: white),
    _underlined_cell("3240104995"),
    "",
    "",
    _underlined_cell([组$space.quad space.quad$员：], color: white),
    _underlined_cell("杨诚伟"),
    "",
    "",
    _underlined_cell([学$space.quad space.quad$号：], color: white),
    _underlined_cell("3240105298"),
    "",
    "",
    _underlined_cell("完成日期：", color: white),
    _underlined_cell("2025 年 6 月 13 日"),
    "",
  )
}

#show: project.with(
  theme: "project",
  course: "《数字逻辑设计》课程设计报告",
  title: "基于 FPGA 的打地鼠游戏",
  date: "",
  author: "eWloYW8",
  semester: "",
  cover_comments: cover_comments,
)

= 项目概述

== 简介

本系统是基于FPGA平台实现的“打地鼠”电子游戏。通过鼠标实现互动，配合VGA显示器显示界面，复现街机游戏中经典的打地鼠场景。玩家根据地鼠出现的位置迅速作出反应进行打击。

== 使用说明

将比特流文件烧录到 FPGA 开发板上，连接好 PS/2 鼠标和 VGA 显示器。

显示器上会展示启动页面#footnote("由于无法直接对VGA屏幕截图，下面的图片为后期合成，仅供效果演示")：

#align(center)[
  #image("assets/before_start.png", width: 60%)
]

单击鼠标左键开始游戏，游戏界面如下：

#align(center)[
  #image("assets/game.png", width: 60%)
]

玩家可以通过鼠标移动锤子的指针位置，当地鼠出现时，点击鼠标左键进行打击。每次成功打击地鼠会增加分数，并播放相应的音效。游戏会随机生成地鼠出现的位置和时间。

玩家分数越高，地鼠出现的频率和速度会逐渐增加，游戏难度也会随之提升。分数足够时，游戏胜利结束，显示胜利画面：

#align(center)[
  #image("assets/win.png", width: 60%)
]

当玩家漏掉地鼠或未能及时打击，会扣除一条生命值。游戏开始时玩家有五条生命值，生命值耗尽后游戏结束，显示失败画面：

#align(center)[
  #image("assets/lose.png", width: 60%)
]

游戏胜利或失败结束后，玩家可以点击鼠标右键返回到启动页面，重新开始游戏。

#v(0.25fr)

除VGA屏幕外，本项目还使用了七段数码管显示游戏状态信息，包括当前速度等级、分数和剩余生命值等。数码管会实时更新。

具体信息如下：

#align(center)[
  #image("assets/segment.png", width: 60%)
]


== 硬件平台

本项目基于浙江大学东四教学楼 509 教室的 #link("http://sword.org.cn/hardwares/sword4.0")[SWORD 4.0] 平台开发，同时使用了 PS/2 鼠标、VGA 显示器等外设。

在本项目中，我们利用 SWORD 4.0 平台上集成的 Xilinx Kintex™-7 FPGA 作为核心处理单元，通过其丰富的 I/O 接口连接并控制外部设备。我们使用了 PS/2 鼠标作为用户输入设备，可接收用户的实时控制指令；VGA 显示器用于图形界面的输出展示。

== 开发环境与工具链

本项目采用 Vivado 2024.2 作为主要开发平台，所有模块均使用 Verilog HDL 编写。

图片资源的转换处理使用了 Python Pillow 库，生成适合 FPGA 处理的 coe 格式。

项目版本管理使用 Git 进行，代码托管在 #link("https://github.com/eWloYW8/FPGA-Whac-A-Mole")[#text(fill: rgb(0,0,255))[该项目的 GitHub 仓库]] 中。

报告使用 VSCode+Tinymist+#link("https://www.typst.app/")[#text(fill: rgb(0,0,255))[Typst]] 编写，报告中的结构图和流程图使用 #link("https://www.drawio.com/")[#text(fill: rgb(0,0,255))[draw.io]] 绘制。

#pagebreak()

= 项目实现

== 项目架构

本项目的架构如下图所示：

#align(center)[
  #image("assets/structure.drawio.svg", width: 80%)
]

项目主要分为以下几个模块：外设驱动、游戏主逻辑和音视频管理。

== 外设驱动

=== VGA 显示

VGA显示协议通过模拟信号配合同步信号来驱动显示器逐行扫描显示图像。图像数据以 RGB 信号传输，通过水平同步信号 hsync 和垂直同步信号 vsync 控制扫描时序。显示器按照从左到右、从上到下的顺序进行逐行扫描。整个过程中，图像内容一般存储在帧缓存中，按照 VGA 规定的分辨率和刷新频率，周期性地输出到显示设备上。

权衡图片资源的大小和 SWORD 板的 Block Memory 容量后，我们将游戏界面分辨率设置为 640x480。我们对实验文档中的 vgac 模块进行了简单改写作为 VGA 驱动，显示内容主要由后续的显示管理模块 Display Manager 进行控制。

=== PS/2 鼠标

为了实现鼠标输入，我对实验教室中的不同鼠标进行了大量尝试，发现不同鼠标经过开发板转换后的 PS/2 信号存在差异。最终找到了一个较为老旧的与 PS/2 鼠标标准协议较为接近的可用鼠标。

鼠标每次移动或操作时会连续发送三个字节的 PS/2 数据包：

#tablex(
  columns: (0.5fr, 0.5fr, 1.5fr, 1.5fr),
  align: (center, center, left, left),
  "字节", "位", "PS/2 鼠标标准", "实验室鼠标",
  1, 0, "左键状态；1 = 按下", "左键状态；1 = 按下",
  1, 1, "右键状态；1 = 按下", "右键状态；1 = 按下",
  1, 2, "中键状态；1 = 按下", "恒为0",
  1, 3, "保留", "恒为0",
  1, 4, "X 方向符号位；1 = 负", "恒为0",
  1, 5, "Y 方向符号位；1 = 负", "恒为0",
  1, 6, "保留", "恒为0",
  1, 7, "保留", "恒为0",
  2, "0–7", "X 方向位移量", "X 方向位移量（有符号整数）",
  3, "0–7", "Y 方向位移量", "Y 方向位移量（有符号整数）",
)

为了实现 PS/2 鼠标数据包的接收和解析，我编写了 PS2 Recorder 模块，该模块实际上是一个 PS/2 数据包上层的串进并出转换器。它接收三个 PS/2 信号后发出激活信号，使上层的 PS2 Mouse Driver 解析当前三个字节的数据包。

PS2 Mouse Driver 模块会根据 PS/2 鼠标协议解析数据包，它使用一个累加器将鼠标的位置信息转换为游戏界面坐标系下的像素位置。同时处理鼠标按键状态，供游戏逻辑模块使用。

=== 七段数码管

七段数码管的驱动采用了 #link("https://3200105455.pages.zjusct.io/2025_dd/labD/shift_register/")[#text(fill: rgb(0,0,255))[Lab D - Shift Register]] 中的七段数码管驱动模块，实际上就是对 P2S 模块的简单封装。

=== 蜂鸣器

蜂鸣器模块本身较为简单，蜂鸣器驱动模块只对 64 种常见音频频率进行了预设。具体音频播放逻辑由声音管理模块 Sound Manager 进行控制。

== 游戏主逻辑

游戏的主逻辑是一个有限状态机，为了便于表现，这里对它进行了高度简化，可以表示为下面的不严格的状态转移图：

#align(center)[
  #image("assets/pseudo-state-graph.drawio.svg")
]

由于具体的状态转移图较为复杂，这里只给出一个简化的版本。实际的状态转移图包含了更多细节，例如地鼠出现的具体位置、分数计算、生命值管理等。

该模块的实现主要位于 `game.v` 文件中。

== 音视频管理

=== 声音管理

声音管理模块负责处理游戏中的音效播放。它使用了一个简单的队列来存储正在播放的音频，并通过游戏状态的变化来触发不同的声音播放事件。

