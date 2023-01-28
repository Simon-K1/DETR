package Systolic_Array
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
import java.awt.image.Kernel
import spinal.core.internals.Operator
class DataGen_Bram extends BlackBox{//黑盒，入32bit，出16 bit,Activation Bram，也就是SA左边挂的那块Bram
    val Config=TopConfig()
    val io=new Bundle{//component要求out有驱动，但是black box不要求out的驱动
        val clka=in Bool()
        val addra=in UInt(log2Up(Config.DATA_GENERATE_BRAM_IN_ADDR_DEPTH) bits)
        val dina=in UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits)
        val ena=in Bool()
        val wea=in Bool()

        
        val addrb=in UInt(log2Up(Config.DATA_GENERATE_BRAM_OUT_ADDR_DEPTH) bits)
        val doutb=out UInt((Config.DATA_GENERATE_BRAM_OUT_WIDTH) bits)
        val clkb=in Bool()
        
        // val enb=in Bool()        
    }
    noIoPrefix()
    // Clock A is map on a specific clock Domain
    mapClockDomain(this.clockDomain, io.clka)
    // Clock B is map on the current clock domain
    mapCurrentClockDomain(io.clkb)
}
object DATA_GENERATE_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, LOAD_FIRST_kROWs,SA_COMPUTE,UPDATE_FIFORd,WAIT_ROWs_TO_CACHE= newElement
    //LOAD_FIRST_kROWs:加载前K行,卷积核大小多大就加载多少行(这里是加载K行还是k-1行呢?)
        //可以是K-1行,这样又可以少一行的缓存时间
    //SA_COMPUTE:脉动阵列计算,8*8的脉动阵列输出64个点
    //WAIT_ROWs_TO_CACHE:如果输入通道比较大,那么完全可以在计算期间加载后面的数据,比如步长为1,则需要额外加载一行数据,16步长,就要加载16行数据
        //另外还存在一种情况,就是算完了数据还没缓存完,所以这里我们需要消耗一个周期来判断
    //UPDATE_FIFORd:后面新添加的状态，用来更新Row_Base_Addr Fifo
}
case class Data_GenerateFsm(start:Bool)extends Area{
    val currentState = Reg(DATA_GENERATE_ENUM()) init DATA_GENERATE_ENUM.IDLE
    val nextState = DATA_GENERATE_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Load_First_kROWs_End=Bool()
    val FifoRd_Updated=Bool()//处理完一行输出，接下来开始更新fifo,fifo更新完后开始等下一行缓存完成
    val SA_Compute_End=Bool()
    val All_Computed=Bool()
    val Row_Cached=Bool()//
    switch(currentState){
        is(DATA_GENERATE_ENUM.IDLE){
            when(start){
                nextState:=DATA_GENERATE_ENUM.INIT
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.IDLE
            }
        }
        is(DATA_GENERATE_ENUM.INIT){
            when(Init_End){
                nextState:=DATA_GENERATE_ENUM.LOAD_FIRST_kROWs
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.INIT
            }
        }
        is(DATA_GENERATE_ENUM.LOAD_FIRST_kROWs){
            when(Load_First_kROWs_End){
                nextState:=DATA_GENERATE_ENUM.SA_COMPUTE
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.LOAD_FIRST_kROWs
            }
        }
        is(DATA_GENERATE_ENUM.SA_COMPUTE){
            when(All_Computed){
                nextState:=DATA_GENERATE_ENUM.IDLE
            }elsewhen(SA_Compute_End){//这里的意思是脉动阵列处理完了一行数据
                nextState:=DATA_GENERATE_ENUM.UPDATE_FIFORd
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.SA_COMPUTE
            }
        }
        is(DATA_GENERATE_ENUM.UPDATE_FIFORd){
            when(FifoRd_Updated){
                nextState:=DATA_GENERATE_ENUM.WAIT_ROWs_TO_CACHE
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.UPDATE_FIFORd
            }
        }
        is(DATA_GENERATE_ENUM.WAIT_ROWs_TO_CACHE){
            when(Row_Cached){
                nextState:=DATA_GENERATE_ENUM.SA_COMPUTE
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.WAIT_ROWs_TO_CACHE
            }
        }
    }
}
object LOAD_KROWS_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, LOAD_NEXT_KROWs,WAITING= newElement
//LOAD_NEXT_KROWs:当脉动阵列处理完一行数据后，我们就可以加载后面的k行数据了
//WAITING:等待加载下一行状态
}
case class Load_KRows_Fsm(start:Bool)extends Area{
    val currentState = Reg(LOAD_KROWS_ENUM()) init LOAD_KROWS_ENUM.IDLE
    val nextState = LOAD_KROWS_ENUM()
    currentState := nextState
    val Krows_Loaded=Bool()
    val All_Rows_Loaded=Bool()
    switch(currentState){
        is(LOAD_KROWS_ENUM.IDLE){
            when(start){
                nextState:=LOAD_KROWS_ENUM.LOAD_NEXT_KROWs
            }otherwise{
                nextState:=LOAD_KROWS_ENUM.IDLE
            }
        }
        is(LOAD_KROWS_ENUM.LOAD_NEXT_KROWs){
            when( All_Rows_Loaded){
                nextState:=LOAD_KROWS_ENUM.IDLE//缓存完了就可以进入IDLE状态等计算计算接受结束
            }elsewhen(Krows_Loaded){
                nextState:=LOAD_KROWS_ENUM.WAITING
            }otherwise{
                nextState:=LOAD_KROWS_ENUM.LOAD_NEXT_KROWs
            }
        }
        is(LOAD_KROWS_ENUM.WAITING){
            when(start){
                nextState:=LOAD_KROWS_ENUM.LOAD_NEXT_KROWs
            }otherwise{
                nextState:=LOAD_KROWS_ENUM.WAITING
            }           
        }
    }

}
class WaddrOffset_Fifo extends StreamFifo(UInt(16 bits),32+1)//必须加一，比如我们需要实现16*16的卷积，如果fifo深度设置为32，32个fifo会被存满，fifo.push.ready会拉低,不能出现这种情况
class RaddrOffset_Fifo extends StreamFifo(UInt(16 bits),32)
//读写地址偏移的fifo需要被分开嘛？
class Data_Generate extends Component{
    //数据生成模块,Bram的空间应该能
    val Config=TopConfig()
    val io=new Bundle{//测试先用8bit位宽测试
        val start=in Bool()
        val sData=slave Stream(UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits))//Stream(UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits))//进来的数据给到Bram
        val mData=out UInt(Config.DATA_GENERATE_BRAM_OUT_WIDTH bits)
        val mValid=out Bool()
        val mLast=out Bool()
        //Conv相关
        //默认所有可配置参数都是正确的,比如要不要Padding,Padding多少,Stride多少?如果不满足条件,那就是算法那边背锅
            //这里不做错误判断
            //默认所有配置参数位宽均为32bit
        val Stride=in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size=in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size=in UInt(16 bits)
            //所谓WindowSize,比如一个16*16的卷积,那么一个滑动窗口的大小就是16,但是需要考虑输入通道,比如256的输入通道,那么这时输入的Window_Size就是16*256(对应的是滑动窗口一行数据点),只支持方形卷积
            //除了考虑输入通道，还要考虑输入数据的并行度，比如如果一下进8个点，也就是8个通道，虽然实际我们进的是224*224*3的图片，
            //但是我们不能简单的将Window_Size设置为16*3，应该还是设置为16，因为3通道不够，需要补零成8通道
            //这时我们的WindowSize还是1，如果输入通道是9，那么我们的Window_Size就是16*2，9通道继续补零成16通道，有7个通道冗余
            //总的来说Window_Size的实际计算公式应该是：KernelSize*InChannel/(Bram_Out_DataWidth/8)(向上取整)

