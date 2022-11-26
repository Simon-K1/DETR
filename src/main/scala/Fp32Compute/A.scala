package Fp32Compute

import spinal.core._

class U32_to_Fp32 extends BlackBox{
    val io=new Bundle{

    }
}

// class Lty_Bram extends BlackBox{//黑盒，入32bit，出16 bit
//     val Config=MemConfig()//浮点乘法器
//     val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
//         val clka=in Bool()
//         val addra=in UInt(log2Up(Config.LTY_DATA_BRAM_A_DEPTH) bits)
//         val dina=in UInt(Config.LTY_DATA_BRAM_A_WIDTH bits)
//         val ena=in Bool()
//         val wea=in Bool()

//         //B口读使能一直有效----后来发现还是给个读使能比较方便
//         val addrb=in UInt(log2Up(Config.LTY_DATA_BRAM_B_DEPTH) bits)
//         val clkb=in Bool()
//         val doutb=out UInt((Config.LTY_DATA_BRAM_B_WIDTH) bits)
//         // val enb=in Bool()        
//     }

//     noIoPrefix()
//     // Clock A is map on a specific clock Domain
//     mapClockDomain(this.clockDomain, io.clka)
//     // Clock B is map on the current clock domain
//     mapCurrentClockDomain(io.clkb)
// }