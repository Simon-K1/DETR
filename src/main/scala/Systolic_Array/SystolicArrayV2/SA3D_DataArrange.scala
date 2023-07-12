package Systolic_Array.SystolicArrayV2
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
            when(LayerEnd){//layerend，（半年之后重新理解自己写的代码）：应该是当前层的图片全部进完后，那么这一层就结束了，但是还有一些数据残留在流水线里
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
//实现思路：构建SA_Row个Fifo缓存8行完整的数据后依次输出第一行，第二行...第8行的数据
class ConvArrangeV3(SLICE:Int,HEIGHT:Int,WIDTH:Int) extends Component{//卷积输出数据的数据排列，排列成通道优先的格式
    val Config=TopConfig()
    val io=new Bundle{
        val sData=in Vec(UInt(8*SLICE bits),HEIGHT)//前提：输入的数据已经对齐
        val sReady=out Bool()
        val sValid=in Bits(HEIGHT bits)//数据全部拼成64bit
        val MatrixCol=in UInt(Config.MATRIXC_COL_WIDTH bits)
        val MatrixRow=in UInt(Config.MATRIXC_ROW_WIDTH bits)//这里应该是log2Up（outfeaturesize^2)

        val OutChannel=in UInt(Config.DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH bits)
        val OutFeatureSize=in UInt(16 bits)


        val mData= master Stream(UInt(64 bits))
        val mLast=out Bool()
        val LayerEnd=out Bool()
        val start=in Bool()
        val SwitchConv=in Bool()
    
    }
    noIoPrefix()
    val Fsm=ConvOutput_Fsm(io.start)
    val ConvCtrl=new ConvOutput_Ctrl(SLICE,HEIGHT,WIDTH)//卷积输出控制
    val GemmCtrl=new GemmOutput_Ctrl(SLICE,HEIGHT,WIDTH)//矩阵输出控制
    ConvCtrl.io.ResetCnt:=Fsm.currentState===CONVOUTPUT_ENUM.INIT
    ConvCtrl.io.InData_Cnt_En:=(io.sReady&&io.sValid(0))&&(io.SwitchConv)
    ConvCtrl.io.OutData_Cnt_En:=(io.mData.fire)&&(io.SwitchConv)
    ConvCtrl.io.OutChannel:=io.OutChannel
    ConvCtrl.io.OutFeatureSize:=io.OutFeatureSize

    GemmCtrl.io.ResetCnt:=Fsm.currentState===CONVOUTPUT_ENUM.INIT
    GemmCtrl.io.InData_Cnt_En:=(io.sReady&&io.sValid(0))&&(!io.SwitchConv)
    GemmCtrl.io.OutData_Cnt_En:=(io.mData.fire)&&(!io.SwitchConv)
    GemmCtrl.io.MatrixCol:=io.MatrixCol
    GemmCtrl.io.MatrixRow:=io.MatrixRow


    val Init_Cnt=ForLoopCounter(Fsm.currentState===CONVOUTPUT_ENUM.INIT,3,5)
    Fsm.Inited:=Init_Cnt.valid
    


    Fsm.LayerEnd:=(ConvCtrl.io.Fsm_LayerEnd&&io.SwitchConv)||(GemmCtrl.io.Fsm_LayerEnd&&(!io.SwitchConv))
    Fsm.Data_AllOut:=(ConvCtrl.io.Fsm_Data_AllOut&&io.SwitchConv)||(GemmCtrl.io.Fsm_Data_AllOut&&(!io.SwitchConv))
    //构建SA_Row个Mem作为缓存,外面再挂一个WidthConverter
    //构建SA_Row个Mem作为缓存,由于现在输入通道都是8的倍数，所以即使输出通道不是8的倍数，在数据整理模块中也应该将数据补成8通道的倍数
    io.mData.payload:=0
    io.mData.valid:=False
    val OutSwitch=Reg(UInt(8 bits))init(1)
    when(Fsm.currentState===CONVOUTPUT_ENUM.INIT){
        OutSwitch:=1
    }elsewhen(ConvCtrl.io.OutSwitch_Reset){
        OutSwitch:=1
    }elsewhen(ConvCtrl.io.OutSwitch_Rotate||GemmCtrl.io.OutSwitch_Rotate){
        OutSwitch:=OutSwitch.rotateLeft(1)
    }
    val OutFeature_Cache=Array.tabulate(HEIGHT){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val OutFeature_Fifo=new StreamFifo(UInt(64 bits),512)//现在我们默认这些fifo的大小都是in/Out 64 bits
            //这个fifo必须至少能缓存输出矩阵完整的一行
            val DataConverter=new AxisDataConverter(8*SLICE,64)//将一个点的8通道喂到fifo里
            DataConverter.setDefinitionName("ConvOutput_Converter")
            OutFeature_Fifo.setDefinitionName("ConvOutput_Fifo")
            DataConverter.inStream.payload:=io.sData(i)//第i行的数据进入第i个fifo，存满8行完整的数据后，再依次按：第一行，第二行。。。输出
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

class ConvOutput_Ctrl(SLICE:Int,HEIGHT:Int,WIDTH:Int) extends Component{//卷积输出控制
    //将矩阵排列和矩阵排列整合起来
    val Config=TopConfig()
    val io=new Bundle{
        val ResetCnt=in Bool()//计数器归位
        val InData_Cnt_En=in Bool()
        val OutData_Cnt_En=in Bool()

        val OutChannel=in UInt(Config.DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH bits)
        val OutFeatureSize=in UInt(16 bits)

        val Fsm_LayerEnd=out Bool()
        val Fsm_Data_AllOut=out Bool()

        val OutSwitch_Rotate=out Bool()
        val OutSwitch_Reset=out Bool()
        
    }
    noIoPrefix()
    
    val InChannel_Cnt=ForLoopCounter((io.InData_Cnt_En),Config.DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH,(io.OutChannel-1)>>(log2Up(SLICE)))//输入通道计数器，每行一下进一个点，也就是图片的一个通道
    val In_Col_Cnt=SubstractLoopCounter(InChannel_Cnt.valid,16,io.OutFeatureSize,HEIGHT)//图片列计数器,做减法这里io.Matrix_Col不需要减1
    //In_Channel_Cnt每次Valid代表已经缓存好了HEIGHT个点的完整通道，所以这里需要除HEIGHT
    when(io.ResetCnt){
        In_Col_Cnt.reset
    }
    val In_Row_Cnt=ForLoopCounter(In_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.OutFeatureSize-1)//图片行计数器
    io.Fsm_LayerEnd:=In_Row_Cnt.valid
    //分析：这里好绕
    //一开始第一个fifo接收输出图片（0，0）点的所有通道，第二个fifo接收（0，1）点的所有通道，，，第8个fifo接收（0，7）点的所有通道
    // 由于脉动阵列一下只能出8个通道，假如输出通道是32，那么fifo要缓存4次才能凑齐一个点的完整通道
    //图片排列格式按通道优先来，所以必须第一个fifo输出完一个点的32通道，第二个fifo才能开始输出，以此类推
    //
    val OutChannel_Cnt=ForLoopCounter(io.OutData_Cnt_En,Config.MATRIXC_COL_WIDTH-3,(io.OutChannel>>3)-1)//输出通道计数器，因为DMA位宽是64，一下出8个点，也就是一下出8个通道
    // Outchannel_Cnt valid拉高，代表一个像素点被处理完了，这时就要切换到下一个fifo
    val Out_Col_Cnt=ForLoopCounter(OutChannel_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.OutFeatureSize-1)//图片列计数器
    val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.OutFeatureSize-1)//
    io.Fsm_Data_AllOut:=Out_Row_Cnt.valid

    io.OutSwitch_Reset:=Out_Col_Cnt.valid
    io.OutSwitch_Rotate:=OutChannel_Cnt.valid


}
class GemmOutput_Ctrl(SLICE:Int,HEIGHT:Int,WIDTH:Int) extends Component{//Gemm输出控制
    val Config=TopConfig()
    val io=new Bundle{
        val ResetCnt=in Bool()//计数器归位
        val InData_Cnt_En=in Bool()
        val OutData_Cnt_En=in Bool()
        val MatrixCol=in UInt(Config.MATRIXC_COL_WIDTH bits)
        val MatrixRow=in UInt(Config.MATRIXC_ROW_WIDTH bits)//这里应该是log2Up（outfeaturesize^2)

        val Fsm_LayerEnd=out Bool()//代表这一层的输入已经完成，但是还有一部分数据没有完全输出
        val Fsm_Data_AllOut=out Bool()
        
        val OutSwitch_Rotate=out Bool()//矩阵计算输出不需要OutSwitch复位控制

    
    }
    noIoPrefix()

    val In_Col_Cnt=ForLoopCounter(io.InData_Cnt_En,Config.MATRIXC_COL_WIDTH,io.MatrixCol-1)//图片列计数器,做减法这里io.Matrix_Col不需要减1
    val In_Row_Cnt=SubstractLoopCounter(In_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.MatrixRow,8)//图片行计数器
    when(io.ResetCnt){
        In_Row_Cnt.reset
    }

    val Out_Col_Cnt=ForLoopCounter(io.OutData_Cnt_En,Config.MATRIXC_COL_WIDTH-3,(io.MatrixCol>>3)-1)//图片列计数器,因为一下出8个点，一行一行出，所以要除8
    val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,Config.MATRIXC_ROW_WIDTH,io.MatrixRow-1)
    io.Fsm_Data_AllOut:=Out_Row_Cnt.valid
    //构建SA_Row个Mem作为缓存,外面再挂一个WidthConverter
    //构建SA_Row个Mem作为缓存,由于现在输入通道都是8的倍数，所以即使输出通道不是8的倍数，在数据整理模块中也应该将数据补成8通道的倍数
    

    io.OutSwitch_Rotate:=Out_Col_Cnt.valid
    io.Fsm_LayerEnd:=In_Row_Cnt.valid

}



object ConvOutputV3 extends App { 
    val verilog_path="./Simulation/SA_3D/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvArrangeV3(8,8,8))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}