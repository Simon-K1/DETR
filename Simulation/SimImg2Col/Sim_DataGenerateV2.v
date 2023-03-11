`timescale 1ns / 1ps

module Sim_DataGenerate;
parameter Mem_Depth =300*300*4;
parameter Mem_Width=8*8;//txt����λ��
parameter Total_Input_Times=224*224*4;//����2224*224*64bit���ݺ�mValid��Ҫ����
  reg clk;
  reg rst;

  wire mReady;
  reg mValid;

  reg sReady;
  wire sValid;
  wire sLast;//��ȡsLast�źţ��ڶ���������
  wire Start_Again_En;
  assign Start_Again_En=0;//��Ҫ�����ٴ�����
  reg start;
  wire [63:0]sData;

  reg [31:0]Total_Cnt;//����ģ��Mvalid��Sready
  reg [63:0]Out_Total_Cnt;//������ݼ���������������������ݵ�
  reg[63:0]Input_Total_Cnt;//��������������������

  reg [31:0]mem_addr;

  reg	[Mem_Width-1:0]	mem	[0:Mem_Depth-1];
  
  reg [15:0]Scale_Bias_Mem[0:383];
  wire Write_Txt_En;
  wire Write_Txt_End;     
//  ����txt����=====================================================
//E:\\Transformer\\Sim_Transformer\\SimData_Output\\DataGenerate.txt
  integer file_out;
  initial
  begin

      file_out = $fopen("C:\\Users\\25073\\Desktop\\compare\\VivadoOutput.txt","w+");//�ǵ���\\�ֿ�
      if (!file_out) begin
          $display("can't open file");
          $finish;
      end
  end 

  always @ (posedge clk) begin  
        if(Write_Txt_End)begin
           $fclose(file_out);  //�ر�д�ļ�
        end
        else if(sValid&&Write_Txt_En) begin
          $fdisplay(file_out, "%h", sData);//������д��TXT�ļ��У������Զ�����
        end 
  end
//  ==========================================
  initial
  begin
  
//    $readmemh("E:/Transformer/Sim_File/Xq_LayerNorm_δ��������.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K33\\S1_O35\\img2Col��������������.txt",mem);//_Modified
    $readmemh("E:/Transformer/Sim_File/Scale_Bias.txt",Scale_Bias_Mem);//��8bitΪScale����8bitΪBias
    clk=0;
    start=0;
    rst=1;
    mValid<=0;
    mem_addr=0;
    #200000
     rst=0;
     start=1;
    #200
     start=0;
  end
  always#5 clk=~clk;//100Mʱ��


  //ȫ�ּ����������ڿ���Mvalid��Sready
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
  //������ݼ�����===============================================
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
  //�������룬û����ʱ��ֱ�Ӵ�reg�ж�����=========================
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
  //���������ݼ�����================================================
  always@(posedge clk)
  begin
    if(rst||start)//����λ��ڶ������������������Ҫ��λ
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
  //mValid��sReadyģ��============================================
  always@(posedge clk)
  begin
    if(rst)
    begin
      mValid<=0;

    end
    else if(Total_Cnt<64&&Input_Total_Cnt<Total_Input_Times)
    begin
      mValid<=1'b1;

    end
    else
    begin
      mValid<=1;

    end
  end
  
  always@(posedge clk)begin
    if(rst)
      begin
        sReady<=0;
      end
      else if(Total_Cnt<64)
      begin
        sReady<=1;
      end
      else
      begin
        sReady<=0;
      end
    end
  
  
  
  always@(posedge clk)
  begin
    if(rst)
    begin
      start<=0;
    end
    else if(sLast&&Start_Again_En)//sLast�����һ��������������ٴ�����
      start<=1;
    else start<=0;
  end
//ģ����ⲿmemȡscale��bias
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


Img2Col_Top DG(
  .start(start),
.sData_valid(mValid),
.sData_ready(mReady),
.sData_payload(mem[mem_addr]),
//.Stride('d16),
//.Kernel_Size('d16),
//.Window_Size('d64),
//.InFeature_Size('d224),
//.InFeature_Channel('d32),
//.OutFeature_Channel('d32),
//.OutFeature_Channel_Count_Times('d4),
//.OutFeature_Size('d14),
//.OutCol_Count_Times('d2),
//.OutRow_Count_Times('d14),
//.InCol_Count_Times('d896),
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

.clk(clk),
.reset(rst),

.mData(sData),
.mValid(sValid),
.mLast(sLast),
.mReady(sReady),

.Test_Signal(Write_Txt_En),
.Test_End(Write_Txt_End),
.Test_Generate_Period('d14)//Ҫ�Աȵڼ��о����뼸������2���ǵڶ��У���ʼ����Ϊ1
);

endmodule
