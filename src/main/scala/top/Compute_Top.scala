package top
import spinal.core._
import Systolic_Array.{Tile,WeightCache_Stream,PEConfig,Img2Col_Top,ConvOutput}
import RegTable.RegTable
import utils.{TopConfig,WaCounter,WidthConvert}
import spinal.lib.StreamFifo
import utils.AxisDataConverter
import spinal.lib.Delay
import utils.Axis_Switch_1s
import utils.Axis_Switch_2s
import spinal.lib.master


class Img2ColStreamV2 extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        
        val mData=out UInt(64 bits)//out UInt(64 bits)//Vec(UInt(8 bits),8)
        val mReady=in Bool()
        val mValid=out UInt(Config.SA_ROW bits)

        def DATA_IN_WIDTH=64
        val s_axis_s2mm_tdata=in UInt(DATA_IN_WIDTH bits)
        val s_axis_s2mm_tkeep=in Bits(DATA_IN_WIDTH/8 bits)
        val s_axis_s2mm_tlast=in Bool()
        val s_axis_s2mm_tready=out Bool()
        val s_axis_s2mm_tvalid=in Bool()

        // val m_tlast=out Bool()
        val start=in Bool()
        val Raddr_Valid=out Bool()
        val LayerEnd=out Bool()
        // val MatrixRow_Switch=out UInt(Config.SA_ROW bits)



        val Stride                          =in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size                     =in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size                     =in UInt(16 bits)
        val InFeature_Size                  =in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel               =in UInt(16 bits)//输入通道的信息已经包含在WindowSize中，可能以后用不到了
        val OutFeature_Channel              =in UInt(16 bits)
        val OutFeature_Size                 =in UInt(16 bits)//输出特征图的大小                                            
        val OutCol_Count_Times              =in UInt(16 bits)
        val InCol_Count_Times               =in UInt(16 bits)//这玩意又是啥？
        val OutRow_Count_Times              =in UInt(16 bits)
        val OutFeature_Channel_Count_Times  =in UInt(16 bits)
        val Sliding_Size                    =in UInt(16-3 bits)
    }
    noIoPrefix()
    val SubModule=new Img2Col_Top
    val WidthConvert_Fifo=new Array[StreamFifo[UInt]](8)
    val Converter=new Array[AxisDataConverter](8)
    
    // SubModule.io.mData<>io.mdata
    
    // io.Raddr_Valid:=RegNext(SubModule.io.Raddr_Valid)
    //分析：不想写了，自己看波形叭~，---->计算模块开发记录-2023/3/4:连连线
    val OutData_Switch=Reg(Bits(8 bits))init(1)
    val Switch_Reset=RegNext(SubModule.io.SA_Row_Cnt_Valid)
    when(Switch_Reset){
        OutData_Switch:=1
    }elsewhen(SubModule.io.mValid){
        OutData_Switch:=OutData_Switch.rotateLeft(1)//循环左移1位    
    }
    val TestValid_Signal=Vec(Bool(),8)//8个测试信号，以后要删除
    for (i<-0 to 7){
        
        WidthConvert_Fifo(i)=new StreamFifo(UInt(64 bits),16)
        Converter(i)=new AxisDataConverter(64,8)
        WidthConvert_Fifo(i).io.push.payload:=SubModule.io.mData
        WidthConvert_Fifo(i).io.push.valid:=(OutData_Switch(i downto i).asBool)&&SubModule.io.mValid
        WidthConvert_Fifo(i).setDefinitionName("Img2Col_WidthConverter_Fifo")
        Converter(i).inStream<>WidthConvert_Fifo(i).io.pop
        Converter(i).outStream.ready:=True
        io.mData((i+1)*8-1 downto i*8):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
        io.mValid(i):=RegNext(Converter(i).outStream.valid)//这个valid信号给到脉动阵列
        //io.mData(i):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
    }
    //存在一个问题：如果现在只激活了脉动阵列的1~6行，那么还剩两行没有激活
    //在进入第二轮计算时，也就是处理输出图片的第二行，一开始1~6行的fifo中还有保留有数据没有出去，但是7~8行的fifo没有数据，这时就会出现7~8行提前计算，这样7~8行的激活就没有和权重对齐，
    //导致7~8行提前输出并且结果还不对，，，，
    //，，，，，很难改，
    
    io.Raddr_Valid:=Converter(0).outStream.valid
    // val WeightCached_Flag=Bool
    SubModule.io.sData.payload<>io.s_axis_s2mm_tdata
    SubModule.io.sData.valid<>io.s_axis_s2mm_tvalid
    SubModule.io.sData.ready<>io.s_axis_s2mm_tready
    SubModule.io.start:=io.start



    SubModule.io.Stride                         <>io.Stride                         
    SubModule.io.Kernel_Size                    <>io.Kernel_Size                    
    SubModule.io.Window_Size                    <>io.Window_Size                    
    SubModule.io.InFeature_Size                 <>io.InFeature_Size                 
    SubModule.io.InFeature_Channel              <>io.InFeature_Channel              
    SubModule.io.OutFeature_Channel             <>io.OutFeature_Channel             
    SubModule.io.OutFeature_Size                <>io.OutFeature_Size                
    SubModule.io.OutCol_Count_Times             <>io.OutCol_Count_Times             
    SubModule.io.InCol_Count_Times              <>io.InCol_Count_Times              
    SubModule.io.OutRow_Count_Times             <>io.OutRow_Count_Times             
    SubModule.io.OutFeature_Channel_Count_Times <>io.OutFeature_Channel_Count_Times 
    SubModule.io.Sliding_Size                   <>io.Sliding_Size                   
    SubModule.io.Fifo_Clear                     <>(!WidthConvert_Fifo(0).io.pop.valid)

    SubModule.io.mReady                         :=WidthConvert_Fifo(0).io.push.ready
    io.LayerEnd:=Delay(SubModule.io.LayerEnd,3)
