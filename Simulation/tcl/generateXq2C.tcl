set mulExit [lsearch -exact [get_ips Xq2C] Xq2C]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name Xq2C
}
set_property -dict [list CONFIG.PortAWidth {31} CONFIG.PortAType {signed} CONFIG.PortBWidth {19} CONFIG.PortBType {signed} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {49} CONFIG.OutputWidthLow {0} CONFIG.PipeStages {3} ] [get_ips Xq2C] 
