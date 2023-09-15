package TestSpace.NandFlash

import spinal.core._
import utils.ForLoopCounter
import xip.xil_SimpleDualBram
import spinal.lib.StreamFifo
import spinal.lib.Delay



object RW_STATUS extends SpinalEnum(defaultEncoding = binaryOneHot){
    val IDLE,CLEAR,WRITE,READ_AND_CHECK,IS_LAST_TEST=newElement
}
case class RW_Fsm(start:Bool)extends Area{
    val currentState = Reg(RW_STATUS()) init RW_STATUS.IDLE
    val nextState = RW_STATUS()
    currentState := nextState

    val clear_done=Bool()
    val write_done=Bool()
    val read_done=Bool()
    val is_last_test=Bool()

    switch(currentState){
        is(RW_STATUS.IDLE){
            when(start){
                nextState:=RW_STATUS.CLEAR
            }otherwise{
                nextState:=RW_STATUS.IDLE
            }
        }

        is(RW_STATUS.CLEAR){
            when(clear_done){
                nextState:=RW_STATUS.WRITE
            }otherwise{
                nextState:=RW_STATUS.CLEAR
            }
        }

        is(RW_STATUS.WRITE){
            when(write_done){
                nextState:=RW_STATUS.READ_AND_CHECK
            }otherwise{
                nextState:=RW_STATUS.WRITE
            }
        }
        is(RW_STATUS.READ_AND_CHECK){
            when(read_done){
                nextState:=RW_STATUS.IS_LAST_TEST
            }otherwise{
                nextState:=RW_STATUS.READ_AND_CHECK
            }
        }
        is(RW_STATUS.IS_LAST_TEST){
            when(is_last_test){
                nextState:=RW_STATUS.IDLE
            }otherwise{
                nextState:=RW_STATUS.CLEAR
            }
        }
    }



}
class NandFlash_Check(CHECK_TIMES_WIDTH:Int,CHECK_DATA_NUM_WIDTH:Int) extends Component{
    val io =new Bundle{
        val start=in Bool()
        val Check_Times=in UInt(CHECK_TIMES_WIDTH bits)//写次数
        val Check_Data_Num=in UInt(CHECK_DATA_NUM_WIDTH bits)//写数据量
        val Check_Start_Addr=in UInt(24 bits)//写起始地址(用于测试，之后的Wr_Addr会不断累加4K)
        val Wr_Addr=out UInt(24 bits)//实际的写起始地址

        val done_flag=out Bool()//读写是否完成的flag

        val wr_data=in UInt(8 bits)
        val wr_valid=in Bool()

        val rd_data=in UInt(8 bits)
        val rd_valid=in Bool()

        val clr_opt=out Bool()
        val wr_opt=out Bool()
        val rd_opt=out Bool()
    }
    val Fsm=RW_Fsm(io.start)
    noIoPrefix()
    val Data_Cache=new StreamFifo(UInt(8 bits),8192)
    Data_Cache.io.push.payload:=io.wr_data
    Data_Cache.io.push.valid:=io.wr_valid&&(Fsm.currentState===RW_STATUS.WRITE)

    Data_Cache.io.pop.ready:=io.rd_valid&&(Fsm.currentState===RW_STATUS.READ_AND_CHECK)

    //clr===================================================
    
    io.clr_opt:=Delay((Fsm.currentState===RW_STATUS.CLEAR),5)
    //每次操作完后，延时一段时间
    val Clr_Delay_Cnt=Reg(UInt(10 bits))init(0)
    when(Fsm.currentState===RW_STATUS.CLEAR){
        Clr_Delay_Cnt:=Clr_Delay_Cnt+1
    }otherwise{
        Clr_Delay_Cnt:=0
    }
    Fsm.clear_done:=Clr_Delay_Cnt.msb

