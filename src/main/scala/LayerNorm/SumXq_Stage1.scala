package LayerNorm
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
import xip.Mul
import Systolic_Array.Quant.Quan
import xip.xil_SimpleDualBram
//实现8并行度的累加计算
object SUM_XQ_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_FIRST_ROW,ACCUMU,FINISH_LAST_ROW = newElement
    //LOAD_FIRTS_ROW:加载第一行，这时候计算第一行的累加和和C*X_Q
    //FINISH_LAST_ROW:处理完最后一行的计算
}

class XqC extends BlackBox{
    //XQC=C*X_q计算
    //注意Dsp48使用的是补码输入，所以如果输入的是无符号8bit，需要设置输入位宽为9，MSB永远设置为0，
    //所以这地方暂时使Multiplier Ip
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in SInt(Config.XQC_A_WIDTH bits)//xq-zp  sint
        val B=in UInt(Config.XQC_B_WIDTH bits)//C--uint
        val P=out SInt(Config.XQC_P_WIDTH bits)
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
class Xq2C extends BlackBox{
    //XQC=C*X_q计算
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in SInt(Config.XQ2C_A_WIDTH bits)//sint 20bit--(xq-zp)*C
        val B=in SInt(Config.XQ2C_B_WIDTH bits)//sint 8bit  xq
        val P=out UInt(Config.XQ2C_P_WIDTH bits)
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
class Xq_Sum_Pow extends BlackBox{
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in SInt(Config.XQ_SUM_WIDTH bits)//20
        val B=in SInt(Config.XQ_SUM_WIDTH bits)//20
        val P=out UInt(2*Config.XQ_SUM_WIDTH bits)//40
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}

class Scale_Multiply_A extends BlackBox{
    //在计算根号下分之一得同时计算Scale*（CX_q-Sum(Xq))=A
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in SInt(Config.XQ_SUBSTRACT_M2_WIDTH bits)//20
        val B=in SInt(Config.SCALE_WIDTH bits)//8
        val P=out SInt(Config.SCALE_WIDTH+Config.XQ_SUBSTRACT_M2_WIDTH bits)//40
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}
class Fi32_to_Single extends  BlackBox{//定点32转单精度
    val s_axis_a=new Bundle{
        val tdata=in UInt(32 bits)
        val tready=out Bool()
        val tvalid=in Bool()
    }
    val aclk=in Bool()
    val m_axis_result=new Bundle{
        val tdata=out UInt(32 bits)
        val tready=in Bool()
        val tvalid=out Bool()
    }
    noIoPrefix()
    mapClockDomain(clock=aclk)
}
class Reciprocal_Sqrt extends BlackBox{
    val s_axis_a=new Bundle{
        val tdata=in UInt(32 bits)
        val tready=out Bool()
        val tvalid=in Bool()
    }
    val aclk=in Bool()
    val m_axis_result=new Bundle{
        val tdata=out UInt(32 bits)
        val tready=in Bool()
        val tvalid=out Bool()
    }
    noIoPrefix()
    mapClockDomain(clock=aclk)
}
class Scale_A_ReciproSqrt extends BlackBox{
    val Config=TopConfig()
    val io=new Bundle{
        val CLK=in Bool()
        val A=in SInt(Config.SCALE_A_RECIPROSQRT_Aport_WIDTH bits)//40
        val B=in UInt(Config.SCALE_A_RECIPROSQRT_Bport_WIDTH bits)//24
        val P=out SInt(Config.SCALE_A_RECIPROSQRT_Pport_WIDTH bits)//64
    }
    noIoPrefix()
    mapClockDomain(clock=io.CLK)
}

class Dynamic_Shift extends Component{//动态移位，上板测试过了，，，居然真的能过
    //动态移位测试，之前写的移位都是固定位数的移位，但是现在平方根出来的是一个单精度，带了动态移位参数，需要考虑进去
    val io=new Bundle{
        val Shift_Num=in UInt(8 bits)//需要动态移位的参数
        val Data_To_Shift=in UInt(32 bits)
        val Data_Shited=out UInt(32 bits)
    }
    noIoPrefix()
    //如果是bit类型，单纯使用逻辑移位，如果是Uint或SInt，则使用算术移位
    io.Data_Shited:=io.Data_To_Shift>>io.Shift_Num
    val aaa=io.Data_To_Shift>>io.Shift_Num
}
class Scale_A_Fifo(dataType:SInt,depth: Int) extends StreamFifo(dataType,depth)
case class SUM_XQ_FSM(start:Bool)extends Area{
    val currentState = Reg(SUM_XQ_ENUM()) init SUM_XQ_ENUM.IDLE
    val nextState = SUM_XQ_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Load_Firts_Row_End=Bool()//加载完第一行
    val Accumu_End=Bool()//一个矩阵的所有点都进来后,结束累加进入Idle状态,所有行的累加和都被计算完成，包括最后一行的XqC也被计算完只是被缓存了
    val Last_Row_Finished=Bool()

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
                nextState:=SUM_XQ_ENUM.FINISH_LAST_ROW
            }otherwise{
                nextState:=SUM_XQ_ENUM.ACCUMU
            }//可以百分百确定的是，最后一个点进完之后，平方，根号这些计算一定还没有算完，所以对于平方，根号的结果valid需要延时
        }
        is(SUM_XQ_ENUM.FINISH_LAST_ROW){
            when(Last_Row_Finished){
                nextState:=SUM_XQ_ENUM.IDLE
            }otherwise{
                nextState:=SUM_XQ_ENUM.FINISH_LAST_ROW
            }
        }
    }
}
object SQRT_COMPUTE_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val COMPUTE =Array.tabulate(8+1)(i=>{
        val COMPUTE=newElement
        COMPUTE
    })
    //可以认为Compute0是之前的WAIT
    //WAIT:等待进Sqrt的有效数据
    //COMPUTE0:计算第一个并行度的sqrt，分8次计算，没必要要为了8并行度消耗8*9=72个DSP
}//这个状态机就是用来加载8个sqrt，写那么多的原因是因为有可能Fixed2Single模块的ready拉低，ready拉低就不能进数据了
case class SQRT_COMPUTE_FSM()extends Area{
    val currentState = Reg(SQRT_COMPUTE_ENUM()) init SQRT_COMPUTE_ENUM.COMPUTE(0)
    val nextState = SQRT_COMPUTE_ENUM()
    currentState := nextState

    val Data_Sended=Bool()
    val Send_Data=Vec(Bool(),9)//Send_Data(0)
    switch(currentState){
        for(i<-0 to 8){
            is(SQRT_COMPUTE_ENUM.COMPUTE(i)){
                when(Send_Data(i)){
                    if(i==8){
                        nextState:=SQRT_COMPUTE_ENUM.COMPUTE(0)//到了最后一个，也就是Send_Data(8)来了，那么下一个周期就是WAIT（Send_Data(0))
                    }else{
                        nextState:=SQRT_COMPUTE_ENUM.COMPUTE(i+1)
                    }
                }otherwise{
                    nextState:=SQRT_COMPUTE_ENUM.COMPUTE(i)
                }
            }
        }
    }
}


