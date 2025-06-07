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

# VGA
set_property -dict {PACKAGE_PIN T20  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {blue_out[0]}]
set_property -dict {PACKAGE_PIN R20  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {blue_out[1]}]
set_property -dict {PACKAGE_PIN T22  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {blue_out[2]}]
set_property -dict {PACKAGE_PIN T23  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {blue_out[3]}]

set_property -dict {PACKAGE_PIN R22  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {green_out[0]}]
set_property -dict {PACKAGE_PIN R23  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {green_out[1]}]
set_property -dict {PACKAGE_PIN T24  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {green_out[2]}]
set_property -dict {PACKAGE_PIN T25  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {green_out[3]}]

set_property -dict {PACKAGE_PIN N21  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {red_out[0]}]
set_property -dict {PACKAGE_PIN N22  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {red_out[1]}]
set_property -dict {PACKAGE_PIN R21  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {red_out[2]}]
set_property -dict {PACKAGE_PIN P21  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {red_out[3]}]

set_property -dict {PACKAGE_PIN M22  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {hor_sync}]
set_property -dict {PACKAGE_PIN M21  IOSTANDARD LVCMOS33  SLEW FAST} [get_ports {ver_sync}]