//调试信号================================================================================================
    // //val Out_Data_Counter=WaCounter(io.mReady&&io.mValid,32,U"32'hffffffff")       
    // val In_Data_Counter=WaCounter(io.s_axis_s2mm_tvalid&&io.s_axis_s2mm_tready,32,U"32'hffffffff")   
    // when(io.start){
    //     //Out_Data_Counter.clear
    //     In_Data_Counter.clear
    // }
}
class SA_Conv(Tile_Size: Int, dataWidthIn: Int, dataWidthOut: Int,peConfig:PEConfig) extends  Component{
  val Config=new TopConfig
  val io = new Bundle {
    val activate = in SInt (Tile_Size * dataWidthIn bits)
    val a_Valid = in Bits(Tile_Size bits)
    val weight = in SInt (Tile_Size * dataWidthIn bits)
    val b_Valid = in Bits(Tile_Size bits)

   
    val signCount = in UInt (16 bits) //卷积核16*16  signCoun就是t256
    // val resultVaild = out Vec(Bool,Tile_Size)
    val In_Channel=in UInt(Config.DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH bits)
    val Matrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)
    val Matrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)
    val start=in Bool()
    val LayerEnd=out Bool()
    val mData=master Stream(UInt(64 bits))

    val mLast=out Bool()
  }
  noIoPrefix()
  val Tile=new Tile(Tile_Size,dataWidthIn,dataWidthOut,peConfig)
//   Tile.setDefinitionName("SA_Conv_Tile")
  val Tile_Output=new ConvOutput
//   Tile_Output.setDefinitionName("SA_Conv_ConvOutput")
  io.activate    <>Tile.io.activate
  // io.a_Valid     <>Tile.io.a_Valid 
  io.weight      <>Tile.io.weight 
  // io.b_Valid     <>Tile.io.b_Valid 
  io.signCount   <>Tile.io.signCount
  for(i<-0 to 7){
    Tile.io.a_Valid(i):=io.a_Valid(i downto i).asBool
    Tile.io.b_Valid(i):=io.b_Valid(i downto i).asBool
  }

  io.In_Channel <>Tile_Output.io.In_Channel
  io.Matrix_Col <>Tile_Output.io.Matrix_Col
  io.Matrix_Row <>Tile_Output.io.Matrix_Row 
  io.start      <>Tile_Output.io.start

  for(i<-0 to Tile_Size-1){
    Tile.io.PE_OUT(i)(7 downto 0).asUInt<>Tile_Output.io.sData((i+1)*8-1 downto i*8)//还没量化，所以只能截取低8位
  }
  Tile.io.resultVaild(0)<>Tile_Output.io.sValid
  io.LayerEnd:=Tile_Output.io.LayerEnd
  io.mData<>Tile_Output.io.mData
  io.mLast:=Tile_Output.io.mLast
}


