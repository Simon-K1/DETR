package Systolic_Array
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
class DataGen_Bram extends BlackBox{//黑盒，入32bit，出16 bit,Activation Bram，也就是SA左边挂的那块Bram
    val Config=TopConfig()
    val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
        val clka=in Bool()
        val addra=in UInt(log2Up(Config.DATA_GENERATE_BRAM_IN_ADDR_DEPTH) bits)
        val dina=in UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits)
        val ena=in Bool()
        val wea=in Bool()

        
        val addrb=in UInt(log2Up(Config.DATA_GENERATE_BRAM_OUT_ADDR_DEPTH) bits)
        val doutb=out UInt((Config.DATA_GENERATE_BRAM_OUT_WIDTH) bits)
        val clkb=in Bool()
        
        // val enb=in Bool()        
    }

    noIoPrefix()
    // Clock A is map on a specific clock Domain
    mapClockDomain(this.clockDomain, io.clka)
    // Clock B is map on the current clock domain
    mapCurrentClockDomain(io.clkb)
}
class Data_Generate extends Component{
    //数据生成模块,Bram的空间应该能
    val Config=TopConfig()
    val io=new Bundle{
        val sData=slave Stream(UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits))//进来的数据给到Bram

        //Conv相关
        val Stride=in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//
        val Kernel_Size=in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//输入的kernel_Size，如果是3*3的卷积，那么需要输入2
        val Out_Row_Cnt=in UInt(32 bits)
    }
    val DGB=new DataGen_Bram
    DGB.io.dina:=io.sData.payload
    DGB.io.addra:=0
    DGB.io.ena:=False
    DGB.io.wea:=True
    DGB.io.addrb:=0


    io.sData.ready:=False

    
    val Out_Row_Cnt=WaCounter(True,32,io.Out_Row_Cnt)
    val Kernel_Addr=WaCounter(True,log2Up(Config.PICTURE_SIZE-Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH-1),Config.PICTURE_SIZE-Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH-2,Stride=io.Stride)
    val Row_Read_Offset=UInt(log2Up(Config.PICTURE_SIZE-Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH-1) bits)
        //Kernel_Addr对应的是卷积滑动窗口top-left点的相对地址(注意是相对地址,后面读写时相对地址加上地址偏移就是绝对地址)
    val Window_Row=WaCounter(True,Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH,io.Kernel_Size)//io.kernel_Size
    val Window_Col=WaCounter(True,Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH,io.Kernel_Size)//io.kernel_Size
    
    val Raddr=WaCounter(True,log2Up(Config.PICTURE_SIZE-Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH-1)) Kernel_Addr.count+Row_Read_Offset

}   
object DGB_Gen extends App { 
    val verilog_path="./testcode_gen/Systolic_Array" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Data_Generate)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}