package Systolic_Array.SystolicArray3D
import spinal.core._
import utils.ForLoopCounter
import spinal.lib.Delay


class dsp_marco(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int) extends BlackBox {
  val io = new Bundle{
    val CLK = in Bool()
    val A = in SInt(A_WIDTH bits)
    val B = in SInt(B_WIDTH bits)
    val P =out SInt(OUT_WIDTH bits)
    
}
noIoPrefix()
mapClockDomain(clock=io.CLK)
}
class PE(A_WIDTH: Int, B_WIDTH: Int,OUT_WIDTH:Int) extends Component{
  val io = new Bundle{
    val activate = in SInt(A_WIDTH bits)
    val weight = in SInt(B_WIDTH bits)
    val valid = in Bool()//数据有效的信号
    val signCount = in UInt(16 bits)  //卷积核16*16  signCoun就是t256
    val acount = out SInt(A_WIDTH bits)
    val bcount = out SInt(B_WIDTH bits)
    val PE_OUT = out SInt(OUT_WIDTH bits)
    val finish =  out Bool ()
  }
  noIoPrefix()
  val reg1 = Reg(SInt(OUT_WIDTH bits)) init(0)
  val dsp = new dsp_marco(8,8,16)

  val finishCnt = ForLoopCounter(RegNext(RegNext(io.valid)),16,io.signCount)//signCount是否需要做一下寄存？
  io.finish:=finishCnt.valid
  io.PE_OUT:=0
  when(finishCnt.valid){
    io.PE_OUT:=reg1
    reg1:=io.valid?(dsp.io.P.resized)|S(0,OUT_WIDTH bits)    //U(0,4 bits)@@(dsp.io.P)
  }elsewhen(RegNext(io.valid)){//这里dsp计算延时为1，todo：可能存在一个雷
    reg1:=dsp.io.P+reg1
  }
  io.activate <> dsp.io.A   //根据valid将dsp输入改变
  io.weight <> dsp.io.B
  io.acount <> RegNext(io.activate)
  io.bcount <> RegNext(io.weight)
}



class SA_2D(HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int,CVALID:Boolean) extends Component{//给定宽和高构建一个2维脉动阵列
  val io=new Bundle{
      val MatrixA=in Vec(SInt(8 bits),HEIGHT)
      val MatrixB=in Vec(SInt(8 bits),WIDTH)
      val A_Valid=in Vec(Bool(),HEIGHT)
      val B_Valid=in Vec(Bool(),WIDTH)//数据有效标记
      //val Matrix_C=out Vec(SInt(ACCU_WITDH bits),HEIGHT)//累加和应该至少是20bits，可以配置为32bit
      val signCount=in UInt(16 bits)

  }
  
    val MatrixC=out Vec(SInt(ACCU_WITDH bits),HEIGHT)//输出的矩阵C
    val C_Valid =   (CVALID) generate(out Vec(Bool(),HEIGHT))



    val PEArry = Array.ofDim[PE](HEIGHT, WIDTH)
    
    val start   =in Bool()
    for(row<-0 to HEIGHT-1){
        for(col<- 0 to WIDTH-1){
            PEArry(row)(col)=new PE(8,8,ACCU_WITDH)
            PEArry(row)(col).setName("PE"+row.toString+col.toString)
        }
    }

    
    // for (i<-0 to WIDTH-1){
    //   val tmp=Bits(WIDTH bits)
    //   MatrixC(i):=0
    //   for(j<-0 to HEIGHT-1){
    //     tmp(j):=PEArry(i)(j).io.finish
    //     when(PEArry(i)(j).io.finish){
    //       MatrixC(i):=PEArry(i)(j).io.PE_OUT
    //     }
    //   }
    //   if(CVALID){
    //     C_Valid(i):=tmp.orR
    //   }
    // }
    for (i<-0 to HEIGHT-1){
      val tmp=Bits(WIDTH bits)
      MatrixC(i):=0
      for(j<-0 to WIDTH-1){
        tmp(j):=PEArry(i)(j).io.finish
        when(PEArry(i)(j).io.finish){
          MatrixC(i):=PEArry(i)(j).io.PE_OUT
        }
      }
      if(CVALID){
        C_Valid(i):=tmp.orR
      }
    }

    

