package TestSpace
import spinal.core._
object TestGen extends App { 
    val verilog_path="src/main/scala/TestSpace" 
    // val test=new TopTest
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Timer_Cnt)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Timer_Cnt_V2)
    
}