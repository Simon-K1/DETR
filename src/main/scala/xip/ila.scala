package xip

import spinal.core._
import org.apache.commons.io.FileUtils
import utils.Tcl_Config.Tcl_File_Path
import java.io.File,java.io.PrintWriter//输出函数
//写一个自动生成ila的模块
class xil_ila(ports:Array[Bits],genTcl:Boolean=false,componentName: String="NoName") extends BlackBox{
    val probe = Array.ofDim[Bits](ports.length)
    for(i<-0 to ports.length-1){
        probe(i)=Bits(ports(i).getBitsWidth bits).asInput()
        probe(i).setName("probe"+i)
    }
    val clk=in Bool()  
    mapClockDomain(clock = clk)
    if(genTcl){
    // create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name My_New_ila 
    // set_property -dict [list CONFIG.C_PROBE2_WIDTH {10} CONFIG.C_PROBE1_WIDTH {9} CONFIG.C_PROBE0_WIDTH {8} CONFIG.C_NUM_OF_PROBES {3} CONFIG.Component_Name {My_New_ila}] [get_ips My_New_ila
        var probes_config="";
        for(i<-0 to ports.length-1){
            probes_config=probes_config+s"CONFIG.C_PROBE${i}_WIDTH {${ports(i).getBitsWidth}} "
        }

        FileUtils.forceMkdir(new File(Tcl_File_Path + File.separator + "ila"))
        val tclHeader = new PrintWriter(new File(Tcl_File_Path + File.separator + "ila" + File.separator + s"generate$componentName.tcl"))
        val tcl_Cmd=s"set mulExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$mulExit <0} {\n" +
            s"create_ip -name ila -vendor xilinx.com -library ip -module_name $componentName\n" +
            s"}\n"+
        s"set_property -dict [list CONFIG.C_NUM_OF_PROBES {${ports.length}} "+probes_config+s" CONFIG.Component_Name {$componentName}"+
        s"] [get_ips $componentName]"//每一个[]之间都要加一个空格，这需要注意
        tclHeader.write(tcl_Cmd)
        tclHeader.close()
    }
    setDefinitionName(componentName)

}


class ila_test extends Component{
    val io=new Bundle{
        val gpio_in=in Bits(3 bits)
        val cnt    =out UInt(32 bits)
    }
    val valid=io.gpio_in(0)//当改valid拉高，则计数器开始计数
    val restart=io.gpio_in(1)
    val cnt=Reg(UInt(32 bits))init(0)
    when(valid){
        cnt:=cnt+1
    }elsewhen(io.gpio_in(2)){
        cnt:=0
    }elsewhen(restart){
        cnt:=0//复位
    }
    io.cnt:=cnt

    val Debug_Signals=Array[Bits](io.gpio_in,restart.asBits,cnt.asBits)
    val ila_test=new xil_ila(Debug_Signals,true,"ila_test")
    for(i<-0 to Debug_Signals.length-1){
        ila_test.probe(i):=Debug_Signals(i)
    }

}

object ila_gen extends App { 
    val verilog_path="./testcode_gen" 
    
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ila_test)
}