object SCALEA_MUL_RESQRT_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, RESQRT_VALID,RESQRT_VALID_AGAIN= newElement
    //RESQRT_VALID代表Resqrt数据有效，可以进行Scale*A*B的计算，但是有一种可能：就是上层算得比较快（中间sValid一直拉高），
        //在计算上一轮Scale*A*B*（也就是上一轮的Scale*A*B还没算完，下一轮的Resqrt又算好了）
        //那么这轮的RESQRT_VALID状态结束后不用进入IDLE状态而是继续计算
        //分析：
            //如果上层累加和模块不停，也就是一直流，那么上层稳定后384周期处理一轮，下层也是384周期处理一轮，这样就会产生前面说的问题
}
case class ScaleA_Mul_Resqrt_Fsm(start:Bool) extends Area{
    val currentState = Reg(SCALEA_MUL_RESQRT_ENUM()) init SCALEA_MUL_RESQRT_ENUM.IDLE
    val nextState = SCALEA_MUL_RESQRT_ENUM()
    currentState := nextState

    val ScaleA_Mul_ReSqrt_End=Bool()
    val Row_All_Computed=Bool()//全部行都算完了
    switch(currentState){
        is(SCALEA_MUL_RESQRT_ENUM.IDLE){
            when(start){
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID
            }otherwise{
                nextState:=SCALEA_MUL_RESQRT_ENUM.IDLE
            }
        }
        is(SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID){
            when(Row_All_Computed){
                nextState:=SCALEA_MUL_RESQRT_ENUM.IDLE
            }elsewhen(start&&ScaleA_Mul_ReSqrt_End){//加一个这个判断是因为：碰到一种很奇葩的可能：
                        //如果start和SAB_count同时拉高，，，，那么下一个状态应该还是RESQRT_VALID
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID
            }elsewhen(start){//如果1/Sqrt先算完
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID_AGAIN
            }elsewhen(ScaleA_Mul_ReSqrt_End){
                nextState:=SCALEA_MUL_RESQRT_ENUM.IDLE
            }otherwise{
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID
            }
        }
        is(SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID_AGAIN){
            when(Row_All_Computed){
                nextState:=SCALEA_MUL_RESQRT_ENUM.IDLE
            }elsewhen(ScaleA_Mul_ReSqrt_End){
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID
            }otherwise{
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID_AGAIN
            }
        }
    }
}
class Ptf_Module extends Component{
    val io=new Bundle{
        val DataIn=in SInt(8 bits)//减去zeropoint后的数据
        val DataOut=out SInt(11 bits)//移位后的值
        val Ptf=in UInt(2 bits)
    }
    val sData_Ptf=SInt(11 bits)//88bit
    switch(io.Ptf){//这里执行的是算术移位，移位是有符号数，由补码表示
        is(0){
            sData_Ptf:=io.DataIn.resized
        }
        is(1){
            sData_Ptf:=(io.DataIn<<1).resized
        }
        is(2){
            sData_Ptf:=(io.DataIn<<2).resized
        }
        is(3){
            sData_Ptf:=io.DataIn<<3
        }//由于是动态移位，但是动态移位的位数又是有限的，就用一个switch来处理了
    }
}
class Sum_Xq extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val sData=slave Stream( SInt(Config.XQ_DATA_WIDTH bits))//输入数据88bit，一次进8行，每行一个点（8bit),进来的数据为Xq-Zeropoint的值，所以是有符号数据
        //11bit是在外面处理了ptf量化因子后的值
        val start=in Bool()//计算启动信号

        val Channel_Nums=in UInt(Config.CHANNEL_NUMS_WIDTH bits)//12bit--最大4095
        val Token_Nums=in UInt(Config.TOKEN_NUMS_WIDTH bits)
        
        val Scale_Read_Addr=out UInt(Config.CHANNEL_NUMS_WIDTH bits)
        val Scale=in SInt(8 bits)//暂时让Scale和Bias作为输入
        val Bias=in SInt(8 bits)//不知道8bit够不够用，，planB就是之后将8bit改为32bit

        val Sqrt_Out_Valid=out Bool()
        val Sqrt_In_Truncated=out UInt(32 bits)

        val ScaleA_Fifo_Popfire=out Bool()
        val Recipro_Sqrt_Result=in UInt(32 bits)
        val Recipro_Sqrt_Result_Valid=in Bool()

        val mData=master Stream(SInt(8 bits))
    }
    noIoPrefix()
    //使用Ptf量化因子，对输入的8bit进行移位操作，变成11bit定点


    
    val Fsm=SUM_XQ_FSM(io.start&&(!RegNext(io.start)))
    val Init_Count=ForLoopCounter(Fsm.currentState===SUM_XQ_ENUM.INIT,log2Up(5),5)//初始化数5下
    val Col_Cnt=ForLoopCounter(io.sData.valid&&io.sData.ready||Fsm.currentState===SUM_XQ_ENUM.FINISH_LAST_ROW, Config.CHANNEL_NUMS_WIDTH, io.Channel_Nums-1)//创建输入数据的列计数器
    val Row_Cnt=ForLoopCounter(Col_Cnt.valid, Config.TOKEN_NUMS_WIDTH, io.Token_Nums-1)//创建输入数据行计数器                                                            
                                                                //Row_Cnt的值对应的是当前正在处理的行数，所以这里不该减一
    Fsm.Init_End:=Init_Count.valid
    
    Fsm.Load_Firts_Row_End:=(Row_Cnt.count===0)&&Col_Cnt.valid//当行计数为0时，说明处于第一行，当列计数拉高时，说明第一行加载完了
    Fsm.Accumu_End:=Row_Cnt.valid//当行计数器valid拉高，也就是说说明一个完整的矩阵数据已经进来了。
    Fsm.Last_Row_Finished:=Col_Cnt.valid//因为最后一行了，只要将缓存的XqC全部取出即可进行状态跳转

    io.sData.ready:=(Fsm.currentState=/=SUM_XQ_ENUM.IDLE)&&(Fsm.currentState=/=SUM_XQ_ENUM.INIT)&&(Fsm.currentState=/=SUM_XQ_ENUM.FINISH_LAST_ROW)//暂时只考虑到这么多，只要不处于这两个状态应该都能接受数据吧
    //创建一个mem用于缓存8行数据，因为A需要计算完均值再做减法===============================================================
    val Row_Mem=new Mem(SInt(Config.XQC_P_WIDTH bits),Config.MAX_CHANNEL_NUMS)//64位宽，384深度，用于存储sint的Xq*C
    

    val Read_Row_Mem_Data=Row_Mem.readSync(Col_Cnt.count,io.sData.fire||Fsm.currentState===SUM_XQ_ENUM.FINISH_LAST_ROW)//这里采用的就是：来一个数读一下
    
    
    //这里直接用最简单的本办法，让写入数据慢读出数据一拍，错开就不会有冲突了
        //之前想的是单独为读数据创建一个计数器，当读出多少数据后才开始写入新的数据，感觉有点麻烦
        //现在的策略就是来一个数据，先读再写，写慢读一拍


    //第二步骤，设计乘法流水线（需要大量调用xilinx的IP核)=============================================================================================
    
    //①计算x_q*c
    val Read_Row_Mem_Data_Valid=RegNext(io.sData.fire&&Fsm.currentState===SUM_XQ_ENUM.ACCUMU||(Fsm.currentState===SUM_XQ_ENUM.FINISH_LAST_ROW))//因为只有进入ACCUMU状态才开始计算上一层累加和之后的数据
    //sData.fire拉高，说明可以从Mem中读取数据，需要一个时钟，所以RegNext一下-->数据进来一个，sData.fire拉高，这时从Mem中读出一个数，在下一周期才有效
