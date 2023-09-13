package  TestSpace
import  spinal.core._
class ODDR_Module extends BlackBox {
  val io = new Bundle {
    val Q=out Bits(1 bit)
    val C=in Bool()//时钟输入
    val CE=in Bool()//clk enable
    val D1=in Bits(1 bit)//position edge
    val D2=in Bits(1 bit)//negative edge
    val R=in Bool()//reset
    val S=in Bool()//set
  }
  noIoPrefix()
  mapClockDomain(clock = io.C)
  // 在BlackBox中插入自己的Verilog代码
  // 例如：setDefinitionName("my_black_box")
  // 例如：addRTLPath("path/to/my_black_box.v")
  //setInlineVerilog("");
  //addRTLPath("E:\\Transformer\\Spinal\\src\\main\\scala\\TestSpace\\ODDR.v")
  val verilogstr="ODDR #(\n" +
    ".DDR_CLK_EDGE(\"SAME_EDGE\"),\n" +
    ".INIT(1'b0),    \n" +
    ".SRTYPE(\"SYNC\") \n" +
    ") ODDR_inst (\n" +
    ".Q(Q),   \n" +
    ".C(C),   \n" +
    ".CE(CE), \n" +
    ".D1(D1), \n" +
    ".D2(D2), \n" +
    ".R(R),   \n" +
    ".S(S)    \n" +
    ");\n"
  setInlineVerilog(verilogstr);
  
}

//TX DDR Single port 
class TX_DDR extends Component{
    val io=new Bundle{
        val I_12bit=in Bits(12 bits)
        val Q_12bit=in Bits(12 bits)//输入的12位数据，然后再将其拆成6bit，作为单口数据输出
        val Tx_Frame=in Bool()

        val Tx_6bit=out Bits(6 bits)//I的高六位
        //val Q_6bit=out Bits(6 bits)//Q的高六位
    }

    //思路：将收到的12bit数据拆成高6bit和低6bit
    //Tx_Frame为高则标记高6bit
    val I_Lsb=RegNextWhen(io.I_12bit(5 downto 0),io.Tx_Frame)
    val Q_Lsb=RegNextWhen(io.Q_12bit(5 downto 0),io.Tx_Frame)

    //Oddr采用Same edge模式
    val ODDR_D1=io.Tx_Frame?io.I_12bit(11 downto 6)|I_Lsb
    val ODDR_D2=io.Tx_Frame?io.Q_12bit(11 downto 6)|Q_Lsb

    val oddr_module=new Array[ODDR_Module](6)
    for(i<-0 to 5){
        oddr_module(i)=new ODDR_Module
        oddr_module(i).io.R:=False
        oddr_module(i).io.S:=False
        oddr_module(i).io.CE:=True
        oddr_module(i).io.D1:=ODDR_D1(i downto i)
        oddr_module(i).io.D2:=ODDR_D2(i downto i)
        io.Tx_6bit(i downto i):=oddr_module(i).io.Q
    }



    
}