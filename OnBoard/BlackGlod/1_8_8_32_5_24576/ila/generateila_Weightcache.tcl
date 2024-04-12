set mulExit [lsearch -exact [get_ips ila_Weightcache] ila_Weightcache]
if { $mulExit <0} {
create_ip -name ila -vendor xilinx.com -library ip -module_name ila_Weightcache
}
set_property -dict [list CONFIG.C_NUM_OF_PROBES {9} CONFIG.C_PROBE0_WIDTH {8} CONFIG.C_PROBE1_WIDTH {16} CONFIG.C_PROBE2_WIDTH {3} CONFIG.C_PROBE3_WIDTH {16} CONFIG.C_PROBE4_WIDTH {16} CONFIG.C_PROBE5_WIDTH {8} CONFIG.C_PROBE6_WIDTH {1} CONFIG.C_PROBE7_WIDTH {1} CONFIG.C_PROBE8_WIDTH {4}  CONFIG.Component_Name {ila_Weightcache}] [get_ips ila_Weightcache]