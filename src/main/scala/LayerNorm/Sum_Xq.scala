package LayerNorm
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
//实现8并行度的累加计算
object SUM_XQ_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_FIRST_ROW,ACCUMU = newElement
    //LOAD_FIRTS_ROW:加载第一行，这时候计算第一行的累加和和C*X_Q
}

// class Xq2C_1 extends BlackBox{
//     //XQ2C=cM2计算
//     //Dsp48 macro有一个A*B+P还有一个A*B+C，这个是A*B+C的
//     val Config=TopConfig()
//     val io=new Bundle{
//         val CLK=in Bool()
//         val A=in UInt(Config.XQ2C_A_WIDTH bits)
//         val B=in UInt(Config.XQ2C_B_WIDTH bits)
//         val C=in UInt(Config.XQ2C_C_WIDTH bits)
//         val P=out UInt(Config.XQ2C_P_WIDTH bits)
//     }
//     noIoPrefix()
//     mapClockDomain(clock=io.CLK)
// }
// class Xq2C_2 extends BlackBox{
//     //XQ2C=cM2计算
//     //Dsp48 macro有一个A*B+P还有一个A*B+C，这个是A*B+P的（最后测试发现这个P初始化有问题....,不太会用)
//     val Config=TopConfig()
//     val io=new Bundle{
//         val CLK=in Bool()
//         val A=in UInt(Config.XQ2C_A_WIDTH bits)
//         val B=in UInt(Config.XQ2C_B_WIDTH bits)
//         // val C=in UInt(Config.XQ2C_C_WIDTH bits)
//         val P=out UInt(Config.XQ2C_P_WIDTH bits)
//     }
//     noIoPrefix()
//     mapClockDomain(clock=io.CLK)
// }
class XqC extends BlackBox{
    //XQC=C*X_q计算
    //注意Dsp48使用的是补码输入，所以如果输入的是无符号8bit，需要设置输入位宽为9，MSB永远设置为0，
    //所以这地方暂时使Multiplier Ip
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in UInt(Config.XQC_A_WIDTH bits)
        val B=in UInt(Config.XQC_B_WIDTH bits)
        val P=out UInt(Config.XQC_P_WIDTH bits)
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
class Xq2C extends BlackBox{
    //XQC=C*X_q计算
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in UInt(Config.XQ2C_A_WIDTH bits)
        val B=in UInt(Config.XQ2C_B_WIDTH bits)
        val P=out UInt(Config.XQ2C_P_WIDTH bits)
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
class Xq_Sum_Pow extends BlackBox{
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in UInt(Config.XQ_SUM_WIDTH bits)//20
        val B=in UInt(Config.XQ_SUM_WIDTH bits)//20
        val P=out UInt(2*Config.XQ_SUM_WIDTH bits)//40
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
case class SUM_XQ_FSM(start:Bool)extends Area{
    val currentState = Reg(SUM_XQ_ENUM()) init SUM_XQ_ENUM.IDLE
    val nextState = SUM_XQ_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Load_Firts_Row_End=Bool()//加载完第一行
    val Accumu_End=Bool()//一个矩阵的所有点都进来后,结束累加进入Idle状态

    switch(currentState){
        is(SUM_XQ_ENUM.IDLE){
            when(start){
                nextState:=SUM_XQ_ENUM.INIT
            }otherwise{
                nextState:=SUM_XQ_ENUM.IDLE
            }
        }
        is(SUM_XQ_ENUM.INIT){
            when(Init_End){
                nextState:=SUM_XQ_ENUM.LOAD_FIRST_ROW
            }otherwise{
                nextState:=SUM_XQ_ENUM.INIT
            }
        }
        is(SUM_XQ_ENUM.LOAD_FIRST_ROW){
            when(Load_Firts_Row_End){
                nextState:=SUM_XQ_ENUM.ACCUMU
            }otherwise{
                nextState:=SUM_XQ_ENUM.LOAD_FIRST_ROW
            }
        }
        is(SUM_XQ_ENUM.ACCUMU){
            when(Accumu_End){
                nextState:=SUM_XQ_ENUM.IDLE
            }otherwise{
                nextState:=SUM_XQ_ENUM.ACCUMU
            }//可以百分百确定的是，最后一个点进完之后，平方，根号这些计算一定还没有算完，所以对于平方，根号的结果valid需要延时
        }
    }
}
class Sum_Xq extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val sData=slave Stream( UInt(Config.IN_DATA_WIDTH bits))//输入数据64bit，一次进8行，每行一个点（8bit)
        val start=in Bool()//计算启动信号

