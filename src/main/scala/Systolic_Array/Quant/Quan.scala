//这里的量化用于全部的矩阵计算
//量化计算：

package Systolic_Array.Quant
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
// import spinal.core.internals.Operator
import xip.xil_SimpleDualBram
//实现卷积和权重的量化
    //先存bias，再存Scale，再存shift
object ConvQuan_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_BIAS,LOAD_SCALE,LOAD_SHIFT,QUANT= newElement
    //LOAD_BIAS:加载Bias
    //LOAD_SCALE:加载Scale
    //...
    //QUANT: 量化计算

}
case class ConvQuan_Fsm(start:Bool)extends Area{
    val currentState = Reg(ConvQuan_ENUM()) init ConvQuan_ENUM.IDLE
    val nextState = ConvQuan_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Bias_Loaded=Bool()
    val Scale_Loaded=Bool()
    val Shift_Loaded=Bool()
    val LayerEnd=Bool()

    switch(currentState){
        is(ConvQuan_ENUM.IDLE){
            when(start){
                nextState:=ConvQuan_ENUM.INIT
            }otherwise{
                nextState:=ConvQuan_ENUM.IDLE
            }
        }
        is(ConvQuan_ENUM.INIT){
            when(Init_End){
                nextState:=ConvQuan_ENUM.LOAD_BIAS
            }otherwise{
                nextState:=ConvQuan_ENUM.INIT
            }
        }
        is(ConvQuan_ENUM.LOAD_BIAS){
            when(Bias_Loaded){
                nextState:=ConvQuan_ENUM.LOAD_SCALE
            }otherwise{
                nextState:=ConvQuan_ENUM.LOAD_BIAS
            }
        }
        is(ConvQuan_ENUM.LOAD_SCALE){
            when(Scale_Loaded){
                nextState:=ConvQuan_ENUM.LOAD_SHIFT
            }otherwise{
                nextState:=ConvQuan_ENUM.LOAD_SCALE
            }
        }
        is(ConvQuan_ENUM.LOAD_SHIFT){
            when(Shift_Loaded){
                nextState:=ConvQuan_ENUM.QUANT
            }otherwise{
                nextState:=ConvQuan_ENUM.LOAD_SHIFT
            }
        }
        is(ConvQuan_ENUM.QUANT){
            when(LayerEnd){
                nextState:=ConvQuan_ENUM.IDLE
            }otherwise{
                nextState:=ConvQuan_ENUM.QUANT
            }
        }
    }
}
class ConvQuant extends Component{
    //规定Scale， Bias，Shift均为32 bit
        //量化参数由算法给出
    //大体思路：先缓存全部的量化参数，然后再循环输出
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()
        val sData=slave Stream(UInt(64 bits))//DMA位宽应该是64bits，这里进的是量化参数

        // val Bias    =out UInt(32 bits)//输出Bias，Scale，Shift等量化参数
        // val Scale   =out UInt(32 bits)
        // val Shift   =out UInt(32 bits)