    for(row<-0 to HEIGHT-1){
        val signCountTmp=RegNextWhen(io.signCount,start)init(0)//现在需要给SA一个start信号用来存储累加次数了
        for(col<-0 to WIDTH-1){
          if(row==0){//如果是第一行
            if(col==0){//如果是第一行并且是第一列
              PEArry(row)(col).io.activate:=io.MatrixA(row)//连接输入激活
              PEArry(row)(col).io.weight  :=io.MatrixB(col)//连接输入权重
              PEArry(row)(col).io.signCount:=signCountTmp
              PEArry(row)(col).io.valid:=io.A_Valid(row)&&io.B_Valid(col)
            }else{//如果是第一行而不是第一列
              PEArry(row)(col).io.activate:=PEArry(row)(col-1).io.acount//连接输入激活
              PEArry(row)(col).io.weight  :=io.MatrixB(col)//连接输入权重
              PEArry(row)(col).io.signCount:=signCountTmp
              PEArry(row)(col).io.valid:=Delay(io.A_Valid(row),col)&&Delay(io.B_Valid(col),row)
            }
          }else{
            if(col==0){//如果不是第一行但是是第一列
              PEArry(row)(col).io.activate:=io.MatrixA(row)//PEArry(row)(col).io.acount//获取第row行的输入激活
              PEArry(row)(col).io.weight  :=PEArry(row-1)(col).io.bcount//权重则为上一行的的权重
              PEArry(row)(col).io.signCount:=signCountTmp
              PEArry(row)(col).io.valid:=Delay(io.A_Valid(row),col)&&Delay(io.B_Valid(col),row)
            }else{//如果不是第一行也不是第一列
              PEArry(row)(col).io.activate:=PEArry(row)(col-1).io.acount//连接输入激活
              PEArry(row)(col).io.weight  :=PEArry(row-1)(col).io.bcount//连接输入权重
              PEArry(row)(col).io.signCount:=signCountTmp
              PEArry(row)(col).io.valid:=Delay(io.A_Valid(row),col)&&Delay(io.B_Valid(col),row)
            }
          }
        }
    }
}

class SA_Input(HEIGHT:Int,WIDTH:Int) extends Bundle{
  val MatrixA=in Vec(SInt(8 bits),HEIGHT)//HEIGHT个输入
  val MatrixB=in Vec(SInt(8 bits),WIDTH)
  val A_Valid=in Vec(Bool(),HEIGHT)
  val B_Valid=in Vec(Bool(),WIDTH)//数据有效标记
  //val Matrix_C=out Vec(SInt(ACCU_WITDH bits),HEIGHT)//累加和应该至少是20bits，可以配置为32bit
  val signCount=in UInt(16 bits)
}

class SA_3D(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int) extends Component{
  //SLICE:3维脉动阵列的片数
  val start =in Bool()//
  val SA_Inputs=Array.ofDim[SA_Input](SLICE)
  val PEArrays=Array.ofDim[SA_2D](SLICE)
  for(i<-0 to SLICE-1){
    SA_Inputs(i)=new SA_Input(HEIGHT,WIDTH)
    PEArrays(i)=new SA_2D(HEIGHT,WIDTH,ACCU_WITDH,i==0)
    PEArrays(i).io<>SA_Inputs(i)//PE的输入IO连接到顶层
    PEArrays(i).start:=start
    PEArrays(i).setName("Slice"+i.toString())
  }
  val Matrix_C=new Bundle{
    val valid=out Vec(Bool(),HEIGHT)
    val payload=out Vec(UInt(SLICE*ACCU_WITDH bits),HEIGHT)//位宽好像有点大。。。
  }

  //调试信号,将三维脉动阵列的输出重写排列一下
  // val Dbg_Signal=Vec(UInt(ACCU_WITDH bits),SLICE*HEIGHT*WIDTH)
  //阵列每次能出一个8*64子矩阵
  for(i<-0 to HEIGHT-1){//遍历HEIGHT
    Matrix_C.valid(i):=Delay(PEArrays(0).C_Valid(i),HEIGHT-i+1)
    for(j<-0 to SLICE-1){//遍历SLICE
        Matrix_C.payload(i)((j+1)*ACCU_WITDH-1 downto j*ACCU_WITDH):=Delay(PEArrays(j).MatrixC(i).asUInt,HEIGHT-i+1)//现在需要让脉动阵列每行出去的数据对齐
    }
  }

}
//2023、9、13：todo:将来要在这里再加一个模块，用来将三维输出转化为二维输出，这样的话，后面的其他模块就不需要适配三维的数据格式了，只需要适配二维格式即可
//具体查看当前文件夹下的pic2.png
object ConvOutput extends App { //
    val verilog_path="./Simulation/SA_3D/verilog" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_3D(1,8,64,32))
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new SA_2D(8,8,32,false))//
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}