        val Channel_Nums=in UInt(Config.CHANNEL_NUMS_WIDTH bits)//12bit--最大4095

        val Scale=in UInt(8 bits)
        val Bias=in UInt(8 bits)//不知道8bit够不够用，，planB就是之后将8bit改为32bit
    }
    noIoPrefix()

    
    val Fsm=SUM_XQ_FSM(io.start&&(!RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===SUM_XQ_ENUM.INIT,log2Up(5),5)//初始化数5下
    val Col_Cnt=WaCounter(io.sData.valid&&io.sData.ready, log2Up(Config.CHANNEL_NUMS), Config.CHANNEL_NUMS-1)//创建输入数据的列计数器
    val Row_Cnt=WaCounter(Col_Cnt.valid, log2Up(Config.TOKEN_NUMS), Config.TOKEN_NUMS-1)//创建输入数据行计数器
    
    
    Fsm.Init_End:=Init_Count.valid
    Fsm.Load_Firts_Row_End:=(Row_Cnt.count===0)&&Col_Cnt.valid//当行计数为0时，说明处于第一行，当列计数拉高时，说明第一行加载完了
    Fsm.Accumu_End:=Row_Cnt.valid//当行计数器valid拉高，也就是说说明一个完整的矩阵数据已经进来了。

    io.sData.ready:=(Fsm.currentState=/=SUM_XQ_ENUM.IDLE)&&(Fsm.currentState=/=SUM_XQ_ENUM.INIT)//暂时只考虑到这么多，只要不处于这两个状态应该都能接受数据吧
    //创建一个mem用于缓存8行数据，因为A需要计算完均值再做减法===============================================================
    val Row_Mem=new Mem(UInt(Config.XQC_P_WIDTH bits),Config.CHANNEL_NUMS)//64位宽，384深度
    

    val Read_Row_Mem_Data=Row_Mem.readSync(Col_Cnt.count,io.sData.fire)//这里采用的就是：来一个数读一下
    
    
    //这里直接用最简单的本办法，让写入数据慢读出数据一拍，错开就不会有冲突了
        //之前想的是单独为读数据创建一个计数器，当读出多少数据后才开始写入新的数据，感觉有点麻烦
        //现在的策略就是来一个数据，先读再写，写慢读一拍


    //第二步骤，设计乘法流水线（需要大量调用xilinx的IP核)=============================================================================================
    
    //①计算x_q*c
    val Read_Row_Mem_Data_Valid=RegNext(io.sData.fire&&Fsm.currentState===SUM_XQ_ENUM.ACCUMU)//因为只有进入ACCUMU状态才开始计算上一层累加和之后的数据
    //sData.fire拉高，说明可以从Mem中读取数据，需要一个时钟，所以RegNext一下-->数据进来一个，sData.fire拉高，这时从Mem中读出一个数，在下一周期才有效

    val XqC_Module=new XqC
    // val Xq2C_ABCP=new Xq2C_1
    val Xq2C_Module=new Xq2C
    
    XqC_Module.io.A:=io.sData.payload(7 downto 0)//读出上一行的数据参与计算
    XqC_Module.io.B:=io.Channel_Nums
    //XqC计算结果写回=======================================================
    val XqC_Valid=Delay(io.sData.fire,Config.XQC_PIPELINE)
    val Write_Row_Mem_Data=XqC_Module.io.P.resized//要写入的数据应该是XqC这个数据
    val Write_Row_Mem_Valid=XqC_Valid
    val Write_Row_Mem_Addr=Delay(Col_Cnt.count,Config.XQC_PIPELINE)
    Row_Mem.write(Write_Row_Mem_Addr,Write_Row_Mem_Data,Write_Row_Mem_Valid)//使用读优先策略，要求先读再写，先读出旧的Xq再写入新的Xq
    //累加和计算=============================================================
    val Xq_Sum=Reg(UInt(Config.XQ_SUM_WIDTH bits))init(0)
    val Xq_Sum_Clear=RegNext(Col_Cnt.valid)//累加和清零,延一拍


    when(io.sData.fire){//如果当前数据有效，需要判断是继续累加还是重新开始累加
        when(Xq_Sum_Clear){
            Xq_Sum:=io.sData.payload(7 downto 0).resized
        }otherwise{
            Xq_Sum:=Xq_Sum+io.sData.payload(7 downto 0).resized
        }
    }
    
    //Xq2C计算==============================================================
    Xq2C_Module.io.A:=XqC_Module.io.P
    Xq2C_Module.io.B:=Delay(io.sData.payload(7 downto 0),Config.XQC_PIPELINE)
    

    //平方和计算=============================================================
    val Xq2C_Sum=Reg(UInt(Config.XQ2C_SUM_WIDTH bits))init(0)//累加和32bit位宽可能不够，。。。。
    val Xq2C_Valid=Delay(XqC_Valid,Config.XQ2C_PIPELINE)
    val Xq2C_Sum_Clear=Delay(Xq_Sum_Clear,Config.XQ2C_PIPELINE+Config.XQC_PIPELINE)//Xq进来，valid拉高，计算累加和，Xq然后和C计算，延迟XqC_Pipeline拍，出来的结果继续和Xq计算，延迟Xq2c_Pipeline拍

    when(Xq2C_Valid){//如果当前数据有效，需要判断是继续累加还是重新开始累加
        when(Xq2C_Sum_Clear){
            Xq2C_Sum:=Xq2C_Module.io.P.resized
        }otherwise{
            Xq2C_Sum:=Xq2C_Sum+Xq2C_Module.io.P.resized
        }
    }
    // Xq2C_ABCP.io.B:=XqC_Module.io.A

    //设计思路：
        //由于A=C*X_q-M1,所以可以在加载一行的同时进行累加和计算，加载完一行后，累加和M1也就算完了
        //同时在加载的时候还能同时进行C*X_q的计算，这样一行加载完，每个点的C*X_q-M1的值也就知道了
        //之后再加载下一行，复写上一行的Bram，以此类推


//第二阶段，拿上一行计算完的XqC，Xq_Sum,Xq2C_Sum执行剩下的计算(⭐⭐默认以下计算都能在加载一行数据的过程中计算完成，还还没有处理embedding维度小于二阶段计算延时的情况)
    //计算A=X_q*C-M1=========================================================================
    val Xq_Sum_Old= RegNextWhen(Xq_Sum, Xq_Sum_Clear)init(0)
    //当最后一个点进来，col_valid拉高，然后，第二个个周期Xq_Sum_Clear拉高，这时，上一行累加和计算完成，同时Mem的读地址变为0即在第三个周期读出
    //上一行的Xq,另外，在第三个周期的上一行累加和Xq_Sum_Old也被确定
    val Xq_Substract_M2=Read_Row_Mem_Data-Xq_Sum_Old//⭐应该是有符号类型，补码表示
    //计算C*M2-M1^2==========================================================================
        //M1^2(这地方可以给乘法器加一个时钟使能，以后再说)
    val XqSum_Pow=new Xq_Sum_Pow
    XqSum_Pow.io.A:=Xq_Sum_Old
    XqSum_Pow.io.B:=Xq_Sum_Old
    val Xq_Sum_Pow_Valid=Delay(Xq_Sum_Clear,Config.XQ_SUM_POW_PIPELINE)//40bit
        //获取上一行的C*M2
    val Xq2C_Sum_Last=RegNextWhen(Xq2C_Sum,Xq2C_Sum_Clear)init(0)
        //计算上一行数据CM2-M1^2作为根号输入
    val Sqrt_In=Xq2C_Sum_Last-XqSum_Pow.io.P//这样写会出来毛刺，，，，，，
    

}
object Sum_Xq_Gen extends App { 
    val verilog_path="./testcode_gen" 
   SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Sum_Xq)
}