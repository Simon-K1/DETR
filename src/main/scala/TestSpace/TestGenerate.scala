package TestSpace
import spinal.core._
import TestSpace.AD9361.{TX_DDR,IQ_concat}

object TestGen extends App { 
    val verilog_path="src/main/scala/TestSpace" 
    // val test=new TopTest
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Timer_Cnt)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Timer_Cnt_V2)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new IQ_concat)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new TX_DDR)
    
}