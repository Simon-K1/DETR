package Systolic_Array.LHMM
import spinal.core._
import spinal.lib._
import utils.ForLoopCounter
import utils.TopConfig
//以矩阵格式输出阵列计算结构



class MatrixOut(dataWidthIn: Int, dataWidthOut: Int,depth:Int) extends Component{
  val Config=TopConfig()
  val io = new Bundle {
    val sData = slave Flow(UInt(dataWidthIn bits))
    val mData =  master Stream UInt(dataWidthOut bits)
    val mLast =out Bool()
    
    val OutMatrix_Col=in UInt(Config.MATRIXC_COL_WIDTH bits)//输出矩阵的列数，
    val OutMatrix_Row=in UInt(Config.MATRIXC_ROW_WIDTH bits)//输出矩阵的行数
    
  }
  noIoPrefix()

  val dataFifo = new StreamFifo(UInt(64 bits), depth)


  dataFifo.setDefinitionName("MatrixOutFifo")

  io.mData.payload<>dataFifo.io.pop.payload
  io.mData.valid<>dataFifo.io.pop.valid

  val Out_Col_Cnt=ForLoopCounter(io.mData.fire,Config.MATRIXC_COL_WIDTH,io.OutMatrix_Col-1)
  val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,Config.MATRIXC_COL_WIDTH,io.OutMatrix_Row-1)

}