//只要位于FINISH_LAST_ROW状态，读出来的XqC数据都是有效的
    // val XqC_Module=new XqC
    // val XqC_Module=new Mul(Config.XQC_A_WIDTH,Config.XQC_B_WIDTH,Config.XQC_P_WIDTH,"signed","unsigned",3,"DSP",this.clockDomain,"Xqc",Config.XQC_P_WIDTH-1,0,true)
    val XqC_Module=Mul(Config.XQC_A_WIDTH,Config.XQC_B_WIDTH,Config.XQC_P_WIDTH,"signed","unsigned",Config.XQC_PIPELINE,"DSP",this.clockDomain,"XqC",Config.XQC_P_WIDTH-1,0,true)
    // val Xq2C_ABCP=new Xq2C_1
    val Xq2C_Module=Mul(Config.XQ2C_A_WIDTH,Config.XQ2C_B_WIDTH,Config.XQ2C_P_WIDTH,"signed","signed",Config.XQ2C_PIPELINE,"DSP",this.clockDomain,"Xq2C",Config.XQ2C_P_WIDTH-1,0,true)
    XqC_Module.io.A:=io.sData.payload//读出上一行的数据参与计算
    XqC_Module.io.B:=io.Channel_Nums
    //XqC计算结果写回=======================================================
    val XqC_Valid=Delay(io.sData.fire,Config.XQC_PIPELINE)
    val Write_Row_Mem_Data=XqC_Module.io.P.asSInt//要写入的数据应该是XqC这个数据

    val Write_Row_Mem_Valid=XqC_Valid
    val Write_Row_Mem_Addr=Delay(Col_Cnt.count,Config.XQC_PIPELINE)
    Row_Mem.write(Write_Row_Mem_Addr,Write_Row_Mem_Data,Write_Row_Mem_Valid)//使用读优先策略，要求先读再写，先读出旧的Xq再写入新的Xq
    //累加和计算=============================================================
    val Xq_Sum=Reg(SInt(Config.XQ_SUM_WIDTH bits))init(0)
    val Xq_Sum_Clear=RegNext(Col_Cnt.valid)//累加和清零,延一拍


    when(io.sData.fire){//如果当前数据有效，需要判断是继续累加还是重新开始累加
        when(Xq_Sum_Clear){
            Xq_Sum:=io.sData.payload.resized
        }otherwise{
            Xq_Sum:=Xq_Sum+io.sData.payload.resized
        }
    }
    
    //Xq2C计算==============================================================
    Xq2C_Module.io.A<>(XqC_Module.io.P).asSInt
    Xq2C_Module.io.B:=Delay(io.sData.payload,Config.XQC_PIPELINE)
    

    //平方和计算=============================================================
    val Xq2C_Sum=Reg(UInt(Config.XQ2C_SUM_WIDTH bits))init(0)//累加和32bit位宽可能不够，。。。。
    val Xq2C_Valid=Delay(XqC_Valid,Config.XQ2C_PIPELINE)
    val Xq2C_Sum_Clear=Delay(Xq_Sum_Clear,Config.XQ2C_PIPELINE+Config.XQC_PIPELINE)//Xq进来，valid拉高，计算累加和，Xq然后和C计算，延迟XqC_Pipeline拍，出来的结果继续和Xq计算，延迟Xq2c_Pipeline拍

    when(Xq2C_Valid){//如果当前数据有效，需要判断是继续累加还是重新开始累加
        when(Xq2C_Sum_Clear){
            Xq2C_Sum:=(Xq2C_Module.io.P.asUInt).resized
        }otherwise{
            Xq2C_Sum:=Xq2C_Sum+(Xq2C_Module.io.P.asUInt).resized
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
    val XqC_Substract_M2=(Read_Row_Mem_Data.resize(Config.XQ_SUBSTRACT_M2_WIDTH)-Xq_Sum_Old.resize(Config.XQ_SUBSTRACT_M2_WIDTH))//⭐应该是有符号类型，补码表示，他智能//需要单独为其设置位宽，先拿32bit来试试
    //这里由于XqC是有符号数，M2也是有符号数，两数相减存在位宽扩大的情况，所以需要在做减法之前提前符号位扩展
    //计算C*M2-M1^2==========================================================================
        //M1^2(这地方可以给乘法器加一个时钟使能，以后再说)
    // val XqSum_Pow=new Xq_Sum_Pow
    val XqSum_Pow=Mul(Config.XQ_SUM_WIDTH,Config.XQ_SUM_WIDTH,2*Config.XQ_SUM_WIDTH,"signed","signed",Config.XQ_SUM_POW_PIPELINE,"DSP",this.clockDomain,"Xq_Sum_Pow",2*Config.XQ_SUM_WIDTH-1,0,true)
    XqSum_Pow.io.A:=Xq_Sum_Old
    XqSum_Pow.io.B:=Xq_Sum_Old//Xq_Sum_Old慢Xq_Sum一拍，这样的话下面Xq_Sum_Pow_Valid要多打一拍，
    val Xq_Sum_Pow_Valid=Delay(Xq_Sum_Clear,Config.XQ_SUM_POW_PIPELINE+1)//40bit
        //获取上一行的C*M2
    //val Xq2C_Sum_Last=RegNextWhen(Xq2C_Sum,Xq2C_Sum_Clear)init(0)
        //计算上一行数据CM2-M1^2作为根号输入
    val Sqrt_Out_Valid=RegNext(Xq2C_Sum_Clear)//维持一个周期，但是如果是多并行度的话，只要有一个好了，那么其他的都好了
    io.Sqrt_Out_Valid:=Sqrt_Out_Valid
    val Sqrt_In=RegNextWhen(Xq2C_Sum-XqSum_Pow.io.P.asUInt,Xq2C_Sum_Clear)init(0)//这样写会出来毛刺，，，，，，
    //分析发现Xq2C的结果是最后出来的，所以当Xq2C最后被算出来，CXq-M2,Xq_Sum,Xq_Sum_Pow都被算出来了
    val Sqrt_In_Truncated=Sqrt_In(31 downto 0)//这里为什么要取后32位而不是前32位？（半后年再看这行代码看不懂了，23、5、22，已解决）
    val Truncated_Success=Sqrt_In===Sqrt_In_Truncated//先转32单精度，再执行根号下分之一计算，得到单精度浮点
    io.Sqrt_In_Truncated:=Sqrt_In_Truncated

    //在算根号分之一的时候计算算S*A===============================================
    // val Scale_Mul_A=new Scale_Multiply_A
    val Scale_Mul_A=Mul(Config.XQ_SUBSTRACT_M2_WIDTH,Config.SCALE_WIDTH,Config.SCALE_WIDTH+Config.XQ_SUBSTRACT_M2_WIDTH,"signed","signed",Config.SCALE_A_PIPELINE,"DSP",this.clockDomain,"Scale_Multiply_A",Config.SCALE_WIDTH+Config.XQ_SUBSTRACT_M2_WIDTH-1,0,true)
    Scale_Mul_A.io.A:=XqC_Substract_M2
    Scale_Mul_A.io.B:=io.Scale
    io.Scale_Read_Addr:=Col_Cnt.count//目前认为Scale和Bias从外面输入，也就是说Scale和Bias已经在外面存好了，现在只要给外面的存储模块一个读地址就能将对应的Scale和Bias读进来
    val Scale_Mul_A_Valid=Delay(Read_Row_Mem_Data_Valid,Config.SCALE_A_PIPELINE)//Scale*A 的valid标志，读出来的XqC直接进Scale*A计算模块计算，所以Scale*A的结果valid需要延迟一下

    //有一种可能，Scale*A算完了，ReciproSqrt还没算完，需要Scale*A的数据进行缓存一下
    val ScaleMulA_Fifo=new Scale_A_Fifo(SInt(Config.SCALE_WIDTH+Config.XQ_SUBSTRACT_M2_WIDTH bits),128)
    ScaleMulA_Fifo.io.push.payload:=Scale_Mul_A.io.P.asSInt//缓存一下Scale*A的值
    ScaleMulA_Fifo.io.push.valid:=Scale_Mul_A_Valid
    ScaleMulA_Fifo.io.pop.ready:=io.Recipro_Sqrt_Result_Valid//当Recipro_Sqrt被算完了，就可以从fifo中出数了
    io.ScaleA_Fifo_Popfire:=ScaleMulA_Fifo.io.pop.fire

    // val ScaleA_Mul_ReSqrt=new Scale_A_ReciproSqrt
    val ScaleA_Mul_ReSqrt=Mul(Config.SCALE_A_RECIPROSQRT_Aport_WIDTH,Config.SCALE_A_RECIPROSQRT_Bport_WIDTH,Config.SCALE_A_RECIPROSQRT_Pport_WIDTH,"signed","unsigned",Config.SCALE_A_RECIPROSQRT_PIPELINE,"DSP",this.clockDomain,"Scale_A_ReciproSqrt",Config.SCALE_A_RECIPROSQRT_Pport_WIDTH-1,0,true)
    ScaleA_Mul_ReSqrt.io.A:=ScaleMulA_Fifo.io.pop.payload
    ScaleA_Mul_ReSqrt.io.B:=U"1'b1"@@(io.Recipro_Sqrt_Result(22 downto 0))//拿到尾数部分
    val ScaleA_Mul_ReSqrt_Result_Valid=Delay(ScaleMulA_Fifo.io.pop.fire,Config.SCALE_A_RECIPROSQRT_PIPELINE)
    

    //拿到结果后执行动态移位再加上Bias
    //由于Scale不能和Bias同时进来，所以需要对Bias的读取额外处理一下
    val Exp_Part=io.Recipro_Sqrt_Result(30 downto 23)//指数部分
    val Right_Shift_Num0=150-Exp_Part
    val SAB_Shifted=(ScaleA_Mul_ReSqrt.io.P).asSInt>>Delay(Right_Shift_Num0,Config.SCALE_A_RECIPROSQRT_PIPELINE)//这里位宽会不会超？
    val SAB_Add_Bias=SAB_Shifted+io.Bias
    val SAB_Add_Bias_Truncated=SAB_Add_Bias(7 downto 0)//加完bias咋就变成8bit了。。。

    io.mData.payload:=SAB_Add_Bias_Truncated
    io.mData.valid:=ScaleA_Mul_ReSqrt_Result_Valid
}


class Reci_Sqrt_Compute extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val Channel_Nums=in UInt(Config.CHANNEL_NUMS_WIDTH bits)
        val Token_Nums=in UInt(Config.TOKEN_NUMS_WIDTH bits)
        val Sqrt_In_Valid=in Vec(Bool(),8)
        val Sqrt_In_Truncated=in Vec(UInt(32 bits),Config.LAYERNORM_PIPELINE)
        val ScaleA_Fifo_Popfire=in Bool()
    
        val Recipro_Sqrt_Result_Latch=out Vec(UInt(32 bits),Config.LAYERNORM_PIPELINE)
        val Recipro_Sqrt_Result_Valid=out Bool()
        val Bias_Read_Addr=out UInt(Config.CHANNEL_NUMS_WIDTH bits)

        val mLast=out Bool()
        
    }
    noIoPrefix()
