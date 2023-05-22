`timescale 1ns / 1ps

module Sim_LayernormV2;
parameter Mem_Depth =197*768;
parameter Mem_Width=20;//txt����λ��
parameter Total_Input_Times=197*768;//����2224*224*64bit���ݺ�mValid��Ҫ����

parameter Mem2_Depth=768;//�ڶ���Mem������
parameter Mem2_Width=16;

  reg clk;
  reg rst;

  wire mReady;
  reg mValid;
  wire mReady2;
  reg mValid2;

  reg sReady;
  wire sValid;
  wire sLast;//��ȡsLast�źţ��ڶ���������
  wire Start_Again_En;
  assign Start_Again_En=0;//��Ҫ�����ٴ�����
  reg start;
  reg start2;
  wire [63:0]sData;

  reg [31:0]Total_Cnt;//����ģ��Mvalid��Sready
  reg [63:0]Out_Total_Cnt;//������ݼ���������������������ݵ�
  reg[63:0]Input_Total_Cnt;//��������������������
  reg [63:0]Input_Total_Cnt2;
  reg [31:0]mem_addr;
  reg [31:0]mem_addr2;  
  
  reg	[Mem_Width-1:0]	mem	[0:Mem_Depth-1];
  
  reg [Mem2_Width-1:0]mem2[0:Mem2_Depth-1];
  wire Write_Txt_En;
  wire Write_Txt_End;    
  reg [1:0]InSwitch; 
//  ����txt����=====================================================
//E:\\Transformer\\Sim_Transformer\\SimData_Output\\DataGenerate.txt
//  integer file_out;
//  initial
//  begin

//      file_out = $fopen("C:\\Users\\25073\\Desktop\\compare\\VivadoOutput.txt","w+");//�ǵ���\\�ֿ�
//      if (!file_out) begin
//          $display("can't open file");
//          $finish;
//      end
//  end 

//  always @ (posedge clk) begin  
//        if(Write_Txt_End)begin
//           $fclose(file_out);  //�ر�д�ļ�
//        end
//        else if(sValid&&Write_Txt_En) begin
//          $fdisplay(file_out, "%h", sData);//������д��TXT�ļ��У������Զ�����
//        end 
//  end
//  ==========================================
  initial
  begin

//    $readmemh("E:\\Transformer\\Transformer_Arithmatic\\Transformer_Main\\TXT\\WeightPicture.txt",mem);//_Modified
//    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\MM_Test\\WeightMatrix.txt",mem);
    $readmemh("E:\\Transformer\\Matlab\\LayerNorm_Txt_Gen\\Generated_Files\\522\\Xq_LayerNorm������19bit.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\LayerNorm_Txt_Gen\\Generated_Files\\522\\Scale_Bias.txt",mem2);//��8bitΪScale����8bitΪBias
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
    else if(start)
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
    else if(sLast&&Start_Again_En)//sLast�����һ��������������ٴ�����
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
  if(rst||start)//����λ��ڶ������������������Ҫ��λ
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