        val InFeature_Size=in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel=in UInt(16 bits)
        
        val OutFeature_Channel=in UInt(16 bits)
        val OutFeature_Channel_Count_Times=in UInt(16 bits)
        val OutFeature_Size=in UInt(16 bits)//输出特征图的大小
                                            //用于计算的冗余处理，
        val OutCol_Count_Times=in UInt(16 bits)
        val OutRow_Count_Times=in UInt(16 bits)
        val InCol_Count_Times=in UInt(16 bits)//图片大小*ceil(通道数/8)，比如224的图片，3通道，但是一下子进8个通道，这三个通道补零成8通道，那么这里应该输入224*ceil(3/8)
                                                //实际上就是输入图片一行（全部通道）的地址空间大小

        // val Test_Signal=out Bool()//一个调试信号，比如第一轮的输出保存为txt，或者第5轮的输出保存为txt
        // val Test_Generate_Period=in UInt(32 bits)
    }
    noIoPrefix()
    val Fsm=Data_GenerateFsm(io.start&&(~RegNext(io.start)))
    //读数据展开控制====================================================================================================
    
    
    //卷积窗口按行展开
    val SA_Row_Cnt=ForLoopCounter(Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE,3,8-1)//这个计数器对应的是脉动阵列的每一行
    //这里的意思是：脉动阵列一共有8行，每一行处理一个滑动窗口，那么8行就处理8个滑动窗口，对应特征图的一行8个输出点
    //以后这个地方需要修改为可配置的
    val Window_Col_Cnt=ForLoopCounter(SA_Row_Cnt.valid,16,io.Window_Size-1)
    //滑动窗口列计数器
    val Window_Row_Cnt=ForLoopCounter(Window_Col_Cnt.valid,16,io.Kernel_Size-1)
    //滑动窗口行计数器
        //与上Window_Col_Cnt.valid的原因：当Window_Col_Cnt==15时会一直拉高，
    val Out_Channel_Cnt=ForLoopCounter(Window_Row_Cnt.valid,16,io.OutFeature_Channel_Count_Times-1)//因为一下出8个通道，所以得除以8
    //这里假设输出通道总是能被8整除，比如输出通道比较大，768个通道，一下处理8个通道，那么需要768/8=96个循环。
    val Out_Col_Cnt=ForLoopCounter(Out_Channel_Cnt.valid,16,io.OutCol_Count_Times-1)//输出列计数器，比如输出特征图的大小是14列，但是我们的输出并行度是8，所以这里应该是ceil(14/8)=2
    val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,16,io.OutRow_Count_Times-1)


    //冗余计算处理==============================================================================
    val OutFeature_Col_Lefted=Reg(UInt(16 bits))init(0)//用来标记输出特征图一行还剩多少列没处理
    when(Out_Col_Cnt.valid){
        OutFeature_Col_Lefted:=io.OutFeature_Size//跑完一行后归位
    }elsewhen(Out_Channel_Cnt.valid){
        //当8个输入通道与所有卷积核计算完后得到输出特征图一行8个点的全部输出通道
        //还没处理的输出特征图的列数减8更新
        OutFeature_Col_Lefted:=OutFeature_Col_Lefted-8
    }elsewhen(Fsm.currentState===DATA_GENERATE_ENUM.INIT){
        OutFeature_Col_Lefted:=io.OutFeature_Size
    }
    when(SA_Row_Cnt.count===OutFeature_Col_Lefted-1){//得减个1，看仿真看出来的，分析也好分析
        SA_Row_Cnt.valid:=True
        SA_Row_Cnt.count:=0
    }
    val Kernel_Addr=Reg(UInt(32 bits))init(0)//WaCounter(Window_Row.valid,32,Config.PICTURE_SIZE-io.Kernel_Size-1,Stride=io.Stride)//默认卷积核的最右边一列最后可以到达输入特征图的最右边
        //当输出完一个滑动窗口的所有点后,卷积核开始移动
        //Kernel_Addr对应的是卷积滑动窗口top-left点的相对地址(注意是相对地址,后面读写时相对地址加上地址偏移就是绝对地址)
    val Kernel_Base_Addr=Reg(UInt(32 bits))init(0)
    when(Out_Col_Cnt.valid){//每输出一行特征图，卷积核地址复位
        Kernel_Base_Addr:=0
    }elsewhen(Out_Channel_Cnt.valid){//每输出8个点对应的全部通道，也就是Out_Feature的一行的8个点，卷积核基地址后移8个滑动窗口位置
        Kernel_Base_Addr:=Kernel_Base_Addr+(io.Window_Size<<3).resized//一个Window_Size对应一个滑动窗口的全部数据的地址长度,并行度是8,
    }//一个Window_Size最大的大小就是:KernelSize*Compute_In_Channel,Compute_In_Channel最大是8
    when(Out_Col_Cnt.valid){
        //拿到输出矩阵的一行后，Kernel_Base_Addr和Kernel_Addr都要归位
        Kernel_Addr:=0
    }elsewhen(Out_Channel_Cnt.valid){
        Kernel_Addr:=Kernel_Base_Addr+(io.Window_Size<<3).resized//一轮输出通道处理完,8个滑动窗口右移更新成下一8滑动窗口的相对起始地址,
                                                                //
    }elsewhen(Window_Row_Cnt.valid){
        Kernel_Addr:=Kernel_Base_Addr
    }elsewhen(SA_Row_Cnt.valid){//输完8个卷积核中的第一个点,然后再重新回来输第二个点,输完8个滑窗
        Kernel_Addr:=Kernel_Base_Addr
    }elsewhen(Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE){
        Kernel_Addr:=Kernel_Addr+io.Stride//每向SA输入一行数据,Kernel_Addr就加一个步长
    }
    val Row_Base_Addr=Reg(UInt(16 bits))init(0)
    val Raddr=Kernel_Addr+Row_Base_Addr+Window_Col_Cnt.count


    //Row_Base_Addr偏移控制
    //首先，在一轮计算开始时，FifoRd是空的，一开始需要向Fifo中写入数据
    //比如3*3步长为1的卷积,一开始需要向Fifo中写入0,1,2,3行的基地址
    //这里的话是16*16,步长为16的卷积,那么需要向fifo中写入0,1,2,...31行的基地址
    //同时还要考虑for循环中基地址更新的问题:
        //比如要得到输出特征图的第一行,就需要导入处理0,1,2...15行的数据,并且循环读取这15行数据
        //输出特征图的第一行被得到后,需要导入16,17..31行的数据
        //如果只用一个fifo来循环读写会有问题,比如我们向fifo中写入了0,1,2...31行的基地址,很明显0,1,2,3...15行的基地址要被循环读取多次,在处理完前16行数据之前还不能读取第16行数据
    //初步思路:
        //第一步:在数据缓存阶段先向FifoRd写入需要循环读的Row_Base_Addr
        //第二步:前32行(16行)数据被缓存完后,开始进入计算状态,在计算状态中读
        //所以在数据缓存阶段,先向FifoRd0写入0~15行的基地址,FifoRd1中写入16~31行的基地址
    val FifoRd0=new RaddrOffset_Fifo//由于暂时只支持32的Conv,所以深度设置为32
    val FifoRd1=new RaddrOffset_Fifo
    //两个fifo拼起来,具体逻辑见(待更新)
    FifoRd0.io.push.payload:=0
    FifoRd0.io.push.valid:=False
    FifoRd0.io.pop.ready:=False

    FifoRd1.io.push.payload:=0
    FifoRd1.io.push.valid:=False
    FifoRd1.io.pop.ready:=False
    // when(Window_Col_Cnt.valid){
    //     Row_Base_Addr:=FifoRd0.io.pop.payload//当8个滑窗的一行都被输出了,接下来换下一行,换下一行需要更新Row_Base_Addr
    // }
    //===========================FifoRd循环读写地址控制========================
    val Update_FifoRd=(Out_Col_Cnt.count===io.OutCol_Count_Times-1)&&(Out_Channel_Cnt.count===io.OutFeature_Channel_Count_Times-1)//在这个状态下确实需要刷新fifo，
        //但是需要考虑不同的步长，比如步长为1，只用向fiford0中pop一个到fiford1，再从fiford1pop一个到fiford0即可
        //8滑动窗口得滑倒当前16行的最后，然后输出通道的计算也应该是最后的8个输出通道
    when(Fsm.nextState===DATA_GENERATE_ENUM.SA_COMPUTE&&Fsm.currentState=/=DATA_GENERATE_ENUM.SA_COMPUTE){//在进入SA_Compute 状态之前得pop一下
        FifoRd0.io.pop.ready:=True//首先我们知道每次计算前FifoRd0都会将要循环读取的Row_Base_Addr存起来，所以每次计算前我们需要先pop出第一个Row_Base_Addr才能开始后面的机选
        //这里就是在每次计算开始前先pop一个Row_Base_Addr
        FifoRd0.io.push.payload:=FifoRd0.io.pop.payload
        FifoRd0.io.push.valid:=FifoRd0.io.pop.valid   
    }
    
    when(Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE){
        
        when(Window_Col_Cnt.valid&&Fsm.nextState=/=DATA_GENERATE_ENUM.UPDATE_FIFORd){//这里很麻烦，需要好好写一个备忘录来说明
            //滑动窗口的一行输出完后，就开始处理滑动窗口的下一行数据，这是Row_Base_Addr需要被更新
            FifoRd0.io.pop.ready:=True
            FifoRd0.io.push.payload:=FifoRd0.io.pop.payload//循环写回
            FifoRd0.io.push.valid:=FifoRd0.io.pop.valid
        }
    }
    when(FifoRd0.io.pop.fire){
        Row_Base_Addr:=FifoRd0.io.pop.payload//更新行基地址
    }
    //=======================花io.stride个周期更新fifoRd0=========================
    val FifoRd0_Update_Cnt=ForLoopCounter(Fsm.currentState===DATA_GENERATE_ENUM.UPDATE_FIFORd,5,io.Stride-1)//最大支持32bit
    Fsm.FifoRd_Updated:=FifoRd0_Update_Cnt.valid
    when(Fsm.currentState===DATA_GENERATE_ENUM.UPDATE_FIFORd){
        FifoRd0.io.pop.ready:=True
        FifoRd0.io.push.payload:=FifoRd1.io.pop.payload
        FifoRd0.io.push.valid:=FifoRd1.io.pop.valid

        FifoRd1.io.pop.ready:=True
        FifoRd1.io.push.payload:=FifoRd0.io.pop.payload
        FifoRd1.io.push.valid:=FifoRd0.io.pop.valid
        
    }
    //写数据缓存控制=====================================================================================================
        //通道优先,先写第一个点的所有通道,第一个点的所有通道写完了,此时列计数器加加,再那么写下一个点的所有通道,也就是当前行第二列的数据
    // val In_Channel_Cnt=WaCounter(io.sData.fire,32,io.InFeature_Channel-1)//输入通道计数器
    val In_Col_Cnt=WaCounter(io.sData.fire,16,io.InCol_Count_Times-1)//需要边界控制,如果输入通道是1的话,那么In_Channel_Cnt.valid会一直拉高
        //RegNext是为了防止当In_Channel_Cnt==223时fire拉低,In_Channel_Cnt.valid就一直拉高的情况
        //当然也可以让In_Channel_Cnt数完一轮后自动归零(还没试过)
            //嗯,,,,好像不能自动归零,因为写地址的地址偏移还有一段In_Channel_Cnt时间要用到In_Col_Cnt...
    val In_Row_Cnt=ForLoopCounter(In_Col_Cnt.valid,16,io.InFeature_Size-1)//嗯,,,,,谁闲着没事会算1个像素点的图片?现在默认图片大小至少是2*2
    //这里改成In_Channel_Cnt.valid的原因可以看上次提交的commit备注
    //主要是为了让In_Row_Cnt晚点计数,防止当In_Row_Cnt==15后,In_channel_Cnt还没数完的问题,从而处理丢最后几个点的问题.
    //如果是3通道,会在最后丢一个点,4通道会丢两个点,,,,
    val WaddrOffset=Reg(UInt(16 bits))init(0)


    
    val Waddr_To_Push_State=In_Row_Cnt.count<io.Kernel_Size+io.Stride//一个单独的状态,只有在这一段时间中我们才向fifo中写入地址
        //比如3*3步长为1的卷积,我们需要4行数据缓存
        //而16*16,步长为16的卷积我们需要32行的数据缓存

    val Data_Cache_Fsm=Load_KRows_Fsm(Out_Col_Cnt.valid&&Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE)//输出特征图一行处理完了，就可以启动下一次的数据缓存
    val FifoWr_Pop_Now=((!Waddr_To_Push_State)&&In_Col_Cnt.valid)||(Fsm.currentState===DATA_GENERATE_ENUM.LOAD_FIRST_kROWs&&Fsm.Load_First_kROWs_End)//(Data_Cache_Fsm.currentState===LOAD_KROWS_ENUM.IDLE&&Data_Cache_Fsm.nextState=/=LOAD_KROWS_ENUM.IDLE)
    //加载完前K行需要pop一下
    // val FifoWr_Push_Now=FifoWr_Pop_Now||In_Col_Cnt.valid
        //首先，如果在缓存前k行的状态里，如果那么就只能push不能pop，每缓存完一行就push一下
        //然后，在计算状态中，每拿到输出矩阵完整的一行，就得开始缓存后面的K行,这时得先pop出一个新的Waddr                                                                        
    val Waddr=WaddrOffset+In_Col_Cnt.count//Waddr_To_Push_State?WaddrOffset|WaddrOffset+In_Col_Cnt.count

    val FifoWr=new WaddrOffset_Fifo//Fifo Of Write Addr offset
    FifoWr.io.push.payload:=Waddr_To_Push_State?WaddrOffset|FifoWr.io.pop.payload
        //比如16*16的卷积，步长为16，一开始我们不需要循环复用Bram地址空间，只需要一直往里面写0，1，2，3...行的起始地址即可
        //存完32行数据后，就可以循环复用Bram地址空间了，这时Fifo出来的数据要重新写回fifo队列中
    FifoWr.io.push.valid:=In_Col_Cnt.valid//将前32行的起始地址缓存下来，每处理完一行，fifo就pop一个地址并且push一个地址
    //因为目前来说只要pop出来就得push进去，但是在最后的K行的时候就不用push了
    FifoWr.io.pop.ready:=(!Waddr_To_Push_State)&&In_Col_Cnt.valid
    
        //前期不需要复用Bram地址空间，那么我们就一直往前面写就行了
        //比如16*16的卷积，步长为16，当行计数器还没满16行时，那么前面32行数据的写地址直接从0一直到32行末尾
        //存完32行数据后，我们才开始复用Bram地址空间，这时可以启动FIFO循环写地址。

    // when(In_Col_Cnt.valid){
    //     when(Waddr_To_Push_State){
    //         WaddrOffset:=WaddrOffset+io.InCol_Count_Times//变成下一行的起始地址
    //     }otherwise{
    //         WaddrOffset:=FifoWr.io.pop.payload//锁住，维持224个周期
    //     }
    // }
    when(Data_Cache_Fsm.nextState===LOAD_KROWS_ENUM.LOAD_NEXT_KROWs&&Data_Cache_Fsm.currentState===LOAD_KROWS_ENUM.IDLE){
        FifoWr.io.pop.ready:=True
        FifoWr.io.push.valid:=True//之后每缓存K行的一开始都要pop一下
    }
    when(Waddr_To_Push_State){
         when(In_Col_Cnt.valid){
            WaddrOffset:=WaddrOffset+io.InCol_Count_Times//变成下一行的起始地址
         }
    }elsewhen(FifoWr.io.pop.fire){
        WaddrOffset:=FifoWr.io.pop.payload//锁住，维持224个周期
    }

    when(Fsm.currentState===DATA_GENERATE_ENUM.LOAD_FIRST_kROWs){
        //当处于缓存前K行数据状态时,更新读地址fifo,只向FifoRd1中写入即可
        when(In_Row_Cnt.count<io.Kernel_Size){
            FifoRd0.io.push.payload:=WaddrOffset
            FifoRd0.io.push.valid:=In_Col_Cnt.valid//在缓存前32行数据的(之后应该修改为只缓存16行数据)这一段时间内和写地址fifo同步
            
        }
        // otherwise{
        //     FifoRd0.io.push.payload:=0
        //     FifoRd0.io.push.valid:=False//在缓存前32行数据的(之后应该修改为只缓存16行数据)这一段时间内和写地址fifo同步
            
        // }
        when(In_Row_Cnt.count>=io.Kernel_Size){
            FifoRd1.io.push.payload:=WaddrOffset
            FifoRd1.io.push.valid:=In_Col_Cnt.valid//在缓存前32行数据的(之后应该修改为只缓存16行数据)这一段时间内和写地址fifo同步
            // FifoRd1.io.pop.ready:=(In_Row_Cnt.count<io.Kernel_Size)//前16个点还是继续pop给FIfoRd0
        }
        // otherwise{
        //     FifoRd1.io.push.payload:=0
        //     FifoRd1.io.push.valid:=False//在缓存前32行数据的(之后应该修改为只缓存16行数据)这一段时间内和写地址fifo同步
        //     // FifoRd1.io.pop.ready:=(In_Row_Cnt.count<io.Kernel_Size)//前16个点还是继续pop给FIfoRd0            
        // }
    }

