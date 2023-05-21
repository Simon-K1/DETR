set mulExit [lsearch -exact [get_ips XqC] XqC]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name XqC
}
set_property -dict [list CONFIG.PortAWidth {19} CONFIG.PortAType {signed} CONFIG.PortBWidth {12} CONFIG.PortBType {unsigned} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {30} CONFIG.OutputWidthLow {0} CONFIG.PipeStages {3} ] [get_ips XqC] 
