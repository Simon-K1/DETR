package Systolic_Array
import spinal.core._
import utils.WaCounter

class dsp_marco(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int) extends BlackBox {
  val io = new Bundle{
    val CLK = in Bool()
//    val CE = in Bool()
//    val SCLR =in Bool()
    val A = in UInt(A_WIDTH bits)
    val B = in UInt(B_WIDTH bits)
    val ACOUT= out UInt(A_WIDTH bits)
    val BCOUT = out UInt(B_WIDTH bits)
    val P =out UInt(OUT_WIDTH bits)
  }
  noIoPrefix()

  mapClockDomain(clock=io.CLK)
}

//case class PEConfig(count_WIDTH:Int){
//
//}


class PE(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int,peConfig:PEConfig) extends Component{
  val io = new Bundle{
    val activate = in UInt(A_WIDTH bits)
    val weight = in UInt(B_WIDTH bits)
    val vaild = in Bool()//数据有效的信号
//    val CE = in Bool()
//    val SCLR = in Bool()

    val signCount = in UInt(16 bits)  //卷积核16*16  signCoun就是t256
    val acount = out UInt(A_WIDTH bits)
    val bcount = out UInt(B_WIDTH bits)
    val PE_OUT = out UInt(OUT_WIDTH bits)
    val finish =  out Bool ()
  }
  noIoPrefix()
  val reg1 = Reg(UInt(peConfig.Reg_WIDTH bits)) init(0)

  val dsp = new dsp_marco(8,8,16)
  when(RegNext(io.vaild)){
    reg1:=dsp.io.P+reg1
  }

  val finishCnt = WaCounter(RegNext(RegNext(io.vaild)),16,io.signCount)
  io.finish:=finishCnt.valid

  when(finishCnt.valid){
    io.PE_OUT:=reg1
    reg1:=U(0,4 bits)@@(dsp.io.P)
  }otherwise{
    io.PE_OUT:=0
  }

  io.activate <> dsp.io.A   ////根据vaild将dsp输入改变
  io.weight <> dsp.io.B
  io.acount <> dsp.io.ACOUT
  io.bcount <> dsp.io.BCOUT


}


//object PE extends App {
//  SpinalVerilog(new PE(8,8,20,PEConfig(64,20) ))
//}
