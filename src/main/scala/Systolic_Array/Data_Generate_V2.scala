package Systolic_Array
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
import spinal.core.internals.Operator
import _root_.com.sourcegraph.semanticdb_javac.Semanticdb.Tree

object IMG2COL_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, INIT_ADDR,DATA_CACHE,WAIT_COMPUTE,UPDATE_ADDR,START_COMPUTE= newElement
    //INIT_ADDR:即初始化读写fifo的地址,把需要的地址存起来

    //DATA_CACHE:缓存一轮计算所需的数据
    //WAIT:缓存完了得等开始计算，比如上一轮还没算完，得等上一轮算完了才开始计算
    //UPDATE_ADDR:更新下一轮计算的全部读地址，比如在Init_Addr阶段0~31的地址都被存好了,现在计算的话需要的确实0~15的地址,我们需要把0~15的地址写入fifo
                //下一轮计算的时候需要的是16~31的地址,下一次计算前也要更新.
    //START_COMPUTE:开始计算，理论上就拉高一个周期
}
case class Img2Col_Fsm(start:Bool)extends Area{
    val currentState = Reg(IMG2COL_ENUM()) init IMG2COL_ENUM.IDLE
    val nextState = IMG2COL_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Addr_Inited=Bool()//初始化读写地址完成
    val Data_Cached=Bool()//一轮要计算的数据缓存完了
    val Addr_Updated=Bool()
    val SA_Ready=Bool()//脉动阵准备好接收新一轮数据开始计算
    val Layer_End=Bool()//一层全部算完了
    switch(currentState){
        is(IMG2COL_ENUM.IDLE){
            when(start){
                nextState:=IMG2COL_ENUM.INIT
            }otherwise{
                nextState:=IMG2COL_ENUM.IDLE
            }
        }
        is(IMG2COL_ENUM.INIT){
            when(Init_End){
                nextState:=IMG2COL_ENUM.INIT_ADDR
            }otherwise{
                nextState:=IMG2COL_ENUM.INIT
            }
        }
        is(IMG2COL_ENUM.INIT_ADDR){
            when(Addr_Inited){
                nextState:=IMG2COL_ENUM.DATA_CACHE
            }otherwise{
                nextState:=IMG2COL_ENUM.INIT_ADDR
            }
        }
        is(IMG2COL_ENUM.DATA_CACHE){
            when(Data_Cached){
                nextState:=IMG2COL_ENUM.WAIT_COMPUTE
            }otherwise{
                nextState:=IMG2COL_ENUM.DATA_CACHE
            }
        }
        is(IMG2COL_ENUM.WAIT_COMPUTE){
            when(SA_Ready){
                nextState:=IMG2COL_ENUM.UPDATE_ADDR
            }otherwise{
                nextState:=IMG2COL_ENUM.WAIT_COMPUTE
            }
        }
        is(IMG2COL_ENUM.UPDATE_ADDR){
            when(Addr_Updated){
                nextState:=IMG2COL_ENUM.START_COMPUTE
            }otherwise{
                nextState:=IMG2COL_ENUM.UPDATE_ADDR
            }
        }
        is(IMG2COL_ENUM.START_COMPUTE){
            when(Layer_End){
                nextState:=IMG2COL_ENUM.IDLE
            }otherwise{
                nextState:=IMG2COL_ENUM.DATA_CACHE
            }
        }
    }
    
}
class Img2Col_Top extends Component{
    //Top模块负责总控和数据缓存,数据输出模块再开一个
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()
        val sData=slave Stream(UInt(64 bits))
        val mData=out UInt(Config.DATA_GENERATE_BRAM_OUT_WIDTH bits)
        val mValid=out Bool()
        val mLast=out Bool()

