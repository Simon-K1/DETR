package Systolic_Array.SystolicArray3D

//维度展平，将三维的脉动阵列输出转化为二维的矩阵输出
import spinal.core._
import spinal.lib.StreamFifo
class Flatten(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int) extends Component{
  val sData=new Bundle{
    val valid=in Vec(Bool(),HEIGHT)
    val payload=in Vec(Vec(UInt(ACCU_WITDH bits),SLICE),HEIGHT)//位宽好像有点大。。。
  }
  val Data_Cache=new Array[StreamFifo[Vec[UInt]]](SLICE)//传入数组的类型参数应该也是一个类型，而不是一个实例
  for(i<- 0 to SLICE-1){
    Data_Cache(i)=new StreamFifo(Vec(UInt(ACCU_WITDH bits),HEIGHT),16)
    // Data_Cache(i).io.
  }
    
    //第一步：先把脉动阵列过来的数据存起来
}