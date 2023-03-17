`timescale 1ns / 1ps

module SimConvOutput;
parameter Mem_Depth =300*300*4;
parameter Mem_Width=8*8;//txt����λ��
parameter Total_Input_Times=896;//����2224*224*64bit���ݺ�mValid��Ҫ����

parameter Mem2_Depth=300*300*4;//�ڶ���Mem������
parameter Mem2_Width=64;

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
  assign Start_Again_En=1;//��Ҫ�����ٴ�����
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
  
//    $readmemh("E:/Transformer/Sim_File/Xq_LayerNorm_δ��������.txt",mem);//_Modified
    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K1616\\S16\\���������������.txt",mem);//_Modified
//    $readmemh("E:\\Transformer\\Matlab\\Img2Col\\Img2Col_A\\main\\K33\\S1_O35\\WeightData.txt",mem2);//��8bitΪScale����8bitΪBias
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
  always@(*)
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

wire WeightCached;
wire Raddr_Valid;
wire DataInValid;
wire [63:0]activate;
wire [63:0]Weight;
wire LayerEnd;
wire [7:0]a_Valid;
wire [7:0]b_Valid;

ConvOutput ConvOutput(
  .sData(mem[mem_addr]),
  .sReady(mReady),
  .sValid(mValid),
  
.In_Channel                    (32),
  .Matrix_Col                    (14),
  .Matrix_Row                    (14),
  
  .mData_valid(),
  .mData_ready(1),
  .mData_payload(),
  .start(start),
  .clk(clk),
  .reset(rst)
);
endmodule