        val Stride=in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size=in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size=in UInt(16 bits)
            //所谓WindowSize,比如一个16*16的卷积,那么一个滑动窗口的大小就是16,但是需要考虑输入通道,比如256的输入通道,那么这时输入的Window_Size就是16*256(对应的是滑动窗口一行数据点),只支持方形卷积
            //除了考虑输入通道，还要考虑输入数据的并行度，比如如果一下进8个点，也就是8个通道，虽然实际我们进的是224*224*3的图片，
            //但是我们不能简单的将Window_Size设置为16*3，应该还是设置为16，因为3通道不够，需要补零成8通道
            //这时我们的WindowSize还是1，如果输入通道是9，那么我们的Window_Size就是16*2，9通道继续补零成16通道，有7个通道冗余
            //总的来说Window_Size的实际计算公式应该是：KernelSize*InChannel/(Bram_Out_DataWidth/8)(向上取整)

        val InFeature_Size=in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel=in UInt(16 bits)
        
        val OutFeature_Channel=in UInt(16 bits)
        val OutFeature_Channel_Count_Times=in UInt(16 bits)
        val OutFeature_Size=in UInt(16 bits)//输出特征图的大小
                                            //用于计算的冗余处理，
        val OutCol_Count_Times=in UInt(16 bits)
        val OutRow_Count_Times=in UInt(16 bits)
        val InCol_Count_Times=in UInt(16 bits)//图片大小*ceil(通道数/8)，比如224的图片，3通道，但是一下子进8个通道，这三个通道补零成8通道，那么这里应该输入224*ceil(3/8)
                                                //实际上就是输入图片一行（全部通道）的地址空间大小
    }
    noIoPrefix()
    val Fsm=Img2Col_Fsm(io.start&&(~RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===IMG2COL_ENUM.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid
    //初始化结束后进入初始化地址阶段============================================================
    val Addr_Init_Cnt=ForLoopCounter(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR,5,io.Kernel_Size+io.Stride-1)
    Fsm.Addr_Inited:=Addr_Init_Cnt.valid

    val AddrFifo=new WaddrOffset_Fifo
    val WaddrOffset=Reg(UInt(16 bits))init(0)
    AddrFifo.io.push.payload:=WaddrOffset
    AddrFifo.io.push.valid:=False
    AddrFifo.io.pop.ready:=False

    when(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR){
        AddrFifo.io.push.valid:=True
        // AddrFifo.io.push.payload:=WaddrOffset
    }
    //开始缓存之前要先pop一下,这里判定的优先级比较重要
    when(AddrFifo.io.pop.fire){
        WaddrOffset:=AddrFifo.io.pop.payload
    }elsewhen(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR){
        WaddrOffset:=WaddrOffset+io.InCol_Count_Times
    }//当AddrFifo.io.pop.fire拉高时必须更新WaddrOffset

    when(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR&&Fsm.nextState===IMG2COL_ENUM.DATA_CACHE){
        AddrFifo.io.pop.ready:=True
    }
    

    //缓存数据================================================================================
    val In_Col_Cnt=ForLoopCounter(io.sData.fire,16,io.InCol_Count_Times-1)
    val Row_Cache_Cnt=ForLoopCounter(In_Col_Cnt.valid,5,io.Stride-1)
    val In_Row_Cnt=ForLoopCounter(In_Col_Cnt.valid,16,io.InFeature_Size-1)
    when(In_Col_Cnt.valid){
        AddrFifo.io.pop.ready:=True//每缓存满一行,Fifo就pop一下
    }
    when(RegNext(In_Col_Cnt.valid)){//这里RegNext是因为WaddrOffset从AddrFifo中读取数据需要一个周期
        AddrFifo.io.push.valid:=True//pop出来的数据也要push回去
    }
    Fsm.Data_Cached:=Row_Cache_Cnt.valid//每次只需要缓存Stride行数据即可
    io.sData.ready:=Fsm.currentState===IMG2COL_ENUM.DATA_CACHE//只有在数据缓存阶段才能接收数据,每次接收Stride的数据
    //Bram的读写策略采取写优先
    //更新读地址fifo============================================================================
    Fsm.Addr_Updated:=False
    //启动计算==================================================================================
    Fsm.SA_Ready:=False
    Fsm.Layer_End:=False
    



    //============
    io.mData:=0
    io.mValid:=False
    io.mLast:=False
}

object Img2ColGen extends App { 
    val verilog_path="./testcode_gen/Systolic_Array" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Img2Col_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}