//Bram的读写策略采取写优先=================================================================
    val DGB=new DataGen_Bram
    DGB.io.dina:=io.sData.payload
    DGB.io.addra:=Waddr.resized//写地址,由于For循环展开都是用32bit来计数的
    DGB.io.ena:=io.sData.fire
    DGB.io.wea:=True
    DGB.io.addrb:=Raddr.resized//读地址，循环读,还没有处理128入64出的情况,,,,

//Fsm==========================================================================================================
    
    val Init_Count=WaCounter(Fsm.currentState===DATA_GENERATE_ENUM.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid
    Fsm.Load_First_kROWs_End:=In_Col_Cnt.valid&&(In_Row_Cnt.count===io.Kernel_Size+io.Stride-1)//如果是1*1的卷积,就不用缓存了,直接进SA计算得了,,,
    //加一个In_Col_Cnt.valid就不会在进完最后一个点后ready还拉高一个周期
    //或者说1*1卷积再重新写一个配置？啊，1*1卷积真折磨人
    // 1/12更新，其实1*1卷积就是一个点一个点算，没有重合，所以不需要用img2col展开，单独再开一条线就行了
    //所以我们这里暂时先处理2*2及以上的卷积。
    //当In_Row_Cnt=0时代表在加载第0行数据，当In_Row_Cnt=1时，代表第0行数据加载完了，正在加载第1行数据
        //若卷积核大小时16*16，那么当In_Row_Cnt=15时代表正在加载第15行数据，
        //由于只需要缓存前16行数据就能开始计算，所以这里的状态跳转标志应该没啥问题。
        //这里kernelsize=16，Stride=16，16+16=32，当In_Row_Cnt=32时，说明正在加载第32行数据（从0开始），那么此时前32行数据已经缓存完了
        //不管怎么说，反正最后进fifo的地址应该是0~31
    // val Data_Cache_Fsm=Load_KRows_Fsm(Out_Col_Cnt.valid)//输出特征图一行处理完了，就可以启动下一次的数据缓存
    Fsm.SA_Compute_End:=Out_Col_Cnt.valid//当输出矩阵的一行被处理完了，也就是16行的输入数据也被处理完了，这时脉动阵列计算完了一轮
    Fsm.All_Computed:=Out_Row_Cnt.valid
    Fsm.Row_Cached:=True//Data_Cache_Fsm.currentState===LOAD_KROWS_ENUM.IDLE//下一轮的计算数据已经被缓存完，就可以开始计算
    //能否认为计算时间永远大于等于缓存时间?
    //不能这样认为,万一上层出数比较慢,也就是sData.valid可能拉低很长一段时间,,,,嗯,,,,这就是一种极端情况需要被考虑
    val Load_KRows_Cnt=ForLoopCounter(In_Col_Cnt.valid,32,io.Stride-1)//
    Data_Cache_Fsm.Krows_Loaded:=Load_KRows_Cnt.valid//当第15行（从0开始）数据全部加载完即可
    Data_Cache_Fsm.All_Rows_Loaded:=In_Row_Cnt.valid||Fsm.All_Computed//加一个All_Computed的原因（最后才加的）：由于缓存只是比计算快，所以存在全部数据都缓存完了但是还没算完的情况
    
    io.sData.ready:=False
    when(Fsm.currentState===DATA_GENERATE_ENUM.LOAD_FIRST_kROWs){
        io.sData.ready:=True
    }
    when(Data_Cache_Fsm.currentState===LOAD_KROWS_ENUM.LOAD_NEXT_KROWs){
        io.sData.ready:=True
    }
    io.mData:=DGB.io.doutb//(7 downto 0).resized

    
    io.mValid:=RegNext(Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE)
    when(Fsm.nextState===DATA_GENERATE_ENUM.IDLE){
        FifoRd0.io.flush:=True
        FifoRd1.io.flush:=True
        FifoWr.io.flush:=True
    }otherwise{
        FifoRd0.io.flush:=False
        FifoRd1.io.flush:=False
        FifoWr.io.flush:=False
    }//清空Fifio，，，那我之前写的那些好像没啥用了
    io.mLast:=RegNext(Out_Row_Cnt.valid)
//测试信号，将来要删除===============================================================
    // io.Test_Signal:=(io.Test_Generate_Period-1)===RegNext(Out_Row_Cnt.count)
}   

