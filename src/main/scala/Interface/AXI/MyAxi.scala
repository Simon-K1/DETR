package Interface.AXI
import spinal.core._
import spinal.lib.Delay
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
	val C_M_TARGET_SLAVE_BASE_ADDR	= U"32'h40000000"
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

	val C_MASTER_LENGTH=12
	//由于有4K地址边界限制，4K=1111_1111_1111=4095
	//需要考虑一个突发传输消耗掉的地址数量就是burst_size*burst_length(这里就是16*8=128)
	//那么为了不跨越4K边界，最多可以连续突发传输多少次呢：4096/128--->12-6(数据位宽)

	val C_NO_BURSTS_REQ=C_MASTER_LENGTH-log2Up((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1);//一般burstsize=总线数据位宽
	print("%d======",C_NO_BURSTS_REQ)
	val io=Axi_Interface()

	val axi_bready=Reg(Bool())init(False)
	val axi_awvalid=Reg(Bool())init(False)
	io.M_AXI_BREADY:=axi_bready

	val init_txn_ff=Reg(Bool())init(False)
	val init_txn_ff2=Reg(Bool())init(False)
	init_txn_ff:=io.INIT_AXI_TXN
	val init_txn_pulse=init_txn_ff&&(RegNext(!init_txn_ff))//上升沿检测
	val Fsm=M_AXI_FSM(init_txn_pulse)
	val write_burst_counter=Reg(UInt(C_NO_BURSTS_REQ bits))init(0)
	//状态机里的写完成标志,用于状态跳转到Read状态
	//The writes_done should be associated with a bready response
	when(init_txn_pulse){
		Fsm.writes_done:=False
	}elsewhen(io.M_AXI_BVALID&& (write_burst_counter(C_NO_BURSTS_REQ-1) && axi_bready)){
		Fsm.writes_done:=True
	}otherwise{
		Fsm.writes_done:=Fsm.writes_done
	}

	//write_burst_counter，还不太明白这个write_burst_counter是干啥的？
	when(init_txn_pulse){
		write_burst_counter:=0//启动的时候，重置为0
	}elsewhen(io.M_AXI_AWREADY && axi_awvalid){//当成功写入一个地址后
		when(~write_burst_counter(C_NO_BURSTS_REQ-1)){//只要还没数满，那就一直数
			write_burst_counter:=write_burst_counter+1
		}otherwise{
			write_burst_counter:=write_burst_counter//数满了，就停下来
		}
	}
	
//===================================写地址通道=============================================================
	//地址通道没有过多的传输，每个burst发一个首地址即可
	//awaddr
	//awvalid
	//awready
	//bready
	//bvalid

	io.M_AXI_AWID:=0//将AWID设置为0
	val axi_awaddr=Reg(UInt(C_M_AXI_ADDR_WIDTH bits))init(0)//写地址
	val burst_size_bytes=U(C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8)//burst_size:一次突发传输的字节数=总线数据位宽
	
	//awaddr控制===============================================================
	when(init_txn_pulse){//awaddr控制
		axi_awaddr:=0//每次传输都是从0开始
	}elsewhen(io.M_AXI_AWREADY&&axi_awvalid){
		axi_awaddr:=axi_awaddr+burst_size_bytes//每次增加的地址与突发长度和数据位宽有关
		//这里的突发长度为16，数据位宽为64bit=8B，那么一次突发传输能发16*8=128B的数据，从机拿到起始地址0，然后再自己计算剩下的地址
		//【注意】只有完成一次完整的突发传输后，从机才能再取一次写地址,
		//也可以看下面的awvalid的控制，可以看出，每次突发传输也只会发一次写地址
	}otherwise{//TODO,这里需要这句话嘛？
		axi_awaddr:=axi_awaddr//所有条件都不满足就保持不变即可，其实这个otherwise语句可以不写
	}
	//awvalid控制===============================================================
	val start_single_burst_write=Reg(Bool())init(False)//这玩意的控制还挺麻烦
	val burst_write_active		=Reg(Bool())init(False)
	//burst_write_active的作用就是用来标记当前是否处于传输状态
	when(init_txn_pulse){
		burst_write_active:=False
	}elsewhen(start_single_burst_write){//当一次突发传输被启动后，burst_write_active就拉高
		burst_write_active:=True
	}elsewhen(io.M_AXI_BVALID && axi_bready){//写传输的response，当从机给了个反馈，burst_write_active即可拉低
		burst_write_active:=False
	}

	when(Fsm.currentState===M_AXI_STATUS.INIT_WRITE){
		when(~axi_awvalid && ~start_single_burst_write && (~burst_write_active)){
			//如果当前状态处于INIT_WIRTE，并且axi_awvalid没拉高
			start_single_burst_write:=True//则启动一次突发写传输
		}otherwise{//当写地址被发过去后，axi_awvalid就会拉低
			start_single_burst_write:=False
		}
	}
	when(init_txn_pulse){
		axi_awvalid:=False//
	}elsewhen(!axi_awvalid&&start_single_burst_write){
		axi_awvalid:=True//当axi_awvalid无效时并且开始新一轮传输时，说明这时的写地址是有效的
	}elsewhen(axi_awvalid&&io.M_AXI_AWREADY){
		axi_awvalid:=False//当写地址发过去后，拉低，因为只要发一次写地址即可，剩下的就是让从机自己去算了
	}otherwise{
		axi_awvalid:=axi_awvalid
	}

	//开始控制axi_bready
	when(init_txn_pulse){
		
	}


	
	io.M_AXI_AWADDR		:=C_M_TARGET_SLAVE_BASE_ADDR+axi_awaddr
	io.M_AXI_AWLEN		:=C_M_AXI_BURST_LEN-1
	io.M_AXI_AWSIZE		:=log2Up((C_M_AXI_DATA_WIDTH/8)-1)
	io.M_AXI_AWBURST	:=U"2'b01"
	io.M_AXI_AWLOCK		:=False
	io.M_AXI_AWCACHE	:=U"4'b0010"
	io.M_AXI_AWPROT		:=U"3'b0"
	io.M_AXI_AWQOS		:=U("4'b0")//U"4'b0"
	io.M_AXI_AWUSER		:=U(s"${C_M_AXI_AWUSER_WIDTH}'b0")
	
	io.M_AXI_AWVALID	:=axi_awvalid

	

}

class AA extends  Component{
    val AA=in UInt(0 bits)//0bit的会直接优化掉
    val BB=in UInt(1 bits)
}

object ConvOutput extends App { //
    val verilog_path="./verilog/MyAxi/" 
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new MyAxi_Master)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new MyAxi_Master)

}