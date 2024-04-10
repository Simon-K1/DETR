package SystolicArray3D
import spinal.core._
import spinal.lib._
import utils._
import spinal.lib.Delay
import spinal.lib.StreamFifo
// import spinal.core.internals.Operator
import xip.{xil_SimpleDualBram,xil_ila}
class WaddrOffset_Fifo extends StreamFifo(UInt(16 bits),32+1)//必须加一，比如我们需要实现16*16的卷积，如果fifo深度设置为32，32个fifo会被存满，fifo.push.ready会拉低,不能出现这种情况
class RaddrOffset_Fifo extends StreamFifo(UInt(16 bits),32)
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

object IMG2COL_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot) {//读取一个矩阵数据并且计算累加和状态
    val IDLE, INIT, INIT_ADDR,DATA_CACHE,WAIT_COMPUTE,UPDATE_ADDR,START_COMPUTE= newElement
    //INIT_ADDR:即初始化读写fifo的地址,把需要的地址存起来

    //DATA_CACHE:缓存一轮计算所需的数据
    //WAIT:缓存完了得等开始计算，比如上一轮还没算完，得等上一轮算完了才开始计算
    //UPDATE_ADDR:更新下一轮计算的全部读地址，比如在Init_Addr阶段0~31的地址都被存好了,现在计算的话需要的确实0~15的地址,我们需要把0~15的地址写入fifo
                //下一轮计算的时候需要的是16~31的地址,下一次计算前也要更新.
    //START_COMPUTE:开始计算，理论上就拉高一个周期

}
case class Img2Col_Fsm(start:Bool)extends Area{
    val currentState = Reg(IMG2COL_ENUM()) init IMG2COL_ENUM.IDLE
    val nextState = IMG2COL_ENUM()
    currentState := nextState

    val Init_End=Bool()
    val Addr_Inited=Bool()//初始化读写地址完成
    val Data_Cached=Bool()//一轮要计算的数据缓存完了
    val Addr_Updated=Bool()
    val SA_Ready=Bool()//脉动阵准备好接收新一轮数据开始计算
    val Cache_End=Bool()//缓存结束，比如224行数据全部被缓存完了
    val Layer_End=Bool()//一层全部算完了
    switch(currentState){
        is(IMG2COL_ENUM.IDLE){
            when(start){
                nextState:=IMG2COL_ENUM.INIT
            }otherwise{
                nextState:=IMG2COL_ENUM.IDLE
            }
        }
        is(IMG2COL_ENUM.INIT){
            when(Init_End){
                nextState:=IMG2COL_ENUM.INIT_ADDR
            }otherwise{
                nextState:=IMG2COL_ENUM.INIT
            }
        }
        is(IMG2COL_ENUM.INIT_ADDR){
            when(Addr_Inited){
                nextState:=IMG2COL_ENUM.DATA_CACHE
            }otherwise{
                nextState:=IMG2COL_ENUM.INIT_ADDR
            }
        }
        is(IMG2COL_ENUM.DATA_CACHE){
            when(Data_Cached){
                nextState:=IMG2COL_ENUM.WAIT_COMPUTE
            }otherwise{
                nextState:=IMG2COL_ENUM.DATA_CACHE
            }
        }
        is(IMG2COL_ENUM.WAIT_COMPUTE){
            when(Layer_End){//全部计算结束
                nextState:=IMG2COL_ENUM.IDLE
            }elsewhen(SA_Ready){
                nextState:=IMG2COL_ENUM.UPDATE_ADDR
            }otherwise{
                nextState:=IMG2COL_ENUM.WAIT_COMPUTE
            }
        }
        is(IMG2COL_ENUM.UPDATE_ADDR){
            when(Addr_Updated){
                nextState:=IMG2COL_ENUM.START_COMPUTE
            }otherwise{
                nextState:=IMG2COL_ENUM.UPDATE_ADDR
            }
        }
        is(IMG2COL_ENUM.START_COMPUTE){//这个状态没啥用
            when(Layer_End){
                nextState:=IMG2COL_ENUM.IDLE
            }elsewhen(Cache_End){//缓存结束了就不用再进入缓存状态，直接等待计算结束即可
                nextState:=IMG2COL_ENUM.WAIT_COMPUTE
            }otherwise{
                nextState:=IMG2COL_ENUM.DATA_CACHE
            }
        }
    }
    
}
class Img2Col_Top extends Component{
    //Top模块负责总控和数据缓存,数据输出模块再开一个
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()
        val sData=slave Stream(UInt(64 bits))
        val mData=out UInt(Config.DATA_GENERATE_BRAM_OUT_WIDTH bits)
        val mReady=in Bool()//下层准备好的信号
        val mValid=out Bool()
        val Fifo_Clear=in Bool()
        val mLast=out Bool()

