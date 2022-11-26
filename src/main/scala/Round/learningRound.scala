package Round
import spinal.core._
class Round_Test extends Component{
    

}
object Round_Test extends App { 
    val verilog_path="./testcode_gen/Round_Test" 
   SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Round_Test)
}