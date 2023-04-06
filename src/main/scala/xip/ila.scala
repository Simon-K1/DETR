// package xip
// import spinal.core._
// import org.apache.commons.io.FileUtils
// import utils.Tcl_Config.Tcl_File_Path
// import java.io.File,java.io.PrintWriter//输出函数
// //一键生成ila，一键添加ilaimport spinal.core._

// // create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name TestIla -dir e:/Transformer/OnBoard/SystolicOnBoard/V3_Conv_OnBoard/V3_Conv_OnBoard.srcs/sources_1/ip
// // set_property -dict [list CONFIG.C_PROBE2_WIDTH {3} CONFIG.C_PROBE1_WIDTH {2} CONFIG.C_NUM_OF_PROBES {3} CONFIG.Component_Name {TestIla}] [get_ips TestIla]
// class xil_NativeIla(ProbeNum:Int,componentName: String,genTcl:Boolean) extends BlackBox{
//     //Xilinx 简单双口Bram
//     val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
//         val clk=in Bool()
//         val probe=in Vec(Bits(),ProbeNum)
//         // val enb=in Bool()        
//     }
//     noIoPrefix()
//     this.setDefinitionName(componentName)
//     mapClockDomain(clockDomain, io.clk)
    

//     if(genTcl){
//         FileUtils.forceMkdir(new File(Tcl_File_Path + File.separator + "tcl"))
//         val tclHeader = new PrintWriter(new File(Tcl_File_Path + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
//         val tcl_Cmd=s"create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name $componentName\n"+
//         s"set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} "+
//         s"CONFIG.Assume_Synchronous_Clk {true} "+
//         s"CONFIG.Write_Width_A {$inwidth} "+
//         s"CONFIG.Write_Depth_A {$indepth} "+
//         s"CONFIG.Read_Width_A {$inwidth} "+
//         s"CONFIG.Operating_Mode_A {NO_CHANGE} "+
//         s"CONFIG.Write_Width_B {$outwidth} "+
//         s"CONFIG.Read_Width_B {$outwidth} "+
//         s"CONFIG.Operating_Mode_B {READ_FIRST} "+
//         s"CONFIG.Enable_B {Always_Enabled} "+
//         s"CONFIG.Register_PortA_Output_of_Memory_Primitives {false} "+
//         s"CONFIG.Register_PortB_Output_of_Memory_Primitives {false} "+
//         s"CONFIG.Port_B_Clock {100} "+
//         s"CONFIG.Port_B_Enable_Rate {100}] "+
//         s"[get_ips $componentName]"
//         tclHeader.write(tcl_Cmd)
//         tclHeader.close()
//     }

// }