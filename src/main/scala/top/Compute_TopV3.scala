package top.topV3
import spinal.core._

import RegTable.RegTable
import spinal.lib.bus.amba4.axilite._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.slave
import top.topV2.Conv

class ConvTop extends Component{
  val regSData = slave(AxiLite4(log2Up(1 MiB), 32))//地址位宽-数据位宽
  AxiLite4SpecRenamer(regSData)
  val Regs=new RegTable
  val core=new Conv
  val s_axis_s2mm=new Bundle{
    val Data_Width=64
    val tdata=in UInt(Data_Width bits)
    val tkeep=in Bits(Data_Width/8 bits)
    val tlast=in Bool()
    val tready=out Bool()
    val tvalid=in Bool()
  }
  val m_axis_mm2s=new Bundle{
    val Data_Width=64
    val tdata=out UInt(Data_Width bits)
    val tkeep=out Bits(Data_Width/8 bits)
    val tlast=out Bool()
    val tready=in Bool()
    val tvalid=out Bool()
  }
  Regs.regSData<>regSData
  core.s_axis_s2mm<>s_axis_s2mm
  core.m_axis_mm2s<>m_axis_mm2s

  core.Control.start                                  :=Regs.Start
  core.Control.Switch_Conv                            :=Regs.SwitchConv
  // core.Control
    
  core.Img2Col_Instru.Stride                          :=Regs.Stride.resized                        
  core.Img2Col_Instru.Kernel_Size                     :=Regs.Kernel_Size.resized                   
  core.Img2Col_Instru.Window_Size                     :=Regs.Window_Size.resized                   
  core.Img2Col_Instru.InFeature_Size                  :=Regs.InFeature_Size.resized                
  core.Img2Col_Instru.InFeature_Channel               :=Regs.InFeature_Channel.resized             
  core.Img2Col_Instru.OutFeature_Channel              :=Regs.OutFeature_Channel.resized //输出图片通道也可以是权重矩阵的列数           
  core.Img2Col_Instru.OutFeature_Size                 :=Regs.OutFeature_Size.resized               
  core.Img2Col_Instru.Sliding_Size                    :=Regs.Sliding_Size.resized                  
  core.Img2Col_Instru.OutCol_Count_Times              :=Regs.OutCol_Count_Times.resized            
  core.Img2Col_Instru.InCol_Count_Times               :=Regs.InCol_Count_Times.resized             
  core.Img2Col_Instru.OutRow_Count_Times              :=Regs.OutRow_Count_Times.resized            
  core.Img2Col_Instru.OutFeature_Channel_Count_Times  :=Regs.OutFeature_Channel_Count_Times.resized
    

  core.Img2Col_Instru.WeightMatrix_Row                :=Regs.WeightMatrix_Row

  core.Img2Col_Instru.OutMatrix_Col                   :=Regs.OutMatrix_Col
  core.Img2Col_Instru.OutMatrix_Row                   :=Regs.OutMatrix_Row//输出矩阵的行数

  core.GemmInstru.HEIGHT                              :=Regs.Gemm_Height
  core.GemmInstru.WIDTH                               :=Regs.Gemm_Width
  }






object Top extends App { 
    val OnBoard=true
    var verilog_path="./Simulation/Quant" 
    if(OnBoard){
        verilog_path="./OnBoard"
    }
    
  
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ConvTop)
    
}