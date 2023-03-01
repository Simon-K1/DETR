package top
import spinal.core._
import Systolic_Array.{Tile,DataGenerate_Top,Weight_Cache,PEConfig,Img2Col_Top}
import utils.{TopConfig,WaCounter}

// class Compute_Top extends Component{
//     val io=new Bundle{
//         def DATA_IN_WIDTH=64
//         val m_axis_mm2s_tdata=out UInt(DATA_IN_WIDTH bits)
//         val m_axis_mm2s_tkeep=out Bits(DATA_IN_WIDTH/8 bits)
//         val m_axis_mm2s_tlast=out Bool()
//         val m_axis_mm2s_tready=in Bool()
//         val m_axis_mm2s_tvalid=out Bool()

//         def DATA_OUT_WIDTH=64
//         val s_axis_s2mm_tdata=in UInt(DATA_OUT_WIDTH bits)
//         val s_axis_s2mm_tkeep=in Bits(DATA_OUT_WIDTH/8 bits)
//         val s_axis_s2mm_tlast=in Bool()
//         val s_axis_s2mm_tready=out Bool()
//         val s_axis_s2mm_tvalid=in Bool()

//         // val m_tlast=out Bool()
//         val start=in Bool()
//     }

//     val SA=new Tile(8,8,20,PEConfig(767,20))
//     val Img2Col=new DataGenerate_Top
//     val WeightCache=new Weight_Cache
// }
class Img2ColModule extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        def DATA_IN_WIDTH=64
        val mdata=out UInt(DATA_IN_WIDTH bits)
        val mready=in Bool()
        val mvalid=out Bool()

        def DATA_OUT_WIDTH=64
        val s_axis_s2mm_tdata=in UInt(DATA_OUT_WIDTH bits)
        val s_axis_s2mm_tkeep=in Bits(DATA_OUT_WIDTH/8 bits)
        val s_axis_s2mm_tlast=in Bool()
        val s_axis_s2mm_tready=out Bool()
        val s_axis_s2mm_tvalid=in Bool()

        // val m_tlast=out Bool()
        val start=in Bool()
    }
    noIoPrefix()
    val SubModule=new Img2Col_Top
    SubModule.io.mData<>io.mdata
    SubModule.io.mValid<>io.mvalid
    
    
    

    SubModule.io.sData.payload<>io.s_axis_s2mm_tdata
    SubModule.io.sData.valid<>io.s_axis_s2mm_tvalid
    SubModule.io.sData.ready<>io.s_axis_s2mm_tready
    SubModule.io.start<>io.start

    val Stride=16
    val Kernel_Size=16
    val InFeature_Size=224//图片大小为224*224

    SubModule.io.Stride                          :=Stride                       
    SubModule.io.Kernel_Size                     :=Kernel_Size       
    SubModule.io.Window_Size                     :=16       
    SubModule.io.InFeature_Size                  :=224          
    SubModule.io.InFeature_Channel               :=3               
    SubModule.io.OutFeature_Channel              :=768               
    SubModule.io.OutFeature_Channel_Count_Times  :=96                           
    SubModule.io.OutFeature_Size                 :=14           
    SubModule.io.OutCol_Count_Times              :=2               
    SubModule.io.OutRow_Count_Times              :=14               
    SubModule.io.InCol_Count_Times               :=224               
    // SubModule.io.Test_Signal                     :=       
    // SubModule.io.Test_Generate_Period            :=14
//调试信号================================================================================================
    val Out_Data_Counter=WaCounter(io.mready&&io.mvalid,32,U"32'hffffffff")       
    val In_Data_Counter=WaCounter(io.s_axis_s2mm_tvalid&&io.s_axis_s2mm_tready,32,U"32'hffffffff")   
    when(io.start){
        Out_Data_Counter.clear
        In_Data_Counter.clear
    }
//调试信号end==============================================================================================
            
}

object Top extends App { 
    val verilog_path="./TopVerilog" 
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Tile(8,8,20,PEConfig(767,20)))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}