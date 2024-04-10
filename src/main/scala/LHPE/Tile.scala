package Systolic_Array
import spinal.core._
import spinal.lib.Delay
import utils.WaCounter
import utils.TopConfig
//======================================
case class PEConfig(count:Int,Reg_WIDTH:Int){

}


class Tile (Tile_Size: Int, dataWidthIn: Int, dataWidthOut: Int,peConfig:PEConfig)extends Component {
  val io = new Bundle {
    val activate = in SInt (Tile_Size * dataWidthIn bits)
    val a_Valid = in Vec(Bool,Tile_Size)
    val weight = in SInt (Tile_Size * dataWidthIn bits)
    val b_Valid = in Vec(Bool,Tile_Size)

   // val vaild = in Bool() //数据有效的信号
    val signCount = in UInt (16 bits) //卷积核16*16  signCoun就是t256
    val PE_OUT = out Vec(SInt (dataWidthOut bits),Tile_Size)
    val resultVaild = out Vec(Bool,Tile_Size)
  }
  noIoPrefix()
  val PE_OUT=Vec(SInt (dataWidthOut bits),Tile_Size)
  val resultVaild = Vec(Bool,Tile_Size)
  for(k <- 0 to Tile_Size-1){
    PE_OUT(k):=0
    resultVaild(k) := False
    io.PE_OUT(k):=Delay(PE_OUT(k),Tile_Size-k)
    io.resultVaild(k):=Delay(resultVaild(k),Tile_Size-k)
  }

  val PEArry = Array.ofDim[PE](8, 8)
  PEArry(0)(0) = new PE(dataWidthIn, dataWidthIn,dataWidthOut,peConfig)
  PEArry(0)(0).io.weight <> io.weight(7 downto 0)
  PEArry(0)(0).io.activate <> io.activate(7 downto 0)
  PEArry(0)(0).io.vaild <> (io.a_Valid(0)&io.b_Valid(0))
  PEArry(0)(0).io.signCount<>io.signCount


  for (i <- 1 to Tile_Size-1) {
    val j=0
    PEArry(i)(j) = new PE(dataWidthIn, dataWidthIn,dataWidthOut,peConfig).setName("left")
    PEArry(i)(j).io.activate <> io.activate((i+1)*dataWidthIn-1 downto i*dataWidthIn)//io.activate((i+1)*dataWidthIn-1 downto i*dataWidthIn)//Delay(io.activate((i+1)*dataWidthIn-1 downto i*dataWidthIn),i)
    PEArry(i)(j).io.weight <> PEArry(i-1)(0).io.bcount
    PEArry(i)(j).io.vaild <> (io.a_Valid(i)&Delay(io.b_Valid(0),i))//Delay(io.a_Valid(i),i)//io.a_Valid(i)
    PEArry(i)(j).io.signCount<>io.signCount
    }

  for (j <- 1 to Tile_Size - 1) {
    val i = 0
    PEArry(i)(j) = new PE(dataWidthIn, dataWidthIn, dataWidthOut, peConfig).setName("top")
    PEArry(i)(j).io.activate <> PEArry(0)(j - 1).io.acount
    PEArry(i)(j).io.weight <>   Delay(io.weight((j + 1) * dataWidthIn - 1 downto j * dataWidthIn),j)
    PEArry(i)(j).io.vaild <> (Delay(io.b_Valid(j),j)&Delay(io.a_Valid(0),j))
    PEArry(i)(j).io.signCount<>io.signCount

  }

  for(i <- 1 to Tile_Size-1){
    for(j <- 1 to Tile_Size - 1){
      PEArry(i)(j) = new PE(dataWidthIn, dataWidthIn, dataWidthOut, peConfig).setName("mid")
      PEArry(i)(j).io.activate <> PEArry(i)(j-1).io.acount
      PEArry(i)(j).io.weight <> PEArry(i-1)(j).io.bcount
      PEArry(i)(j).io.vaild <>  (Delay(PEArry(i)(j-1).io.vaild, 1) & Delay(PEArry(i-1)(j).io.vaild, 1))
      PEArry(i)(j).io.signCount<>io.signCount
    }
  }
  for(i <- 0 to Tile_Size-1) {
    for (j <- 0 to Tile_Size - 1) {
      when(PEArry(i)(j).io.finish === True) {
        PE_OUT(i) <> PEArry(i)(j).io.PE_OUT
        resultVaild(i):=PEArry(i)(j).io.finish
        
      }
    }
  }
}



object Tile extends App{
  SpinalVerilog(new Tile(16,8,20,PEConfig(767,32)))
}
