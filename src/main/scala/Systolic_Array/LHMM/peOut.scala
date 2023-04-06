package Systolic_Array.LHMM
import spinal.core._
import spinal.lib._




class PEresult(dataWidthIn: Int, dataWidthOut: Int,depth:Int) extends Component{
  val io = new Bundle {

    val input = in Vec(Flow(UInt(dataWidthIn bits)), 8)
    val mData =  master Stream UInt(dataWidthOut bits)
    //val count = UInt(64 bits) //通道数
  }
  noIoPrefix()

  val dataFifo1 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo2 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo3 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo4 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo5 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo6 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo7 = new StreamFifo(UInt(dataWidthIn bits), 100)
  val dataFifo8 = new StreamFifo(UInt(dataWidthIn bits), 100)


  val fifos = Array(dataFifo1, dataFifo2, dataFifo3, dataFifo4, dataFifo5, dataFifo6, dataFifo7, dataFifo8)
//  fifos(7).io.push.valid:=io.input(7).valid
//  fifos(7).io.pop.ready<>io.mData.ready
//  fifos(7).io.push.payload<>io.input(7).payload

  for (i <- 0 until 8) {
    fifos(i).io.push.payload<>io.input(i).payload
    fifos(i).io.push.valid<>io.input(i).valid
    fifos(i).io.pop.ready<>(io.mData.ready&&fifos(7).io.pop.valid)
  }

  io.mData.payload<>(fifos(0).io.pop.payload@@fifos(1).io.pop.payload@@fifos(2).io.pop.payload@@fifos(3).io.pop.payload@@fifos(4).io.pop.payload@@fifos(5).io.pop.payload@@fifos(6).io.pop.payload@@fifos(7).io.pop.payload)
  io.mData.valid<>fifos(7).io.pop.fire


}




//object PEresult extends App {
//  SpinalVerilog(new PEresult)
//
//}
