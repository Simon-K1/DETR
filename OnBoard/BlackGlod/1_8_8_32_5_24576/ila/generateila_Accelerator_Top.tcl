set mulExit [lsearch -exact [get_ips ila_Accelerator_Top] ila_Accelerator_Top]
if { $mulExit <0} {
create_ip -name ila -vendor xilinx.com -library ip -module_name ila_Accelerator_Top
}
set_property -dict [list CONFIG.C_NUM_OF_PROBES {21} CONFIG.C_PROBE0_WIDTH {1} CONFIG.C_PROBE1_WIDTH {1} CONFIG.C_PROBE2_WIDTH {5} CONFIG.C_PROBE3_WIDTH {2} CONFIG.C_PROBE4_WIDTH {2} CONFIG.C_PROBE5_WIDTH {5} CONFIG.C_PROBE6_WIDTH {5} CONFIG.C_PROBE7_WIDTH {16} CONFIG.C_PROBE8_WIDTH {16} CONFIG.C_PROBE9_WIDTH {16} CONFIG.C_PROBE10_WIDTH {16} CONFIG.C_PROBE11_WIDTH {16} CONFIG.C_PROBE12_WIDTH {13} CONFIG.C_PROBE13_WIDTH {16} CONFIG.C_PROBE14_WIDTH {16} CONFIG.C_PROBE15_WIDTH {16} CONFIG.C_PROBE16_WIDTH {16} CONFIG.C_PROBE17_WIDTH {16} CONFIG.C_PROBE18_WIDTH {12} CONFIG.C_PROBE19_WIDTH {20} CONFIG.C_PROBE20_WIDTH {8}  CONFIG.Component_Name {ila_Accelerator_Top}] [get_ips ila_Accelerator_Top]