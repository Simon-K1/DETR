package utils
import spinal.lib.{master, slave,StreamWidthAdapter}
import spinal.core._
class WidthConvert extends Component{
    //位宽转换,只适用于Img2Col模块与SA的数据交互
    val io =new Bundle{
        val InData=slave Stream(Bits(64 bits))
        val OutData=out Bits(8 bits)
    }
    val Regs=Vec(Reg(Bits(8 bits))init(0),8)
    when(io.InData.valid){
        for(i<-0 to 7){
            Regs(i):=io.InData.payload((i+1)*8-1 downto i*8)
        }
    }otherwise{
        for(i<-1 to 7){
            Regs(i-1):=Regs(i)
        }
    }

    io.OutData:=Regs(0)
    
    io.InData.ready:=True
}



class AxisDataConverter(InWidth:Int,OutWidth:Int) extends Component{
    if(InWidth>OutWidth)
    assert(InWidth%OutWidth==0,"要使用SpinalHDL自带的Converter,InWidth和OutWidth必须为倍数关系")
    else if(InWidth<OutWidth)
    assert(OutWidth%InWidth==0,"要使用SpinalHDL自带的Converter,InWidth和OutWidth必须为倍数关系")
    val inStream =slave Stream(UInt(InWidth bits))
    val outStream =master Stream(UInt(OutWidth bits))
    val adapter = StreamWidthAdapter(inStream,outStream)
}
object Lty_Gen extends App { 
    val verilog_path="src/main/scala/utils/verilog" 
   //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Med_Sort)
//    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new RegTable)
//    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Feature_Mark)
//    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new AxisDataConverter(96,64))
   SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new WidthConvert)
   //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Map_Triangle_Mem)
}