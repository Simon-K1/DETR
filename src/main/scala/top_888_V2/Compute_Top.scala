package top.topV5
import spinal.core._
import Systolic_Array.{Tile,PEConfig,Img2Col_Top}
import Systolic_Array.ConvArrangeV2
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
import Systolic_Array.ConvArrangeV3



class Img2ColStreamV2 extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        
        val mData=out UInt(64 bits)//out UInt(64 bits)//Vec(UInt(8 bits),8)
        // val mReady=in Bool()
        val mValid=out Bits(Config.SA_ROW bits)

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
class SA_Core(Tile_Size: Int, dataWidthIn: Int, dataWidthOut: Int,peConfig:PEConfig) extends  Component{
    //改个名字：叫阵列核心
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
  io.activate    <>Tile.io.activate
  io.weight      <>Tile.io.weight 
  io.signCount   <>Tile.io.signCount
  for(i<-0 to 7){
    Tile.io.a_Valid(i):=io.a_Valid(i downto i).asBool
    Tile.io.b_Valid(i):=io.b_Valid(i downto i).asBool
  }


  io.mData<>Tile.io.PE_OUT
  Tile.io.resultVaild<>io.resultVaild//TODO，优化这里的valid信号数量

}


// class SA_3D extends Component{
//     //重新构建三维脉动阵列（只构建脉动阵列）


// }

object Top extends App { 
    val OnBoard=true
    var verilog_path="./Simulation/Quant" 
    if(OnBoard){
        verilog_path="./OnBoard"
    }
    
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_Core(8,8,32,PEConfig(4*4*32,32)))//计算单元)
}