        val OutMatrix_Col=in UInt(16 bits)//输出通道数量，也是输出矩阵的列数
        val LayerEnd=in Bool()//待定，这是外部给的信号
        val QuantPara_Cached=out Bool()//量化参数缓存完成
        //=================================
        val dataIn   =in Vec(SInt(Config.addChannelTimesWidth bits),Config.SA_ROW)//sum(q1*q2)的值
        val dataOut  =out UInt (Config.SA_ROW * 8 bits)//一次出8个8bit，因为脉动阵列有8行
        val zeroIn   =in UInt(8 bits)
        val SAOutput_Valid=in Bool()//脉动阵列输出的数据有效标志，用于将量化参数从


        
    }
    
    noIoPrefix()
    val Fsm=ConvQuan_Fsm(io.start&&(~RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===ConvQuan_ENUM.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid
    Fsm.LayerEnd:=io.LayerEnd//结束信号由外层给到
    val BiasCache   =new xil_SimpleDualBram(64,Config.QUAN_MAX_MATRIX_COL/2,32,"ConvQuan_Bram",true)//
    val ScaleCache  =new xil_SimpleDualBram(64,Config.QUAN_MAX_MATRIX_COL/2,32,"ConvQuan_Bram",false)//
    val ShiftCache  =new xil_SimpleDualBram(64,Config.QUAN_MAX_MATRIX_COL/2,32,"ConvQuan_Bram",false)//


    val InMatrixCol_Cnt=ForLoopCounter(io.sData.fire,log2Up(Config.QUAN_MAX_MATRIX_COL/2),(io.OutMatrix_Col>>1)-1)//列计数器，可以认为是脉动阵列输出矩阵的列数，也可以认为是输出特征图的通道
        //输入位宽是64bit，输出位宽为32bit，比如一共由32列，写地址只需要16个即可。读地址还是32个
    Fsm.Bias_Loaded:=(InMatrixCol_Cnt.valid)&&Fsm.currentState===ConvQuan_ENUM.LOAD_BIAS
    Fsm.Scale_Loaded:=(InMatrixCol_Cnt.valid)&&Fsm.currentState===ConvQuan_ENUM.LOAD_SCALE
    Fsm.Shift_Loaded:=(InMatrixCol_Cnt.valid)&&Fsm.currentState===ConvQuan_ENUM.LOAD_SHIFT
    
    BiasCache.io.addra:=InMatrixCol_Cnt.count
    ScaleCache.io.addra:=InMatrixCol_Cnt.count
    ShiftCache.io.addra:=InMatrixCol_Cnt.count

    BiasCache.io.ena:=(Fsm.currentState===ConvQuan_ENUM.LOAD_BIAS)&&io.sData.valid
    ScaleCache.io.ena:=(Fsm.currentState===ConvQuan_ENUM.LOAD_SCALE)&&io.sData.valid
    ShiftCache.io.ena:=(Fsm.currentState===ConvQuan_ENUM.LOAD_SHIFT)&&io.sData.valid
    
    BiasCache.io.dina:=io.sData.payload
    ScaleCache.io.dina:=io.sData.payload
    ShiftCache.io.dina:=io.sData.payload
    
    BiasCache.io.wea:=True
    ScaleCache.io.wea:=True
    ShiftCache.io.wea:=True

    // io.Bias    :=BiasCache.io.doutb
    // io.Scale   :=ScaleCache.io.doutb
    // io.Shift   :=ShiftCache.io.doutb
    io.sData.ready:=(Fsm.currentState===ConvQuan_ENUM.LOAD_BIAS)||(Fsm.currentState===ConvQuan_ENUM.LOAD_SCALE)||(Fsm.currentState===ConvQuan_ENUM.LOAD_SHIFT)
    io.QuantPara_Cached:=Fsm.Shift_Loaded

    //量化参数缓存结束，接下来开始实现量化计算============================================================
    val OutCol_Cnt=ForLoopCounter(io.SAOutput_Valid,log2Up(Config.QUAN_MAX_MATRIX_COL),io.OutMatrix_Col-1)
    BiasCache.io.addrb:=OutCol_Cnt.count
    ScaleCache.io.addrb:=OutCol_Cnt.count
    ShiftCache.io.addrb:=OutCol_Cnt.count
    
    val Quant_Module=new Quan(Config)
    Quant_Module.io.dataIn:=io.dataIn//
        //↑这里不再Regnext的原因是Quant内部已经做了RegNext对齐
    Quant_Module.io.biasIn:=BiasCache.io.doutb
    Quant_Module.io.scaleIn:=ScaleCache.io.doutb
    Quant_Module.io.shiftIn:=ShiftCache.io.doutb
    Quant_Module.io.zeroIn:=io.zeroIn
    io.dataOut:=Quant_Module.io.dataOut
}

object QuantGen extends App { 
    val verilog_path="./Simulation/Quant" 
    (0 to 8).foreach(i=>{
        printf("%d\n",i)
    })
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvQuant)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Quan(TopConfig()))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}