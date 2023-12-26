package Systolic_Array.SystolicArray3D

//加速器 Top模块

import spinal.core._

import RegTable.RegTable
import spinal.lib.bus.amba4.axilite._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.slave
import xip.xil_ila
import utils.TopConfig
import utils.Tcl_Config

class Accelerator_Top extends Component{//此版本已失效（此版本用的是一个大状态机做全局控制，现在已经不那样用了）
  val Config=TopConfig()
  val regSData = slave(AxiLite4(log2Up(1 MiB), 32))//地址位宽-数据位宽
  AxiLite4SpecRenamer(regSData)
  val Regs=new RegTable
  val core=new SA3D_Top(1,8,64,32)
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

//   core.GemmInstru.HEIGHT                              :=Regs.Gemm_Height
//   core.GemmInstru.WIDTH                               :=Regs.Gemm_Width

    core.QuantInstru.zeroIn                             :=Regs.Quant_ZeroPoint


  }



class Accelerator_TopV2(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int,val MODULE_NUM:Int=5,WW_Detpth:Int=1024) extends Component{
  //WW_Detpth 代表的是权重缓存模块Weight cache 的write depth 
  val Config=TopConfig()
  val regSData = slave(AxiLite4(log2Up(1 MiB), 32))//地址位宽-数据位宽
  AxiLite4SpecRenamer(regSData)
  val Regs=new RegTable
  val core=new SA_3D_SwitchVersion(SLICE,HEIGHT,WIDTH,ACCU_WITDH,MODULE_NUM,WW_Detpth)//(1,8,64,32,4)//采用上位机手动switch的方法
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
    val Dma_TX_Int         =in Bool()//DMA发送中断，也就是DMA那边数据已经发送完成了
    Regs.regSData<>regSData
    core.s_axis_s2mm<>s_axis_s2mm
    core.m_axis_mm2s<>m_axis_mm2s

    core.Control.start                                  :=Regs.Start
    core.Control.Dma_TX_Int                             :=Dma_TX_Int
    core.Control.Switch                                 :=Regs.SwitchCtrl
    core.Control.QuantSwitch                            :=Regs.QuantSwitch(1 downto 0)
    core.Control.OutputSwitch                           :=Regs.OutSwitchCtrl(1 downto 0)
    //   core.Control.Switch_Conv                            :=Regs.SwitchConv
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
    core.Gemm_Instru.Gemm_Height                        :=Regs.Gemm_Height
    core.Gemm_Instru.Gemm_Width                         :=Regs.Gemm_Width
//   core.GemmInstru.HEIGHT                              :=Regs.Gemm_Height
//   core.GemmInstru.WIDTH                               :=Regs.Gemm_Width
    core.QuantInstru.zeroIn                             :=Regs.Quant_ZeroPoint

    core.setDefinitionName("SA3D_Top")

  if(Config.ila){
    val Debug_Signals=Array[Bits](
      core.Control.start.asBits,
      core.Control.Dma_TX_Int.asBits,
      core.Control.Switch.asBits,
      core.Control.QuantSwitch.asBits,
      core.Control.OutputSwitch.asBits,
      core.Img2Col_Instru.Stride.asBits,                        
      core.Img2Col_Instru.Kernel_Size.asBits,                   
      core.Img2Col_Instru.Window_Size.asBits,                   
      core.Img2Col_Instru.InFeature_Size.asBits,                
      core.Img2Col_Instru.InFeature_Channel.asBits,             
      core.Img2Col_Instru.OutFeature_Channel.asBits,            
      core.Img2Col_Instru.OutFeature_Size.asBits,               
      core.Img2Col_Instru.Sliding_Size.asBits,                  
      core.Img2Col_Instru.OutCol_Count_Times.asBits,            
      core.Img2Col_Instru.InCol_Count_Times.asBits,             
      core.Img2Col_Instru.OutRow_Count_Times.asBits,            
      core.Img2Col_Instru.OutFeature_Channel_Count_Times.asBits,
          
      core.Img2Col_Instru.WeightMatrix_Row.asBits,              
      core.Img2Col_Instru.OutMatrix_Col.asBits,                 
      core.Img2Col_Instru.OutMatrix_Row.asBits,
      core.QuantInstru.zeroIn.asBits       

             
  )
    val ila=new xil_ila(Debug_Signals,true,"ila_Accelerator_Top")
    for(i<-0 to Debug_Signals.length-1){
        ila.probe(i):=Debug_Signals(i)
    }
  }
  }


object Top extends App { //
    val OnBoard=true
    var verilog_path="./verilog/SA_3D" 
    if(OnBoard){
        verilog_path="./OnBoard"
    }
    
    
  def GenerateTop(Slice:Int,Height:Int,Width:Int,Accu_Width:Int,Nums:Int,WW_Depth:Int):Unit={
    verilog_path="./OnBoard/"+Slice.toString+"_"+Height.toString+"_"+Width.toString+"_"+Accu_Width.toString+"_"+Nums.toString+"_"+WW_Depth.toString
    Tcl_Config.Tcl_File_Path=verilog_path
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Accelerator_TopV2(Slice,Height,Width,Accu_Width,Nums,WW_Depth))
  }
  GenerateTop(1,8,8,32,5,24576)
  GenerateTop(2,8,8,32,5,12288)  
  GenerateTop(3,8,8,32,5,8192)  
  GenerateTop(3,8,64,32,5,1024)  
  GenerateTop(4,8,32,32,5,1536)  
  GenerateTop(4,8,64,32,5,768)  
    
    
    
}