//开始计算根号下分之一，先转单精度再计算
    val Fi32_2_Single=new Fi32_to_Single
    val Reci_Sqrt=new Reciprocal_Sqrt
    Fi32_2_Single.m_axis_result<>Reci_Sqrt.s_axis_a

    Reci_Sqrt.m_axis_result.tready:=True
    


    //理论上来说8个点是同步的，所以需要对8个点的入fifo冲突进行处理
    //考虑到之后多并行度需要共用一个根号分之一模块,从而能节省72-9个DSP
    //先算进第一个点
    val Sqrt_Compute_Fsm=new SQRT_COMPUTE_FSM//Sqrt_Compute_Fsm由Sqrt_In_valid控制，下面的SAB状态则算完根号分之一后启动
    Sqrt_Compute_Fsm.Send_Data(0):=io.Sqrt_In_Valid(0)&&Fi32_2_Single.s_axis_a.tready//意思是：发送第0个数据进行根号分之1计算，
    //实际上Compute1~8才开始发送Sqrt
    for(i<-1 to 8){
        Sqrt_Compute_Fsm.Send_Data(i):=Fi32_2_Single.s_axis_a.tready//只用tready的原因：以为上层模块只要有一个模块的sqrt_valid拉高，那么说明其他模块的Sqrt_out都算完了
    }
