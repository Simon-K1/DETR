package TestSpace
import spinal.core._
import utils.TopConfig
class Xq2C extends BlackBox{
    //XQC=C*X_q计算
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in SInt(Config.XQ2C_A_WIDTH bits)
        val B=in SInt(Config.XQ2C_B_WIDTH bits)
        val P=out UInt(Config.XQ2C_P_WIDTH bits)
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
class Test extends Component{
    val a=Reg(SInt(20 bits))init(0)
    val b=Reg(SInt(8 bits))init(0)
    val hh=new Xq2C
    hh.io.A:=a
    hh.io.B:=b
}
object TestGen extends App { 
    val verilog_path="./testcode_gen" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Test)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}