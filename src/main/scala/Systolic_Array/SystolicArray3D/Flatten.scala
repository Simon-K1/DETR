package Systolic_Array.SystolicArray3D

//维度展平，将三维的脉动阵列输出转化为二维的矩阵输出
import spinal.core._
import spinal.lib.StreamFifo
import utils.AxisDataConverter
import spinal.lib.slave
import spinal.lib.master
import xip.xil_ila
//2023、12、9 Flatten模块存在的一个bug：当inChannel<SLICE*WIDTH时，也就是存在一些脉动阵列的列没被使用，这样会导致WidthConverter最后会有残留无效数据
  //初步解决办法：每次重新计算时，flush一下fifo
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
        Data_Cache(i).setDefinitionName("Flatten_Fifo")
        Data_Converter(i)=new AxisDataConverter(SLICE*ACCU_WITDH,ACCU_WITDH)

        for(j<-0 to SLICE-1){//遍历SLICE，
            Data_Cache(i).io.push.payload((j+1)*ACCU_WITDH-1 downto j*ACCU_WITDH):=sData.payload(i)(j)
        }
        Data_Cache(i).io.push.valid:=sData.valid(i)
        Data_Converter(i).inStream<>Data_Cache(i).io.pop
        Data_Converter(i).outStream<>mData(i)
    }
  }

  val Debug_Signals=Array[Bits](
      mData(0).payload.asBits,
      mData(1).payload.asBits,
      mData(2).payload.asBits,
      mData(3).payload.asBits,
      mData(4).payload.asBits,
      mData(5).payload.asBits,
      mData(6).payload.asBits,
      mData(7).payload.asBits,
      mData(0).valid.asBits,
      mData(1).valid.asBits,
      mData(2).valid.asBits,
      mData(3).valid.asBits,
      mData(4).valid.asBits,
      mData(5).valid.asBits,
      mData(6).valid.asBits,
      mData(7).valid.asBits
    )
    val Debug_Name=Array[String](
      "mData_payload0",
      "mData_payload1",
      "mData_payload2",
      "mData_payload3",
      "mData_payload4",
      "mData_payload5",
      "mData_payload6",
      "mData_payload7",
      "mData_valid0",
      "mData_valid1",
      "mData_valid2",
      "mData_valid3",
      "mData_valid4",
      "mData_valid5",
      "mData_valid6",
      "mData_valid7"
    )
    val ila=new xil_ila(Debug_Signals,true,"ila_Flatten")
    for(i<-0 to Debug_Signals.length-1){
      ila.probe(i):=Debug_Signals(i)
      Debug_Signals(i).setName(Debug_Name(i))
    }
}
object Flatten_Gene extends  App{
    val verilog_path="./verilog/SA_3D/verilog" 
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Flatten(8,8,8,32))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Flatten(2,8,8,32))
}