//计算Scale*A*B=============================================================

    val Recipro_Pointer_Result=ForLoopCounter(Reci_Sqrt.m_axis_result.tvalid,log2Up(Config.LAYERNORM_PIPELINE),Config.LAYERNORM_PIPELINE-1)
    //这个Pointer是用来标识计算完的根号分之一结果的
    val Recipro_Sqrt_Result_Latch=out Vec(UInt(32 bits),Config.LAYERNORM_PIPELINE)//由于Recipro_Sqrt出来的有效结果只会保持一个周期，所以得缓存一下


    // Exp_Part:=(Reci_Sqrt.m_axis_result.tvalid&&(Recipro_Pointer.count===0))?(Reci_Sqrt.m_axis_result.tdata(30 downto 23))|RegNext(Exp_Part)
    // val SAB_Fsm=ScaleA_Mul_Resqrt_Fsm(Recipro_Pointer_Result.count===Config.LAYERNORM_PIPELINE-1)//最后还是决定等8个sqrt都算完了才启动后面的计算，因为后面还得读取Bias，8个sqrt对齐后读取bias就会变得方便一些
        //23/5/23修了一个bug↑
    val SAB_Fsm=ScaleA_Mul_Resqrt_Fsm(Recipro_Pointer_Result.valid)//最后还是决定等8个sqrt都算完了才启动后面的计算，因为后面还得读取Bias，8个sqrt对齐后读取bias就会变得方便一些

    val SAB_Cnt=ForLoopCounter(io.ScaleA_Fifo_Popfire,Config.CHANNEL_NUMS_WIDTH,io.Channel_Nums-1)//当Fifo出了384个点后，一行就算完了
    SAB_Fsm.ScaleA_Mul_ReSqrt_End:=SAB_Cnt.valid

    io.Recipro_Sqrt_Result_Valid:=(SAB_Fsm.currentState===SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID)||(SAB_Fsm.currentState===SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID_AGAIN)
    io.Bias_Read_Addr:=ForLoopCounter(SAB_Fsm.currentState===SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID,Config.CHANNEL_NUMS_WIDTH,io.Channel_Nums-1).count//Delay(SAB_Cnt.count,Config.SCALE_A_RECIPROSQRT_PIPELINE-1)//减一的原因：外部读取Bias需要一个周期
    for(i<-0 to Config.LAYERNORM_PIPELINE-1){
        Recipro_Sqrt_Result_Latch(i):=(Reci_Sqrt.m_axis_result.tvalid&&(Recipro_Pointer_Result.count===i))?(Reci_Sqrt.m_axis_result.tdata)|RegNext(Recipro_Sqrt_Result_Latch(i))
        io.Recipro_Sqrt_Result_Latch(i):=((RegNext(SAB_Cnt.valid)&&SAB_Fsm.currentState===SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID)||SAB_Fsm.currentState===SCALEA_MUL_RESQRT_ENUM.IDLE)?Recipro_Sqrt_Result_Latch(i)|RegNext(io.Recipro_Sqrt_Result_Latch(i))
//如果下层还在计算SAB，也就是下层比上层慢，只有当SAB计算完才能切换ReciSqrt
//如果下层处于idle状态，也就是下层算得比上层快，在等ReciSqrt，那么这时只要ResqrtValid来了即可切换Resqrt
    }



    //=======================================================================================================
    switch(Sqrt_Compute_Fsm.currentState){//这里控制定点转浮点模块
        for(i <-1 to Config.LAYERNORM_PIPELINE){
            is(SQRT_COMPUTE_ENUM.COMPUTE(i)){
                //Fi32_2_Single.s_axis_a.tdata:=io.Sqrt_In_Truncated(i)//有一种可能Fi32_2_Single还没准备好但是累加和已经计算好了这种可能，，，
                Fi32_2_Single.s_axis_a.tvalid:=True//只会拉高一个周期
            }
        }
        default{
            Fi32_2_Single.s_axis_a.tvalid:=False
        }   
    }
    val Recipro_Pointer_DataIn=ForLoopCounter(Fi32_2_Single.s_axis_a.tvalid&&Fi32_2_Single.s_axis_a.tready,log2Up(Config.LAYERNORM_PIPELINE),Config.LAYERNORM_PIPELINE-1)
    if(Config.LAYERNORM_PIPELINE==1){Fi32_2_Single.s_axis_a.tdata:=io.Sqrt_In_Truncated(0)}else{Fi32_2_Single.s_axis_a.tdata:=Recipro_Pointer_DataIn.count.muxList(for(i <- 0 until Config.LAYERNORM_PIPELINE) yield (i, io.Sqrt_In_Truncated(i)))}
                                                                //这里改成muxListDc也行，需要研究研究
    val Row_Cnt=ForLoopCounter(SAB_Cnt.valid,Config.TOKEN_NUMS_WIDTH,io.Token_Nums-1)//加一个这个是为了最后计算完了状态跳转
                                                                                      //这里也是得减一                                                                        
    SAB_Fsm.Row_All_Computed:=Row_Cnt.valid&&SAB_Cnt.valid//当处于最后一行并且最后一列算完了
    io.mLast:=SAB_Fsm.Row_All_Computed
}

