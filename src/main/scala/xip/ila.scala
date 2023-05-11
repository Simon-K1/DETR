package xip

import spinal.core._
import spinal.lib.bus.amba4.axi.Axi4
//写一个自动生成ila的模块
class xil_ila(portSize:Array[Int]) extends Component{
    val probe = Array.ofDim[Bits](portSize.length)
    for(i<-0 to portSize.length-1){
        probe(i)=Bits(portSize(i) bits).asInput()
        probe(i).setName("probe"+i)
    }
    val clk=in Bool()  
}
object ila_gen extends App { 
    val verilog_path="./testcode_gen" 
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new xil_ila( Array(1, 2, 3,4)))
}