// class DataGenerate_Top extends Component{
//     val Config=TopConfig()
//     val io=new Bundle{
//         def DATA_IN_WIDTH=64
//         val m_axis_mm2s_tdata=out UInt(DATA_IN_WIDTH bits)
//         val m_axis_mm2s_tkeep=out Bits(DATA_IN_WIDTH/8 bits)
//         val m_axis_mm2s_tlast=out Bool()
//         val m_axis_mm2s_tready=in Bool()
//         val m_axis_mm2s_tvalid=out Bool()

//         def DATA_OUT_WIDTH=64
//         val s_axis_s2mm_tdata=in UInt(DATA_OUT_WIDTH bits)
//         val s_axis_s2mm_tkeep=in Bits(DATA_OUT_WIDTH/8 bits)
//         val s_axis_s2mm_tlast=in Bool()
//         val s_axis_s2mm_tready=out Bool()
//         val s_axis_s2mm_tvalid=in Bool()

//         // val m_tlast=out Bool()
//         val start=in Bool()
//         //=================================================================
//         // val Stride=in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
//         // val Kernel_Size=in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
//         // val Window_Size=in UInt(32 bits)
//         //     //所谓WindowSize,比如一个16*16的卷积,那么一个滑动窗口的大小就是16,但是需要考虑输入通道,比如256的输入通道,那么这时输入的Window_Size就是16*256(对应的是滑动窗口一行数据点),只支持方形卷积
//         //     //除了考虑输入通道，还要考虑输入数据的并行度，比如如果一下进8个点，也就是8个通道，虽然实际我们进的是224*224*3的图片，
//         //     //但是我们不能简单的将Window_Size设置为16*3，应该还是设置为16，因为3通道不够，需要补零成8通道
//         //     //这时我们的WindowSize还是1，如果输入通道是9，那么我们的Window_Size就是16*2，9通道继续补零成16通道，有7个通道冗余
//         //     //总的来说Window_Size的实际计算公式应该是：KernelSize*InChannel/(Bram_Out_DataWidth/8)(向上取整)

