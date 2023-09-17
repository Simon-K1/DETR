package Systolic_Array.weightV2

//重新设计权重缓存，为了适应后面多头矩阵乘法
import spinal.core._
import spinal.lib.{slave,master}
import utils._
import xip.xil_SimpleDualBram
import spinal.core
import scala.tools.reflect.FrontEnd
import spinal.lib.Delay
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
                                            //Row=InChannels*KernelSize^2,实际是多少就输入多少
        
        val Matrix_Col=in UInt(Config.WEIGHT_CACHE_MATRIX_COL_WIDTH bits)//每次计算的权重矩阵的实际列数（对应输出通道数量）
                                        //比如输出通道是768，但是资源不够，所以只能存256个输出通道，所以这里输入256
                                        //Col=OutChannels
        
        //必须确保InChannel*KernelSize*KernelSize<2^(WEIGHT_CACHE_MATRIX_ROW_WIDTH)
        //比如我们这里Matrix_Col的位宽是16bit，地址空间就是0~2^16-1,如果我们计算16*16的卷积核，可以得到支持的最大输入通道为2^16/(16*16)=256,所以这里输入通道是有上限的

        val mData=out UInt(64 bits)//out Vec(UInt(8 bits),Config.SA_COL)//out UInt(64 bits)//Vec(UInt(8 bits),Config.SA_COL)
        val Raddr_Valid=in Bool()//读Bram使能

        
        val Weight_Cached=out Bool()//权重缓存完了，给Img2Col一个启动型号
        val LayerEnd=in Bool()//当前网络层计算完毕
        val MatrixCol_Switch=out UInt(Config.SA_COL bits)//脉动阵列有多少列就需要多少选择信号
    //分析：首先，假设输入通道是32，输出通道是256，16*16，那么权重矩阵的每一列有16*16*32=8192个元素，每一列8192代表一个完整的卷积核，也就是对应矩阵的一列
    }
    noIoPrefix()
    //val Col_Lefted=Reg(UInt(Config.WEIGHT_CACHE_MATRIX_COL_WIDTH bits))init(0)//剩余待处理的列数
    val Fsm=WeightCache_Fsm(io.start&&(~RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid

    //缓存数据,写地址写数据控制
    
    //注意：现在矩阵的列数应该被统一为8的倍数
    val In_Row_Cnt=ForLoopCounter(io.sData.fire,Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH,io.Matrix_Row-1)
    //val In_Col_Cnt=ForLoopCounter(In_Row_Cnt.valid,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Col>>3-1)//因为一下进8列，所以需要除3
    val In_Col_Cnt=SubstractLoopCounter(In_Row_Cnt.valid,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Col,Config.SA_COL)
    when(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT){
        In_Col_Cnt.reset
    }

    val Read_Row_Base_Addr=Reg(UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits))init(0)//读权重的基地址,一列一列读，
    val Write_Row_Base_Addr=Reg(UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits))init(0)//写权重的基地址，一列一列存
    
    //输出行计数器
    val OutRow_Cnt=ForLoopCounter(io.Raddr_Valid&&Fsm.currentState===WEIGHT_CACHE_STATUS.SA_COMPUTE,Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH,(io.Matrix_Row)-1)//输出行计数器,（要求输出通道必须是8的倍数）

    val OutCol_Cnt=SubstractLoopCounter(OutRow_Cnt.valid,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Col,Config.SA_COL)
    when(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT){
        OutCol_Cnt.reset
    }
    when(OutCol_Cnt.valid){
        Read_Row_Base_Addr:=0//输出全部数据后，也就是一个完整的输出通道都算完了，读数据基地址移归位
    }elsewhen(OutRow_Cnt.valid){
        Read_Row_Base_Addr:=Read_Row_Base_Addr+io.Matrix_Row
    }

    when(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT){
        Write_Row_Base_Addr:=0
    }elsewhen(In_Row_Cnt.valid){
        Write_Row_Base_Addr:=Write_Row_Base_Addr+io.Matrix_Row
    }




    Fsm.Weight_All_Cached:=In_Col_Cnt.valid
    io.Weight_Cached:=In_Col_Cnt.valid

    //构建8列权重缓存
    
    val Weight_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            //4096*64bit是一个Bram资源，32K
            val Weight_Bram=new xil_SimpleDualBram(8,Config.WEIGHT_CACHE_MATRIX_MAX_ROW*Config.WEIGHT_CACHE_MATRIX_MAX_COL/8,8,"Weight_Bram",i==0)//bram的深度必须正确配置,只能大不能小
            Weight_Bram.io.addra:=(In_Row_Cnt.count+Write_Row_Base_Addr).resized
            Weight_Bram.io.addrb:=(OutRow_Cnt.count+Read_Row_Base_Addr).resized
            // Weight_Bram.io.doutb:=0
            Weight_Bram.io.dina:=io.sData.payload((i+1)*8-1 downto i*8)
            Weight_Bram.io.ena:=io.sData.fire
            Weight_Bram.io.wea:=True
            io.mData((i+1)*8-1 downto i*8):=Weight_Bram.io.doutb
        }
        gen()
    }
    io.sData.ready:=Fsm.currentState===WEIGHT_CACHE_STATUS.CACHE_WEIGHT//位于缓存权重状态
    
    //每遍历一次WeightCache就会得到输出矩阵完整的一行
    // val OutFeatureRow_Cnt=ForLoopCounter()
    Fsm.SA_Computed:=io.LayerEnd


    val MatrixCol_Switch=UInt(Config.SA_COL bits)
    switch(OutCol_Cnt.count) {
        for(i<-1 to Config.SA_COL-1){
            is(i) {
                MatrixCol_Switch(i-1 downto 0).setAll()
                MatrixCol_Switch(Config.SA_COL-1 downto i).clearAll()
            }
        } 


        default {
            MatrixCol_Switch.setAll()
        }
    }
    io.MatrixCol_Switch:=RegNext(MatrixCol_Switch)
}
class WeightCache_Stream extends Component{
    val Config=new TopConfig
    val io=new Bundle{
        def DATA_IN_WIDTH=64
        val s_axis_s2mm_tdata=in UInt(DATA_IN_WIDTH bits)
        val s_axis_s2mm_tkeep=in Bits(DATA_IN_WIDTH/8 bits)
        val s_axis_s2mm_tlast=in Bool()
        val s_axis_s2mm_tready=out Bool()
        val s_axis_s2mm_tvalid=in Bool()


        val start=in Bool()
        val Matrix_Row=in UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits)
        val Matrix_Col=in UInt(Config.WEIGHT_CACHE_MATRIX_COL_WIDTH bits)
        val mData=out UInt(64 bits)//out Vec(UInt(8 bits),Config.SA_COL)//out UInt(64 bits)//Vec(UInt(8 bits),Config.SA_COL)
        val Raddr_Valid=in Bool()//读Bram使能
        val Weight_Cached=out Bool()//权重缓存完了，给Img2Col一个启动型号
        val LayerEnd=in Bool()//当前网络层计算完毕
        val MatrixCol_Switch=out UInt(Config.SA_COL bits)
    }
    noIoPrefix()
    val WeightCache=new Weight_Cache
    WeightCache.io.start:=io.start
    WeightCache.io.Matrix_Col:=io.Matrix_Col
    WeightCache.io.Matrix_Row:=io.Matrix_Row
    WeightCache.io.mData<>io.mData
    WeightCache.io.Raddr_Valid<>io.Raddr_Valid
    WeightCache.io.LayerEnd<>io.LayerEnd
    WeightCache.io.Weight_Cached<>io.Weight_Cached
    WeightCache.io.MatrixCol_Switch<>io.MatrixCol_Switch

    WeightCache.io.sData.payload<>io.s_axis_s2mm_tdata
    WeightCache.io.sData.valid<>io.s_axis_s2mm_tvalid
    WeightCache.io.sData.ready<>io.s_axis_s2mm_tready
    
}
object Weight_Gen extends App { 
    val verilog_path="./verilog/SimWeightCache" 
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}