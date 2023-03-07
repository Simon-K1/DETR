package top
import spinal.core._
import Systolic_Array.{Tile,DataGenerate_Top,Weight_Cache,PEConfig,Img2Col_Top}
import utils.{TopConfig,WaCounter,WidthConvert}

class Img2ColStream extends Component{
    //此模块用于整合到脉动阵列中
    val Config=TopConfig()
    val io=new Bundle{
        
        val mdata=out Vec(Bits(8 bits),8)
        val mReady=in Bool()
        val mvalid=out Bool()

        def DATA_OUT_WIDTH=64
        val s_axis_s2mm_tdata=in UInt(DATA_OUT_WIDTH bits)
        val s_axis_s2mm_tkeep=in Bits(DATA_OUT_WIDTH/8 bits)
        val s_axis_s2mm_tlast=in Bool()
        val s_axis_s2mm_tready=out Bool()
        val s_axis_s2mm_tvalid=in Bool()

        // val m_tlast=out Bool()
        val start=in Bool()
        val Raddr_Valid=out Bool()
    }
    noIoPrefix()
    val SubModule=new Img2Col_Top
    val WidthConvert_Array=new Array[WidthConvert](8)

    
    // SubModule.io.mData<>io.mdata
    io.mvalid:=RegNext(SubModule.io.mValid)//数据进WidthConverter后会慢一个周期才能出来
    io.Raddr_Valid:=RegNext(SubModule.io.Raddr_Valid)
    //分析：不想写了，自己看波形叭~，---->计算模块开发记录-2023/3/4:连连线
    val OutData_Switch=Reg(Bits(8 bits))init(1)
    when(SubModule.io.mValid){
        OutData_Switch:=OutData_Switch.rotateLeft(1)//循环左移1位    
    }
    for (i<-0 to 7){
        WidthConvert_Array(i)=new WidthConvert
        WidthConvert_Array(i).io.InData.payload:=SubModule.io.mData.asBits
        WidthConvert_Array(i).io.InData.valid:=OutData_Switch(i downto i).asBool
        io.mdata(i):=WidthConvert_Array(i).io.OutData
    }
    

    SubModule.io.sData.payload<>io.s_axis_s2mm_tdata
    SubModule.io.sData.valid<>io.s_axis_s2mm_tvalid
    SubModule.io.sData.ready<>io.s_axis_s2mm_tready
    SubModule.io.start<>io.start

    // val Stride=16
    // val Kernel_Size=16
    // val InFeature_Size=224//图片大小为224*224


    SubModule.io.Stride                            :=16
    SubModule.io.Kernel_Size                       :=16
    SubModule.io.Window_Size                       :=64
    SubModule.io.InFeature_Size                    :=224
    SubModule.io.InFeature_Channel                 :=32
    SubModule.io.OutFeature_Channel                :=32
    SubModule.io.OutFeature_Size                   :=14
    SubModule.io.OutCol_Count_Times                :=2
    SubModule.io.InCol_Count_Times                 :=896
    SubModule.io.OutRow_Count_Times                :=14
    SubModule.io.OutFeature_Channel_Count_Times    :=4
    SubModule.io.Sliding_Size                      :=64
    SubModule.io.mReady                            :=io.mReady

//调试信号================================================================================================
    val Out_Data_Counter=WaCounter(io.mReady&&io.mvalid,32,U"32'hffffffff")       
    val In_Data_Counter=WaCounter(io.s_axis_s2mm_tvalid&&io.s_axis_s2mm_tready,32,U"32'hffffffff")   
    when(io.start){
        Out_Data_Counter.clear
        In_Data_Counter.clear
    }
    
//调试信号end==============================================================================================
            
}