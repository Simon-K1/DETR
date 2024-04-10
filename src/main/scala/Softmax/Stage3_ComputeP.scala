import spinal.core._
import utils.ForLoopCounter
import spinal.lib.Delay
import spinal.lib.PriorityMux
class Mul(AWidth:Int=8,BWidth:Int=8,CWidth:Int=8,delay_Times:Int=1) extends BlackBox{
    val io=new Bundle{
        val clk=in Bool()
        val rst=in Bool()
        val A=in UInt(AWidth bits)
        val B=in UInt(BWidth bits)
        val C=out UInt(CWidth bits)
    }
    noIoPrefix()
      // 添加参数
    addGeneric("AWidth", AWidth)
    addGeneric("BWidth", BWidth)
    addGeneric("CWidth", CWidth)
    addGeneric("delay_times", delay_Times)
    mapClockDomain(clock=io.clk,reset=io.rst)
}
class Stage3_ComputeP(MemDepth:Int=197) extends Component{
    val io=new Bundle{
        val MatrixCol=in UInt(log2Up(MemDepth) bits)
        val start=in Bool()
        val Xq_Z=in UInt(8+8 bits)//把Z和Xq拼起来
        val sValid=in Bool()
        val Scale=in UInt(8 bits)

        val f1=in UInt(16 bits)//Scaling_Factor,应该是一个高精度的值，所以用16bit来表示了,算法那边也不能取整
        val f2=in UInt(8 bits)
        val f3=in UInt(8 bits)
        
    }
    noIoPrefix()
    val Z_Mul_Scale=new Mul(8,8,16,1)
    Z_Mul_Scale.io.A:=io.Xq_Z(7 downto 0)
    Z_Mul_Scale.io.B:=io.Scale
    val P_Valid=RegNext(io.sValid)//对进来的valid打一拍,对齐Z*Scale的数据
    // val P_Mem=new Mem(UInt(8 bits),MemDepth)
    

    
    val P=((RegNext(io.Xq_Z(15 downto 8)).asSInt-Z_Mul_Scale.io.C.asSInt)).resize(8).asUInt//因为Z需要用Xq来算,Xq永远比Z快,所以需要对Xq进行延时
    // P_Mem.write(Counter.count,P,P_Valid)//先把P存起来

    //算完P之后,继续算e^p====//f1*(P*(P+f2)+f3)
    //第一步:先算P+floor(b/(a*S))
    val Mul_1=new Mul(8,8,16,1)//按照算法那边，f1，f2，f3直接取整了。没有移位
    Mul_1.io.A:=P+io.f2
    Mul_1.io.B:=P
    val Mul_1_Result=Mul_1.io.C
    val Mul_2=new Mul(16,16,32,1)
    
    Mul_2.io.B:=Mul_1.io.C+io.f3
    Mul_2.io.A:=io.f1
    val Mul_2_Result=Mul_2.io.C

    //然后再计算e^p>>z最终完成i-Exp的计算
    val Z_dly=Delay(io.Xq_Z(7 downto 0),3)
    val Iexp=RegNext(Mul_2.io.C>>Z_dly)//打一拍叭，这里动态移位不知道会发生什么...
    val Exp_Valid=Delay(io.sValid,4)
    val Exp_Sum=Reg(UInt(32 bits))init(0)//sum(e)累加和
    when(io.start){
        Exp_Sum:=0
    }elsewhen(Exp_Valid){
        Exp_Sum:=Exp_Sum+Iexp.resized
    }

    //完成IExp的计算后,需要计算计算累加和与log,并将log存起来
    val Log2_Result=UInt(5 bits)

