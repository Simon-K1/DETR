package top
import spinal.core._
import Systolic_Array.{Tile,WeightCache_Stream,PEConfig,Img2Col_Top}
import RegTable.RegTable
import utils.{TopConfig,WaCounter,WidthConvert}
import spinal.lib.StreamFifo
import utils.AxisDataConverter
import spinal.lib.Delay
import utils.Axis_Switch_1s
import utils.Axis_Switch_2s


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
        WidthConvert_Fifo(i).setDefinitionName("WidthConverter_Fifo")
        Converter(i).inStream<>WidthConvert_Fifo(i).io.pop
        Converter(i).outStream.ready:=True
        io.mData((i+1)*8-1 downto i*8):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
        io.mValid(i):=RegNext(Converter(i).outStream.valid)//这个valid信号给到脉动阵列
        //io.mData(i):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
    }
    
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




object Top extends App { 
    val OnBoard=false
    var verilog_path="./Simulation/SimSystolic/verilog" 
    if(OnBoard){
        verilog_path="./OnBoard"
    }
    
    
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Tile(8,8,20,PEConfig(4*4*32,20)))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Img2ColStreamV2)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new WeightCache_Stream)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_2s(3,64))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_1s(3,64))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}