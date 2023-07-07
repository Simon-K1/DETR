package Systolic_Array.SystolicArrayV2
//重构权重缓存模块，以适配三维脉动阵列的计算
import spinal.core._
import spinal.lib.{slave,master}
import utils._
import xip.xil_SimpleDualBram
import spinal.core
import scala.tools.reflect.FrontEnd
import spinal.lib.Delay
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

class Weight_Cache(SLICE:Int,HEIGHT:Int,WIDTH:Int,DMA_WIDTH:Int) extends Component{
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

        val mData=out Vec(UInt(8 bits),HEIGHT*SLICE*WIDTH)//out Vec(UInt(8 bits),Config.SA_COL)//out UInt(64 bits)//Vec(UInt(8 bits),Config.SA_COL)
        val Raddr_Valid=in Bool()//读Bram使能
        // val OutMatrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)
        // val OutMatrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)
        
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
    //按列优先存储数据,有点反直觉，因为我们的矩阵是竖着进脉动阵列的
    val InData_Switch=Reg(UInt(SLICE*HEIGHT*WIDTH bits))init(1)//这地方的初始化得是1
    val Matrix_In_MaxCnt=io.Matrix_Row>>(log2Up(DMA_WIDTH/8))//除8，考虑DMA位宽,目前DMA是64bit
    val In_Row_Cnt=ForLoopCounter(io.sData.fire,Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH,Matrix_In_MaxCnt-1)//右移的原因：要考虑DMA的位宽
    //输入行计数器：因为数据是一列一列输入的，先进第一列的第一行，第二行。。。。。第二列的第一行，第二列的第二行。。。以此类推
    val In_Col_Cnt=ForLoopCounter(In_Row_Cnt.valid,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Col-1)//
    //In_Row_Cnt.valid一次，代表完整的一列被输入了。
    //val Raddr=ForLoopCounter(io.Raddr_Valid&&Fsm.currentState===WEIGHT_CACHE_STATUS.SA_COMPUTE,Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH,io.Matrix_Row-1)//Bram读地址
    val Read_Row_Base_Addr=Reg(UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits))init(0)//读权重的基地址,一列一列读，
    val Write_Row_Base_Addr=Reg(UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits))init(0)//写权重的基地址，一列一列存
    
    //输出行计数器
    val OutRow_Cnt=ForLoopCounter(io.Raddr_Valid&&Fsm.currentState===WEIGHT_CACHE_STATUS.SA_COMPUTE,Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH,(io.Matrix_Row)-1)//输出行计数器,（要求输出通道必须是8的倍数）
    //

    val OutCol_Cnt=SubstractLoopCounter(OutRow_Cnt.valid,Config.WEIGHT_CACHE_MATRIX_COL_WIDTH,io.Matrix_Col,Config.SA_COL)
    when(io.start){
        OutCol_Cnt.reset
    }

    //举个栗子：比如16*16*32入，32出的卷积展平成2D矩阵，那么这个2D矩阵一共有8192行，32列，脉动阵列一共有8列,
    //所以一次能输出8192*（8列）的数据，要将8192*（32列）的数据全部输出，那么只需要4次即可，输输完4次8192*（8列）数据后，读基地址（Read_Row_Base_Addr）需要归位
    //为什么加一个RowBaseAddr？
    //我们只需要输入Matirx_Row，对于输入数据：只要右移三位就能拿到In_Row_Cnt的End，
    //同样地，对于输出数据每读完I*Matirx_Row后再从Matrix_Row*(I+1)开始读下一个卷积核的数据
    val Col_In_8_Cnt=ForLoopCounter(In_Row_Cnt.valid,log2Up(HEIGHT*WIDTH*SLICE),HEIGHT*WIDTH*SLICE-1)//
    //比如SA的大小为1*8*8，那么每出8列数据读数据基地址需要自增一下
    when(OutCol_Cnt.valid){
        Col_In_8_Cnt.clear
        Read_Row_Base_Addr:=0//输出全部数据后，也就是一个完整的输出通道都算完了，读数据基地址移归位
    }elsewhen(OutRow_Cnt.valid){
        Read_Row_Base_Addr:=Read_Row_Base_Addr+io.Matrix_Row
    }
    when(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT){
        InData_Switch:=1
    }elsewhen(In_Row_Cnt.valid){//
        InData_Switch:=InData_Switch.rotateLeft(1)//循环左移1位    
    }
    when(Fsm.currentState===WEIGHT_CACHE_STATUS.INIT){
        Write_Row_Base_Addr:=0
    }elsewhen(Col_In_8_Cnt.valid){
        Write_Row_Base_Addr:=Write_Row_Base_Addr+Matrix_In_MaxCnt
    }
    Fsm.Weight_All_Cached:=In_Col_Cnt.valid
    io.Weight_Cached:=In_Col_Cnt.valid

    //构建8列权重缓存
    
    val Weight_Cache=Array.tabulate(HEIGHT*WIDTH*SLICE){//所需要的权重缓存buf
        i=>def gen()={//这里用了8个4KB的Bram
            //4096*64bit是一个Bram资源，32K
            val Weight_Bram=new xil_SimpleDualBram(64,2048,8,"Weight_Bram",i==0)//bram的深度必须正确配置,只能大不能小
            Weight_Bram.io.addra:=(In_Row_Cnt.count+Write_Row_Base_Addr).resized
            Weight_Bram.io.addrb:=(Read_Row_Base_Addr+OutRow_Cnt.count).resized
            // Weight_Bram.io.doutb:=0
            Weight_Bram.io.dina:=io.sData.payload
            Weight_Bram.io.ena:=InData_Switch(i downto i).asBool&&io.sData.fire
            Weight_Bram.io.wea:=True
            io.mData(i):=Weight_Bram.io.doutb//Delay(,i)
            // io.mData(i):=Delay(Weight_Bram.io.doutb,i)
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
        val mData=out Vec(UInt(8 bits),8*8*8)//out Vec(UInt(8 bits),Config.SA_COL)//out UInt(64 bits)//Vec(UInt(8 bits),Config.SA_COL)
        val Raddr_Valid=in Bool()//读Bram使能
        val Weight_Cached=out Bool()//权重缓存完了，给Img2Col一个启动型号
        val LayerEnd=in Bool()//当前网络层计算完毕
        val MatrixCol_Switch=out UInt(Config.SA_COL bits)
    }
    noIoPrefix()
    val WeightCache=new Weight_Cache(8,8,8,64)
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
    val verilog_path="./Simulation/SA_3D/verilog" 
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache(1,8,8,64))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}