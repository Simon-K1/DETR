package Spinal_Sim

import  spinal.core._
import  spinal.lib.bus.amba4._
import spinal.lib.bus.amba4.axilite.AxiLite4Config
import spinal.lib.bus.amba4.axilite.AxiLite4
import spinal.lib.slave
import spinal.lib.master
import utils.WaCounter
import java.text.Normalizer.Form
import spinal.lib.bus.amba4.axilite.AxiLite4SpecRenamer
object DMACtrl_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT,READ_DMA_REG,CHECK_DMA_STATUS,WAIT_NEXT_CHECK,START_RECEIVE,START_SEND,WAIT_INTR= newElement
    //发送和接收数据，将Bram 0号地址空间数据搬运到1号地址空间，也就是需要同时启动Dma读写
        //从0号地址空间读出数据，并且写入1号地址空间
    //CHECK_DMA_STATUS:检查DMA状态，每次需要从DMA的0x4地址中读出dma的状态，读出dma状态后，如果状态是IDLE，则启动DMA收发数据
        //如果读出来的状态不是IDLE，那么等10个周期后再查询一下，直到DMA 的状态是IDLE
        //在检查DMA状态中，需要先发送一个读读地址，当DMA接收到有效的读地址后，还需要等待DMA返回有效的读数据
    //WAIT_READ_BACK:等待DMA发回读取到的数据
    //在等待DMA_Ready的过程中需要轮询DMA的状态，读取DMA的0x4寄存器，每10个周期读一下
    //START_RECEIVE:启动接收，
    //START_SEND:启动发送
    //WAIT_INTR:等待中断
}
case class DmaCtrl_Fsm(start:Bool)extends Area{
    val currentState = Reg(DMACtrl_ENUM()) init DMACtrl_ENUM.IDLE
    val nextState = DMACtrl_ENUM()
    currentState := nextState

    val Inited=Bool()//初始化完成
    val Dma_Idle=Bool()//查询到的DMA IDLE状态
    val AxiLite_arready=Bool()//读地址发送完成
    val AxiLite_rValid=Bool()//通过Axilite读回了有效的DMA状态

    val Wait_Check_Cnt_Valid=Bool()

    val Receive_Started=Bool()//启动DMA接收数据完成
    val Send_Started=Bool()//启动DMA发送数据完成
    val Intr_Detected=Bool()//检测到DMA中断
    switch(currentState){
        is(DMACtrl_ENUM.IDLE){
            when(start){
                nextState:=DMACtrl_ENUM.INIT
            }otherwise{
                nextState:=DMACtrl_ENUM.IDLE
            }
        }
        is(DMACtrl_ENUM.INIT){
            when(Inited){
                nextState:=DMACtrl_ENUM.READ_DMA_REG
            }otherwise{
                nextState:=DMACtrl_ENUM.INIT
            }
        }
        is(DMACtrl_ENUM.READ_DMA_REG){//读取DMA寄存器

            when(AxiLite_arready){
                nextState:=DMACtrl_ENUM.CHECK_DMA_STATUS
            }otherwise{
                nextState:=DMACtrl_ENUM.READ_DMA_REG
            }
        }
        is(DMACtrl_ENUM.CHECK_DMA_STATUS){
            when(AxiLite_rValid){
                when(Dma_Idle){
                    nextState:=DMACtrl_ENUM.START_RECEIVE
                }otherwise{
                    nextState:=DMACtrl_ENUM.WAIT_NEXT_CHECK//读地址1发送完成，下一步等待DMA返回最新状态
                } 
            }otherwise{
                nextState:=DMACtrl_ENUM.CHECK_DMA_STATUS
            }
        }
        is(DMACtrl_ENUM.WAIT_NEXT_CHECK){
            when(Wait_Check_Cnt_Valid){
                nextState:=DMACtrl_ENUM.READ_DMA_REG
            }otherwise{
                nextState:=DMACtrl_ENUM.WAIT_NEXT_CHECK
            }
        }
        is(DMACtrl_ENUM.START_RECEIVE){
            when(Receive_Started){
                nextState:=DMACtrl_ENUM.START_SEND
            }otherwise{
                nextState:=DMACtrl_ENUM.START_RECEIVE
            }
        }
        is(DMACtrl_ENUM.START_SEND){
            when(Send_Started){
                nextState:=DMACtrl_ENUM.WAIT_INTR
            }otherwise{
                nextState:=DMACtrl_ENUM.START_SEND
            }
        }
        is(DMACtrl_ENUM.WAIT_INTR){
            when(Intr_Detected){
                nextState:=DMACtrl_ENUM.IDLE
            }otherwise{
                nextState:=DMACtrl_ENUM.WAIT_INTR
            }
        }
    }
}
//自己控制DMA
class DmaCtrl extends  Component{
    val AxiLite=master(AxiLite4(AxiLite4Config(addressWidth=10,dataWidth=32)))
    AxiLite4SpecRenamer(AxiLite)
    val io=new Bundle{
        val Read_Addr=in UInt(32 bits)//读地址
        val Read_Length=in UInt(32 bits)//读长度

        val Write_Addr=in UInt(32 bits)//写地址
        val Write_Length=in UInt(32 bits)//写长度
        val start=in Bool()//启动Dma读写数据，搬运数据 
    }
    noIoPrefix()
    AxiLite.aw.valid    :=False//Reg(Bool())init(False)
    AxiLite.w.valid     :=False//Reg(Bool())init(False)

