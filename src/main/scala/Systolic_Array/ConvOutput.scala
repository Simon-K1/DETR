package Systolic_Array
//实现卷积结果的整理，2023/3/14
import spinal.core._
import spinal.lib.slave
import utils.TopConfig
import xip.xil_SimpleDualBram
import spinal.lib.StreamFifoInterface
import spinal.lib.StreamFifo

class ConvOutput extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val sData= Vec(slave Stream(UInt(8 bits)),Config.SA_ROW)//
    }
    noIoPrefix()


    //构建SA_Row个Mem作为缓存
    val OutFeature_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val OutFeature=new StreamFifo(UInt(8 bits),1024)//bram的深度必须正确配置,只能大不能小
            
        }
        gen()
    }
    for(i<-0 to Config.SA_ROW-1){
        io.sData(i).ready:=False
    }


}
object ConvOutput extends App { 
    val verilog_path="./Simulation/SimSystolic/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvOutput)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}