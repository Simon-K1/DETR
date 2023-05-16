package RegTable
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.bus.regif._
import spinal.lib.bus.regif.AccessType._
import scala.collection.script.Start
import utils.TopConfig
class RegTable extends Component{
	val Config=TopConfig()
	val regSData = slave(AxiLite4(log2Up(1 MiB), 32))//地址位宽-数据位宽
	AxiLite4SpecRenamer(regSData)
	val bus = BusInterface(regSData, sizeMap = SizeMapping(0x43C00000, 1 MiB))//创建一个总线接口,映射范围是0~1MiB
	//后面的内存映射也可以这样写：BusInterface(IO.regSData,(0x0000, 100 Byte)
	//这个BusInterface是一个object
	//这里的只读和只写对应的是master那边的只读和只写
    val LED_Reg  = bus.newReg(doc="PS Lights up Led ,test")
    val LD0123=LED_Reg.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput()
	val LD4567=LED_Reg.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput() 


	val Control_Reg=bus.newReg(doc="Img2Col_Start")
	val Start=Control_Reg.field(Bool(),WO,doc="Ps Start Img2Col_Start(only for test)").asOutput()
	val SwitchConv=Control_Reg.field(Bool(),WO,doc="1:Start Conv Compute\n").asOutput()
	val Matrix2Img=Control_Reg.field(Bool(),WO,doc="reshape Matrix into 3D Feature\n").asOutput()
	//val OutSwitch=Control_Reg.field(Bits(2 bits),WO,doc="ConvOutput Switch").asOutput()


	val Img2Col_Instru1	=bus.newReg(doc="[Kernel_Size,Stride]")
	val Stride			=Img2Col_Instru1.field(UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits),WO).asOutput()
	val Kernel_Size		=Img2Col_Instru1.field(UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits),WO).asOutput()

	val Img2Col_Instru2	=bus.newReg(doc="[InFeature_Size,Window_Size]")
	val Window_Size		=Img2Col_Instru2.field(UInt(16 bits),WO).asOutput()
	val InFeature_Size	=Img2Col_Instru2.field(UInt(16 bits),WO).asOutput()


	val Img2Col_Instru3 		=bus.newReg(doc="[OutFeature_Channel,InFeature_Channel]")
	val InFeature_Channel		=Img2Col_Instru3.field(UInt(16 bits),WO).asOutput()
	val OutFeature_Channel		=Img2Col_Instru3.field(UInt(16 bits),WO).asOutput()

	val Img2Col_Instru4 		=bus.newReg(doc="[Sliding_Size,OutFeature_Size]")
	val OutFeature_Size			=Img2Col_Instru4.field(UInt(16 bits),WO).asOutput()
	val Sliding_Size			=Img2Col_Instru4.field(UInt(16-3 bits),WO).asOutput()


	val Img2Col_Instru5 		=bus.newReg(doc="[InCol_Count_Times,OutCol_Count_Times]")
	val OutCol_Count_Times			=Img2Col_Instru5.field(UInt(16 bits),WO).asOutput()
	val InCol_Count_Times			=Img2Col_Instru5.field(UInt(16 bits),WO).asOutput()

	val Img2Col_Instru6 		=bus.newReg(doc="[OutFeature_Channel_Count_Times,OutRow_Count_Times]")
	val OutRow_Count_Times						=Img2Col_Instru6.field(UInt(16 bits),WO).asOutput()
	val OutFeature_Channel_Count_Times			=Img2Col_Instru6.field(UInt(16 bits),WO).asOutput()


	val Img2Col_Instru7			=bus.newReg(doc="[OutFeature_Channel_Count_Times,WeightMatrix_Row]")
	val WeightMatrix_Row		=Img2Col_Instru7.field(UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits),WO).asOutput()

	val Img2Col_Instru8			=bus.newReg(doc="[OutMatrix_Row,OutMatrix_Col]")
	val OutMatrix_Col			=Img2Col_Instru8.field(UInt(Config.MATRIXC_COL_WIDTH bits),WO).asOutput()
	val OutMatrix_Row			=Img2Col_Instru8.field(UInt(Config.MATRIXC_ROW_WIDTH bits),WO).asOutput()

	val Gemm_Instru				=bus.newReg(doc="Gemm Instru")
	val Gemm_Width				=Gemm_Instru.field(UInt(16 bits),WO).asOutput()
	val Gemm_Height				=Gemm_Instru.field(UInt(16 bits),WO).asOutput()


	val QuantReg1				=bus.newReg(doc="Quant Instru")
	val Quant_ZeroPoint			=QuantReg1.field(UInt(8 bits),WO).asOutput()//给到指令中的zeropoint

	bus.accept(HtmlGenerator("regif", "RegTable V1"))
}





object RegTable_Gen extends App { 
    val verilog_path="./testcode_gen/RegTable" //注意是高复位
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}