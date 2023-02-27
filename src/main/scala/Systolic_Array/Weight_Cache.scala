package Systolic_Array

import spinal.core._
import spinal.lib.{slave,master}
import utils._
import xip.xil_SimpleDualBram
import spinal.core
//实现权重矩阵的缓存与输出计算
//初步思路:在所有计算开始前应该先缓存所有权重,
    //如果片上资源不够,应该进行矩阵切块,这里将权重矩阵切4块,也就是需要调用计算模块4次
    //---->768/4=192,也就是每次启动只能算192个输出通道,
    //192/8=24,激活值循环24次,也可以认为是每个Weight_Bram存24个16*16*8的卷积核,每个Bram应该存储16*16*8*24(12个Bram)个字节
object WEIGHT_CACHE_STATUS extends SpinalEnum(defaultEncoding = binaryOneHot){
    //权重缓存模块的状态
    val IDLE, INIT, CACHE_WEIGHT,SA_COMPUTE= newElement
    //感觉权重模块很简单,给一个启动信号即可一直循环出数
    //唯一的要求就是出去的权重必须和Img2Col后的图片对上
    //CACHE_WEIGHT:缓存权重
    //SA_COMPUTE:发送权重到脉动阵列参与卷积/矩阵计算
}
case class WeightCache_Fsm(start:Bool)extends Area{
    val currentState = Reg(WEIGHT_CACHE_STATUS()) init WEIGHT_CACHE_STATUS.IDLE
    val nextState = WEIGHT_CACHE_STATUS()
    currentState := nextState

    val Init_End=Bool()
    val Weight_All_Cached=Bool()
    val SA_Computed=Bool()//脉动阵列计算完毕，算完了就不再发数据进入IDLE状态
    switch(currentState){
        is(WEIGHT_CACHE_STATUS.IDLE){
            when(start){
                nextState:=WEIGHT_CACHE_STATUS.INIT
            }otherwise{
                nextState:=WEIGHT_CACHE_STATUS.IDLE
            }
        }
        is(WEIGHT_CACHE_STATUS.INIT){
            when(Init_End){
                nextState:=WEIGHT_CACHE_STATUS.CACHE_WEIGHT
            }otherwise{
                nextState:=WEIGHT_CACHE_STATUS.INIT
            }
        }
        is(WEIGHT_CACHE_STATUS.CACHE_WEIGHT){
            when(Weight_All_Cached){
                nextState:=WEIGHT_CACHE_STATUS.SA_COMPUTE
            }otherwise{
                nextState:=WEIGHT_CACHE_STATUS.CACHE_WEIGHT
            }
        }
        is(WEIGHT_CACHE_STATUS.SA_COMPUTE){
            when(SA_Computed){
                nextState:=WEIGHT_CACHE_STATUS.IDLE
            }otherwise{
                nextState:=WEIGHT_CACHE_STATUS.SA_COMPUTE
            }
        }
    }
}


class Weight_Cache extends Component{
    //应该创建8列缓存单元,卷积核循环填充到这8个缓存单元中
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()
        val sData=slave Stream(UInt(Config.WEIGHT_CACHE_BRAM_IN_DATA_WIDTH bits))
        val Matrix_Row=in UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits)//先初步默认16bit，以后不够再改
                                            //Row=InChannels*KernelSize^2
        
        val Matrix_Col=in UInt(Config.WEIGHT_CACHE_MATRIX_COL_WIDTH bits)//每次计算的权重矩阵的实际列数（对应输出通道数量）
                                        //比如输出通道是768，但是资源不够，所以只能存256个输出通道，所以这里输入256
                                        //Col=OutChannels

        //必须确保InChannel*KernelSize*KernelSize<2^(WEIGHT_CACHE_MATRIX_ROW_WIDTH)
        //比如我们这里Matrix_Col的位宽是16bit，地址空间就是0~2^16-1,如果我们计算16*16的卷积核，可以得到支持的最大输入通道为2^16/(16*16)=256,所以这里输入通道是有上限的

        val mData=Vec(UInt(8 bits),Config.SA_COL)
        val Read_Bram_En=in Bool()//读Bram使能
        //这个使能是干啥的？
    //分析：首先，假设输入通道是32，输出通道是256，16*16，那么权重矩阵的每一列有16*16*32=8192个元素，每一列8192代表一个完整的卷积核，也就是对应
    }
    noIoPrefix()
    val Fsm=WeightCache_Fsm(io.start)
    val Init_Count=WaCounter(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid

    //缓存数据,写地址写数据控制
    //按列优先存储数据,有点反直觉，因为我们的矩阵是竖着进脉动阵列的
    val InData_Switch=Reg(UInt(8 bits))init(1)//这地方的初始化得是1
    val In_Row_Cnt=ForLoopCounter(io.sData.fire,Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH,io.Matrix_Row)
    val In_Col_Cnt=ForLoopCounter(In_Row_Cnt.valid,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Col)
    
    when(In_Row_Cnt.valid){
        InData_Switch:=InData_Switch.rotateLeft(1)//循环左移1位
    }
    Fsm.Weight_All_Cached:=In_Col_Cnt.valid
    

    //构建8列权重缓存
    val Raddr=ForLoopCounter(io.Read_Bram_En&&Fsm.currentState===WEIGHT_CACHE_STATUS.SA_COMPUTE,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Row)//Bram读地址
    val Weight_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val Weight_Bram=new xil_SimpleDualBram(64,6144+5,8,"Weight_Bram",i==0)//bram的深度必须正确配置,只能大不能小
            Weight_Bram.io.addra:=0
            Weight_Bram.io.addrb:=0
            // Weight_Bram.io.doutb:=0
            Weight_Bram.io.dina:=0
            Weight_Bram.io.ena:=InData_Switch(i downto i).asBool
            Weight_Bram.io.wea:=True
            io.mData(i):=Weight_Bram.io.doutb
        }
        gen()
    }
    io.sData.ready:=Fsm.currentState===WEIGHT_CACHE_STATUS.CACHE_WEIGHT//位于缓存权重状态
    
    

}

object Weight_Gen extends App { 
    val verilog_path="./Simulation/SimWeightCache" 
    
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}