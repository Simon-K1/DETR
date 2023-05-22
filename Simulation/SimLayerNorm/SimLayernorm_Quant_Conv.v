`timescale 1ns / 1ps

module Sim_LayernormV2;
parameter Mem_Depth =197*768;
parameter Mem_Width=20;//txt数据位宽
parameter Total_Input_Times=197*768;//发完2224*224*64bit数据后mValid需要拉低

parameter Mem2_Depth=768;//第二个Mem的配置
parameter Mem2_Width=16;

  reg clk;
  reg rst;

  wire mReady;
  reg mValid;
  wire mReady2;
  reg mValid2;

  reg sReady;
  wire sValid;
  wire sLast;//获取sLast信号，第二次启动。
  wire Start_Again_En;
  assign Start_Again_En=0;//需要仿真再次启动
  reg start;
  reg start2;
  wire [63:0]sData;

  reg [31:0]Total_Cnt;//用来模拟Mvalid和Sready
  reg [63:0]Out_Total_Cnt;//输出数据计数器，用来计数输出数据的
  reg[63:0]Input_Total_Cnt;//用来计算输入数据数量
  reg [63:0]Input_Total_Cnt2;
  reg [31:0]mem_addr;
  reg [31:0]mem_addr2;  
  
  reg	[Mem_Width-1:0]	mem	[0:Mem_Depth-1];
  
  reg [Mem2_Width-1:0]mem2[0:Mem2_Depth-1];
  wire Write_Txt_En;
  wire Write_Txt_End;    
  reg [1:0]InSwitch; 
//  导出txt数据=====================================================
//E:\\Transformer\\Sim_Transformer\\SimData_Output\\DataGenerate.txt
//  integer file_out;
//  initial
//  begin

//      file_out = $fopen("C:\\Users\\25073\\Desktop\\compare\\VivadoOutput.txt","w+");//记得用\\分开
//      if (!file_out) begin
//          $display("can't open file");
//          $finish;
//      end
//  end 

//  always @ (posedge clk) begin  
//        if(Write_Txt_End)begin
//           $fclose(file_out);  //关闭写文件
//        end
//        else if(sValid&&Write_Txt_En) begin
//          $fdisplay(file_out, "%h", sData);//将数据写到TXT文件中，并且自动换行
//        end 
//  end
//  ==========================================
  initial
  begin

//    $readmemh("E:\\Transformer\\Transformer_Arithmatic\\Transformer_Main\\TXT\\WeightPicture.txt",mem);//_Modified
//    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\MM_Test\\WeightMatrix.txt",mem);
    $readmemh("E:\\Transformer\\Matlab\\LayerNorm_Txt_Gen\\Generated_Files\\522\\Xq_LayerNorm乘掩码19bit.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\LayerNorm_Txt_Gen\\Generated_Files\\522\\Scale_Bias.txt",mem2);//高8bit为Scale，低8bit为Bias
    clk=0;
    start=0;
    rst=1;
    InSwitch=1;
    mValid=0;
    mem_addr=0;
    mem_addr2=0;
    #20000
     rst=0;
     start=1;
     start2=1;
    #200
     start=0;
     start2=0;
     #20000
     InSwitch=0;
  end
  always#5 clk=~clk;//100M时钟


  //全局计数器，用于控制Mvalid和Sready
  always@(posedge clk)
  begin
    if(rst)
    begin
      Total_Cnt<=0;
    end
    else if(Total_Cnt<512)
    begin
      Total_Cnt<=Total_Cnt+1'b1;
    end
    else
      Total_Cnt<=0;
  end
  //输出数据计数器===============================================
  always@(posedge clk)
  begin
    if(rst)
    begin
      Out_Total_Cnt<=0;
    end
    else if(sReady&&sValid)
    begin
      Out_Total_Cnt<=Out_Total_Cnt+1'b1;
    end
    else if(sLast)
      Out_Total_Cnt<=0;
    else
      Out_Total_Cnt<=Out_Total_Cnt;
  end
  //数据输入，没有延时，直接从reg中读出来=========================
  always@(posedge clk)
  begin
    if(rst)
    begin
      mem_addr<=0;
    end
    else if(start)
    begin//
      mem_addr<=0;
    end
    else if(mValid&&mReady)
      mem_addr<=mem_addr+1'b1;
    else
      mem_addr<=mem_addr;
  end
  //总输入数据计数器================================================
  always@(posedge clk)
  begin
    if(rst||start)//若复位或第二次启动，这个计数器要归位
    begin
      Input_Total_Cnt<=0;
    end
    else if(mReady&&mValid)
    begin
      Input_Total_Cnt<=Input_Total_Cnt+1'b1;
    end
    else
      Input_Total_Cnt<=Input_Total_Cnt;
  end
  //mValid和sReady模拟============================================
  always@(posedge clk)
  begin
    if(rst)
    begin
      mValid<=0;
      sReady<=0;
    end
    else if(Total_Cnt<32&&Input_Total_Cnt<Total_Input_Times)
    begin
      mValid<=1'b1;
      sReady<=1;
    end
    else
    begin
      mValid<=0;
      sReady<=1;
    end
  end
  always@(posedge clk)
  begin
    if(rst)
    begin
      start<=0;
    end
    else if(sLast&&Start_Again_En)//sLast即最后一个输出，结束后再次启动
      start<=1;
    else start<=0;
  end
//================================================================================
  always@(posedge clk)
begin
  if(rst)
  begin
    mem_addr2<=0;
  end
  else if(start)
  begin//
    mem_addr2<=0;
  end
  else if(mValid2&&mReady2)
    mem_addr2<=mem_addr2+1'b1;
  else
    mem_addr2<=mem_addr2;
end


always@(posedge clk)
begin
  if(rst||start)//若复位或第二次启动，这个计数器要归位
  begin
    Input_Total_Cnt2<=0;
  end
  else if(mReady2&&mValid2)
  begin
    Input_Total_Cnt2<=Input_Total_Cnt2+1'b1;
  end
  else
    Input_Total_Cnt2<=Input_Total_Cnt2;
end
always@(posedge clk)
  begin
    if(rst)
    begin
      mValid2<=0;
    end
    else if(Total_Cnt<64&&Input_Total_Cnt2<Total_Input_Times)
    begin
      mValid2<=1'b1;
    end
    else
    begin
      mValid2<=1;
    end
  end
wire [18:0]mem_19bit;
assign mem_19bit=mem[mem_addr];
LayerNorm_Top Layernorm(
.sData_0(mem[mem_addr][18:0]),//  input      [18:0]   
.sValid(mValid),//  input               
.sReady(mReady),//  output              
.start(start),//  input               
.Channel_Nums('d768),//  input      [9:0]    
.Token_Nums('d197),//  input      [19:0]   
.ScaleBias_sValid(mValid2),//  input               
.ScaleBias_sReady(mReady2),//  output reg          
.Scale(mem2[mem_addr2][15:8]),//  input      [7:0]    
.Bias(mem2[mem_addr2][7:0]),//  input      [7:0]    
.mData_valid(sValid),//  output              
.mData_ready(sReady),//  input               
.mData_payload(),//  output     [7:0]    
.mLast(sLast),//  output              
.clk(clk),//  input               
.reset(rst)//  input               

);



endmodule
