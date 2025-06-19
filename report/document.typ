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

#set par(justify: true, first-line-indent: 2em)

= 项目概述

== 简介

本系统是基于FPGA平台实现的“打地鼠”电子游戏。通过鼠标实现互动，配合VGA显示器显示界面，复现街机游戏中经典的打地鼠场景。玩家根据地鼠出现的位置迅速作出反应进行打击。

== 硬件平台

本项目基于浙江大学东四教学楼 509 教室的 #link("http://sword.org.cn/hardwares/sword4.0")[SWORD 4.0] 平台开发，同时使用了 PS/2 鼠标、VGA 显示器等外设。

在本项目中，我们利用 SWORD 4.0 平台上集成的 Xilinx Kintex™-7 FPGA 作为核心处理单元，通过其丰富的 I/O 接口连接并控制外部设备。我们使用了 PS/2 鼠标作为用户输入设备，可接收用户的实时控制指令；VGA 显示器用于图形界面的输出展示，实现了较为友好的人机交互。

== 开发环境与工具链

本项目采用 Vivado 2024.2 作为主要开发平台，所有模块均使用 Verilog HDL 编写