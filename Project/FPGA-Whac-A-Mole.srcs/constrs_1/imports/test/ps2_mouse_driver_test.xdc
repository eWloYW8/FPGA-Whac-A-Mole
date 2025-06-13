# Main clock
set_property PACKAGE_PIN AC18 [get_ports clk]
set_property IOSTANDARD LVCMOS18 [get_ports clk]

create_clock -period 10.000 -name clk [get_ports "clk"]

# Seven Segment Display
set_property PACKAGE_PIN M24 [get_ports {seg_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_clk}]
set_property PACKAGE_PIN M20 [get_ports {seg_clrn}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_clrn}]
set_property PACKAGE_PIN L24 [get_ports {seg_sout}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_sout}]
set_property PACKAGE_PIN R18 [get_ports {seg_PEN}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg_PEN}]

# PS/2 Interface
set_property PACKAGE_PIN N18 [get_ports ps2_clk]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_clk]
set_property PACKAGE_PIN M19 [get_ports ps2_data]
set_property IOSTANDARD LVCMOS33 [get_ports ps2_data]

# Switches
set_property PACKAGE_PIN AA10 [get_ports {BTN}]
set_property IOSTANDARD LVCMOS15 [get_ports {BTN}]