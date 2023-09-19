package TestSpace.NandFlash

import spinal.core._
import utils.ForLoopCounter
import xip.xil_SimpleDualBram
import spinal.lib.StreamFifo
import spinal.lib.Delay



object RW_STATUS extends SpinalEnum(defaultEncoding = binaryOneHot){
    val IDLE,CLEAR,WRITE,READ,CHECK,IS_LAST_TEST=newElement
}
case class RW_Fsm(start:Bool)extends Area{
    val currentState = Reg(RW_STATUS()) init RW_STATUS.IDLE
    val nextState = RW_STATUS()
    currentState := nextState

    val clear_done=Bool()
    val write_done=Bool()
    val read_done=Bool()
    val check_done=Bool()
    val is_last_test=Bool()
    val check_next_page=Bool()
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
                nextState:=RW_STATUS.READ
            }otherwise{
                nextState:=RW_STATUS.WRITE
            }
        }
        is(RW_STATUS.READ){
            when(read_done){
                nextState:=RW_STATUS.CHECK
            }otherwise{
                nextState:=RW_STATUS.READ
            }
        }
        is(RW_STATUS.CHECK){
            when(check_done){
                nextState:=RW_STATUS.IS_LAST_TEST
            }otherwise{
                nextState:=RW_STATUS.CHECK
            }
        }
        is(RW_STATUS.IS_LAST_TEST){
            when(is_last_test){
                nextState:=RW_STATUS.IDLE
            }elsewhen(check_next_page){
                nextState:=RW_STATUS.CLEAR
            }otherwise{
                nextState:=RW_STATUS.IS_LAST_TEST
            }
        }
    }



}
class NandFlash_Check(CHECK_TIMES_WIDTH:Int,CHECK_DATA_NUM_WIDTH:Int,WRITE_HEAD_NUM:Int=7,READ_HEAD_NUM:Int=0) extends Component{
    val io =new Bundle{
        val start=in Bool()
        val device_ready=in Bool()//设备ready，比如发了一个clear信号出去，需要等待的时间从1.5ms到7ms不等，在这期间无法再对设备进行操作
        val Check_Next_Page_En=in Bool()//读写下一页，可以一直给1，也可以在外面手动触发
        val Check_Times=in UInt(CHECK_TIMES_WIDTH bits)//写次数
        val Check_Data_Num=in UInt(CHECK_DATA_NUM_WIDTH bits)//写数据量
        //val Check_Start_Addr=in UInt(24 bits)//写起始地址(用于测试，之后的Wr_Addr会不断累加4K)
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

    //clr===================================================
    
    io.clr_opt:=Delay((Fsm.currentState===RW_STATUS.CLEAR),5)
    //每次操作完后，延时一段时间
    val Clr_Delay_Cnt=Reg(UInt(10 bits))init(0)
    when(Clr_Delay_Cnt.msb&&(Fsm.currentState===RW_STATUS.CLEAR)){
        Clr_Delay_Cnt:=Clr_Delay_Cnt
    }elsewhen(Fsm.currentState===RW_STATUS.CLEAR){
        Clr_Delay_Cnt:=Clr_Delay_Cnt+1
    }otherwise{
        Clr_Delay_Cnt:=0
    }
    Fsm.clear_done:=(Clr_Delay_Cnt.msb)&&io.device_ready

    //wr====================================================
        //在写入的同时将被写入的数据存入mem中，用于下次与读回来的数据进行对比
    io.wr_opt:=(Fsm.currentState===RW_STATUS.WRITE)
    val wr_cnt=ForLoopCounter(io.wr_valid&&(Fsm.currentState===RW_STATUS.WRITE),CHECK_DATA_NUM_WIDTH,io.Check_Data_Num-1+WRITE_HEAD_NUM)//写计数器，应该往nand flash写入固定数量的数据+一开始的固定长度数据
    val Write_Done_Flag=Reg(Bool())init(False)
    val Wr_Delay_Cnt=Reg(UInt(10 bits))init(0)//写完了，等一段时间再启动读操作

    Fsm.write_done:=Wr_Delay_Cnt.msb&&io.device_ready
    when(io.start){
        Wr_Delay_Cnt:=0
    }elsewhen(Fsm.nextState===RW_STATUS.CLEAR){
        Wr_Delay_Cnt:=0
    }elsewhen(Write_Done_Flag){
        Wr_Delay_Cnt:=Wr_Delay_Cnt+1
    }elsewhen(Wr_Delay_Cnt.msb){
        Wr_Delay_Cnt:=Wr_Delay_Cnt
    }otherwise{
        Wr_Delay_Cnt:=0
    }
    when(wr_cnt.valid){
        Write_Done_Flag:=True
    }elsewhen(Wr_Delay_Cnt.msb){
        Write_Done_Flag:=False
    }


    val wdata_cahce=new xil_SimpleDualBram(8,9000,8,"NdFlash_Mem",true)
    wdata_cahce.io.addra:=wr_cnt.count.resized
    wdata_cahce.io.dina:=io.wr_data
    wdata_cahce.io.ena:=io.wr_valid
    wdata_cahce.io.wea:=True
    //rd====================================================
    val rd_valid=(io.rd_valid)&&(~RegNext(io.rd_valid))//对rd_valid做了边沿检测
    io.rd_opt:=Fsm.currentState===RW_STATUS.READ
    val rd_cnt=ForLoopCounter(rd_valid&&(Fsm.currentState===RW_STATUS.READ),CHECK_DATA_NUM_WIDTH,io.Check_Data_Num-1+READ_HEAD_NUM)
    val Read_Done_Flag=Reg(Bool())init(False)
    val Rd_Delay_Cnt=Reg(UInt(10 bits))init(0)

    Fsm.read_done:=rd_cnt.valid
    val rdata_cahce=new xil_SimpleDualBram(8,9000,8,"NdFlash_Mem",false)
    rdata_cahce.io.addra:=rd_cnt.count.resized
    
    
    rdata_cahce.io.dina:=io.rd_data
    rdata_cahce.io.ena:=rd_valid
    rdata_cahce.io.wea:=True
    //check==================================================
        //将读进来的数据进行对比
    val Error_Cnt=Reg(UInt(32 bits))init(0)//错误次数统计
    val Error_Flag=Reg(Bool())init(False)
    when(io.start){
        Error_Cnt:=0
    }elsewhen(Error_Flag){
        Error_Cnt:=Error_Cnt+1
    }

    val ADDR_OFFSET1=WRITE_HEAD_NUM//这其实是一个地址偏移，用于将开头的那些地址，指令啥的乱七八糟的数据剔除
    val ADDR_OFFSET2=READ_HEAD_NUM
    val Check_Addr1=Reg(UInt(CHECK_DATA_NUM_WIDTH bits))init(ADDR_OFFSET1)
    val Check_Addr2=Reg(UInt(CHECK_DATA_NUM_WIDTH bits))init(ADDR_OFFSET2)

    when(Fsm.currentState===RW_STATUS.CHECK){
        Check_Addr1:=Check_Addr1+1
        Check_Addr2:=Check_Addr2+1
    }otherwise{
        if(ADDR_OFFSET1==0){
            Check_Addr1:=0
        }else{
            Check_Addr1:=ADDR_OFFSET1-1
        }
        if(ADDR_OFFSET2==0){
            Check_Addr2:=0
        }else{
            Check_Addr2:=ADDR_OFFSET2-1
        }
    }

    wdata_cahce.io.addrb:=Check_Addr1.resized
    rdata_cahce.io.addrb:=Check_Addr2.resized
    

    when(Fsm.currentState===RW_STATUS.CHECK){//如果读入的数据有效，那么将其与fifo pop出的数据进行对比
        when(wdata_cahce.io.doutb=/=rdata_cahce.io.doutb){
            Error_Flag:=True
        }
    }elsewhen(Fsm.clear_done){
        Error_Flag:=False
    }
    Fsm.check_done:=(Check_Addr1===io.Check_Data_Num-1)

    

    //=================================================
        //写一次读一次，需要统计可以写多少次，读多少次,每次都按页读按页写
    val update_page=Fsm.currentState===RW_STATUS.IS_LAST_TEST&&(Fsm.nextState===RW_STATUS.CLEAR)
    val Page_Cnt=ForLoopCounter(update_page,log2Up(128),128-1)
    val Block_Cnt=ForLoopCounter(Page_Cnt.valid,log2Up(2048),2048-1)
    val Plane_Cnt=ForLoopCounter(Block_Cnt.valid,1,2-1)
    val LUN_Cnt=ForLoopCounter(Plane_Cnt.valid,1,2-1)
    when(Fsm.currentState===RW_STATUS.IDLE){
        Page_Cnt.clear
        Block_Cnt.clear
        Plane_Cnt.clear
        LUN_Cnt.clear
    }

    val Check_Times_Cnt=Reg(UInt(CHECK_TIMES_WIDTH bits))init(0)
        //ForLoopCounter(,CHECK_TIMES_WIDTH,io.Check_Times-1)
    when(update_page){
        Check_Times_Cnt:=Check_Times_Cnt+1
    }elsewhen(io.start){
        Check_Times_Cnt:=0
    }
    Fsm.is_last_test:=Check_Times_Cnt===(io.Check_Times-1)
    Fsm.check_next_page:=io.Check_Next_Page_En


    val Wr_Addr=U"4'b0"@@LUN_Cnt.count@@(Block_Cnt.count)@@(Plane_Cnt.count@@Page_Cnt.count)
    // when(io.start){
    //     Wr_Addr:=io.Check_Start_Addr
    // }elsewhen(Fsm.nextState===RW_STATUS.IS_LAST_TEST){
    //     Wr_Addr:=Wr_Addr+4096//4096的地址步长（4k）
    // }
    io.Wr_Addr:=Wr_Addr

    io.done_flag:=Error_Flag


}

object TestGen extends App { 
    val verilog_path="src/main/scala/TestSpace/NandFlash" 
    // val test=new TopTest
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains =ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new NandFlash_Check(24,32))

    
}