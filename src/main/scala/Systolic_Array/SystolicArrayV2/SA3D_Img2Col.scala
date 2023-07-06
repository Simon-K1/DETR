package Systolic_Array.SystolicArrayV2
//将img2col模块和SA 3D 模块组合起来
import spinal.core._
import spinal.lib.slave
import utils._
import Systolic_Array.Img2ColStreamV2
class SA32_Img2Col(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int) extends Component{
    val Config=TopConfig()
    val io=new Bundle{

        def DATA_IN_WIDTH=64
        val s_axis_s2mm_tdata   =in UInt(DATA_IN_WIDTH bits)
        val s_axis_s2mm_tkeep   =in Bits(DATA_IN_WIDTH/8 bits)
        val s_axis_s2mm_tlast   =in Bool()
        val s_axis_s2mm_tready  =out Bool()
        val s_axis_s2mm_tvalid  =in Bool()


        val start               =in Bool()
        val Raddr_Valid         =out Bool()
        val LayerEnd            =out Bool()




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

        val signCount                       =in UInt(16 bits)
    }
    noIoPrefix()
    val SubModule_Img2Col   =new Img2ColStreamV2
    val SubModule_SA_3D     =new SA_3D(SLICE,HEIGHT,WIDTH,ACCU_WITDH)//8*8*8的脉动阵列

    for(i<-0 to HEIGHT-1){
        SubModule_SA_3D.SA_Inputs(i).signCount :=io.signCount
        for(j<-0 to SLICE-1){
            SubModule_SA_3D.SA_Inputs(i).MatrixA(j):=SubModule_Img2Col.io.mData((i+1)*8-1 downto i*8).asSInt//SLICE轴的每一行的输入一样
            SubModule_SA_3D.SA_Inputs(i).A_Valid(j):=SubModule_Img2Col.io.mValid(i)
            
            SubModule_SA_3D.SA_Inputs(i).MatrixB(j):=0
            SubModule_SA_3D.SA_Inputs(i).B_Valid(j):=False
        }
    }


    SubModule_Img2Col.io.s_axis_s2mm_tdata   <>io.s_axis_s2mm_tdata 
    SubModule_Img2Col.io.s_axis_s2mm_tkeep   <>io.s_axis_s2mm_tkeep 
    SubModule_Img2Col.io.s_axis_s2mm_tlast   <>io.s_axis_s2mm_tlast 
    SubModule_Img2Col.io.s_axis_s2mm_tready  <>io.s_axis_s2mm_tready
    SubModule_Img2Col.io.s_axis_s2mm_tvalid  <>io.s_axis_s2mm_tvalid

    SubModule_Img2Col.io.Stride                        <>io.Stride                        
    SubModule_Img2Col.io.Kernel_Size                   <>io.Kernel_Size                   
    SubModule_Img2Col.io.Window_Size                   <>io.Window_Size                   
    SubModule_Img2Col.io.InFeature_Size                <>io.InFeature_Size                
    SubModule_Img2Col.io.InFeature_Channel             <>io.InFeature_Channel             
    SubModule_Img2Col.io.OutFeature_Channel            <>io.OutFeature_Channel            
    SubModule_Img2Col.io.OutFeature_Size               <>io.OutFeature_Size               
    SubModule_Img2Col.io.OutCol_Count_Times            <>io.OutCol_Count_Times            
    SubModule_Img2Col.io.InCol_Count_Times             <>io.InCol_Count_Times             
    SubModule_Img2Col.io.OutRow_Count_Times            <>io.OutRow_Count_Times            
    SubModule_Img2Col.io.OutFeature_Channel_Count_Times<>io.OutFeature_Channel_Count_Times
    SubModule_Img2Col.io.Sliding_Size                  <>io.Sliding_Size     
    SubModule_Img2Col.io.start                         <>io.start      
    SubModule_Img2Col.io.Raddr_Valid                   <>io.Raddr_Valid
    SubModule_Img2Col.io.LayerEnd                      <>io.LayerEnd         
}

object SA3D_Img2Col_Generate extends App { 
    val verilog_path="./Simulation/SA_3D/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA32_Img2Col(8,8,8,32))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}