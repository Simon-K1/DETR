package Interface.AXI
import spinal.core._
// class MyAxi_Master extends Component{
//         val ACLK=in Bool()
//         val ARESTn=in Bool()
//     // mapClockDomain(clockDomain,io.ACLK)
//     // this.clockDomain.clock:=io.ACLK
//     // this.clockDomain.reset:=io.rst
//     val coreClockDomain=ClockDomain(ACLK,ARESTn)
//     new ClockingArea(coreClockDomain){//如果需要用自己的时钟，需要用一层ClockingArea包起来。。。。
//         val AW=new Bundle{
//             //Address Write 通道
//             val AWID_SIZE   =8
//             val AWADDR_SIZE =32
//             val AWLEN_SIZE  =8//突发传输长度    
//             val AWSIZE_SIZE =3//一次可以传输的B数
//             val AWBURST_SIZE    =8    
//             val AWLOCK_SIZE =1
//             val AWCACHE_SIZE    =8
//             val AWPROT_SIZE =8
//             val AWQOS_SIZE  =1
//             val AWREGION_SIZE   =1
//             val AWUSER_SIZE =8

//             val ID          =out UInt()
//             //所谓ID，说的是每个传输通道都有自己的的传输ID
//             val ADDR        =out UInt(32 bits)
//             val LEN         =out UInt(AWLEN_SIZE bits)
//             val SIZE        =out UInt(AWSIZE_SIZE bits)
//             val BURST       =out UInt(AWBURST_SIZE bits)
//             val LOCK        =out UInt(AWLOCK_SIZE bits)
//             val CACHE       =out UInt(AWCACHE_SIZE bits)
//             val PROT        =out UInt(AWPROT_SIZE bits)
//             val QOS         =out UInt(AWQOS_SIZE bits)
//             val REGION      =out UInt(AWREGION_SIZE bits)
//             val USER        =out UInt(AWUSER_SIZE bits)

//             val READY       =in Bool()
//             val VALID       =out Bool()


//         }
//     }
// }
class MyAxi_Master extends Component{
    
    val M_AXI_ACLK=in Bool()
    val M_AXI_ARESETN=in Bool()
    val coreClockDomain=ClockDomain(M_AXI_ACLK,M_AXI_ARESETN)
    new ClockingArea(coreClockDomain){//如果需要用自己的时钟，需要用
		val  INIT_AXI_TXNin =in Bool()
		// Asserts when transaction is complete
		val  TXN_DONE       =out Bool()
		// Asserts when ERROR is detected
		val  ERROR          =out Bool()

		// Master Interface Write Address ID
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
		// Master Interface Write Address
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_AWBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each write transaction.
		output wire [3 : 0] M_AXI_AWQOS,
		// Optional User-defined signal in the write address channel.
		output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
		output wire  M_AXI_AWVALID,
		// Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_AWREADY,
		// Master Interface Write Data.
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		// Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		// Write last. This signal indicates the last transfer in a write burst.
		output wire  M_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
		// Write valid. This signal indicates that valid write
    // data and strobes are available
		output wire  M_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    // can accept the write data.
		input wire  M_AXI_WREADY,
		// Master Interface Write Response.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
		// Write response. This signal indicates the status of the write transaction.
		input wire [1 : 0] M_AXI_BRESP,
		// Optional User-defined signal in the write response channel
		input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
		// Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master
    // can accept a write response.
		output wire  M_AXI_BREADY,
		// Master Interface Read Address.
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
		// Read address. This signal indicates the initial
    // address of a read burst transaction.
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_ARBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each read transaction
		output wire [3 : 0] M_AXI_ARQOS,
		// Optional User-defined signal in the read address channel.
		output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
		output wire  M_AXI_ARVALID,
		// Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
		// Master Read Data
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer
		input wire [1 : 0] M_AXI_RRESP,
		// Read last. This signal indicates the last transfer in a read burst
		input wire  M_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
		// Read valid. This signal indicates that the channel
    // is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    // accept the read data and response information.
		output wire  M_AXI_RREADY
    
    
    }

}
class AA extends  Component{
    val AA=in UInt(0 bits)//0bit的会直接优化掉
    val BB=in UInt(1 bits)
}




object ConvOutput extends App { //
    val verilog_path="./Simulation/MyAxi/verilog" 
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new MyAxi_Master)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new AA)

}