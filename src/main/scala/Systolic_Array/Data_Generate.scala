package Systolic_Array
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
import java.awt.image.Kernel
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
    val IDLE, INIT, LOAD_FIRST_kROWs,SA_COMPUTE,WAIT_ROWs_TO_CACHE= newElement
    //LOAD_FIRST_kROWs:加载前K行,有多少个卷积核就加载多少行(这里是加载K行还是k-1行呢?)
        //可以是K-1行,这样又可以少一行的缓存时间
    //SA_COMPUTE:脉动阵列计算,8*8的脉动阵列输出64个点
    //WAIT_ROWs_TO_CACHE:如果输入通道比较大,那么完全可以在计算期间加载后面的数据,比如步长为,则需要加载一行数据,16步长,就要加载16行数据
        //另外还存在一种情况,就是算完了数据还没缓存完,所以这里我们需要消耗一个周期来判断
}
case class Data_GenerateFsm(start:Bool)extends Area{
    val currentState = Reg(DATA_GENERATE_ENUM()) init DATA_GENERATE_ENUM.IDLE
    val nextState = DATA_GENERATE_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Load_First_kROWs_End=Bool()
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
                nextState:=DATA_GENERATE_ENUM.WAIT_ROWs_TO_CACHE
            }otherwise{
                nextState:=DATA_GENERATE_ENUM.SA_COMPUTE
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
    val IDLE, LOAD_NEXT_KROWs,LOAD_LAST_KROWs= newElement
//LOAD_NEXT_KROWs:当脉动阵列处理完一行数据后，我们就可以加载后面的k行数据了
//LOAD_LAST_KROWs:加入这个状态是为了处理边界问题，比如当加载最后K行数据时，我们是不需要再往fifo中循环写回地址的，这时Fifo只需pop即可，
    //当最后的K行被加载完了，fifo也被清空了。
}
case class Load_KRows_Fsm(start:Bool)extends Area{
    val currentState = Reg(LOAD_KROWS_ENUM()) init LOAD_KROWS_ENUM.IDLE
    val nextState = LOAD_KROWS_ENUM()
    currentState := nextState
    val Krows_Loaded=Bool()
    val Load_Last_KRows=Bool()
    switch(currentState){
        is(LOAD_KROWS_ENUM.IDLE){
            when(start){
                nextState:=LOAD_KROWS_ENUM.LOAD_NEXT_KROWs
            }otherwise{
                nextState:=LOAD_KROWS_ENUM.IDLE
            }
        }
        is(LOAD_KROWS_ENUM.LOAD_NEXT_KROWs){
            when(Load_Last_KRows){
                nextState:=LOAD_KROWS_ENUM.LOAD_LAST_KROWs
            }elsewhen(Krows_Loaded){
                nextState:=LOAD_KROWS_ENUM.IDLE//缓存完了就可以进入IDLE状态等计算计算接受结束
            }otherwise{
                nextState:=LOAD_KROWS_ENUM.LOAD_NEXT_KROWs
            }
        }
        is(LOAD_KROWS_ENUM.LOAD_LAST_KROWs){
            when(Krows_Loaded){
                nextState:=LOAD_KROWS_ENUM.IDLE
            }otherwise{
                nextState:=LOAD_KROWS_ENUM.LOAD_LAST_KROWs
            }           
        }
    }

}
class WaddrOffset_Fifo extends StreamFifo(UInt(32 bits),32)
class RaddrOffset_Fifo extends StreamFifo(UInt(32 bits),32)
//读写地址偏移的fifo需要被分开嘛？
class Data_Generate extends Component{
    //数据生成模块,Bram的空间应该能
    val Config=TopConfig()
    val io=new Bundle{//测试先用8bit位宽测试
        val start=in Bool()
        val sData=slave Stream(UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits))//Stream(UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits))//进来的数据给到Bram

        //Conv相关
        //默认所有可配置参数都是正确的,比如要不要Padding,Padding多少,Stride多少?如果不满足条件,那就是算法那边背锅
            //这里不做错误判断
            //默认所有配置参数位宽均为32bit
        val Stride=in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size=in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size=in UInt(32 bits)
            //所谓WindowSize,比如一个16*16的卷积,那么一个滑动窗口的大小就是16,但是需要考虑输入通道,比如256的输入通道,那么这时输入的Window_Size就是16*256(对应的是滑动窗口一行数据点),只支持方形卷积
            //除了考虑输入通道，还要考虑输入数据的并行度，比如如果一下进8个点，也就是8个通道，虽然实际我们进的是224*224*3的图片，
            //但是我们不能简单的将Window_Size设置为16*3，应该还是设置为16，因为3通道不够，需要补零成8通道
            //这时我们的WindowSize还是1，如果输入通道是9，那么我们的Window_Size就是16*2，9通道继续补零成16通道，有7个通道冗余
            //总的来说Window_Size的实际计算公式应该是：KernelSize*InChannel/(Bram_Out_DataWidth/8)(向上取整)
        
