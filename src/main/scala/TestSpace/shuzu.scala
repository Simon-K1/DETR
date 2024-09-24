import spinal.core._

class MyModule extends Component {
  val io = new Bundle {
    val PEZ = out(Vec(Vec(Bits(1 bits), 8), 8))
  }

  // 在顶层组件中定义PEZ数组
  val array = Array.ofDim[Bits](8, 8)
  for (row <- 0 until 8) {
    for (col <- 0 until 8) {
      array(row)(col) = B(0,1 bits)
    }
  }

  // 将数组转换为Vec[Vec[Bits]]
  val vecArray = Vec(array.map(row => Vec(row.map(_.asBits))))

  // 将PEZ数组连接到顶层输出端口
  io.PEZ := vecArray
}

// 生成Verilog文件
object MyModule extends App{
  val verilog_path = "./verilog/Test/verilog"
  SpinalConfig(targetDirectory = verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new MyModule)

}
