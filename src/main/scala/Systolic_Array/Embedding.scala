package Systolic_Array
//Embedding layer模块，用来做picture patch，第一个卷积层，暂时考虑的是1入8出
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
object PATCH_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_FIRST_KROW,SEND_KROW,PING_PONG_READY= newElement
    //LOAD_FIRTS_KROW:加载前K行的数据（K对应卷积核大小)
    //SEND_KROW:发送K行数据，一下出K个点给到下层脉动阵列中
    //PING_PONG_READY：在发送K行数据进行计算的时候顺便缓存下一批的K行数据（这个模块能被复用吗？)
}
class Patch_Bram extends BlackBox{//黑盒，入32bit，出16 bit
    val Config=TopConfig()//浮点乘法器
    val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
        val clka=in Bool()
        val addra=in UInt(log2Up(Config.PATCH_BRAM_IN_DEPTH) bits)
        val dina=in UInt(Config.PATCH_BRAM_IN_WIDTH bits)
        val ena=in Bool()
        val wea=in Bool()

        
        val addrb=in UInt(log2Up(Config.PATCH_BRAM_OUT_DEPTH) bits)
        val clkb=in Bool()
        val doutb=out UInt((Config.PATCH_BRAM_OUT_WIDTH) bits)
        // val enb=in Bool()        
    }

    noIoPrefix()
    // Clock A is map on a specific clock Domain
    mapClockDomain(this.clockDomain, io.clka)
    // Clock B is map on the current clock domain
    mapCurrentClockDomain(io.clkb)
}

class Picture_Cache extends Component{
    //数据缓存模块，用来缓存16行的数据
    //初步设想：乒乓操作，可配置，为以后的4*4的swin-transformer做准备
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()//启动信号

        val sData=slave Stream(UInt(64 bits))//stream流输入8bit图片数据
    }
    val In_Col_Cnt=WaCounter(io.sData.fire,log2Up(Config.PATCH_BRAM_IN_DEPTH),Config.PATCH_BRAM_IN_DEPTH-1)//列计数器
    val In_Row_Cnt=WaCounter(In_Col_Cnt.valid,log2Up(Config.PICTURE_SIZE),Config.PICTURE_SIZE-1)//行计数器
    
    //构建X个行缓存，但是这样的话资源消耗太浪费了，应该把Bram留给Weight用
    val Row_Cache0=Array.tabulate(Config.PATCH_SIZE)(i=>{
        def gen():Patch_Bram={
            val Row_Cache0=new Patch_Bram
            Row_Cache0.io.dina:=io.sData.payload//写数据
            Row_Cache0.io.ena:=(In_Col_Cnt.count(log2Up(Config.PATCH_SIZE)-1 downto 0)===i)//写使能
            Row_Cache0.io.addra:=In_Col_Cnt.count.resized//写地址
            Row_Cache0.io.wea:=True

            Row_Cache0.io.addrb:=0
            Row_Cache0
        }
        gen()
    })
    io.sData.ready:=True
    noIoPrefix()
    println("PATCH_BRAM_IN_DEPTH:",Config.PATCH_BRAM_IN_DEPTH)
    println("PATCH_BRAM_OUT_DEPTH:",Config.PATCH_BRAM_OUT_DEPTH)
}

object Sum_Xq_Gen extends App { 
    val verilog_path="./testcode_gen/Systolic_Array" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Picture_Cache)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}