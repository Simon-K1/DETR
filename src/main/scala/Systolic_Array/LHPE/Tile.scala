package Systolic_Array
import spinal.core._
import spinal.lib.Delay
import utils.WaCounter

case class PEConfig(count:Int,Reg_WIDTH:Int){

}


class Tile (Tile_Size: Int, dataWidthIn: Int, dataWidthOut: Int,peConfig:PEConfig)extends Component {
  val io = new Bundle {
    val activate = in UInt (Tile_Size * dataWidthIn bits)
    val weight = in UInt (Tile_Size * dataWidthIn bits)
    val vaild = in Bool() //数据有效的信号
    val signCount = in UInt (16 bits) //卷积核16*16  signCoun就是t256
    val PE_OUT = out Vec(UInt (dataWidthOut bits),Tile_Size)
    val resultVaild = out Vec(Bool,Tile_Size)
  }
  noIoPrefix()

  for(k <- 0 to Tile_Size-1){
    io.PE_OUT(k):=0
    io.resultVaild(k) := False
  }



  //  val PEone = new PEOther(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int,Reg_WIDTH:Int,peConfig:PEConfig)

//  (1 to Tile_Size - 1).foreach { i =>
//    val PEone = new PEOther(dataWidthIn: Int, dataWidthOut:Int,dataWidthOut:Int,peConfig:PEConfig)
//
//  }
 // val outCnt =  WaCounter(io.vaild,20,)


  val PEArry = Array.ofDim[PE](8, 8)
  PEArry(0)(0) = new PE(dataWidthIn, dataWidthIn,dataWidthOut,PEConfig(64,20))
  PEArry(0)(0).io.weight <> io.weight(7 downto 0)
  PEArry(0)(0).io.activate <> io.activate(7 downto 0)
  PEArry(0)(0).io.vaild <> io.vaild
  PEArry(0)(0).io.signCount<>io.signCount


  for (i <- 1 to Tile_Size-1) {
    val j=0
    PEArry(i)(j) = new PE(dataWidthIn, dataWidthIn,dataWidthOut,PEConfig(64,20))
    PEArry(i)(j).io.activate <> Delay(io.activate((i+1)*dataWidthIn-1 downto i*dataWidthIn),i)
    PEArry(i)(j).io.weight <> PEArry(i-1)(0).io.bcount
    PEArry(i)(j).io.vaild <> Delay(io.vaild,i)
    PEArry(i)(j).io.signCount<>io.signCount
    }

  for (j <- 1 to Tile_Size - 1) {
    val i = 0
    PEArry(i)(j) = new PE(dataWidthIn, dataWidthIn, dataWidthOut, PEConfig(64, 20))
    PEArry(i)(j).io.activate <> PEArry(0)(j - 1).io.acount
    PEArry(i)(j).io.weight <>   Delay(io.weight((j + 1) * dataWidthIn - 1 downto j * dataWidthIn),j)
    PEArry(i)(j).io.vaild <> Delay(io.vaild, j)
    PEArry(i)(j).io.signCount<>io.signCount

  }

  for(i <- 1 to Tile_Size-1){
    for(j <- 1 to Tile_Size - 1){
      PEArry(i)(j) = new PE(dataWidthIn, dataWidthIn, dataWidthOut, PEConfig(64, 20))
      PEArry(i)(j).io.activate <> PEArry(i)(j-1).io.acount
      PEArry(i)(j).io.weight <> PEArry(i-1)(j).io.bcount
      PEArry(i)(j).io.vaild <> Delay(PEArry(i)(j-1).io.vaild, 1)
      PEArry(i)(j).io.signCount<>io.signCount
    }
  }
  for(i <- 0 to Tile_Size-1) {
    for (j <- 0 to Tile_Size - 1) {
      when(PEArry(i)(j).io.finish === True) {
        io.PE_OUT(i) <> PEArry(i)(j).io.PE_OUT
        io.resultVaild(i)<>PEArry(i)(j).io.finish
      }
    }
  }



  }


//    io.activate <> PELeft.io.activate
//    io.weight <> PELeft.io.weight
//    io.vaild <>PELeft.io.vaild
//    io.signCount <>PELeft.io.signCount
//    io.PE_OUT<>PEone.io.PE_OUT
//
//
//  PEone.io.activate <> PELeft.io.acount //hang
//  PEone.io.weight <> PELeft.io.bcount  //列
//  PEone.io.vaild := RegNext(PELeft.io.vaild)
//  PEone.io.signCount := PELeft.io.signCount
//  PEone.io.finishNum <> PELeft.io.PE_OUT




// object Tile extends App{
//   SpinalVerilog(new Tile(8,8,20,PEConfig(767,20)))
// }

object Tile extends App { 
    val verilog_path="./Simulation/SimWeightTile" 
    // printf("=================%d===============",log2Up(7))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Tile(8,8,20,PEConfig(767,20)))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}
