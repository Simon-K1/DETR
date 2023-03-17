package Systolic_Array
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

//需要一个状态机来做控制调度
object CONVOUTPUT_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT,DATA_ARRANGEMENT,WAIT_END= newElement
    //DATA_ARRANGEMENT:数据排列(输入缓存+输出排列)
    //WAIT_END:等待FIFO中缓存的数据完全输出
}
case class ConvOutput_Fsm(start:Bool)extends Area{
    val currentState = Reg(CONVOUTPUT_ENUM()) init CONVOUTPUT_ENUM.IDLE
    val nextState = CONVOUTPUT_ENUM()
    currentState := nextState

    val Inited=Bool()
    val LayerEnd=Bool()
    val Data_AllOut=Bool()
    switch(currentState){
        is(CONVOUTPUT_ENUM.IDLE){
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
                nextState:=CONVOUTPUT_ENUM.WAIT_END
            }otherwise{
                nextState:=CONVOUTPUT_ENUM.DATA_ARRANGEMENT
            }
        }
        is(CONVOUTPUT_ENUM.WAIT_END){
            when(Data_AllOut){
                nextState:=CONVOUTPUT_ENUM.IDLE
            }otherwise{
                nextState:=CONVOUTPUT_ENUM.WAIT_END
            }
        }
    }
}
// object ARRANGE_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
//     val IDLE, DATA_OUTPUT= newElement
//     //DATA_OUTPUT:数据输出
// }
// case class Arrange_Fsm(start:Bool)extends Area{
//     val currentState = Reg(ARRANGE_ENUM()) init ARRANGE_ENUM.IDLE
//     val nextState = ARRANGE_ENUM()
//     currentState := nextState
//     val OutEnd=Bool()//完整的8行输出结束
//     switch(currentState){
//         is(ARRANGE_ENUM.IDLE){
//             when(start){
//                 nextState:=ARRANGE_ENUM.DATA_OUTPUT
//             }otherwise{
//                 nextState:=ARRANGE_ENUM.IDLE
//             }
//         }
//         is(ARRANGE_ENUM.DATA_OUTPUT){
//             when(OutEnd){
//                 nextState:=ARRANGE_ENUM.IDLE
//             }otherwise{
//                 nextState:=ARRANGE_ENUM.DATA_OUTPUT
//             }
//         }
//     }
// }
//实现思路：构建SA_Row个Fifo缓存8行完整的数据后依次输出第一行，第二行...第8行的数据
class ConvOutput extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val sData=in UInt(Config.SA_ROW*8 bits)//输入的数据已经对齐
        val sReady=out Bool()
        val sValid=in Bool()
        val In_Channel=in UInt(Config.DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH bits)
        val Matrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)
        val Matrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)
        val mData= master Stream(UInt(64 bits))
        val start=in Bool()
    }
    noIoPrefix()
    val Fsm=ConvOutput_Fsm(io.start)
    

    val Init_Cnt=ForLoopCounter(Fsm.currentState===CONVOUTPUT_ENUM.INIT,3,5)
    Fsm.Inited:=Init_Cnt.valid
    
    //注意这里的InChannel实际上是脉动阵列输出图片的通道，也就是卷积完后图片的通道，也可以认为是卷积层的输出通道，只是这里需要知道一个通道参数进行数据缓存和输出
    val InChannel_Cnt=ForLoopCounter((io.sReady&&io.sValid),Config.MATRIXC_COL_WIDTH,io.In_Channel-1)//输入通道计数器，每行一下进一个点，也就是图片的一个通道
    val In_Col_Cnt=SubstractLoopCounter(InChannel_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.Matrix_Col,8)//图片列计数器,做减法这里io.Matrix_Col不需要减1
    //In_Channel_Cnt每次Valid代表已经缓存好了8个点的完整通道，所以这里需要除8
    val In_Row_Cnt=ForLoopCounter(In_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.Matrix_Row-1)//图片行计数器
    Fsm.LayerEnd:=In_Row_Cnt.valid
    //分析：这里好绕
    //一开始第一个fifo接收输出图片（0，0）点的所有通道，第二个fifo接收（0，1）点的所有通道，，，第8个fifo接收（0，7）点的所有通道
    // 由于脉动阵列一下只能出8个通道，假如输出通道是32，那么fifo要缓存4次才能凑齐一个点的完整通道
    //图片排列格式按通道优先来，所以必须第一个fifo输出完一个点的32通道，第二个fifo才能开始输出，以此类推
    //
    val OutChannel_Cnt=ForLoopCounter(io.mData.fire,Config.MATRIXC_COL_WIDTH-3,(io.In_Channel>>3)-1)//输出通道计数器，一下出8个点，也就是一下出8个通道
    // Outchannel_Cnt valid拉高，代表一个像素点被处理完了，这时就要切换到下一个fifo
    val Out_Col_Cnt=ForLoopCounter(OutChannel_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.Matrix_Row-1)//图片列计数器
    val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.Matrix_Row-1)
    Fsm.Data_AllOut:=Out_Row_Cnt.valid
    //构建SA_Row个Mem作为缓存,外面再挂一个WidthConverter
    //构建SA_Row个Mem作为缓存,由于现在输入通道都是8的倍数，所以即使输出通道不是8的倍数，在数据整理模块中也应该将数据补成8通道的倍数
    io.mData.payload:=0
    io.mData.valid:=False
    val OutSwitch=Reg(UInt(8 bits))init(1)
    when(Out_Col_Cnt.valid){
        OutSwitch:=1//得到完整的一行数据，则重新开始循环输出
    }elsewhen(OutChannel_Cnt.valid){//得到完整的一个输出点，切换下一个fifo
        OutSwitch:=OutSwitch.rotateLeft(1)
    }
    val OutFeature_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val OutFeature_Fifo=new StreamFifo(UInt(64 bits),512)//bram的深度必须正确配置,只能大不能小
            //这个fifo必须至少能缓存输出矩阵完整的一行
            val DataConverter=new AxisDataConverter(8,64)
            DataConverter.setDefinitionName("ConvOutput_Converter")
            OutFeature_Fifo.setDefinitionName("ConvOutput_Fifo")
            DataConverter.inStream.payload:=io.sData((i+1)*8-1 downto i*8)
            if(i==0){
                io.sReady:=(DataConverter.inStream.ready&&(Fsm.currentState===CONVOUTPUT_ENUM.DATA_ARRANGEMENT))
            }
            DataConverter.inStream.valid<>(io.sValid&&(Fsm.currentState===CONVOUTPUT_ENUM.DATA_ARRANGEMENT))
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

}



object ConvOutput extends App { 
    val verilog_path="./Simulation/SimSystolic/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvOutput)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}