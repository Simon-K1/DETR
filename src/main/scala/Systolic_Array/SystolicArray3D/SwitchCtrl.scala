package Systolic_Array.SystolicArray3D

//用来控制switch
import spinal.core._
class SwitchCtrl extends Component{
    val io=new Bundle{
        val Data_Num=in UInt(32 bits)//发完这么多数据后switch到下一个
    }
}