set mulExit [lsearch -exact [get_ips Scale_Multiply_A] Scale_Multiply_A]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name Scale_Multiply_A
}
set_property -dict [list CONFIG.PortAWidth {32} CONFIG.PortAType {signed} CONFIG.PortBWidth {8} CONFIG.PortBType {signed} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {39} CONFIG.OutputWidthLow {0} CONFIG.PipeStages {4} ] [get_ips Scale_Multiply_A] 