class LayerNorm_Module extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        val sData=in Vec( SInt(Config.XQ_DATA_WIDTH bits),Config.LAYERNORM_PIPELINE)//输入数据88bit，一次进8行，每行一个点（8bit),进来的数据为Xq-Zeropoint的值，所以是有符号数据
        val sValid=in Bool()
        val sReady=out Bool()
        val start=in Bool()//计算启动信号

        val Channel_Nums=in UInt(Config.CHANNEL_NUMS_WIDTH bits)//12bit--最大4095
        val Token_Nums=in UInt(Config.TOKEN_NUMS_WIDTH bits)

        val Bias_Read_Addr=out UInt(Config.CHANNEL_NUMS_WIDTH bits)
        val Scale_Read_Addr=out UInt(Config.CHANNEL_NUMS_WIDTH bits)
        val Scale=in SInt(8 bits)//暂时让Scale和Bias作为输入
        val Bias=in SInt(8 bits)//不知道8bit够不够用，planB就是之后将8bit改为32bit

        val mData=master Stream(SInt(8*Config.LAYERNORM_PIPELINE bits))
        val mLast=out Bool()
    }
    noIoPrefix()

    val Stage2=new Reci_Sqrt_Compute//一个模块用于计算根号分之一
    val Stage1=Array.tabulate(Config.LAYERNORM_PIPELINE)(i=>{
        def gen():Sum_Xq={
            val Stage1=new Sum_Xq
            //Stage1与顶层Io接口连接=============================
            // Stage1.io.sData.payload<>io.sData.payload((Config.XQ_DATA_WIDTH)*(i+1)-1 downto Config.XQ_DATA_WIDTH*i)
            // Stage1.io.sData.payload<>io.sData.payload((Config.XQ_DATA_WIDTH)*(i+1)-1 downto (Config.XQ_DATA_WIDTH)*i)//-5是因为因为测试数据生成的是16bit*8，但是我们只取其中的11bit即可
            Stage1.io.sData.payload<>io.sData(i)

            Stage1.io.sData.valid<>io.sValid

            Stage1.io.start:=io.start
            Stage1.io.Channel_Nums:=io.Channel_Nums
            Stage1.io.Token_Nums:=io.Token_Nums
            Stage1.io.Scale:=io.Scale
            Stage1.io.Bias:=Delay(io.Bias,Config.SCALE_A_RECIPROSQRT_PIPELINE-1)//减一的原因：待更新
            //Stage1和Stage2之间的连接===========================
            Stage1.io.Sqrt_In_Truncated<>Stage2.io.Sqrt_In_Truncated(i)
            Stage1.io.Sqrt_Out_Valid<>Stage2.io.Sqrt_In_Valid(i)
            
            Stage1.io.Recipro_Sqrt_Result<>Stage2.io.Recipro_Sqrt_Result_Latch(i)
            Stage1.io.Recipro_Sqrt_Result_Valid<>Stage2.io.Recipro_Sqrt_Result_Valid
            Stage1.io.mData.payload<>io.mData.payload(8*(i+1)-1 downto 8*i)
            Stage1
        }
        gen()
    })
    Stage1(0).io.ScaleA_Fifo_Popfire<>Stage2.io.ScaleA_Fifo_Popfire
    Stage1(0).io.sData.ready<>io.sReady
    Stage1(0).io.Scale_Read_Addr<>io.Scale_Read_Addr
    //根号分之一与顶层接口连接============================
    Stage2.io.Bias_Read_Addr<>io.Bias_Read_Addr
    Stage2.io.Channel_Nums:=io.Channel_Nums
    Stage2.io.Token_Nums    :=io.Token_Nums
    io.mData.valid:=Stage1(0).io.mData.valid
    io.mLast:=Stage2.io.mLast
}

