package top.topV2
import spinal.core._
import Systolic_Array.{Tile,PEConfig}
import Systolic_Array.SystolicArray3D.Img2ColStreamV2

import Systolic_Array.BackUp.ConvArrangeV2
import Systolic_Array.LHMM.GemmCache
import Systolic_Array.weightV1.WeightCache_Stream
import RegTable.RegTable
import utils.{TopConfig,WaCounter,WidthConvert}
import spinal.lib.StreamFifo
import utils.AxisDataConverter
import spinal.lib.Delay
import utils.Axis_Switch_1s
import utils.Axis_Switch_2s
import spinal.lib.master

import Systolic_Array.Quant.ConvQuant
import javax.sound.midi.Instrument
import Systolic_Array.BackUp.ConvArrangeV3




class SA_Conv(Tile_Size: Int, dataWidthIn: Int, dataWidthOut: Int,peConfig:PEConfig) extends  Component{
  val Config=new TopConfig
  val io = new Bundle {
    val activate = in SInt (Tile_Size * dataWidthIn bits)
    val a_Valid = in Bits(Tile_Size bits)
    val weight = in SInt (Tile_Size * dataWidthIn bits)
    val b_Valid = in Bits(Tile_Size bits)

   
    val signCount = in UInt (16 bits) //卷积核16*16  signCoun就是t256
    val resultVaild = out Vec(Bool,Tile_Size)
    
    val OutMatrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)
    val OutMatrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)

    val OutChannel=in UInt(Config.DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH bits)
    val OutFeatureSize=in UInt(16 bits)
    // val Matrix2Img=in Bool()//Matrix to Image 将卷积后的矩阵结果按通道优先的图片格式输出
    val start=in Bool()
    // val LayerEnd=out Bool()
    val mData=out Vec(SInt(Config.addChannelTimesWidth bits),Config.SA_ROW)

    // val mLast=out Bool()
  }
  noIoPrefix()
  val Tile=new Tile(Tile_Size,dataWidthIn,dataWidthOut,peConfig)//脉动阵列
  //val Tile_Output=new ConvArrange//需要改名字，这里是将矩阵格式转化为图片通道优先格式
  //val MatrixFormat_Output=new MatrixOut(64,64,64)//不管是矩阵还是权重都按矩阵格式输出

  io.activate    <>Tile.io.activate
  io.weight      <>Tile.io.weight 
  io.signCount   <>Tile.io.signCount
  for(i<-0 to 7){
    Tile.io.a_Valid(i):=io.a_Valid(i downto i).asBool
    Tile.io.b_Valid(i):=io.b_Valid(i downto i).asBool
  }

  //io.OutChannel <>Tile_Output.io.OutChannel
  //Tile_Output.io.start:=io.start&&io.Matrix2Img 
  //io.OutFeatureSize <>Tile_Output.io.OutFeatureSize


  //io.OutMatrix_Col <>MatrixFormat_Output.io.OutMatrix_Col
  //io.OutMatrix_Row <>MatrixFormat_Output.io.OutMatrix_Row



  // for(i<-0 to Tile_Size-1){
  //   // Tile.io.PE_OUT(i)(7 downto 0).asUInt<>Tile_Output.io.sData((i+1)*8-1 downto i*8)//还没量化，所以只能截取低8位
  //   // Tile.io.PE_OUT(i)(7 downto 0).asUInt<>MatrixFormat_Output.io.sData.payload((i+1)*8-1 downto i*8)//还没量化，所以只能截取低8位
    
  // }
  io.mData<>Tile.io.PE_OUT
  Tile.io.resultVaild<>io.resultVaild//TODO，优化这里的valid信号数量
  // Tile.io.resultVaild(0)<>MatrixFormat_Output.io.sData.valid
  
  // io.LayerEnd:=Tile_Output.io.LayerEnd
  // io.mData<>Tile.io.mData
  // io.mLast:=Tile_Output.io.mLast

  
}


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
//权重图片各占一个DMA
class Conv extends Component{
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
  // val mData=new Bundle{
  //   val payload=out UInt(64 bits)
  //   // val valid=out Vec(Bool(),Config.SA_ROW)
  // }
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
  }
  Img2Col_Instru.setName("Img2Col")
  
  val GemmInstru=new Bundle{
    val WIDTH=in UInt(16 bits)
    val HEIGHT=in UInt(16 bits)
  }
  val QuantInstru=new Bundle{
    val zeroIn=in UInt(8 bits)
  }
  val Fsm=TopCtrl_Fsm(Control.start)
  val InitCnt=WaCounter(Fsm.currentState===TopCtrl_Enum.INIT,3,5)
  Fsm.Inited:=InitCnt.valid

  val InputSwitch=new Axis_Switch_1s(3,64)//1个从接口，一个给img2col，一个给weight
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
  //InputSwitch.io.Switch:=Control.Inswitch
  //OutputSwitch.io.Switch:=Control.OutSwitch//
  // when(Control.Switch_Conv){
  //   OutputSwitch.io.Switch:=0//因为先实现的卷积，所以这里0选择卷积输出，1选择Gemm输出
  // }otherwise{
  //   OutputSwitch.io.Switch:=1
  // }
  //整合img2col，脉动阵列以及数据输出
  val Compute_Unit=new SA_Conv(8,8,Config.addChannelTimesWidth,PEConfig(4*4*32,32))//计算单元
  val Weight_Unit=new WeightCache_Stream//权重缓存单元
  val Img2Col_Unit=new Img2ColStreamV2//img2col数据排列单元
  val LH_Gemm=new GemmCache
  val ConvQuant=new ConvQuant//卷积量化模块
  val DataOutput=new ConvArrangeV3

  Img2Col_Unit.io.s_axis_s2mm_tdata <>InputSwitch.m(1).axis_mm2s_tdata
  Img2Col_Unit.io.s_axis_s2mm_tkeep <>InputSwitch.m(1).axis_mm2s_tkeep
  Img2Col_Unit.io.s_axis_s2mm_tlast <>InputSwitch.m(1).axis_mm2s_tlast
  Img2Col_Unit.io.s_axis_s2mm_tready<>InputSwitch.m(1).axis_mm2s_tready
  Img2Col_Unit.io.s_axis_s2mm_tvalid<>InputSwitch.m(1).axis_mm2s_tvalid

  Img2Col_Unit.io.Stride                          <>Img2Col_Instru.Stride                          //置步长//DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
  Img2Col_Unit.io.Kernel_Size                     <>Img2Col_Instru.Kernel_Size                     ////DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
  Img2Col_Unit.io.Window_Size                     <>Img2Col_Instru.Window_Size                     //
  Img2Col_Unit.io.InFeature_Size                  <>Img2Col_Instru.InFeature_Size                  //输入多大的数据
  Img2Col_Unit.io.InFeature_Channel               <>Img2Col_Instru.InFeature_Channel               //能以后用不到了//)//输入通道的信息已经包含在WindowSize中，可能以后用不到了
  Img2Col_Unit.io.OutFeature_Channel              <>Img2Col_Instru.OutFeature_Channel              //
  Img2Col_Unit.io.OutFeature_Size                 <>Img2Col_Instru.OutFeature_Size                 //                    //)//输出特征图的大小                                            
  Img2Col_Unit.io.OutCol_Count_Times              <>Img2Col_Instru.OutCol_Count_Times              //
  Img2Col_Unit.io.InCol_Count_Times               <>Img2Col_Instru.InCol_Count_Times               //
  Img2Col_Unit.io.OutRow_Count_Times              <>Img2Col_Instru.OutRow_Count_Times              //
  Img2Col_Unit.io.OutFeature_Channel_Count_Times  <>Img2Col_Instru.OutFeature_Channel_Count_Times  //
  Img2Col_Unit.io.Sliding_Size                    <>Img2Col_Instru.Sliding_Size                    //
 
  Img2Col_Unit.io.start                           :=Delay(Weight_Unit.io.Weight_Cached,3)&&(Control.Switch_Conv)//权重缓存完了才启动img2col以及卷积计算
  Fsm.Picture_Received                            :=Img2Col_Unit.io.LayerEnd||LH_Gemm.io.LayerEnd


  val LayerEnd=Bool()
  Weight_Unit.io.Matrix_Row :=Img2Col_Instru.WeightMatrix_Row
  Weight_Unit.io.Matrix_Col :=Img2Col_Instru.OutFeature_Channel
  Weight_Unit.io.start      :=Delay(Fsm.nextState===TopCtrl_Enum.WEIGHT_CACHE,3)
  Weight_Unit.io.Raddr_Valid:=Img2Col_Unit.io.Raddr_Valid||LH_Gemm.io.bvalid
  Weight_Unit.io.LayerEnd   :=LayerEnd//(Control.LayerEnd)
  Fsm.WeightCached          :=(ConvQuant.io.QuantPara_Cached)
  Fsm.Compute_End           :=LayerEnd//(Control.LayerEnd)
  // val Weight_Tmp=UInt(64 bits)
  Weight_Unit.io.s_axis_s2mm_tdata <>InputSwitch.m(0).axis_mm2s_tdata//RegNext(InputSwitch.m(0).axis_mm2s_tdata)
  Weight_Unit.io.s_axis_s2mm_tkeep <>InputSwitch.m(0).axis_mm2s_tkeep
  Weight_Unit.io.s_axis_s2mm_tlast <>InputSwitch.m(0).axis_mm2s_tlast
  Weight_Unit.io.s_axis_s2mm_tready<>InputSwitch.m(0).axis_mm2s_tready
  Weight_Unit.io.s_axis_s2mm_tvalid<>InputSwitch.m(0).axis_mm2s_tvalid//RegNext(InputSwitch.m(0).axis_mm2s_tvalid)
  //当B矩阵缓存完后应该继续缓存量化参数
  when(Weight_Unit.io.s_axis_s2mm_tready){
    InputSwitch.m(0).axis_mm2s_tready:=Weight_Unit.io.s_axis_s2mm_tready
  }otherwise{
    InputSwitch.m(0).axis_mm2s_tready:=ConvQuant.io.sData.ready
  }
  ConvQuant.io.sData.payload<>InputSwitch.m(0).axis_mm2s_tdata
  ConvQuant.io.sData.valid<>InputSwitch.m(0).axis_mm2s_tvalid
  //==================================================================================
  Compute_Unit.io.start           :=Delay(Fsm.nextState===TopCtrl_Enum.WEIGHT_CACHE&&Control.Switch_Conv,3)
  // Compute_Unit.io.Matrix2Img      :=Control.Matrix2Img
  Compute_Unit.io.OutChannel      :=Img2Col_Instru.OutFeature_Channel.resized//这里的位宽可以小一点
  Compute_Unit.io.OutMatrix_Col   :=Img2Col_Instru.OutMatrix_Col
  Compute_Unit.io.OutMatrix_Row   :=Img2Col_Instru.OutMatrix_Row
  Compute_Unit.io.OutFeatureSize  :=Img2Col_Instru.OutFeature_Size
  Compute_Unit.io.signCount       :=Img2Col_Instru.WeightMatrix_Row-1
  when(Control.Switch_Conv){
    Compute_Unit.io.activate    :=Img2Col_Unit.io.mData.asSInt
  }otherwise{
    Compute_Unit.io.activate    :=LH_Gemm.io.mData.asSInt
  }
  
  Compute_Unit.io.weight      :=Weight_Unit.io.mData.asSInt
  for(i<-0 to 7){
    Compute_Unit.io.b_Valid(i):=Weight_Unit.io.MatrixCol_Switch(i downto i).asBool
  }
  when(Control.Switch_Conv){
    Compute_Unit.io.a_Valid:=Img2Col_Unit.io.mValid
  }otherwise{
    for(i<-0 to 7){
      Compute_Unit.io.a_Valid(i):=LH_Gemm.io.validOut(i)
    }
  }



  
  // OutputSwitch.s(1).axis_s2mm_tkeep.setAll 
  // OutputSwitch.s(0).axis_s2mm_tkeep.setAll    
  // OutputSwitch.s(1).axis_s2mm_tkeep.setAll    
  
  //Compute_Unit.io.mData.resized <>mData.payload
  // Compute_Unit.io.resultVaild<>mData.valid    
  // Compute_Unit.io.mLast         <>OutputSwitch.s(0).axis_s2mm_tlast
  // Compute_Unit.io.mData.ready   <>OutputSwitch.s(0).axis_s2mm_tready
  // Compute_Unit.io.mData.valid   <>OutputSwitch.s(0).axis_s2mm_tvalid
  //=====================================================================================
  Fsm.Matrix_Received:=LH_Gemm.io.LayerEnd
  Fsm.Switch_Conv:=Control.Switch_Conv

  LH_Gemm.io.start:=Weight_Unit.io.Weight_Cached
  LH_Gemm.io.sData.payload  <>InputSwitch.m(2).axis_mm2s_tdata
  LH_Gemm.io.sData.ready    <>InputSwitch.m(2).axis_mm2s_tready
  LH_Gemm.io.sData.valid    <>InputSwitch.m(2).axis_mm2s_tvalid
  LH_Gemm.io.WIDTH:=GemmInstru.WIDTH.resized
  LH_Gemm.io.HIGHT:=GemmInstru.HEIGHT.resized//
  LH_Gemm.io.WEIGHTCOL:=Img2Col_Instru.OutFeature_Channel.resized

  //=====================================================================================
    //开始连接量化模块
    //应该在外面再开一个数据接口用于输入量化参数
  // val ConvQuant=new ConvQuant
  // val s_axis_quant=new Bundle{//一个从接口，两个主接口
  //   val Data_Width=64
  //   val tdata=in UInt(Data_Width bits)
  //   val tkeep=in Bits(Data_Width/8 bits)
  //   val tlast=in Bool()
  //   val tready=out Bool()
  //   val tvalid=in Bool()
  // }
  // ConvQuant.io.sData.payload<>s_axis_quant.tdata
  // ConvQuant.io.sData.valid<>s_axis_quant.tvalid
  // ConvQuant.io.sData.ready<>s_axis_quant.tready
  ConvQuant.io.start:=Weight_Unit.io.Weight_Cached
  
  ConvQuant.io.dataIn:=Compute_Unit.io.mData
  // ConvQuant.io.dataOut<>mData.payload
  ConvQuant.io.LayerEnd:=LayerEnd//Control.LayerEnd
  ConvQuant.io.OutMatrix_Col:=Img2Col_Instru.OutFeature_Channel//输出矩阵的列数
  ConvQuant.io.zeroIn:=QuantInstru.zeroIn
  ConvQuant.io.SAOutput_Valid:=Compute_Unit.io.resultVaild(0)
  // mData.valid:=False

  DataOutput.io.sData:=ConvQuant.io.dataOut
  for(i<-0 to Config.SA_ROW-1){
    DataOutput.io.sValid(i):=Delay(Compute_Unit.io.resultVaild(i),10)
  }

  val m_axis_mm2s=new Bundle{//一个从接口，两个主接口
    val Data_Width=64
    val tdata=out UInt(Data_Width bits)
    val tkeep=out Bits(Data_Width/8 bits)
    val tlast=out Bool()
    val tready=in Bool()
    val tvalid=out Bool()
  }
  DataOutput.io.MatrixCol:=Img2Col_Instru.OutMatrix_Col
  DataOutput.io.MatrixRow:=Img2Col_Instru.OutMatrix_Row
  DataOutput.io.start    :=Control.start
  DataOutput.io.OutChannel:=Img2Col_Instru.OutFeature_Channel.resized
  DataOutput.io.OutFeatureSize:=Img2Col_Instru.OutFeature_Size
  DataOutput.io.SwitchConv:=Control.Switch_Conv
  m_axis_mm2s.tdata:=DataOutput.io.mData.payload
  m_axis_mm2s.tlast:=DataOutput.io.mLast
  m_axis_mm2s.tvalid:=DataOutput.io.mData.valid
  m_axis_mm2s.tkeep.setAll()
  DataOutput.io.mData.ready:=m_axis_mm2s.tready
  LayerEnd:=DataOutput.io.LayerEnd

}


object Top extends App { 
    val OnBoard=false
    var verilog_path="./verilog/Quant" 
    if(OnBoard){
        verilog_path="./OnBoard"
    }
    
    
    // printf("=================%d===============",log2Up(7))
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_Conv(8,8,20,PEConfig(4*4*32,20)))
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Img2ColStreamV2)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new WeightCache_Stream)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_2s(3,64))
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_1s(3,64))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Conv)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvQuant)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}