    AxiLite.ar.valid    :=False//Reg(Bool)init False//Reg(Bool())init(False)
    AxiLite.r.ready     :=False//Reg(Bool())init(False)
    AxiLite.ar.payload.addr:=0// address

    AxiLite.b.ready     :=True//Reg(Bool())init(False)
//读数据，查询dma状态
    val Fsm=DmaCtrl_Fsm(io.start)
    val Init_Cnt=WaCounter(Fsm.currentState===DMACtrl_ENUM.INIT,3,5)//初始化计数器
    Fsm.Inited:=Init_Cnt.valid
    val Wait_Check_Cnt=WaCounter(Fsm.currentState===DMACtrl_ENUM.WAIT_NEXT_CHECK,4,10)//每10个周期查询一下DMA状态
    Fsm.Wait_Check_Cnt_Valid:=Wait_Check_Cnt.valid

    //检查DMA状态
    Fsm.Dma_Idle:=AxiLite.r.payload.data(0 downto 0).asBool//DMA IDLE状态
    Fsm.AxiLite_rValid:=AxiLite.r.valid
    Fsm.AxiLite_arready:=AxiLite.ar.ready
    when(Fsm.currentState===DMACtrl_ENUM.READ_DMA_REG){
        AxiLite.ar.valid:=True//读地址valid拉高
    //如果arready拉低,那么arvalid拉高,如果arready拉高,那么arvalid与arready握手一下
        AxiLite.ar.addr:=0x4//读取0x4寄存器
        //AxiLite.r.ready:=True//读数据通道准备好接收数据
    }
    when(Fsm.currentState===DMACtrl_ENUM.CHECK_DMA_STATUS){
        AxiLite.r.ready:=True//读数据通道准备好接收数据
    }
    AxiLite.ar.payload.prot:=6//.assignBigInt(6)
    

//写数据
    AxiLite.aw.payload.prot :=6//0110
    AxiLite.w.payload.strb  :=15//1111
    AxiLite.aw.payload.addr :=0
    AxiLite.w.payload.data  :=0

    Fsm.Receive_Started :=False//启动DMA接收数据完成
    Fsm.Send_Started    :=False//启动DMA发送数据完成
    Fsm.Intr_Detected   :=False//检测到DMA中断
}


object Top extends App { 
    val OnBoard=false
    var verilog_path="./testcode_gen" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DmaCtrl)
}