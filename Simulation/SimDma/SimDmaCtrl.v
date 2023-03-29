`timescale 1ns / 1ps

module SimDmaCtrl;
  reg clk;
reg rst;
reg start;

//����ַͨ��
 reg [9:0]S_AXI_LITE_araddr;//����ַ
  wire S_AXI_LITE_arready;//����ַready
  reg S_AXI_LITE_arvalid;
  
  //д��ַͨ��
  reg [9:0]S_AXI_LITE_awaddr;
  wire S_AXI_LITE_awready;
  reg S_AXI_LITE_awvalid;
  
  reg S_AXI_LITE_bready;
  wire [1:0]S_AXI_LITE_bresp;
  wire S_AXI_LITE_bvalid;//axi_bvalid���ڸ�֪axi master axi-slave���Ѿ�������ݽ�����
  
  wire [31:0]S_AXI_LITE_rdata;
  reg S_AXI_LITE_rready;
  wire [1:0]S_AXI_LITE_rresp;
  wire S_AXI_LITE_rvalid;
  wire [31:0]S_AXI_LITE_wdata;
  wire S_AXI_LITE_wready;
  reg S_AXI_LITE_wvalid;
  
  initial
  begin
    clk=0;
    rst=1;
    start=0;
    #20000
     rst=0;
     start=1;
     #20
     start=0;//start ����2������
     
     
     //��ȡDMA״̬
     S_AXI_LITE_arvalid=1;//����ַvalid
     S_AXI_LITE_araddr='d4;//����ַ,��ȡdma״̬
     S_AXI_LITE_rready=1;//׼���ý��ն�����������
     wait(S_AXI_LITE_arready);//�ȴ�dma���ն���ַ
     S_AXI_LITE_arvalid=0;//����ַ�������
     wait(S_AXI_LITE_rvalid);//׼�����ܶ�����������
     #12
     S_AXI_LITE_rready=0;
     
     
  end
  always#5 clk=~clk;//100Mʱ��
always@(posedge clk)begin
    if(rst)begin
        S_AXI_LITE_araddr=0;
        S_AXI_LITE_awvalid   = 0;
        S_AXI_LITE_wvalid     = 0;
        S_AXI_LITE_arvalid    = 0;
        S_AXI_LITE_rready     = 1;
        S_AXI_LITE_bready     =1;
    end

end


  Dma_Ctrl SimDma_i
       (.start(start),
        .clk(clk),
        .rst(rst));

endmodule
