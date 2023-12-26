package xip

import spinal.core._
import org.apache.commons.io.FileUtils
import utils.Tcl_Config.Tcl_File_Path
import java.io.File,java.io.PrintWriter//输出函数
class xil_SimpleDualBram(inwidth:Int=8,indepth:Int=8,outwidth:Int=8,componentName: String,genTcl:Boolean,File_Path:String=Tcl_File_Path) extends BlackBox{
    //这个Bram tcl以后应该加入配置：用Bram搭还是lut搭
    //Xilinx 简单双口Bram
    val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
        val clka=in Bool()
        val addra=in UInt(log2Up(indepth) bits)
        val dina=in UInt(inwidth bits)
        val ena=in Bool()
        val wea=in Bool()
        val outdepth=(inwidth*indepth)/outwidth
        val addrb=in UInt(log2Up(outdepth) bits)
        val doutb=out UInt(outwidth bits)
        val clkb=in Bool()
        // val enb=in Bool()        
    }
    noIoPrefix()
    this.setDefinitionName(componentName)
    mapClockDomain(clockDomain, io.clka)
    mapCurrentClockDomain(io.clkb)

    if(genTcl){
        FileUtils.forceMkdir(new File(File_Path + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(File_Path + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        val tcl_Cmd=s"set mulExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$mulExit <0} {\n" +
            s"create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name $componentName\n" +
            s"}\n"+
        s"set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} "+
        s"CONFIG.Assume_Synchronous_Clk {true} "+
        s"CONFIG.Write_Width_A {$inwidth} "+
        s"CONFIG.Write_Depth_A {$indepth} "+
        s"CONFIG.Read_Width_A {$inwidth} "+
        s"CONFIG.Operating_Mode_A {NO_CHANGE} "+
        s"CONFIG.Write_Width_B {$outwidth} "+
        s"CONFIG.Read_Width_B {$outwidth} "+
        s"CONFIG.Operating_Mode_B {READ_FIRST} "+
        s"CONFIG.Enable_B {Always_Enabled} "+
        s"CONFIG.Register_PortA_Output_of_Memory_Primitives {false} "+
        s"CONFIG.Register_PortB_Output_of_Memory_Primitives {false} "+
        s"CONFIG.Port_B_Clock {100} "+
        s"CONFIG.Port_B_Enable_Rate {100}] "+
        s"[get_ips $componentName]"
        tclHeader.write(tcl_Cmd)
        tclHeader.close()
    }

}
class Fuck extends Component{
    val DGB=new xil_SimpleDualBram(64,64,64,"fuck",true)
    DGB.io.dina:=0
    DGB.io.addra:=0//写地址
    DGB.io.ena:=False
    DGB.io.wea:=True
    DGB.io.addrb:=0//读地址

}
object TestGen extends App { 
    val verilog_path="./testcode_gen" 
    
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Fuck)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}