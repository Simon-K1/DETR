package Systolic_Array.SystolicArray3D

//维度展平，将三维的脉动阵列输出转化为二维的矩阵输出
import spinal.core._
import spinal.lib.StreamFifo
import utils.AxisDataConverter
import spinal.lib.slave
import spinal.lib.master

class Flatten(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int,FIFO_DEPTH:Int=64) extends Component{
  val sData=new Bundle{//数据输入
    val valid=in Vec(Bool(),HEIGHT)
    val payload=in Vec(Vec(UInt(ACCU_WITDH bits),SLICE),HEIGHT)//位宽好像有点大。。。
    //payload(i)(j):第i行的第j个slice的输出
  }
  val mData= Vec(master Stream(UInt(ACCU_WITDH bits)),HEIGHT)


  val Data_Cache=new Array[StreamFifo[UInt]](HEIGHT)//传入数组的类型参数应该也是一个类型，而不是一个实例
  val Data_Converter=new Array[AxisDataConverter](HEIGHT)
//如果只有1个SLICE,就没必要加FIFO和WIDTH Converter,直接输入连输出就行了
  if(SLICE==1){
    for(i<-0 to HEIGHT-1){
        mData(i).payload:=sData.payload(i)(0)
        mData(i).valid:=sData.valid(i)
    }
  }else{
    for(i<- 0 to HEIGHT-1){//遍历行（脉动阵列的输出，从上往下）
        Data_Cache(i)=new StreamFifo(UInt(ACCU_WITDH*SLICE bits),FIFO_DEPTH)//FIFO的深度默认为64
        Data_Converter(i)=new AxisDataConverter(SLICE*ACCU_WITDH,ACCU_WITDH)

        for(j<-0 to SLICE-1){//遍历SLICE，
            Data_Cache(i).io.push.payload((j+1)*ACCU_WITDH-1 downto j*ACCU_WITDH):=sData.payload(i)(j)
        }
        Data_Cache(i).io.push.valid:=sData.valid(i)
        Data_Converter(i).inStream<>Data_Cache(i).io.pop
        Data_Converter(i).outStream<>mData(i)
    }
  }

}
object Flatten_Gene extends  App{
    val verilog_path="./verilog/SA_3D/verilog" 
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Flatten(8,8,8,32))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Flatten(2,8,8,32))
}