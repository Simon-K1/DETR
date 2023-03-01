package TestSpace
import spinal.core._
import utils.TopConfig
import spinal.lib.StreamFifo
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
class Scale_A_Fifo(dataType:spinal.core.Bits,depth: Int) extends StreamFifo(dataType,depth)
class ExtendsTest extends Component{
    val A=new Scale_A_Fifo(UInt(32 bits).asBits,32)
}


class gray2bin(data_width:Int=4) extends Component{
    val io=new Bundle{
        val gray=in Bits(data_width bits)
        val bin=out Bits(data_width bits)
    }
noIoPrefix()
    val bin_tmp=Bits(data_width bits)
    
    io.bin:=bin_tmp
    bin_tmp(data_width-1 downto data_width-1):=io.gray(data_width-1 downto data_width-1)
    for(i <-0 to data_width-2){
        bin_tmp(i downto i):=RegNext(bin_tmp(i+1 downto i+1)^io.gray(i downto i))
    }
}
class gray2bin_V2(data_width:Int=4) extends Component{
    val io=new Bundle{
        val gray=in Bits(data_width bits)
        val bin=out Bits(data_width bits)
    }


    
    io.bin(data_width-1 downto data_width-1):=io.gray(data_width-1 downto data_width-1)
    for(i <-0 to data_width-2){
        io.bin(i downto i):=io.bin(i+1 downto i+1)^io.gray(i downto i)
    }
}

object TestGen extends App { 
    val verilog_path="./testcode_gen" 
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new ExtendsTest)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new gray2bin)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}