object TopCtrl_Enum extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, WEIGHT_CACHE,RECEIVE_PICTURE,WAIT_COMPUTE_END= newElement
    //WEIGHT_CACHE:缓存权重
    //RECEIVE_PICTURE:接收图片数据
    //WAITEND:等待计算结束

}
case class TopCtrl_Fsm(start:Bool)extends Area{
    val currentState = Reg(TopCtrl_Enum()) init TopCtrl_Enum.IDLE
    val nextState = TopCtrl_Enum()
    currentState := nextState

    val Inited=Bool()
    val WeightCached=Bool()
    val Picture_Received=Bool()
    val Compute_End=Bool()
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
        when(WeightCached){
          nextState:=TopCtrl_Enum.RECEIVE_PICTURE
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

      is(TopCtrl_Enum.WAIT_COMPUTE_END){
        when(Compute_End){
          nextState:=TopCtrl_Enum.IDLE
        }otherwise{
          nextState:=TopCtrl_Enum.WAIT_COMPUTE_END
        }
      }
    }
}

class Conv extends Component{
  val Config=TopConfig()
  val Control=new Bundle{
    val start=in Bool()
    //val Inswitch=in UInt(2 bits)
    val OutSwitch=in UInt(2 bits)
  }
  val s_axis_s2mm=new Bundle{//一个从接口，两个主接口
    val Data_Width=64
    val tdata=in UInt(Data_Width bits)
    val tkeep=in Bits(Data_Width/8 bits)
    val tlast=in Bool()
    val tready=out Bool()
    val tvalid=in Bool()
  }
  val m_axis_mm2s=new Bundle{//一个从接口，两个主接口
    val Data_Width=64
    val tdata=out UInt(Data_Width bits)
    val tkeep=out Bits(Data_Width/8 bits)
    val tlast=out Bool()
    val tready=in Bool()
    val tvalid=out Bool()
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

    val OutMatrix_Col                   =in UInt(Config.MATRIXC_COL_WIDTH bits)
    val OutMatrix_Row                   =in UInt(Config.MATRIXC_ROW_WIDTH bits)
  }
  val Fsm=TopCtrl_Fsm(Control.start)
  val InitCnt=WaCounter(Fsm.currentState===TopCtrl_Enum.INIT,3,5)
  Fsm.Inited:=InitCnt.valid

  val InputSwitch=new Axis_Switch_1s(2,64)//1个从接口，一个给img2col，一个给weight
  InputSwitch.setDefinitionName("Conv_DataIn_Switch")
  val OutputSwitch=new Axis_Switch_2s(1,64)//2个从接口
  OutputSwitch.setDefinitionName("COnv_DataOut_Switch")

  InputSwitch.s0_axis_s2mm<>s_axis_s2mm
  OutputSwitch.m0_axis_mm2s<>m_axis_mm2s
  when(Fsm.currentState===TopCtrl_Enum.WEIGHT_CACHE){
    InputSwitch.io.Switch:=1
  }otherwise{
    InputSwitch.io.Switch:=0
  }
  //InputSwitch.io.Switch:=Control.Inswitch
  OutputSwitch.io.Switch:=Control.OutSwitch
  //整合img2col，脉动阵列以及数据输出
  val Compute_Unit=new SA_Conv(8,8,20,PEConfig(4*4*32,20))//计算单元
  val Weight_Unit=new WeightCache_Stream//权重缓存单元
  val Img2Col_Unit=new Img2ColStreamV2//img2col数据排列单元
  

