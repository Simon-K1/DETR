package RegTable
import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axilite._
import spinal.lib.bus.misc.SizeMapping
import spinal.lib.bus.regif._
import spinal.lib.bus.regif.AccessType._
import scala.collection.script.Start
class RegTable extends Component{

	val regSData = slave(AxiLite4(log2Up(1 MiB), 32))//地址位宽-数据位宽
	AxiLite4SpecRenamer(regSData)
	val bus = BusInterface(regSData, sizeMap = SizeMapping(0x43C00000, 1 MiB))//创建一个总线接口,映射范围是0~1MiB
	//后面的内存映射也可以这样写：BusInterface(IO.regSData,(0x0000, 100 Byte)
	//这个BusInterface是一个object
	//这里的只读和只写对应的是master那边的只读和只写
    val LED_Reg  = bus.newReg(doc="PS Lights up Led ,test")
    val LD0123=LED_Reg.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput()
	val LD4567=LED_Reg.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput() 


	val LayerNorm_Reg=bus.newReg(doc="LayerNorm")
	val LayerNorm_Start=LayerNorm_Reg.field(Bits(1 bits),WO,doc="Ps Start LayerNorm(only for test)")
	bus.accept(HtmlGenerator("regif.html", "RegTable V1"))
}




class RegTableOld extends Component{

	val regSData = slave(AxiLite4(log2Up(1 MiB), 32))//地址位宽-数据位宽

	AxiLite4SpecRenamer(regSData)
	
	val bus = BusInterface(regSData, sizeMap = SizeMapping(0x43C00000, 1 MiB))//创建一个总线接口,映射范围是0~1MiB
	//后面的内存映射也可以这样写：BusInterface(IO.regSData,(0x0000, 100 Byte)
	//这个BusInterface是一个object
	//这里的只读和只写对应的是master那边的只读和只写

    val LedReg  = bus.newReg(doc="PS Lights up Led ,test")

    val LD0123=LedReg.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput()
	//val Read_Ps_Num=Reg0.field(Bits(10 bit),WO,doc="pl 从ps ddr读数据的数量").asInput()--报错
	val LD4567=LedReg.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput() 

	bus.accept(HtmlGenerator("regif.html", "RegTable V1"))//fuck
	//git pull 测试哈哈哈哈
}

object RegTable_Gen extends App { 
    val verilog_path="./testcode_gen" //注意是高复位
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}