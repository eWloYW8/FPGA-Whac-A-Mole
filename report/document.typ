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

项目版本管理使用 Git 进行，代码托管在 #link("https://github.com/eWloYW8/FPGA-Whac-A-Mole")[#text(fill: rgb(0,0,255))[GitHub]] 上。

= 项目实现

== 系统架构

#align(center)[
  #image("assets/structure.drawio.svg", width: 80%)
]
