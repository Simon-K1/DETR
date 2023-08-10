package TestSpace

import spinal.core._
import utils.SubstractLoopCounter
import utils.ForLoopCounter

class LoopTest extends Component{
    val io=new Bundle{
        val valid=in Bool()
        val restart=in Bool()
        val start=in UInt(32 bits)
    }

    val SubLoop=SubstractLoopCounter(io.valid,32,io.start,8)
    when(io.restart){
        SubLoop.reset
    }
}

class Timer_Cnt extends Component{
    val io=new Bundle{
        val gpio_in=in Bits(2 bits)
        val cnt    =out UInt(32 bits)
    }
    val valid=io.gpio_in(0)//当改valid拉高，则计数器开始计数
    val restart=io.gpio_in(1)
    val cnt=Reg(UInt(32 bits))init(0)
    when(valid){
        cnt:=cnt+1
    }elsewhen(restart){
        cnt:=0//复位
    }
    io.cnt:=cnt
}