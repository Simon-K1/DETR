package utils

import spinal.core._
class Axis_Switch extends Component{
        val io=new Bundle{
            val Switch=in UInt(1 bits)
        }
        noIoPrefix()
        val s0_axis_s2mm=new Bundle{//一个从接口，两个主接口
            val tdata=in UInt(32 bits)
            val tkeep=in UInt(4 bits)
            val tlast=in Bool()
            val tready=out Bool()
            val tvalid=in Bool()
        }
    val m0_axis_mm2s=new Bundle{
        val tdata=out UInt(32 bits)
        val tkeep=out UInt(4 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    val m1_axis_mm2s=new Bundle{
        val tdata=out UInt(32 bits)
        val tkeep=out UInt(4 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    m1_axis_mm2s.tkeep:=s0_axis_s2mm.tkeep
    m0_axis_mm2s.tkeep:=s0_axis_s2mm.tkeep
    when(io.Switch===0){//s口连接0号主接口
        s0_axis_s2mm.tready:=m0_axis_mm2s.tready

        m0_axis_mm2s.tdata:=s0_axis_s2mm.tdata
        m0_axis_mm2s.tlast:=s0_axis_s2mm.tlast
        m0_axis_mm2s.tvalid:=s0_axis_s2mm.tvalid

        m1_axis_mm2s.tdata:=0
        m1_axis_mm2s.tlast:=False
        m1_axis_mm2s.tvalid:=False
    }otherwise{
        m0_axis_mm2s.tdata:=0
        m0_axis_mm2s.tlast:=False
        m0_axis_mm2s.tvalid:=False

        s0_axis_s2mm.tready:=m1_axis_mm2s.tready

        m1_axis_mm2s.tdata:=s0_axis_s2mm.tdata
        m1_axis_mm2s.tlast:=s0_axis_s2mm.tlast
        m1_axis_mm2s.tvalid:=s0_axis_s2mm.tvalid
    }
    
}
//spinalhdl的总线接口自动连线测试
class Only_One_Master extends Component{
    val m1_axis_mm2s=new Bundle{
        val tdata=out UInt(32 bits)
        val tkeep=out UInt(4 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    m1_axis_mm2s.tdata:=0
    m1_axis_mm2s.tkeep:=0
    m1_axis_mm2s.tlast:=False
    m1_axis_mm2s.tvalid:=False
}
class Lined_Test extends Component{
    val Master_port=new Only_One_Master
    val Slave_Port=new Axis_Switch
    Slave_Port.s0_axis_s2mm<>Master_port.m1_axis_mm2s
}

case class Stream_Switch(Enum_Num:Int) extends SpinalEnum(defaultEncoding = binaryOneHot) {
    for(i<-0 to log2Up(Enum_Num)){
         val ChoseFlag = newElement
    }
}
class Axis_Switch_1s(Master_Port_Num:Int,Data_Width:Int) extends Component{
    val io=new Bundle{//一个s口多个m口
        val Switch=in UInt(2 bits)
    }
        noIoPrefix()
    val s0_axis_s2mm=new Bundle{//一个从接口，两个主接口
        val tdata=in UInt(Data_Width bits)
        val tkeep=in Bits(Data_Width/8 bits)
        val tlast=in Bool()
        val tready=out Bool()
        val tvalid=in Bool()
    }

    val m=Vec(new Bundle{        
        val axis_mm2s_tdata=out UInt(Data_Width bits)
        val axis_mm2s_tkeep=out Bits(Data_Width/8 bits)
        val axis_mm2s_tlast=out Bool()
        val axis_mm2s_tready=in Bool()
        val axis_mm2s_tvalid=out Bool()
        axis_mm2s_tkeep:=s0_axis_s2mm.tkeep
        },Master_Port_Num)
    s0_axis_s2mm.tready:=False
    for(i<-0 to Master_Port_Num-1){
        when(io.Switch===i){
            s0_axis_s2mm.tready:=m(i).axis_mm2s_tready
            m(i).axis_mm2s_tdata:=s0_axis_s2mm.tdata
            m(i).axis_mm2s_tlast:=s0_axis_s2mm.tlast
            m(i).axis_mm2s_tvalid:=s0_axis_s2mm.tvalid
        }otherwise{
            m(i).axis_mm2s_tdata:=0
            m(i).axis_mm2s_tlast:=False
            m(i).axis_mm2s_tvalid:=False
        }
    }
}

class Axis_Switch_2s(Slave_Port_Num:Int,Data_Width:Int) extends Component{
    val io=new Bundle{//多个s口一个m口
        val Switch=in Bits(log2Up(Slave_Port_Num) bits)
    }
    noIoPrefix()
    val m0_axis_mm2s=new Bundle{//一个主接口，多个从接口
        val tdata=out UInt(Data_Width bits)
        val tkeep=out Bits(Data_Width/8 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    val s=Vec(new Bundle{        
        val axis_s2mm_tdata=in UInt(Data_Width bits)
        val axis_s2mm_tkeep=in Bits(Data_Width/8 bits)
        val axis_s2mm_tlast=in Bool()
        val axis_s2mm_tready=out Bool()
        val axis_s2mm_tvalid=in Bool()
        axis_s2mm_tready:=False
    },Slave_Port_Num)//生成这么多个slave口，放左边
    m0_axis_mm2s.tdata:=0
    m0_axis_mm2s.tkeep:=0
    m0_axis_mm2s.tlast:=False
    m0_axis_mm2s.tvalid:=False
    for(i<-0 to Slave_Port_Num-1){
        when(io.Switch===i){
            s(i).axis_s2mm_tready:=m0_axis_mm2s.tready//出去的ready
            m0_axis_mm2s.tkeep:=s(i).axis_s2mm_tkeep
            m0_axis_mm2s.tdata:=s(i).axis_s2mm_tdata
            m0_axis_mm2s.tlast:=s(i).axis_s2mm_tlast
            m0_axis_mm2s.tvalid:=s(i).axis_s2mm_tvalid
        }
    }
}
object StreamSwitchGen extends App { 
    val verilog_path="./testcode_gen/MemGen" 
   SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_2s(3,64))
   SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Axis_Switch_1s(3,64))
  // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Lined_Test)
}