        val InFeature_Size=in UInt(32 bits)//图片多大就输入多大的数据
        val InFeature_Channel=in UInt(32 bits)
        
        val OutFeature_Channel=in UInt(32 bits)
        val OutFeature_Channel_Count_Times=in UInt(32 bits)
        val OutFeature_Size=in UInt(32 bits)
        val OutCol_Count_Times=in UInt(32 bits)
        val OutRow_Count_Times=in UInt(32 bits)
        val InCol_Count_Times=in UInt(32 bits)//图片大小*ceil(通道数/8)，比如224的图片，3通道，但是一下子进8个通道，这三个通道补零成8通道，那么这里应该输入224*ceil(3/8)
    }
    noIoPrefix()
    val Fsm=Data_GenerateFsm(io.start)
    //读数据展开控制====================================================================================================
    
    
    //卷积窗口按行展开
    val SA_Row_Cnt=ForLoopCounter(Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE,3,8-1)//这个计数器对应的是脉动阵列的每一行
    //这里的意思是：脉动阵列一共有8行，每一行处理一个滑动窗口，那么8行就处理8个滑动窗口，对应特征图的一行8个输出点
    //以后这个地方需要修改为可配置的
    val Window_Col_Cnt=ForLoopCounter(SA_Row_Cnt.valid,32,io.Window_Size-1)
    //滑动窗口列计数器
    val Window_Row_Cnt=ForLoopCounter(Window_Col_Cnt.valid,32,io.Kernel_Size-1)
    //滑动窗口行计数器
        //与上Window_Col_Cnt.valid的原因：当Window_Col_Cnt==15时会一直拉高，
    val Out_Channel_Cnt=ForLoopCounter(Window_Row_Cnt.valid,32,io.OutFeature_Channel_Count_Times-1)//因为一下出8个通道，所以得除以8
    //这里假设输出通道总是能被8整除，比如输出通道比较大，768个通道，一下处理8个通道，那么需要768/8=96个循环。
    val Out_Col_Cnt=ForLoopCounter(Out_Channel_Cnt.valid,32,io.OutCol_Count_Times-1)//输出列计数器，比如输出特征图的大小是14列，但是我们的输出并行度是8，所以这里应该是ceil(14/8)=2
    val Out_Row_Cnt=ForLoopCounter(Out_Col_Cnt.valid,32,io.OutRow_Count_Times-1)


    //冗余计算处理==============================================================================
    val OutFeature_Col_Lefted=Reg(UInt(32 bits))init(0)//用来标记输出特征图一行还剩多少列没处理
    when(Out_Col_Cnt.valid){
        OutFeature_Col_Lefted:=io.OutFeature_Size//跑完一行后归位
    }elsewhen(Out_Channel_Cnt.valid){
        //当8个输入通道与所有卷积核计算完后得到输出特征图一行8个点的全部输出通道
        //还没处理的输出特征图的列数减8更新
        OutFeature_Col_Lefted:=OutFeature_Col_Lefted-8
    }elsewhen(Fsm.currentState===DATA_GENERATE_ENUM.INIT){
        OutFeature_Col_Lefted:=io.OutFeature_Size
    }
    when(SA_Row_Cnt.count===OutFeature_Col_Lefted){
        SA_Row_Cnt.valid:=True
        SA_Row_Cnt.count:=0
    }
    val Kernel_Addr=Reg(UInt(32 bits))init(0)//WaCounter(Window_Row.valid,32,Config.PICTURE_SIZE-io.Kernel_Size-1,Stride=io.Stride)//默认卷积核的最右边一列最后可以到达输入特征图的最右边
        //当输出完一个滑动窗口的所有点后,卷积核开始移动
        //Kernel_Addr对应的是卷积滑动窗口top-left点的相对地址(注意是相对地址,后面读写时相对地址加上地址偏移就是绝对地址)
    val Kernel_Base_Addr=Reg(UInt(32 bits))init(0)
    val Row_Base_Addr=Reg(UInt(32 bits))init(0)
    val Raddr=Kernel_Addr+Kernel_Base_Addr+Row_Base_Addr

    //地址偏移fifo
    val FifoRd=new RaddrOffset_Fifo//由于暂时只支持32的Conv,所以深度设置为32
    FifoRd.io.push.payload:=0
    FifoRd.io.push.valid:=False
    FifoRd.io.pop.ready:=False
    

    //写数据缓存控制=====================================================================================================
        //通道优先,先写第一个点的所有通道,第一个点的所有通道写完了,此时列计数器加加,再那么写下一个点的所有通道,也就是当前行第二列的数据
    // val In_Channel_Cnt=WaCounter(io.sData.fire,32,io.InFeature_Channel-1)//输入通道计数器
    val In_Col_Cnt=WaCounter(io.sData.fire,32,io.InCol_Count_Times-1)//需要边界控制,如果输入通道是1的话,那么In_Channel_Cnt.valid会一直拉高
        //RegNext是为了防止当In_Channel_Cnt==223时fire拉低,In_Channel_Cnt.valid就一直拉高的情况
        //当然也可以让In_Channel_Cnt数完一轮后自动归零(还没试过)
            //嗯,,,,好像不能自动归零,因为写地址的地址偏移还有一段In_Channel_Cnt时间要用到In_Col_Cnt...
    val In_Row_Cnt=WaCounter(In_Col_Cnt.valid,32,io.InFeature_Size-1)//嗯,,,,,谁闲着没事会算1个像素点的图片?现在默认图片大小至少是2*2
    //这里改成In_Channel_Cnt.valid的原因可以看上次提交的commit备注
    //主要是为了让In_Row_Cnt晚点计数,防止当In_Row_Cnt==15后,In_channel_Cnt还没数完的问题,从而处理丢最后几个点的问题.
    //如果是3通道,会在最后丢一个点,4通道会丢两个点,,,,
    val WaddrOffset=Reg(UInt(32 bits))init(0)


    
    val Waddr_To_Push_State=In_Row_Cnt.count<io.Kernel_Size+io.Stride//一个单独的状态,只有在这一段时间中我们才向fifo中写入地址
        //比如3*3步长为1的卷积,我们需要4行数据缓存
        //而16*16,步长为16的卷积我们需要32行的数据缓存


    val FifoWr_Pop_Now=(!Waddr_To_Push_State)&&In_Col_Cnt.valid
    val Waddr=Waddr_To_Push_State?WaddrOffset|WaddrOffset+In_Col_Cnt.count

    val FifoWr=new WaddrOffset_Fifo//Fifo Of Write Addr offset
    FifoWr.io.push.payload:=Waddr_To_Push_State?WaddrOffset|FifoWr.io.pop.payload
        //比如16*16的卷积，步长为16，一开始我们不需要循环复用Bram地址空间，只需要一直往里面写0，1，2，3...行的起始地址即可
        //存完32行数据后，就可以循环复用Bram地址空间了，这时Fifo出来的数据要重新写回fifo队列中
    FifoWr.io.push.valid:=In_Col_Cnt.valid//将前32行的起始地址缓存下来，每处理完一行，fifo就pop一个地址并且push一个地址
    FifoWr.io.pop.ready:=FifoWr_Pop_Now//
        //当开始复用Bram地址空间并且数完一行数据后才Pop下一个地址偏移
    
        //前期不需要复用Bram地址空间，那么我们就一直往前面写就行了
        //比如16*16的卷积，步长为16，当行计数器还没满16行时，那么前面32行数据的写地址直接从0一直到32行末尾
        //存完32行数据后，我们才开始复用Bram地址空间，这时可以启动FIFO循环写地址。

    when(In_Col_Cnt.valid){
        when(Waddr_To_Push_State){
            WaddrOffset:=WaddrOffset+io.InCol_Count_Times//变成下一行的起始地址
        }otherwise{
            WaddrOffset:=FifoWr.io.pop.payload//锁住，维持224个周期
        }
    }

