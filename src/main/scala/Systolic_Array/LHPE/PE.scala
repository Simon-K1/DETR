package Systolic_Array
import spinal.core._
import utils.WaCounter
import utils.ForLoopCounter


class dsp_marco(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int) extends BlackBox {
  val io = new Bundle{
    val CLK = in Bool()
    val A = in SInt(9 bits)//代尧修改
    val B = in SInt(B_WIDTH bits)
    val P =out SInt(OUT_WIDTH bits)
  }
//  when(io.A(A_WIDTH downto A_WIDTH)===0){
//
//
//  }


  noIoPrefix()

  mapClockDomain(clock=io.CLK)
}




class PE(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int,peConfig:PEConfig) extends Component{
  val io = new Bundle{
    val activate = in SInt(A_WIDTH bits)
    val weight = in SInt(B_WIDTH bits)
    val vaild = in Bool()//数据有效的信号
    val signCount = in UInt(16 bits)  //卷积核16*16  signCoun就是t256
    val acount = out SInt(A_WIDTH bits)
    val bcount = out SInt(B_WIDTH bits)
    val PE_OUT = out SInt(OUT_WIDTH bits)
    val finish =  out Bool ()
  }
  noIoPrefix()
  val reg1 = Reg(SInt(peConfig.Reg_WIDTH bits)) init(0)

  val dsp = new dsp_marco(8,8,16)
  when(RegNext(io.vaild)){
    reg1:=dsp.io.P+reg1
  }

  val finishCnt = ForLoopCounter(RegNext(RegNext(io.vaild)),16,io.signCount)
  io.finish:=finishCnt.valid

  when(finishCnt.valid){
    io.PE_OUT:=reg1
    reg1:=io.vaild?(dsp.io.P.resized)|S(0,peConfig.Reg_WIDTH bits)    //U(0,4 bits)@@(dsp.io.P)
  }otherwise{
    io.PE_OUT:=0
  }
  //代尧修改↓
  S(B"1'b0")@@io.activate <> dsp.io.A   ////根据vaild将dsp输入改变
  io.weight <> dsp.io.B
  io.acount <> RegNext(io.activate)
  io.bcount <> RegNext(io.weight)


}


//object PE extends App {
//  SpinalVerilog(new PE(8,8,20,PEConfig(64,20) ))
//}
