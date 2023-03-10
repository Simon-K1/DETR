package utils
import spinal.core.{Area, Bool, False, IntToBuilder, Reg, True, UInt, when}
import spinal.core.RegNext
import java.awt.Component
import spinal.core

object WaCounter {
    def apply(en: Bool, width: Int, end: UInt,Stride:UInt=1,InitData:UInt=0) = new WaCounter(en, width, end,Stride)
}//在构建DataGenerate时添加参数：stride，默认值为1

class WaCounter(en: Bool, width: Int, cnt: UInt,Stride:UInt) extends Area {
    val count = Reg(UInt(width bits)) init 0
    val valid = Bool()
    when(count === cnt) {
        valid := True
    } otherwise {
        valid := False
    }
    when(en) {
        count := count + Stride
        when(valid) {
            count := 0
        }
    }
    def clear = {
        count := 0
        valid := False
    }
}
object ForLoopCounter{
    //For循环累加器，相比于WaCounter，valid只会拉高一下
    //适用场景：3个及以上的个For循环映射到硬件上（两个或两个以下还是WaCounter比较保守）
    def apply(en:Bool,width:Int,end:UInt)=new ForLoopCounter(en, width, end)
    //def apply(en:Bool,width:Int,stride:UInt,subs:Boolean)=new ForLoopCounter(en,width,stride)
}
class ForLoopCounter(en:Bool,width:Int,cnt:UInt)extends Area{
    val count = Reg(UInt(width bits)) init 0
    val valid =(count === cnt)&&en//Valid只拉高一下，用于for循环的控制
    when(en) {
        when(valid) {
            count := 0
        }otherwise{
            count := count + 1
        }
    }
    def clear = {
        count := 0
        valid := False
    }
}
object SubstractLoopCounter{
    //递减循环计数器
    def apply(en:Bool,width:Int,start:UInt,Stride:UInt)=new SubstractLoopCounter(en, width, start,Stride)
    
}
class SubstractLoopCounter(en:Bool,width:Int,start:UInt,stride:UInt)extends Area{
    val count = Reg(UInt(width bits)) init start
    val valid =(count <= stride)&&en//Valid只拉高一下，用于for循环的控制
    when(en) {
        when(valid) {
            count := start
        }otherwise{
            count := count - stride
        }
    }
    def reset = {
        count := start
        valid := False
    }
}