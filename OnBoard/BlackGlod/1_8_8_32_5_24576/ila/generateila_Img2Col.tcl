set mulExit [lsearch -exact [get_ips ila_Img2Col] ila_Img2Col]
if { $mulExit <0} {
create_ip -name ila -vendor xilinx.com -library ip -module_name ila_Img2Col
}
set_property -dict [list CONFIG.C_NUM_OF_PROBES {3} CONFIG.C_PROBE0_WIDTH {7} CONFIG.C_PROBE1_WIDTH {1} CONFIG.C_PROBE2_WIDTH {1}  CONFIG.Component_Name {ila_Img2Col}] [get_ips ila_Img2Col]