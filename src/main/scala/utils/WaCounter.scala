package utils
import spinal.core.{Area, Bool, False, IntToBuilder, Reg, True, UInt, when}

object WaCounter {
    def apply(en: Bool, width: Int, end: UInt,Stride:UInt=1,InitData:UInt=0) = new WaCounter(en, width, end,Stride,InitData)
}//在构建DataGenerate时添加参数：stride，默认值为1

class WaCounter(en: Bool, width: Int, cnt: UInt,Stride:UInt,InitData:UInt) extends Area {
    val count = Reg(UInt(width bits)) init InitData
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