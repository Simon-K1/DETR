set mulExit [lsearch -exact [get_ips Xq_Sum_Pow] Xq_Sum_Pow]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name Xq_Sum_Pow
}
set_property -dict [list CONFIG.PortAWidth {20} CONFIG.PortAType {signed} CONFIG.PortBWidth {20} CONFIG.PortBType {signed} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {39} CONFIG.OutputWidthLow {0} CONFIG.PipeStages {4} ] [get_ips Xq_Sum_Pow] 
