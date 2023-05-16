package xip

import spinal.core._
import utils.Tcl_Config.Tcl_File_Path
import org.apache.commons.io.FileUtils
object MulConfig {
    val signed = "signed"
    val unsigned = "Unsigned"
    val dsp = "DSP"
    val lut = "LUT"
}

class Mul(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int, A_TYPE: String, B_TYPE: String, clockDomain: ClockDomain, componentName: String) extends BlackBox {
    val io = new Bundle {
        val A = if (A_TYPE == MulConfig.signed) {
            in SInt (A_WIDTH bits)
        } else {
            in UInt (A_WIDTH bits)
        }
        val B = if (B_TYPE == MulConfig.signed) {
            in SInt (B_WIDTH bits)
        } else {
            in UInt (B_WIDTH bits)
        }
        val P =out Bits(P_WIDTH bits)
        // P.asOutput()
        val CLK = in Bool()
    }
    noIoPrefix()
    this.setDefinitionName(componentName)

    mapClockDomain(clockDomain, io.CLK)
}

object Mul {
    //private var mulIndex = -1
    private def genTcl(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int, A_TYPE: String, B_TYPE: String, PIPELINE_STAGE: Int, RESOURCES_TYPE: String, componentName: String): Unit = {
        import java.io._
        val createMulCmd = s"set mulExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$mulExit <0} {\n" +
            s"create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name $componentName\n" +
            s"}\n"
        FileUtils.forceMkdir(new File(Tcl_File_Path + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(Tcl_File_Path + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        tclHeader.write(createMulCmd)
        tclHeader.write(s"set_property -dict [list ")
        tclHeader.write(s"CONFIG.PortAWidth {$A_WIDTH} ")
        tclHeader.write(s"CONFIG.PortAType {$A_TYPE} ")
        tclHeader.write(s"CONFIG.PortBWidth {$B_WIDTH} ")
        tclHeader.write(s"CONFIG.PortBType {$B_TYPE} ")
        val res = if (RESOURCES_TYPE == MulConfig.dsp) {
            "Use_Mults"
        } else {
            "Use_LUTs"
        }
        tclHeader.write(s"CONFIG.Multiplier_Construction {$res} ")
        val w = P_WIDTH - 1
        if (A_WIDTH + B_WIDTH != P_WIDTH) {
            tclHeader.write(s"CONFIG.Use_Custom_Output_Width {true} ")
        }
        tclHeader.write(s"CONFIG.OutputWidthHigh {$w} ")
        tclHeader.write(s"CONFIG.PipeStages {$PIPELINE_STAGE} ")
        tclHeader.write(s"] [get_ips $componentName] \n")
        tclHeader.write(s"set_property generate_synth_checkpoint 0 [get_files $componentName.xci] \n")
        tclHeader.close()
    }

    private def genTcl(A_WIDTH: Int, B_WIDTH: Int, A_TYPE: String, B_TYPE: String, PIPELINE_STAGE: Int, RESOURCES_TYPE: String, componentName: String, outMsb: Int, outLsb: Int): Unit = {
        import java.io._
        val createMulCmd = s"set mulExit [lsearch -exact [get_ips $componentName] $componentName]\n" +
            s"if { $$mulExit <0} {\n" +
            s"create_ip -name mult_gen -vendor xilinx.com -library ip -version 12.0 -module_name $componentName\n" +
            s"}\n"
        FileUtils.forceMkdir(new File(Tcl_File_Path + File.separator + "tcl"))
        val tclHeader = new PrintWriter(new File(Tcl_File_Path + File.separator + "tcl" + File.separator + s"generate$componentName.tcl"))
        tclHeader.write(createMulCmd)
        tclHeader.write(s"set_property -dict [list ")
        tclHeader.write(s"CONFIG.PortAWidth {$A_WIDTH} ")
        tclHeader.write(s"CONFIG.PortAType {$A_TYPE} ")
        tclHeader.write(s"CONFIG.PortBWidth {$B_WIDTH} ")
        tclHeader.write(s"CONFIG.PortBType {$B_TYPE} ")
        val res = if (RESOURCES_TYPE == MulConfig.dsp) {
            "Use_Mults"
        } else {
            "Use_LUTs"
        }
        tclHeader.write(s"CONFIG.Multiplier_Construction {$res} ")
        tclHeader.write(s"CONFIG.Use_Custom_Output_Width {true} ")
        tclHeader.write(s"CONFIG.OutputWidthHigh {$outMsb} ")
        tclHeader.write(s"CONFIG.OutputWidthLow {$outLsb} ")
        tclHeader.write(s"CONFIG.PipeStages {$PIPELINE_STAGE} ")
        tclHeader.write(s"] [get_ips $componentName] \n")
//        tclHeader.write(s"set_property generate_synth_checkpoint 0 [get_files $componentName.xci] \n")
        tclHeader.close()
    }

    def apply(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int, A_TYPE: String, B_TYPE: String, PIPELINE_STAGE: Int, RESOURCES_TYPE: String, clockDomain: ClockDomain, componentName: String, genTclScript: Boolean = true) = {
        if (genTclScript) {
            // mulIndex = mulIndex + 1
            genTcl(A_WIDTH, B_WIDTH, P_WIDTH, A_TYPE, B_TYPE, PIPELINE_STAGE, RESOURCES_TYPE, componentName)
        }
        val mul = new Mul(A_WIDTH, B_WIDTH, P_WIDTH, A_TYPE, B_TYPE, clockDomain, componentName)
        mul
    }

    def apply(A_WIDTH: Int, B_WIDTH: Int, P_WIDTH: Int, A_TYPE: String, B_TYPE: String, PIPELINE_STAGE: Int, RESOURCES_TYPE: String, clockDomain: ClockDomain, componentName: String, outMsb: Int, outLsb: Int, genTclScript: Boolean) = {
        if (genTclScript) {
            // mulIndex = mulIndex + 1
            genTcl(A_WIDTH, B_WIDTH, A_TYPE, B_TYPE, PIPELINE_STAGE, RESOURCES_TYPE, componentName, outMsb, outLsb)
        }
        val mul = new Mul(A_WIDTH, B_WIDTH, P_WIDTH, A_TYPE, B_TYPE, clockDomain, componentName)
        mul
    }
}

// class testMul extends Component{
//    val io = new Bundle{
//        val A = in SInt(32 bits)
//        val B = in UInt(32 bits)
//        val P = out Vec(SInt(32 bits),5)
//    }
//    noIoPrefix()
//    val mul = Array.tabulate(5){i=>
//        def gen = {
//            val m = Mul(32,32,32,MulConfig.signed,MulConfig.unsigned,3,MulConfig.dsp,this.clockDomain,"mul8_8_8",63,32,i==0)
//            m.io.A <> io.A
//            m.io.B <> io.B
//            m.io.P <> io.P(i)
//        }
//        gen
//    }


// }
// object testMul extends App {
//    SpinalVerilog(new testMul)
// }