        val Stride                          =in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size                     =in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size                     =in UInt(16 bits)
        val InFeature_Size                  =in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel               =in UInt(16 bits)//输入通道的信息已经包含在WindowSize中，可能以后用不到了
        val OutFeature_Channel              =in UInt(16 bits)
        val OutFeature_Size                 =in UInt(16 bits)//输出特征图的大小                                            
        val OutCol_Count_Times              =in UInt(16 bits)
        val InCol_Count_Times               =in UInt(16 bits)//这玩意又是啥？
        val OutRow_Count_Times              =in UInt(16 bits)
        val OutFeature_Channel_Count_Times  =in UInt(16 bits)
        val Sliding_Size                    =in UInt(16-3 bits)
        //比如224的图片，输入通道是8，那么InCOl_Count_TImes就是224，数224下就能把输入图片完整的一行存下来
        //如果图片的输入通道变成了16，那么我们肯定得数224*2下才能把图片的完整的一行存下来，因为输入位宽是64bit，一下进8个点
        
        


        //测试信号==============================================================
        val Test_Signal=out Bool()
        val Test_Generate_Period=in UInt(16 bits)
        val Test_End=out Bool()
        

        val Raddr_Valid=out Bool()
        val LayerEnd=out Bool()

        val SA_Row_Cnt_Valid=out Bool()//给脉动阵列的行选择信号的复位标志
        
    }
    noIoPrefix()
    val Fsm=Img2Col_Fsm(io.start&&(~RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===IMG2COL_ENUM.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid
    //初始化结束后进入初始化地址阶段============================================================
    val Addr_Init_Cnt=ForLoopCounter(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR,5,io.Kernel_Size+io.Stride-1)
    Fsm.Addr_Inited:=Addr_Init_Cnt.valid

    val AddrFifo=new WaddrOffset_Fifo
    val WaddrOffset=Reg(UInt(16 bits))init(0)
    AddrFifo.io.push.payload:=WaddrOffset
    AddrFifo.io.push.valid:=False
    AddrFifo.io.pop.ready:=False

    when(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR){
        AddrFifo.io.push.valid:=True
        // AddrFifo.io.push.payload:=WaddrOffset
    }
    //这里判定的优先级比较重要
    when(Fsm.currentState===IMG2COL_ENUM.INIT){
        WaddrOffset:=0//初始化为0，防止第二次启动出现问题（上板第二次启动不对的问题bug出处）
    }elsewhen(AddrFifo.io.pop.fire){
        WaddrOffset:=AddrFifo.io.pop.payload
    }elsewhen(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR){
        WaddrOffset:=WaddrOffset+io.InCol_Count_Times
    }//当AddrFifo.io.pop.fire拉高时必须更新WaddrOffset

    when(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR&&Fsm.nextState===IMG2COL_ENUM.DATA_CACHE){
        AddrFifo.io.pop.ready:=True//开始缓存之前要先pop一下,
    }
    
    //===================初始化读地址fifo======================
    val RaddrFifo0 =new WaddrOffset_Fifo//同样地再创建一个读地址fifo用于生成6个for循环的地址
    val Raddr_Initialization=Reg(UInt(16 bits))init(0)//
    RaddrFifo0.io.push.valid:=False
    RaddrFifo0.io.pop.ready:=False
    RaddrFifo0.io.push.payload:=RaddrFifo0.io.pop.payload
    when(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR){
        RaddrFifo0.io.push.valid:=True
        RaddrFifo0.io.push.payload:=Raddr_Initialization
    }
    when(Fsm.currentState===IMG2COL_ENUM.INIT_ADDR){
        Raddr_Initialization:=Raddr_Initialization+io.InCol_Count_Times
    }otherwise{
        Raddr_Initialization:=0
    }
    //用完Raddr_Initialization要重置
    
    
    //缓存数据================================================================================
    val Cache_Row_Num=UInt(5 bits)
    val Raddr_Updata_Cnt_Num=UInt(5 bits)
    val In_Col_Cnt=ForLoopCounter(io.sData.fire,16,io.InCol_Count_Times-1)
    val Row_Cache_Cnt=ForLoopCounter(In_Col_Cnt.valid,5,Cache_Row_Num-1)//在计算过程中只需要缓存Stride行数据即可
    val In_Row_Cnt=ForLoopCounter(In_Col_Cnt.valid,16,io.InFeature_Size-1)
    when(In_Col_Cnt.valid){
        AddrFifo.io.pop.ready:=True//每缓存满一行,Fifo就pop一下
    }
    when(In_Col_Cnt.valid){//这里RegNext是因为WaddrOffset从AddrFifo中读取数据需要一个周期
        AddrFifo.io.push.valid:=True//pop出来的数据也要push回去
    }
    when(In_Row_Cnt.count>io.Kernel_Size-1){
        Cache_Row_Num:=io.Stride
        Raddr_Updata_Cnt_Num:=io.Stride
    }otherwise{
        Cache_Row_Num:=io.Kernel_Size
        Raddr_Updata_Cnt_Num:=io.Kernel_Size
    }
    Fsm.Data_Cached:=Row_Cache_Cnt.valid//每次只需要缓存Kernel_Size行数据即可
    val CacheEnd_Flag=Reg(Bool())init(False)
    when(In_Row_Cnt.valid){
        CacheEnd_Flag:=True
    }elsewhen(Fsm.currentState===IMG2COL_ENUM.IDLE){
        CacheEnd_Flag:=False
    }
    Fsm.Cache_End:=CacheEnd_Flag
    io.sData.ready:=Fsm.currentState===IMG2COL_ENUM.DATA_CACHE//只有在数据缓存阶段才能接收数据,每次接收Stride的数据


    //启动计算==================================================================================
    // Fsm.SA_Ready:=True//脉动阵列已经准备好开始新的一轮计算了
    //更新读地址fifo============================================================================
        //此状态应该维持io.KernelSIze个周期，向下层模块传递Kernel_Size个基地址
    val Img2ColOutput_Module_Ready_Receive_Addr=Bool()
    
    
    // val Raddr_UpData_Cnt=ForLoopCounter((Fsm.currentState===IMG2COL_ENUM.UPDATE_ADDR&&Img2ColOutput_Module_Ready_Receive_Addr),5,Raddr_Updata_Cnt_Num-1)//这里实现从上往下的卷积
    

    when(Fsm.currentState===IMG2COL_ENUM.UPDATE_ADDR){
        RaddrFifo0.io.push.valid:=RaddrFifo0.io.pop.fire
        RaddrFifo0.io.push.payload:=RaddrFifo0.io.pop.payload
        RaddrFifo0.io.pop.ready:=Img2ColOutput_Module_Ready_Receive_Addr
    }
    // val RaddrUpdated=Bool()
    // Fsm.Addr_Updated:=RaddrUpdated//Raddr_UpData_Cnt.valid
    //=========================================================================================
        //这里实现最外层的第六层for循环,多次调用子模块
    

    val Img2Col_SubModule=new Img2Col_OutPut
    Img2Col_SubModule.io.Stride                        :=io.Stride                            
    Img2Col_SubModule.io.Kernel_Size                   :=io.Kernel_Size                       
    Img2Col_SubModule.io.Window_Size                   :=io.Window_Size                       
    Img2Col_SubModule.io.InFeature_Size                :=io.InFeature_Size                    
    Img2Col_SubModule.io.InFeature_Channel             :=io.InFeature_Channel                 
    Img2Col_SubModule.io.OutFeature_Channel            :=io.OutFeature_Channel                
    Img2Col_SubModule.io.OutFeature_Size               :=io.OutFeature_Size                   
    Img2Col_SubModule.io.OutCol_Count_Times            :=io.OutCol_Count_Times                
    Img2Col_SubModule.io.InCol_Count_Times             :=io.InCol_Count_Times                 
    Img2Col_SubModule.io.OutFeature_Channel_Count_Times:=io.OutFeature_Channel_Count_Times    

    Img2Col_SubModule.io.start:=Fsm.currentState===IMG2COL_ENUM.UPDATE_ADDR
    Img2Col_SubModule.io.SA_Idle<>Fsm.SA_Ready

    Img2Col_SubModule.io.NewAddrIn.payload<>RaddrFifo0.io.pop.payload
    Img2Col_SubModule.io.NewAddrIn.ready<>Img2ColOutput_Module_Ready_Receive_Addr
    Img2Col_SubModule.io.NewAddrIn.valid:=Fsm.currentState===IMG2COL_ENUM.UPDATE_ADDR
    Img2Col_SubModule.io.Sliding_Size:=io.Sliding_Size
    Img2Col_SubModule.io.LayerEnd:=Fsm.Layer_End
    Img2Col_SubModule.io.mReady:=io.mReady
    Img2Col_SubModule.io.Fifo_Clear:=io.Fifo_Clear
    Img2Col_SubModule.io.SA_Row_Cnt_Valid<>io.SA_Row_Cnt_Valid

    io.LayerEnd:=Fsm.Layer_End
    Fsm.Addr_Updated:=Img2Col_SubModule.io.AddrReceived
    val Out_Row_Cnt=ForLoopCounter(Img2Col_SubModule.io.SA_End,16,io.OutRow_Count_Times-1)
    // when(Fsm.currentState===IMG2COL_ENUM.IDLE){
    //     Out_Row_Cnt.clear//使用WaCounter作为最外层循环要记得最后复位
    // }
    Fsm.Layer_End:=Out_Row_Cnt.valid
    //构建一个Bram
    //val DGB=new DataGen_Bram
        // val addra=in UInt(log2Up(Config.DATA_GENERATE_BRAM_IN_ADDR_DEPTH) bits)
        // val dina=in UInt(Config.DATA_GENERATE_BRAM_IN_WIDTH bits)
        // val ena=in Bool()
        // val wea=in Bool()

        
        // val addrb=in UInt(log2Up(Config.DATA_GENERATE_BRAM_OUT_ADDR_DEPTH) bits)
        // val doutb=out UInt((Config.DATA_GENERATE_BRAM_OUT_WIDTH) bits)
        // val clkb=in Bool()


    val DGB=new xil_SimpleDualBram(Config.DATA_GENERATE_BRAM_IN_WIDTH,Config.DATA_GENERATE_BRAM_IN_ADDR_DEPTH,Config.DATA_GENERATE_BRAM_OUT_WIDTH,"DataGen_Bram",true)
    val Waddr =WaddrOffset+In_Col_Cnt.count
    DGB.io.dina:=io.sData.payload
    DGB.io.addra:=Waddr.resized//写地址,由于For循环展开都是用32bit来计数的
    DGB.io.ena:=io.sData.fire//写使能
    DGB.io.wea:=True
    DGB.io.addrb:=Img2Col_SubModule.io.Raddr.resized//读地址，循环读,还没有处理128入64出的情况,,,,
    //============
    io.mData:=DGB.io.doutb
    io.mValid:=RegNext(Img2Col_SubModule.io.Raddr_Valid)
    io.mLast:=RegNext(Out_Row_Cnt.valid)
    //============
    val Test_Valid=(io.Test_Generate_Period-1)===RegNext(Out_Row_Cnt.count)
    io.Test_Signal:=Test_Valid//(io.Test_Generate_Period-1)===RegNext(Out_Row_Cnt.count)
    io.Test_End:=(~Test_Valid)&(RegNext(Test_Valid))


    AddrFifo.io.flush:=(Fsm.nextState===IMG2COL_ENUM.IDLE)
    RaddrFifo0.io.flush:=(Fsm.nextState===IMG2COL_ENUM.IDLE)
    io.Raddr_Valid:=Img2Col_SubModule.io.Raddr_Valid//这个读地址Valid是给外面的权重缓存模块用的
}

object IMG2COL_OUTPUT_ENUM extends SpinalEnum(defaultEncoding = binaryOneHot){
    val IDLE, INIT, INIT_ADDR,SA_COMPUTE,UPDATE_ADDR,WAIT_NEXT_READY,WAIT_FIFO_CLEAR= newElement
    //WAIT_NEXT_READY:最后加的一个状态,因为img2Col处理了冗余计算，那么img2Col出数据的速度会比WeightCache模块出数据的速度快很多
    //所以img2COl模块可能会要等一下WeightCache模块，这是就需要处理数据反压
    //WAIT_FIFO_CLEAR:最最后加的一个状态，因为如果最后只激活了脉动阵列的6行，那么FIFO进数比出数快，所以最后FIFIO中一定有残留的数据没有被完全输出
    //这样的话如果直接开启第二行的计算，一定会出现7~8行FIFO提前出数导致出去的数和权重无法对齐。
    //所以最后一定要等FIFO中的数据都被清空才行。
}
case class Img2Col_Output_Fsm(start:Bool) extends Area{
    val currentState = Reg(IMG2COL_OUTPUT_ENUM()) init IMG2COL_OUTPUT_ENUM.IDLE
    val nextState = IMG2COL_OUTPUT_ENUM()
    currentState := nextState
    
    val Init_End=Bool()
    val Addr_Inited=Bool()
    val SA_Computed=Bool()
    val Addr_Updated=Bool()
    val LayerEnd=Bool()
    val NextReady=Bool()
    val Fifo_Clear=Bool()
    switch(currentState){
        is(IMG2COL_OUTPUT_ENUM.IDLE){
            when(start){
                nextState:=IMG2COL_OUTPUT_ENUM.INIT
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.IDLE
            }
        }
        is(IMG2COL_OUTPUT_ENUM.INIT){
            when(Init_End){
                nextState:=IMG2COL_OUTPUT_ENUM.INIT_ADDR
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.INIT
            }
        }
        is(IMG2COL_OUTPUT_ENUM.INIT_ADDR){//获取最新的地址数据用于内层的5个循环
            when(Addr_Inited){
                nextState:=IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.INIT_ADDR
            }
        }
        is(IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY){
            when(NextReady){//可以认为一开始FIFO都是空的，那么NextReady就一直是拉高的
                nextState:=IMG2COL_OUTPUT_ENUM.SA_COMPUTE
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY
            }
        }
        is(IMG2COL_OUTPUT_ENUM.SA_COMPUTE){
            when(LayerEnd){//当前网络层计算完了，就结束计算进入IDLE状态
                nextState:=IMG2COL_OUTPUT_ENUM.IDLE
            }elsewhen(SA_Computed){//SA_Computed实际是数据发送完成的信号
                nextState:=IMG2COL_OUTPUT_ENUM.WAIT_FIFO_CLEAR//数据发送完了就得等待FIFO清空
            }elsewhen(!NextReady){
                nextState:=IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.SA_COMPUTE
            }
        }
        is(IMG2COL_OUTPUT_ENUM.WAIT_FIFO_CLEAR){
            when(Fifo_Clear){
                nextState:=IMG2COL_OUTPUT_ENUM.UPDATE_ADDR//FIFO清空了就可以更新下一轮计算的地址了
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.WAIT_FIFO_CLEAR
            }
        }
        is(IMG2COL_OUTPUT_ENUM.UPDATE_ADDR){
            when(Addr_Updated){
                nextState:=IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY
            }otherwise{
                nextState:=IMG2COL_OUTPUT_ENUM.UPDATE_ADDR
            }
        }
    }
}
class  Img2Col_OutPut extends Component{
    //本模块用于实现5个for循环,输出标准的img2Col数据，外部会多次调用此模块
    //调用之前先要传入有效的用于内层5个循环的行基地址
    //输出读地址给顶层模块，顶层模块拿到读地址从缓存的数据中输出标准的img2Col矩阵数据
    val Config=TopConfig()
    val io=new Bundle{
        val start=in Bool()//启动信号
        val NewAddrIn=slave Stream(UInt(16 bits))//总控模块传过来的内五层循环的地址
        val SA_Idle=out Bool()//计算结束信号

        val Raddr=out UInt(16 bits)
        val Raddr_Valid=out Bool()

        val SA_End=out Bool()//一轮计算结束信号
        val Stride                          =in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长,用于从上
        val Kernel_Size                     =in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size                     =in UInt(16 bits)
        val InFeature_Size                  =in UInt(16 bits)//图片多大就输入多大的数据，目前暂时只能算正方形的图片，因为以前偷懒了，这个InFeature_Size直接代表的是图片的行列
        val InFeature_Channel               =in UInt(16 bits)
        val OutFeature_Channel              =in UInt(16 bits)
        val OutFeature_Size                 =in UInt(16 bits)//输出特征图的大小                                            
        val OutCol_Count_Times              =in UInt(16 bits)
        val InCol_Count_Times               =in UInt(16 bits)
        val OutFeature_Channel_Count_Times  =in UInt(16 bits)
        val Sliding_Size=in UInt(13 bits)//滑动长度，包含了步长信息，比如输入通道是32，步长为2，那么Kernel_Addr+=32/8*2,其中Sliding_Size=32/8*2
        
        val mReady=in Bool()//下层准备好接收数据的信号
        val Fifo_Clear=in Bool()//Img2Col和脉动阵列之间连接的fifo清空的信号
        val AddrReceived=out Bool()//地址初始化完成
        val LayerEnd=in Bool()

        val SA_Row_Cnt_Valid=out Bool()
        //同时，当拿到当前8个滑窗对应的全部输出通道后，KernelBaseAddr+=Sliding_Size<<3
        // val Sliding_Size=in UInt(16 bits)
    }
    noIoPrefix()


    val Fsm=Img2Col_Output_Fsm(io.start&&(~RegNext(io.start)))
    val Init_Count=WaCounter(Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT,3,5)//数5下进行初始化
    Fsm.Init_End:=Init_Count.valid
    Fsm.Fifo_Clear:=io.Fifo_Clear
    //初始化循环基地址=====================================================================
    io.NewAddrIn.ready:=(Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT_ADDR||Fsm.currentState===IMG2COL_OUTPUT_ENUM.UPDATE_ADDR)//位于更新Addr或初始化Addr状态则可以获取Addr
    
    
    val RaddrFifo1=new WaddrOffset_Fifo//第二个RaddrFifo,作用于内五层循环
    RaddrFifo1.io.push.valid:=False
    RaddrFifo1.io.pop.ready:=False
    val Row_Base_Addr=Reg(UInt(16 bits))init(0)
    
    

    // RaddrFifo1.io.push.payload:=(Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT_ADDR)?|
    when(RaddrFifo1.io.pop.fire){//只要fifo pop出一个数，那么就要更新一下值
        Row_Base_Addr:=RaddrFifo1.io.pop.payload
    }
    
    val Raddr_Init_Cnt=ForLoopCounter((Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT_ADDR&&RaddrFifo1.io.push.fire),5,io.Kernel_Size-1)//需要Stride个周期更新这一轮计算的循环地址
    Fsm.Addr_Inited:=Raddr_Init_Cnt.valid
    val Raddr_Update_Cnt=ForLoopCounter((Fsm.currentState===IMG2COL_OUTPUT_ENUM.UPDATE_ADDR&&RaddrFifo1.io.push.fire),5,io.Stride-1)
    Fsm.Addr_Updated:=Raddr_Update_Cnt.valid
    Fsm.NextReady:=io.mReady
    //开始计算================================================================
    io.AddrReceived:=False
    when(Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT_ADDR&&Fsm.nextState===IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY||Fsm.currentState===IMG2COL_OUTPUT_ENUM.UPDATE_ADDR&&Fsm.nextState===IMG2COL_OUTPUT_ENUM.WAIT_NEXT_READY){
        RaddrFifo1.io.pop.ready:=True//开始计算之前要先pop一下,
        io.AddrReceived:=True
    }
    



    //(核心部分）卷积窗口按行展开=================================================
    val SA_Row_Cnt=ForLoopCounter((Fsm.currentState===IMG2COL_OUTPUT_ENUM.SA_COMPUTE)&&io.mReady,3,8-1)//这个计数器对应的是脉动阵列的每一行
        //这里的意思是：脉动阵列一共有8行，每一行处理一个滑动窗口，那么8行就处理8个滑动窗口，对应特征图的一行8个输出点
        //以后这个地方需要修改为可配置的
    io.SA_Row_Cnt_Valid:=SA_Row_Cnt.valid
    val In_Channel_Process_Cnt=ForLoopCounter(SA_Row_Cnt.valid,16-3,(io.InFeature_Channel>>3)-1)//必须确保输入通道是8的倍数
        //输入通道处理次数：目前处理的输入通道次数，比如输入通道是32，一次处理8个通道，需要4次才能处理完一个点的全部的输入通道
    val Window_Col_Cnt=ForLoopCounter(In_Channel_Process_Cnt.valid,16,io.Kernel_Size-1)
    //滑动窗口列计数器
    val Window_Row_Cnt=ForLoopCounter(Window_Col_Cnt.valid,16,io.Kernel_Size-1)
    //滑动窗口行计数器
        //与上Window_Col_Cnt.valid的原因：当Window_Col_Cnt==15时会一直拉高，
    val Out_Channel_Cnt=ForLoopCounter(Window_Row_Cnt.valid,16,io.OutFeature_Channel_Count_Times-1)//因为一下出8个通道，所以得除以8
    //这里假设输出通道总是能被8整除，比如输出通道比较大，768个通道，一下处理8个通道，那么需要768/8=96个循环。
    val Out_Col_Cnt=ForLoopCounter(Out_Channel_Cnt.valid,16,io.OutCol_Count_Times-1)//输出列计数器，比如输出特征图的大小是14列，但是我们的输出并行度是8，所以这里应该是ceil(14/8)=2
    io.SA_End:=Out_Col_Cnt.valid
    //冗余计算处理==============================================================================
    val OutFeature_Col_Lefted=Reg(UInt(16 bits))init(0)//用来标记输出特征图一行还剩多少列没处理
    when(Out_Col_Cnt.valid){
        OutFeature_Col_Lefted:=io.OutFeature_Size//跑完一行后归位
    }elsewhen(Out_Channel_Cnt.valid){
        //当8个输入通道与所有卷积核计算完后得到输出特征图一行8个点的全部输出通道
        //还没处理的输出特征图的列数减8更新
        OutFeature_Col_Lefted:=OutFeature_Col_Lefted-8
    }elsewhen(Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT){
        OutFeature_Col_Lefted:=io.OutFeature_Size
    }
    when((SA_Row_Cnt.count===OutFeature_Col_Lefted-1)&&io.mReady&&(Fsm.currentState===IMG2COL_OUTPUT_ENUM.SA_COMPUTE)){//得减个1，看仿真看出来的，分析也好分析
        SA_Row_Cnt.valid:=True
        SA_Row_Cnt.count:=0
    }
    val WindowSize_Cnt=ForLoopCounter(SA_Row_Cnt.valid,13,io.Window_Size-1)
    val Kernel_Addr=Reg(UInt(32 bits))init(0)//WaCounter(Window_Row.valid,32,Config.PICTURE_SIZE-io.Kernel_Size-1,Stride=io.Stride)//默认卷积核的最右边一列最后可以到达输入特征图的最右边
        //当输出完一个滑动窗口的所有点后,卷积核开始移动
        //Kernel_Addr对应的是卷积滑动窗口top-left点的相对地址(注意是相对地址,后面读写时相对地址加上地址偏移就是绝对地址)
    val Kernel_Base_Addr=Reg(UInt(32 bits))init(0)
    when(Out_Col_Cnt.valid){//每得到输出特征图的一行，卷积核地址复位
        Kernel_Base_Addr:=0
    }elsewhen(Out_Channel_Cnt.valid){//每输出8个点对应的全部通道，也就是Out_Feature的一行的8个点，卷积核基地址后移8个滑动窗口位置
        Kernel_Base_Addr:=Kernel_Base_Addr+(io.Sliding_Size<<3).resized//一个Window_Size对应一个滑动窗口的全部数据的地址长度,并行度是8,
    }//一个Window_Size最大的大小就是:KernelSize*Compute_In_Channel,Compute_In_Channel最大是8
    when(Out_Col_Cnt.valid){
        //拿到输出矩阵的一行后，Kernel_Base_Addr和Kernel_Addr都要归位
        Kernel_Addr:=0
    }elsewhen(Out_Channel_Cnt.valid){
        Kernel_Addr:=Kernel_Base_Addr+(io.Sliding_Size<<3).resized//一轮输出通道处理完,8个滑动窗口右移更新成下一8滑动窗口的相对起始地址,
    }elsewhen(Window_Row_Cnt.valid){
        Kernel_Addr:=Kernel_Base_Addr
    }elsewhen(WindowSize_Cnt.valid){
        Kernel_Addr:=Kernel_Base_Addr//处理完Window_Size个数据也就是InChannel*KernelSize/8个数据后需要归位
    }elsewhen(SA_Row_Cnt.valid){//输完8个卷积核中的第一个点,然后再重新回来输第二个点,输完8个滑窗
        Kernel_Addr:=Kernel_Base_Addr+WindowSize_Cnt.count+1//因为In_Channel_Process_Cnt计数器慢一拍
    }elsewhen(Fsm.currentState===IMG2COL_OUTPUT_ENUM.SA_COMPUTE&&io.mReady){
        Kernel_Addr:=Kernel_Addr+io.Sliding_Size//每向SA输入一行数据,Kernel_Addr就加一个步长
        //Bug修复：注意需要考虑输入通道：步长跨越了输入通道，比如步长为2，输入通道为32，那么下一个地址应该是2*32
    }

    io.Raddr:=(Kernel_Addr+Row_Base_Addr).resized
    Fsm.SA_Computed:=Out_Col_Cnt.valid//得到输出特征图完整的一行后要等一下。
    io.SA_Idle:=Fsm.currentState===IMG2COL_OUTPUT_ENUM.IDLE||Fsm.currentState===IMG2COL_OUTPUT_ENUM.UPDATE_ADDR

    //循环写回地址===========================================
    when(Fsm.currentState===IMG2COL_OUTPUT_ENUM.INIT_ADDR){//初始化阶段只push
        RaddrFifo1.io.push.valid:=io.NewAddrIn.valid
        RaddrFifo1.io.push.payload:=io.NewAddrIn.payload
        // RaddrFifo1.io.pop.ready:=True
    }elsewhen(Fsm.currentState===IMG2COL_OUTPUT_ENUM.UPDATE_ADDR){//更新地址阶段除了push进来还要pop出去
        RaddrFifo1.io.push.valid:=io.NewAddrIn.valid
        RaddrFifo1.io.push.payload:=io.NewAddrIn.payload
        RaddrFifo1.io.pop.ready:=RaddrFifo1.io.push.fire//进来一个就pop一个
    }otherwise{
        RaddrFifo1.io.push.payload:=Row_Base_Addr
        RaddrFifo1.io.push.valid:=Window_Col_Cnt.valid
    }
    when(Window_Col_Cnt.valid){
        RaddrFifo1.io.pop.ready:=True//每处理完一行,就pop一下
    }
    //======================================================
    // RaddrFifo1.io.flush:=Fsm.nextState===IMG2COL_OUTPUT_ENUM.IDLE
    io.Raddr_Valid:=(Fsm.currentState===IMG2COL_OUTPUT_ENUM.SA_COMPUTE)&&io.mReady
    Fsm.LayerEnd:=io.LayerEnd
    RaddrFifo1.io.flush:=Fsm.currentState===IMG2COL_OUTPUT_ENUM.IDLE


        //ila===============================================================================================
    if(Config.ila){
        val Debug_Signals=Array[Bits](Fsm.currentState.asBits,io.SA_Idle.asBits,io.SA_End.asBits)
        val Debug_Name=Array[String]("Fsm_currentState","SA_Idle","SA_End")
        val ila=new xil_ila(Debug_Signals,true,"ila_Img2Col")
        for(i<-0 to Debug_Signals.length-1){
            ila.probe(i):=Debug_Signals(i)
            Debug_Signals(i).setName("Debug_"+Debug_Name(i))
        }
    }

}

class Img2ColStreamV2 extends Component{
    val Config=TopConfig()
    val io=new Bundle{
        
        val mData=out UInt(64 bits)//out UInt(64 bits)//Vec(UInt(8 bits),8)
        // val mReady=in Bool()
        val mValid=out Bits(Config.SA_ROW bits)

        def DATA_IN_WIDTH=64
        val s_axis_s2mm_tdata=in UInt(DATA_IN_WIDTH bits)
        val s_axis_s2mm_tkeep=in Bits(DATA_IN_WIDTH/8 bits)
        val s_axis_s2mm_tlast=in Bool()
        val s_axis_s2mm_tready=out Bool()
        val s_axis_s2mm_tvalid=in Bool()

        // val m_tlast=out Bool()
        val start=in Bool()
        val Raddr_Valid=out Bool()
        val LayerEnd=out Bool()
        // val MatrixRow_Switch=out UInt(Config.SA_ROW bits)



        val Stride                          =in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size                     =in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size                     =in UInt(16 bits)
        val InFeature_Size                  =in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel               =in UInt(16 bits)//输入通道的信息已经包含在WindowSize中，可能以后用不到了
        val OutFeature_Channel              =in UInt(16 bits)
        val OutFeature_Size                 =in UInt(16 bits)//输出特征图的大小                                            
        val OutCol_Count_Times              =in UInt(16 bits)
        val InCol_Count_Times               =in UInt(16 bits)//这玩意又是啥？
        val OutRow_Count_Times              =in UInt(16 bits)
        val OutFeature_Channel_Count_Times  =in UInt(16 bits)
        val Sliding_Size                    =in UInt(16-3 bits)
    }
    noIoPrefix()
    val SubModule=new Img2Col_Top
    val WidthConvert_Fifo=new Array[StreamFifo[UInt]](8)
    val Converter=new Array[AxisDataConverter](8)
    
    // SubModule.io.mData<>io.mdata
    
    // io.Raddr_Valid:=RegNext(SubModule.io.Raddr_Valid)
    //分析：不想写了，自己看波形叭~，---->计算模块开发记录-2023/3/4:连连线
    val OutData_Switch=Reg(Bits(8 bits))init(1)
    val Switch_Reset=RegNext(SubModule.io.SA_Row_Cnt_Valid)
    when(Switch_Reset){
        OutData_Switch:=1
    }elsewhen(SubModule.io.mValid){
        OutData_Switch:=OutData_Switch.rotateLeft(1)//循环左移1位    
    }
    val TestValid_Signal=Vec(Bool(),8)//8个测试信号，以后要删除
    for (i<-0 to 7){
        
        WidthConvert_Fifo(i)=new StreamFifo(UInt(64 bits),16)
        Converter(i)=new AxisDataConverter(64,8)
        WidthConvert_Fifo(i).io.push.payload:=SubModule.io.mData
        WidthConvert_Fifo(i).io.push.valid:=(OutData_Switch(i downto i).asBool)&&SubModule.io.mValid
        WidthConvert_Fifo(i).setDefinitionName("Img2Col_WidthConverter_Fifo")
        Converter(i).inStream<>WidthConvert_Fifo(i).io.pop
        Converter(i).outStream.ready:=True
        io.mData((i+1)*8-1 downto i*8):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
        io.mValid(i):=RegNext(Converter(i).outStream.valid)//这个valid信号给到脉动阵列
        //io.mData(i):=RegNext(Converter(i).outStream.payload)//valid拉高，数据应该在valid拉高的下一个周期出去，这是为了与weightCache对上
    }
    //存在一个问题：如果现在只激活了脉动阵列的1~6行，那么还剩两行没有激活
    //在进入第二轮计算时，也就是处理输出图片的第二行，一开始1~6行的fifo中还有保留有数据没有出去，但是7~8行的fifo没有数据，这时就会出现7~8行提前计算，这样7~8行的激活就没有和权重对齐，
    //导致7~8行提前输出并且结果还不对，，，，
    //，，，，，很难改，
    
    io.Raddr_Valid:=Converter(0).outStream.valid
    // val WeightCached_Flag=Bool
    SubModule.io.sData.payload<>io.s_axis_s2mm_tdata
    SubModule.io.sData.valid<>io.s_axis_s2mm_tvalid
    SubModule.io.sData.ready<>io.s_axis_s2mm_tready
    SubModule.io.start:=io.start



    SubModule.io.Stride                         <>io.Stride                         
    SubModule.io.Kernel_Size                    <>io.Kernel_Size                    
    SubModule.io.Window_Size                    <>io.Window_Size                    
    SubModule.io.InFeature_Size                 <>io.InFeature_Size                 
    SubModule.io.InFeature_Channel              <>io.InFeature_Channel              
    SubModule.io.OutFeature_Channel             <>io.OutFeature_Channel             
    SubModule.io.OutFeature_Size                <>io.OutFeature_Size                
    SubModule.io.OutCol_Count_Times             <>io.OutCol_Count_Times             
    SubModule.io.InCol_Count_Times              <>io.InCol_Count_Times              
    SubModule.io.OutRow_Count_Times             <>io.OutRow_Count_Times             
    SubModule.io.OutFeature_Channel_Count_Times <>io.OutFeature_Channel_Count_Times 
    SubModule.io.Sliding_Size                   <>io.Sliding_Size                   
    SubModule.io.Fifo_Clear                     <>(!WidthConvert_Fifo(0).io.pop.valid)

    SubModule.io.mReady                         :=WidthConvert_Fifo(0).io.push.ready
    io.LayerEnd:=Delay(SubModule.io.LayerEnd,3)
//调试信号================================================================================================
    // //val Out_Data_Counter=WaCounter(io.mReady&&io.mValid,32,U"32'hffffffff")       
    // val In_Data_Counter=WaCounter(io.s_axis_s2mm_tvalid&&io.s_axis_s2mm_tready,32,U"32'hffffffff")   
    // when(io.start){
    //     //Out_Data_Counter.clear
    //     In_Data_Counter.clear
    // }


}

object Img2ColGen extends App { 
    val verilog_path="./verilog/SimImg2Col" 
    SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Img2Col_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new DataGenerate_Top)
    //SpinalConfig(targetDirectory=verilog_path, defaultConfigForClockDomains = ClockDomainConfig(resetActiveLevel = HIGH)).generateVerilog(new Dynamic_Shift)
}