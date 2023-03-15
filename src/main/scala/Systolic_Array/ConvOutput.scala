package Systolic_Array
//实现卷积结果的整理，2023/3/14
import spinal.core._
import spinal.lib.slave
import utils.TopConfig
import xip.xil_SimpleDualBram
import spinal.lib.StreamFifoInterface
import spinal.lib.StreamFifo
import spinal.lib.master

//需要一个状态机来做控制调度
object CONVOUTPUT_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT,DATA_ARRANGEMENT= newElement
    //DATA_ARRANGEMENT:数据排列
}
case class ConvOutput_Fsm(start:Bool)extends Area{
    val currentState = Reg(CONVOUTPUT_ENUM()) init CONVOUTPUT_ENUM.IDLE
    val nextState = CONVOUTPUT_ENUM()
    currentState := nextState

    val Inited=Bool()
    val LayerEnd=Bool()
    switch(currentState){
        is(CONVOUTPUT_ENUM.INIT){
            when(start){
                nextState:=CONVOUTPUT_ENUM.INIT
            }otherwise{
                nextState:=CONVOUTPUT_ENUM.IDLE
            }
        }
        is(CONVOUTPUT_ENUM.INIT){
            when(Inited){
                nextState:=CONVOUTPUT_ENUM.DATA_ARRANGEMENT
            }otherwise{
                nextState:=CONVOUTPUT_ENUM.INIT
            }
        }
        is(CONVOUTPUT_ENUM.DATA_ARRANGEMENT){
            when(LayerEnd){
                nextState:=CONVOUTPUT_ENUM.IDLE
            }otherwise{
                nextState:=CONVOUTPUT_ENUM.DATA_ARRANGEMENT
            }
        }
    }
}

//实现思路：构建SA_Row个Fifo缓存8行完整的数据后依次输出第一行，第二行...第8行的数据
class ConvOutput extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val sData= Vec(slave Stream(UInt(8 bits)),Config.SA_ROW)//
        val Matrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)
        val Matrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)
        val mData= master Stream(UInt(64 bits))
    }
    noIoPrefix()


    //构建SA_Row个Mem作为缓存,外面再挂一个WidthConverter
    //构建SA_Row个Mem作为缓存,由于现在输入通道都是8的倍数，所以即使输出通道不是8的倍数，在数据整理模块中也应该将数据补成8通道的倍数
    val OutFeature_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val OutFeature=new StreamFifo(UInt(8 bits),1024)//bram的深度必须正确配置,只能大不能小
            when(OutFeature.io.pop.valid){
                io.mData.payload((i+1)*8-1 downto i*8):=OutFeature.io.pop.payload
            }otherwise{
                io.mData.payload((i+1)*8-1 downto i*8):=0//非8的倍数补零
            }
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