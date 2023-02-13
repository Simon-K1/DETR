package Systolic_Array

import spinal.core._
import spinal.lib.slave
import utils._
import xip.xil_SimpleDualBram
//实现权重矩阵的缓存与输出计算
class Weight_Cache extends Component{
    //应该创建8列缓存单元,卷积核循环填充到这8个缓存单元中
    val Config=TopConfig()
    val io=new Bundle{
        val sData=slave Stream(UInt(64 bits))

    }
    noIoPrefix()

    //构建8列权重缓存
    val Weight_Cache=Array.tabulate(Config.SA_COL){
        i=>def gen()={
            val Weight_Bram=new xil_SimpleDualBram(64,512*20,8,"Weight_Bram",i==0)
            Weight_Bram.io.addra:=0
            Weight_Bram.io.addrb:=0
            // Weight_Bram.io.doutb:=0
            Weight_Bram.io.dina:=0
            Weight_Bram.io.ena:=False
            Weight_Bram.io.wea:=False
        }
        gen()
    }
    io.sData.ready:=False
}

object Weight_Gen extends App { 
    val verilog_path="./testcode_gen/WeightCache" 
    
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Weight_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}