//Bram的读写策略采取写优先=================================================================
    val DGB=new DataGen_Bram
    DGB.io.dina:=io.sData.payload
    DGB.io.addra:=Waddr.resized//写地址,由于For循环展开都是用32bit来计数的
    DGB.io.ena:=False
    DGB.io.wea:=True
    DGB.io.addrb:=0//读地址，循环读,还没有处理128入64出的情况,,,,

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
    Fsm.SA_Compute_End:=False
    Fsm.All_Computed:=False
    Fsm.Row_Cached:=False

    val Data_Cache_Fsm=Load_KRows_Fsm(Out_Col_Cnt.valid)//输出特征图一行处理完了，就可以启动下一次的数据缓存
    val Load_KRows_Cnt=WaCounter(In_Col_Cnt.valid,32,io.Stride-1)//
    Data_Cache_Fsm.Krows_Loaded:=Load_KRows_Cnt.valid&&In_Col_Cnt.valid//当第15行（从0开始）数据全部加载完即可
    Data_Cache_Fsm.Load_Last_KRows:=In_Row_Cnt.count===io.InFeature_Size-(io.Stride)
    when(Fsm.currentState===DATA_GENERATE_ENUM.LOAD_FIRST_kROWs){
        io.sData.ready:=True
    }elsewhen(Fsm.currentState===DATA_GENERATE_ENUM.SA_COMPUTE){
        io.sData.ready:=False//计算状态时也是true，这里还需要加新的约束条件，比如入完多少数据后ready拉低
    }otherwise{
        io.sData.ready:=False
    }    
}   


object DGB_Gen extends App { 
    val verilog_path="./testcode_gen/Systolic_Array" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Data_Generate)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}