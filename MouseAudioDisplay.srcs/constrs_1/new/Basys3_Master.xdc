set_property PACKAGE_PIN W5 [get_ports CLOCK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLOCK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLOCK]

set_property PACKAGE_PIN J1 [get_ports {JA[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[0]}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {JA[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[1]}]
#Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {JA[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[2]}]
#Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {JA[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {JA[3]}]

set_property PACKAGE_PIN U18 [get_ports btnC]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnC]

set_property PACKAGE_PIN V17 [get_ports {sw}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw}]