//         // val InFeature_Size=in UInt(32 bits)//图片多大就输入多大的数据
//         // val InFeature_Channel=in UInt(32 bits)
        
//         // val OutFeature_Channel=in UInt(32 bits)
//         // val OutFeature_Channel_Count_Times=in UInt(32 bits)
//         // val OutFeature_Size=in UInt(32 bits)//输出特征图的大小
//         //                                     //用于计算的冗余处理，
//         // val OutCol_Count_Times=in UInt(32 bits)
//         // val OutRow_Count_Times=in UInt(32 bits)
//         // val InCol_Count_Times=in UInt(32 bits)//图片大小*ceil(通道数/8)，比如224的图片，3通道，但是一下子进8个通道，这三个通道补零成8通道，那么这里应该输入224*ceil(3/8)
//         //                                         //实际上就是输入图片一行（全部通道）的地址空间大小

//         // val Test_Signal=out Bool()//一个调试信号，比如第一轮的输出保存为txt，或者第5轮的输出保存为txt
//         // val Test_Generate_Period=in UInt(32 bits)//
//     }
//     noIoPrefix()
//     val SubModule=new Data_Generate
//     SubModule.io.mData<>io.m_axis_mm2s_tdata
//     SubModule.io.mValid<>io.m_axis_mm2s_tvalid
//     // SubModule.io.mReady<>io.m_axis_mm2s_tready
//     SubModule.io.mLast<>io.m_axis_mm2s_tlast
//     io.m_axis_mm2s_tkeep.setAll()//全部设置为1

