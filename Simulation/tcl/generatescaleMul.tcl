set mulExit [lsearch -exact [get_ips scaleMul] scaleMul]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name scaleMul
}
set_property -dict [list CONFIG.PortAWidth {48} CONFIG.PortAType {signed} CONFIG.PortBWidth {32} CONFIG.PortBType {Unsigned} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {79} CONFIG.OutputWidthLow {48} CONFIG.PipeStages {8} ] [get_ips scaleMul] 
