set mulExit [lsearch -exact [get_ips Scale_A_ReciproSqrt] Scale_A_ReciproSqrt]
if { $mulExit <0} {
create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name Scale_A_ReciproSqrt
}
set_property -dict [list CONFIG.PortAWidth {40} CONFIG.PortAType {signed} CONFIG.PortBWidth {24} CONFIG.PortBType {unsigned} CONFIG.Multiplier_Construction {Use_Mults} CONFIG.Use_Custom_Output_Width {true} CONFIG.OutputWidthHigh {63} CONFIG.OutputWidthLow {0} CONFIG.PipeStages {5} ] [get_ips Scale_A_ReciproSqrt] 
