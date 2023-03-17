`timescale 1ns / 1ps

module SimSystolicArray;
parameter Mem_Depth =300*300*4;
parameter Mem_Width=8*8;//txt数据位宽
parameter Total_Input_Times=300*300*4;//发完2224*224*64bit数据后mValid需要拉低

parameter Mem2_Depth=300*300*4;//第二个Mem的配置
parameter Mem2_Width=64;

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
  assign Start_Again_En=1;//需要仿真再次启动
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
  
//    $readmemh("E:/Transformer/Sim_File/Xq_LayerNorm_未处理掩码.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K33\\S1_O35\\img2Col随机输入测试数据.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K33\\S1_O35\\WeightData.txt",mem2);//高8bit为Scale，低8bit为Bias
    clk=0;
    start=0;
    rst=1;
    mValid=0;
    mem_addr=0;
    mem_addr2=0;
    #200000
     rst=0;
     start=1;
     start2=1;
    #200
     start=0;
     start2=0;
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
    else if(mem_addr==Mem_Depth-1&&mValid&&mReady)
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
    else if(Total_Cnt<64&&Input_Total_Cnt<Total_Input_Times)
    begin
      mValid<=1'b1;
      sReady<=1;
    end
    else
    begin
      mValid<=1;
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
  else if(mem_addr2==Mem2_Depth-1&&mValid2&&mReady2)
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

wire WeightCached;
wire Raddr_Valid;
wire DataInValid;
wire [63:0]activate;
wire [63:0]Weight;
wire LayerEnd;
wire [7:0]a_Valid;
wire [7:0]b_Valid;
Img2ColStreamV2 Img2ComStream(
    .mReady(sReady),
//    .mValid(sValid),
    .s_axis_s2mm_tdata(mem[mem_addr]),

    .s_axis_s2mm_tready(mReady),
    .s_axis_s2mm_tvalid(mValid),
    .start(WeightCached),//权重缓存完了才能启动图片缓存（实际上板可能不是这样的)
    .clk(clk),
    .Raddr_Valid(Raddr_Valid),
    .mValid(a_Valid),
    .LayerEnd(LayerEnd),
    .mData(activate),
    
    .Stride                        (1),
    .Kernel_Size                   (3),
    .Window_Size                   (18),
    .InFeature_Size                (225),
    .InFeature_Channel             (48),
    .OutFeature_Channel            (35),
    .OutFeature_Size               (223),
    .OutCol_Count_Times            (28),
    .InCol_Count_Times             (1350),
    .OutRow_Count_Times            (223),
    .OutFeature_Channel_Count_Times(5),
    .Sliding_Size                  (6),

    .reset(rst)
    
    
    
    
            
);
Weight_Cache Weight_Cache(
  .start(start),
  .sData_valid(mValid2),
  .sData_ready(mReady2),
  .sData_payload(mem2[mem_addr2]),
.Matrix_Row                    (432),
  .Matrix_Col                    (35),
  .Raddr_Valid(Raddr_Valid),
//  .OutMatrix_Row('d49729),
  .Weight_Cached(WeightCached),
  .LayerEnd(LayerEnd),
  .mData(Weight),
  .MatrixCol_Switch(b_Valid),
//    .mData_0(Weight[7:0]),
//    .mData_1(Weight[15:8]),
//    .mData_2(Weight[23:16]),                     
//    .mData_3(Weight[31:24]),                     
//    .mData_4(Weight[39:32]),                     
//    .mData_5(Weight[47:40]),                     
//    .mData_6(Weight[55:48]),                     
//    .mData_7(Weight[63:56])
    .clk(clk),
  .reset(rst)

);  

Tile SystolicArray(
.activate(activate),
.weight(Weight),
.signCount('d431),
.a_Valid_0(a_Valid[0]),
.a_Valid_1(a_Valid[1]),
.a_Valid_2(a_Valid[2]),
.a_Valid_3(a_Valid[3]),
.a_Valid_4(a_Valid[4]),
.a_Valid_5(a_Valid[5]),
.a_Valid_6(a_Valid[6]),
.a_Valid_7(a_Valid[7]),
.b_Valid_0(b_Valid[0]),
.b_Valid_1(b_Valid[1]),
.b_Valid_2(b_Valid[2]),
.b_Valid_3(b_Valid[3]),
.b_Valid_4(b_Valid[4]),
.b_Valid_5(b_Valid[5]),
.b_Valid_6(b_Valid[6]),
.b_Valid_7(b_Valid[7]),




.clk(clk),
.reset(rst)
);


// ConvOutput ConvOutput(
//   .sData(mem[mem_addr]),
//   .sReady(mReady),
//   .sValid(mValid),
  
// .In_Channel                    (32),
//   .Matrix_Col                    (14),
//   .Matrix_Row                    (14),
  
//   .mData_valid(),
//   .mData_ready(1),
//   .mData_payload(),
//   .start(start),
//   .clk(clk),
//   .reset(rst)
// );
endmodule
