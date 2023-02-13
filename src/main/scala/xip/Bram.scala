package xip

// update_compile_order -fileset sources_1
// create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name blk_mem_gen_0 -dir e:/Transformer/Sim_Transformer/Sim_LayerNorm/Sim_LayerNormV1/Sim_LayerNormV1.srcs/sources_1/ip
// set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Write_Width_A {64} CONFIG.Write_Depth_A {512} CONFIG.Read_Width_A {64} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {64} CONFIG.Read_Width_B {64} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips blk_mem_gen_0]
// generate_target {instantiation_template} [get_files e:/Transformer/Sim_Transformer/Sim_LayerNorm/Sim_LayerNormV1/Sim_LayerNormV1.srcs/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0.xci]



// create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name Weight_Bram 
// set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Write_Width_A {64} CONFIG.Write_Depth_A {512} CONFIG.Read_Width_A {64} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {64} CONFIG.Read_Width_B {64} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips blk_mem_gen_0]


import spinal.core._
class xil_Bram extends Component{
    
}