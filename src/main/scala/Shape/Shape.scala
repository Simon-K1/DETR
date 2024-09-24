package Shape

import spinal.core.Component
import spinal.core._
import spinal.lib._

case class ShapeConfig(DATA_WIDTH: Int, COMPUTE_CHANNEL_NUM: Int, FEATURE: Int, CHANNEL_WIDTH: Int, ROW_MEM_DEPTH: Int) {
  val STREAM_DATA_WIDTH = DATA_WIDTH * COMPUTE_CHANNEL_NUM
  val maxPoolingConfig = MaxPoolingConfig(DATA_WIDTH, COMPUTE_CHANNEL_NUM, FEATURE, CHANNEL_WIDTH, ROW_MEM_DEPTH)

}

class Shape(shapeConfig: ShapeConfig) extends Component {
  val io = new Bundle {
    val sData = Vec(slave Stream (UInt(shapeConfig.STREAM_DATA_WIDTH bits)), 2)
    val mData = master Stream (UInt(shapeConfig.STREAM_DATA_WIDTH bits))
    val dmaReadValid = out Vec(Bool(), 2)
    val dmaWriteValid = out Bool()
    val control = in Bits (4 bits)
    val state = out Bits (4 bits)
    val introut = in Bool()
    val instruction = in Vec(Bits(32 bits), 6)
    val last = out Bool()
  }
  noIoPrefix()

//  val shapeState = new ShapeState
//  shapeState.io.dmaReadValid <> io.dmaReadValid
//  shapeState.io.dmaWriteValid <> io.dmaWriteValid
//  shapeState.io.control <> io.control
//  shapeState.io.state <> io.state
//
//  shapeState.io.complete <> io.introut
//
//  val start = shapeState.io.start.map(_.rise()).reduce(_ || _)
//  val instruction = io.instruction.reverse.reduceRight(_ ## _)
//  val instructionReg = Reg(Bits(instruction.getWidth bits)) init 0
//  when(start) {
//    instructionReg := instruction
//  }

  val fifoReady = Reg(Bool()) init False

//  val maxPooling = new MaxPooling(shapeConfig.maxPoolingConfig)
//  maxPooling.io.start <> Delay(shapeState.io.start(Start.MAX_POOLING), 8)
//  maxPooling.io.colNumIn  <> instructionReg(Instruction.COL_NUM_IN).asUInt.resized
//  maxPooling.io.rowNumIn  <> instructionReg(Instruction.ROW_NUM_IN).asUInt.resized
//  maxPooling.io.channelIn <> instructionReg(Instruction.CHANNEL_IN).asUInt.resized
//  maxPooling.io.enPadding <> instructionReg(Instruction.ENPADDING).asBool.resized
//  maxPooling.io.kernelNum <> instructionReg(Instruction.KERNELNUM).asUInt.resized
//  maxPooling.io.strideNum <> instructionReg(Instruction.STRIDENUM).asUInt.resized
//  maxPooling.io.zeroDara  <> instructionReg(Instruction.ZERODATA).asBits.resized
//  maxPooling.io.zeroNum   <> instructionReg(Instruction.ZERONUM).asUInt.resized

}

