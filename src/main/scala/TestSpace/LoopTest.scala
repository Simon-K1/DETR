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
        val gpio_in=in Bits(4 bits)
        val cnt    =out UInt(32 bits)

        val Intc=out Bool()
        val Interrupt_Coming=out UInt(32 bits)//中断到来
        val Waiting_Detect_interrupt=out Bool()
    }
    noIoPrefix()
    
    


    val valid=io.gpio_in(0)//当改valid拉高，则计数器开始计数
    val restart=io.gpio_in(1)
    val Waiting_Detect_interrupt=Reg(Bool)init(False)//等待检测到中断
    io.Waiting_Detect_interrupt:=Waiting_Detect_interrupt
    //每隔一段时间给一个中断
    val clk_period=20;//20ns,50MHz
    //每隔一段时间
    val int_cycle=2//单位2s
    val MAX_CNT:Long=int_cycle*1000*1000*1000/clk_period
    val INTERRUPT_LAST=100;
    print(MAX_CNT)
    // assert(MAX_CNT<0xffffffff)
    

    val Interrupt_Coming=Reg(UInt(32 bits))init(0)
    val Intc=Reg(Bool)init(False)//中断信号
    when(Interrupt_Coming===MAX_CNT){//等待2秒后，中断产生
        Intc:=True
    }elsewhen(Interrupt_Coming===(MAX_CNT+INTERRUPT_LAST-1)){//中断产生后，维持100个周期
        Intc:=False
    }
    io.Interrupt_Coming:=Interrupt_Coming
    io.Intc:=Intc

    val Interrupt_prepare=Reg(Bool)init(False)//准备中断
    val Start_generate_Interrupt=io.gpio_in(3)//ps给一个启动信号，开始生成中断
    when(Start_generate_Interrupt){
        Interrupt_prepare:=True
    }elsewhen(Interrupt_Coming===(MAX_CNT+INTERRUPT_LAST-1)){//中断计时器数两秒后拉高一下中断
        Interrupt_prepare:=False
    }

    when(Interrupt_Coming===(MAX_CNT+INTERRUPT_LAST-1)){
        Interrupt_Coming:=0
    }elsewhen(Interrupt_prepare){
        Interrupt_Coming:=Interrupt_Coming+1
    }

    when(Intc&(~RegNext(Intc))){//当中断产生，等待PS那边检测到中断，开始计时
        Waiting_Detect_interrupt:=True
    }elsewhen(restart){//当PS检测到中断，拉低
        Waiting_Detect_interrupt:=False//当向gpio写2时，说明检测到了中断
    }


    val cnt=Reg(UInt(32 bits))init(0)
    when(valid){
        cnt:=cnt+1
    }elsewhen(Waiting_Detect_interrupt){//
        cnt:=cnt+1//中断产生，就开始计时
    }elsewhen(restart||io.gpio_in(2)){
        cnt:=0//复位
    }
    io.cnt:=cnt
}
class Int_Generate extends Component{

    val io=new Bundle{
        val Intc=out Bool()
        val Int_cnt=out UInt(32 bits)
    }
    noIoPrefix()
    //每隔一段时间给一个中断
    val clk_period=20;//20ns,50MHz
    //每隔一段时间
    val int_cycle=2//单位2s
    val MAX_CNT:Long=int_cycle*1000*1000*1000/clk_period
    print(MAX_CNT)
    // assert(MAX_CNT<0xffffffff)
    
    val Int_cnt=Reg(UInt(32 bits))init(0)
    val Intc=Reg(Bool)init(False)
    when(Int_cnt===MAX_CNT){
        Intc:=True
    }elsewhen(Int_cnt===MAX_CNT+100){
        Intc:=False
    }
    io.Intc:=Intc
    when(Int_cnt===MAX_CNT){
        Int_cnt:=0
    }otherwise{
        Int_cnt:=Int_cnt+1
    }
    io.Int_cnt:=Int_cnt
}




class Timer_Cnt_V2 extends Component{
    val io=new Bundle{
        val gpio_in=in Bits(3 bits)
        val cnt    =out UInt(32 bits)
    }
    val valid=io.gpio_in(0)//当改valid拉高，则计数器开始计数
    val restart=io.gpio_in(1)
    val cnt=Reg(UInt(32 bits))init(0)
    when(valid){
        cnt:=cnt+1
    }elsewhen(io.gpio_in(2)){
        cnt:=0
    }elsewhen(restart){
        cnt:=0//复位
    }
    io.cnt:=cnt
}