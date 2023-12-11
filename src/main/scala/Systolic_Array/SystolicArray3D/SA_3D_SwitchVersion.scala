package Systolic_Array.SystolicArray3D

//2023/10/12  实在不知道怎么办了，数据流先不管他了，直接把计算完的数据收回来放DDR里，之后再重新发回去得了
import spinal.core._
import utils._
import Systolic_Array.Img2ColStreamV2
import spinal.lib.Delay
import Systolic_Array.Quant.ConvQuant
import LayerNorm.LayerNorm_Top
import spinal.lib.StreamWidthAdapter
import Systolic_Array.Quant.Quan
import xip.xil_ila
import Systolic_Array.LHMM.GEMM_Fsm
import Systolic_Array.LHMM.GemmCache
//Switch模块是不是得添加一些组合逻辑，不然可能时序过不去
class Axis_Switch_M2S(Slave_Port_Num:Int,Data_Width:Int) extends Component{
    val io=new Bundle{//master to Slave,一个master口转成多个Slave口
        val Switch=in Bits(Slave_Port_Num bits)
    }
    noIoPrefix()
    val m0_axis_mm2s=new Bundle{//一个主接口，多个从接口
        val tdata=out UInt(Data_Width bits)
        val tkeep=out Bits(Data_Width/8 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    val s=Vec(new Bundle{        
        val axis_s2mm_tdata=in UInt(Data_Width bits)
        val axis_s2mm_tkeep=in Bits(Data_Width/8 bits)
        val axis_s2mm_tlast=in Bool()
        val axis_s2mm_tready=out Bool()
        val axis_s2mm_tvalid=in Bool()
        axis_s2mm_tready:=False
    },Slave_Port_Num)//生成这么多个slave口，放左边
    m0_axis_mm2s.tdata:=0
    m0_axis_mm2s.tkeep:=0
    m0_axis_mm2s.tlast:=False
    m0_axis_mm2s.tvalid:=False
    for(i<-0 to Slave_Port_Num-1){
        when(io.Switch(i)){
            s(i).axis_s2mm_tready:=m0_axis_mm2s.tready//出去的ready
            m0_axis_mm2s.tkeep:=s(i).axis_s2mm_tkeep
            m0_axis_mm2s.tdata:=s(i).axis_s2mm_tdata
            m0_axis_mm2s.tlast:=s(i).axis_s2mm_tlast
            m0_axis_mm2s.tvalid:=s(i).axis_s2mm_tvalid
        }
    }
}
class Axis_Switch_S2M(Master_Port_Num:Int,Data_Width:Int) extends Component{
    val io=new Bundle{//Slave to Master,1个Slave转成多个master口
        val Switch=in Bits(Master_Port_Num bits)
    }
        noIoPrefix()
    val s0_axis_s2mm=new Bundle{//一个从接口，多个主接口
        val tdata=in UInt(Data_Width bits)
        val tkeep=in Bits(Data_Width/8 bits)
        val tlast=in Bool()
        val tready=out Bool()
        val tvalid=in Bool()
    }

    val m=Vec(new Bundle{        
        val axis_mm2s_tdata=out UInt(Data_Width bits)
        val axis_mm2s_tkeep=out Bits(Data_Width/8 bits)
        val axis_mm2s_tlast=out Bool()
        val axis_mm2s_tready=in Bool()
        val axis_mm2s_tvalid=out Bool()
        axis_mm2s_tkeep:=s0_axis_s2mm.tkeep
        },Master_Port_Num)
    s0_axis_s2mm.tready:=False
    for(i<-0 to Master_Port_Num-1){
        when(io.Switch(i)){
            s0_axis_s2mm.tready:=m(i).axis_mm2s_tready
            m(i).axis_mm2s_tdata:=s0_axis_s2mm.tdata
            m(i).axis_mm2s_tlast:=s0_axis_s2mm.tlast
            m(i).axis_mm2s_tvalid:=s0_axis_s2mm.tvalid
        }otherwise{
            m(i).axis_mm2s_tdata:=0
            m(i).axis_mm2s_tlast:=False
            m(i).axis_mm2s_tvalid:=False
        }
    }
}

class SA_3D_SwitchVersion(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int,val MODULE_NUM:Int=6) extends Component{
    val Config=TopConfig()
    val Control=new Bundle{
        val start=in Bool()
        val Switch             =in Bits(MODULE_NUM bits)//模块选择
        val QuantSwitch        =in Bits(2 bits)//模块选择
        val OutputSwitch       =in Bits(2 bits)
        val Dma_TX_Int         =in Bool()//DMA发送中断，也就是DMA那边数据已经发送完成了
        //val InputSwitch        =in Bits(MODULE_NUM bits)
    }
    val s_axis_s2mm=new Bundle{//一个从接口，两个主接口
        val Data_Width=64
        val tdata=in UInt(Data_Width bits)
        val tkeep=in Bits(Data_Width/8 bits)
        val tlast=in Bool()
        val tready=out Bool()
        val tvalid=in Bool()
    }

    val QuantInstru=new Bundle{
      val zeroIn=in UInt(8 bits)//量化零点
    }
    val Img2Col_Instru=new Bundle{
        val Stride                          =in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size                     =in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size                     =in UInt(16 bits)
        val InFeature_Size                  =in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel               =in UInt(16 bits)//输入通道的信息已经包含在WindowSize中，可能以后用不到了
        val OutFeature_Channel              =in UInt(16 bits)
        val OutFeature_Size                 =in UInt(16 bits)//输出特征图的大小     
        val Sliding_Size                    =in UInt(16-3 bits)                                       
        val OutCol_Count_Times              =in UInt(16 bits)
        val InCol_Count_Times               =in UInt(16 bits)//这玩意又是啥？
        val OutRow_Count_Times              =in UInt(16 bits)
        val OutFeature_Channel_Count_Times  =in UInt(16 bits)
        

        val WeightMatrix_Row                =in UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits)

        val OutMatrix_Col                   =in UInt(Config.MATRIXC_COL_WIDTH bits)//输出矩阵的列数，比如脉动阵列最终的输出矩阵C为196*768，那么行数和列数分别书196*768
        val OutMatrix_Row                   =in UInt(Config.MATRIXC_ROW_WIDTH bits)//输出矩阵的行数
        
        
        //val LayerNorm_TokenNums             =in UInt(16 bits)//TokenNums Ceil(OutMatrix_Row/8)

    }
    val Gemm_Instru=new Bundle{
        val Gemm_Height=in UInt(16 bits)
        val Gemm_Width=in UInt(16 bits)
    }
    Img2Col_Instru.setName("Img2Col")
    // val Fsm=TopCtrl_Fsm(Control.start)
    val LayerEnd=Control.Dma_TX_Int//DMA发送数据完毕的中断
    // Fsm.Compute_End:=LayerEnd
    // val InitCnt=WaCounter(Fsm.currentState===TopCtrl_Enum.INIT,3,5)
    // Fsm.Inited:=InitCnt.valid
    val SWITCH_WEIGHT  =0
    val SWITCH_QUANT   =1
    val SWITCH_IMG2COL =2
    val SWITCH_LAYERNORM=3
    val SWITCH_GEMM=4
    val SWITCH_SOFTTMAX=5
    
    //数据流程：先缓存权重，包块卷积计算权重，量化权重，非线性算子的权重，最后再进图片
    val InputSwitch=new Axis_Switch_S2M(MODULE_NUM,64)//5个接口
    // val ConvQuantSwitch=new Axis_Switch_M2S(3,64)//卷积量化模块出来switch一下
    val Quant_Switch=new Axis_Switch_S2M(2,64)
    
    val OutputSwitch=new Axis_Switch_M2S(2,64)//
    InputSwitch.io.Switch:=Control.Switch
    InputSwitch.setDefinitionName("Compute_DataIn_Switch")//#todo 这些常用的可配置模块应该对其重命名

    
    InputSwitch.s0_axis_s2mm<>s_axis_s2mm




    noIoPrefix()
    val SubModule_WeightCache   =new WeightCache_Stream(SLICE,HEIGHT,WIDTH,64)//1
    val SubModule_ConvQuant     =new ConvQuant//2
    val SubModule_Img2Col       =new Img2ColStreamV2//3
    val SubModule_LayerNorm     =new LayerNorm_Top//4
    // val SubModule_Softmax       =new SoftMax_Top //5
    val SubModule_SA_3D         =new SA_3D(SLICE,HEIGHT,WIDTH,ACCU_WITDH)//8*8*8的脉动阵列
    val SubModule_Flatten       =new Flatten(SLICE,HEIGHT,WIDTH,ACCU_WITDH)
    val SubModule_DataArrange   =new ConvArrangeV3(1,HEIGHT,WIDTH)//由于前面已经有一个Flatten模块，所以后面的数据都是2维的矩阵
    val SubModule_GEMM          =new GemmCache
    
    //#todo---这里以后如果添加了矩阵计算模块要重新switch
    when(Control.Switch(SWITCH_GEMM)){
        for(i<-0 to HEIGHT-1){
            for(j<-0 to SLICE-1){
                SubModule_SA_3D.SA_Inputs(j).MatrixA(i):=SubModule_GEMM.io.mData((i+1)*8-1 downto i*8).asSInt//SLICE轴的每一行的输入一样
                SubModule_SA_3D.SA_Inputs(j).A_Valid(i):=SubModule_GEMM.io.validOut(i)
            }
        }
    }otherwise{    
        for(i<-0 to HEIGHT-1){
            for(j<-0 to SLICE-1){
                SubModule_SA_3D.SA_Inputs(j).MatrixA(i):=SubModule_Img2Col.io.mData((i+1)*8-1 downto i*8).asSInt//SLICE轴的每一行的输入一样
                SubModule_SA_3D.SA_Inputs(j).A_Valid(i):=SubModule_Img2Col.io.mValid(i)
            }
        }
    }
    for(j<-0 to SLICE-1){
      SubModule_SA_3D.SA_Inputs(j).signCount :=Img2Col_Instru.WeightMatrix_Row-1
    }
    SubModule_SA_3D.start:=Control.start
    SubModule_Img2Col.io.s_axis_s2mm_tdata   <>InputSwitch.m(SWITCH_IMG2COL).axis_mm2s_tdata
    SubModule_Img2Col.io.s_axis_s2mm_tkeep   <>InputSwitch.m(SWITCH_IMG2COL).axis_mm2s_tkeep
    SubModule_Img2Col.io.s_axis_s2mm_tlast   <>InputSwitch.m(SWITCH_IMG2COL).axis_mm2s_tlast
    SubModule_Img2Col.io.s_axis_s2mm_tready  <>InputSwitch.m(SWITCH_IMG2COL).axis_mm2s_tready
    SubModule_Img2Col.io.s_axis_s2mm_tvalid  <>InputSwitch.m(SWITCH_IMG2COL).axis_mm2s_tvalid
    SubModule_GEMM.io.sData.payload          <>InputSwitch.m(SWITCH_GEMM).axis_mm2s_tdata
    SubModule_GEMM.io.sData.valid            <>InputSwitch.m(SWITCH_GEMM).axis_mm2s_tvalid
    SubModule_GEMM.io.sData.ready            <>InputSwitch.m(SWITCH_GEMM).axis_mm2s_tready
    SubModule_Img2Col.io.Stride                        <>Img2Col_Instru.Stride                        
    SubModule_Img2Col.io.Kernel_Size                   <>Img2Col_Instru.Kernel_Size                   
    SubModule_Img2Col.io.Window_Size                   <>Img2Col_Instru.Window_Size                   
    SubModule_Img2Col.io.InFeature_Size                <>Img2Col_Instru.InFeature_Size                
    SubModule_Img2Col.io.InFeature_Channel             <>Img2Col_Instru.InFeature_Channel             
    SubModule_Img2Col.io.OutFeature_Channel            <>Img2Col_Instru.OutFeature_Channel            
    SubModule_Img2Col.io.OutFeature_Size               <>Img2Col_Instru.OutFeature_Size               
    SubModule_Img2Col.io.OutCol_Count_Times            <>Img2Col_Instru.OutCol_Count_Times            
    SubModule_Img2Col.io.InCol_Count_Times             <>Img2Col_Instru.InCol_Count_Times             
    SubModule_Img2Col.io.OutRow_Count_Times            <>Img2Col_Instru.OutRow_Count_Times            
    SubModule_Img2Col.io.OutFeature_Channel_Count_Times<>Img2Col_Instru.OutFeature_Channel_Count_Times
    SubModule_Img2Col.io.Sliding_Size                  <>Img2Col_Instru.Sliding_Size  

    SubModule_GEMM.io.HIGHT                             <>Gemm_Instru.Gemm_Height.resized
    SubModule_GEMM.io.WIDTH                             <>Gemm_Instru.Gemm_Width.resized
    SubModule_GEMM.io.WEIGHTCOL                         <>Img2Col_Instru.OutFeature_Channel.resized//这里矩阵计算的列位宽暂时先设置为最大就12bit
    val GemmStart=Control.start&Control.Switch(SWITCH_GEMM)
    SubModule_GEMM.io.start                             :=RegNext(~GemmStart)&GemmStart

    for(i<-0 to WIDTH-1){//遍历每一列
        for(j<-0 to SLICE-1){//遍历每个slice，slice是最内层循环
            SubModule_SA_3D.SA_Inputs(j).MatrixB(i):=Delay(SubModule_WeightCache.io.mData(i*SLICE+j).asSInt,i)
            SubModule_SA_3D.SA_Inputs(j).B_Valid(i):=Delay(SubModule_WeightCache.io.MatrixCol_Switch(i*SLICE+j),i)//权重数据在进入SA之前需要做一下延迟
            //这里在仿真的时候很绕，需要注意(见pic0和pic1)
        }
    }

    SubModule_Img2Col.io.start                      :=Control.start&Control.Switch(SWITCH_IMG2COL)//启动Img2Col，必须在权重缓存完后才能启动Img2Col，缓存的权重中还包含了量化因子
    
    SubModule_WeightCache.io.Matrix_Row :=Img2Col_Instru.WeightMatrix_Row
    SubModule_WeightCache.io.Matrix_Col :=Img2Col_Instru.OutFeature_Channel
    SubModule_WeightCache.io.start      :=Control.Switch(SWITCH_WEIGHT)&Control.start
    // SubModule_WeightCache.io.Raddr_Valid:=SubModule_Img2Col.io.Raddr_Valid//||LH_Gemm.io.bvalid---todo，重点关注
    SubModule_WeightCache.io.Raddr_Valid            :=SubModule_Img2Col.io.Raddr_Valid
    SubModule_WeightCache.io.LayerEnd   :=LayerEnd
    // Fsm.WeightCached          :=SubModule_WeightCache.io.Weight_Cached//(ConvQuant.io.QuantPara_Cached)---todo,重点关注

    SubModule_WeightCache.io.s_axis_s2mm_tdata <>InputSwitch.m(SWITCH_WEIGHT).axis_mm2s_tdata//RegNext(InputSwitch.m(0).axis_mm2s_tdata)
    SubModule_WeightCache.io.s_axis_s2mm_tkeep <>InputSwitch.m(SWITCH_WEIGHT).axis_mm2s_tkeep
    SubModule_WeightCache.io.s_axis_s2mm_tlast <>InputSwitch.m(SWITCH_WEIGHT).axis_mm2s_tlast
    SubModule_WeightCache.io.s_axis_s2mm_tready<>InputSwitch.m(SWITCH_WEIGHT).axis_mm2s_tready
    SubModule_WeightCache.io.s_axis_s2mm_tvalid<>InputSwitch.m(SWITCH_WEIGHT).axis_mm2s_tvalid//RegNext(InputSwitch.m(0).axis_mm2s_tvalid)
    
    
    //卷积量化模块==============================================================================================================
    val DELAY_TIMES=15//#todo 延迟的级数，需要确定
    for(i<-0 to HEIGHT-1){
      for(j<-0 to SLICE-1){
        SubModule_Flatten.sData.payload(i)(j):=SubModule_SA_3D.Matrix_C.payload(i)(ACCU_WITDH*(j+1)-1 downto ACCU_WITDH*j)
        // SubModule_Flatten.sData.valid(i)     :=SubModule_SA_3D.Matrix_C.valid(i)
      }
      SubModule_Flatten.sData.valid(i)     :=SubModule_SA_3D.Matrix_C.valid(i)
    }
    SubModule_ConvQuant.io.start          :=Control.start&Control.Switch(SWITCH_QUANT)
    for(i<-0 to HEIGHT-1){
      SubModule_ConvQuant.io.dataIn(i)         :=SubModule_Flatten.mData(i).payload.asSInt
      SubModule_ConvQuant.io.Quant_State       <>SubModule_Flatten.mData(i).ready
    }    
    
        // ConvQuant.io.dataOut<>mData.payload
    SubModule_ConvQuant.io.LayerEnd       :=LayerEnd//Control.LayerEnd
    SubModule_ConvQuant.io.OutMatrix_Col  :=Img2Col_Instru.OutFeature_Channel//输出矩阵的列数
    SubModule_ConvQuant.io.zeroIn         :=QuantInstru.zeroIn
    SubModule_ConvQuant.io.SAOutput_Valid :=SubModule_Flatten.mData(0).valid
    SubModule_ConvQuant.io.sData.payload<>  InputSwitch.m(SWITCH_QUANT).axis_mm2s_tdata
    SubModule_ConvQuant.io.sData.valid<>    InputSwitch.m(SWITCH_QUANT).axis_mm2s_tvalid
    SubModule_ConvQuant.io.sData.ready<>    InputSwitch.m(SWITCH_QUANT).axis_mm2s_tready

    //Quant完了再加一个Switch
    
    Quant_Switch.io.Switch:=Control.QuantSwitch //#todo 待修改
    
    Quant_Switch.s0_axis_s2mm.tdata:=SubModule_ConvQuant.io.dataOut//对COnvQuant出来的数据进行switch
    Quant_Switch.s0_axis_s2mm.tkeep.setAll()
    Quant_Switch.s0_axis_s2mm.tlast:=False
    Quant_Switch.s0_axis_s2mm.tvalid:=Delay(SubModule_SA_3D.Matrix_C.valid(0),DELAY_TIMES)


    //DataArrange 模块--(ConvQuant-->DataArrange)============================================================================================================================
    

    
    SubModule_DataArrange.io.MatrixCol:=Img2Col_Instru.OutMatrix_Col
    SubModule_DataArrange.io.MatrixRow:=Img2Col_Instru.OutMatrix_Row
    SubModule_DataArrange.io.start    :=Control.start&Control.Switch(SWITCH_WEIGHT)//只要缓存权重，那么一定会启动Arrange模块。
    SubModule_DataArrange.io.OutChannel:=Img2Col_Instru.OutFeature_Channel.resized
    SubModule_DataArrange.io.OutFeatureSize:=Img2Col_Instru.OutFeature_Size
    SubModule_DataArrange.io.SwitchConv:=Control.Switch(SWITCH_IMG2COL)//#todo 以后这里添加了Gemm后，要记得修改


    OutputSwitch.s(0).axis_s2mm_tdata:=SubModule_DataArrange.io.mData.payload
    OutputSwitch.s(0).axis_s2mm_tlast:=SubModule_DataArrange.io.mLast
    OutputSwitch.s(0).axis_s2mm_tvalid:=SubModule_DataArrange.io.mData.valid
    OutputSwitch.s(0).axis_s2mm_tkeep.setAll()
    SubModule_DataArrange.io.mData.ready:=OutputSwitch.s(0).axis_s2mm_tready
    for(i<-0 to HEIGHT-1){//遍历行
      SubModule_DataArrange.io.sData(i):=Quant_Switch.m(0).axis_mm2s_tdata((i+1)*8-1 downto i*8)//从现在开始约定好，输出的数据都用vec描述，Vec的大小就是HEIGHT每一行都与DataArrange一一对应
      SubModule_DataArrange.io.sValid(i):=Delay(SubModule_Flatten.mData(i).valid,DELAY_TIMES)
    }
    Quant_Switch.m(0).axis_mm2s_tready:=SubModule_DataArrange.io.sReady


    //LayerNrom===============================================================================================================================================================
    //val DELAY_TIMES=15//#todo 延迟的级数，需要确定

    SubModule_LayerNorm.io.start          :=Control.start&Control.Switch(SWITCH_LAYERNORM)//当ConvQuant模块的权重缓存完后，才能启动Layernorm
    for(i<-0 to HEIGHT-1){//还是决定实现8并行度的LayerNorm
      SubModule_LayerNorm.io.sData(i)     :=Quant_Switch.m(1).axis_mm2s_tdata((i+1)*8-1 downto i*8).asSInt
    }
    SubModule_LayerNorm.io.sValid         :=Delay(SubModule_SA_3D.Matrix_C.valid(0),DELAY_TIMES)
    
    SubModule_LayerNorm.io.Channel_Nums   :=Img2Col_Instru.OutMatrix_Col.resized//ChannelNum也就就是矩阵C的列数
    SubModule_LayerNorm.io.Token_Nums     :=((Img2Col_Instru.OutMatrix_Row>>log2Up(HEIGHT))+Img2Col_Instru.OutMatrix_Row((log2Up(HEIGHT)-1) downto log2Up(HEIGHT)-1)).resized//TokenNum即矩阵C的列数(默认layerNorm的并行的为1)
    //这里实际上是在执行TokenNums=ceil(OutMatric_Row/8)这个向上取整的操作
    SubModule_LayerNorm.io.ScaleBias_In.payload:=InputSwitch.m(SWITCH_LAYERNORM).axis_mm2s_tdata
    SubModule_LayerNorm.io.ScaleBias_In.valid:=InputSwitch.m(SWITCH_LAYERNORM).axis_mm2s_tvalid
    InputSwitch.m(SWITCH_LAYERNORM).axis_mm2s_tready:=SubModule_LayerNorm.io.ScaleBias_In.ready

    // SubModule_LayerNorm.io.ScaleBias_In.ready<>InputSwitch.m(0).axis_mm2s_tready
    SubModule_LayerNorm.io.ZeroPoint:=QuantInstru.zeroIn.asSInt
    //SubModule_LayerNorm.io.mData.payload(7 downto 0)
    //SubModule_LayerNorm.io.mData.ready:=True//#todo 以后这个mready应该接到外部输出,,已经接到了外部输出20231108
    for(i<- 0 to HEIGHT-1){//#todo 要修改
      //SubModule_LayerNorm.io.mData.payload((i+1)*8-1 downto i*8).asUInt<>SubModule_DataArrange.io.sData(i)
    }

    if(Config.ila){//抓脉动阵列的输出
        val Debug_Signals=Array[Bits](
            SubModule_SA_3D.Matrix_C.payload(0).asBits,
            SubModule_SA_3D.Matrix_C.payload(1).asBits,
            SubModule_SA_3D.Matrix_C.payload(2).asBits,
            SubModule_SA_3D.Matrix_C.payload(3).asBits,
            SubModule_SA_3D.Matrix_C.payload(4).asBits,
            SubModule_SA_3D.Matrix_C.payload(5).asBits,
            SubModule_SA_3D.Matrix_C.payload(6).asBits,
            SubModule_SA_3D.Matrix_C.payload(7).asBits,
            SubModule_SA_3D.Matrix_C.valid.asBits
        
        )
        val ila=new xil_ila(Debug_Signals,true,"ila_SA_output")
        for(i<-0 to Debug_Signals.length-1){
            ila.probe(i):=Debug_Signals(i)
        }
    }
    val m_axis_mm2s=new Bundle{
        val Data_Width=64
        val tdata=out UInt(Data_Width bits)
        val tkeep=out Bits(Data_Width/8 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    OutputSwitch.m0_axis_mm2s<>m_axis_mm2s
    OutputSwitch.s(1).axis_s2mm_tdata:=SubModule_LayerNorm.io.mData.payload.asUInt
    OutputSwitch.s(1).axis_s2mm_tlast:=SubModule_LayerNorm.io.mLast
    OutputSwitch.s(1).axis_s2mm_tvalid:=SubModule_LayerNorm.io.mData.valid
    OutputSwitch.s(1).axis_s2mm_tready<>SubModule_LayerNorm.io.mData.ready
    OutputSwitch.s(1).axis_s2mm_tkeep.setAll()
    OutputSwitch.io.Switch:=Control.OutputSwitch
}   


object SA_3D_Switch extends App { //
    val verilog_path="./verilog/SA_3D" //(1,8,64,32,4)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_3D_SwitchVersion(3,8,64,32,4))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_3D_SwitchVersion(8,8,16,32,4))
    
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}