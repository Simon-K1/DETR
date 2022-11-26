package LayerNorm
import spinal.core._
import spinal.lib._
import utils._
//实现8并行度的累加计算
object SUM_XQ_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_FIRST_ROW,ACCUMU = newElement
    //LOAD_FIRTS_ROW:加载第一行，这时候计算第一行的累加和和C*X_Q
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
    }
    noIoPrefix()

    
    val Fsm=SUM_XQ_FSM(io.start&&(!RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===SUM_XQ_ENUM.INIT,log2Up(5),5)//初始化数5下
    val Col_Cnt=WaCounter(io.sData.valid&&io.sData.ready, log2Up(Config.CHANNEL_NUMS), Config.CHANNEL_NUMS-1)//创建输入数据的列计数器
    val Row_Cnt=WaCounter(Col_Cnt.valid, log2Up(Config.TOKEN_NUMS), Config.TOKEN_NUMS-1)//创建输入数据行计数器
    
    
    Fsm.Init_End:=Init_Count.valid
    Fsm.Load_Firts_Row_End:=Row_Cnt.count>=1//当行计数器为1时，说明刚好进完了一列，所以这个的判断条件是行计数器大于等于1
    Fsm.Accumu_End:=Row_Cnt.valid//当行计数器valid拉高，也就是说说明一个完整的矩阵数据已经进来了。

    io.sData.ready:=(Fsm.currentState=/=SUM_XQ_ENUM.IDLE)&&(Fsm.currentState=/=SUM_XQ_ENUM.INIT)//暂时只考虑到这么多，只要不处于这两个状态应该都能接受数据吧
    //创建一个mem用于缓存8行数据，因为A需要计算完均值再做减法===============================================================
    val Row_Mem=new Mem(UInt(Config.IN_DATA_WIDTH bits),Config.CHANNEL_NUMS)//64位宽，384深度
    

    val Read_Row_Mem_Data=Row_Mem.readSync(Col_Cnt.count,io.sData.fire)//这里采用的就是：来一个数读一下
    val Write_Row_Mem_Data=RegNext(io.sData.payload)
    val Write_Row_Mem_Valid=RegNext(io.sData.fire)
    val Write_Row_Mem_Addr=RegNext(Col_Cnt.count)
    Row_Mem.write(Write_Row_Mem_Addr,Write_Row_Mem_Data,Write_Row_Mem_Valid)//使用读优先策略，要求先读再写，先读出旧的Xq再写入新的Xq
    //这里直接用最简单的本办法，让写入数据慢读出数据一拍，错开就不会有冲突了
        //之前想的是单独为读数据创建一个计数器，当读出多少数据后才开始写入新的数据，感觉有点麻烦
        //现在的策略就是来一个数据，先读再写，写慢读一拍

    //设计思路：
        //由于A=C*X_q-M1,所以可以在加载一行的同时进行累加和计算，加载完一行后，累加和M1也就算完了
        //同时在加载的时候还能同时进行C*X_q的计算，这样一行加载完，每个点的C*X_q-M1的值也就知道了
        //之后再加载下一行，腹泻上一行的Bram，以此类推
}
object Sum_Xq_Gen extends App { 
    val verilog_path="./testcode_gen" 
   SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Sum_Xq)
}