object LayerNorm_Status extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_QUANT_DATA,WAIT_END = newElement
    //LOAD_QUANT_DATA:加载量化参数
    //WAIT_END:等待量化计算和数据输出结束
}
case class LayerNorm_Fsm(start:Bool)extends Area{
    val currentState = Reg(LayerNorm_Status()) init LayerNorm_Status.IDLE
    val nextState = LayerNorm_Status()
    currentState := nextState

    val Init_End=Bool()
    val QuantData_Loaded=Bool()//量化参数加载完毕
    val Compute_End=Bool()//计算结束
    switch(currentState){
        is(LayerNorm_Status.IDLE){
            when(start){
                nextState:=LayerNorm_Status.INIT
            }otherwise{
                nextState:=LayerNorm_Status.IDLE
            }
        }
        is(LayerNorm_Status.INIT){
            when(Init_End){
                nextState:=LayerNorm_Status.LOAD_QUANT_DATA
            }otherwise{
                nextState:=LayerNorm_Status.INIT
            }
        }
        is(LayerNorm_Status.LOAD_QUANT_DATA){
            when(QuantData_Loaded){
                nextState:=LayerNorm_Status.WAIT_END
            }otherwise{
                nextState:=LayerNorm_Status.LOAD_QUANT_DATA
            }
        }
        is(LayerNorm_Status.WAIT_END){
            when(Compute_End){
                nextState:=LayerNorm_Status.IDLE
            }otherwise{
                nextState:=LayerNorm_Status.WAIT_END
            }
        }
    }
}
class LayerNorm_Top extends Component{
    //添加Scale，Bias的缓存模块
    val Config=TopConfig()
    val io=new Bundle{
        val sData=in Vec( SInt(Config.XQ_DATA_WIDTH bits),Config.LAYERNORM_PIPELINE)
        val sValid=in Bool()
        val sReady=out Bool()
        val start=in Bool()//计算启动信号
        val Channel_Nums=in UInt(Config.CHANNEL_NUMS_WIDTH bits)//12bit--最大4095
        val Token_Nums=in UInt(Config.TOKEN_NUMS_WIDTH bits)//TokenNums 的值由外部编译器给出,比如197行矩阵,如果并Pipeline设置为1,那么这里的值是197
        //如果PipeLine设置为8,那么这里的值是25,计算公式为ceil(TokenNums/Pipeline)

        val ScaleBias_sValid=in Bool()
        val ScaleBias_sReady=out Bool()
        val Scale=in SInt(8 bits)//暂时让Scale和Bias作为输入
        val Bias=in SInt(8 bits)//不知道8bit够不够用，planB就是之后将8bit改为32bit
        val mData=master Stream(SInt(8*Config.LAYERNORM_PIPELINE bits))
        val mLast=out Bool()

    }
    val SubModule=new LayerNorm_Module
    noIoPrefix()
    val Fsm=LayerNorm_Fsm(io.start)
    val Init_Count=ForLoopCounter(Fsm.currentState===LayerNorm_Status.INIT,log2Up(5),5)//初始化数5下
    Fsm.Init_End:=Init_Count.valid

