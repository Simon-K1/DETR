package Systolic_Array.Quant
import spinal.core._
import spinal.lib._
import xip.{AddSub, AddSubConfig, Mul, MulConfig}
import  utils.TopConfig
import xip.xil_ila
//实现量化算子

class Quan(convConfig: TopConfig) extends Component {
    val Config=TopConfig()
    val io = new Bundle {
        val dataIn = in Vec(SInt(convConfig.addChannelTimesWidth bits),convConfig.SA_ROW)
        val biasIn = in UInt (convConfig.QUANT_FACTOR_WIDTH bits)
        val scaleIn = in UInt (convConfig.QUANT_FACTOR_WIDTH bits)
        val shiftIn = in UInt (convConfig.QUANT_FACTOR_WIDTH bits)
        val zeroIn = in UInt (8 bits)
        // val activationEn = in Bool()
        val dataOut = out UInt (convConfig.SA_ROW * 8 bits)//一次出8个8bit，因为脉动阵列有8行
        //val amendReg = in Bits (32 bits)
    }
    noIoPrefix()
    val bias = new Bias(convConfig)
    bias.port.dataIn <> RegNext(io.dataIn)
    bias.port.quan <> io.biasIn

    val scale = new Scale(convConfig)
    scale.port.dataIn <> bias.port.dataOut
    scale.port.quan <> Delay(io.scaleIn, 2)

    val shift = new Shift(convConfig)
    shift.port.dataIn <> scale.port.dataOut
    shift.port.quan <> Delay(io.shiftIn, 10 + 1)

    val zero = new Zero(convConfig)
    zero.io.dataIn <> shift.port.dataOut
    zero.io.quan <> io.zeroIn

    // val leakyRelu = new LeakyRelu(convConfig)
    // leakyRelu.io.dataIn <> zero.io.dataOut
    // leakyRelu.io.quanZero <> io.zeroIn
    // leakyRelu.io.amendReg <> io.amendReg
    // when(io.activationEn) {
    //     io.dataOut.subdivideIn(convConfig.SA_ROW slices) <> leakyRelu.io.dataOut
    // } otherwise {
        
    // }
    io.dataOut.subdivideIn(convConfig.SA_ROW slices) <> zero.io.dataOut
    if(Config.ila){
        val Debug_Signals=Array[Bits](
            bias.port.dataOut.asBits,
            scale.port.dataOut.asBits,
            shift.port.dataOut.asBits,
            io.dataOut.asBits
        )
        
        val Debug_Name=Array[String]("Bias","Scale","Shift","DataOut")
        val ila=new xil_ila(Debug_Signals,true,"ila_BiasScaleShift")
        for(i<-0 to Debug_Signals.length-1){
            ila.probe(i):=Debug_Signals(i)
            Debug_Signals(i).setName("Debug_"+Debug_Name(i))
        }
    }

}
//object Quan extends App {
//    SpinalVerilog(new Quan(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

case class QuanSubPort(convConfig: TopConfig, inWidth: Int, quanWidth: Int, outWidth: Int) extends Bundle {
    val dataIn = in Vec(SInt(inWidth bits), convConfig.SA_ROW)
    val quan = in UInt(quanWidth bits)
    val dataOut = out Vec(SInt(outWidth bits), convConfig.SA_ROW)
}

class Bias(convConfig: TopConfig) extends Component {


    val port = QuanSubPort(convConfig, 32, 32, 48).setName("Bias")//输入位宽32，量化位宽32，输出位宽48
    val dataInTemp = Vec(Reg(SInt(48 bits)), convConfig.SA_ROW)
    val biasInTemp = Vec(Reg(UInt(48 bits)), convConfig.SA_ROW)
    (0 until convConfig.SA_ROW).foreach(i => {//对每个输出通道处理
        dataInTemp(i) := port.dataIn(i) @@ S"16'd0"//补0
        switch(port.quan(30 downto 24)) {//i：0~7--对应Bias
            for (j <- 0 until 17) {
                is(j) {//转化为补码计算
                    biasInTemp(i) := S(port.quan(31)).resize(8 + j bits).asUInt @@ port.quan(23 downto 0) @@ U(16 - j bits, default -> false)
                }
            }
            default {
                //算法控制，实际这个default是不会出现的
                biasInTemp(i) := 0
            }
        }
    })
    val biasAdd = Array.tabulate(convConfig.SA_ROW)(i => {
        def gen = {
            val add = AddSub(48, 48, 48, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "biasAdd", i == 0)
            add.io.A <> dataInTemp(i)
            add.io.B <> biasInTemp(i)
            add.io.S <> port.dataOut(i)
        }

        gen
    })
}
//object Bias extends App {
//    SpinalVerilog(new Bias(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}

