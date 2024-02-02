package Systolic_Array.SystolicArray3D
//将img2col模块和SA 3D 模块组合起来
import spinal.core._
import spinal.lib.slave
import utils._
import spinal.lib.Delay
import Systolic_Array.Quant.ConvQuant
import LayerNorm.LayerNorm_Top
import spinal.lib.StreamWidthAdapter
import Systolic_Array.Quant.Quan
object TopCtrl_Enum extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, WEIGHT_CACHE,RECEIVE_PICTURE,RECEIVE_MATRIX,WAIT_COMPUTE_END= newElement
    //WEIGHT_CACHE:缓存权重
      //缓存的权重包含B矩阵权重和量化参数
    //RECEIVE_PICTURE:接收图片数据
    //RECEIVE_MATRIX:接收矩阵数据
    //WAITEND:等待计算结束

}
case class TopCtrl_Fsm(start:Bool)extends Area{
    val currentState = Reg(TopCtrl_Enum()) init TopCtrl_Enum.IDLE
    val nextState = TopCtrl_Enum()
    currentState := nextState

    val Inited=Bool()
    val WeightCached=Bool()
    val Picture_Received=Bool()
    val Matrix_Received=Bool()
    val Compute_End=Bool()

    val Switch_Conv=Bool()

    switch(currentState){
      is(TopCtrl_Enum.IDLE){
        when(start){
          nextState:=TopCtrl_Enum.INIT
        }otherwise{
          nextState:=TopCtrl_Enum.IDLE
        }
      }
      is(TopCtrl_Enum.INIT){
        when(Inited){
          nextState:=TopCtrl_Enum.WEIGHT_CACHE
        }otherwise{
          nextState:=TopCtrl_Enum.INIT
        }
      }
      is(TopCtrl_Enum.WEIGHT_CACHE){
        when(WeightCached&&Switch_Conv){
          nextState:=TopCtrl_Enum.RECEIVE_PICTURE
        }elsewhen(WeightCached&&(~Switch_Conv)){
          nextState:=TopCtrl_Enum.RECEIVE_MATRIX
        }otherwise{
          nextState:=TopCtrl_Enum.WEIGHT_CACHE
        }
      }
      is(TopCtrl_Enum.RECEIVE_PICTURE){
        when(Picture_Received){
          nextState:=TopCtrl_Enum.WAIT_COMPUTE_END
        }otherwise{
          nextState:=TopCtrl_Enum.RECEIVE_PICTURE
        }
      }
      is(TopCtrl_Enum.RECEIVE_MATRIX){
        when(Matrix_Received){
          nextState:=TopCtrl_Enum.WAIT_COMPUTE_END
        }otherwise{
          nextState:=TopCtrl_Enum.RECEIVE_MATRIX
        }
      }
      is(TopCtrl_Enum.WAIT_COMPUTE_END){
        when(Compute_End){
          nextState:=TopCtrl_Enum.IDLE
        }otherwise{
          nextState:=TopCtrl_Enum.WAIT_COMPUTE_END
        }
      }
    }
}
class SA3D_Top(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int) extends Component{
    val Config=TopConfig()
    val Control=new Bundle{
        val start=in Bool()
        //val Inswitch=in UInt(2 bits)
        //val OutSwitch           =in UInt(2 bits)
        val Switch_Conv         =in Bool()//切换到卷积计算
        // val Matrix2Img          =in Bool()
        // val LayerEnd            =in Bool()//数据量化完成，输出完成
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
    Img2Col_Instru.setName("Img2Col")
    val Fsm=TopCtrl_Fsm(Control.start)
    val LayerEnd=Bool()
    Fsm.Compute_End:=LayerEnd
    val InitCnt=WaCounter(Fsm.currentState===TopCtrl_Enum.INIT,3,5)
    Fsm.Inited:=InitCnt.valid

    val InputSwitch=new Axis_Switch_1s(2,64)//1个从接口，一个给img2col，一个给weight
    InputSwitch.setDefinitionName("Compute_DataIn_Switch")
    //val OutputSwitch=new Axis_Switch_2s(1,64)//2个从接口
    // OutputSwitch.setDefinitionName("Compute_DataOut_Switch")
    
    InputSwitch.s0_axis_s2mm<>s_axis_s2mm
    // OutputSwitch.m0_axis_mm2s<>m_axis_mm2s
    when(Fsm.currentState===TopCtrl_Enum.WEIGHT_CACHE){//0：加载权重，1：加载图片，2：加载矩阵
        InputSwitch.io.Switch:=0
    }elsewhen(Control.Switch_Conv){
        InputSwitch.io.Switch:=1//切换到卷积通道
    }otherwise{
        InputSwitch.io.Switch:=2//切换到Gemm通道
    }

    noIoPrefix()
    val SubModule_Img2Col       =new Img2ColStreamV2
    val SubModule_SA_3D         =new SA_3D(SLICE,HEIGHT,WIDTH,ACCU_WITDH)//8*8*8的脉动阵列
    val SubModule_WeightCache   =new WeightCache_Stream(8,8,8,64)//权重缓存模块
    val SubModule_Flatten       =new Flatten(SLICE,HEIGHT,WIDTH,ACCU_WITDH)
    val SubModule_DataArrange   =new ConvArrangeV3(SLICE,HEIGHT,WIDTH)
    val SubModule_ConvQuant     =new ConvQuant
    val SubModule_LayerNorm     =new LayerNorm_Top

    //todo---这里以后如果添加了矩阵计算模块要重新switch
    for(i<-0 to HEIGHT-1){
        for(j<-0 to SLICE-1){
            SubModule_SA_3D.SA_Inputs(j).MatrixA(i):=SubModule_Img2Col.io.mData((i+1)*8-1 downto i*8).asSInt//SLICE轴的每一行的输入一样
            SubModule_SA_3D.SA_Inputs(j).A_Valid(i):=SubModule_Img2Col.io.mValid(i)
        }
    }
    for(j<-0 to SLICE-1){
      SubModule_SA_3D.SA_Inputs(j).signCount :=Img2Col_Instru.WeightMatrix_Row-1
    }

    
    SubModule_SA_3D.start:=Control.start

    SubModule_Img2Col.io.s_axis_s2mm_tdata   <>InputSwitch.m(1).axis_mm2s_tdata
    SubModule_Img2Col.io.s_axis_s2mm_tkeep   <>InputSwitch.m(1).axis_mm2s_tkeep
    SubModule_Img2Col.io.s_axis_s2mm_tlast   <>InputSwitch.m(1).axis_mm2s_tlast
    SubModule_Img2Col.io.s_axis_s2mm_tready  <>InputSwitch.m(1).axis_mm2s_tready
    SubModule_Img2Col.io.s_axis_s2mm_tvalid  <>InputSwitch.m(1).axis_mm2s_tvalid

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
    // SubModule_Img2Col.io.start                         <>Control.start      

    // SubModule_Img2Col.io.Raddr_Valid                   <>SubModule_WeightCache.io.Raddr_Valid//延时已经在Img2Col里做了
    //SubModule_Img2Col.io.LayerEnd                      <>SubModule_WeightCache.io.LayerEnd        

    for(i<-0 to WIDTH-1){//遍历每一列
        for(j<-0 to SLICE-1){//遍历每个slice，slice是最内层循环
            SubModule_SA_3D.SA_Inputs(j).MatrixB(i):=Delay(SubModule_WeightCache.io.mData(i*SLICE+j).asSInt,i)
            SubModule_SA_3D.SA_Inputs(j).B_Valid(i):=Delay(SubModule_WeightCache.io.MatrixCol_Switch(i*SLICE+j),i)//权重数据在进入SA之前需要做一下延迟
            //这里在仿真的时候很绕，需要注意(见pic0和pic1)
        }
    }

    SubModule_Img2Col.io.start                      :=Delay(SubModule_WeightCache.io.Weight_Cached,3)&&(Control.Switch_Conv)//权重缓存完了才启动img2col以及卷积计算
    // Fsm.Picture_Received                            :=SubModule_Img2Col.io.LayerEnd//||LH_Gemm.io.LayerEnd---重点关注
    Fsm.Switch_Conv                                 :=Control.Switch_Conv
//WeightCache模块控制=================================================================================================================================
    
    SubModule_WeightCache.io.Matrix_Row :=Img2Col_Instru.WeightMatrix_Row
    SubModule_WeightCache.io.Matrix_Col :=Img2Col_Instru.OutFeature_Channel
    SubModule_WeightCache.io.start      :=Delay(Fsm.nextState===TopCtrl_Enum.WEIGHT_CACHE,3)
    // SubModule_WeightCache.io.Raddr_Valid:=SubModule_Img2Col.io.Raddr_Valid//||LH_Gemm.io.bvalid---todo，重点关注
    SubModule_WeightCache.io.LayerEnd   :=LayerEnd
    // Fsm.WeightCached          :=SubModule_WeightCache.io.Weight_Cached//(ConvQuant.io.QuantPara_Cached)---todo,重点关注

    SubModule_WeightCache.io.s_axis_s2mm_tdata <>InputSwitch.m(0).axis_mm2s_tdata//RegNext(InputSwitch.m(0).axis_mm2s_tdata)
    SubModule_WeightCache.io.s_axis_s2mm_tkeep <>InputSwitch.m(0).axis_mm2s_tkeep
    SubModule_WeightCache.io.s_axis_s2mm_tlast <>InputSwitch.m(0).axis_mm2s_tlast
    SubModule_WeightCache.io.s_axis_s2mm_tready<>InputSwitch.m(0).axis_mm2s_tready
    SubModule_WeightCache.io.s_axis_s2mm_tvalid<>InputSwitch.m(0).axis_mm2s_tvalid//RegNext(InputSwitch.m(0).axis_mm2s_tvalid)
    // //当B矩阵缓存完后应该继续缓存量化参数--重点关注
    // when(SubModule_WeightCache.io.s_axis_s2mm_tready){
    //     InputSwitch.m(0).axis_mm2s_tready:=SubModule_WeightCache.io.s_axis_s2mm_tready
    // }otherwise{
    //     InputSwitch.m(0).axis_mm2s_tready:=SubModule_ConvQuant.io.sData.ready
    // }
    // SubModule_ConvQuant.io.sData.payload<>InputSwitch.m(0).axis_mm2s_tdata
    // SubModule_ConvQuant.io.sData.valid<>InputSwitch.m(0).axis_mm2s_tvalid
//GEMM模块控制=================================================================================================================================
    Fsm.Matrix_Received:=False
//阵列输出数据展平模块--[SA_3D-->Flatten]==============================================================================================================
    for(i<-0 to HEIGHT-1){
      for(j<-0 to SLICE-1){
        SubModule_Flatten.sData.payload(i)(j):=SubModule_SA_3D.Matrix_C.payload(i)(ACCU_WITDH*(j+1)-1 downto ACCU_WITDH*j)
        SubModule_Flatten.sData.valid(i)     :=SubModule_SA_3D.Matrix_C.valid(i)
      }
    }
    
//ConvQuant 模块---[Flatten->ConvQuant]============================================================================================================================
    SubModule_ConvQuant.io.start          :=SubModule_WeightCache.io.Weight_Cached
    
    for(i<-0 to HEIGHT-1){
      SubModule_ConvQuant.io.dataIn(i)         :=SubModule_Flatten.mData(i).payload.asSInt
    }

    // ConvQuant.io.dataOut<>mData.payload
    SubModule_ConvQuant.io.LayerEnd       :=LayerEnd//Control.LayerEnd
    SubModule_ConvQuant.io.OutMatrix_Col  :=Img2Col_Instru.OutFeature_Channel//输出矩阵的列数
    SubModule_ConvQuant.io.zeroIn         :=QuantInstru.zeroIn
    SubModule_ConvQuant.io.SAOutput_Valid :=SubModule_Flatten.mData(0).valid
    
//LayerNorm---(ConvQuant --> LayerNorm)=====================================================================================================
    val DELAY_TIMES=15//#todo 延迟的级数，需要确定

    SubModule_LayerNorm.io.start          :=SubModule_ConvQuant.io.QuantPara_Cached//当ConvQuant模块的权重缓存完后，才能启动Layernorm
    for(i<-0 to HEIGHT-1){//还是决定实现8并行度的LayerNorm
      SubModule_LayerNorm.io.sData(i)     :=(SubModule_ConvQuant.io.dataOut((i+1)*8-1 downto i*8).asSInt).resized//这里输入的数据是(Xq-Zp)移位后的19bit数据
    }
    SubModule_LayerNorm.io.sValid         :=Delay(SubModule_SA_3D.Matrix_C.valid(0),DELAY_TIMES)
    
    SubModule_LayerNorm.io.Channel_Nums   :=Img2Col_Instru.OutMatrix_Col.resized//ChannelNum也就就是矩阵C的列数
    SubModule_LayerNorm.io.Token_Nums     :=((Img2Col_Instru.OutMatrix_Row>>log2Up(HEIGHT))+Img2Col_Instru.OutMatrix_Row((log2Up(HEIGHT)-1) downto log2Up(HEIGHT)-1)).resized//TokenNum即矩阵C的列数(默认layerNorm的并行的为1)
    //这里实际上是在执行TokenNums=ceil(OutMatric_Row/8)这个向上取整的操作
    SubModule_LayerNorm.io.ScaleBias_In.payload:=InputSwitch.m(0).axis_mm2s_tdata
    SubModule_LayerNorm.io.ScaleBias_In.valid:=InputSwitch.m(0).axis_mm2s_tvalid
    // SubModule_LayerNorm.io.ScaleBias_In.ready<>InputSwitch.m(0).axis_mm2s_tready
    SubModule_LayerNorm.io.ZeroPoint:=QuantInstru.zeroIn.asSInt
    //SubModule_LayerNorm.io.mData.payload(7 downto 0)
    SubModule_LayerNorm.io.mData.ready:=SubModule_DataArrange.io.sReady//#todo 以后这个mready应该接到外部输出
    for(i<- 0 to HEIGHT-1){
      SubModule_LayerNorm.io.mData.payload((i+1)*8-1 downto i*8).asUInt<>SubModule_DataArrange.io.sData(i)
    }

//DataArrange 模块--(ConvQuant-->DataArrange)============================================================================================================================
    val m_axis_mm2s=new Bundle{//一个从接口，两个主接口
      val Data_Width=64
      val tdata=out UInt(Data_Width bits)
      val tkeep=out Bits(Data_Width/8 bits)
      val tlast=out Bool()
      val tready=in Bool()
      val tvalid=out Bool()
    }
    
    SubModule_DataArrange.io.MatrixCol:=Img2Col_Instru.OutMatrix_Col
    SubModule_DataArrange.io.MatrixRow:=Img2Col_Instru.OutMatrix_Row
    SubModule_DataArrange.io.start    :=Control.start
    SubModule_DataArrange.io.OutChannel:=Img2Col_Instru.OutFeature_Channel.resized
    SubModule_DataArrange.io.OutFeatureSize:=Img2Col_Instru.OutFeature_Size
    SubModule_DataArrange.io.SwitchConv:=Control.Switch_Conv

    

    m_axis_mm2s.tdata:=SubModule_DataArrange.io.mData.payload
    m_axis_mm2s.tlast:=SubModule_DataArrange.io.mLast
    m_axis_mm2s.tvalid:=SubModule_DataArrange.io.mData.valid
    m_axis_mm2s.tkeep.setAll()
    SubModule_DataArrange.io.mData.ready:=m_axis_mm2s.tready

    for(i<-0 to HEIGHT-1){//遍历行
      
      //SubModule_DataArrange.io.sData(i):=SubModule_ConvQuant.io.dataOut((i+1)*8-1 downto i*8)//从现在开始约定好，输出的数据都用vec描述，Vec的大小就是HEIGHT每一行都与DataArrange一一对应
      SubModule_DataArrange.io.sValid(i):=SubModule_LayerNorm.io.mData.valid
    }



//============================================================================================================================================
  //添加新模块后需要重点关注的信号放着这里
  Fsm.Picture_Received                            :=SubModule_Img2Col.io.LayerEnd//||LH_Gemm.io.LayerEnd---todo
  SubModule_WeightCache.io.Raddr_Valid            :=SubModule_Img2Col.io.Raddr_Valid//||LH_Gemm.io.bvalid---todo
  Fsm.WeightCached                                :=SubModule_LayerNorm.io.QuantPara_Cached//(ConvQuant.io.QuantPara_Cached)---todo
  //当B矩阵缓存完后应该继续缓存量化参数
  when(SubModule_WeightCache.io.s_axis_s2mm_tready){
      InputSwitch.m(0).axis_mm2s_tready:=SubModule_WeightCache.io.s_axis_s2mm_tready
  }elsewhen(SubModule_ConvQuant.io.sData.ready){
      InputSwitch.m(0).axis_mm2s_tready:=SubModule_ConvQuant.io.sData.ready
  }otherwise{
      InputSwitch.m(0).axis_mm2s_tready:=SubModule_LayerNorm.io.ScaleBias_In.ready//最后再存LayerNorm的：Scale和Bias
  }
  SubModule_ConvQuant.io.sData.payload<>InputSwitch.m(0).axis_mm2s_tdata
  SubModule_ConvQuant.io.sData.valid<>InputSwitch.m(0).axis_mm2s_tvalid
//最后的其他控制+==============================================================================================================================
    LayerEnd:=SubModule_DataArrange.io.LayerEnd
//
}



object SA3D_Generate extends App { 
    val verilog_path="./verilog/SA_3D" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA3D_Top(1,8,64,32))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}