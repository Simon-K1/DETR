package gemm
import spinal.core._
import spinal.core.internals.Operator
import spinal.lib._
import utils.{ForLoopCounter}
import xip.xil_SimpleDualBram

case class configGemm(){
  val WH_WIDTH = 12

  val dataWidthIn = 64
  val dataWidthOut = 64
}

object GEMM_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {
  val IDLE, INIT, WRITE, READ, CHECK= newElement//CHECK等待状态,

}

object RW_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {
  val IDLE, WRITE= newElement//CHECK,

}

case class RW_Fsm(start:Bool)extends Area{
  val currentState = Reg(RW_ENUM()) init RW_ENUM.IDLE //RegInit(GEMM_ENUM.IDLE)
  val nextState = RW_ENUM()
  currentState:= nextState

  val writeEnd = Bool()
  switch(currentState){
    is(RW_ENUM.WRITE) {
      when(writeEnd) {
        nextState := RW_ENUM.IDLE
      } otherwise {
        nextState := RW_ENUM.WRITE
      }
    }


    is(RW_ENUM.IDLE) {
      when(start) {
        nextState := RW_ENUM.WRITE
      } otherwise {
        nextState := RW_ENUM.IDLE
      }
    }

  }



}



case class GEMM_Fsm(start:Bool)extends Area{
  val currentState = Reg(GEMM_ENUM()) init GEMM_ENUM.IDLE//RegInit(GEMM_ENUM.IDLE)
  val nextState = GEMM_ENUM()
  currentState:= nextState
  val initEnd = Bool()
  val readFinish = Bool()
  val writeEnd = Bool()
  val judge = Bool()//读完没写完
  val otherWrite= Bool()//那边写完

  switch(currentState){
    is(GEMM_ENUM.IDLE){
        when(start){
          nextState:=GEMM_ENUM.INIT
        }otherwise{
          nextState:=GEMM_ENUM.IDLE
        }
    }

    is(GEMM_ENUM.INIT){
        when(initEnd){
          nextState:=GEMM_ENUM.WRITE
        }otherwise{
          nextState:=GEMM_ENUM.INIT
        }
    }

    is(GEMM_ENUM.WRITE){
      when(writeEnd) {
        nextState := GEMM_ENUM.READ
      } otherwise {
        nextState := GEMM_ENUM.WRITE
      }
    }

    is(GEMM_ENUM.READ){
      when(readFinish) {
        nextState := GEMM_ENUM.IDLE
      }elsewhen(judge) {
        nextState := GEMM_ENUM.CHECK
      }otherwise {
        nextState := GEMM_ENUM.READ
      }

    }

    is(GEMM_ENUM.CHECK){
      when(otherWrite) { //那边写完
        nextState := GEMM_ENUM.READ
      } otherwise {
        nextState := GEMM_ENUM.CHECK
      }
    }


  }

}







class GemmCache extends Component{
val config = new configGemm()

  val io = new Bundle{
      val sData =  slave Stream UInt(config.dataWidthIn bits)
      val WIDTH = in UInt(config.WH_WIDTH bits)
      val HIGHT = in UInt(config.WH_WIDTH bits)
      val WEIGHTCOL  = in UInt(8 bits) //权重矩阵列数

      val start = in Bool()  //START信号，开始加载
      val validOut = out Vec(Bool(),8)
      val LayerEnd = out Bool ()  //结束信号
      val bvalid = out Bool ()
      val mData = out UInt(config.dataWidthOut bits)
  }
  noIoPrefix()
  io.mData:=0

  val Switch=Reg(Bool()) init(False)//这地方的初始化得是1
  val valid =  Vec(Bool(),8) //数据有效
  val data = UInt(config.dataWidthOut bits)


  val reg = Reg(UInt(config.WH_WIDTH bits)) init (0)

  val fsm =  GEMM_Fsm(io.start)

  when(fsm.currentState === GEMM_ENUM.IDLE) {
    reg := io.HIGHT
  }

  val writeend = fsm.currentState === GEMM_ENUM.WRITE && fsm.nextState === GEMM_ENUM.READ

  val rwfsm = new RW_Fsm((Switch.fall()||Switch.rise())&&fsm.currentState=/=GEMM_ENUM.IDLE)

