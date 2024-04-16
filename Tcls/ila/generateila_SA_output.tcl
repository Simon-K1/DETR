set mulExit [lsearch -exact [get_ips ila_SA_output] ila_SA_output]
if { $mulExit <0} {
create_ip -name ila -vendor xilinx.com -library ip -module_name ila_SA_output
}
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9} CONFIG.C_PROBE0_WIDTH {96} CONFIG.C_PROBE1_WIDTH {96} CONFIG.C_PROBE2_WIDTH {96} CONFIG.C_PROBE3_WIDTH {96} CONFIG.C_PROBE4_WIDTH {96} CONFIG.C_PROBE5_WIDTH {96} CONFIG.C_PROBE6_WIDTH {96} CONFIG.C_PROBE7_WIDTH {96} CONFIG.C_PROBE8_WIDTH {8}  CONFIG.Component_Name {ila_SA_output}] [get_ips ila_SA_output]