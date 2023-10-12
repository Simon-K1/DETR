package Systolic_Array.SystolicArray3D

//2023/10/12  实在不知道怎么办了，数据流先不管他了，直接把计算完的数据收回来放DDR里，之后再重新发回去得了
import spinal.core._
import utils._
import Systolic_Array.Img2ColStreamV2
import spinal.lib.Delay
import Systolic_Array.Quant.ConvQuant
import LayerNorm.LayerNorm_Top
import spinal.lib.StreamWidthAdapter
import Systolic_Array.Quant.Quan
//Switch模块是不是得添加一些组合逻辑，不然可能时序过不去
class Axis_Switch_M2S(Slave_Port_Num:Int,Data_Width:Int) extends Component{
    val io=new Bundle{//master to Slave,一个master口转成多个Slave口
        val Switch=in UInt(Slave_Port_Num bits)
    }
    noIoPrefix()
    val m0_axis_mm2s=new Bundle{//一个主接口，多个从接口
        val tdata=out UInt(Data_Width bits)
        val tkeep=out Bits(Data_Width/8 bits)
        val tlast=out Bool()
        val tready=in Bool()
        val tvalid=out Bool()
    }
    val s=Vec(new Bundle{        
        val axis_s2mm_tdata=in UInt(Data_Width bits)
        val axis_s2mm_tkeep=in Bits(Data_Width/8 bits)
        val axis_s2mm_tlast=in Bool()
        val axis_s2mm_tready=out Bool()
        val axis_s2mm_tvalid=in Bool()
        axis_s2mm_tready:=False
    },Slave_Port_Num)//生成这么多个slave口，放左边
    m0_axis_mm2s.tdata:=0
    m0_axis_mm2s.tkeep:=0
    m0_axis_mm2s.tlast:=False
    m0_axis_mm2s.tvalid:=False
    for(i<-0 to Slave_Port_Num-1){
        when(io.Switch(i)){
            s(i).axis_s2mm_tready:=m0_axis_mm2s.tready//出去的ready
            m0_axis_mm2s.tkeep:=s(i).axis_s2mm_tkeep
            m0_axis_mm2s.tdata:=s(i).axis_s2mm_tdata
            m0_axis_mm2s.tlast:=s(i).axis_s2mm_tlast
            m0_axis_mm2s.tvalid:=s(i).axis_s2mm_tvalid
        }
    }
}
class Axis_Switch_S2M(Master_Port_Num:Int,Data_Width:Int) extends Component{
    val io=new Bundle{//Slave to Master,1个Slave转成多个master口
        val Switch=in Bits(Master_Port_Num bits)
    }
        noIoPrefix()
    val s0_axis_s2mm=new Bundle{//一个从接口，两个主接口
        val tdata=in UInt(Data_Width bits)
        val tkeep=in Bits(Data_Width/8 bits)
        val tlast=in Bool()
        val tready=out Bool()
        val tvalid=in Bool()
    }

    val m=Vec(new Bundle{        
        val axis_mm2s_tdata=out UInt(Data_Width bits)
        val axis_mm2s_tkeep=out Bits(Data_Width/8 bits)
        val axis_mm2s_tlast=out Bool()
        val axis_mm2s_tready=in Bool()
        val axis_mm2s_tvalid=out Bool()
        axis_mm2s_tkeep:=s0_axis_s2mm.tkeep
        },Master_Port_Num)
    s0_axis_s2mm.tready:=False
    for(i<-0 to Master_Port_Num-1){
        when(io.Switch(i)){
            s0_axis_s2mm.tready:=m(i).axis_mm2s_tready
            m(i).axis_mm2s_tdata:=s0_axis_s2mm.tdata
            m(i).axis_mm2s_tlast:=s0_axis_s2mm.tlast
            m(i).axis_mm2s_tvalid:=s0_axis_s2mm.tvalid
        }otherwise{
            m(i).axis_mm2s_tdata:=0
            m(i).axis_mm2s_tlast:=False
            m(i).axis_mm2s_tvalid:=False
        }
    }
}

class SA_3D_SwitchVersion(SLICE:Int,HEIGHT:Int,WIDTH:Int,ACCU_WITDH:Int,val MODULE_NUM:Int=5) extends Component{
    val Config=TopConfig()
    val Control=new Bundle{
        val start=in Bool()
        val Switch             =in Bits(MODULE_NUM bits)//模块选择
    }
    val s_axis_s2mm=new Bundle{//一个从接口，两个主接口
        val Data_Width=64
        val tdata=in UInt(Data_Width bits)
        val tkeep=in Bits(Data_Width/8 bits)
        val tlast=in Bool()
        val tready=out Bool()
        val tvalid=in Bool()
    }