  val initCount=ForLoopCounter(fsm.currentState===GEMM_ENUM.INIT,3,5)
  val colCnt = ForLoopCounter(io.sData.fire,config.WH_WIDTH,io.WIDTH-1)
  val rAddrCnt= ForLoopCounter(fsm.currentState===GEMM_ENUM.READ,config.WH_WIDTH,io.WIDTH-1)
  val totalCnt =ForLoopCounter(rAddrCnt.valid,log2Up(8),io.WEIGHTCOL/8-1)//记录权重矩阵出了几次
  val finish = Bool()
  when(totalCnt.valid&&reg<=8){
    finish:=True
  }otherwise{
    finish:=False
  }



  when(totalCnt.valid&&(!finish)) {
    reg := reg - config.dataWidthIn / 8
  }


  when(RegNext(writeend)) {
    Switch := !Switch
  } elsewhen (RegNext(totalCnt.valid && rwfsm.currentState === RW_ENUM.IDLE)) {
    Switch := !Switch
  } elsewhen (RegNext(colCnt.valid && fsm.currentState === GEMM_ENUM.CHECK)) {
    Switch := !Switch
  }elsewhen(RegNext(finish)){
    Switch := False
  }


  rwfsm.writeEnd:=colCnt.valid
  fsm.initEnd:=initCount.valid
  fsm.judge:=totalCnt.valid&&rwfsm.currentState===RW_ENUM.WRITE
  fsm.readFinish:=finish//totalCnt.valid&&rwfsm.currentState===RW_ENUM.IDLE//suoyou都读空
  fsm.otherWrite:=colCnt.valid
  fsm.writeEnd:=colCnt.valid
  io.LayerEnd:= RegNext(finish)

  val buffer1=new xil_SimpleDualBram(config.dataWidthIn,2304,config.dataWidthOut,"A_Bram",true)
  val buffer2=new xil_SimpleDualBram(config.dataWidthIn,2304,config.dataWidthOut,"B_Bram",true)

  buffer1.io.addra := 0
  buffer1.io.dina := 0
  buffer1.io.ena := False
  buffer1.io.wea := True
  buffer2.io.addrb := 0
  buffer2.io.addra := 0
  buffer2.io.dina := 0
  buffer2.io.ena := False
  buffer2.io.wea := True
  buffer1.io.addrb := 0


  when(Switch===False){
    buffer1.io.addra := colCnt.count
    buffer1.io.dina := io.sData.payload
    buffer1.io.ena := io.sData.fire
    buffer1.io.wea := True
    buffer2.io.addrb := rAddrCnt.count
    data := buffer2.io.doutb
//    for(i <- 0 to 7){
//      io.mData((i+1)*8-1 downto i*8):=Delay(buffer2.io.doutb((i+1)*8-1 downto i*8),i)
//    }


  }otherwise{
    buffer2.io.addra := colCnt.count
    buffer2.io.dina := io.sData.payload
    buffer2.io.ena := io.sData.fire
    buffer2.io.wea := True
    buffer1.io.addrb := rAddrCnt.count
    data := buffer1.io.doutb
//    for (i <- 0 to 7) {
//      io.mData((i + 1) * 8 - 1 downto i * 8) := Delay(buffer1.io.doutb((i + 1) * 8 - 1 downto i * 8), i)
//    }
  }



   when(fsm.currentState === GEMM_ENUM.WRITE || rwfsm.currentState===RW_ENUM.WRITE){
    io.sData.ready := True
   }otherwise{
     io.sData.ready := False
   }

  when(fsm.currentState === GEMM_ENUM.IDLE){
    rwfsm.writeEnd:=True

  }


  valid := Vec(False, 8)
//  when(RegNext(fsm.currentState === GEMM_ENUM.READ)) {
//    for (i <- 0 to 7) {
//      when(reg > i) {
//        valid(i) := True
//      } otherwise {
//        valid(i) := False
//      }
//
//    }
//  }

  when(RegNext(fsm.currentState === GEMM_ENUM.READ)) {
    valid := Vec(True, 8)
  }
  for (i <- 0 to 7) {
    io.validOut(i) := Delay(valid(i), i)
  }

      for (i <- 0 to 7) {
        io.mData((i + 1) * 8 - 1 downto i * 8) := Delay(data((i + 1) * 8 - 1 downto i * 8), i)
      }


  when(fsm.currentState === GEMM_ENUM.READ) {
    io.bvalid:= True
  }otherwise{
    io.bvalid:= False
  }







}









object GemmCache extends App{
  val verilog_path="./Simulation/gemm"
  SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new GemmCache)
}
