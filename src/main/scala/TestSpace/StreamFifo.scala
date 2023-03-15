package TestSpace

import spinal.core._
import spinal.lib.slave
import spinal.lib.master
import spinal.lib.Counter

object StreamFifo{
  def apply[T <: Data](dataType: T, depth: Int) = new StreamFifo(dataType,depth)
}
//设计一个位宽转换的fifo，
//比如输入8bit，输出64bit
//注意：缺点就是必须凑齐完整的64bit才能输出一次，比如需要输入8个8bit的点才能输出一个64bit，如果只输入了7个8bit（56bit），那么pop.valid就永远不会拉高
class StreamFifo[T <: Data](dataType: HardType[T], depth: Int) extends Component {
  require(depth >= 0)
  val io = new Bundle {
    val push = slave Stream (dataType)
    val pop = master Stream (dataType)
    val flush = in Bool() default(False)
    val occupancy    = out UInt (log2Up(depth + 1) bits)
    val availability = out UInt (log2Up(depth + 1) bits)
  }

  val bypass = (depth == 0) generate new Area {
      io.push >> io.pop
      io.occupancy := 0
      io.availability := 0
    }
  val oneStage = (depth == 1) generate new Area{
      io.push.m2sPipe(flush = io.flush) >> io.pop
      io.occupancy := U(io.pop.valid)
      io.availability := U(!io.pop.valid)
    }
  val logic = (depth > 1) generate new Area {
    val ram  = Mem(dataType, depth)
    val ram_Array= Array.ofDim[Mem[T]](8)
    

    val pushPtr = Counter(depth)
    val popPtr = Counter(depth)
    val ptrMatch = pushPtr === popPtr
    val risingOccupancy = RegInit(False)
    val pushing = io.push.fire
    val popping = io.pop.fire
    val empty = ptrMatch & !risingOccupancy
    val full = ptrMatch & risingOccupancy

    io.push.ready := !full
    io.pop.valid := !empty & !(RegNext(popPtr.valueNext === pushPtr, False) & !full) //mem write to read propagation
    io.pop.payload := ram.readSync(popPtr.valueNext)

    when(pushing =/= popping) {
      risingOccupancy := pushing
    }
    when(pushing) {
      ram(pushPtr.value) := io.push.payload
      pushPtr.increment()
    }
    when(popping) {
      popPtr.increment()
    }

    val ptrDif = pushPtr - popPtr
    if (isPow2(depth)) {
      io.occupancy := ((risingOccupancy && ptrMatch) ## ptrDif).asUInt
      io.availability := ((!risingOccupancy && ptrMatch) ## (popPtr - pushPtr)).asUInt
    } else {
      when(ptrMatch) {
        io.occupancy    := Mux(risingOccupancy, U(depth), U(0))
        io.availability := Mux(risingOccupancy, U(0), U(depth))
      } otherwise {
        io.occupancy := Mux(pushPtr > popPtr, ptrDif, U(depth) + ptrDif)
        io.availability := Mux(pushPtr > popPtr, U(depth) + (popPtr - pushPtr), (popPtr - pushPtr))
      }
    }

    when(io.flush){
      pushPtr.clear()
      popPtr.clear()
      risingOccupancy := False
    }
  }
}