    val QuantInstru=new Bundle{
      val zeroIn=in UInt(8 bits)//量化零点
    }
    val Img2Col_Instru=new Bundle{
        val Stride                          =in UInt(Config.DATA_GENERATE_CONV_STRIDE_WIDTH bits)//可配置步长
        val Kernel_Size                     =in UInt(Config.DATA_GENERATE_CONV_KERNELSIZE_WIDTH bits)//
        val Window_Size                     =in UInt(16 bits)
        val InFeature_Size                  =in UInt(16 bits)//图片多大就输入多大的数据
        val InFeature_Channel               =in UInt(16 bits)//输入通道的信息已经包含在WindowSize中，可能以后用不到了
        val OutFeature_Channel              =in UInt(16 bits)
        val OutFeature_Size                 =in UInt(16 bits)//输出特征图的大小     
        val Sliding_Size                    =in UInt(16-3 bits)                                       
        val OutCol_Count_Times              =in UInt(16 bits)
        val InCol_Count_Times               =in UInt(16 bits)//这玩意又是啥？
        val OutRow_Count_Times              =in UInt(16 bits)
        val OutFeature_Channel_Count_Times  =in UInt(16 bits)
        

        val WeightMatrix_Row                =in UInt(Config.WEIGHT_CACHE_MATRIX_ROW_WIDTH bits)

        val OutMatrix_Col                   =in UInt(Config.MATRIXC_COL_WIDTH bits)//输出矩阵的列数，比如脉动阵列最终的输出矩阵C为196*768，那么行数和列数分别书196*768
        val OutMatrix_Row                   =in UInt(Config.MATRIXC_ROW_WIDTH bits)//输出矩阵的行数
        
        //val LayerNorm_TokenNums             =in UInt(16 bits)//TokenNums Ceil(OutMatrix_Row/8)

    }
    Img2Col_Instru.setName("Img2Col")
    val Fsm=TopCtrl_Fsm(Control.start)
    val LayerEnd=Bool()
    Fsm.Compute_End:=LayerEnd
    val InitCnt=WaCounter(Fsm.currentState===TopCtrl_Enum.INIT,3,5)
    Fsm.Inited:=InitCnt.valid

    val InputSwitch=new Axis_Switch_S2M(MODULE_NUM,64)//5个接口
    InputSwitch.setDefinitionName("Compute_DataIn_Switch")

    
    InputSwitch.s0_axis_s2mm<>s_axis_s2mm


    val WEIGHT_NUM  =1
    val QUANT_NUM   =2
    val IMG2COL_NUM =3
    val LAYERNORM_NUM=4
    val SOFTTMAX_NUM=5

    noIoPrefix()
    val SubModule_WeightCache   =new WeightCache_Stream(8,8,8,64)//1
    val SubModule_ConvQuant     =new ConvQuant//2
    val SubModule_Img2Col       =new Img2ColStreamV2//3
    val SubModule_LayerNorm     =new LayerNorm_Top//4
    // val SubModule_Softmax       =new SoftMax_Top //5
    val SubModule_SA_3D         =new SA_3D(SLICE,HEIGHT,WIDTH,ACCU_WITDH)//8*8*8的脉动阵列
    val SubModule_Flatten       =new Flatten(SLICE,HEIGHT,WIDTH,ACCU_WITDH)
    val SubModule_DataArrange   =new ConvArrangeV3(SLICE,HEIGHT,WIDTH)
    
    
    //#todo---这里以后如果添加了矩阵计算模块要重新switch
    for(i<-0 to HEIGHT-1){
        for(j<-0 to SLICE-1){
            SubModule_SA_3D.SA_Inputs(j).MatrixA(i):=SubModule_Img2Col.io.mData((i+1)*8-1 downto i*8).asSInt//SLICE轴的每一行的输入一样
            SubModule_SA_3D.SA_Inputs(j).A_Valid(i):=SubModule_Img2Col.io.mValid(i)
        }
    }
    for(j<-0 to SLICE-1){
      SubModule_SA_3D.SA_Inputs(j).signCount :=Img2Col_Instru.WeightMatrix_Row-1
    }
    SubModule_SA_3D.start:=Control.start
    SubModule_Img2Col.io.s_axis_s2mm_tdata   <>InputSwitch.m(IMG2COL_NUM).axis_mm2s_tdata
    SubModule_Img2Col.io.s_axis_s2mm_tkeep   <>InputSwitch.m(IMG2COL_NUM).axis_mm2s_tkeep
    SubModule_Img2Col.io.s_axis_s2mm_tlast   <>InputSwitch.m(IMG2COL_NUM).axis_mm2s_tlast
    SubModule_Img2Col.io.s_axis_s2mm_tready  <>InputSwitch.m(IMG2COL_NUM).axis_mm2s_tready
    SubModule_Img2Col.io.s_axis_s2mm_tvalid  <>InputSwitch.m(IMG2COL_NUM).axis_mm2s_tvalid
    
