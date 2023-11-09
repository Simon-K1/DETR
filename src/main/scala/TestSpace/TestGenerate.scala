package TestSpace
import spinal.core._
import TestSpace.AD9361.{TX_DDR,IQ_concat}
object STATE extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val ON,OFF= newElement

}
case class Img2Col_Fsm()extends Area{
    val currentState = Reg(STATE()) init STATE.OFF
    val nextState = STATE()
    currentState := nextState

    val j=Bool()
    val k=Bool()
    switch(currentState){
        is(STATE.OFF){
            when(j){
                nextState:=STATE.ON
            }otherwise{
                nextState:=STATE.OFF
            }
        }
        is(STATE.ON){
            when(k){
                nextState:=STATE.OFF
            }otherwise{
                nextState:=STATE.ON
            }
        }
    }
}
class test extends Component{
    val aa=in Bool()
    val Fsm=Img2Col_Fsm()
}
object TestGen extends App { 
    val verilog_path="./verilog" 
    // val test=new TopTest
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new test)
}