  Img2Col_Unit.io.s_axis_s2mm_tdata <>InputSwitch.m(0).axis_mm2s_tdata
  Img2Col_Unit.io.s_axis_s2mm_tkeep <>InputSwitch.m(0).axis_mm2s_tkeep
  Img2Col_Unit.io.s_axis_s2mm_tlast <>InputSwitch.m(0).axis_mm2s_tlast
  Img2Col_Unit.io.s_axis_s2mm_tready<>InputSwitch.m(0).axis_mm2s_tready
  Img2Col_Unit.io.s_axis_s2mm_tvalid<>InputSwitch.m(0).axis_mm2s_tvalid

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
 
  Img2Col_Unit.io.start                           :=Delay(Weight_Unit.io.Weight_Cached,3)//权重缓存完了才启动img2col以及卷积计算
  Fsm.Picture_Received                            :=Img2Col_Unit.io.LayerEnd



  Weight_Unit.io.Matrix_Row :=Img2Col_Instru.WeightMatrix_Row
  Weight_Unit.io.Matrix_Col :=Img2Col_Instru.OutFeature_Channel
  Weight_Unit.io.start      :=Delay(Fsm.nextState===TopCtrl_Enum.WEIGHT_CACHE,3)
  Weight_Unit.io.Raddr_Valid:=Img2Col_Unit.io.Raddr_Valid
  Weight_Unit.io.LayerEnd   :=Compute_Unit.io.LayerEnd
  Fsm.WeightCached          :=Weight_Unit.io.Weight_Cached
  Fsm.Compute_End           :=Compute_Unit.io.LayerEnd
  Weight_Unit.io.s_axis_s2mm_tdata <>InputSwitch.m(1).axis_mm2s_tdata
  Weight_Unit.io.s_axis_s2mm_tkeep <>InputSwitch.m(1).axis_mm2s_tkeep
  Weight_Unit.io.s_axis_s2mm_tlast <>InputSwitch.m(1).axis_mm2s_tlast
  Weight_Unit.io.s_axis_s2mm_tready<>InputSwitch.m(1).axis_mm2s_tready
  Weight_Unit.io.s_axis_s2mm_tvalid<>InputSwitch.m(1).axis_mm2s_tvalid


  //==================================================================================
  Compute_Unit.io.start       :=Delay(Fsm.nextState===TopCtrl_Enum.WEIGHT_CACHE,3)

  Compute_Unit.io.In_Channel  :=Img2Col_Instru.OutFeature_Channel.resized//这里的位宽可以小一点
  Compute_Unit.io.Matrix_Col  :=Img2Col_Instru.OutMatrix_Col
  Compute_Unit.io.Matrix_Row  :=Img2Col_Instru.OutMatrix_Row
  Compute_Unit.io.signCount   :=Img2Col_Instru.WeightMatrix_Row-1

  Compute_Unit.io.activate    :=Img2Col_Unit.io.mData.asSInt
  Compute_Unit.io.weight      :=Weight_Unit.io.mData.asSInt
  for(i<-0 to 7){
    Compute_Unit.io.a_Valid(i):=Img2Col_Unit.io.mValid(i downto i).asBool
    Compute_Unit.io.b_Valid(i):=Weight_Unit.io.MatrixCol_Switch(i downto i).asBool
  }
  


  
  // OutputSwitch.s(1).axis_s2mm_tkeep.setAll 
  OutputSwitch.s(0).axis_s2mm_tkeep.setAll    
  Compute_Unit.io.mData.payload <>OutputSwitch.s(0).axis_s2mm_tdata        
  Compute_Unit.io.mLast         <>OutputSwitch.s(0).axis_s2mm_tlast
  Compute_Unit.io.mData.ready   <>OutputSwitch.s(0).axis_s2mm_tready
  Compute_Unit.io.mData.valid   <>OutputSwitch.s(0).axis_s2mm_tvalid

}


object Top extends App { 
    val OnBoard=true
    var verilog_path="./Simulation/SimSystolic/verilog" 
    if(OnBoard){
        verilog_path="./OnBoard"
    }
    
    
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_Conv(8,8,20,PEConfig(4*4*32,20)))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Img2ColStreamV2)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new WeightCache_Stream)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_2s(3,64))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_1s(3,64))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Conv)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}