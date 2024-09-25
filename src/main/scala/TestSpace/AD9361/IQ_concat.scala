package TestSpace.AD9361

import spinal.core._

//AD9361设置未single port dual duplex cmos模式
//将ddr转出来的数据进行concat成12bit
class IQ_concat extends  Component{
    val io=new Bundle{
        val I_6bit=in Bits(6 bits)
        val Q_6bit=in Bits(6 bits)
        val Rx_Frame=in Bool()
        val I_12bit=out Bits(12 bits)
        val Q_12bit=out Bits(12 bits)
    }
    noIoPrefix()
    //在时钟上升沿根据Rx_Fram对MSB和LSB进行判断
    val I_Msb=RegNextWhen(io.I_6bit,io.Rx_Frame)init(0)
    val Q_Msb=RegNextWhen(io.Q_6bit,io.Rx_Frame)init(0)
    val I_Lsb=io.I_6bit//RegNextWhen(io.I_6bit,~io.Rx_Frame)init(0)
    val Q_Lsb=io.Q_6bit//RegNextWhen(io.Q_6bit,~io.Rx_Frame)init(0)  
    //val Flag=RegNext(io.Rx_Frame)//  Flag为1，则是Msb，Flab为0则是Lsb
    io.I_12bit:=RegNextWhen((I_Msb##I_Lsb),RegNext(io.Rx_Frame))
    io.Q_12bit:=RegNextWhen((Q_Msb##Q_Lsb),RegNext(io.Rx_Frame))



}