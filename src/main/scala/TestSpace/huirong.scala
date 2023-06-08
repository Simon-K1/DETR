package TestSpace

import spinal.core._
import utils.ForLoopCounter
class hrgk extends Component{
    val io=new Bundle{
        val start=in Bool()
        val End=out Bool()
    }
    val SpinalOut=new Bundle{
        val TX=out Bool()
        val SW=out Bool()
        val DS=out Bool()
        val AD=out Bool()
    }

}