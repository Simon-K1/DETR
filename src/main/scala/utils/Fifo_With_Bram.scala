package utils
//一个自定义的fifo
import spinal.core._
class Fifo_With_Bram(inwidth:Int=8,indepth:Int=8,outwidth:Int=8,componentName: String,genTcl:Boolean) extends Component{
    val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
        val clka=in Bool()
        val addra=in UInt(log2Up(indepth) bits)
        val dina=in UInt(inwidth bits)
        val ena=in Bool()
        val wea=in Bool()
        val outdepth=(inwidth*indepth)/outwidth
        val addrb=in UInt(log2Up(outdepth) bits)
        val doutb=out UInt(outwidth bits)
        val clkb=in Bool()
        // val enb=in Bool()        
    }



}