    //wr====================================================
        //在写入的同时将被写入的数据存入fifo中，用于下次与读回来的数据进行对比
    io.wr_opt:=Delay((Fsm.currentState===RW_STATUS.WRITE),5)
    val wr_cnt=ForLoopCounter(io.wr_valid&&(Fsm.currentState===RW_STATUS.WRITE),CHECK_DATA_NUM_WIDTH,io.Check_Data_Num-1)//写计数器，应该往nand flash写入固定数量的数据
    val Write_Done_Flag=Reg(Bool())init(False)
    val Wr_Delay_Cnt=Reg(UInt(10 bits))init(0)//写完了，等一段时间再启动读操作

    Fsm.write_done:=Wr_Delay_Cnt.msb
    when(Write_Done_Flag){
        Wr_Delay_Cnt:=Wr_Delay_Cnt+1
    }otherwise{
        Wr_Delay_Cnt:=0
    }
    when(wr_cnt.valid){
        Write_Done_Flag:=True
    }elsewhen(Wr_Delay_Cnt.msb){
        Write_Done_Flag:=False
    }
    //rd====================================================
        //在读的同时，从fifo中pop出之前写入的数据与读出的数据进行对比
    io.rd_opt:=Delay((Fsm.currentState===RW_STATUS.READ_AND_CHECK),5)
    val rd_cnt=ForLoopCounter(io.rd_valid&&(Fsm.currentState===RW_STATUS.READ_AND_CHECK),CHECK_DATA_NUM_WIDTH,io.Check_Data_Num-1)
    val Read_Done_Flag=Reg(Bool())init(False)
    val Rd_Delay_Cnt=Reg(UInt(10 bits))init(0)

    Fsm.read_done:=Rd_Delay_Cnt.msb
    when(Read_Done_Flag){
        Rd_Delay_Cnt:=Rd_Delay_Cnt+1
    }otherwise{
        Rd_Delay_Cnt:=0
    }
    when(rd_cnt.valid){
        Read_Done_Flag:=True
    }elsewhen(Rd_Delay_Cnt.msb){
        Read_Done_Flag:=False
    }

        //将读进来的数据进行对比
    val Error_Cnt=Reg(UInt(32 bits))init(0)//错误次数统计
    val Error_Flag=Reg(Bool())init(False)
    when(io.start){
        Error_Cnt:=0
    }elsewhen(Error_Flag){
        Error_Cnt:=Error_Cnt+1
    }

    when(io.rd_valid){//如果读入的数据有效，那么将其与fifo pop出的数据进行对比
        when(RegNext(io.rd_data)=/=Data_Cache.io.pop.payload){
            Error_Flag:=True
        }
    }elsewhen(Fsm.clear_done){
        Error_Flag:=False
    }

    //=================================================
        //写一次读一次，需要统计可以写多少次，读多少次
    val Check_Times_Cnt=Reg(UInt(CHECK_TIMES_WIDTH bits))init(0)
        //ForLoopCounter(,CHECK_TIMES_WIDTH,io.Check_Times-1)
    when(Fsm.currentState===RW_STATUS.IS_LAST_TEST&&(Fsm.nextState===RW_STATUS.CLEAR)){
        Check_Times_Cnt:=Check_Times_Cnt+1
    }elsewhen(io.start){
        Check_Times_Cnt:=0
    }
    Fsm.is_last_test:=Check_Times_Cnt===(io.Check_Times-1)

    val Wr_Addr=Reg(UInt(24 bits))init(0)
    when(io.start){
        Wr_Addr:=io.Check_Start_Addr
    }elsewhen(Fsm.nextState===RW_STATUS.IS_LAST_TEST){
        Wr_Addr:=Wr_Addr+4096//4096的地址步长（4k）
    }
    io.Wr_Addr:=Wr_Addr

    io.done_flag:=Error_Flag
}

object TestGen extends App { 
    val verilog_path="src/main/scala/TestSpace/NandFlash" 
    // val test=new TopTest
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new NandFlash_Check(16,32))

    
}