class Scale(convConfig: TopConfig) extends Component {
    val port = QuanSubPort(convConfig, 48, 32, 32).setName("Scale")
    val scaleMulOut = Vec(SInt(32 bits), convConfig.SA_ROW)
    val scaleMul = Array.tabulate(convConfig.SA_ROW)(i => {
        def gen = {
            val mul = Mul(48, 32, 32, MulConfig.signed, MulConfig.unsigned, 8, MulConfig.dsp, this.clockDomain, "scaleMul", 79, 48, i == 0)
            mul.io.A <> port.dataIn(i)
            mul.io.B <> port.quan
            scaleMulOut(i):=mul.io.P.asSInt
        }

        gen
    })
    (0 until convConfig.SA_ROW).foreach(i => {
        port.dataOut(i) := RegNext(scaleMulOut(i))
    })

}

class Shift(convConfig: TopConfig) extends Component {
    val port = QuanSubPort(convConfig, 32, 32, 16).setName("shift")
    //shift完后为什么要加1？
    def <<(in: SInt, sh: UInt): SInt = {//动态移位
        val dataTemp = SInt(32 bits)
        dataTemp := in >> sh//比如那边实际上Shift了8位，但是这边拿到的却是7位，原因是如果直接移8位，最后一位就直接丢掉了，但是我们需要判断最后一位的值，做四舍五入
        val out = Reg(SInt(16 bits))
        when(dataTemp(0)) {
            out := (dataTemp.sign.asSInt @@ dataTemp(15 downto 1)) + 1//这里实际上是四舍五入
        } otherwise {
            out := dataTemp.sign.asSInt @@ dataTemp(15 downto 1)//不四舍五入，直接截余取整可否？
        }
        out
    }
    
    (0 until convConfig.SA_ROW).foreach { i =>
        port.dataOut(i) := <<(port.dataIn(i), port.quan)
    }

}
//object Shift extends App {
//    SpinalVerilog(new Shift(ConvConfig(8, 8, 8, 12, 8192, 512, 10, 2048, 1, ConvType.conv33)))
//}


class Zero(convConfig: TopConfig) extends Component {
    val io = new Bundle {
        val dataIn = in Vec(SInt(16 bits), convConfig.SA_ROW)
        val quan = in UInt (8 bits)
        val dataOut = out Vec(UInt(8 bits), convConfig.SA_ROW)
    }
    noIoPrefix()
    val addZeroTemp = Vec(SInt(16 bits), convConfig.SA_ROW)
    val addZero = Array.tabulate(convConfig.SA_ROW)(i => {
        def gen = {
            val add = AddSub(16, 8, 16, AddSubConfig.signed, AddSubConfig.unsigned, 1, AddSubConfig.lut, this.clockDomain, AddSubConfig.add, "AddZero", i == 0)
            add.io.A <> io.dataIn(i)
            add.io.B <> io.quan
            add.io.S <> addZeroTemp(i)
            add
        }

        gen
    })

    val normalData = Vec(Reg(UInt(8 bits)), convConfig.SA_ROW)
    io.dataOut := normalData
    (0 until convConfig.SA_ROW).foreach(i => {
        when(addZeroTemp(i).sign) {//缩放到0~255之间
            normalData(i) := 0
        } elsewhen (addZeroTemp(i) > 255) {
            normalData(i) := 255
        } otherwise {
            normalData(i) := addZeroTemp(i).asUInt.resized
        }
    })
}

object GeneVerilog extends App { 
    val verilog_path="./verilog/SimImg2Col" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Shift(TopConfig()))
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}

