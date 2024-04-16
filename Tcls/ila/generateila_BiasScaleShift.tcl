set mulExit [lsearch -exact [get_ips ila_BiasScaleShift] ila_BiasScaleShift]
if { $mulExit <0} {
create_ip -name ila -vendor xilinx.com -library ip -module_name ila_BiasScaleShift
}
set_property -dict [list CONFIG.C_NUM_OF_PROBES {4} CONFIG.C_PROBE0_WIDTH {384} CONFIG.C_PROBE1_WIDTH {256} CONFIG.C_PROBE2_WIDTH {128} CONFIG.C_PROBE3_WIDTH {64}  CONFIG.Component_Name {ila_BiasScaleShift}] [get_ips ila_BiasScaleShift]