package LayerNorm
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
//实现8并行度的累加计算
object SUM_XQ_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_FIRST_ROW,ACCUMU = newElement
    //LOAD_FIRTS_ROW:加载第一行，这时候计算第一行的累加和和C*X_Q
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
object SQRT_COMPUTE_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val WAIT, COMPUTE0, COMPUTE1,COMPUTE2,COMPUTE3,COMPUTE4,COMPUTE5,COMPUTE6,COMPUTE7 = newElement
    //WAIT:等待进Sqrt的有效数据
    //COMPUTE0:计算第一个并行度的sqrt，分8次计算，没必要要为了8并行度消耗8*9=72个DSP
}
case class SQRT_COMPUTE_FSM()extends Area{
    val currentState = Reg(SQRT_COMPUTE_ENUM()) init SQRT_COMPUTE_ENUM.WAIT
    val nextState = SQRT_COMPUTE_ENUM()
    currentState := nextState

    val Send0_Data=Bool()
    val Send1_Data=Bool()
    val Send2_Data=Bool()
    val Send3_Data=Bool()
    val Send4_Data=Bool()
    val Send5_Data=Bool()
    val Send6_Data=Bool()
    val Send7_Data=Bool()
    val Data_Sended=Bool()



    switch(currentState){
        is(SQRT_COMPUTE_ENUM.WAIT){
            when(Send0_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE0
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.WAIT
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE0){
            when(Send1_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE1
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE0
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE1){
            when(Send2_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE2
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE1
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE2){
            when(Send3_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE3
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE2
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE3){
            when(Send4_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE4
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE3
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE4){
            when(Send5_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE5
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE4
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE5){
            when(Send6_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE6
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE5
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE6){
            when(Send7_Data){
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE7
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE6
            }
        }
        is(SQRT_COMPUTE_ENUM.COMPUTE7){
            when(Data_Sended){
                nextState:=SQRT_COMPUTE_ENUM.WAIT
            }otherwise{
                nextState:=SQRT_COMPUTE_ENUM.COMPUTE7
            }
        }
    }
}
object SCALEA_MUL_RESQRT_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, RESQRT_VALID= newElement
}
case class ScaleA_Mul_Resqrt_Fsm(start:Bool) extends Area{
    val currentState = Reg(SCALEA_MUL_RESQRT_ENUM()) init SCALEA_MUL_RESQRT_ENUM.IDLE
    val nextState = SCALEA_MUL_RESQRT_ENUM()
    currentState := nextState

    val ScaleA_Mul_ReSqrt_End=Bool()
    switch(currentState){
        is(SCALEA_MUL_RESQRT_ENUM.IDLE){
            when(start){
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID
            }otherwise{
                nextState:=SCALEA_MUL_RESQRT_ENUM.IDLE
            }
        }
        is(SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID){
            when(ScaleA_Mul_ReSqrt_End){
                nextState:=SCALEA_MUL_RESQRT_ENUM.IDLE
            }otherwise{
                nextState:=SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID
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
        val sData=slave Stream( SInt(Config.IN_DATA_WIDTH bits))//输入数据88bit，一次进8行，每行一个点（8bit),进来的数据为Xq-Zeropoint的值，所以是有符号数据
        val start=in Bool()//计算启动信号

        val Channel_Nums=in UInt(Config.CHANNEL_NUMS_WIDTH bits)//12bit--最大4095

        val Bias_Read_Addr=out UInt(log2Up(Config.CHANNEL_NUMS) bits)
        val Scale_Read_Addr=out UInt(log2Up(Config.CHANNEL_NUMS) bits)
        val Scale=in SInt(8 bits)//暂时让Scale和Bias作为输入
        val Bias=in SInt(8 bits)//不知道8bit够不够用，，planB就是之后将8bit改为32bit
    }
    noIoPrefix()
    //使用Ptf量化因子，对输入的8bit进行移位操作，变成11bit定点


    
    val Fsm=SUM_XQ_FSM(io.start&&(!RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===SUM_XQ_ENUM.INIT,log2Up(5),5)//初始化数5下
    val Col_Cnt=WaCounter(io.sData.valid&&io.sData.ready, log2Up(Config.CHANNEL_NUMS), Config.CHANNEL_NUMS-1)//创建输入数据的列计数器
    val Row_Cnt=WaCounter(Col_Cnt.valid, log2Up(Config.TOKEN_NUMS), Config.TOKEN_NUMS-1)//创建输入数据行计数器
    
    
    Fsm.Init_End:=Init_Count.valid
    Fsm.Load_Firts_Row_End:=(Row_Cnt.count===0)&&Col_Cnt.valid//当行计数为0时，说明处于第一行，当列计数拉高时，说明第一行加载完了
    Fsm.Accumu_End:=Row_Cnt.valid//当行计数器valid拉高，也就是说说明一个完整的矩阵数据已经进来了。

    io.sData.ready:=(Fsm.currentState=/=SUM_XQ_ENUM.IDLE)&&(Fsm.currentState=/=SUM_XQ_ENUM.INIT)//暂时只考虑到这么多，只要不处于这两个状态应该都能接受数据吧
    //创建一个mem用于缓存8行数据，因为A需要计算完均值再做减法===============================================================
    val Row_Mem=new Mem(SInt(Config.XQC_P_WIDTH bits),Config.CHANNEL_NUMS)//64位宽，384深度，用于存储sint的Xq*C
    

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
    
    XqC_Module.io.A:=io.sData.payload(Config.XQ_DATA_WIDTH-1 downto 0)//读出上一行的数据参与计算
    XqC_Module.io.B:=io.Channel_Nums
    //XqC计算结果写回=======================================================
    val XqC_Valid=Delay(io.sData.fire,Config.XQC_PIPELINE)
    val Write_Row_Mem_Data=XqC_Module.io.P.resized//要写入的数据应该是XqC这个数据
    val Write_Row_Mem_Valid=XqC_Valid
    val Write_Row_Mem_Addr=Delay(Col_Cnt.count,Config.XQC_PIPELINE)
    Row_Mem.write(Write_Row_Mem_Addr,Write_Row_Mem_Data,Write_Row_Mem_Valid)//使用读优先策略，要求先读再写，先读出旧的Xq再写入新的Xq
    //累加和计算=============================================================
    val Xq_Sum=Reg(SInt(Config.XQ_SUM_WIDTH bits))init(0)
    val Xq_Sum_Clear=RegNext(Col_Cnt.valid)//累加和清零,延一拍


    when(io.sData.fire){//如果当前数据有效，需要判断是继续累加还是重新开始累加
        when(Xq_Sum_Clear){
            Xq_Sum:=io.sData.payload(Config.XQ_DATA_WIDTH-1 downto 0).resized
        }otherwise{
            Xq_Sum:=Xq_Sum+io.sData.payload(Config.XQ_DATA_WIDTH-1 downto 0).resized
        }
    }
    
    //Xq2C计算==============================================================
    Xq2C_Module.io.A:=XqC_Module.io.P
    Xq2C_Module.io.B:=Delay(io.sData.payload(Config.XQ_DATA_WIDTH-1 downto 0),Config.XQC_PIPELINE)
    

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
    val XqC_Substract_M2=(Read_Row_Mem_Data.resize(Config.XQ_SUBSTRACT_M2_WIDTH)-Xq_Sum_Old.resize(Config.XQ_SUBSTRACT_M2_WIDTH))//⭐应该是有符号类型，补码表示，他智能//需要单独为其设置位宽，先拿32bit来试试
    //这里由于XqC是有符号数，M2也是有符号数，两数相减存在位宽扩大的情况，所以需要在做减法之前提前符号位扩展
    //计算C*M2-M1^2==========================================================================
        //M1^2(这地方可以给乘法器加一个时钟使能，以后再说)
    val XqSum_Pow=new Xq_Sum_Pow
    XqSum_Pow.io.A:=Xq_Sum_Old
    XqSum_Pow.io.B:=Xq_Sum_Old//Xq_Sum_Old慢Xq_Sum一拍，这样的话下面Xq_Sum_Pow_Valid要多打一拍，
    val Xq_Sum_Pow_Valid=Delay(Xq_Sum_Clear,Config.XQ_SUM_POW_PIPELINE+1)//40bit
        //获取上一行的C*M2
    //val Xq2C_Sum_Last=RegNextWhen(Xq2C_Sum,Xq2C_Sum_Clear)init(0)
        //计算上一行数据CM2-M1^2作为根号输入
    val Sqrt_In_Valid=RegNext(Xq2C_Sum_Clear)
    val Sqrt_In=RegNextWhen(Xq2C_Sum-XqSum_Pow.io.P,Xq2C_Sum_Clear)init(0)//这样写会出来毛刺，，，，，，
    //分析发现Xq2C的结果是最后出来的，所以当Xq2C最后被算出来，CXq-M2,Xq_Sum,Xq_Sum_Pow都被算出来了
    val Sqrt_In_Truncated=Sqrt_In(31 downto 0)
    val Truncated_Success=Sqrt_In===Sqrt_In_Truncated//先转32单精度，再执行根号下分之一计算，得到单精度浮点



    
//开始计算根号下分之一，先转单精度再计算
    val Fi32_2_Single=new Fi32_to_Single
    val Reci_Sqrt=new Reciprocal_Sqrt
    Fi32_2_Single.m_axis_result<>Reci_Sqrt.s_axis_a

    Reci_Sqrt.m_axis_result.tready:=True
    


    //理论上来说8个点是同步的，所以需要对8个点的入fifo冲突进行处理
    //考虑到之后多并行度需要共用一个根号分之一模块,从而能节省72-9个DSP
    //先算进第一个点
    val Sqrt_Compute_Fsm=new SQRT_COMPUTE_FSM
    Sqrt_Compute_Fsm.Send0_Data:=Sqrt_In_Valid//意思是：发送第0个数据进行根号分之1计算，
    Sqrt_Compute_Fsm.Send1_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Send2_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Send3_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Send4_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Send5_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Send6_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Send7_Data:=Fi32_2_Single.s_axis_a.tready
    Sqrt_Compute_Fsm.Data_Sended:=Fi32_2_Single.s_axis_a.tready
    switch(Sqrt_Compute_Fsm.currentState){
        is(SQRT_COMPUTE_ENUM.COMPUTE0){
            Fi32_2_Single.s_axis_a.tdata:=Sqrt_In_Truncated//有一种可能Fi32_2_Single还没准备好但是累加和已经计算好了这种可能，，，
            Fi32_2_Single.s_axis_a.tvalid:=True//只会拉高一个周期
        }
        default{
            Fi32_2_Single.s_axis_a.tdata:=1
            Fi32_2_Single.s_axis_a.tvalid:=False
        }
    }
//在算根号分之一的时候计算算S*A===============================================
    val Scale_Mul_A=new Scale_Multiply_A
    Scale_Mul_A.io.A:=XqC_Substract_M2
    Scale_Mul_A.io.B:=io.Scale
    io.Scale_Read_Addr:=Col_Cnt.count//目前认为Scale和Bias从外面输入，也就是说Scale和Bias已经在外面存好了，现在只要给外面的存储模块一个读地址就能将对应的Scale和Bias读进来
    val Scale_Mul_A_Valid=Delay(Read_Row_Mem_Data_Valid,Config.SCALE_A_PIPELINE)//Scale*A 的valid标志，读出来的XqC直接进Scale*A计算模块计算，所以Scale*A的结果valid需要延迟一下
//计算Scale*A*B=============================================================
    //由于Recipro_Sqrt出来的有效结果只会保持一个周期，所以得缓存一下
    val Recipro_Pointer=WaCounter(Reci_Sqrt.m_axis_result.tvalid,Config.PIPELINE,log2Up(Config.PIPELINE))
    val Recipro_Sqrt_Result0_Latch=UInt(24 bits)//23bit尾数加1bit
    val Exp_Part=UInt(8 bits)
    Recipro_Sqrt_Result0_Latch:=(Reci_Sqrt.m_axis_result.tvalid&&(Recipro_Pointer.count===0))?(U"1'b1"@@Reci_Sqrt.m_axis_result.tdata(22 downto 0))|RegNext(Recipro_Sqrt_Result0_Latch)
    Exp_Part:=(Reci_Sqrt.m_axis_result.tvalid&&(Recipro_Pointer.count===0))?(Reci_Sqrt.m_axis_result.tdata(30 downto 23))|RegNext(Exp_Part)
    val SAB_Fsm=ScaleA_Mul_Resqrt_Fsm(Reci_Sqrt.m_axis_result.tvalid)//SAB即Scale*A*B
    val Recipro_Sqrt_Result0_Valid=SAB_Fsm.currentState===SCALEA_MUL_RESQRT_ENUM.RESQRT_VALID

    //有一种可能，Scale*A算完了，ReciproSqrt还没算完，需要Scale*A的数据进行缓存一下
    val ScaleMulA_Fifo=new Scale_A_Fifo(SInt(Config.SCALE_WIDTH+Config.XQ_SUBSTRACT_M2_WIDTH bits),128)
    ScaleMulA_Fifo.io.push.payload:=Scale_Mul_A.io.P//缓存一下Scale*A的值
    ScaleMulA_Fifo.io.push.valid:=Scale_Mul_A_Valid
    ScaleMulA_Fifo.io.pop.ready:=Recipro_Sqrt_Result0_Valid
    val SAB_Cnt=WaCounter(ScaleMulA_Fifo.io.pop.fire,log2Up(Config.CHANNEL_NUMS),Config.CHANNEL_NUMS-1)
    SAB_Fsm.ScaleA_Mul_ReSqrt_End:=SAB_Cnt.valid

    val ScaleA_Mul_ReSqrt=new Scale_A_ReciproSqrt
    ScaleA_Mul_ReSqrt.io.A:=ScaleMulA_Fifo.io.pop.payload
    ScaleA_Mul_ReSqrt.io.B:=Recipro_Sqrt_Result0_Latch
    val ScaleA_Mul_ReSqrt_Result_Valid=Delay(Recipro_Sqrt_Result0_Valid&&Recipro_Sqrt_Result0_Valid,Config.SCALE_A_RECIPROSQRT_PIPELINE)
    

    //拿到结果后执行动态移位再加上Bias
    //由于Scale不能和Bias同时进来，所以需要对Bias的读取额外处理一下
    io.Bias_Read_Addr:=Delay(SAB_Cnt.count,Config.SCALE_A_RECIPROSQRT_PIPELINE-1)//减一的原因：外部读取Bias需要一个周期
    val Right_Shift_Num0=150-Exp_Part
    val SAB_Shifted=ScaleA_Mul_ReSqrt.io.P>>Right_Shift_Num0
    val SAB_Add_Bias=SAB_Shifted+io.Bias
    val SAB_Add_Bias_Truncated=SAB_Add_Bias(7 downto 0)
}



object Sum_Xq_Gen extends App { 
    val verilog_path="./testcode_gen" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Sum_Xq)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}