    val QuantCache_Cnt=ForLoopCounter(io.ScaleBias_sValid&&io.ScaleBias_sReady,Config.CHANNEL_NUMS_WIDTH,io.Channel_Nums-1)
    Fsm.QuantData_Loaded:=QuantCache_Cnt.valid
    val ScaleMem=new xil_SimpleDualBram(8,1024,8,"ScaleMem",true)
    val BiasMem=new xil_SimpleDualBram(8,1024,8,"ScaleMem",false)

    ScaleMem.io.dina        :=io.Scale.asUInt
    ScaleMem.io.addra       :=QuantCache_Cnt.count
    ScaleMem.io.ena         :=io.ScaleBias_sValid&&io.ScaleBias_sReady
    ScaleMem.io.addrb       :=SubModule.io.Scale_Read_Addr
    ScaleMem.io.wea          :=True

    BiasMem.io.dina         :=io.Bias.asUInt
    BiasMem.io.addra        :=QuantCache_Cnt.count
    BiasMem.io.ena          :=io.ScaleBias_sValid&&io.ScaleBias_sReady
    BiasMem.io.addrb        :=SubModule.io.Bias_Read_Addr
    BiasMem.io.wea          :=True

    SubModule.io.Scale          :=ScaleMem.io.doutb.asSInt
    SubModule.io.Bias           :=BiasMem.io.doutb.asSInt
    SubModule.io.Channel_Nums   :=io.Channel_Nums
    SubModule.io.Token_Nums     :=io.Token_Nums
    SubModule.io.mData          <>io.mData
    SubModule.io.sData          :=io.sData
    SubModule.io.sValid         :=io.sValid
    io.sReady                   :=SubModule.io.sReady
    SubModule.io.start          :=Fsm.QuantData_Loaded

    when(Fsm.currentState===LayerNorm_Status.LOAD_QUANT_DATA){
        io.ScaleBias_sReady:=True
    }otherwise{
        io.ScaleBias_sReady:=False
    }

    io.mLast:=SubModule.io.mLast
    Fsm.Compute_End:=SubModule.io.mLast


}
// class LayerNorm_Top extends Component{
//     val LN_Compute=new LayerNorm_Module

//     val io=new Bundle{
//         val m_axis_mm2s_tdata=out SInt(64 bits)
//         val m_axis_mm2s_tkeep=out Bits(4 bits)
//         val m_axis_mm2s_tlast=out Bool()
//         val m_axis_mm2s_tready=in Bool()
//         val m_axis_mm2s_tvalid=out Bool()

//         val s_axis_s2mm_tdata=in SInt(128 bits)
//         val s_axis_s2mm_tkeep=in Bits(4 bits)
//         val s_axis_s2mm_tlast=in Bool()
//         val s_axis_s2mm_tready=out Bool()
//         val s_axis_s2mm_tvalid=in Bool()


//         val start=in Bool()
        
//     }
//     noIoPrefix()
//     LN_Compute.io.mData.payload<>io.m_axis_mm2s_tdata
//     LN_Compute.io.mData.ready<>io.m_axis_mm2s_tready
//     LN_Compute.io.mData.valid<>io.m_axis_mm2s_tvalid
//     LN_Compute.io.m_tlast<>io.m_axis_mm2s_tlast
//     io.m_axis_mm2s_tkeep:=B"4'b1111"

//     LN_Compute.io.sData.payload<>io.s_axis_s2mm_tdata
//     LN_Compute.io.sData.ready<>io.s_axis_s2mm_tready
//     LN_Compute.io.sData.valid<>io.s_axis_s2mm_tvalid

//     Med_Sort.io.m_tlast<>io.m_tlast
//     LN_Compute.io.start<>io.start
// }

object Sum_Xq_Gen extends App { //到目前为止,layernorm需要80的dsp
    val verilog_path="./Simulation/SimLayerNorm/verilog" 
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Sum_Xq)
    // SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Reci_Sqrt_Compute)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new LayerNorm_Top)

    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}
