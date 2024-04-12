set mulExit [lsearch -exact [get_ips ila_QuantModule] ila_QuantModule]
if { $mulExit <0} {
create_ip -name ila -vendor xilinx.com -library ip -module_name ila_QuantModule
}
set_property -dict [list CONFIG.C_NUM_OF_PROBES {2} CONFIG.C_PROBE0_WIDTH {64} CONFIG.C_PROBE1_WIDTH {1}  CONFIG.Component_Name {ila_QuantModule}] [get_ips ila_QuantModule]