    // 判断MSB
    when(Iexp.msb) {
        Log2_Result := U(23).resize(5)+((Iexp(22))?U(1)|U(0))
    }.elsewhen(Iexp(22)) {
        Log2_Result := U(21).resize(5)+((Iexp(21))?U(1)|U(0))
    }.elsewhen(Iexp(21)) {
        Log2_Result := U(20).resize(5)+((Iexp(20))?U(1)|U(0))
    }.elsewhen(Iexp(20)) {
        Log2_Result := U(19).resize(5)+((Iexp(19))?U(1)|U(0))
    }.elsewhen(Iexp(19)) {
        Log2_Result := U(18).resize(5)+((Iexp(18))?U(1)|U(0))
    }.elsewhen(Iexp(18)) {
        Log2_Result := U(17).resize(5)+((Iexp(17))?U(1)|U(0))
    }.elsewhen(Iexp(17)) {
        Log2_Result := U(16).resize(5)+((Iexp(16))?U(1)|U(0))
    }.elsewhen(Iexp(16)) {
        Log2_Result := U(15).resize(5)+((Iexp(15))?U(1)|U(0))
    }.elsewhen(Iexp(15)) {
        Log2_Result := U(14).resize(5)+((Iexp(14))?U(1)|U(0))
    }.elsewhen(Iexp(14)) {
        Log2_Result := U(13).resize(5)+((Iexp(13))?U(1)|U(0))
    }.elsewhen(Iexp(13)) {
        Log2_Result := U(12).resize(5)+((Iexp(12))?U(1)|U(0))
    }.elsewhen(Iexp(12)) {
        Log2_Result := U(11).resize(5)+((Iexp(11))?U(1)|U(0))
    }.elsewhen(Iexp(11)) {
        Log2_Result := U(10).resize(5)+((Iexp(10))?U(1)|U(0))
    }.elsewhen(Iexp(10)) {
        Log2_Result := U(9).resize(5)+((Iexp(9))?U(1)|U(0))
    }.elsewhen(Iexp(9)) {
        Log2_Result := U(8).resize(5)+((Iexp(8))?U(1)|U(0))
    }.elsewhen(Iexp(8)) {
        Log2_Result := U(7).resize(5)+((Iexp(7))?U(1)|U(0))
    }.elsewhen(Iexp(7)) {
        Log2_Result := U(6).resize(5)+((Iexp(6))?U(1)|U(0))
    }.elsewhen(Iexp(6)) {
        Log2_Result := U(5).resize(5)+((Iexp(5))?U(1)|U(0))
    }.elsewhen(Iexp(5)) {
        Log2_Result := U(4).resize(5)+((Iexp(4))?U(1)|U(0))
    }.elsewhen(Iexp(4)) {
        Log2_Result := U(3).resize(5)+((Iexp(3))?U(1)|U(0))
    }.elsewhen(Iexp(3)) {
        Log2_Result := U(2).resize(5)+((Iexp(2))?U(1)|U(0))
    }.elsewhen(Iexp(2)) {
        Log2_Result := U(1).resize(5)+((Iexp(1))?U(1)|U(0))
    }.elsewhen(Iexp(1)) {
        Log2_Result := ((Iexp(1))?U(1)|U(0)).resize(5)
    }.otherwise {
        Log2_Result := U(0)
    }

    
    val Counter=ForLoopCounter(Exp_Valid,log2Up(MemDepth),MemDepth-1)
    val Log_Mem=new Mem(UInt(5 bits),MemDepth)
    Log_Mem.write(Counter.count,Log2_Result,Counter.valid)
    val LogValid=Reg(Bool())init(False)
    when(io.start){
        LogValid:=False
    }elsewhen(Counter.valid){
        LogValid:=True
    }
    val Last_ExpSum=RegNextWhen(RegNext(Exp_Sum),Counter.valid,U(0))
    val Log_ExpSum=UInt(5 bits)
    var priorityList= Seq.empty[(Bool, UInt)] // 创建一个空的 Seq
    for(i<-31 to 0 by -1){
        priorityList=priorityList:+(Last_ExpSum(i),U(i).resize(5))//一个优先选择器，其实SpinalHD已经实现了这个功能，不用像之前那样写一堆When额
    }
    Log_ExpSum:= PriorityMux(priorityList)
    // Log2_Result:=computeLog2(Iexp)

    // def computeLog2(data: UInt):UInt = {
    //    val Log2_Result=UInt(8 bits)
    //    if(data.getWidth>1){
    //        when(data.msb){
    //            // val one=
    //            Log2_Result:=U(data.getWidth).resize(8)+((data(data.getWidth-2))?U(1)|U(0))//先实现向下取整
    //        }otherwise{
    //            computeLog2(data(data.getWidth-1 downto 0))
    //        }
    //    }else{
    //        Log2_Result:=0//先实现向下取整
    //    }
    //    Log2_Result
    // }

    //求完log然后将数据缓存下来，并计算累加和

}

object Softmax_Gen extends App { 
    val verilog_path="./verilog/SimSystolic/verilog" 
    // for (i<-23 to 0 by -1)
    // print(i)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Stage3_ComputeP)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}



// object PrioritySelectorExample {
//   def main(args: Array[String]): Unit = {
//     SpinalConfig(targetDirectory = "rtl").generateVerilog(new PrioritySelectorModule)
//   }
// }

// class PrioritySelectorModule extends Component {
//   val io = new Bundle {
//     val inputs = in Vec(UInt(32 bits), 8)
//     val result = out UInt(32 bits)
//   }

//     // val priorityList = Seq[(Bool(),UInt(5 bits))]
//     var seq= Seq.empty[(Bool, UInt)] // 创建一个空的 Seq
//     for(i<-31 to 0 by -1){
//         seq=seq:+
//     }
// // val seq: Seq[(Bool, UInt)] = Seq(
// //   (True, U(0, 5 bits)),
// //   (False, U(1, 5 bits)),
// //   (True, U(2, 5 bits)),
// //   (True, U(3, 5 bits)),
// //   (False, U(4, 5 bits))
// // )
//     // io.result := PriorityMux(priorityList)
// }