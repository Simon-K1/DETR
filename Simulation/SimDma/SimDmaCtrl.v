`timescale 1ns / 1ps

module SimDmaCtrl;
  reg clk;
reg rst;
reg start;

//读地址通道
 reg [9:0]S_AXI_LITE_araddr;//读地址
  wire S_AXI_LITE_arready;//读地址ready
  reg S_AXI_LITE_arvalid;
  
  //写地址通道
  reg [9:0]S_AXI_LITE_awaddr;
  wire S_AXI_LITE_awready;
  reg S_AXI_LITE_awvalid;
  
  reg S_AXI_LITE_bready;
  wire [1:0]S_AXI_LITE_bresp;
  wire S_AXI_LITE_bvalid;//axi_bvalid用于告知axi master axi-slave端已经完成数据接收了
  
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
     start=0;//start 拉高2个周期
     
     
     //读取DMA状态
     S_AXI_LITE_arvalid=1;//读地址valid
     S_AXI_LITE_araddr='d4;//读地址,获取dma状态
     S_AXI_LITE_rready=1;//准备好接收读出来的数据
     wait(S_AXI_LITE_arready);//等待dma接收读地址
     S_AXI_LITE_arvalid=0;//读地址发送完毕
     wait(S_AXI_LITE_rvalid);//准备接受读出来的数据
     #12
     S_AXI_LITE_rready=0;
     
     
  end
  always#5 clk=~clk;//100M时钟
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
