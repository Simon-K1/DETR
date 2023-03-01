package top
import spinal.core._
import Systolic_Array.{Tile,DataGenerate_Top,Weight_Cache,PEConfig}

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

object Top extends App { 
    val verilog_path="./TopVerilog" 
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Tile(8,8,20,PEConfig(767,20)))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}