package Systolic_Array.BackUp
//实现卷积结果的整理，2023/3/14
import spinal.core._
import spinal.lib.slave
import utils.TopConfig
import xip.xil_SimpleDualBram
import spinal.lib.StreamFifoInterface
import spinal.lib.StreamFifo
import spinal.lib.master
import utils.ForLoopCounter
import utils.AxisDataConverter
import utils.SubstractLoopCounter
import Systolic_Array.SystolicArray3D.{CONVOUTPUT_ENUM, ConvOutput_Fsm}

//实现思路：构建SA_Row个Fifo缓存8行完整的数据后依次输出第一行，第二行...第8行的数据
class ConvArrangeV2 extends Component{//卷积输出数据的数据排列，排列成通道优先的格式
    val Config=TopConfig()
    val io=new Bundle{
        val sData=in UInt(Config.SA_ROW*8 bits)//输入的数据已经对齐
        val sReady=out Bool()
        val sValid=in Bits(Config.SA_ROW bits)
        val MatrixCol=in UInt(Config.MATRIXC_COL_WIDTH bits)
        val MatrixRow=in UInt(Config.MATRIXC_ROW_WIDTH bits)//这里应该是log2Up（outfeaturesize^2)
        // val Matrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)//这里是图片的列
        // val Matrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)//这里是图片的行，以后需要修改这里的名字
        val mData= master Stream(UInt(64 bits))
        val mLast=out Bool()
        val LayerEnd=out Bool()
        val start=in Bool()
    
    }
    noIoPrefix()
    val Fsm=ConvOutput_Fsm(io.start)
    

    val Init_Cnt=ForLoopCounter(Fsm.currentState===CONVOUTPUT_ENUM.INIT,3,5)
    Fsm.Inited:=Init_Cnt.valid
    
    val In_Col_Cnt=ForLoopCounter(io.sReady&&io.sValid(0),Config.MATRIXC_COL_WIDTH,io.MatrixCol-1)//图片列计数器,做减法这里io.Matrix_Col不需要减1
    val In_Row_Cnt=SubstractLoopCounter(In_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.MatrixRow,8)//图片行计数器
    when(io.start){
        In_Row_Cnt.reset
    }
    Fsm.LayerEnd:=In_Row_Cnt.valid
    //分析：这里好绕
    //一开始第一个fifo接收输出图片（0，0）点的所有通道，第二个fifo接收（0，1）点的所有通道，，，第8个fifo接收（0，7）点的所有通道
    // 由于脉动阵列一下只能出8个通道，假如输出通道是32，那么fifo要缓存4次才能凑齐一个点的完整通道
    //图片排列格式按通道优先来，所以必须第一个fifo输出完一个点的32通道，第二个fifo才能开始输出，以此类推
    //
    //val OutChannel_Cnt=ForLoopCounter(io.mData.fire,Config.MATRIXC_COL_WIDTH-3,(io.OutChannel>>3)-1)//输出通道计数器，一下出8个点，也就是一下出8个通道
    // Outchannel_Cnt valid拉高，代表一个像素点被处理完了，这时就要切换到下一个fifo
    val Out_Col_Cnt=ForLoopCounter(io.mData.fire,Config.MATRIXC_COL_WIDTH-3,(io.MatrixCol>>3)-1)//图片列计数器,因为一下出8个点，一行一行出，所以要除8
    val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.MatrixRow-1)
    Fsm.Data_AllOut:=Out_Row_Cnt.valid
    //构建SA_Row个Mem作为缓存,外面再挂一个WidthConverter
    //构建SA_Row个Mem作为缓存,由于现在输入通道都是8的倍数，所以即使输出通道不是8的倍数，在数据整理模块中也应该将数据补成8通道的倍数
    io.mData.payload:=0
    io.mData.valid:=False
    val OutSwitch=Reg(UInt(8 bits))init(1)
    when(Fsm.currentState===CONVOUTPUT_ENUM.INIT){
        OutSwitch:=1
    }elsewhen(Out_Col_Cnt.valid){
        OutSwitch:=OutSwitch.rotateLeft(1)
    }
    val OutFeature_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val OutFeature_Fifo=new StreamFifo(UInt(64 bits),512)
            //这个fifo必须至少能缓存输出矩阵完整的一行
            val DataConverter=new AxisDataConverter(8,64)
            DataConverter.setDefinitionName("ConvOutput_Converter")
            OutFeature_Fifo.setDefinitionName("ConvOutput_Fifo")
            DataConverter.inStream.payload:=io.sData((i+1)*8-1 downto i*8)
            if(i==0){
                io.sReady:=(DataConverter.inStream.ready&&(Fsm.currentState===CONVOUTPUT_ENUM.DATA_ARRANGEMENT))
            }
            DataConverter.inStream.valid<>(io.sValid(i)&&(Fsm.currentState===CONVOUTPUT_ENUM.DATA_ARRANGEMENT))
            OutFeature_Fifo.io.push<>DataConverter.outStream

            OutFeature_Fifo.io.pop.ready:=False
            when(OutSwitch(i downto i).asBool){
                io.mData.payload:=OutFeature_Fifo.io.pop.payload
                io.mData.valid:=OutFeature_Fifo.io.pop.valid
                OutFeature_Fifo.io.pop.ready:=io.mData.ready
            }
        }
        gen()
    }
    // io.mData.valid:=False
    io.mLast:=Fsm.Data_AllOut
    io.LayerEnd:=Fsm.Data_AllOut

}



object ConvOutputV2 extends App { 
    val verilog_path="./verilog/SimSystolic/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvArrangeV2)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}