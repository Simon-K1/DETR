package top
import spinal.core._
import Systolic_Array.{Tile,DataGenerate_Top,Weight_Cache,PEConfig,Img2Col_Top}
import utils.{TopConfig,WaCounter,WidthConvert}
import spinal.lib.StreamFifo
import utils.AxisDataConverter


class Img2ColStreamV2 extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        
        val mdata=out Vec(UInt(8 bits),8)
        val mReady=in Bool()
        val mvalid=out Bool()

        def DATA_OUT_WIDTH=64
        val s_axis_s2mm_tdata=in UInt(DATA_OUT_WIDTH bits)
        val s_axis_s2mm_tkeep=in Bits(DATA_OUT_WIDTH/8 bits)
        val s_axis_s2mm_tlast=in Bool()
        val s_axis_s2mm_tready=out Bool()
        val s_axis_s2mm_tvalid=in Bool()

        // val m_tlast=out Bool()
        val start=in Bool()
        val Raddr_Valid=out Bool()
    }
    noIoPrefix()
    val SubModule=new Img2Col_Top
    val WidthConvert_Fifo=new Array[StreamFifo[UInt]](8)
    val Converter=new Array[AxisDataConverter](8)
    
    // SubModule.io.mData<>io.mdata
    
    // io.Raddr_Valid:=RegNext(SubModule.io.Raddr_Valid)
    //分析：不想写了，自己看波形叭~，---->计算模块开发记录-2023/3/4:连连线
    val OutData_Switch=Reg(Bits(8 bits))init(1)
    when(SubModule.io.mValid){
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
        io.mdata(i):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
    }
    io.mvalid:=Converter(0).outStream.valid
    io.Raddr_Valid:=Converter(0).outStream.valid
    // val WeightCached_Flag=Bool
    SubModule.io.sData.payload<>io.s_axis_s2mm_tdata
    SubModule.io.sData.valid<>io.s_axis_s2mm_tvalid
    SubModule.io.sData.ready<>io.s_axis_s2mm_tready
    SubModule.io.start:=io.start



    SubModule.io.Stride                         :=2
    SubModule.io.Kernel_Size                    :=4
    SubModule.io.Window_Size                    :=16
    SubModule.io.InFeature_Size                 :=226
    SubModule.io.InFeature_Channel              :=32
    SubModule.io.OutFeature_Channel             :=32
    SubModule.io.OutFeature_Size                :=112
    SubModule.io.OutCol_Count_Times             :=14
    SubModule.io.InCol_Count_Times              :=904
    SubModule.io.OutRow_Count_Times             :=112
    SubModule.io.OutFeature_Channel_Count_Times :=4
    SubModule.io.Sliding_Size                   :=8


    SubModule.io.mReady                         :=WidthConvert_Fifo(0).io.push.ready

//调试信号================================================================================================
    val Out_Data_Counter=WaCounter(io.mReady&&io.mvalid,32,U"32'hffffffff")       
    val In_Data_Counter=WaCounter(io.s_axis_s2mm_tvalid&&io.s_axis_s2mm_tready,32,U"32'hffffffff")   
    when(io.start){
        Out_Data_Counter.clear
        In_Data_Counter.clear
    }

}





object Top extends App { 
    val verilog_path="./Simulation/SimSystolic" 
    
    // printf("=================%d===============",log2Up(7))
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Tile(8,8,20,PEConfig(767,20)))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Img2ColStreamV2)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}