//     SubModule.io.sData.payload<>io.s_axis_s2mm_tdata
//     SubModule.io.sData.valid<>io.s_axis_s2mm_tvalid
//     SubModule.io.sData.ready<>io.s_axis_s2mm_tready
//     SubModule.io.start<>io.start


//     // io.Stride                           <>SubModule.io.Stride
//     // io.Kernel_Size                      <>SubModule.io.Kernel_Size  
//     // io.Window_Size                      <>SubModule.io.Window_Size  
//     // io.InFeature_Size                   <>SubModule.io.InFeature_Size 
//     // io.InFeature_Channel                <>SubModule.io.InFeature_Channel  
//     // io.OutFeature_Channel               <>SubModule.io.OutFeature_Channel 
//     // io.OutFeature_Channel_Count_Times   <>SubModule.io.OutFeature_Channel_Count_Times 
//     // io.OutFeature_Size                  <>SubModule.io.OutFeature_Size
//     // io.OutCol_Count_Times               <>SubModule.io.OutCol_Count_Times 
//     // io.OutRow_Count_Times               <>SubModule.io.OutRow_Count_Times 
//     // io.InCol_Count_Times                <>SubModule.io.InCol_Count_Times  
//     // io.Test_Signal                      <>SubModule.io.Test_Signal
//     // io.Test_Generate_Period             <>SubModule.io.Test_Generate_Period

//     SubModule.io.Stride                          :=16                       
//     SubModule.io.Kernel_Size                     :=16       
//     SubModule.io.Window_Size                     :=16       
//     SubModule.io.InFeature_Size                  :=224          
//     SubModule.io.InFeature_Channel               :=3               
//     SubModule.io.OutFeature_Channel              :=768               
//     SubModule.io.OutFeature_Channel_Count_Times  :=96                           
//     SubModule.io.OutFeature_Size                 :=14           
//     SubModule.io.OutCol_Count_Times              :=2               
//     SubModule.io.OutRow_Count_Times              :=14               
//     SubModule.io.InCol_Count_Times               :=224               
//     // SubModule.io.Test_Signal                     :=       
//     // SubModule.io.Test_Generate_Period            :=14               
// }
object DGB_Gen extends App { 
    val verilog_path="./testcode_gen/Systolic_Array" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Data_Generate)
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}