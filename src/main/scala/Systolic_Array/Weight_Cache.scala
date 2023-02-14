package Systolic_Array

import spinal.core._
import spinal.lib.slave
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
    val IDLE, INIT, SEND_WEIGHT= newElement
    //感觉权重模块很简单,给一个启动信号即可一直循环出数
    //唯一的要求就是出去的权重必须和Img2Col后的图片对上
}
case class WeightCache_Fsm(start:Bool)extends Area{
    val currentState = Reg(WEIGHT_CACHE_STATUS()) init WEIGHT_CACHE_STATUS.IDLE
    val nextState = WEIGHT_CACHE_STATUS()
    currentState := nextState

    val Init_End=Bool()
    val Weight_All_Sended=Bool()
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
                nextState:=WEIGHT_CACHE_STATUS.SEND_WEIGHT
            }otherwise{
                nextState:=WEIGHT_CACHE_STATUS.INIT
            }
        }
        is(WEIGHT_CACHE_STATUS.SEND_WEIGHT){
            when(Weight_All_Sended){
                nextState:=WEIGHT_CACHE_STATUS.IDLE
            }otherwise{
                nextState:=WEIGHT_CACHE_STATUS.SEND_WEIGHT
            }
        }
    }
}


class Weight_Cache extends Component{
    //应该创建8列缓存单元,卷积核循环填充到这8个缓存单元中
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()
        val sData=slave Stream(UInt(64 bits))
        val Matrix_Row=in UInt(16 bits)//先初步默认16bit，以后不够再改
        val Matrix_Col=in UInt(16 bits)//每次计算的权重矩阵的实际列数（对应输出通道数量）
                                        //比如输出通道是768，但是资源不够，所以只能存192个输出通道，所以这里输入192
        
    }
    noIoPrefix()
    val Fsm=WeightCache_Fsm(io.start)
    val Init_Count=WaCounter(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid


    //构建8列权重缓存
    val Weight_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            val Weight_Bram=new xil_SimpleDualBram(64,6144+5,8,"Weight_Bram",i==0)
            Weight_Bram.io.addra:=0
            Weight_Bram.io.addrb:=0
            // Weight_Bram.io.doutb:=0
            Weight_Bram.io.dina:=0
            Weight_Bram.io.ena:=False
            Weight_Bram.io.wea:=False
        }
        gen()
    }
    io.sData.ready:=False
}

object Weight_Gen extends App { 
    val verilog_path="./testcode_gen/WeightCache" 
    
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}