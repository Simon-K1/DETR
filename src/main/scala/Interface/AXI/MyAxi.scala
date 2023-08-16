package Interface.AXI
import spinal.core._
class MyAxi_Master extends Component{
        val ACLK=in Bool()
        val ARESTn=in Bool()
    // mapClockDomain(clockDomain,io.ACLK)
    // this.clockDomain.clock:=io.ACLK
    // this.clockDomain.reset:=io.rst
    val coreClockDomain=ClockDomain(ACLK,ARESTn)
    new ClockingArea(coreClockDomain){//如果需要用自己的时钟，需要用一层ClockingArea包起来。。。。
        

        val AW=new Bundle{
            //Address Write 通道
            val AWID_SIZE   =8
            val AWADDR_SIZE =32
            val AWLEN_SIZE  =8//突发传输长度    
            val AWSIZE_SIZE =3//一次可以传输的B数
            val AWBURST_SIZE    =8    
            val AWLOCK_SIZE =1
            val AWCACHE_SIZE    =8
            val AWPROT_SIZE =8
            val AWQOS_SIZE  =1
            val AWREGION_SIZE   =1
            val AWUSER_SIZE =8

            val ID          =out UInt()
            //所谓ID，说的是每个传输通道都有自己的的传输ID
            val ADDR        =out UInt(32 bits)
            val LEN         =out UInt(AWLEN_SIZE bits)
            val SIZE        =out UInt(AWSIZE_SIZE bits)
            val BURST       =out UInt(AWBURST_SIZE bits)
            val LOCK        =out UInt(AWLOCK_SIZE bits)
            val CACHE       =out UInt(AWCACHE_SIZE bits)
            val PROT        =out UInt(AWPROT_SIZE bits)
            val QOS         =out UInt(AWQOS_SIZE bits)
            val REGION      =out UInt(AWREGION_SIZE bits)
            val USER        =out UInt(AWUSER_SIZE bits)

            val READY       =in Bool()
            val VALID       =out Bool()


        }
    }
    
    
}

object ConvOutput extends App { //
    val verilog_path="./Simulation/MyAxi/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new MyAxi_Master)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_2D(8,8,32,false))//
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}