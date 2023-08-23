package Interface.AXI

import spinal.core._
object M_AXI_STATUS extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT_WRITE,INIT_READ,INIT_COMPARE = newElement
}
case class M_AXI_FSM(start:Bool)extends Area{
    val currentState = Reg(M_AXI_STATUS()) init M_AXI_STATUS.IDLE
    val nextState = M_AXI_STATUS()
    currentState := nextState
	val writes_done=Bool()
	val reads_done=Bool()
	switch(currentState){
		is(M_AXI_STATUS.IDLE){
			when(start){
				nextState:=M_AXI_STATUS.INIT_WRITE
			}otherwise{
				nextState:=M_AXI_STATUS.INIT_READ
			}
		}
		is(M_AXI_STATUS.INIT_WRITE){
			when(writes_done){
				nextState:=M_AXI_STATUS.INIT_READ
			}otherwise{
				nextState:=M_AXI_STATUS.INIT_WRITE
			}
		}
		is(M_AXI_STATUS.INIT_READ){
			when(reads_done){
				nextState:=M_AXI_STATUS.INIT_COMPARE
			}otherwise{
				nextState:=M_AXI_STATUS.INIT_READ
			}
		}
		is(M_AXI_STATUS.INIT_COMPARE){
			nextState:=M_AXI_STATUS.IDLE
		}
	}
}
case class Axi_Interface() extends Bundle{
    // Users to add parameters here
    // User parameters ends
    // Do not modify the parameters beyond this line
    // Base address of targeted slave
    //val C_M_TARGET_SLAVE_BASE_ADDR	= U"32'h40000000"
    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    val C_M_AXI_BURST_LEN	= 16
    // Thread ID Width
    val C_M_AXI_ID_WIDTH	= 1
    // Width of Address Bus
    val C_M_AXI_ADDR_WIDTH	= 32
    // Width of Data Bus
    val C_M_AXI_DATA_WIDTH	= 32
    // Width of User Write Address Bus
    val C_M_AXI_AWUSER_WIDTH	= 0
    // Width of User Read Address Bus
    val C_M_AXI_ARUSER_WIDTH	= 0
    // Width of User Write Data Bus
    val C_M_AXI_WUSER_WIDTH	= 0
    // Width of User Read Data Bus
    val C_M_AXI_RUSER_WIDTH	= 0
    // Width of User Response Bus
    val C_M_AXI_BUSER_WIDTH	= 0

	val  INIT_AXI_TXN =in Bool()
	// Asserts when transaction is complete
	// val  TXN_DONE       =out Bool()
	// Asserts when ERROR is detected
	// val  ERROR          =out Bool()
	// Master Interface Write Address ID
	val M_AXI_AWID		=out UInt(C_M_AXI_ID_WIDTH bits)
	// Master Interface Write Address
	val M_AXI_AWADDR	=out UInt(C_M_AXI_ADDR_WIDTH bits)
	// Burst length. The burst length gives the exact number of transfers in a burst
	val M_AXI_AWLEN		=out UInt(8 bits)
	// Burst size. This signal indicates the size of each transfer in the burst
	val M_AXI_AWSIZE	=out UInt(3 bits)//[2 : 0] ,
	// Burst type. The burst type and the size information, 
// determine how the address for each transfer within the burst is calculated.
	val M_AXI_AWBURST	=out UInt(2 bits)//[1 : 0] ,
	// Lock type. Provides additional information about the
// atomic characteristics of the transfer.
	val M_AXI_AWLOCK	=out  Bool()//,
	// Memory type. This signal indicates how transactions
// are required to progress through a system.
	val M_AXI_AWCACHE	=out UInt(4 bits)//[3 : 0] ,
	// Protection type. This signal indicates the privilege
// and security level of the transaction, and whether
// the transaction is a data access or an instruction access.
	val M_AXI_AWPROT	=out UInt(3 bits)//[2 : 0] ,
	// Quality of Service, QoS identifier sent for each write transaction.
	val M_AXI_AWQOS		=out UInt(4 bits)//[3 : 0] ,
	// Optional User-defined signal in the write address channel.
	val M_AXI_AWUSER	=out UInt(C_M_AXI_AWUSER_WIDTH bits)//[C_M_AXI_AWUSER_WIDTH-1 : 0] ,
	// Write address valid. This signal indicates that
// the channel is signaling valid write address and control information.
	val M_AXI_AWVALID	=out  Bool()//,
	// Write address ready. This signal indicates that
// the slave is ready to accept an address and associated control signals
	val  M_AXI_AWREADY	=in Bool()//,
// 	// Master Interface Write Data.
// 	val M_AXI_WDATA		=out UInt(C_M_AXI_DATA_WIDTH bits)//[C_M_AXI_DATA_WIDTH-1 : 0] ,
// 	// Write strobes. This signal indicates which byte
// // lanes hold valid data. There is one write strobe
// // bit for each eight bits of the write data bus.
// 	val M_AXI_WSTRB		=out UInt(C_M_AXI_DATA_WIDTH/8 bits)//[C_M_AXI_DATA_WIDTH/8-1 : 0],
// 	// Write last. This signal indicates the last transfer in a write burst.
// 	val M_AXI_WLAST		=out  Bool()//,
// 	// Optional User-defined signal in the write data channel.
// 	val M_AXI_WUSER		=out UInt(C_M_AXI_WUSER_WIDTH bits)//[C_M_AXI_WUSER_WIDTH-1 : 0] ,
// 	// Write valid. This signal indicates that valid write
// // data and strobes are available
// 	val M_AXI_WVALID	=out  Bool()//,
// 	// Write ready. This signal indicates that the slave
// // can accept the write data.
// 	val M_AXI_WREADY=in  Bool()//,
// 	// Master Interface Write Response.
// 	val M_AXI_BID=in UInt(C_M_AXI_ID_WIDTH bits)//[C_M_AXI_ID_WIDTH-1 : 0] //,
// 	// Write response. This signal indicates the status of the write transaction.
// 	val M_AXI_BRESP=in UInt(2 bits)//[1 : 0] ,
// 	// Optional User-defined signal in the write response channel
// 	val M_AXI_BUSER=in UInt(C_M_AXI_BUSER_WIDTH bits)//[C_M_AXI_BUSER_WIDTH-1 : 0] ,
// 	// Write response valid. This signal indicates that the
// // channel is signaling a valid write response.
// 	val M_AXI_BVALID=in  Bool()//,
// 	// Response ready. This signal indicates that the master
// // can accept a write response.
// 	val M_AXI_BREADY=out  Bool()//,
// 	// Master Interface Read Address.
// 	val M_AXI_ARID=out UInt(C_M_AXI_ID_WIDTH bits)//[C_M_AXI_ID_WIDTH-1 : 0] ,
// 	// Read address. This signal indicates the initial
// // address of a read burst transaction.
// 	val M_AXI_ARADDR=out UInt(C_M_AXI_ADDR_WIDTH bits)//[C_M_AXI_ADDR_WIDTH-1 : 0] ,
// 	// Burst length. The burst length gives the exact number of transfers in a burst
// 	val M_AXI_ARLEN=out UInt(8 bits)//[7 : 0] ,
// 	// Burst size. This signal indicates the size of each transfer in the burst
// 	val M_AXI_ARSIZE=out UInt(3 bits)//[2 : 0] ,
// 	// Burst type. The burst type and the size information, 
// // determine how the address for each transfer within the burst is calculated.
// 	val M_AXI_ARBURST=out UInt(2 bits)//[1 : 0] ,
// 	// Lock type. Provides additional information about the
// // atomic characteristics of the transfer.
// 	val M_AXI_ARLOCK=out  Bool()
// 	// Memory type. This signal indicates how transactions
// // are required to progress through a system.
// 	val M_AXI_ARCACHE=out UInt(4 bits)//[3 : 0] ,
// 	// Protection type. This signal indicates the privilege
// // and security level of the transaction, and whether
// // the transaction is a data access or an instruction access.
// 	val M_AXI_ARPROT=out UInt(3 bits)//[2 : 0] ,
// 	// Quality of Service, QoS identifier sent for each read transaction
// 	val M_AXI_ARQOS=out UInt(4 bits)//[3 : 0] ,
// 	// Optional User-defined signal in the read address channel.
// 	val M_AXI_ARUSER=out UInt(C_M_AXI_ARUSER_WIDTH bits)//[C_M_AXI_ARUSER_WIDTH-1 : 0] ,
// 	// Write address valid. This signal indicates that
// // the channel is signaling valid read address and control information
// 	val M_AXI_ARVALID=out  Bool()
// 	// Read address ready. This signal indicates that
// // the slave is ready to accept an address and associated control signals
// 	val M_AXI_ARREADY=in  Bool()//,
// 	// Read ID tag. This signal is the identification tag
// // for the read data group of signals generated by the slave.
// 	val M_AXI_RID=in UInt(C_M_AXI_ID_WIDTH bits)//[C_M_AXI_ID_WIDTH-1 : 0] ,
// 	// Master Read Data
// 	val M_AXI_RDATA=in UInt(C_M_AXI_DATA_WIDTH bits)//[C_M_AXI_DATA_WIDTH-1 : 0] ,
// 	// Read response. This signal indicates the status of the read transfer
// 	val M_AXI_RRESP=in UInt(2 bits)//[1 : 0] ,
// 	// Read last. This signal indicates the last transfer in a read burst
// 	val M_AXI_RLAST=in  Bool()//,
// 	// Optional User-defined signal in the read address channel.
// 	val M_AXI_RUSER=in UInt(C_M_AXI_RUSER_WIDTH bits)//[C_M_AXI_RUSER_WIDTH-1 : 0] ,
// 	// Read valid. This signal indicates that the channel
// // is signaling the required read data.
// 	val M_AXI_RVALID=in  Bool()//,
// 	// Read ready. This signal indicates that the master can
// // accept the read data and response information.
// 	val M_AXI_RREADY=out  Bool()
}