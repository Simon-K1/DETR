package Interface.AXI
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
    val Reg_W  = bus.newReg(doc="PS Lights up Led ,test")
    val Reg_R  = bus.newReg(doc="PS Lights up Led ,test")
    val LD0123=Reg_W.field(Bits(4 bit),WO,doc="O:接外面的灯，测试").asOutput()
	val LD4567=Reg_R.field(Bits(4 bit),RO,doc="O:接外面的灯，测试").asInput()


	bus.accept(HtmlGenerator("regif", "RegTable V1"))
}





object RegTable_Gen extends App { 
    val verilog_path="./verilog/MyAxi"  //注意是高复位
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}