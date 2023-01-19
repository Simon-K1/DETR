`timescale 1ns / 1ps

module Sim_DataGenerate;
parameter Mem_Depth =224*224;
parameter Mem_Width=8*8;//txt数据位宽
parameter Total_Input_Times=224*224;//发完2224*224*64bit数据后mValid需要拉低
  reg clk;
  reg rst;

  wire mReady;
  reg mValid;

  reg sReady;
  wire sValid;
  reg start;

  reg [31:0]Total_Cnt;//用来模拟Mvalid和Sready
  reg [63:0]Out_Total_Cnt;//输出数据计数器，用来计数输出数据的
  reg[63:0]Input_Total_Cnt;//用来计算输入数据数量

  wire mlast;
  reg [31:0]mem_addr;

  reg	[Mem_Width-1:0]	mem	[0:Mem_Depth-1];
  
  reg [15:0]Scale_Bias_Mem[0:383];
  initial
  begin
//    $readmemh("E:/Transformer/Sim_File/Xq_LayerNorm_未处理掩码.txt",mem);//_Modified
    $readmemh("E:/Transformer/Sim_File/DataGenerate/img2Col顺序输入测试数据.txt",mem);//_Modified
    $readmemh("E:/Transformer/Sim_File/Scale_Bias.txt",Scale_Bias_Mem);//高8bit为Scale，低8bit为Bias
    clk=0;
    start=0;
    rst=1;
    mValid<=0;
    mem_addr=0;
    #200000
     rst=0;
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
    else if(mlast)
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
    if(rst)
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
      mValid<=0;
      sReady<=0;
    end
  end
  always@(posedge clk)
  begin
    if(rst)
    begin
      start<=0;
    end
    else
      start<=1;
  end
//模拟从外部mem取scale和bias
reg [7:0]Scale_In;
reg [7:0]Bias_In;
wire[8:0]Scale_Read_Addr;
wire[8:0]Bias_Read_Addr;
always@(posedge clk)begin
    if(rst)begin
        Scale_In<=0;
        Bias_In<=0;
    end
    else begin
        Scale_In<=Scale_Bias_Mem[Scale_Read_Addr][15:8];
        Bias_In<=Scale_Bias_Mem[Bias_Read_Addr][7:0];
    end
end


Data_Generate DG(
  .start(start),
.sData_valid(mValid),
.sData_ready(mReady),
.sData_payload(mem[mem_addr]),
.Stride('d16),
.Kernel_Size('d16),
.Window_Size('d16),
.InFeature_Size('d224),
.InFeature_Channel('d3),
.OutFeature_Channel('d768),
.OutFeature_Channel_Count_Times('d96),
.OutFeature_Size('d14),
.OutCol_Count_Times('d2),
.OutRow_Count_Times('d14),
.InCol_Count_Times('d224),
.clk(clk),
.reset(rst)         
);
endmodule


