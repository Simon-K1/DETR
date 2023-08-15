set addSubExit [lsearch -exact [get_ips AddZero] AddZero]
if { $addSubExit <0} {
create_ip -name c_addsub -vendor xilinx.com -library ip -version 12.0 -module_name AddZero
}
set_property -dict [list CONFIG.A_Width {16} CONFIG.A_Type {signed} CONFIG.B_Width {8} CONFIG.B_Type {Unsigned} CONFIG.CE {false} CONFIG.Add_Mode {Add} CONFIG.Implementation {Fabric} CONFIG.Out_Width {16} CONFIG.Latency {1} ] [get_ips AddZero] 
