package Systolic_Array
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
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
class WaddrOffset_Fifo extends StreamFifo(UInt(32 bits),32)
class RaddrOffset_Fifo extends StreamFifo(UInt(32 bits),32)
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
            //所谓WindowSize,比如一个5*5的卷积,那么一个滑动窗口的大小就是5,但是需要考虑输入通道,比如256的输入通道,那么这时输入的Window_Size就是5*256(对应的是滑动窗口一行数据点),只支持方形卷积
        val OutFeature_Size=in UInt(32 bits)
        val InFeature_Size=in UInt(32 bits)//
        val InFeature_Channel=in UInt(32 bits)

        val InFeature_Size_Mul_Channel=in UInt(32 bits)//图片大小乘以通道数，比如224的图片，3通道，那么这里应该输入224*3
    }
    noIoPrefix()






    

    //读数据展开控制====================================================================================================
    //卷积窗口按行展开
    val Window_Col=WaCounter(True,32,io.Window_Size-1)//io.kernel_Size
    val Window_Row=WaCounter(Window_Col.valid,32,io.Window_Size-1)//io.kernel_Size
        //每输出完滑动窗口的一行行计数器就加一
    val Kernel_Addr=WaCounter(Window_Row.valid,32,Config.PICTURE_SIZE-io.Kernel_Size-1,Stride=io.Stride)//默认卷积核的最右边一列最后可以到达输入特征图的最右边
        //当输出完一个滑动窗口的所有点后,卷积核开始移动
        //Kernel_Addr对应的是卷积滑动窗口top-left点的相对地址(注意是相对地址,后面读写时相对地址加上地址偏移就是绝对地址)
    val RaddrOffset=UInt(32 bits)//输出完滑动窗口的一行后才会更新成下一行的偏移地址
    val Raddr=Window_Col.count+Kernel_Addr.count+RaddrOffset
    val OutFeature_Width=WaCounter(Kernel_Addr.valid,32,io.OutFeature_Size-1)

    //地址偏移fifo
    val FifoRd=new RaddrOffset_Fifo//由于暂时只支持32的Conv,所以深度设置为32
    FifoRd.io.push.payload:=0
    FifoRd.io.push.valid:=False
    FifoRd.io.pop.ready:=Window_Col.valid//处理完滑动窗口的一行就继续处理下一行,处理下一行的话行地址偏移需要更新
    RaddrOffset:=FifoRd.io.pop.valid?FifoRd.io.pop.payload|0//Fifo Of Read Addr Offset

    //写数据缓存控制=====================================================================================================
        //t通道优先,先写第一个点的所有通道,第一个点的所有通道写完了,此时列计数器加加,再那么写下一个点的所有通道,也就是当前行第二列的数据
    // val In_Channel_Cnt=WaCounter(io.sData.fire,32,io.InFeature_Channel-1)//输入通道计数器
    val In_Col_Cnt=WaCounter(io.sData.fire,32,io.InFeature_Size_Mul_Channel-1)//需要边界控制,如果输入通道是1的话,那么In_Channel_Cnt.valid会一直拉高
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
            WaddrOffset:=WaddrOffset+io.InFeature_Size_Mul_Channel//变成下一行的起始地址
        }otherwise{
            WaddrOffset:=FifoWr.io.pop.payload//锁住，维持224个周期
        }
    }

//Bram的读写策略采取写优先
    val DGB=new DataGen_Bram
    DGB.io.dina:=io.sData.payload
    DGB.io.addra:=Waddr.resized//写地址,由于For循环展开都是用32bit来计数的
    DGB.io.ena:=False
    DGB.io.wea:=True
    DGB.io.addrb:=Raddr.resized//读地址，循环读,还没有处理128入64出的情况,,,,

//Fsm==========================================================================================================
    val Fsm=Data_GenerateFsm(io.start)
    val Init_Count=WaCounter(Fsm.currentState===DATA_GENERATE_ENUM.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid
    Fsm.Load_First_kROWs_End:=In_Row_Cnt.count===io.Kernel_Size+io.Stride//如果是1*1的卷积,就不用缓存了,直接进SA计算得了,,,
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