    SubModule_Img2Col.io.Stride                        <>Img2Col_Instru.Stride                        
    SubModule_Img2Col.io.Kernel_Size                   <>Img2Col_Instru.Kernel_Size                   
    SubModule_Img2Col.io.Window_Size                   <>Img2Col_Instru.Window_Size                   
    SubModule_Img2Col.io.InFeature_Size                <>Img2Col_Instru.InFeature_Size                
    SubModule_Img2Col.io.InFeature_Channel             <>Img2Col_Instru.InFeature_Channel             
    SubModule_Img2Col.io.OutFeature_Channel            <>Img2Col_Instru.OutFeature_Channel            
    SubModule_Img2Col.io.OutFeature_Size               <>Img2Col_Instru.OutFeature_Size               
    SubModule_Img2Col.io.OutCol_Count_Times            <>Img2Col_Instru.OutCol_Count_Times            
    SubModule_Img2Col.io.InCol_Count_Times             <>Img2Col_Instru.InCol_Count_Times             
    SubModule_Img2Col.io.OutRow_Count_Times            <>Img2Col_Instru.OutRow_Count_Times            
    SubModule_Img2Col.io.OutFeature_Channel_Count_Times<>Img2Col_Instru.OutFeature_Channel_Count_Times
    SubModule_Img2Col.io.Sliding_Size                  <>Img2Col_Instru.Sliding_Size  

    for(i<-0 to WIDTH-1){//遍历每一列
        for(j<-0 to SLICE-1){//遍历每个slice，slice是最内层循环
            SubModule_SA_3D.SA_Inputs(j).MatrixB(i):=Delay(SubModule_WeightCache.io.mData(i*SLICE+j).asSInt,i)
            SubModule_SA_3D.SA_Inputs(j).B_Valid(i):=Delay(SubModule_WeightCache.io.MatrixCol_Switch(i*SLICE+j),i)//权重数据在进入SA之前需要做一下延迟
            //这里在仿真的时候很绕，需要注意(见pic0和pic1)
        }
    }

    SubModule_Img2Col.io.start                      :=Control.start&Control.Switch(IMG2COL_NUM)//启动Img2Col，必须在权重缓存完后才能启动Img2Col，缓存的权重中还包含了量化因子
    
    SubModule_WeightCache.io.Matrix_Row :=Img2Col_Instru.WeightMatrix_Row
    SubModule_WeightCache.io.Matrix_Col :=Img2Col_Instru.OutFeature_Channel
    SubModule_WeightCache.io.start      :=Control.Switch(WEIGHT_NUM)&Control.start
    // SubModule_WeightCache.io.Raddr_Valid:=SubModule_Img2Col.io.Raddr_Valid//||LH_Gemm.io.bvalid---todo，重点关注
    SubModule_WeightCache.io.LayerEnd   :=LayerEnd
    // Fsm.WeightCached          :=SubModule_WeightCache.io.Weight_Cached//(ConvQuant.io.QuantPara_Cached)---todo,重点关注

    SubModule_WeightCache.io.s_axis_s2mm_tdata <>InputSwitch.m(WEIGHT_NUM).axis_mm2s_tdata//RegNext(InputSwitch.m(0).axis_mm2s_tdata)
    SubModule_WeightCache.io.s_axis_s2mm_tkeep <>InputSwitch.m(WEIGHT_NUM).axis_mm2s_tkeep
    SubModule_WeightCache.io.s_axis_s2mm_tlast <>InputSwitch.m(WEIGHT_NUM).axis_mm2s_tlast
    SubModule_WeightCache.io.s_axis_s2mm_tready<>InputSwitch.m(WEIGHT_NUM).axis_mm2s_tready
    SubModule_WeightCache.io.s_axis_s2mm_tvalid<>InputSwitch.m(WEIGHT_NUM).axis_mm2s_tvalid//RegNext(InputSwitch.m(0).axis_mm2s_tvalid)
    
    //阵列输出数据展平模块--[SA_3D-->Flatten]==============================================================================================================
    for(i<-0 to HEIGHT-1){
      for(j<-0 to SLICE-1){
        SubModule_Flatten.sData.payload(i)(j):=SubModule_SA_3D.Matrix_C.payload(i)(ACCU_WITDH*(j+1)-1 downto ACCU_WITDH*j)
        SubModule_Flatten.sData.valid(i)     :=SubModule_SA_3D.Matrix_C.valid(i)
      }
    }
}   