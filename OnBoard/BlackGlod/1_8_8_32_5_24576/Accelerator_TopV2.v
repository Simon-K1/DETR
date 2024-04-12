// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Accelerator_TopV2
// Git hash  : 854a5e5d9d98de974dbc4ad9735094507c82ec17

`timescale 1ns/1ps

module Accelerator_TopV2 (
  input               regSData_awvalid,
  output              regSData_awready,
  input      [19:0]   regSData_awaddr,
  input      [2:0]    regSData_awprot,
  input               regSData_wvalid,
  output              regSData_wready,
  input      [31:0]   regSData_wdata,
  input      [3:0]    regSData_wstrb,
  output              regSData_bvalid,
  input               regSData_bready,
  output     [1:0]    regSData_bresp,
  input               regSData_arvalid,
  output              regSData_arready,
  input      [19:0]   regSData_araddr,
  input      [2:0]    regSData_arprot,
  output              regSData_rvalid,
  input               regSData_rready,
  output     [31:0]   regSData_rdata,
  output     [1:0]    regSData_rresp,
  input               clk,
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  output     [63:0]   m_axis_mm2s_tdata,
  output     [7:0]    m_axis_mm2s_tkeep,
  output              m_axis_mm2s_tlast,
  input               m_axis_mm2s_tready,
  output              m_axis_mm2s_tvalid,
  input               Dma_TX_Int,
  input               reset
);

  wire       [1:0]    core_Control_QuantSwitch;
  wire       [1:0]    core_Control_OutputSwitch;
  wire       [0:0]    xil_ila_probe0;
  wire       [0:0]    xil_ila_probe1;
  wire       [4:0]    xil_ila_probe5;
  wire       [4:0]    xil_ila_probe6;
  wire       [15:0]   xil_ila_probe7;
  wire       [15:0]   xil_ila_probe8;
  wire       [15:0]   xil_ila_probe9;
  wire       [15:0]   xil_ila_probe10;
  wire       [15:0]   xil_ila_probe11;
  wire       [12:0]   xil_ila_probe12;
  wire       [15:0]   xil_ila_probe13;
  wire       [15:0]   xil_ila_probe14;
  wire       [15:0]   xil_ila_probe15;
  wire       [15:0]   xil_ila_probe16;
  wire       [15:0]   xil_ila_probe17;
  wire       [11:0]   xil_ila_probe18;
  wire       [19:0]   xil_ila_probe19;
  wire       [7:0]    xil_ila_probe20;
  wire                Regs_regSData_awready;
  wire                Regs_regSData_wready;
  wire                Regs_regSData_bvalid;
  wire       [1:0]    Regs_regSData_bresp;
  wire                Regs_regSData_arready;
  wire                Regs_regSData_rvalid;
  wire       [31:0]   Regs_regSData_rdata;
  wire       [1:0]    Regs_regSData_rresp;
  wire       [3:0]    Regs_LD0123;
  wire       [3:0]    Regs_LD4567;
  wire                Regs_Start;
  wire                Regs_SwitchConv;
  wire                Regs_Matrix2Img;
  wire       [4:0]    Regs_SwitchCtrl;
  wire       [3:0]    Regs_QuantSwitch;
  wire       [3:0]    Regs_OutSwitchCtrl;
  wire       [4:0]    Regs_Stride;
  wire       [4:0]    Regs_Kernel_Size;
  wire                Regs_enPadding;
  wire       [7:0]    Regs_zeroDara;
  wire       [1:0]    Regs_zeroNum;
  wire       [15:0]   Regs_Window_Size;
  wire       [15:0]   Regs_InFeature_Size;
  wire       [15:0]   Regs_InFeature_Channel;
  wire       [15:0]   Regs_OutFeature_Channel;
  wire       [15:0]   Regs_OutFeature_Size;
  wire       [12:0]   Regs_Sliding_Size;
  wire       [15:0]   Regs_OutCol_Count_Times;
  wire       [15:0]   Regs_InCol_Count_Times;
  wire       [15:0]   Regs_OutRow_Count_Times;
  wire       [15:0]   Regs_OutFeature_Channel_Count_Times;
  wire       [15:0]   Regs_WeightMatrix_Row;
  wire       [11:0]   Regs_OutMatrix_Col;
  wire       [19:0]   Regs_OutMatrix_Row;
  wire       [15:0]   Regs_Gemm_Width;
  wire       [15:0]   Regs_Gemm_Height;
  wire       [7:0]    Regs_Quant_ZeroPoint;
  wire                core_s_axis_s2mm_tready;
  wire       [63:0]   core_m_axis_mm2s_tdata;
  wire       [7:0]    core_m_axis_mm2s_tkeep;
  wire                core_m_axis_mm2s_tlast;
  wire                core_m_axis_mm2s_tvalid;

  RegTable Regs (
    .regSData_awvalid               (regSData_awvalid                         ), //i
    .regSData_awready               (Regs_regSData_awready                    ), //o
    .regSData_awaddr                (regSData_awaddr[19:0]                    ), //i
    .regSData_awprot                (regSData_awprot[2:0]                     ), //i
    .regSData_wvalid                (regSData_wvalid                          ), //i
    .regSData_wready                (Regs_regSData_wready                     ), //o
    .regSData_wdata                 (regSData_wdata[31:0]                     ), //i
    .regSData_wstrb                 (regSData_wstrb[3:0]                      ), //i
    .regSData_bvalid                (Regs_regSData_bvalid                     ), //o
    .regSData_bready                (regSData_bready                          ), //i
    .regSData_bresp                 (Regs_regSData_bresp[1:0]                 ), //o
    .regSData_arvalid               (regSData_arvalid                         ), //i
    .regSData_arready               (Regs_regSData_arready                    ), //o
    .regSData_araddr                (regSData_araddr[19:0]                    ), //i
    .regSData_arprot                (regSData_arprot[2:0]                     ), //i
    .regSData_rvalid                (Regs_regSData_rvalid                     ), //o
    .regSData_rready                (regSData_rready                          ), //i
    .regSData_rdata                 (Regs_regSData_rdata[31:0]                ), //o
    .regSData_rresp                 (Regs_regSData_rresp[1:0]                 ), //o
    .LD0123                         (Regs_LD0123[3:0]                         ), //o
    .LD4567                         (Regs_LD4567[3:0]                         ), //o
    .Start                          (Regs_Start                               ), //o
    .SwitchConv                     (Regs_SwitchConv                          ), //o
    .Matrix2Img                     (Regs_Matrix2Img                          ), //o
    .SwitchCtrl                     (Regs_SwitchCtrl[4:0]                     ), //o
    .QuantSwitch                    (Regs_QuantSwitch[3:0]                    ), //o
    .OutSwitchCtrl                  (Regs_OutSwitchCtrl[3:0]                  ), //o
    .Stride                         (Regs_Stride[4:0]                         ), //o
    .Kernel_Size                    (Regs_Kernel_Size[4:0]                    ), //o
    .enPadding                      (Regs_enPadding                           ), //o
    .zeroDara                       (Regs_zeroDara[7:0]                       ), //o
    .zeroNum                        (Regs_zeroNum[1:0]                        ), //o
    .Window_Size                    (Regs_Window_Size[15:0]                   ), //o
    .InFeature_Size                 (Regs_InFeature_Size[15:0]                ), //o
    .InFeature_Channel              (Regs_InFeature_Channel[15:0]             ), //o
    .OutFeature_Channel             (Regs_OutFeature_Channel[15:0]            ), //o
    .OutFeature_Size                (Regs_OutFeature_Size[15:0]               ), //o
    .Sliding_Size                   (Regs_Sliding_Size[12:0]                  ), //o
    .OutCol_Count_Times             (Regs_OutCol_Count_Times[15:0]            ), //o
    .InCol_Count_Times              (Regs_InCol_Count_Times[15:0]             ), //o
    .OutRow_Count_Times             (Regs_OutRow_Count_Times[15:0]            ), //o
    .OutFeature_Channel_Count_Times (Regs_OutFeature_Channel_Count_Times[15:0]), //o
    .WeightMatrix_Row               (Regs_WeightMatrix_Row[15:0]              ), //o
    .OutMatrix_Col                  (Regs_OutMatrix_Col[11:0]                 ), //o
    .OutMatrix_Row                  (Regs_OutMatrix_Row[19:0]                 ), //o
    .Gemm_Width                     (Regs_Gemm_Width[15:0]                    ), //o
    .Gemm_Height                    (Regs_Gemm_Height[15:0]                   ), //o
    .Quant_ZeroPoint                (Regs_Quant_ZeroPoint[7:0]                ), //o
    .clk                            (clk                                      ), //i
    .reset                          (reset                                    )  //i
  );
  SA3D_Top core (
    .Control_start                          (Regs_Start                               ), //i
    .Control_Switch                         (Regs_SwitchCtrl[4:0]                     ), //i
    .Control_QuantSwitch                    (core_Control_QuantSwitch[1:0]            ), //i
    .Control_OutputSwitch                   (core_Control_OutputSwitch[1:0]           ), //i
    .Control_Dma_TX_Int                     (Dma_TX_Int                               ), //i
    .s_axis_s2mm_tdata                      (s_axis_s2mm_tdata[63:0]                  ), //i
    .s_axis_s2mm_tkeep                      (s_axis_s2mm_tkeep[7:0]                   ), //i
    .s_axis_s2mm_tlast                      (s_axis_s2mm_tlast                        ), //i
    .s_axis_s2mm_tready                     (core_s_axis_s2mm_tready                  ), //o
    .s_axis_s2mm_tvalid                     (s_axis_s2mm_tvalid                       ), //i
    .QuantInstru_zeroIn                     (Regs_Quant_ZeroPoint[7:0]                ), //i
    .Img2Col_Stride                         (Regs_Stride[4:0]                         ), //i
    .Img2Col_Kernel_Size                    (Regs_Kernel_Size[4:0]                    ), //i
    .Img2Col_Window_Size                    (Regs_Window_Size[15:0]                   ), //i
    .Img2Col_InFeature_Size                 (Regs_InFeature_Size[15:0]                ), //i
    .Img2Col_InFeature_Channel              (Regs_InFeature_Channel[15:0]             ), //i
    .Img2Col_OutFeature_Channel             (Regs_OutFeature_Channel[15:0]            ), //i
    .Img2Col_OutFeature_Size                (Regs_OutFeature_Size[15:0]               ), //i
    .Img2Col_Sliding_Size                   (Regs_Sliding_Size[12:0]                  ), //i
    .Img2Col_OutCol_Count_Times             (Regs_OutCol_Count_Times[15:0]            ), //i
    .Img2Col_InCol_Count_Times              (Regs_InCol_Count_Times[15:0]             ), //i
    .Img2Col_OutRow_Count_Times             (Regs_OutRow_Count_Times[15:0]            ), //i
    .Img2Col_OutFeature_Channel_Count_Times (Regs_OutFeature_Channel_Count_Times[15:0]), //i
    .Img2Col_enPadding                      (Regs_enPadding                           ), //i
    .Img2Col_zeroDara                       (Regs_zeroDara[7:0]                       ), //i
    .Img2Col_zeroNum                        (Regs_zeroNum[1:0]                        ), //i
    .Img2Col_WeightMatrix_Row               (Regs_WeightMatrix_Row[15:0]              ), //i
    .Img2Col_OutMatrix_Col                  (Regs_OutMatrix_Col[11:0]                 ), //i
    .Img2Col_OutMatrix_Row                  (Regs_OutMatrix_Row[19:0]                 ), //i
    .Gemm_Instru_Height                     (Regs_Gemm_Height[15:0]                   ), //i
    .Gemm_Instru_Width                      (Regs_Gemm_Width[15:0]                    ), //i
    .clk                                    (clk                                      ), //i
    .m_axis_mm2s_tdata                      (core_m_axis_mm2s_tdata[63:0]             ), //o
    .m_axis_mm2s_tkeep                      (core_m_axis_mm2s_tkeep[7:0]              ), //o
    .m_axis_mm2s_tlast                      (core_m_axis_mm2s_tlast                   ), //o
    .m_axis_mm2s_tready                     (m_axis_mm2s_tready                       ), //i
    .m_axis_mm2s_tvalid                     (core_m_axis_mm2s_tvalid                  ), //o
    .reset                                  (reset                                    )  //i
  );
  ila_Accelerator_Top xil_ila (
    .probe0  (xil_ila_probe0                ), //i
    .probe1  (xil_ila_probe1                ), //i
    .probe2  (Regs_SwitchCtrl[4:0]          ), //i
    .probe3  (core_Control_QuantSwitch[1:0] ), //i
    .probe4  (core_Control_OutputSwitch[1:0]), //i
    .probe5  (xil_ila_probe5[4:0]           ), //i
    .probe6  (xil_ila_probe6[4:0]           ), //i
    .probe7  (xil_ila_probe7[15:0]          ), //i
    .probe8  (xil_ila_probe8[15:0]          ), //i
    .probe9  (xil_ila_probe9[15:0]          ), //i
    .probe10 (xil_ila_probe10[15:0]         ), //i
    .probe11 (xil_ila_probe11[15:0]         ), //i
    .probe12 (xil_ila_probe12[12:0]         ), //i
    .probe13 (xil_ila_probe13[15:0]         ), //i
    .probe14 (xil_ila_probe14[15:0]         ), //i
    .probe15 (xil_ila_probe15[15:0]         ), //i
    .probe16 (xil_ila_probe16[15:0]         ), //i
    .probe17 (xil_ila_probe17[15:0]         ), //i
    .probe18 (xil_ila_probe18[11:0]         ), //i
    .probe19 (xil_ila_probe19[19:0]         ), //i
    .probe20 (xil_ila_probe20[7:0]          ), //i
    .clk     (clk                           )  //i
  );
  assign regSData_awready = Regs_regSData_awready;
  assign regSData_wready = Regs_regSData_wready;
  assign regSData_bvalid = Regs_regSData_bvalid;
  assign regSData_bresp = Regs_regSData_bresp;
  assign regSData_arready = Regs_regSData_arready;
  assign regSData_rvalid = Regs_regSData_rvalid;
  assign regSData_rdata = Regs_regSData_rdata;
  assign regSData_rresp = Regs_regSData_rresp;
  assign s_axis_s2mm_tready = core_s_axis_s2mm_tready;
  assign m_axis_mm2s_tdata = core_m_axis_mm2s_tdata;
  assign m_axis_mm2s_tkeep = core_m_axis_mm2s_tkeep;
  assign m_axis_mm2s_tlast = core_m_axis_mm2s_tlast;
  assign m_axis_mm2s_tvalid = core_m_axis_mm2s_tvalid;
  assign core_Control_QuantSwitch = Regs_QuantSwitch[1 : 0];
  assign core_Control_OutputSwitch = Regs_OutSwitchCtrl[1 : 0];
  assign xil_ila_probe0 = Regs_Start;
  assign xil_ila_probe1 = Dma_TX_Int;
  assign xil_ila_probe5 = Regs_Stride;
  assign xil_ila_probe6 = Regs_Kernel_Size;
  assign xil_ila_probe7 = Regs_Window_Size;
  assign xil_ila_probe8 = Regs_InFeature_Size;
  assign xil_ila_probe9 = Regs_InFeature_Channel;
  assign xil_ila_probe10 = Regs_OutFeature_Channel;
  assign xil_ila_probe11 = Regs_OutFeature_Size;
  assign xil_ila_probe12 = Regs_Sliding_Size;
  assign xil_ila_probe13 = Regs_OutCol_Count_Times;
  assign xil_ila_probe14 = Regs_InCol_Count_Times;
  assign xil_ila_probe15 = Regs_OutRow_Count_Times;
  assign xil_ila_probe16 = Regs_OutFeature_Channel_Count_Times;
  assign xil_ila_probe17 = Regs_WeightMatrix_Row;
  assign xil_ila_probe18 = Regs_OutMatrix_Col;
  assign xil_ila_probe19 = Regs_OutMatrix_Row;
  assign xil_ila_probe20 = Regs_Quant_ZeroPoint;

endmodule

module SA3D_Top (
  input               Control_start,
  input      [4:0]    Control_Switch,
  input      [1:0]    Control_QuantSwitch,
  input      [1:0]    Control_OutputSwitch,
  input               Control_Dma_TX_Int,
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  input      [7:0]    QuantInstru_zeroIn,
  input      [4:0]    Img2Col_Stride,
  input      [4:0]    Img2Col_Kernel_Size,
  input      [15:0]   Img2Col_Window_Size,
  input      [15:0]   Img2Col_InFeature_Size,
  input      [15:0]   Img2Col_InFeature_Channel,
  input      [15:0]   Img2Col_OutFeature_Channel,
  input      [15:0]   Img2Col_OutFeature_Size,
  input      [12:0]   Img2Col_Sliding_Size,
  input      [15:0]   Img2Col_OutCol_Count_Times,
  input      [15:0]   Img2Col_InCol_Count_Times,
  input      [15:0]   Img2Col_OutRow_Count_Times,
  input      [15:0]   Img2Col_OutFeature_Channel_Count_Times,
  input               Img2Col_enPadding,
  input      [7:0]    Img2Col_zeroDara,
  input      [1:0]    Img2Col_zeroNum,
  input      [15:0]   Img2Col_WeightMatrix_Row,
  input      [11:0]   Img2Col_OutMatrix_Col,
  input      [19:0]   Img2Col_OutMatrix_Row,
  input      [15:0]   Gemm_Instru_Height,
  input      [15:0]   Gemm_Instru_Width,
  input               clk,
  output     [63:0]   m_axis_mm2s_tdata,
  output     [7:0]    m_axis_mm2s_tkeep,
  output              m_axis_mm2s_tlast,
  input               m_axis_mm2s_tready,
  output              m_axis_mm2s_tvalid,
  input               reset
);

  wire                Quant_Switch_m_1_axis_mm2s_tready;
  wire       [63:0]   OutputSwitch_s_1_axis_s2mm_tdata;
  wire                SubModule_WeightCache_start;
  wire                SubModule_WeightCache_Raddr_Valid;
  wire                SubModule_ConvQuant_start;
  wire       [31:0]   SubModule_ConvQuant_dataIn_0;
  wire       [31:0]   SubModule_ConvQuant_dataIn_1;
  wire       [31:0]   SubModule_ConvQuant_dataIn_2;
  wire       [31:0]   SubModule_ConvQuant_dataIn_3;
  wire       [31:0]   SubModule_ConvQuant_dataIn_4;
  wire       [31:0]   SubModule_ConvQuant_dataIn_5;
  wire       [31:0]   SubModule_ConvQuant_dataIn_6;
  wire       [31:0]   SubModule_ConvQuant_dataIn_7;
  wire                SubModule_Img2Col_start;
  wire       [7:0]    SubModule_LayerNorm_sData_0;
  wire       [7:0]    SubModule_LayerNorm_sData_1;
  wire       [7:0]    SubModule_LayerNorm_sData_2;
  wire       [7:0]    SubModule_LayerNorm_sData_3;
  wire       [7:0]    SubModule_LayerNorm_sData_4;
  wire       [7:0]    SubModule_LayerNorm_sData_5;
  wire       [7:0]    SubModule_LayerNorm_sData_6;
  wire       [7:0]    SubModule_LayerNorm_sData_7;
  wire                SubModule_LayerNorm_start;
  wire       [9:0]    SubModule_LayerNorm_Channel_Nums;
  wire       [19:0]   SubModule_LayerNorm_Token_Nums;
  wire       [7:0]    SubModule_LayerNorm_ZeroPoint;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_0;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_1;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_2;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_3;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_4;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_5;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_6;
  reg        [7:0]    SubModule_SA_3D__zz_io_MatrixA_7;
  wire       [7:0]    SubModule_SA_3D__zz_io_MatrixB_0;
  reg                 SubModule_SA_3D__zz_io_A_Valid_0;
  reg                 SubModule_SA_3D__zz_io_A_Valid_1;
  reg                 SubModule_SA_3D__zz_io_A_Valid_2;
  reg                 SubModule_SA_3D__zz_io_A_Valid_3;
  reg                 SubModule_SA_3D__zz_io_A_Valid_4;
  reg                 SubModule_SA_3D__zz_io_A_Valid_5;
  reg                 SubModule_SA_3D__zz_io_A_Valid_6;
  reg                 SubModule_SA_3D__zz_io_A_Valid_7;
  wire                SubModule_SA_3D__zz_io_B_Valid_0;
  wire       [15:0]   SubModule_SA_3D__zz_io_signCount;
  wire       [31:0]   SubModule_Flatten_sData_payload_0_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_1_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_2_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_3_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_4_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_5_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_6_0;
  wire       [31:0]   SubModule_Flatten_sData_payload_7_0;
  wire       [7:0]    SubModule_DataArrange_sData_0;
  wire       [7:0]    SubModule_DataArrange_sData_1;
  wire       [7:0]    SubModule_DataArrange_sData_2;
  wire       [7:0]    SubModule_DataArrange_sData_3;
  wire       [7:0]    SubModule_DataArrange_sData_4;
  wire       [7:0]    SubModule_DataArrange_sData_5;
  wire       [7:0]    SubModule_DataArrange_sData_6;
  wire       [7:0]    SubModule_DataArrange_sData_7;
  reg        [7:0]    SubModule_DataArrange_sValid;
  wire       [9:0]    SubModule_DataArrange_OutChannel;
  wire                SubModule_DataArrange_start;
  wire                SubModule_DataArrange_SwitchConv;
  wire       [12:0]   SubModule_GEMM_WIDTH;
  wire       [12:0]   SubModule_GEMM_HIGHT;
  wire       [11:0]   SubModule_GEMM_WEIGHTCOL;
  wire                SubModule_GEMM_start;
  wire       [31:0]   xil_ila_probe0;
  wire       [31:0]   xil_ila_probe1;
  wire       [31:0]   xil_ila_probe2;
  wire       [31:0]   xil_ila_probe3;
  wire       [31:0]   xil_ila_probe4;
  wire       [31:0]   xil_ila_probe5;
  wire       [31:0]   xil_ila_probe6;
  wire       [31:0]   xil_ila_probe7;
  wire       [7:0]    xil_ila_probe8;
  wire                InputSwitch_s0_axis_s2mm_tready;
  wire       [63:0]   InputSwitch_m_0_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_0_axis_mm2s_tkeep;
  wire                InputSwitch_m_0_axis_mm2s_tlast;
  wire                InputSwitch_m_0_axis_mm2s_tvalid;
  wire       [63:0]   InputSwitch_m_1_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_1_axis_mm2s_tkeep;
  wire                InputSwitch_m_1_axis_mm2s_tlast;
  wire                InputSwitch_m_1_axis_mm2s_tvalid;
  wire       [63:0]   InputSwitch_m_2_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_2_axis_mm2s_tkeep;
  wire                InputSwitch_m_2_axis_mm2s_tlast;
  wire                InputSwitch_m_2_axis_mm2s_tvalid;
  wire       [63:0]   InputSwitch_m_3_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_3_axis_mm2s_tkeep;
  wire                InputSwitch_m_3_axis_mm2s_tlast;
  wire                InputSwitch_m_3_axis_mm2s_tvalid;
  wire       [63:0]   InputSwitch_m_4_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_4_axis_mm2s_tkeep;
  wire                InputSwitch_m_4_axis_mm2s_tlast;
  wire                InputSwitch_m_4_axis_mm2s_tvalid;
  wire                Quant_Switch_s0_axis_s2mm_tready;
  wire       [63:0]   Quant_Switch_m_0_axis_mm2s_tdata;
  wire       [7:0]    Quant_Switch_m_0_axis_mm2s_tkeep;
  wire                Quant_Switch_m_0_axis_mm2s_tlast;
  wire                Quant_Switch_m_0_axis_mm2s_tvalid;
  wire       [63:0]   Quant_Switch_m_1_axis_mm2s_tdata;
  wire       [7:0]    Quant_Switch_m_1_axis_mm2s_tkeep;
  wire                Quant_Switch_m_1_axis_mm2s_tlast;
  wire                Quant_Switch_m_1_axis_mm2s_tvalid;
  wire       [63:0]   OutputSwitch_m0_axis_mm2s_tdata;
  wire       [7:0]    OutputSwitch_m0_axis_mm2s_tkeep;
  wire                OutputSwitch_m0_axis_mm2s_tlast;
  wire                OutputSwitch_m0_axis_mm2s_tvalid;
  wire                OutputSwitch_s_0_axis_s2mm_tready;
  wire                OutputSwitch_s_1_axis_s2mm_tready;
  wire                SubModule_WeightCache_s_axis_s2mm_tready;
  wire       [7:0]    SubModule_WeightCache_mData_0;
  wire       [7:0]    SubModule_WeightCache_mData_1;
  wire       [7:0]    SubModule_WeightCache_mData_2;
  wire       [7:0]    SubModule_WeightCache_mData_3;
  wire       [7:0]    SubModule_WeightCache_mData_4;
  wire       [7:0]    SubModule_WeightCache_mData_5;
  wire       [7:0]    SubModule_WeightCache_mData_6;
  wire       [7:0]    SubModule_WeightCache_mData_7;
  wire                SubModule_WeightCache_Weight_Cached;
  wire       [7:0]    SubModule_WeightCache_MatrixCol_Switch;
  wire                SubModule_ConvQuant_sData_ready;
  wire                SubModule_ConvQuant_QuantPara_Cached;
  wire       [63:0]   SubModule_ConvQuant_dataOut;
  wire                SubModule_ConvQuant_Quant_State;
  wire       [63:0]   SubModule_Img2Col_mData;
  wire       [7:0]    SubModule_Img2Col_mValid;
  wire                SubModule_Img2Col_s_axis_s2mm_tready;
  wire                SubModule_Img2Col_Raddr_Valid;
  wire                SubModule_Img2Col_LayerEnd;
  wire                SubModule_LayerNorm_sReady;
  wire                SubModule_LayerNorm_mData_valid;
  wire       [63:0]   SubModule_LayerNorm_mData_payload;
  wire                SubModule_LayerNorm_mLast;
  wire                SubModule_LayerNorm_QuantPara_Cached;
  wire                SubModule_LayerNorm_ScaleBias_In_ready;
  wire                SubModule_SA_3D_Matrix_C_valid_0;
  wire                SubModule_SA_3D_Matrix_C_valid_1;
  wire                SubModule_SA_3D_Matrix_C_valid_2;
  wire                SubModule_SA_3D_Matrix_C_valid_3;
  wire                SubModule_SA_3D_Matrix_C_valid_4;
  wire                SubModule_SA_3D_Matrix_C_valid_5;
  wire                SubModule_SA_3D_Matrix_C_valid_6;
  wire                SubModule_SA_3D_Matrix_C_valid_7;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_0;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_1;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_2;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_3;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_4;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_5;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_6;
  wire       [31:0]   SubModule_SA_3D_Matrix_C_payload_7;
  wire                SubModule_Flatten_mData_0_valid;
  wire       [31:0]   SubModule_Flatten_mData_0_payload;
  wire                SubModule_Flatten_mData_1_valid;
  wire       [31:0]   SubModule_Flatten_mData_1_payload;
  wire                SubModule_Flatten_mData_2_valid;
  wire       [31:0]   SubModule_Flatten_mData_2_payload;
  wire                SubModule_Flatten_mData_3_valid;
  wire       [31:0]   SubModule_Flatten_mData_3_payload;
  wire                SubModule_Flatten_mData_4_valid;
  wire       [31:0]   SubModule_Flatten_mData_4_payload;
  wire                SubModule_Flatten_mData_5_valid;
  wire       [31:0]   SubModule_Flatten_mData_5_payload;
  wire                SubModule_Flatten_mData_6_valid;
  wire       [31:0]   SubModule_Flatten_mData_6_payload;
  wire                SubModule_Flatten_mData_7_valid;
  wire       [31:0]   SubModule_Flatten_mData_7_payload;
  wire                SubModule_DataArrange_sReady;
  wire                SubModule_DataArrange_mData_valid;
  wire       [63:0]   SubModule_DataArrange_mData_payload;
  wire                SubModule_DataArrange_mLast;
  wire                SubModule_DataArrange_LayerEnd;
  wire                SubModule_GEMM_sData_ready;
  wire                SubModule_GEMM_validOut_0;
  wire                SubModule_GEMM_validOut_1;
  wire                SubModule_GEMM_validOut_2;
  wire                SubModule_GEMM_validOut_3;
  wire                SubModule_GEMM_validOut_4;
  wire                SubModule_GEMM_validOut_5;
  wire                SubModule_GEMM_validOut_6;
  wire                SubModule_GEMM_validOut_7;
  wire                SubModule_GEMM_LayerEnd;
  wire                SubModule_GEMM_bvalid;
  wire       [63:0]   SubModule_GEMM_mData;
  wire       [16:0]   _zz_Token_Nums;
  wire       [16:0]   _zz_Token_Nums_1;
  wire       [16:0]   _zz_Token_Nums_2;
  wire       [0:0]    _zz_Token_Nums_3;
  wire                when_SA_3D_SwitchVersion_l177;
  wire                GemmStart;
  reg                 _zz_start;
  reg        [7:0]    _zz_io_MatrixB_1;
  reg                 _zz_io_B_Valid_1;
  reg        [7:0]    _zz_io_MatrixB_2;
  reg        [7:0]    _zz_io_MatrixB_2_1;
  reg                 _zz_io_B_Valid_2;
  reg                 _zz_io_B_Valid_2_1;
  reg        [7:0]    _zz_io_MatrixB_3;
  reg        [7:0]    _zz_io_MatrixB_3_1;
  reg        [7:0]    _zz_io_MatrixB_3_2;
  reg                 _zz_io_B_Valid_3;
  reg                 _zz_io_B_Valid_3_1;
  reg                 _zz_io_B_Valid_3_2;
  reg        [7:0]    _zz_io_MatrixB_4;
  reg        [7:0]    _zz_io_MatrixB_4_1;
  reg        [7:0]    _zz_io_MatrixB_4_2;
  reg        [7:0]    _zz_io_MatrixB_4_3;
  reg                 _zz_io_B_Valid_4;
  reg                 _zz_io_B_Valid_4_1;
  reg                 _zz_io_B_Valid_4_2;
  reg                 _zz_io_B_Valid_4_3;
  reg        [7:0]    _zz_io_MatrixB_5;
  reg        [7:0]    _zz_io_MatrixB_5_1;
  reg        [7:0]    _zz_io_MatrixB_5_2;
  reg        [7:0]    _zz_io_MatrixB_5_3;
  reg        [7:0]    _zz_io_MatrixB_5_4;
  reg                 _zz_io_B_Valid_5;
  reg                 _zz_io_B_Valid_5_1;
  reg                 _zz_io_B_Valid_5_2;
  reg                 _zz_io_B_Valid_5_3;
  reg                 _zz_io_B_Valid_5_4;
  reg        [7:0]    _zz_io_MatrixB_6;
  reg        [7:0]    _zz_io_MatrixB_6_1;
  reg        [7:0]    _zz_io_MatrixB_6_2;
  reg        [7:0]    _zz_io_MatrixB_6_3;
  reg        [7:0]    _zz_io_MatrixB_6_4;
  reg        [7:0]    _zz_io_MatrixB_6_5;
  reg                 _zz_io_B_Valid_6;
  reg                 _zz_io_B_Valid_6_1;
  reg                 _zz_io_B_Valid_6_2;
  reg                 _zz_io_B_Valid_6_3;
  reg                 _zz_io_B_Valid_6_4;
  reg                 _zz_io_B_Valid_6_5;
  reg        [7:0]    _zz_io_MatrixB_7;
  reg        [7:0]    _zz_io_MatrixB_7_1;
  reg        [7:0]    _zz_io_MatrixB_7_2;
  reg        [7:0]    _zz_io_MatrixB_7_3;
  reg        [7:0]    _zz_io_MatrixB_7_4;
  reg        [7:0]    _zz_io_MatrixB_7_5;
  reg        [7:0]    _zz_io_MatrixB_7_6;
  reg                 _zz_io_B_Valid_7;
  reg                 _zz_io_B_Valid_7_1;
  reg                 _zz_io_B_Valid_7_2;
  reg                 _zz_io_B_Valid_7_3;
  reg                 _zz_io_B_Valid_7_4;
  reg                 _zz_io_B_Valid_7_5;
  reg                 _zz_io_B_Valid_7_6;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_2;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_3;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_4;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_5;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_6;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_7;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_8;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_9;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_10;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_11;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_12;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_13;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_14;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_15;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_0_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_1_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_2_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_3_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_4_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_5_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_6_valid_delay_15;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_1;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_2;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_3;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_4;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_5;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_6;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_7;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_8;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_9;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_10;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_11;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_12;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_13;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_14;
  reg                 core_SubModule_Flatten_mData_7_valid_delay_15;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_1_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_2_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_3_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_4_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_5_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_6_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_7_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_8_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_9_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_10_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_11_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_12_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_13_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_14_1;
  reg                 core_SubModule_SA_3D_Matrix_C_valid_0_delay_15_1;

  assign _zz_Token_Nums = (_zz_Token_Nums_1 + _zz_Token_Nums_2);
  assign _zz_Token_Nums_1 = (Img2Col_OutMatrix_Row >>> 3);
  assign _zz_Token_Nums_3 = Img2Col_OutMatrix_Row[2 : 2];
  assign _zz_Token_Nums_2 = {16'd0, _zz_Token_Nums_3};
  Compute_DataIn_Switch InputSwitch (
    .Switch               (Control_Switch[4:0]                     ), //i
    .s0_axis_s2mm_tdata   (s_axis_s2mm_tdata[63:0]                 ), //i
    .s0_axis_s2mm_tkeep   (s_axis_s2mm_tkeep[7:0]                  ), //i
    .s0_axis_s2mm_tlast   (s_axis_s2mm_tlast                       ), //i
    .s0_axis_s2mm_tready  (InputSwitch_s0_axis_s2mm_tready         ), //o
    .s0_axis_s2mm_tvalid  (s_axis_s2mm_tvalid                      ), //i
    .m_0_axis_mm2s_tdata  (InputSwitch_m_0_axis_mm2s_tdata[63:0]   ), //o
    .m_0_axis_mm2s_tkeep  (InputSwitch_m_0_axis_mm2s_tkeep[7:0]    ), //o
    .m_0_axis_mm2s_tlast  (InputSwitch_m_0_axis_mm2s_tlast         ), //o
    .m_0_axis_mm2s_tready (SubModule_WeightCache_s_axis_s2mm_tready), //i
    .m_0_axis_mm2s_tvalid (InputSwitch_m_0_axis_mm2s_tvalid        ), //o
    .m_1_axis_mm2s_tdata  (InputSwitch_m_1_axis_mm2s_tdata[63:0]   ), //o
    .m_1_axis_mm2s_tkeep  (InputSwitch_m_1_axis_mm2s_tkeep[7:0]    ), //o
    .m_1_axis_mm2s_tlast  (InputSwitch_m_1_axis_mm2s_tlast         ), //o
    .m_1_axis_mm2s_tready (SubModule_ConvQuant_sData_ready         ), //i
    .m_1_axis_mm2s_tvalid (InputSwitch_m_1_axis_mm2s_tvalid        ), //o
    .m_2_axis_mm2s_tdata  (InputSwitch_m_2_axis_mm2s_tdata[63:0]   ), //o
    .m_2_axis_mm2s_tkeep  (InputSwitch_m_2_axis_mm2s_tkeep[7:0]    ), //o
    .m_2_axis_mm2s_tlast  (InputSwitch_m_2_axis_mm2s_tlast         ), //o
    .m_2_axis_mm2s_tready (SubModule_Img2Col_s_axis_s2mm_tready    ), //i
    .m_2_axis_mm2s_tvalid (InputSwitch_m_2_axis_mm2s_tvalid        ), //o
    .m_3_axis_mm2s_tdata  (InputSwitch_m_3_axis_mm2s_tdata[63:0]   ), //o
    .m_3_axis_mm2s_tkeep  (InputSwitch_m_3_axis_mm2s_tkeep[7:0]    ), //o
    .m_3_axis_mm2s_tlast  (InputSwitch_m_3_axis_mm2s_tlast         ), //o
    .m_3_axis_mm2s_tready (SubModule_LayerNorm_ScaleBias_In_ready  ), //i
    .m_3_axis_mm2s_tvalid (InputSwitch_m_3_axis_mm2s_tvalid        ), //o
    .m_4_axis_mm2s_tdata  (InputSwitch_m_4_axis_mm2s_tdata[63:0]   ), //o
    .m_4_axis_mm2s_tkeep  (InputSwitch_m_4_axis_mm2s_tkeep[7:0]    ), //o
    .m_4_axis_mm2s_tlast  (InputSwitch_m_4_axis_mm2s_tlast         ), //o
    .m_4_axis_mm2s_tready (SubModule_GEMM_sData_ready              ), //i
    .m_4_axis_mm2s_tvalid (InputSwitch_m_4_axis_mm2s_tvalid        )  //o
  );
  Axis_Switch_S2M Quant_Switch (
    .Switch               (Control_QuantSwitch[1:0]                      ), //i
    .s0_axis_s2mm_tdata   (SubModule_ConvQuant_dataOut[63:0]             ), //i
    .s0_axis_s2mm_tkeep   (8'hff                                         ), //i
    .s0_axis_s2mm_tlast   (1'b0                                          ), //i
    .s0_axis_s2mm_tready  (Quant_Switch_s0_axis_s2mm_tready              ), //o
    .s0_axis_s2mm_tvalid  (core_SubModule_SA_3D_Matrix_C_valid_0_delay_15), //i
    .m_0_axis_mm2s_tdata  (Quant_Switch_m_0_axis_mm2s_tdata[63:0]        ), //o
    .m_0_axis_mm2s_tkeep  (Quant_Switch_m_0_axis_mm2s_tkeep[7:0]         ), //o
    .m_0_axis_mm2s_tlast  (Quant_Switch_m_0_axis_mm2s_tlast              ), //o
    .m_0_axis_mm2s_tready (SubModule_DataArrange_sReady                  ), //i
    .m_0_axis_mm2s_tvalid (Quant_Switch_m_0_axis_mm2s_tvalid             ), //o
    .m_1_axis_mm2s_tdata  (Quant_Switch_m_1_axis_mm2s_tdata[63:0]        ), //o
    .m_1_axis_mm2s_tkeep  (Quant_Switch_m_1_axis_mm2s_tkeep[7:0]         ), //o
    .m_1_axis_mm2s_tlast  (Quant_Switch_m_1_axis_mm2s_tlast              ), //o
    .m_1_axis_mm2s_tready (Quant_Switch_m_1_axis_mm2s_tready             ), //i
    .m_1_axis_mm2s_tvalid (Quant_Switch_m_1_axis_mm2s_tvalid             )  //o
  );
  Axis_Switch_M2S OutputSwitch (
    .Switch               (Control_OutputSwitch[1:0]                ), //i
    .m0_axis_mm2s_tdata   (OutputSwitch_m0_axis_mm2s_tdata[63:0]    ), //o
    .m0_axis_mm2s_tkeep   (OutputSwitch_m0_axis_mm2s_tkeep[7:0]     ), //o
    .m0_axis_mm2s_tlast   (OutputSwitch_m0_axis_mm2s_tlast          ), //o
    .m0_axis_mm2s_tready  (m_axis_mm2s_tready                       ), //i
    .m0_axis_mm2s_tvalid  (OutputSwitch_m0_axis_mm2s_tvalid         ), //o
    .s_0_axis_s2mm_tdata  (SubModule_DataArrange_mData_payload[63:0]), //i
    .s_0_axis_s2mm_tkeep  (8'hff                                    ), //i
    .s_0_axis_s2mm_tlast  (SubModule_DataArrange_mLast              ), //i
    .s_0_axis_s2mm_tready (OutputSwitch_s_0_axis_s2mm_tready        ), //o
    .s_0_axis_s2mm_tvalid (SubModule_DataArrange_mData_valid        ), //i
    .s_1_axis_s2mm_tdata  (OutputSwitch_s_1_axis_s2mm_tdata[63:0]   ), //i
    .s_1_axis_s2mm_tkeep  (8'hff                                    ), //i
    .s_1_axis_s2mm_tlast  (SubModule_LayerNorm_mLast                ), //i
    .s_1_axis_s2mm_tready (OutputSwitch_s_1_axis_s2mm_tready        ), //o
    .s_1_axis_s2mm_tvalid (SubModule_LayerNorm_mData_valid          )  //i
  );
  WeightCache_Stream SubModule_WeightCache (
    .s_axis_s2mm_tdata  (InputSwitch_m_0_axis_mm2s_tdata[63:0]      ), //i
    .s_axis_s2mm_tkeep  (InputSwitch_m_0_axis_mm2s_tkeep[7:0]       ), //i
    .s_axis_s2mm_tlast  (InputSwitch_m_0_axis_mm2s_tlast            ), //i
    .s_axis_s2mm_tready (SubModule_WeightCache_s_axis_s2mm_tready   ), //o
    .s_axis_s2mm_tvalid (InputSwitch_m_0_axis_mm2s_tvalid           ), //i
    .start              (SubModule_WeightCache_start                ), //i
    .Matrix_Row         (Img2Col_WeightMatrix_Row[15:0]             ), //i
    .Matrix_Col         (Img2Col_OutFeature_Channel[15:0]           ), //i
    .mData_0            (SubModule_WeightCache_mData_0[7:0]         ), //o
    .mData_1            (SubModule_WeightCache_mData_1[7:0]         ), //o
    .mData_2            (SubModule_WeightCache_mData_2[7:0]         ), //o
    .mData_3            (SubModule_WeightCache_mData_3[7:0]         ), //o
    .mData_4            (SubModule_WeightCache_mData_4[7:0]         ), //o
    .mData_5            (SubModule_WeightCache_mData_5[7:0]         ), //o
    .mData_6            (SubModule_WeightCache_mData_6[7:0]         ), //o
    .mData_7            (SubModule_WeightCache_mData_7[7:0]         ), //o
    .Raddr_Valid        (SubModule_WeightCache_Raddr_Valid          ), //i
    .Weight_Cached      (SubModule_WeightCache_Weight_Cached        ), //o
    .LayerEnd           (Control_Dma_TX_Int                         ), //i
    .MatrixCol_Switch   (SubModule_WeightCache_MatrixCol_Switch[7:0]), //o
    .clk                (clk                                        ), //i
    .reset              (reset                                      )  //i
  );
  ConvQuant SubModule_ConvQuant (
    .start            (SubModule_ConvQuant_start            ), //i
    .sData_valid      (InputSwitch_m_1_axis_mm2s_tvalid     ), //i
    .sData_ready      (SubModule_ConvQuant_sData_ready      ), //o
    .sData_payload    (InputSwitch_m_1_axis_mm2s_tdata[63:0]), //i
    .OutMatrix_Col    (Img2Col_OutFeature_Channel[15:0]     ), //i
    .LayerEnd         (Control_Dma_TX_Int                   ), //i
    .QuantPara_Cached (SubModule_ConvQuant_QuantPara_Cached ), //o
    .dataIn_0         (SubModule_ConvQuant_dataIn_0[31:0]   ), //i
    .dataIn_1         (SubModule_ConvQuant_dataIn_1[31:0]   ), //i
    .dataIn_2         (SubModule_ConvQuant_dataIn_2[31:0]   ), //i
    .dataIn_3         (SubModule_ConvQuant_dataIn_3[31:0]   ), //i
    .dataIn_4         (SubModule_ConvQuant_dataIn_4[31:0]   ), //i
    .dataIn_5         (SubModule_ConvQuant_dataIn_5[31:0]   ), //i
    .dataIn_6         (SubModule_ConvQuant_dataIn_6[31:0]   ), //i
    .dataIn_7         (SubModule_ConvQuant_dataIn_7[31:0]   ), //i
    .dataOut          (SubModule_ConvQuant_dataOut[63:0]    ), //o
    .zeroIn           (QuantInstru_zeroIn[7:0]              ), //i
    .SAOutput_Valid   (SubModule_Flatten_mData_0_valid      ), //i
    .Quant_State      (SubModule_ConvQuant_Quant_State      ), //o
    .clk              (clk                                  ), //i
    .reset            (reset                                )  //i
  );
  Img2ColStreamV2 SubModule_Img2Col (
    .mData                          (SubModule_Img2Col_mData[63:0]               ), //o
    .mValid                         (SubModule_Img2Col_mValid[7:0]               ), //o
    .s_axis_s2mm_tdata              (InputSwitch_m_2_axis_mm2s_tdata[63:0]       ), //i
    .s_axis_s2mm_tkeep              (InputSwitch_m_2_axis_mm2s_tkeep[7:0]        ), //i
    .s_axis_s2mm_tlast              (InputSwitch_m_2_axis_mm2s_tlast             ), //i
    .s_axis_s2mm_tready             (SubModule_Img2Col_s_axis_s2mm_tready        ), //o
    .s_axis_s2mm_tvalid             (InputSwitch_m_2_axis_mm2s_tvalid            ), //i
    .start                          (SubModule_Img2Col_start                     ), //i
    .Raddr_Valid                    (SubModule_Img2Col_Raddr_Valid               ), //o
    .LayerEnd                       (SubModule_Img2Col_LayerEnd                  ), //o
    .Stride                         (Img2Col_Stride[4:0]                         ), //i
    .Kernel_Size                    (Img2Col_Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Img2Col_Window_Size[15:0]                   ), //i
    .InFeature_Size                 (Img2Col_InFeature_Size[15:0]                ), //i
    .InFeature_Channel              (Img2Col_InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (Img2Col_OutFeature_Channel[15:0]            ), //i
    .OutFeature_Size                (Img2Col_OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (Img2Col_OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (Img2Col_InCol_Count_Times[15:0]             ), //i
    .OutRow_Count_Times             (Img2Col_OutRow_Count_Times[15:0]            ), //i
    .OutFeature_Channel_Count_Times (Img2Col_OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Img2Col_Sliding_Size[12:0]                  ), //i
    .enPadding                      (Img2Col_enPadding                           ), //i
    .zeroDara                       (Img2Col_zeroDara[7:0]                       ), //i
    .zeroNum                        (Img2Col_zeroNum[1:0]                        ), //i
    .clk                            (clk                                         ), //i
    .reset                          (reset                                       )  //i
  );
  LayerNorm_Top SubModule_LayerNorm (
    .sData_0              (SubModule_LayerNorm_sData_0[7:0]                ), //i
    .sData_1              (SubModule_LayerNorm_sData_1[7:0]                ), //i
    .sData_2              (SubModule_LayerNorm_sData_2[7:0]                ), //i
    .sData_3              (SubModule_LayerNorm_sData_3[7:0]                ), //i
    .sData_4              (SubModule_LayerNorm_sData_4[7:0]                ), //i
    .sData_5              (SubModule_LayerNorm_sData_5[7:0]                ), //i
    .sData_6              (SubModule_LayerNorm_sData_6[7:0]                ), //i
    .sData_7              (SubModule_LayerNorm_sData_7[7:0]                ), //i
    .sValid               (core_SubModule_SA_3D_Matrix_C_valid_0_delay_15_1), //i
    .sReady               (SubModule_LayerNorm_sReady                      ), //o
    .start                (SubModule_LayerNorm_start                       ), //i
    .Channel_Nums         (SubModule_LayerNorm_Channel_Nums[9:0]           ), //i
    .Token_Nums           (SubModule_LayerNorm_Token_Nums[19:0]            ), //i
    .mData_valid          (SubModule_LayerNorm_mData_valid                 ), //o
    .mData_ready          (OutputSwitch_s_1_axis_s2mm_tready               ), //i
    .mData_payload        (SubModule_LayerNorm_mData_payload[63:0]         ), //o
    .mLast                (SubModule_LayerNorm_mLast                       ), //o
    .QuantPara_Cached     (SubModule_LayerNorm_QuantPara_Cached            ), //o
    .ScaleBias_In_valid   (InputSwitch_m_3_axis_mm2s_tvalid                ), //i
    .ScaleBias_In_ready   (SubModule_LayerNorm_ScaleBias_In_ready          ), //o
    .ScaleBias_In_payload (InputSwitch_m_3_axis_mm2s_tdata[63:0]           ), //i
    .ZeroPoint            (SubModule_LayerNorm_ZeroPoint[7:0]              ), //i
    .clk                  (clk                                             ), //i
    .reset                (reset                                           )  //i
  );
  SA_3D SubModule_SA_3D (
    .start              (Control_start                           ), //i
    ._zz_io_MatrixA_0   (SubModule_SA_3D__zz_io_MatrixA_0[7:0]   ), //i
    ._zz_io_MatrixA_1   (SubModule_SA_3D__zz_io_MatrixA_1[7:0]   ), //i
    ._zz_io_MatrixA_2   (SubModule_SA_3D__zz_io_MatrixA_2[7:0]   ), //i
    ._zz_io_MatrixA_3   (SubModule_SA_3D__zz_io_MatrixA_3[7:0]   ), //i
    ._zz_io_MatrixA_4   (SubModule_SA_3D__zz_io_MatrixA_4[7:0]   ), //i
    ._zz_io_MatrixA_5   (SubModule_SA_3D__zz_io_MatrixA_5[7:0]   ), //i
    ._zz_io_MatrixA_6   (SubModule_SA_3D__zz_io_MatrixA_6[7:0]   ), //i
    ._zz_io_MatrixA_7   (SubModule_SA_3D__zz_io_MatrixA_7[7:0]   ), //i
    ._zz_io_MatrixB_0   (SubModule_SA_3D__zz_io_MatrixB_0[7:0]   ), //i
    ._zz_io_MatrixB_1   (_zz_io_MatrixB_1[7:0]                   ), //i
    ._zz_io_MatrixB_2   (_zz_io_MatrixB_2_1[7:0]                 ), //i
    ._zz_io_MatrixB_3   (_zz_io_MatrixB_3_2[7:0]                 ), //i
    ._zz_io_MatrixB_4   (_zz_io_MatrixB_4_3[7:0]                 ), //i
    ._zz_io_MatrixB_5   (_zz_io_MatrixB_5_4[7:0]                 ), //i
    ._zz_io_MatrixB_6   (_zz_io_MatrixB_6_5[7:0]                 ), //i
    ._zz_io_MatrixB_7   (_zz_io_MatrixB_7_6[7:0]                 ), //i
    ._zz_io_A_Valid_0   (SubModule_SA_3D__zz_io_A_Valid_0        ), //i
    ._zz_io_A_Valid_1   (SubModule_SA_3D__zz_io_A_Valid_1        ), //i
    ._zz_io_A_Valid_2   (SubModule_SA_3D__zz_io_A_Valid_2        ), //i
    ._zz_io_A_Valid_3   (SubModule_SA_3D__zz_io_A_Valid_3        ), //i
    ._zz_io_A_Valid_4   (SubModule_SA_3D__zz_io_A_Valid_4        ), //i
    ._zz_io_A_Valid_5   (SubModule_SA_3D__zz_io_A_Valid_5        ), //i
    ._zz_io_A_Valid_6   (SubModule_SA_3D__zz_io_A_Valid_6        ), //i
    ._zz_io_A_Valid_7   (SubModule_SA_3D__zz_io_A_Valid_7        ), //i
    ._zz_io_B_Valid_0   (SubModule_SA_3D__zz_io_B_Valid_0        ), //i
    ._zz_io_B_Valid_1   (_zz_io_B_Valid_1                        ), //i
    ._zz_io_B_Valid_2   (_zz_io_B_Valid_2_1                      ), //i
    ._zz_io_B_Valid_3   (_zz_io_B_Valid_3_2                      ), //i
    ._zz_io_B_Valid_4   (_zz_io_B_Valid_4_3                      ), //i
    ._zz_io_B_Valid_5   (_zz_io_B_Valid_5_4                      ), //i
    ._zz_io_B_Valid_6   (_zz_io_B_Valid_6_5                      ), //i
    ._zz_io_B_Valid_7   (_zz_io_B_Valid_7_6                      ), //i
    ._zz_io_signCount   (SubModule_SA_3D__zz_io_signCount[15:0]  ), //i
    .clk                (clk                                     ), //i
    .Matrix_C_valid_0   (SubModule_SA_3D_Matrix_C_valid_0        ), //o
    .Matrix_C_valid_1   (SubModule_SA_3D_Matrix_C_valid_1        ), //o
    .Matrix_C_valid_2   (SubModule_SA_3D_Matrix_C_valid_2        ), //o
    .Matrix_C_valid_3   (SubModule_SA_3D_Matrix_C_valid_3        ), //o
    .Matrix_C_valid_4   (SubModule_SA_3D_Matrix_C_valid_4        ), //o
    .Matrix_C_valid_5   (SubModule_SA_3D_Matrix_C_valid_5        ), //o
    .Matrix_C_valid_6   (SubModule_SA_3D_Matrix_C_valid_6        ), //o
    .Matrix_C_valid_7   (SubModule_SA_3D_Matrix_C_valid_7        ), //o
    .Matrix_C_payload_0 (SubModule_SA_3D_Matrix_C_payload_0[31:0]), //o
    .Matrix_C_payload_1 (SubModule_SA_3D_Matrix_C_payload_1[31:0]), //o
    .Matrix_C_payload_2 (SubModule_SA_3D_Matrix_C_payload_2[31:0]), //o
    .Matrix_C_payload_3 (SubModule_SA_3D_Matrix_C_payload_3[31:0]), //o
    .Matrix_C_payload_4 (SubModule_SA_3D_Matrix_C_payload_4[31:0]), //o
    .Matrix_C_payload_5 (SubModule_SA_3D_Matrix_C_payload_5[31:0]), //o
    .Matrix_C_payload_6 (SubModule_SA_3D_Matrix_C_payload_6[31:0]), //o
    .Matrix_C_payload_7 (SubModule_SA_3D_Matrix_C_payload_7[31:0]), //o
    .reset              (reset                                   )  //i
  );
  Flatten SubModule_Flatten (
    .sData_valid_0     (SubModule_SA_3D_Matrix_C_valid_0         ), //i
    .sData_valid_1     (SubModule_SA_3D_Matrix_C_valid_1         ), //i
    .sData_valid_2     (SubModule_SA_3D_Matrix_C_valid_2         ), //i
    .sData_valid_3     (SubModule_SA_3D_Matrix_C_valid_3         ), //i
    .sData_valid_4     (SubModule_SA_3D_Matrix_C_valid_4         ), //i
    .sData_valid_5     (SubModule_SA_3D_Matrix_C_valid_5         ), //i
    .sData_valid_6     (SubModule_SA_3D_Matrix_C_valid_6         ), //i
    .sData_valid_7     (SubModule_SA_3D_Matrix_C_valid_7         ), //i
    .sData_payload_0_0 (SubModule_Flatten_sData_payload_0_0[31:0]), //i
    .sData_payload_1_0 (SubModule_Flatten_sData_payload_1_0[31:0]), //i
    .sData_payload_2_0 (SubModule_Flatten_sData_payload_2_0[31:0]), //i
    .sData_payload_3_0 (SubModule_Flatten_sData_payload_3_0[31:0]), //i
    .sData_payload_4_0 (SubModule_Flatten_sData_payload_4_0[31:0]), //i
    .sData_payload_5_0 (SubModule_Flatten_sData_payload_5_0[31:0]), //i
    .sData_payload_6_0 (SubModule_Flatten_sData_payload_6_0[31:0]), //i
    .sData_payload_7_0 (SubModule_Flatten_sData_payload_7_0[31:0]), //i
    .mData_0_valid     (SubModule_Flatten_mData_0_valid          ), //o
    .mData_0_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_0_payload   (SubModule_Flatten_mData_0_payload[31:0]  ), //o
    .mData_1_valid     (SubModule_Flatten_mData_1_valid          ), //o
    .mData_1_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_1_payload   (SubModule_Flatten_mData_1_payload[31:0]  ), //o
    .mData_2_valid     (SubModule_Flatten_mData_2_valid          ), //o
    .mData_2_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_2_payload   (SubModule_Flatten_mData_2_payload[31:0]  ), //o
    .mData_3_valid     (SubModule_Flatten_mData_3_valid          ), //o
    .mData_3_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_3_payload   (SubModule_Flatten_mData_3_payload[31:0]  ), //o
    .mData_4_valid     (SubModule_Flatten_mData_4_valid          ), //o
    .mData_4_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_4_payload   (SubModule_Flatten_mData_4_payload[31:0]  ), //o
    .mData_5_valid     (SubModule_Flatten_mData_5_valid          ), //o
    .mData_5_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_5_payload   (SubModule_Flatten_mData_5_payload[31:0]  ), //o
    .mData_6_valid     (SubModule_Flatten_mData_6_valid          ), //o
    .mData_6_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_6_payload   (SubModule_Flatten_mData_6_payload[31:0]  ), //o
    .mData_7_valid     (SubModule_Flatten_mData_7_valid          ), //o
    .mData_7_ready     (SubModule_ConvQuant_Quant_State          ), //i
    .mData_7_payload   (SubModule_Flatten_mData_7_payload[31:0]  ), //o
    .clk               (clk                                      )  //i
  );
  ConvArrangeV3 SubModule_DataArrange (
    .sData_0        (SubModule_DataArrange_sData_0[7:0]       ), //i
    .sData_1        (SubModule_DataArrange_sData_1[7:0]       ), //i
    .sData_2        (SubModule_DataArrange_sData_2[7:0]       ), //i
    .sData_3        (SubModule_DataArrange_sData_3[7:0]       ), //i
    .sData_4        (SubModule_DataArrange_sData_4[7:0]       ), //i
    .sData_5        (SubModule_DataArrange_sData_5[7:0]       ), //i
    .sData_6        (SubModule_DataArrange_sData_6[7:0]       ), //i
    .sData_7        (SubModule_DataArrange_sData_7[7:0]       ), //i
    .sReady         (SubModule_DataArrange_sReady             ), //o
    .sValid         (SubModule_DataArrange_sValid[7:0]        ), //i
    .MatrixCol      (Img2Col_OutMatrix_Col[11:0]              ), //i
    .MatrixRow      (Img2Col_OutMatrix_Row[19:0]              ), //i
    .OutChannel     (SubModule_DataArrange_OutChannel[9:0]    ), //i
    .OutFeatureSize (Img2Col_OutFeature_Size[15:0]            ), //i
    .mData_valid    (SubModule_DataArrange_mData_valid        ), //o
    .mData_ready    (OutputSwitch_s_0_axis_s2mm_tready        ), //i
    .mData_payload  (SubModule_DataArrange_mData_payload[63:0]), //o
    .mLast          (SubModule_DataArrange_mLast              ), //o
    .LayerEnd       (SubModule_DataArrange_LayerEnd           ), //o
    .start          (SubModule_DataArrange_start              ), //i
    .SwitchConv     (SubModule_DataArrange_SwitchConv         ), //i
    .clk            (clk                                      ), //i
    .reset          (reset                                    )  //i
  );
  GemmCache SubModule_GEMM (
    .sData_valid   (InputSwitch_m_4_axis_mm2s_tvalid     ), //i
    .sData_ready   (SubModule_GEMM_sData_ready           ), //o
    .sData_payload (InputSwitch_m_4_axis_mm2s_tdata[63:0]), //i
    .WIDTH         (SubModule_GEMM_WIDTH[12:0]           ), //i
    .HIGHT         (SubModule_GEMM_HIGHT[12:0]           ), //i
    .WEIGHTCOL     (SubModule_GEMM_WEIGHTCOL[11:0]       ), //i
    .start         (SubModule_GEMM_start                 ), //i
    .validOut_0    (SubModule_GEMM_validOut_0            ), //o
    .validOut_1    (SubModule_GEMM_validOut_1            ), //o
    .validOut_2    (SubModule_GEMM_validOut_2            ), //o
    .validOut_3    (SubModule_GEMM_validOut_3            ), //o
    .validOut_4    (SubModule_GEMM_validOut_4            ), //o
    .validOut_5    (SubModule_GEMM_validOut_5            ), //o
    .validOut_6    (SubModule_GEMM_validOut_6            ), //o
    .validOut_7    (SubModule_GEMM_validOut_7            ), //o
    .LayerEnd      (SubModule_GEMM_LayerEnd              ), //o
    .bvalid        (SubModule_GEMM_bvalid                ), //o
    .mData         (SubModule_GEMM_mData[63:0]           ), //o
    .clk           (clk                                  ), //i
    .reset         (reset                                )  //i
  );
  ila_SA_output xil_ila (
    .probe0 (xil_ila_probe0[31:0]), //i
    .probe1 (xil_ila_probe1[31:0]), //i
    .probe2 (xil_ila_probe2[31:0]), //i
    .probe3 (xil_ila_probe3[31:0]), //i
    .probe4 (xil_ila_probe4[31:0]), //i
    .probe5 (xil_ila_probe5[31:0]), //i
    .probe6 (xil_ila_probe6[31:0]), //i
    .probe7 (xil_ila_probe7[31:0]), //i
    .probe8 (xil_ila_probe8[7:0] ), //i
    .clk    (clk                 )  //i
  );
  assign s_axis_s2mm_tready = InputSwitch_s0_axis_s2mm_tready;
  assign when_SA_3D_SwitchVersion_l177 = Control_Switch[4];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_0 = SubModule_GEMM_mData[7 : 0];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_0 = SubModule_Img2Col_mData[7 : 0];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_0 = SubModule_GEMM_validOut_0;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_0 = SubModule_Img2Col_mValid[0];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_1 = SubModule_GEMM_mData[15 : 8];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_1 = SubModule_Img2Col_mData[15 : 8];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_1 = SubModule_GEMM_validOut_1;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_1 = SubModule_Img2Col_mValid[1];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_2 = SubModule_GEMM_mData[23 : 16];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_2 = SubModule_Img2Col_mData[23 : 16];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_2 = SubModule_GEMM_validOut_2;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_2 = SubModule_Img2Col_mValid[2];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_3 = SubModule_GEMM_mData[31 : 24];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_3 = SubModule_Img2Col_mData[31 : 24];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_3 = SubModule_GEMM_validOut_3;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_3 = SubModule_Img2Col_mValid[3];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_4 = SubModule_GEMM_mData[39 : 32];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_4 = SubModule_Img2Col_mData[39 : 32];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_4 = SubModule_GEMM_validOut_4;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_4 = SubModule_Img2Col_mValid[4];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_5 = SubModule_GEMM_mData[47 : 40];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_5 = SubModule_Img2Col_mData[47 : 40];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_5 = SubModule_GEMM_validOut_5;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_5 = SubModule_Img2Col_mValid[5];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_6 = SubModule_GEMM_mData[55 : 48];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_6 = SubModule_Img2Col_mData[55 : 48];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_6 = SubModule_GEMM_validOut_6;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_6 = SubModule_Img2Col_mValid[6];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_MatrixA_7 = SubModule_GEMM_mData[63 : 56];
    end else begin
      SubModule_SA_3D__zz_io_MatrixA_7 = SubModule_Img2Col_mData[63 : 56];
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l177) begin
      SubModule_SA_3D__zz_io_A_Valid_7 = SubModule_GEMM_validOut_7;
    end else begin
      SubModule_SA_3D__zz_io_A_Valid_7 = SubModule_Img2Col_mValid[7];
    end
  end

  assign SubModule_SA_3D__zz_io_signCount = (Img2Col_WeightMatrix_Row - 16'h0001);
  assign SubModule_GEMM_HIGHT = Gemm_Instru_Height[12:0];
  assign SubModule_GEMM_WIDTH = Gemm_Instru_Width[12:0];
  assign SubModule_GEMM_WEIGHTCOL = Img2Col_OutFeature_Channel[11:0];
  assign GemmStart = (Control_start && Control_Switch[4]);
  assign SubModule_GEMM_start = (_zz_start && GemmStart);
  assign SubModule_SA_3D__zz_io_MatrixB_0 = SubModule_WeightCache_mData_0;
  assign SubModule_SA_3D__zz_io_B_Valid_0 = SubModule_WeightCache_MatrixCol_Switch[0];
  assign SubModule_Img2Col_start = (Control_start && Control_Switch[2]);
  assign SubModule_WeightCache_start = (Control_Switch[0] && Control_start);
  assign SubModule_WeightCache_Raddr_Valid = (Control_Switch[2] ? SubModule_Img2Col_Raddr_Valid : SubModule_GEMM_bvalid);
  assign SubModule_Flatten_sData_payload_0_0 = SubModule_SA_3D_Matrix_C_payload_0[31 : 0];
  assign SubModule_Flatten_sData_payload_1_0 = SubModule_SA_3D_Matrix_C_payload_1[31 : 0];
  assign SubModule_Flatten_sData_payload_2_0 = SubModule_SA_3D_Matrix_C_payload_2[31 : 0];
  assign SubModule_Flatten_sData_payload_3_0 = SubModule_SA_3D_Matrix_C_payload_3[31 : 0];
  assign SubModule_Flatten_sData_payload_4_0 = SubModule_SA_3D_Matrix_C_payload_4[31 : 0];
  assign SubModule_Flatten_sData_payload_5_0 = SubModule_SA_3D_Matrix_C_payload_5[31 : 0];
  assign SubModule_Flatten_sData_payload_6_0 = SubModule_SA_3D_Matrix_C_payload_6[31 : 0];
  assign SubModule_Flatten_sData_payload_7_0 = SubModule_SA_3D_Matrix_C_payload_7[31 : 0];
  assign SubModule_ConvQuant_start = (Control_start && Control_Switch[1]);
  assign SubModule_ConvQuant_dataIn_0 = SubModule_Flatten_mData_0_payload;
  assign SubModule_ConvQuant_dataIn_1 = SubModule_Flatten_mData_1_payload;
  assign SubModule_ConvQuant_dataIn_2 = SubModule_Flatten_mData_2_payload;
  assign SubModule_ConvQuant_dataIn_3 = SubModule_Flatten_mData_3_payload;
  assign SubModule_ConvQuant_dataIn_4 = SubModule_Flatten_mData_4_payload;
  assign SubModule_ConvQuant_dataIn_5 = SubModule_Flatten_mData_5_payload;
  assign SubModule_ConvQuant_dataIn_6 = SubModule_Flatten_mData_6_payload;
  assign SubModule_ConvQuant_dataIn_7 = SubModule_Flatten_mData_7_payload;
  assign SubModule_DataArrange_start = (Control_start && Control_Switch[0]);
  assign SubModule_DataArrange_OutChannel = Img2Col_OutFeature_Channel[9:0];
  assign SubModule_DataArrange_SwitchConv = Control_Switch[2];
  assign SubModule_DataArrange_sData_0 = Quant_Switch_m_0_axis_mm2s_tdata[7 : 0];
  always @(*) begin
    SubModule_DataArrange_sValid[0] = core_SubModule_Flatten_mData_0_valid_delay_15;
    SubModule_DataArrange_sValid[1] = core_SubModule_Flatten_mData_1_valid_delay_15;
    SubModule_DataArrange_sValid[2] = core_SubModule_Flatten_mData_2_valid_delay_15;
    SubModule_DataArrange_sValid[3] = core_SubModule_Flatten_mData_3_valid_delay_15;
    SubModule_DataArrange_sValid[4] = core_SubModule_Flatten_mData_4_valid_delay_15;
    SubModule_DataArrange_sValid[5] = core_SubModule_Flatten_mData_5_valid_delay_15;
    SubModule_DataArrange_sValid[6] = core_SubModule_Flatten_mData_6_valid_delay_15;
    SubModule_DataArrange_sValid[7] = core_SubModule_Flatten_mData_7_valid_delay_15;
  end

  assign SubModule_DataArrange_sData_1 = Quant_Switch_m_0_axis_mm2s_tdata[15 : 8];
  assign SubModule_DataArrange_sData_2 = Quant_Switch_m_0_axis_mm2s_tdata[23 : 16];
  assign SubModule_DataArrange_sData_3 = Quant_Switch_m_0_axis_mm2s_tdata[31 : 24];
  assign SubModule_DataArrange_sData_4 = Quant_Switch_m_0_axis_mm2s_tdata[39 : 32];
  assign SubModule_DataArrange_sData_5 = Quant_Switch_m_0_axis_mm2s_tdata[47 : 40];
  assign SubModule_DataArrange_sData_6 = Quant_Switch_m_0_axis_mm2s_tdata[55 : 48];
  assign SubModule_DataArrange_sData_7 = Quant_Switch_m_0_axis_mm2s_tdata[63 : 56];
  assign SubModule_LayerNorm_start = (Control_start && Control_Switch[3]);
  assign SubModule_LayerNorm_sData_0 = Quant_Switch_m_1_axis_mm2s_tdata[7 : 0];
  assign SubModule_LayerNorm_sData_1 = Quant_Switch_m_1_axis_mm2s_tdata[15 : 8];
  assign SubModule_LayerNorm_sData_2 = Quant_Switch_m_1_axis_mm2s_tdata[23 : 16];
  assign SubModule_LayerNorm_sData_3 = Quant_Switch_m_1_axis_mm2s_tdata[31 : 24];
  assign SubModule_LayerNorm_sData_4 = Quant_Switch_m_1_axis_mm2s_tdata[39 : 32];
  assign SubModule_LayerNorm_sData_5 = Quant_Switch_m_1_axis_mm2s_tdata[47 : 40];
  assign SubModule_LayerNorm_sData_6 = Quant_Switch_m_1_axis_mm2s_tdata[55 : 48];
  assign SubModule_LayerNorm_sData_7 = Quant_Switch_m_1_axis_mm2s_tdata[63 : 56];
  assign SubModule_LayerNorm_Channel_Nums = Img2Col_OutMatrix_Col[9:0];
  assign SubModule_LayerNorm_Token_Nums = {3'd0, _zz_Token_Nums};
  assign SubModule_LayerNorm_ZeroPoint = QuantInstru_zeroIn;
  assign xil_ila_probe0 = SubModule_SA_3D_Matrix_C_payload_0;
  assign xil_ila_probe1 = SubModule_SA_3D_Matrix_C_payload_1;
  assign xil_ila_probe2 = SubModule_SA_3D_Matrix_C_payload_2;
  assign xil_ila_probe3 = SubModule_SA_3D_Matrix_C_payload_3;
  assign xil_ila_probe4 = SubModule_SA_3D_Matrix_C_payload_4;
  assign xil_ila_probe5 = SubModule_SA_3D_Matrix_C_payload_5;
  assign xil_ila_probe6 = SubModule_SA_3D_Matrix_C_payload_6;
  assign xil_ila_probe7 = SubModule_SA_3D_Matrix_C_payload_7;
  assign xil_ila_probe8 = {SubModule_SA_3D_Matrix_C_valid_7,{SubModule_SA_3D_Matrix_C_valid_6,{SubModule_SA_3D_Matrix_C_valid_5,{SubModule_SA_3D_Matrix_C_valid_4,{SubModule_SA_3D_Matrix_C_valid_3,{SubModule_SA_3D_Matrix_C_valid_2,{SubModule_SA_3D_Matrix_C_valid_1,SubModule_SA_3D_Matrix_C_valid_0}}}}}}};
  assign m_axis_mm2s_tdata = OutputSwitch_m0_axis_mm2s_tdata;
  assign m_axis_mm2s_tkeep = OutputSwitch_m0_axis_mm2s_tkeep;
  assign m_axis_mm2s_tlast = OutputSwitch_m0_axis_mm2s_tlast;
  assign m_axis_mm2s_tvalid = OutputSwitch_m0_axis_mm2s_tvalid;
  assign OutputSwitch_s_1_axis_s2mm_tdata = SubModule_LayerNorm_mData_payload;
  always @(posedge clk) begin
    _zz_start <= (! GemmStart);
    _zz_io_MatrixB_1 <= SubModule_WeightCache_mData_1;
    _zz_io_B_Valid_1 <= SubModule_WeightCache_MatrixCol_Switch[1];
    _zz_io_MatrixB_2 <= SubModule_WeightCache_mData_2;
    _zz_io_MatrixB_2_1 <= _zz_io_MatrixB_2;
    _zz_io_B_Valid_2 <= SubModule_WeightCache_MatrixCol_Switch[2];
    _zz_io_B_Valid_2_1 <= _zz_io_B_Valid_2;
    _zz_io_MatrixB_3 <= SubModule_WeightCache_mData_3;
    _zz_io_MatrixB_3_1 <= _zz_io_MatrixB_3;
    _zz_io_MatrixB_3_2 <= _zz_io_MatrixB_3_1;
    _zz_io_B_Valid_3 <= SubModule_WeightCache_MatrixCol_Switch[3];
    _zz_io_B_Valid_3_1 <= _zz_io_B_Valid_3;
    _zz_io_B_Valid_3_2 <= _zz_io_B_Valid_3_1;
    _zz_io_MatrixB_4 <= SubModule_WeightCache_mData_4;
    _zz_io_MatrixB_4_1 <= _zz_io_MatrixB_4;
    _zz_io_MatrixB_4_2 <= _zz_io_MatrixB_4_1;
    _zz_io_MatrixB_4_3 <= _zz_io_MatrixB_4_2;
    _zz_io_B_Valid_4 <= SubModule_WeightCache_MatrixCol_Switch[4];
    _zz_io_B_Valid_4_1 <= _zz_io_B_Valid_4;
    _zz_io_B_Valid_4_2 <= _zz_io_B_Valid_4_1;
    _zz_io_B_Valid_4_3 <= _zz_io_B_Valid_4_2;
    _zz_io_MatrixB_5 <= SubModule_WeightCache_mData_5;
    _zz_io_MatrixB_5_1 <= _zz_io_MatrixB_5;
    _zz_io_MatrixB_5_2 <= _zz_io_MatrixB_5_1;
    _zz_io_MatrixB_5_3 <= _zz_io_MatrixB_5_2;
    _zz_io_MatrixB_5_4 <= _zz_io_MatrixB_5_3;
    _zz_io_B_Valid_5 <= SubModule_WeightCache_MatrixCol_Switch[5];
    _zz_io_B_Valid_5_1 <= _zz_io_B_Valid_5;
    _zz_io_B_Valid_5_2 <= _zz_io_B_Valid_5_1;
    _zz_io_B_Valid_5_3 <= _zz_io_B_Valid_5_2;
    _zz_io_B_Valid_5_4 <= _zz_io_B_Valid_5_3;
    _zz_io_MatrixB_6 <= SubModule_WeightCache_mData_6;
    _zz_io_MatrixB_6_1 <= _zz_io_MatrixB_6;
    _zz_io_MatrixB_6_2 <= _zz_io_MatrixB_6_1;
    _zz_io_MatrixB_6_3 <= _zz_io_MatrixB_6_2;
    _zz_io_MatrixB_6_4 <= _zz_io_MatrixB_6_3;
    _zz_io_MatrixB_6_5 <= _zz_io_MatrixB_6_4;
    _zz_io_B_Valid_6 <= SubModule_WeightCache_MatrixCol_Switch[6];
    _zz_io_B_Valid_6_1 <= _zz_io_B_Valid_6;
    _zz_io_B_Valid_6_2 <= _zz_io_B_Valid_6_1;
    _zz_io_B_Valid_6_3 <= _zz_io_B_Valid_6_2;
    _zz_io_B_Valid_6_4 <= _zz_io_B_Valid_6_3;
    _zz_io_B_Valid_6_5 <= _zz_io_B_Valid_6_4;
    _zz_io_MatrixB_7 <= SubModule_WeightCache_mData_7;
    _zz_io_MatrixB_7_1 <= _zz_io_MatrixB_7;
    _zz_io_MatrixB_7_2 <= _zz_io_MatrixB_7_1;
    _zz_io_MatrixB_7_3 <= _zz_io_MatrixB_7_2;
    _zz_io_MatrixB_7_4 <= _zz_io_MatrixB_7_3;
    _zz_io_MatrixB_7_5 <= _zz_io_MatrixB_7_4;
    _zz_io_MatrixB_7_6 <= _zz_io_MatrixB_7_5;
    _zz_io_B_Valid_7 <= SubModule_WeightCache_MatrixCol_Switch[7];
    _zz_io_B_Valid_7_1 <= _zz_io_B_Valid_7;
    _zz_io_B_Valid_7_2 <= _zz_io_B_Valid_7_1;
    _zz_io_B_Valid_7_3 <= _zz_io_B_Valid_7_2;
    _zz_io_B_Valid_7_4 <= _zz_io_B_Valid_7_3;
    _zz_io_B_Valid_7_5 <= _zz_io_B_Valid_7_4;
    _zz_io_B_Valid_7_6 <= _zz_io_B_Valid_7_5;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_1 <= SubModule_SA_3D_Matrix_C_valid_0;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_2 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_3 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_2;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_4 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_3;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_5 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_4;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_6 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_5;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_7 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_6;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_8 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_7;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_9 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_8;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_10 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_9;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_11 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_10;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_12 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_11;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_13 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_12;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_14 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_13;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_15 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_14;
    core_SubModule_Flatten_mData_0_valid_delay_1 <= SubModule_Flatten_mData_0_valid;
    core_SubModule_Flatten_mData_0_valid_delay_2 <= core_SubModule_Flatten_mData_0_valid_delay_1;
    core_SubModule_Flatten_mData_0_valid_delay_3 <= core_SubModule_Flatten_mData_0_valid_delay_2;
    core_SubModule_Flatten_mData_0_valid_delay_4 <= core_SubModule_Flatten_mData_0_valid_delay_3;
    core_SubModule_Flatten_mData_0_valid_delay_5 <= core_SubModule_Flatten_mData_0_valid_delay_4;
    core_SubModule_Flatten_mData_0_valid_delay_6 <= core_SubModule_Flatten_mData_0_valid_delay_5;
    core_SubModule_Flatten_mData_0_valid_delay_7 <= core_SubModule_Flatten_mData_0_valid_delay_6;
    core_SubModule_Flatten_mData_0_valid_delay_8 <= core_SubModule_Flatten_mData_0_valid_delay_7;
    core_SubModule_Flatten_mData_0_valid_delay_9 <= core_SubModule_Flatten_mData_0_valid_delay_8;
    core_SubModule_Flatten_mData_0_valid_delay_10 <= core_SubModule_Flatten_mData_0_valid_delay_9;
    core_SubModule_Flatten_mData_0_valid_delay_11 <= core_SubModule_Flatten_mData_0_valid_delay_10;
    core_SubModule_Flatten_mData_0_valid_delay_12 <= core_SubModule_Flatten_mData_0_valid_delay_11;
    core_SubModule_Flatten_mData_0_valid_delay_13 <= core_SubModule_Flatten_mData_0_valid_delay_12;
    core_SubModule_Flatten_mData_0_valid_delay_14 <= core_SubModule_Flatten_mData_0_valid_delay_13;
    core_SubModule_Flatten_mData_0_valid_delay_15 <= core_SubModule_Flatten_mData_0_valid_delay_14;
    core_SubModule_Flatten_mData_1_valid_delay_1 <= SubModule_Flatten_mData_1_valid;
    core_SubModule_Flatten_mData_1_valid_delay_2 <= core_SubModule_Flatten_mData_1_valid_delay_1;
    core_SubModule_Flatten_mData_1_valid_delay_3 <= core_SubModule_Flatten_mData_1_valid_delay_2;
    core_SubModule_Flatten_mData_1_valid_delay_4 <= core_SubModule_Flatten_mData_1_valid_delay_3;
    core_SubModule_Flatten_mData_1_valid_delay_5 <= core_SubModule_Flatten_mData_1_valid_delay_4;
    core_SubModule_Flatten_mData_1_valid_delay_6 <= core_SubModule_Flatten_mData_1_valid_delay_5;
    core_SubModule_Flatten_mData_1_valid_delay_7 <= core_SubModule_Flatten_mData_1_valid_delay_6;
    core_SubModule_Flatten_mData_1_valid_delay_8 <= core_SubModule_Flatten_mData_1_valid_delay_7;
    core_SubModule_Flatten_mData_1_valid_delay_9 <= core_SubModule_Flatten_mData_1_valid_delay_8;
    core_SubModule_Flatten_mData_1_valid_delay_10 <= core_SubModule_Flatten_mData_1_valid_delay_9;
    core_SubModule_Flatten_mData_1_valid_delay_11 <= core_SubModule_Flatten_mData_1_valid_delay_10;
    core_SubModule_Flatten_mData_1_valid_delay_12 <= core_SubModule_Flatten_mData_1_valid_delay_11;
    core_SubModule_Flatten_mData_1_valid_delay_13 <= core_SubModule_Flatten_mData_1_valid_delay_12;
    core_SubModule_Flatten_mData_1_valid_delay_14 <= core_SubModule_Flatten_mData_1_valid_delay_13;
    core_SubModule_Flatten_mData_1_valid_delay_15 <= core_SubModule_Flatten_mData_1_valid_delay_14;
    core_SubModule_Flatten_mData_2_valid_delay_1 <= SubModule_Flatten_mData_2_valid;
    core_SubModule_Flatten_mData_2_valid_delay_2 <= core_SubModule_Flatten_mData_2_valid_delay_1;
    core_SubModule_Flatten_mData_2_valid_delay_3 <= core_SubModule_Flatten_mData_2_valid_delay_2;
    core_SubModule_Flatten_mData_2_valid_delay_4 <= core_SubModule_Flatten_mData_2_valid_delay_3;
    core_SubModule_Flatten_mData_2_valid_delay_5 <= core_SubModule_Flatten_mData_2_valid_delay_4;
    core_SubModule_Flatten_mData_2_valid_delay_6 <= core_SubModule_Flatten_mData_2_valid_delay_5;
    core_SubModule_Flatten_mData_2_valid_delay_7 <= core_SubModule_Flatten_mData_2_valid_delay_6;
    core_SubModule_Flatten_mData_2_valid_delay_8 <= core_SubModule_Flatten_mData_2_valid_delay_7;
    core_SubModule_Flatten_mData_2_valid_delay_9 <= core_SubModule_Flatten_mData_2_valid_delay_8;
    core_SubModule_Flatten_mData_2_valid_delay_10 <= core_SubModule_Flatten_mData_2_valid_delay_9;
    core_SubModule_Flatten_mData_2_valid_delay_11 <= core_SubModule_Flatten_mData_2_valid_delay_10;
    core_SubModule_Flatten_mData_2_valid_delay_12 <= core_SubModule_Flatten_mData_2_valid_delay_11;
    core_SubModule_Flatten_mData_2_valid_delay_13 <= core_SubModule_Flatten_mData_2_valid_delay_12;
    core_SubModule_Flatten_mData_2_valid_delay_14 <= core_SubModule_Flatten_mData_2_valid_delay_13;
    core_SubModule_Flatten_mData_2_valid_delay_15 <= core_SubModule_Flatten_mData_2_valid_delay_14;
    core_SubModule_Flatten_mData_3_valid_delay_1 <= SubModule_Flatten_mData_3_valid;
    core_SubModule_Flatten_mData_3_valid_delay_2 <= core_SubModule_Flatten_mData_3_valid_delay_1;
    core_SubModule_Flatten_mData_3_valid_delay_3 <= core_SubModule_Flatten_mData_3_valid_delay_2;
    core_SubModule_Flatten_mData_3_valid_delay_4 <= core_SubModule_Flatten_mData_3_valid_delay_3;
    core_SubModule_Flatten_mData_3_valid_delay_5 <= core_SubModule_Flatten_mData_3_valid_delay_4;
    core_SubModule_Flatten_mData_3_valid_delay_6 <= core_SubModule_Flatten_mData_3_valid_delay_5;
    core_SubModule_Flatten_mData_3_valid_delay_7 <= core_SubModule_Flatten_mData_3_valid_delay_6;
    core_SubModule_Flatten_mData_3_valid_delay_8 <= core_SubModule_Flatten_mData_3_valid_delay_7;
    core_SubModule_Flatten_mData_3_valid_delay_9 <= core_SubModule_Flatten_mData_3_valid_delay_8;
    core_SubModule_Flatten_mData_3_valid_delay_10 <= core_SubModule_Flatten_mData_3_valid_delay_9;
    core_SubModule_Flatten_mData_3_valid_delay_11 <= core_SubModule_Flatten_mData_3_valid_delay_10;
    core_SubModule_Flatten_mData_3_valid_delay_12 <= core_SubModule_Flatten_mData_3_valid_delay_11;
    core_SubModule_Flatten_mData_3_valid_delay_13 <= core_SubModule_Flatten_mData_3_valid_delay_12;
    core_SubModule_Flatten_mData_3_valid_delay_14 <= core_SubModule_Flatten_mData_3_valid_delay_13;
    core_SubModule_Flatten_mData_3_valid_delay_15 <= core_SubModule_Flatten_mData_3_valid_delay_14;
    core_SubModule_Flatten_mData_4_valid_delay_1 <= SubModule_Flatten_mData_4_valid;
    core_SubModule_Flatten_mData_4_valid_delay_2 <= core_SubModule_Flatten_mData_4_valid_delay_1;
    core_SubModule_Flatten_mData_4_valid_delay_3 <= core_SubModule_Flatten_mData_4_valid_delay_2;
    core_SubModule_Flatten_mData_4_valid_delay_4 <= core_SubModule_Flatten_mData_4_valid_delay_3;
    core_SubModule_Flatten_mData_4_valid_delay_5 <= core_SubModule_Flatten_mData_4_valid_delay_4;
    core_SubModule_Flatten_mData_4_valid_delay_6 <= core_SubModule_Flatten_mData_4_valid_delay_5;
    core_SubModule_Flatten_mData_4_valid_delay_7 <= core_SubModule_Flatten_mData_4_valid_delay_6;
    core_SubModule_Flatten_mData_4_valid_delay_8 <= core_SubModule_Flatten_mData_4_valid_delay_7;
    core_SubModule_Flatten_mData_4_valid_delay_9 <= core_SubModule_Flatten_mData_4_valid_delay_8;
    core_SubModule_Flatten_mData_4_valid_delay_10 <= core_SubModule_Flatten_mData_4_valid_delay_9;
    core_SubModule_Flatten_mData_4_valid_delay_11 <= core_SubModule_Flatten_mData_4_valid_delay_10;
    core_SubModule_Flatten_mData_4_valid_delay_12 <= core_SubModule_Flatten_mData_4_valid_delay_11;
    core_SubModule_Flatten_mData_4_valid_delay_13 <= core_SubModule_Flatten_mData_4_valid_delay_12;
    core_SubModule_Flatten_mData_4_valid_delay_14 <= core_SubModule_Flatten_mData_4_valid_delay_13;
    core_SubModule_Flatten_mData_4_valid_delay_15 <= core_SubModule_Flatten_mData_4_valid_delay_14;
    core_SubModule_Flatten_mData_5_valid_delay_1 <= SubModule_Flatten_mData_5_valid;
    core_SubModule_Flatten_mData_5_valid_delay_2 <= core_SubModule_Flatten_mData_5_valid_delay_1;
    core_SubModule_Flatten_mData_5_valid_delay_3 <= core_SubModule_Flatten_mData_5_valid_delay_2;
    core_SubModule_Flatten_mData_5_valid_delay_4 <= core_SubModule_Flatten_mData_5_valid_delay_3;
    core_SubModule_Flatten_mData_5_valid_delay_5 <= core_SubModule_Flatten_mData_5_valid_delay_4;
    core_SubModule_Flatten_mData_5_valid_delay_6 <= core_SubModule_Flatten_mData_5_valid_delay_5;
    core_SubModule_Flatten_mData_5_valid_delay_7 <= core_SubModule_Flatten_mData_5_valid_delay_6;
    core_SubModule_Flatten_mData_5_valid_delay_8 <= core_SubModule_Flatten_mData_5_valid_delay_7;
    core_SubModule_Flatten_mData_5_valid_delay_9 <= core_SubModule_Flatten_mData_5_valid_delay_8;
    core_SubModule_Flatten_mData_5_valid_delay_10 <= core_SubModule_Flatten_mData_5_valid_delay_9;
    core_SubModule_Flatten_mData_5_valid_delay_11 <= core_SubModule_Flatten_mData_5_valid_delay_10;
    core_SubModule_Flatten_mData_5_valid_delay_12 <= core_SubModule_Flatten_mData_5_valid_delay_11;
    core_SubModule_Flatten_mData_5_valid_delay_13 <= core_SubModule_Flatten_mData_5_valid_delay_12;
    core_SubModule_Flatten_mData_5_valid_delay_14 <= core_SubModule_Flatten_mData_5_valid_delay_13;
    core_SubModule_Flatten_mData_5_valid_delay_15 <= core_SubModule_Flatten_mData_5_valid_delay_14;
    core_SubModule_Flatten_mData_6_valid_delay_1 <= SubModule_Flatten_mData_6_valid;
    core_SubModule_Flatten_mData_6_valid_delay_2 <= core_SubModule_Flatten_mData_6_valid_delay_1;
    core_SubModule_Flatten_mData_6_valid_delay_3 <= core_SubModule_Flatten_mData_6_valid_delay_2;
    core_SubModule_Flatten_mData_6_valid_delay_4 <= core_SubModule_Flatten_mData_6_valid_delay_3;
    core_SubModule_Flatten_mData_6_valid_delay_5 <= core_SubModule_Flatten_mData_6_valid_delay_4;
    core_SubModule_Flatten_mData_6_valid_delay_6 <= core_SubModule_Flatten_mData_6_valid_delay_5;
    core_SubModule_Flatten_mData_6_valid_delay_7 <= core_SubModule_Flatten_mData_6_valid_delay_6;
    core_SubModule_Flatten_mData_6_valid_delay_8 <= core_SubModule_Flatten_mData_6_valid_delay_7;
    core_SubModule_Flatten_mData_6_valid_delay_9 <= core_SubModule_Flatten_mData_6_valid_delay_8;
    core_SubModule_Flatten_mData_6_valid_delay_10 <= core_SubModule_Flatten_mData_6_valid_delay_9;
    core_SubModule_Flatten_mData_6_valid_delay_11 <= core_SubModule_Flatten_mData_6_valid_delay_10;
    core_SubModule_Flatten_mData_6_valid_delay_12 <= core_SubModule_Flatten_mData_6_valid_delay_11;
    core_SubModule_Flatten_mData_6_valid_delay_13 <= core_SubModule_Flatten_mData_6_valid_delay_12;
    core_SubModule_Flatten_mData_6_valid_delay_14 <= core_SubModule_Flatten_mData_6_valid_delay_13;
    core_SubModule_Flatten_mData_6_valid_delay_15 <= core_SubModule_Flatten_mData_6_valid_delay_14;
    core_SubModule_Flatten_mData_7_valid_delay_1 <= SubModule_Flatten_mData_7_valid;
    core_SubModule_Flatten_mData_7_valid_delay_2 <= core_SubModule_Flatten_mData_7_valid_delay_1;
    core_SubModule_Flatten_mData_7_valid_delay_3 <= core_SubModule_Flatten_mData_7_valid_delay_2;
    core_SubModule_Flatten_mData_7_valid_delay_4 <= core_SubModule_Flatten_mData_7_valid_delay_3;
    core_SubModule_Flatten_mData_7_valid_delay_5 <= core_SubModule_Flatten_mData_7_valid_delay_4;
    core_SubModule_Flatten_mData_7_valid_delay_6 <= core_SubModule_Flatten_mData_7_valid_delay_5;
    core_SubModule_Flatten_mData_7_valid_delay_7 <= core_SubModule_Flatten_mData_7_valid_delay_6;
    core_SubModule_Flatten_mData_7_valid_delay_8 <= core_SubModule_Flatten_mData_7_valid_delay_7;
    core_SubModule_Flatten_mData_7_valid_delay_9 <= core_SubModule_Flatten_mData_7_valid_delay_8;
    core_SubModule_Flatten_mData_7_valid_delay_10 <= core_SubModule_Flatten_mData_7_valid_delay_9;
    core_SubModule_Flatten_mData_7_valid_delay_11 <= core_SubModule_Flatten_mData_7_valid_delay_10;
    core_SubModule_Flatten_mData_7_valid_delay_12 <= core_SubModule_Flatten_mData_7_valid_delay_11;
    core_SubModule_Flatten_mData_7_valid_delay_13 <= core_SubModule_Flatten_mData_7_valid_delay_12;
    core_SubModule_Flatten_mData_7_valid_delay_14 <= core_SubModule_Flatten_mData_7_valid_delay_13;
    core_SubModule_Flatten_mData_7_valid_delay_15 <= core_SubModule_Flatten_mData_7_valid_delay_14;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_1_1 <= SubModule_SA_3D_Matrix_C_valid_0;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_2_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_1_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_3_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_2_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_4_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_3_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_5_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_4_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_6_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_5_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_7_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_6_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_8_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_7_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_9_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_8_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_10_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_9_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_11_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_10_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_12_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_11_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_13_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_12_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_14_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_13_1;
    core_SubModule_SA_3D_Matrix_C_valid_0_delay_15_1 <= core_SubModule_SA_3D_Matrix_C_valid_0_delay_14_1;
  end


endmodule

module RegTable (
  input               regSData_awvalid,
  output reg          regSData_awready,
  input      [19:0]   regSData_awaddr,
  input      [2:0]    regSData_awprot,
  input               regSData_wvalid,
  output reg          regSData_wready,
  input      [31:0]   regSData_wdata,
  input      [3:0]    regSData_wstrb,
  output              regSData_bvalid,
  input               regSData_bready,
  output     [1:0]    regSData_bresp,
  input               regSData_arvalid,
  output reg          regSData_arready,
  input      [19:0]   regSData_araddr,
  input      [2:0]    regSData_arprot,
  output              regSData_rvalid,
  input               regSData_rready,
  output     [31:0]   regSData_rdata,
  output     [1:0]    regSData_rresp,
  output reg [3:0]    LD0123,
  output reg [3:0]    LD4567,
  output reg          Start,
  output reg          SwitchConv,
  output reg          Matrix2Img,
  output reg [4:0]    SwitchCtrl,
  output reg [3:0]    QuantSwitch,
  output reg [3:0]    OutSwitchCtrl,
  output reg [4:0]    Stride,
  output reg [4:0]    Kernel_Size,
  output reg          enPadding,
  output reg [7:0]    zeroDara,
  output reg [1:0]    zeroNum,
  output reg [15:0]   Window_Size,
  output reg [15:0]   InFeature_Size,
  output reg [15:0]   InFeature_Channel,
  output reg [15:0]   OutFeature_Channel,
  output reg [15:0]   OutFeature_Size,
  output reg [12:0]   Sliding_Size,
  output reg [15:0]   OutCol_Count_Times,
  output reg [15:0]   InCol_Count_Times,
  output reg [15:0]   OutRow_Count_Times,
  output reg [15:0]   OutFeature_Channel_Count_Times,
  output reg [15:0]   WeightMatrix_Row,
  output reg [11:0]   OutMatrix_Col,
  output reg [19:0]   OutMatrix_Row,
  output reg [15:0]   Gemm_Width,
  output reg [15:0]   Gemm_Height,
  output reg [7:0]    Quant_ZeroPoint,
  input               clk,
  input               reset
);

  wire       [0:0]    _zz_Start;
  wire       [0:0]    _zz_SwitchConv;
  wire       [0:0]    _zz_Matrix2Img;
  wire       [0:0]    _zz_enPadding;
  wire       [3:0]    bus_wstrb;
  reg        [31:0]   bus_wmask;
  reg        [31:0]   bus_wmaskn;
  reg                 bus_readError;
  reg        [31:0]   bus_readData;
  wire                bus_axiAr_valid;
  wire                bus_axiAr_ready;
  wire       [19:0]   bus_axiAr_payload_addr;
  wire       [2:0]    bus_axiAr_payload_prot;
  reg                 regSData_ar_rValid;
  reg        [19:0]   regSData_ar_rData_addr;
  reg        [2:0]    regSData_ar_rData_prot;
  wire                when_Stream_l368;
  wire                bus_axiR_valid;
  wire                bus_axiR_ready;
  wire       [31:0]   bus_axiR_payload_data;
  reg        [1:0]    bus_axiR_payload_resp;
  reg                 bus_axiRValid;
  wire                bus_axiAw_valid;
  wire                bus_axiAw_ready;
  wire       [19:0]   bus_axiAw_payload_addr;
  wire       [2:0]    bus_axiAw_payload_prot;
  reg                 regSData_aw_rValid;
  reg        [19:0]   regSData_aw_rData_addr;
  reg        [2:0]    regSData_aw_rData_prot;
  wire                when_Stream_l368_1;
  wire                bus_axiW_valid;
  wire                bus_axiW_ready;
  wire       [31:0]   bus_axiW_payload_data;
  wire       [3:0]    bus_axiW_payload_strb;
  reg                 regSData_w_rValid;
  reg        [31:0]   regSData_w_rData_data;
  reg        [3:0]    regSData_w_rData_strb;
  wire                when_Stream_l368_2;
  wire                bus_axiB_valid;
  wire                bus_axiB_ready;
  wire       [1:0]    bus_axiB_payload_resp;
  reg                 bus_axiBValid;
  wire                bus_askWrite;
  wire                bus_doWrite;
  wire                bus_doRead;
  wire                read_hit_0x0000;
  wire                write_hit_0x0000;
  wire                read_hit_0x0004;
  wire                write_hit_0x0004;
  wire                read_hit_0x0008;
  wire                write_hit_0x0008;
  wire                read_hit_0x000c;
  wire                write_hit_0x000c;
  wire                read_hit_0x0010;
  wire                write_hit_0x0010;
  wire                read_hit_0x0014;
  wire                write_hit_0x0014;
  wire                read_hit_0x0018;
  wire                write_hit_0x0018;
  wire                read_hit_0x001c;
  wire                write_hit_0x001c;
  wire                read_hit_0x0020;
  wire                write_hit_0x0020;
  wire                read_hit_0x0024;
  wire                write_hit_0x0024;
  wire                read_hit_0x0028;
  wire                write_hit_0x0028;
  wire                read_hit_0x002c;
  wire                write_hit_0x002c;
  wire       [19:0]   switch_BusIfBase_l353;

  assign _zz_Start = ((Start & bus_wmaskn[0 : 0]) | (bus_axiW_payload_data[0 : 0] & bus_wmask[0 : 0]));
  assign _zz_SwitchConv = ((SwitchConv & bus_wmaskn[1 : 1]) | (bus_axiW_payload_data[1 : 1] & bus_wmask[1 : 1]));
  assign _zz_Matrix2Img = ((Matrix2Img & bus_wmaskn[2 : 2]) | (bus_axiW_payload_data[2 : 2] & bus_wmask[2 : 2]));
  assign _zz_enPadding = ((enPadding & bus_wmaskn[10 : 10]) | (bus_axiW_payload_data[10 : 10] & bus_wmask[10 : 10]));
  always @(*) begin
    regSData_arready = bus_axiAr_ready;
    if(when_Stream_l368) begin
      regSData_arready = 1'b1;
    end
  end

  assign when_Stream_l368 = (! bus_axiAr_valid);
  assign bus_axiAr_valid = regSData_ar_rValid;
  assign bus_axiAr_payload_addr = regSData_ar_rData_addr;
  assign bus_axiAr_payload_prot = regSData_ar_rData_prot;
  always @(*) begin
    regSData_awready = bus_axiAw_ready;
    if(when_Stream_l368_1) begin
      regSData_awready = 1'b1;
    end
  end

  assign when_Stream_l368_1 = (! bus_axiAw_valid);
  assign bus_axiAw_valid = regSData_aw_rValid;
  assign bus_axiAw_payload_addr = regSData_aw_rData_addr;
  assign bus_axiAw_payload_prot = regSData_aw_rData_prot;
  always @(*) begin
    regSData_wready = bus_axiW_ready;
    if(when_Stream_l368_2) begin
      regSData_wready = 1'b1;
    end
  end

  assign when_Stream_l368_2 = (! bus_axiW_valid);
  assign bus_axiW_valid = regSData_w_rValid;
  assign bus_axiW_payload_data = regSData_w_rData_data;
  assign bus_axiW_payload_strb = regSData_w_rData_strb;
  assign bus_wstrb = (bus_axiAr_valid ? 4'b1111 : bus_axiW_payload_strb);
  always @(*) begin
    bus_wmask[7 : 0] = (bus_wstrb[0] ? 8'hff : 8'h0);
    bus_wmask[15 : 8] = (bus_wstrb[1] ? 8'hff : 8'h0);
    bus_wmask[23 : 16] = (bus_wstrb[2] ? 8'hff : 8'h0);
    bus_wmask[31 : 24] = (bus_wstrb[3] ? 8'hff : 8'h0);
  end

  always @(*) begin
    bus_wmaskn[7 : 0] = (bus_wstrb[0] ? 8'h0 : 8'hff);
    bus_wmaskn[15 : 8] = (bus_wstrb[1] ? 8'h0 : 8'hff);
    bus_wmaskn[23 : 16] = (bus_wstrb[2] ? 8'h0 : 8'hff);
    bus_wmaskn[31 : 24] = (bus_wstrb[3] ? 8'h0 : 8'hff);
  end

  always @(*) begin
    if(bus_readError) begin
      bus_axiR_payload_resp = 2'b10;
    end else begin
      bus_axiR_payload_resp = 2'b00;
    end
  end

  assign bus_axiR_valid = bus_axiRValid;
  assign bus_axiR_payload_data = bus_readData;
  assign bus_axiB_payload_resp = 2'b00;
  assign bus_axiB_valid = bus_axiBValid;
  assign regSData_rvalid = bus_axiR_valid;
  assign bus_axiR_ready = regSData_rready;
  assign regSData_rdata = bus_axiR_payload_data;
  assign regSData_rresp = bus_axiR_payload_resp;
  assign regSData_bvalid = bus_axiB_valid;
  assign bus_axiB_ready = regSData_bready;
  assign regSData_bresp = bus_axiB_payload_resp;
  assign bus_askWrite = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_doWrite = (bus_askWrite && ((! bus_axiB_valid) || bus_axiB_ready));
  assign bus_doRead = (bus_axiAr_valid && ((! bus_axiR_valid) || bus_axiR_ready));
  assign bus_axiAr_ready = bus_doRead;
  assign bus_axiAw_ready = bus_doWrite;
  assign bus_axiW_ready = bus_doWrite;
  assign read_hit_0x0000 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h0) && bus_doRead);
  assign write_hit_0x0000 = ((bus_axiAw_payload_addr == 20'h0) && bus_doWrite);
  assign read_hit_0x0004 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00004) && bus_doRead);
  assign write_hit_0x0004 = ((bus_axiAw_payload_addr == 20'h00004) && bus_doWrite);
  assign read_hit_0x0008 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00008) && bus_doRead);
  assign write_hit_0x0008 = ((bus_axiAw_payload_addr == 20'h00008) && bus_doWrite);
  assign read_hit_0x000c = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h0000c) && bus_doRead);
  assign write_hit_0x000c = ((bus_axiAw_payload_addr == 20'h0000c) && bus_doWrite);
  assign read_hit_0x0010 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00010) && bus_doRead);
  assign write_hit_0x0010 = ((bus_axiAw_payload_addr == 20'h00010) && bus_doWrite);
  assign read_hit_0x0014 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00014) && bus_doRead);
  assign write_hit_0x0014 = ((bus_axiAw_payload_addr == 20'h00014) && bus_doWrite);
  assign read_hit_0x0018 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00018) && bus_doRead);
  assign write_hit_0x0018 = ((bus_axiAw_payload_addr == 20'h00018) && bus_doWrite);
  assign read_hit_0x001c = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h0001c) && bus_doRead);
  assign write_hit_0x001c = ((bus_axiAw_payload_addr == 20'h0001c) && bus_doWrite);
  assign read_hit_0x0020 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00020) && bus_doRead);
  assign write_hit_0x0020 = ((bus_axiAw_payload_addr == 20'h00020) && bus_doWrite);
  assign read_hit_0x0024 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00024) && bus_doRead);
  assign write_hit_0x0024 = ((bus_axiAw_payload_addr == 20'h00024) && bus_doWrite);
  assign read_hit_0x0028 = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h00028) && bus_doRead);
  assign write_hit_0x0028 = ((bus_axiAw_payload_addr == 20'h00028) && bus_doWrite);
  assign read_hit_0x002c = (({bus_axiAr_payload_addr[19 : 2],2'b00} == 20'h0002c) && bus_doRead);
  assign write_hit_0x002c = ((bus_axiAw_payload_addr == 20'h0002c) && bus_doWrite);
  assign switch_BusIfBase_l353 = {bus_axiAr_payload_addr[19 : 2],2'b00};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      bus_readError <= 1'b0;
      bus_readData <= 32'h0;
      regSData_ar_rValid <= 1'b0;
      bus_axiRValid <= 1'b0;
      regSData_aw_rValid <= 1'b0;
      regSData_w_rValid <= 1'b0;
      bus_axiBValid <= 1'b0;
      LD0123 <= 4'b0000;
      LD4567 <= 4'b0000;
      Start <= 1'b0;
      SwitchConv <= 1'b0;
      Matrix2Img <= 1'b0;
      SwitchCtrl <= 5'h0;
      QuantSwitch <= 4'b0000;
      OutSwitchCtrl <= 4'b0000;
      Stride <= 5'h0;
      Kernel_Size <= 5'h0;
      enPadding <= 1'b0;
      zeroDara <= 8'h0;
      zeroNum <= 2'b00;
      Window_Size <= 16'h0;
      InFeature_Size <= 16'h0;
      InFeature_Channel <= 16'h0;
      OutFeature_Channel <= 16'h0;
      OutFeature_Size <= 16'h0;
      Sliding_Size <= 13'h0;
      OutCol_Count_Times <= 16'h0;
      InCol_Count_Times <= 16'h0;
      OutRow_Count_Times <= 16'h0;
      OutFeature_Channel_Count_Times <= 16'h0;
      WeightMatrix_Row <= 16'h0;
      OutMatrix_Col <= 12'h0;
      OutMatrix_Row <= 20'h0;
      Gemm_Width <= 16'h0;
      Gemm_Height <= 16'h0;
      Quant_ZeroPoint <= 8'h0;
    end else begin
      if(regSData_arready) begin
        regSData_ar_rValid <= regSData_arvalid;
      end
      if(regSData_awready) begin
        regSData_aw_rValid <= regSData_awvalid;
      end
      if(regSData_wready) begin
        regSData_w_rValid <= regSData_wvalid;
      end
      if(bus_axiR_ready) begin
        bus_axiRValid <= 1'b0;
      end
      if(bus_doRead) begin
        bus_axiRValid <= 1'b1;
      end
      if(bus_axiB_ready) begin
        bus_axiBValid <= 1'b0;
      end
      if(bus_doWrite) begin
        bus_axiBValid <= 1'b1;
      end
      if(write_hit_0x0000) begin
        LD0123 <= ((LD0123 & bus_wmaskn[3 : 0]) | (bus_axiW_payload_data[3 : 0] & bus_wmask[3 : 0]));
      end
      if(write_hit_0x0000) begin
        LD4567 <= ((LD4567 & bus_wmaskn[7 : 4]) | (bus_axiW_payload_data[7 : 4] & bus_wmask[7 : 4]));
      end
      if(write_hit_0x0004) begin
        Start <= _zz_Start[0];
      end
      if(write_hit_0x0004) begin
        SwitchConv <= _zz_SwitchConv[0];
      end
      if(write_hit_0x0004) begin
        Matrix2Img <= _zz_Matrix2Img[0];
      end
      if(write_hit_0x0004) begin
        SwitchCtrl <= ((SwitchCtrl & bus_wmaskn[7 : 3]) | (bus_axiW_payload_data[7 : 3] & bus_wmask[7 : 3]));
      end
      if(write_hit_0x0004) begin
        QuantSwitch <= ((QuantSwitch & bus_wmaskn[11 : 8]) | (bus_axiW_payload_data[11 : 8] & bus_wmask[11 : 8]));
      end
      if(write_hit_0x0004) begin
        OutSwitchCtrl <= ((OutSwitchCtrl & bus_wmaskn[15 : 12]) | (bus_axiW_payload_data[15 : 12] & bus_wmask[15 : 12]));
      end
      if(write_hit_0x0008) begin
        Stride <= ((Stride & bus_wmaskn[4 : 0]) | (bus_axiW_payload_data[4 : 0] & bus_wmask[4 : 0]));
      end
      if(write_hit_0x0008) begin
        Kernel_Size <= ((Kernel_Size & bus_wmaskn[9 : 5]) | (bus_axiW_payload_data[9 : 5] & bus_wmask[9 : 5]));
      end
      if(write_hit_0x0008) begin
        enPadding <= _zz_enPadding[0];
      end
      if(write_hit_0x0008) begin
        zeroDara <= ((zeroDara & bus_wmaskn[18 : 11]) | (bus_axiW_payload_data[18 : 11] & bus_wmask[18 : 11]));
      end
      if(write_hit_0x0008) begin
        zeroNum <= ((zeroNum & bus_wmaskn[20 : 19]) | (bus_axiW_payload_data[20 : 19] & bus_wmask[20 : 19]));
      end
      if(write_hit_0x000c) begin
        Window_Size <= ((Window_Size & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x000c) begin
        InFeature_Size <= ((InFeature_Size & bus_wmaskn[31 : 16]) | (bus_axiW_payload_data[31 : 16] & bus_wmask[31 : 16]));
      end
      if(write_hit_0x0010) begin
        InFeature_Channel <= ((InFeature_Channel & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x0010) begin
        OutFeature_Channel <= ((OutFeature_Channel & bus_wmaskn[31 : 16]) | (bus_axiW_payload_data[31 : 16] & bus_wmask[31 : 16]));
      end
      if(write_hit_0x0014) begin
        OutFeature_Size <= ((OutFeature_Size & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x0014) begin
        Sliding_Size <= ((Sliding_Size & bus_wmaskn[28 : 16]) | (bus_axiW_payload_data[28 : 16] & bus_wmask[28 : 16]));
      end
      if(write_hit_0x0018) begin
        OutCol_Count_Times <= ((OutCol_Count_Times & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x0018) begin
        InCol_Count_Times <= ((InCol_Count_Times & bus_wmaskn[31 : 16]) | (bus_axiW_payload_data[31 : 16] & bus_wmask[31 : 16]));
      end
      if(write_hit_0x001c) begin
        OutRow_Count_Times <= ((OutRow_Count_Times & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x001c) begin
        OutFeature_Channel_Count_Times <= ((OutFeature_Channel_Count_Times & bus_wmaskn[31 : 16]) | (bus_axiW_payload_data[31 : 16] & bus_wmask[31 : 16]));
      end
      if(write_hit_0x0020) begin
        WeightMatrix_Row <= ((WeightMatrix_Row & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x0024) begin
        OutMatrix_Col <= ((OutMatrix_Col & bus_wmaskn[11 : 0]) | (bus_axiW_payload_data[11 : 0] & bus_wmask[11 : 0]));
      end
      if(write_hit_0x0024) begin
        OutMatrix_Row <= ((OutMatrix_Row & bus_wmaskn[31 : 12]) | (bus_axiW_payload_data[31 : 12] & bus_wmask[31 : 12]));
      end
      if(write_hit_0x0028) begin
        Gemm_Width <= ((Gemm_Width & bus_wmaskn[15 : 0]) | (bus_axiW_payload_data[15 : 0] & bus_wmask[15 : 0]));
      end
      if(write_hit_0x0028) begin
        Gemm_Height <= ((Gemm_Height & bus_wmaskn[31 : 16]) | (bus_axiW_payload_data[31 : 16] & bus_wmask[31 : 16]));
      end
      if(write_hit_0x002c) begin
        Quant_ZeroPoint <= ((Quant_ZeroPoint & bus_wmaskn[7 : 0]) | (bus_axiW_payload_data[7 : 0] & bus_wmask[7 : 0]));
      end
      if(bus_axiAr_valid) begin
        case(switch_BusIfBase_l353)
          20'h0 : begin
            bus_readData <= {24'h0,{4'b0000,4'b0000}};
            bus_readError <= 1'b1;
          end
          20'h00004 : begin
            bus_readData <= {16'h0,{4'b0000,{4'b0000,{5'h0,{1'b0,{1'b0,1'b0}}}}}};
            bus_readError <= 1'b1;
          end
          20'h00008 : begin
            bus_readData <= {11'h0,{2'b00,{8'h0,{1'b0,{5'h0,5'h0}}}}};
            bus_readError <= 1'b1;
          end
          20'h0000c : begin
            bus_readData <= {16'h0,16'h0};
            bus_readError <= 1'b1;
          end
          20'h00010 : begin
            bus_readData <= {16'h0,16'h0};
            bus_readError <= 1'b1;
          end
          20'h00014 : begin
            bus_readData <= {3'b000,{13'h0,16'h0}};
            bus_readError <= 1'b1;
          end
          20'h00018 : begin
            bus_readData <= {16'h0,16'h0};
            bus_readError <= 1'b1;
          end
          20'h0001c : begin
            bus_readData <= {16'h0,16'h0};
            bus_readError <= 1'b1;
          end
          20'h00020 : begin
            bus_readData <= {16'h0,16'h0};
            bus_readError <= 1'b1;
          end
          20'h00024 : begin
            bus_readData <= {20'h0,12'h0};
            bus_readError <= 1'b1;
          end
          20'h00028 : begin
            bus_readData <= {16'h0,16'h0};
            bus_readError <= 1'b1;
          end
          20'h0002c : begin
            bus_readData <= {24'h0,8'h0};
            bus_readError <= 1'b1;
          end
          default : begin
            bus_readData <= 32'h0;
            bus_readError <= 1'b0;
          end
        endcase
      end else begin
        bus_readData <= 32'h0;
        bus_readError <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(regSData_arready) begin
      regSData_ar_rData_addr <= regSData_araddr;
      regSData_ar_rData_prot <= regSData_arprot;
    end
    if(regSData_awready) begin
      regSData_aw_rData_addr <= regSData_awaddr;
      regSData_aw_rData_prot <= regSData_awprot;
    end
    if(regSData_wready) begin
      regSData_w_rData_data <= regSData_wdata;
      regSData_w_rData_strb <= regSData_wstrb;
    end
  end


endmodule

module GemmCache (
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  input      [12:0]   WIDTH,
  input      [12:0]   HIGHT,
  input      [11:0]   WEIGHTCOL,
  input               start,
  output              validOut_0,
  output              validOut_1,
  output              validOut_2,
  output              validOut_3,
  output              validOut_4,
  output              validOut_5,
  output              validOut_6,
  output              validOut_7,
  output              LayerEnd,
  output reg          bvalid,
  output reg [63:0]   mData,
  input               clk,
  input               reset
);
  localparam GEMM_ENUM_IDLE = 8'd1;
  localparam GEMM_ENUM_INIT = 8'd2;
  localparam GEMM_ENUM_WRITE = 8'd4;
  localparam GEMM_ENUM_READ = 8'd8;
  localparam GEMM_ENUM_CHECK = 8'd16;
  localparam GEMM_ENUM_END_1 = 8'd32;
  localparam GEMM_ENUM_ENDOTHER = 8'd64;
  localparam GEMM_ENUM_ENDOUT = 8'd128;
  localparam RW_ENUM_IDLE = 2'd1;
  localparam RW_ENUM_WRITE = 2'd2;

  reg        [9:0]    xil_SimpleDualBram_addra;
  reg        [63:0]   xil_SimpleDualBram_dina;
  reg                 xil_SimpleDualBram_ena;
  reg                 xil_SimpleDualBram_wea;
  reg        [12:0]   xil_SimpleDualBram_addrb;
  reg        [9:0]    xil_SimpleDualBram_1_addra;
  reg        [63:0]   xil_SimpleDualBram_1_dina;
  reg                 xil_SimpleDualBram_1_ena;
  reg                 xil_SimpleDualBram_1_wea;
  reg        [12:0]   xil_SimpleDualBram_1_addrb;
  reg        [9:0]    xil_SimpleDualBram_2_addra;
  reg        [63:0]   xil_SimpleDualBram_2_dina;
  reg                 xil_SimpleDualBram_2_ena;
  reg                 xil_SimpleDualBram_2_wea;
  reg        [12:0]   xil_SimpleDualBram_2_addrb;
  reg        [9:0]    xil_SimpleDualBram_3_addra;
  reg        [63:0]   xil_SimpleDualBram_3_dina;
  reg                 xil_SimpleDualBram_3_ena;
  reg                 xil_SimpleDualBram_3_wea;
  reg        [12:0]   xil_SimpleDualBram_3_addrb;
  reg        [9:0]    xil_SimpleDualBram_4_addra;
  reg        [63:0]   xil_SimpleDualBram_4_dina;
  reg                 xil_SimpleDualBram_4_ena;
  reg                 xil_SimpleDualBram_4_wea;
  reg        [12:0]   xil_SimpleDualBram_4_addrb;
  reg        [9:0]    xil_SimpleDualBram_5_addra;
  reg        [63:0]   xil_SimpleDualBram_5_dina;
  reg                 xil_SimpleDualBram_5_ena;
  reg                 xil_SimpleDualBram_5_wea;
  reg        [12:0]   xil_SimpleDualBram_5_addrb;
  reg        [9:0]    xil_SimpleDualBram_6_addra;
  reg        [63:0]   xil_SimpleDualBram_6_dina;
  reg                 xil_SimpleDualBram_6_ena;
  reg                 xil_SimpleDualBram_6_wea;
  reg        [12:0]   xil_SimpleDualBram_6_addrb;
  reg        [9:0]    xil_SimpleDualBram_7_addra;
  reg        [63:0]   xil_SimpleDualBram_7_dina;
  reg                 xil_SimpleDualBram_7_ena;
  reg                 xil_SimpleDualBram_7_wea;
  reg        [12:0]   xil_SimpleDualBram_7_addrb;
  reg        [9:0]    xil_SimpleDualBram_8_addra;
  reg        [63:0]   xil_SimpleDualBram_8_dina;
  reg                 xil_SimpleDualBram_8_ena;
  reg                 xil_SimpleDualBram_8_wea;
  reg        [12:0]   xil_SimpleDualBram_8_addrb;
  reg        [9:0]    xil_SimpleDualBram_9_addra;
  reg        [63:0]   xil_SimpleDualBram_9_dina;
  reg                 xil_SimpleDualBram_9_ena;
  reg                 xil_SimpleDualBram_9_wea;
  reg        [12:0]   xil_SimpleDualBram_9_addrb;
  reg        [9:0]    xil_SimpleDualBram_10_addra;
  reg        [63:0]   xil_SimpleDualBram_10_dina;
  reg                 xil_SimpleDualBram_10_ena;
  reg                 xil_SimpleDualBram_10_wea;
  reg        [12:0]   xil_SimpleDualBram_10_addrb;
  reg        [9:0]    xil_SimpleDualBram_11_addra;
  reg        [63:0]   xil_SimpleDualBram_11_dina;
  reg                 xil_SimpleDualBram_11_ena;
  reg                 xil_SimpleDualBram_11_wea;
  reg        [12:0]   xil_SimpleDualBram_11_addrb;
  reg        [9:0]    xil_SimpleDualBram_12_addra;
  reg        [63:0]   xil_SimpleDualBram_12_dina;
  reg                 xil_SimpleDualBram_12_ena;
  reg                 xil_SimpleDualBram_12_wea;
  reg        [12:0]   xil_SimpleDualBram_12_addrb;
  reg        [9:0]    xil_SimpleDualBram_13_addra;
  reg        [63:0]   xil_SimpleDualBram_13_dina;
  reg                 xil_SimpleDualBram_13_ena;
  reg                 xil_SimpleDualBram_13_wea;
  reg        [12:0]   xil_SimpleDualBram_13_addrb;
  reg        [9:0]    xil_SimpleDualBram_14_addra;
  reg        [63:0]   xil_SimpleDualBram_14_dina;
  reg                 xil_SimpleDualBram_14_ena;
  reg                 xil_SimpleDualBram_14_wea;
  reg        [12:0]   xil_SimpleDualBram_14_addrb;
  reg        [9:0]    xil_SimpleDualBram_15_addra;
  reg        [63:0]   xil_SimpleDualBram_15_dina;
  reg                 xil_SimpleDualBram_15_ena;
  reg                 xil_SimpleDualBram_15_wea;
  reg        [12:0]   xil_SimpleDualBram_15_addrb;
  wire       [7:0]    xil_SimpleDualBram_doutb;
  wire       [7:0]    xil_SimpleDualBram_1_doutb;
  wire       [7:0]    xil_SimpleDualBram_2_doutb;
  wire       [7:0]    xil_SimpleDualBram_3_doutb;
  wire       [7:0]    xil_SimpleDualBram_4_doutb;
  wire       [7:0]    xil_SimpleDualBram_5_doutb;
  wire       [7:0]    xil_SimpleDualBram_6_doutb;
  wire       [7:0]    xil_SimpleDualBram_7_doutb;
  wire       [7:0]    xil_SimpleDualBram_8_doutb;
  wire       [7:0]    xil_SimpleDualBram_9_doutb;
  wire       [7:0]    xil_SimpleDualBram_10_doutb;
  wire       [7:0]    xil_SimpleDualBram_11_doutb;
  wire       [7:0]    xil_SimpleDualBram_12_doutb;
  wire       [7:0]    xil_SimpleDualBram_13_doutb;
  wire       [7:0]    xil_SimpleDualBram_14_doutb;
  wire       [7:0]    xil_SimpleDualBram_15_doutb;
  wire       [15:0]   _zz_colCnt_valid;
  wire       [12:0]   _zz_colCnt_valid_1;
  wire       [12:0]   _zz_rAddrCnt_valid;
  wire       [11:0]   _zz_totalCnt_valid;
  wire       [11:0]   _zz_totalCnt_valid_1;
  wire       [15:0]   _zz_OneColCnt_valid;
  wire       [12:0]   _zz_OneColCnt_valid_1;
  wire       [12:0]   _zz_OneColCnt_valid_2;
  wire       [15:0]   _zz_rowCnt_valid;
  wire       [12:0]   _zz_rowCnt_valid_1;
  wire       [12:0]   _zz_hangCnt_valid;
  wire       [12:0]   _zz_hangCnt_count_1;
  wire       [0:0]    _zz_ena;
  wire       [0:0]    _zz_ena_1;
  wire       [0:0]    _zz_ena_2;
  wire       [0:0]    _zz_ena_3;
  wire       [0:0]    _zz_ena_4;
  wire       [0:0]    _zz_ena_5;
  wire       [0:0]    _zz_ena_6;
  wire       [0:0]    _zz_ena_7;
  wire       [0:0]    _zz_ena_8;
  wire       [0:0]    _zz_ena_9;
  wire       [0:0]    _zz_ena_10;
  wire       [0:0]    _zz_ena_11;
  wire       [0:0]    _zz_ena_12;
  wire       [0:0]    _zz_ena_13;
  wire       [0:0]    _zz_ena_14;
  wire       [0:0]    _zz_ena_15;
  reg                 Switch;
  reg                 valid_0;
  reg                 valid_1;
  reg                 valid_2;
  reg                 valid_3;
  reg                 valid_4;
  reg                 valid_5;
  reg                 valid_6;
  reg                 valid_7;
  reg        [7:0]    fsm_currentState;
  reg        [7:0]    fsm_nextState;
  wire                fsm_initEnd;
  wire                fsm_readFinish;
  wire                fsm_writeEnd;
  wire                fsm_judge;
  wire                fsm_otherWrite;
  wire                fsm_dataEnd;
  wire                fsm_end;
  reg                 Switch_regNext;
  reg                 Switch_regNext_1;
  wire                when_GEMM_l45;
  reg        [1:0]    rwfsm_currentState;
  reg        [1:0]    rwfsm_nextState;
  wire                rwfsm_writeEnd;
  wire                when_WaCounter_l40;
  reg        [2:0]    initCount_count;
  wire                initCount_valid;
  wire                sData_fire;
  reg        [15:0]   colCnt_count;
  reg                 colCnt_valid;
  wire                when_WaCounter_l40_1;
  reg        [12:0]   rAddrCnt_count;
  wire                rAddrCnt_valid;
  reg        [11:0]   totalCnt_count;
  wire                totalCnt_valid;
  reg                 finish;
  wire                sData_fire_1;
  reg        [15:0]   OneColCnt_count;
  wire                OneColCnt_valid;
  reg        [15:0]   rowCnt_count;
  wire                rowCnt_valid;
  wire       [3:0]    _zz_hangCnt_count;
  reg        [12:0]   hangCnt_count;
  reg                 hangCnt_valid;
  wire                when_GEMM_l188;
  reg                 finish_regNext;
  wire                writeend;
  reg                 writeend_delay_1;
  reg                 _zz_1;
  reg                 _zz_2;
  reg        [9:0]    Write_Row_Base_Addr;
  reg        [7:0]    InData_Switch;
  wire                sData_fire_2;
  reg        [63:0]   mdata_temp;
  wire                when_GEMM_l254;
  wire                sData_fire_3;
  wire                sData_fire_4;
  wire                when_GEMM_l254_1;
  wire                sData_fire_5;
  wire                sData_fire_6;
  wire                when_GEMM_l254_2;
  wire                sData_fire_7;
  wire                sData_fire_8;
  wire                when_GEMM_l254_3;
  wire                sData_fire_9;
  wire                sData_fire_10;
  wire                when_GEMM_l254_4;
  wire                sData_fire_11;
  wire                sData_fire_12;
  wire                when_GEMM_l254_5;
  wire                sData_fire_13;
  wire                sData_fire_14;
  wire                when_GEMM_l254_6;
  wire                sData_fire_15;
  wire                sData_fire_16;
  wire                when_GEMM_l254_7;
  wire                sData_fire_17;
  wire                sData_fire_18;
  reg        [7:0]    _zz_mData;
  reg        [7:0]    _zz_mData_1;
  reg        [7:0]    _zz_mData_2;
  reg        [7:0]    _zz_mData_3;
  reg        [7:0]    _zz_mData_4;
  reg        [7:0]    _zz_mData_5;
  reg        [7:0]    _zz_mData_6;
  reg        [7:0]    _zz_mData_7;
  reg        [7:0]    _zz_mData_8;
  reg        [7:0]    _zz_mData_9;
  reg        [7:0]    _zz_mData_10;
  reg        [7:0]    _zz_mData_11;
  reg        [7:0]    _zz_mData_12;
  reg        [7:0]    _zz_mData_13;
  reg        [7:0]    _zz_mData_14;
  reg        [7:0]    _zz_mData_15;
  reg        [7:0]    _zz_mData_16;
  reg        [7:0]    _zz_mData_17;
  reg        [7:0]    _zz_mData_18;
  reg        [7:0]    _zz_mData_19;
  reg        [7:0]    _zz_mData_20;
  reg        [7:0]    _zz_mData_21;
  reg        [7:0]    _zz_mData_22;
  reg        [7:0]    _zz_mData_23;
  reg        [7:0]    _zz_mData_24;
  reg        [7:0]    _zz_mData_25;
  reg        [7:0]    _zz_mData_26;
  reg        [7:0]    _zz_mData_27;
  wire                when_GEMM_l282;
  wire                when_GEMM_l284;
  reg                 _zz_3;
  reg                 _zz_4;
  wire                when_GEMM_l299;
  wire                when_GEMM_l299_1;
  wire                when_GEMM_l299_2;
  wire                when_GEMM_l299_3;
  wire                when_GEMM_l299_4;
  wire                when_GEMM_l299_5;
  wire                when_GEMM_l299_6;
  wire                when_GEMM_l299_7;
  reg                 valid_1_delay_1;
  reg                 valid_2_delay_1;
  reg                 valid_2_delay_2;
  reg                 valid_3_delay_1;
  reg                 valid_3_delay_2;
  reg                 valid_3_delay_3;
  reg                 valid_4_delay_1;
  reg                 valid_4_delay_2;
  reg                 valid_4_delay_3;
  reg                 valid_4_delay_4;
  reg                 valid_5_delay_1;
  reg                 valid_5_delay_2;
  reg                 valid_5_delay_3;
  reg                 valid_5_delay_4;
  reg                 valid_5_delay_5;
  reg                 valid_6_delay_1;
  reg                 valid_6_delay_2;
  reg                 valid_6_delay_3;
  reg                 valid_6_delay_4;
  reg                 valid_6_delay_5;
  reg                 valid_6_delay_6;
  reg                 valid_7_delay_1;
  reg                 valid_7_delay_2;
  reg                 valid_7_delay_3;
  reg                 valid_7_delay_4;
  reg                 valid_7_delay_5;
  reg                 valid_7_delay_6;
  reg                 valid_7_delay_7;
  wire                when_GEMM_l316;
  `ifndef SYNTHESIS
  reg [63:0] fsm_currentState_string;
  reg [63:0] fsm_nextState_string;
  reg [39:0] rwfsm_currentState_string;
  reg [39:0] rwfsm_nextState_string;
  `endif


  assign _zz_colCnt_valid_1 = (WIDTH - 13'h0001);
  assign _zz_colCnt_valid = {3'd0, _zz_colCnt_valid_1};
  assign _zz_rAddrCnt_valid = (WIDTH - 13'h0001);
  assign _zz_totalCnt_valid = (_zz_totalCnt_valid_1 - 12'h001);
  assign _zz_totalCnt_valid_1 = (WEIGHTCOL / 4'b1000);
  assign _zz_OneColCnt_valid_1 = (_zz_OneColCnt_valid_2 - 13'h0001);
  assign _zz_OneColCnt_valid = {3'd0, _zz_OneColCnt_valid_1};
  assign _zz_OneColCnt_valid_2 = (WIDTH / 4'b1000);
  assign _zz_rowCnt_valid_1 = (HIGHT - 13'h0001);
  assign _zz_rowCnt_valid = {3'd0, _zz_rowCnt_valid_1};
  assign _zz_hangCnt_valid = {9'd0, _zz_hangCnt_count};
  assign _zz_hangCnt_count_1 = {9'd0, _zz_hangCnt_count};
  assign _zz_ena = InData_Switch[0 : 0];
  assign _zz_ena_1 = InData_Switch[0 : 0];
  assign _zz_ena_2 = InData_Switch[1 : 1];
  assign _zz_ena_3 = InData_Switch[1 : 1];
  assign _zz_ena_4 = InData_Switch[2 : 2];
  assign _zz_ena_5 = InData_Switch[2 : 2];
  assign _zz_ena_6 = InData_Switch[3 : 3];
  assign _zz_ena_7 = InData_Switch[3 : 3];
  assign _zz_ena_8 = InData_Switch[4 : 4];
  assign _zz_ena_9 = InData_Switch[4 : 4];
  assign _zz_ena_10 = InData_Switch[5 : 5];
  assign _zz_ena_11 = InData_Switch[5 : 5];
  assign _zz_ena_12 = InData_Switch[6 : 6];
  assign _zz_ena_13 = InData_Switch[6 : 6];
  assign _zz_ena_14 = InData_Switch[7 : 7];
  assign _zz_ena_15 = InData_Switch[7 : 7];
  A_Bram xil_SimpleDualBram (
    .clka  (clk                           ), //i
    .addra (xil_SimpleDualBram_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_ena        ), //i
    .wea   (xil_SimpleDualBram_wea        ), //i
    .addrb (xil_SimpleDualBram_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_doutb[7:0] ), //o
    .clkb  (clk                           )  //i
  );
  B_Bram xil_SimpleDualBram_1 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_1_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_1_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_1_ena        ), //i
    .wea   (xil_SimpleDualBram_1_wea        ), //i
    .addrb (xil_SimpleDualBram_1_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_1_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  A_Bram xil_SimpleDualBram_2 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_2_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_2_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_2_ena        ), //i
    .wea   (xil_SimpleDualBram_2_wea        ), //i
    .addrb (xil_SimpleDualBram_2_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_2_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  B_Bram xil_SimpleDualBram_3 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_3_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_3_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_3_ena        ), //i
    .wea   (xil_SimpleDualBram_3_wea        ), //i
    .addrb (xil_SimpleDualBram_3_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_3_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  A_Bram xil_SimpleDualBram_4 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_4_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_4_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_4_ena        ), //i
    .wea   (xil_SimpleDualBram_4_wea        ), //i
    .addrb (xil_SimpleDualBram_4_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_4_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  B_Bram xil_SimpleDualBram_5 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_5_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_5_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_5_ena        ), //i
    .wea   (xil_SimpleDualBram_5_wea        ), //i
    .addrb (xil_SimpleDualBram_5_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_5_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  A_Bram xil_SimpleDualBram_6 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_6_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_6_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_6_ena        ), //i
    .wea   (xil_SimpleDualBram_6_wea        ), //i
    .addrb (xil_SimpleDualBram_6_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_6_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  B_Bram xil_SimpleDualBram_7 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_7_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_7_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_7_ena        ), //i
    .wea   (xil_SimpleDualBram_7_wea        ), //i
    .addrb (xil_SimpleDualBram_7_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_7_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  A_Bram xil_SimpleDualBram_8 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_8_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_8_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_8_ena        ), //i
    .wea   (xil_SimpleDualBram_8_wea        ), //i
    .addrb (xil_SimpleDualBram_8_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_8_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  B_Bram xil_SimpleDualBram_9 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_9_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_9_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_9_ena        ), //i
    .wea   (xil_SimpleDualBram_9_wea        ), //i
    .addrb (xil_SimpleDualBram_9_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_9_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  A_Bram xil_SimpleDualBram_10 (
    .clka  (clk                              ), //i
    .addra (xil_SimpleDualBram_10_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_10_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_10_ena        ), //i
    .wea   (xil_SimpleDualBram_10_wea        ), //i
    .addrb (xil_SimpleDualBram_10_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_10_doutb[7:0] ), //o
    .clkb  (clk                              )  //i
  );
  B_Bram xil_SimpleDualBram_11 (
    .clka  (clk                              ), //i
    .addra (xil_SimpleDualBram_11_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_11_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_11_ena        ), //i
    .wea   (xil_SimpleDualBram_11_wea        ), //i
    .addrb (xil_SimpleDualBram_11_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_11_doutb[7:0] ), //o
    .clkb  (clk                              )  //i
  );
  A_Bram xil_SimpleDualBram_12 (
    .clka  (clk                              ), //i
    .addra (xil_SimpleDualBram_12_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_12_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_12_ena        ), //i
    .wea   (xil_SimpleDualBram_12_wea        ), //i
    .addrb (xil_SimpleDualBram_12_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_12_doutb[7:0] ), //o
    .clkb  (clk                              )  //i
  );
  B_Bram xil_SimpleDualBram_13 (
    .clka  (clk                              ), //i
    .addra (xil_SimpleDualBram_13_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_13_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_13_ena        ), //i
    .wea   (xil_SimpleDualBram_13_wea        ), //i
    .addrb (xil_SimpleDualBram_13_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_13_doutb[7:0] ), //o
    .clkb  (clk                              )  //i
  );
  A_Bram xil_SimpleDualBram_14 (
    .clka  (clk                              ), //i
    .addra (xil_SimpleDualBram_14_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_14_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_14_ena        ), //i
    .wea   (xil_SimpleDualBram_14_wea        ), //i
    .addrb (xil_SimpleDualBram_14_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_14_doutb[7:0] ), //o
    .clkb  (clk                              )  //i
  );
  B_Bram xil_SimpleDualBram_15 (
    .clka  (clk                              ), //i
    .addra (xil_SimpleDualBram_15_addra[9:0] ), //i
    .dina  (xil_SimpleDualBram_15_dina[63:0] ), //i
    .ena   (xil_SimpleDualBram_15_ena        ), //i
    .wea   (xil_SimpleDualBram_15_wea        ), //i
    .addrb (xil_SimpleDualBram_15_addrb[12:0]), //i
    .doutb (xil_SimpleDualBram_15_doutb[7:0] ), //o
    .clkb  (clk                              )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      GEMM_ENUM_IDLE : fsm_currentState_string = "IDLE    ";
      GEMM_ENUM_INIT : fsm_currentState_string = "INIT    ";
      GEMM_ENUM_WRITE : fsm_currentState_string = "WRITE   ";
      GEMM_ENUM_READ : fsm_currentState_string = "READ    ";
      GEMM_ENUM_CHECK : fsm_currentState_string = "CHECK   ";
      GEMM_ENUM_END_1 : fsm_currentState_string = "END_1   ";
      GEMM_ENUM_ENDOTHER : fsm_currentState_string = "ENDOTHER";
      GEMM_ENUM_ENDOUT : fsm_currentState_string = "ENDOUT  ";
      default : fsm_currentState_string = "????????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      GEMM_ENUM_IDLE : fsm_nextState_string = "IDLE    ";
      GEMM_ENUM_INIT : fsm_nextState_string = "INIT    ";
      GEMM_ENUM_WRITE : fsm_nextState_string = "WRITE   ";
      GEMM_ENUM_READ : fsm_nextState_string = "READ    ";
      GEMM_ENUM_CHECK : fsm_nextState_string = "CHECK   ";
      GEMM_ENUM_END_1 : fsm_nextState_string = "END_1   ";
      GEMM_ENUM_ENDOTHER : fsm_nextState_string = "ENDOTHER";
      GEMM_ENUM_ENDOUT : fsm_nextState_string = "ENDOUT  ";
      default : fsm_nextState_string = "????????";
    endcase
  end
  always @(*) begin
    case(rwfsm_currentState)
      RW_ENUM_IDLE : rwfsm_currentState_string = "IDLE ";
      RW_ENUM_WRITE : rwfsm_currentState_string = "WRITE";
      default : rwfsm_currentState_string = "?????";
    endcase
  end
  always @(*) begin
    case(rwfsm_nextState)
      RW_ENUM_IDLE : rwfsm_nextState_string = "IDLE ";
      RW_ENUM_WRITE : rwfsm_nextState_string = "WRITE";
      default : rwfsm_nextState_string = "?????";
    endcase
  end
  `endif

  always @(*) begin
    mData = 64'h0;
    mData[7 : 0] = mdata_temp[7 : 0];
    mData[15 : 8] = _zz_mData;
    mData[23 : 16] = _zz_mData_2;
    mData[31 : 24] = _zz_mData_5;
    mData[39 : 32] = _zz_mData_9;
    mData[47 : 40] = _zz_mData_14;
    mData[55 : 48] = _zz_mData_20;
    mData[63 : 56] = _zz_mData_27;
  end

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & GEMM_ENUM_IDLE) == GEMM_ENUM_IDLE) : begin
        if(start) begin
          fsm_nextState = GEMM_ENUM_INIT;
        end else begin
          fsm_nextState = GEMM_ENUM_IDLE;
        end
      end
      (((fsm_currentState) & GEMM_ENUM_INIT) == GEMM_ENUM_INIT) : begin
        if(fsm_initEnd) begin
          fsm_nextState = GEMM_ENUM_WRITE;
        end else begin
          fsm_nextState = GEMM_ENUM_INIT;
        end
      end
      (((fsm_currentState) & GEMM_ENUM_WRITE) == GEMM_ENUM_WRITE) : begin
        if(fsm_writeEnd) begin
          fsm_nextState = GEMM_ENUM_READ;
        end else begin
          fsm_nextState = GEMM_ENUM_WRITE;
        end
      end
      (((fsm_currentState) & GEMM_ENUM_READ) == GEMM_ENUM_READ) : begin
        if(fsm_dataEnd) begin
          fsm_nextState = GEMM_ENUM_END_1;
        end else begin
          if(fsm_judge) begin
            fsm_nextState = GEMM_ENUM_CHECK;
          end else begin
            fsm_nextState = GEMM_ENUM_READ;
          end
        end
      end
      (((fsm_currentState) & GEMM_ENUM_CHECK) == GEMM_ENUM_CHECK) : begin
        if(fsm_otherWrite) begin
          fsm_nextState = GEMM_ENUM_READ;
        end else begin
          if(fsm_dataEnd) begin
            fsm_nextState = GEMM_ENUM_ENDOTHER;
          end else begin
            fsm_nextState = GEMM_ENUM_CHECK;
          end
        end
      end
      (((fsm_currentState) & GEMM_ENUM_ENDOTHER) == GEMM_ENUM_ENDOTHER) : begin
        if(fsm_end) begin
          fsm_nextState = GEMM_ENUM_ENDOUT;
        end else begin
          fsm_nextState = GEMM_ENUM_ENDOTHER;
        end
      end
      (((fsm_currentState) & GEMM_ENUM_END_1) == GEMM_ENUM_END_1) : begin
        if(fsm_end) begin
          fsm_nextState = GEMM_ENUM_ENDOUT;
        end else begin
          fsm_nextState = GEMM_ENUM_END_1;
        end
      end
      default : begin
        if(fsm_readFinish) begin
          fsm_nextState = GEMM_ENUM_IDLE;
        end else begin
          fsm_nextState = GEMM_ENUM_ENDOUT;
        end
      end
    endcase
  end

  assign when_GEMM_l45 = (((((! Switch) && Switch_regNext) || (Switch && (! Switch_regNext_1))) && ((fsm_currentState & GEMM_ENUM_IDLE) == 8'b00000000)) && ((fsm_currentState & GEMM_ENUM_ENDOUT) == 8'b00000000));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((rwfsm_currentState) & RW_ENUM_WRITE) == RW_ENUM_WRITE) : begin
        if(rwfsm_writeEnd) begin
          rwfsm_nextState = RW_ENUM_IDLE;
        end else begin
          rwfsm_nextState = RW_ENUM_WRITE;
        end
      end
      default : begin
        if(when_GEMM_l45) begin
          rwfsm_nextState = RW_ENUM_WRITE;
        end else begin
          rwfsm_nextState = RW_ENUM_IDLE;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((fsm_currentState & GEMM_ENUM_INIT) != 8'b00000000);
  assign initCount_valid = ((initCount_count == 3'b101) && when_WaCounter_l40);
  assign sData_fire = (sData_valid && sData_ready);
  always @(*) begin
    colCnt_valid = ((colCnt_count == _zz_colCnt_valid) && sData_fire);
    if(rowCnt_valid) begin
      colCnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l40_1 = (((((fsm_currentState & GEMM_ENUM_READ) != 8'b00000000) || ((fsm_currentState & GEMM_ENUM_END_1) != 8'b00000000)) || ((fsm_currentState & GEMM_ENUM_ENDOUT) != 8'b00000000)) || ((fsm_currentState & GEMM_ENUM_ENDOTHER) != 8'b00000000));
  assign rAddrCnt_valid = ((rAddrCnt_count == _zz_rAddrCnt_valid) && when_WaCounter_l40_1);
  assign totalCnt_valid = ((totalCnt_count == _zz_totalCnt_valid) && rAddrCnt_valid);
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign OneColCnt_valid = ((OneColCnt_count == _zz_OneColCnt_valid) && sData_fire_1);
  assign rowCnt_valid = ((rowCnt_count == _zz_rowCnt_valid) && OneColCnt_valid);
  assign _zz_hangCnt_count = 4'b1000;
  always @(*) begin
    hangCnt_valid = ((hangCnt_count <= _zz_hangCnt_valid) && colCnt_valid);
    if(start) begin
      hangCnt_valid = 1'b0;
    end
  end

  assign when_GEMM_l188 = (totalCnt_valid && ((fsm_currentState & GEMM_ENUM_ENDOUT) != 8'b00000000));
  always @(*) begin
    if(when_GEMM_l188) begin
      finish = 1'b1;
    end else begin
      finish = 1'b0;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign fsm_writeEnd = (colCnt_valid || rowCnt_valid);
  assign fsm_judge = (totalCnt_valid && ((rwfsm_currentState & RW_ENUM_WRITE) != 2'b00));
  assign fsm_dataEnd = rowCnt_valid;
  assign rwfsm_writeEnd = (colCnt_valid || rowCnt_valid);
  assign fsm_end = (totalCnt_valid && (((fsm_currentState & GEMM_ENUM_END_1) != 8'b00000000) || ((fsm_currentState & GEMM_ENUM_ENDOTHER) != 8'b00000000)));
  assign fsm_readFinish = finish;
  assign fsm_otherWrite = colCnt_valid;
  assign LayerEnd = finish_regNext;
  assign writeend = (((fsm_currentState & GEMM_ENUM_WRITE) != 8'b00000000) && ((fsm_nextState & GEMM_ENUM_READ) != 8'b00000000));
  assign sData_fire_2 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_addra = 10'h0;
    if(when_GEMM_l254) begin
      xil_SimpleDualBram_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_dina = 64'h0;
    if(when_GEMM_l254) begin
      xil_SimpleDualBram_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_ena = 1'b0;
    if(when_GEMM_l254) begin
      xil_SimpleDualBram_ena = (_zz_ena[0] && sData_fire_3);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_wea = 1'b1;
    if(when_GEMM_l254) begin
      xil_SimpleDualBram_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_addrb = 13'h0;
    if(when_GEMM_l254) begin
      xil_SimpleDualBram_1_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_addra = 10'h0;
    if(!when_GEMM_l254) begin
      xil_SimpleDualBram_1_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_dina = 64'h0;
    if(!when_GEMM_l254) begin
      xil_SimpleDualBram_1_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_ena = 1'b0;
    if(!when_GEMM_l254) begin
      xil_SimpleDualBram_1_ena = (_zz_ena_1[0] && sData_fire_4);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_wea = 1'b1;
    if(!when_GEMM_l254) begin
      xil_SimpleDualBram_1_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_addrb = 13'h0;
    if(!when_GEMM_l254) begin
      xil_SimpleDualBram_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254 = (Switch == 1'b0);
  assign sData_fire_3 = (sData_valid && sData_ready);
  always @(*) begin
    if(when_GEMM_l254) begin
      mdata_temp[7 : 0] = xil_SimpleDualBram_1_doutb;
    end else begin
      mdata_temp[7 : 0] = xil_SimpleDualBram_doutb;
    end
    if(when_GEMM_l254_1) begin
      mdata_temp[15 : 8] = xil_SimpleDualBram_3_doutb;
    end else begin
      mdata_temp[15 : 8] = xil_SimpleDualBram_2_doutb;
    end
    if(when_GEMM_l254_2) begin
      mdata_temp[23 : 16] = xil_SimpleDualBram_5_doutb;
    end else begin
      mdata_temp[23 : 16] = xil_SimpleDualBram_4_doutb;
    end
    if(when_GEMM_l254_3) begin
      mdata_temp[31 : 24] = xil_SimpleDualBram_7_doutb;
    end else begin
      mdata_temp[31 : 24] = xil_SimpleDualBram_6_doutb;
    end
    if(when_GEMM_l254_4) begin
      mdata_temp[39 : 32] = xil_SimpleDualBram_9_doutb;
    end else begin
      mdata_temp[39 : 32] = xil_SimpleDualBram_8_doutb;
    end
    if(when_GEMM_l254_5) begin
      mdata_temp[47 : 40] = xil_SimpleDualBram_11_doutb;
    end else begin
      mdata_temp[47 : 40] = xil_SimpleDualBram_10_doutb;
    end
    if(when_GEMM_l254_6) begin
      mdata_temp[55 : 48] = xil_SimpleDualBram_13_doutb;
    end else begin
      mdata_temp[55 : 48] = xil_SimpleDualBram_12_doutb;
    end
    if(when_GEMM_l254_7) begin
      mdata_temp[63 : 56] = xil_SimpleDualBram_15_doutb;
    end else begin
      mdata_temp[63 : 56] = xil_SimpleDualBram_14_doutb;
    end
  end

  assign sData_fire_4 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_2_addra = 10'h0;
    if(when_GEMM_l254_1) begin
      xil_SimpleDualBram_2_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_dina = 64'h0;
    if(when_GEMM_l254_1) begin
      xil_SimpleDualBram_2_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_ena = 1'b0;
    if(when_GEMM_l254_1) begin
      xil_SimpleDualBram_2_ena = (_zz_ena_2[0] && sData_fire_5);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_wea = 1'b1;
    if(when_GEMM_l254_1) begin
      xil_SimpleDualBram_2_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_addrb = 13'h0;
    if(when_GEMM_l254_1) begin
      xil_SimpleDualBram_3_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_addra = 10'h0;
    if(!when_GEMM_l254_1) begin
      xil_SimpleDualBram_3_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_dina = 64'h0;
    if(!when_GEMM_l254_1) begin
      xil_SimpleDualBram_3_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_ena = 1'b0;
    if(!when_GEMM_l254_1) begin
      xil_SimpleDualBram_3_ena = (_zz_ena_3[0] && sData_fire_6);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_wea = 1'b1;
    if(!when_GEMM_l254_1) begin
      xil_SimpleDualBram_3_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_addrb = 13'h0;
    if(!when_GEMM_l254_1) begin
      xil_SimpleDualBram_2_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_1 = (Switch == 1'b0);
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign sData_fire_6 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_4_addra = 10'h0;
    if(when_GEMM_l254_2) begin
      xil_SimpleDualBram_4_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_dina = 64'h0;
    if(when_GEMM_l254_2) begin
      xil_SimpleDualBram_4_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_ena = 1'b0;
    if(when_GEMM_l254_2) begin
      xil_SimpleDualBram_4_ena = (_zz_ena_4[0] && sData_fire_7);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_wea = 1'b1;
    if(when_GEMM_l254_2) begin
      xil_SimpleDualBram_4_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_addrb = 13'h0;
    if(when_GEMM_l254_2) begin
      xil_SimpleDualBram_5_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_addra = 10'h0;
    if(!when_GEMM_l254_2) begin
      xil_SimpleDualBram_5_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_dina = 64'h0;
    if(!when_GEMM_l254_2) begin
      xil_SimpleDualBram_5_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_ena = 1'b0;
    if(!when_GEMM_l254_2) begin
      xil_SimpleDualBram_5_ena = (_zz_ena_5[0] && sData_fire_8);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_wea = 1'b1;
    if(!when_GEMM_l254_2) begin
      xil_SimpleDualBram_5_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_addrb = 13'h0;
    if(!when_GEMM_l254_2) begin
      xil_SimpleDualBram_4_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_2 = (Switch == 1'b0);
  assign sData_fire_7 = (sData_valid && sData_ready);
  assign sData_fire_8 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_6_addra = 10'h0;
    if(when_GEMM_l254_3) begin
      xil_SimpleDualBram_6_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_dina = 64'h0;
    if(when_GEMM_l254_3) begin
      xil_SimpleDualBram_6_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_ena = 1'b0;
    if(when_GEMM_l254_3) begin
      xil_SimpleDualBram_6_ena = (_zz_ena_6[0] && sData_fire_9);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_wea = 1'b1;
    if(when_GEMM_l254_3) begin
      xil_SimpleDualBram_6_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_addrb = 13'h0;
    if(when_GEMM_l254_3) begin
      xil_SimpleDualBram_7_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_addra = 10'h0;
    if(!when_GEMM_l254_3) begin
      xil_SimpleDualBram_7_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_dina = 64'h0;
    if(!when_GEMM_l254_3) begin
      xil_SimpleDualBram_7_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_ena = 1'b0;
    if(!when_GEMM_l254_3) begin
      xil_SimpleDualBram_7_ena = (_zz_ena_7[0] && sData_fire_10);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_wea = 1'b1;
    if(!when_GEMM_l254_3) begin
      xil_SimpleDualBram_7_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_addrb = 13'h0;
    if(!when_GEMM_l254_3) begin
      xil_SimpleDualBram_6_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_3 = (Switch == 1'b0);
  assign sData_fire_9 = (sData_valid && sData_ready);
  assign sData_fire_10 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_8_addra = 10'h0;
    if(when_GEMM_l254_4) begin
      xil_SimpleDualBram_8_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_dina = 64'h0;
    if(when_GEMM_l254_4) begin
      xil_SimpleDualBram_8_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_ena = 1'b0;
    if(when_GEMM_l254_4) begin
      xil_SimpleDualBram_8_ena = (_zz_ena_8[0] && sData_fire_11);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_wea = 1'b1;
    if(when_GEMM_l254_4) begin
      xil_SimpleDualBram_8_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_addrb = 13'h0;
    if(when_GEMM_l254_4) begin
      xil_SimpleDualBram_9_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_addra = 10'h0;
    if(!when_GEMM_l254_4) begin
      xil_SimpleDualBram_9_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_dina = 64'h0;
    if(!when_GEMM_l254_4) begin
      xil_SimpleDualBram_9_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_ena = 1'b0;
    if(!when_GEMM_l254_4) begin
      xil_SimpleDualBram_9_ena = (_zz_ena_9[0] && sData_fire_12);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_wea = 1'b1;
    if(!when_GEMM_l254_4) begin
      xil_SimpleDualBram_9_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_addrb = 13'h0;
    if(!when_GEMM_l254_4) begin
      xil_SimpleDualBram_8_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_4 = (Switch == 1'b0);
  assign sData_fire_11 = (sData_valid && sData_ready);
  assign sData_fire_12 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_10_addra = 10'h0;
    if(when_GEMM_l254_5) begin
      xil_SimpleDualBram_10_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_dina = 64'h0;
    if(when_GEMM_l254_5) begin
      xil_SimpleDualBram_10_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_ena = 1'b0;
    if(when_GEMM_l254_5) begin
      xil_SimpleDualBram_10_ena = (_zz_ena_10[0] && sData_fire_13);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_wea = 1'b1;
    if(when_GEMM_l254_5) begin
      xil_SimpleDualBram_10_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_addrb = 13'h0;
    if(when_GEMM_l254_5) begin
      xil_SimpleDualBram_11_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_addra = 10'h0;
    if(!when_GEMM_l254_5) begin
      xil_SimpleDualBram_11_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_dina = 64'h0;
    if(!when_GEMM_l254_5) begin
      xil_SimpleDualBram_11_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_ena = 1'b0;
    if(!when_GEMM_l254_5) begin
      xil_SimpleDualBram_11_ena = (_zz_ena_11[0] && sData_fire_14);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_wea = 1'b1;
    if(!when_GEMM_l254_5) begin
      xil_SimpleDualBram_11_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_addrb = 13'h0;
    if(!when_GEMM_l254_5) begin
      xil_SimpleDualBram_10_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_5 = (Switch == 1'b0);
  assign sData_fire_13 = (sData_valid && sData_ready);
  assign sData_fire_14 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_12_addra = 10'h0;
    if(when_GEMM_l254_6) begin
      xil_SimpleDualBram_12_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_dina = 64'h0;
    if(when_GEMM_l254_6) begin
      xil_SimpleDualBram_12_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_ena = 1'b0;
    if(when_GEMM_l254_6) begin
      xil_SimpleDualBram_12_ena = (_zz_ena_12[0] && sData_fire_15);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_wea = 1'b1;
    if(when_GEMM_l254_6) begin
      xil_SimpleDualBram_12_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_addrb = 13'h0;
    if(when_GEMM_l254_6) begin
      xil_SimpleDualBram_13_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_addra = 10'h0;
    if(!when_GEMM_l254_6) begin
      xil_SimpleDualBram_13_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_dina = 64'h0;
    if(!when_GEMM_l254_6) begin
      xil_SimpleDualBram_13_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_ena = 1'b0;
    if(!when_GEMM_l254_6) begin
      xil_SimpleDualBram_13_ena = (_zz_ena_13[0] && sData_fire_16);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_wea = 1'b1;
    if(!when_GEMM_l254_6) begin
      xil_SimpleDualBram_13_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_addrb = 13'h0;
    if(!when_GEMM_l254_6) begin
      xil_SimpleDualBram_12_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_6 = (Switch == 1'b0);
  assign sData_fire_15 = (sData_valid && sData_ready);
  assign sData_fire_16 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_14_addra = 10'h0;
    if(when_GEMM_l254_7) begin
      xil_SimpleDualBram_14_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_dina = 64'h0;
    if(when_GEMM_l254_7) begin
      xil_SimpleDualBram_14_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_ena = 1'b0;
    if(when_GEMM_l254_7) begin
      xil_SimpleDualBram_14_ena = (_zz_ena_14[0] && sData_fire_17);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_wea = 1'b1;
    if(when_GEMM_l254_7) begin
      xil_SimpleDualBram_14_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_addrb = 13'h0;
    if(when_GEMM_l254_7) begin
      xil_SimpleDualBram_15_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_addra = 10'h0;
    if(!when_GEMM_l254_7) begin
      xil_SimpleDualBram_15_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_dina = 64'h0;
    if(!when_GEMM_l254_7) begin
      xil_SimpleDualBram_15_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_ena = 1'b0;
    if(!when_GEMM_l254_7) begin
      xil_SimpleDualBram_15_ena = (_zz_ena_15[0] && sData_fire_18);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_wea = 1'b1;
    if(!when_GEMM_l254_7) begin
      xil_SimpleDualBram_15_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_addrb = 13'h0;
    if(!when_GEMM_l254_7) begin
      xil_SimpleDualBram_14_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l254_7 = (Switch == 1'b0);
  assign sData_fire_17 = (sData_valid && sData_ready);
  assign sData_fire_18 = (sData_valid && sData_ready);
  assign when_GEMM_l282 = (((fsm_currentState & GEMM_ENUM_END_1) != 8'b00000000) || ((fsm_currentState & GEMM_ENUM_ENDOUT) != 8'b00000000));
  always @(*) begin
    if(when_GEMM_l282) begin
      sData_ready = 1'b0;
    end else begin
      if(when_GEMM_l284) begin
        sData_ready = 1'b1;
      end else begin
        sData_ready = 1'b0;
      end
    end
  end

  assign when_GEMM_l284 = (((fsm_currentState & GEMM_ENUM_WRITE) != 8'b00000000) || ((rwfsm_currentState & RW_ENUM_WRITE) != 2'b00));
  always @(*) begin
    valid_0 = 1'b0;
    if(_zz_3) begin
      valid_0 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299) begin
        valid_0 = 1'b1;
      end else begin
        valid_0 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_1 = 1'b0;
    if(_zz_3) begin
      valid_1 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_1) begin
        valid_1 = 1'b1;
      end else begin
        valid_1 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_2 = 1'b0;
    if(_zz_3) begin
      valid_2 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_2) begin
        valid_2 = 1'b1;
      end else begin
        valid_2 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_3 = 1'b0;
    if(_zz_3) begin
      valid_3 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_3) begin
        valid_3 = 1'b1;
      end else begin
        valid_3 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_4 = 1'b0;
    if(_zz_3) begin
      valid_4 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_4) begin
        valid_4 = 1'b1;
      end else begin
        valid_4 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_5 = 1'b0;
    if(_zz_3) begin
      valid_5 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_5) begin
        valid_5 = 1'b1;
      end else begin
        valid_5 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_6 = 1'b0;
    if(_zz_3) begin
      valid_6 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_6) begin
        valid_6 = 1'b1;
      end else begin
        valid_6 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_7 = 1'b0;
    if(_zz_3) begin
      valid_7 = 1'b1;
    end
    if(_zz_4) begin
      if(when_GEMM_l299_7) begin
        valid_7 = 1'b1;
      end else begin
        valid_7 = 1'b0;
      end
    end
  end

  assign when_GEMM_l299 = (13'h0 < hangCnt_count);
  assign when_GEMM_l299_1 = (13'h0001 < hangCnt_count);
  assign when_GEMM_l299_2 = (13'h0002 < hangCnt_count);
  assign when_GEMM_l299_3 = (13'h0003 < hangCnt_count);
  assign when_GEMM_l299_4 = (13'h0004 < hangCnt_count);
  assign when_GEMM_l299_5 = (13'h0005 < hangCnt_count);
  assign when_GEMM_l299_6 = (13'h0006 < hangCnt_count);
  assign when_GEMM_l299_7 = (13'h0007 < hangCnt_count);
  assign validOut_0 = valid_0;
  assign validOut_1 = valid_1_delay_1;
  assign validOut_2 = valid_2_delay_2;
  assign validOut_3 = valid_3_delay_3;
  assign validOut_4 = valid_4_delay_4;
  assign validOut_5 = valid_5_delay_5;
  assign validOut_6 = valid_6_delay_6;
  assign validOut_7 = valid_7_delay_7;
  assign when_GEMM_l316 = ((((fsm_currentState & GEMM_ENUM_READ) != 8'b00000000) || ((fsm_currentState & GEMM_ENUM_END_1) != 8'b00000000)) || ((fsm_currentState & GEMM_ENUM_ENDOUT) != 8'b00000000));
  always @(*) begin
    if(when_GEMM_l316) begin
      bvalid = 1'b1;
    end else begin
      bvalid = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Switch <= 1'b0;
      fsm_currentState <= GEMM_ENUM_IDLE;
      rwfsm_currentState <= RW_ENUM_IDLE;
      initCount_count <= 3'b000;
      colCnt_count <= 16'h0;
      rAddrCnt_count <= 13'h0;
      totalCnt_count <= 12'h0;
      OneColCnt_count <= 16'h0;
      rowCnt_count <= 16'h0;
      Write_Row_Base_Addr <= 10'h0;
      InData_Switch <= 8'h01;
    end else begin
      fsm_currentState <= fsm_nextState;
      rwfsm_currentState <= rwfsm_nextState;
      if(when_WaCounter_l40) begin
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end else begin
          initCount_count <= (initCount_count + 3'b001);
        end
      end
      if(sData_fire) begin
        if(colCnt_valid) begin
          colCnt_count <= 16'h0;
        end else begin
          colCnt_count <= (colCnt_count + 16'h0001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(rAddrCnt_valid) begin
          rAddrCnt_count <= 13'h0;
        end else begin
          rAddrCnt_count <= (rAddrCnt_count + 13'h0001);
        end
      end
      if(rAddrCnt_valid) begin
        if(totalCnt_valid) begin
          totalCnt_count <= 12'h0;
        end else begin
          totalCnt_count <= (totalCnt_count + 12'h001);
        end
      end
      if(sData_fire_1) begin
        if(OneColCnt_valid) begin
          OneColCnt_count <= 16'h0;
        end else begin
          OneColCnt_count <= (OneColCnt_count + 16'h0001);
        end
      end
      if(OneColCnt_valid) begin
        if(rowCnt_valid) begin
          rowCnt_count <= 16'h0;
        end else begin
          rowCnt_count <= (rowCnt_count + 16'h0001);
        end
      end
      if(writeend_delay_1) begin
        Switch <= (! Switch);
      end else begin
        if(_zz_1) begin
          Switch <= (! Switch);
        end else begin
          if(_zz_2) begin
            Switch <= (! Switch);
          end
        end
      end
      if(sData_fire_2) begin
        Write_Row_Base_Addr <= (Write_Row_Base_Addr + 10'h001);
      end
      if(OneColCnt_valid) begin
        InData_Switch <= {InData_Switch[6 : 0],InData_Switch[7 : 7]};
        Write_Row_Base_Addr <= 10'h0;
      end
      if(rowCnt_valid) begin
        InData_Switch <= 8'h01;
        colCnt_count <= 16'h0;
      end
    end
  end

  always @(posedge clk) begin
    Switch_regNext <= Switch;
    Switch_regNext_1 <= Switch;
    if(colCnt_valid) begin
      if(hangCnt_valid) begin
        hangCnt_count <= HIGHT;
      end else begin
        hangCnt_count <= (hangCnt_count - _zz_hangCnt_count_1);
      end
    end
    if(start) begin
      hangCnt_count <= HIGHT;
    end
    finish_regNext <= finish;
    writeend_delay_1 <= writeend;
    _zz_1 <= (totalCnt_valid && ((rwfsm_currentState & RW_ENUM_IDLE) != 2'b00));
    _zz_2 <= (colCnt_valid && ((fsm_currentState & GEMM_ENUM_CHECK) != 8'b00000000));
    _zz_mData <= mdata_temp[15 : 8];
    _zz_mData_1 <= mdata_temp[23 : 16];
    _zz_mData_2 <= _zz_mData_1;
    _zz_mData_3 <= mdata_temp[31 : 24];
    _zz_mData_4 <= _zz_mData_3;
    _zz_mData_5 <= _zz_mData_4;
    _zz_mData_6 <= mdata_temp[39 : 32];
    _zz_mData_7 <= _zz_mData_6;
    _zz_mData_8 <= _zz_mData_7;
    _zz_mData_9 <= _zz_mData_8;
    _zz_mData_10 <= mdata_temp[47 : 40];
    _zz_mData_11 <= _zz_mData_10;
    _zz_mData_12 <= _zz_mData_11;
    _zz_mData_13 <= _zz_mData_12;
    _zz_mData_14 <= _zz_mData_13;
    _zz_mData_15 <= mdata_temp[55 : 48];
    _zz_mData_16 <= _zz_mData_15;
    _zz_mData_17 <= _zz_mData_16;
    _zz_mData_18 <= _zz_mData_17;
    _zz_mData_19 <= _zz_mData_18;
    _zz_mData_20 <= _zz_mData_19;
    _zz_mData_21 <= mdata_temp[63 : 56];
    _zz_mData_22 <= _zz_mData_21;
    _zz_mData_23 <= _zz_mData_22;
    _zz_mData_24 <= _zz_mData_23;
    _zz_mData_25 <= _zz_mData_24;
    _zz_mData_26 <= _zz_mData_25;
    _zz_mData_27 <= _zz_mData_26;
    _zz_3 <= (((fsm_currentState & GEMM_ENUM_READ) != 8'b00000000) || ((fsm_currentState & GEMM_ENUM_END_1) != 8'b00000000));
    _zz_4 <= ((fsm_currentState & GEMM_ENUM_ENDOUT) != 8'b00000000);
    valid_1_delay_1 <= valid_1;
    valid_2_delay_1 <= valid_2;
    valid_2_delay_2 <= valid_2_delay_1;
    valid_3_delay_1 <= valid_3;
    valid_3_delay_2 <= valid_3_delay_1;
    valid_3_delay_3 <= valid_3_delay_2;
    valid_4_delay_1 <= valid_4;
    valid_4_delay_2 <= valid_4_delay_1;
    valid_4_delay_3 <= valid_4_delay_2;
    valid_4_delay_4 <= valid_4_delay_3;
    valid_5_delay_1 <= valid_5;
    valid_5_delay_2 <= valid_5_delay_1;
    valid_5_delay_3 <= valid_5_delay_2;
    valid_5_delay_4 <= valid_5_delay_3;
    valid_5_delay_5 <= valid_5_delay_4;
    valid_6_delay_1 <= valid_6;
    valid_6_delay_2 <= valid_6_delay_1;
    valid_6_delay_3 <= valid_6_delay_2;
    valid_6_delay_4 <= valid_6_delay_3;
    valid_6_delay_5 <= valid_6_delay_4;
    valid_6_delay_6 <= valid_6_delay_5;
    valid_7_delay_1 <= valid_7;
    valid_7_delay_2 <= valid_7_delay_1;
    valid_7_delay_3 <= valid_7_delay_2;
    valid_7_delay_4 <= valid_7_delay_3;
    valid_7_delay_5 <= valid_7_delay_4;
    valid_7_delay_6 <= valid_7_delay_5;
    valid_7_delay_7 <= valid_7_delay_6;
  end


endmodule

module ConvArrangeV3 (
  input      [7:0]    sData_0,
  input      [7:0]    sData_1,
  input      [7:0]    sData_2,
  input      [7:0]    sData_3,
  input      [7:0]    sData_4,
  input      [7:0]    sData_5,
  input      [7:0]    sData_6,
  input      [7:0]    sData_7,
  output              sReady,
  input      [7:0]    sValid,
  input      [11:0]   MatrixCol,
  input      [19:0]   MatrixRow,
  input      [9:0]    OutChannel,
  input      [15:0]   OutFeatureSize,
  output reg          mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  output              mLast,
  output              LayerEnd,
  input               start,
  input               SwitchConv,
  input               clk,
  input               reset
);
  localparam CONVOUTPUT_ENUM_IDLE = 4'd1;
  localparam CONVOUTPUT_ENUM_INIT = 4'd2;
  localparam CONVOUTPUT_ENUM_DATA_ARRANGEMENT = 4'd4;
  localparam CONVOUTPUT_ENUM_WAIT_END = 4'd8;

  wire                ConvCtrl_ResetCnt;
  wire                ConvCtrl_InData_Cnt_En;
  wire                ConvCtrl_OutData_Cnt_En;
  wire                GemmCtrl_ResetCnt;
  wire                GemmCtrl_InData_Cnt_En;
  wire                GemmCtrl_OutData_Cnt_En;
  reg                 streamFifo_io_pop_ready;
  wire                axisDataConverter_8_inStream_valid;
  reg                 streamFifo_1_io_pop_ready;
  wire                axisDataConverter_9_inStream_valid;
  reg                 streamFifo_2_io_pop_ready;
  wire                axisDataConverter_10_inStream_valid;
  reg                 streamFifo_3_io_pop_ready;
  wire                axisDataConverter_11_inStream_valid;
  reg                 streamFifo_4_io_pop_ready;
  wire                axisDataConverter_12_inStream_valid;
  reg                 streamFifo_5_io_pop_ready;
  wire                axisDataConverter_13_inStream_valid;
  reg                 streamFifo_6_io_pop_ready;
  wire                axisDataConverter_14_inStream_valid;
  reg                 streamFifo_7_io_pop_ready;
  wire                axisDataConverter_15_inStream_valid;
  wire                ConvCtrl_Fsm_LayerEnd;
  wire                ConvCtrl_Fsm_Data_AllOut;
  wire                ConvCtrl_OutSwitch_Rotate;
  wire                ConvCtrl_OutSwitch_Reset;
  wire                GemmCtrl_Fsm_LayerEnd;
  wire                GemmCtrl_Fsm_Data_AllOut;
  wire                GemmCtrl_OutSwitch_Rotate;
  wire                streamFifo_io_push_ready;
  wire                streamFifo_io_pop_valid;
  wire       [63:0]   streamFifo_io_pop_payload;
  wire       [9:0]    streamFifo_io_occupancy;
  wire       [9:0]    streamFifo_io_availability;
  wire                axisDataConverter_8_inStream_ready;
  wire                axisDataConverter_8_outStream_valid;
  wire       [63:0]   axisDataConverter_8_outStream_payload;
  wire                streamFifo_1_io_push_ready;
  wire                streamFifo_1_io_pop_valid;
  wire       [63:0]   streamFifo_1_io_pop_payload;
  wire       [9:0]    streamFifo_1_io_occupancy;
  wire       [9:0]    streamFifo_1_io_availability;
  wire                axisDataConverter_9_inStream_ready;
  wire                axisDataConverter_9_outStream_valid;
  wire       [63:0]   axisDataConverter_9_outStream_payload;
  wire                streamFifo_2_io_push_ready;
  wire                streamFifo_2_io_pop_valid;
  wire       [63:0]   streamFifo_2_io_pop_payload;
  wire       [9:0]    streamFifo_2_io_occupancy;
  wire       [9:0]    streamFifo_2_io_availability;
  wire                axisDataConverter_10_inStream_ready;
  wire                axisDataConverter_10_outStream_valid;
  wire       [63:0]   axisDataConverter_10_outStream_payload;
  wire                streamFifo_3_io_push_ready;
  wire                streamFifo_3_io_pop_valid;
  wire       [63:0]   streamFifo_3_io_pop_payload;
  wire       [9:0]    streamFifo_3_io_occupancy;
  wire       [9:0]    streamFifo_3_io_availability;
  wire                axisDataConverter_11_inStream_ready;
  wire                axisDataConverter_11_outStream_valid;
  wire       [63:0]   axisDataConverter_11_outStream_payload;
  wire                streamFifo_4_io_push_ready;
  wire                streamFifo_4_io_pop_valid;
  wire       [63:0]   streamFifo_4_io_pop_payload;
  wire       [9:0]    streamFifo_4_io_occupancy;
  wire       [9:0]    streamFifo_4_io_availability;
  wire                axisDataConverter_12_inStream_ready;
  wire                axisDataConverter_12_outStream_valid;
  wire       [63:0]   axisDataConverter_12_outStream_payload;
  wire                streamFifo_5_io_push_ready;
  wire                streamFifo_5_io_pop_valid;
  wire       [63:0]   streamFifo_5_io_pop_payload;
  wire       [9:0]    streamFifo_5_io_occupancy;
  wire       [9:0]    streamFifo_5_io_availability;
  wire                axisDataConverter_13_inStream_ready;
  wire                axisDataConverter_13_outStream_valid;
  wire       [63:0]   axisDataConverter_13_outStream_payload;
  wire                streamFifo_6_io_push_ready;
  wire                streamFifo_6_io_pop_valid;
  wire       [63:0]   streamFifo_6_io_pop_payload;
  wire       [9:0]    streamFifo_6_io_occupancy;
  wire       [9:0]    streamFifo_6_io_availability;
  wire                axisDataConverter_14_inStream_ready;
  wire                axisDataConverter_14_outStream_valid;
  wire       [63:0]   axisDataConverter_14_outStream_payload;
  wire                streamFifo_7_io_push_ready;
  wire                streamFifo_7_io_pop_valid;
  wire       [63:0]   streamFifo_7_io_pop_payload;
  wire       [9:0]    streamFifo_7_io_occupancy;
  wire       [9:0]    streamFifo_7_io_availability;
  wire                axisDataConverter_15_inStream_ready;
  wire                axisDataConverter_15_outStream_valid;
  wire       [63:0]   axisDataConverter_15_outStream_payload;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_1;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_2;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_3;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_4;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_5;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_6;
  wire       [0:0]    _zz_when_SA3D_DataArrange_l131_7;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_Inited;
  wire                Fsm_LayerEnd;
  wire                Fsm_Data_AllOut;
  wire                mData_fire;
  wire                mData_fire_1;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Cnt_count;
  wire                Init_Cnt_valid;
  reg        [7:0]    OutSwitch;
  wire                when_SA3D_DataArrange_l108;
  wire                when_SA3D_DataArrange_l112;
  wire                when_SA3D_DataArrange_l131;
  wire                when_SA3D_DataArrange_l131_1;
  wire                when_SA3D_DataArrange_l131_2;
  wire                when_SA3D_DataArrange_l131_3;
  wire                when_SA3D_DataArrange_l131_4;
  wire                when_SA3D_DataArrange_l131_5;
  wire                when_SA3D_DataArrange_l131_6;
  wire                when_SA3D_DataArrange_l131_7;
  `ifndef SYNTHESIS
  reg [127:0] Fsm_currentState_string;
  reg [127:0] Fsm_nextState_string;
  `endif


  assign _zz_when_SA3D_DataArrange_l131 = OutSwitch[0 : 0];
  assign _zz_when_SA3D_DataArrange_l131_1 = OutSwitch[1 : 1];
  assign _zz_when_SA3D_DataArrange_l131_2 = OutSwitch[2 : 2];
  assign _zz_when_SA3D_DataArrange_l131_3 = OutSwitch[3 : 3];
  assign _zz_when_SA3D_DataArrange_l131_4 = OutSwitch[4 : 4];
  assign _zz_when_SA3D_DataArrange_l131_5 = OutSwitch[5 : 5];
  assign _zz_when_SA3D_DataArrange_l131_6 = OutSwitch[6 : 6];
  assign _zz_when_SA3D_DataArrange_l131_7 = OutSwitch[7 : 7];
  ConvOutput_Ctrl ConvCtrl (
    .ResetCnt         (ConvCtrl_ResetCnt        ), //i
    .InData_Cnt_En    (ConvCtrl_InData_Cnt_En   ), //i
    .OutData_Cnt_En   (ConvCtrl_OutData_Cnt_En  ), //i
    .OutChannel       (OutChannel[9:0]          ), //i
    .OutFeatureSize   (OutFeatureSize[15:0]     ), //i
    .Fsm_LayerEnd     (ConvCtrl_Fsm_LayerEnd    ), //o
    .Fsm_Data_AllOut  (ConvCtrl_Fsm_Data_AllOut ), //o
    .OutSwitch_Rotate (ConvCtrl_OutSwitch_Rotate), //o
    .OutSwitch_Reset  (ConvCtrl_OutSwitch_Reset ), //o
    .clk              (clk                      ), //i
    .reset            (reset                    )  //i
  );
  GemmOutput_Ctrl GemmCtrl (
    .ResetCnt         (GemmCtrl_ResetCnt        ), //i
    .InData_Cnt_En    (GemmCtrl_InData_Cnt_En   ), //i
    .OutData_Cnt_En   (GemmCtrl_OutData_Cnt_En  ), //i
    .MatrixCol        (MatrixCol[11:0]          ), //i
    .MatrixRow        (MatrixRow[19:0]          ), //i
    .Fsm_LayerEnd     (GemmCtrl_Fsm_LayerEnd    ), //o
    .Fsm_Data_AllOut  (GemmCtrl_Fsm_Data_AllOut ), //o
    .OutSwitch_Rotate (GemmCtrl_OutSwitch_Rotate), //o
    .clk              (clk                      ), //i
    .reset            (reset                    )  //i
  );
  ConvOutput_Fifo streamFifo (
    .io_push_valid   (axisDataConverter_8_outStream_valid        ), //i
    .io_push_ready   (streamFifo_io_push_ready                   ), //o
    .io_push_payload (axisDataConverter_8_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_io_pop_valid                    ), //o
    .io_pop_ready    (streamFifo_io_pop_ready                    ), //i
    .io_pop_payload  (streamFifo_io_pop_payload[63:0]            ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_io_occupancy[9:0]               ), //o
    .io_availability (streamFifo_io_availability[9:0]            ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_8 (
    .inStream_valid    (axisDataConverter_8_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_8_inStream_ready         ), //o
    .inStream_payload  (sData_0[7:0]                               ), //i
    .outStream_valid   (axisDataConverter_8_outStream_valid        ), //o
    .outStream_ready   (streamFifo_io_push_ready                   ), //i
    .outStream_payload (axisDataConverter_8_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  ConvOutput_Fifo streamFifo_1 (
    .io_push_valid   (axisDataConverter_9_outStream_valid        ), //i
    .io_push_ready   (streamFifo_1_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_9_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_1_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_1_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_1_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_1_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_1_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_9 (
    .inStream_valid    (axisDataConverter_9_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_9_inStream_ready         ), //o
    .inStream_payload  (sData_1[7:0]                               ), //i
    .outStream_valid   (axisDataConverter_9_outStream_valid        ), //o
    .outStream_ready   (streamFifo_1_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_9_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  ConvOutput_Fifo streamFifo_2 (
    .io_push_valid   (axisDataConverter_10_outStream_valid        ), //i
    .io_push_ready   (streamFifo_2_io_push_ready                  ), //o
    .io_push_payload (axisDataConverter_10_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_2_io_pop_valid                   ), //o
    .io_pop_ready    (streamFifo_2_io_pop_ready                   ), //i
    .io_pop_payload  (streamFifo_2_io_pop_payload[63:0]           ), //o
    .io_flush        (1'b0                                        ), //i
    .io_occupancy    (streamFifo_2_io_occupancy[9:0]              ), //o
    .io_availability (streamFifo_2_io_availability[9:0]           ), //o
    .clk             (clk                                         ), //i
    .reset           (reset                                       )  //i
  );
  ConvOutput_Converter axisDataConverter_10 (
    .inStream_valid    (axisDataConverter_10_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_10_inStream_ready         ), //o
    .inStream_payload  (sData_2[7:0]                                ), //i
    .outStream_valid   (axisDataConverter_10_outStream_valid        ), //o
    .outStream_ready   (streamFifo_2_io_push_ready                  ), //i
    .outStream_payload (axisDataConverter_10_outStream_payload[63:0]), //o
    .clk               (clk                                         ), //i
    .reset             (reset                                       )  //i
  );
  ConvOutput_Fifo streamFifo_3 (
    .io_push_valid   (axisDataConverter_11_outStream_valid        ), //i
    .io_push_ready   (streamFifo_3_io_push_ready                  ), //o
    .io_push_payload (axisDataConverter_11_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_3_io_pop_valid                   ), //o
    .io_pop_ready    (streamFifo_3_io_pop_ready                   ), //i
    .io_pop_payload  (streamFifo_3_io_pop_payload[63:0]           ), //o
    .io_flush        (1'b0                                        ), //i
    .io_occupancy    (streamFifo_3_io_occupancy[9:0]              ), //o
    .io_availability (streamFifo_3_io_availability[9:0]           ), //o
    .clk             (clk                                         ), //i
    .reset           (reset                                       )  //i
  );
  ConvOutput_Converter axisDataConverter_11 (
    .inStream_valid    (axisDataConverter_11_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_11_inStream_ready         ), //o
    .inStream_payload  (sData_3[7:0]                                ), //i
    .outStream_valid   (axisDataConverter_11_outStream_valid        ), //o
    .outStream_ready   (streamFifo_3_io_push_ready                  ), //i
    .outStream_payload (axisDataConverter_11_outStream_payload[63:0]), //o
    .clk               (clk                                         ), //i
    .reset             (reset                                       )  //i
  );
  ConvOutput_Fifo streamFifo_4 (
    .io_push_valid   (axisDataConverter_12_outStream_valid        ), //i
    .io_push_ready   (streamFifo_4_io_push_ready                  ), //o
    .io_push_payload (axisDataConverter_12_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_4_io_pop_valid                   ), //o
    .io_pop_ready    (streamFifo_4_io_pop_ready                   ), //i
    .io_pop_payload  (streamFifo_4_io_pop_payload[63:0]           ), //o
    .io_flush        (1'b0                                        ), //i
    .io_occupancy    (streamFifo_4_io_occupancy[9:0]              ), //o
    .io_availability (streamFifo_4_io_availability[9:0]           ), //o
    .clk             (clk                                         ), //i
    .reset           (reset                                       )  //i
  );
  ConvOutput_Converter axisDataConverter_12 (
    .inStream_valid    (axisDataConverter_12_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_12_inStream_ready         ), //o
    .inStream_payload  (sData_4[7:0]                                ), //i
    .outStream_valid   (axisDataConverter_12_outStream_valid        ), //o
    .outStream_ready   (streamFifo_4_io_push_ready                  ), //i
    .outStream_payload (axisDataConverter_12_outStream_payload[63:0]), //o
    .clk               (clk                                         ), //i
    .reset             (reset                                       )  //i
  );
  ConvOutput_Fifo streamFifo_5 (
    .io_push_valid   (axisDataConverter_13_outStream_valid        ), //i
    .io_push_ready   (streamFifo_5_io_push_ready                  ), //o
    .io_push_payload (axisDataConverter_13_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_5_io_pop_valid                   ), //o
    .io_pop_ready    (streamFifo_5_io_pop_ready                   ), //i
    .io_pop_payload  (streamFifo_5_io_pop_payload[63:0]           ), //o
    .io_flush        (1'b0                                        ), //i
    .io_occupancy    (streamFifo_5_io_occupancy[9:0]              ), //o
    .io_availability (streamFifo_5_io_availability[9:0]           ), //o
    .clk             (clk                                         ), //i
    .reset           (reset                                       )  //i
  );
  ConvOutput_Converter axisDataConverter_13 (
    .inStream_valid    (axisDataConverter_13_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_13_inStream_ready         ), //o
    .inStream_payload  (sData_5[7:0]                                ), //i
    .outStream_valid   (axisDataConverter_13_outStream_valid        ), //o
    .outStream_ready   (streamFifo_5_io_push_ready                  ), //i
    .outStream_payload (axisDataConverter_13_outStream_payload[63:0]), //o
    .clk               (clk                                         ), //i
    .reset             (reset                                       )  //i
  );
  ConvOutput_Fifo streamFifo_6 (
    .io_push_valid   (axisDataConverter_14_outStream_valid        ), //i
    .io_push_ready   (streamFifo_6_io_push_ready                  ), //o
    .io_push_payload (axisDataConverter_14_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_6_io_pop_valid                   ), //o
    .io_pop_ready    (streamFifo_6_io_pop_ready                   ), //i
    .io_pop_payload  (streamFifo_6_io_pop_payload[63:0]           ), //o
    .io_flush        (1'b0                                        ), //i
    .io_occupancy    (streamFifo_6_io_occupancy[9:0]              ), //o
    .io_availability (streamFifo_6_io_availability[9:0]           ), //o
    .clk             (clk                                         ), //i
    .reset           (reset                                       )  //i
  );
  ConvOutput_Converter axisDataConverter_14 (
    .inStream_valid    (axisDataConverter_14_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_14_inStream_ready         ), //o
    .inStream_payload  (sData_6[7:0]                                ), //i
    .outStream_valid   (axisDataConverter_14_outStream_valid        ), //o
    .outStream_ready   (streamFifo_6_io_push_ready                  ), //i
    .outStream_payload (axisDataConverter_14_outStream_payload[63:0]), //o
    .clk               (clk                                         ), //i
    .reset             (reset                                       )  //i
  );
  ConvOutput_Fifo streamFifo_7 (
    .io_push_valid   (axisDataConverter_15_outStream_valid        ), //i
    .io_push_ready   (streamFifo_7_io_push_ready                  ), //o
    .io_push_payload (axisDataConverter_15_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_7_io_pop_valid                   ), //o
    .io_pop_ready    (streamFifo_7_io_pop_ready                   ), //i
    .io_pop_payload  (streamFifo_7_io_pop_payload[63:0]           ), //o
    .io_flush        (1'b0                                        ), //i
    .io_occupancy    (streamFifo_7_io_occupancy[9:0]              ), //o
    .io_availability (streamFifo_7_io_availability[9:0]           ), //o
    .clk             (clk                                         ), //i
    .reset           (reset                                       )  //i
  );
  ConvOutput_Converter axisDataConverter_15 (
    .inStream_valid    (axisDataConverter_15_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_15_inStream_ready         ), //o
    .inStream_payload  (sData_7[7:0]                                ), //i
    .outStream_valid   (axisDataConverter_15_outStream_valid        ), //o
    .outStream_ready   (streamFifo_7_io_push_ready                  ), //i
    .outStream_payload (axisDataConverter_15_outStream_payload[63:0]), //o
    .clk               (clk                                         ), //i
    .reset             (reset                                       )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      CONVOUTPUT_ENUM_IDLE : Fsm_currentState_string = "IDLE            ";
      CONVOUTPUT_ENUM_INIT : Fsm_currentState_string = "INIT            ";
      CONVOUTPUT_ENUM_DATA_ARRANGEMENT : Fsm_currentState_string = "DATA_ARRANGEMENT";
      CONVOUTPUT_ENUM_WAIT_END : Fsm_currentState_string = "WAIT_END        ";
      default : Fsm_currentState_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      CONVOUTPUT_ENUM_IDLE : Fsm_nextState_string = "IDLE            ";
      CONVOUTPUT_ENUM_INIT : Fsm_nextState_string = "INIT            ";
      CONVOUTPUT_ENUM_DATA_ARRANGEMENT : Fsm_nextState_string = "DATA_ARRANGEMENT";
      CONVOUTPUT_ENUM_WAIT_END : Fsm_nextState_string = "WAIT_END        ";
      default : Fsm_nextState_string = "????????????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & CONVOUTPUT_ENUM_IDLE) == CONVOUTPUT_ENUM_IDLE) : begin
        if(start) begin
          Fsm_nextState = CONVOUTPUT_ENUM_INIT;
        end else begin
          Fsm_nextState = CONVOUTPUT_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & CONVOUTPUT_ENUM_INIT) == CONVOUTPUT_ENUM_INIT) : begin
        if(Fsm_Inited) begin
          Fsm_nextState = CONVOUTPUT_ENUM_DATA_ARRANGEMENT;
        end else begin
          Fsm_nextState = CONVOUTPUT_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) == CONVOUTPUT_ENUM_DATA_ARRANGEMENT) : begin
        if(Fsm_LayerEnd) begin
          Fsm_nextState = CONVOUTPUT_ENUM_WAIT_END;
        end else begin
          Fsm_nextState = CONVOUTPUT_ENUM_DATA_ARRANGEMENT;
        end
      end
      default : begin
        if(Fsm_Data_AllOut) begin
          Fsm_nextState = CONVOUTPUT_ENUM_IDLE;
        end else begin
          Fsm_nextState = CONVOUTPUT_ENUM_WAIT_END;
        end
      end
    endcase
  end

  assign ConvCtrl_ResetCnt = ((Fsm_currentState & CONVOUTPUT_ENUM_INIT) != 4'b0000);
  assign ConvCtrl_InData_Cnt_En = ((sReady && sValid[0]) && SwitchConv);
  assign mData_fire = (mData_valid && mData_ready);
  assign ConvCtrl_OutData_Cnt_En = (mData_fire && SwitchConv);
  assign GemmCtrl_ResetCnt = ((Fsm_currentState & CONVOUTPUT_ENUM_INIT) != 4'b0000);
  assign GemmCtrl_InData_Cnt_En = ((sReady && sValid[0]) && (! SwitchConv));
  assign mData_fire_1 = (mData_valid && mData_ready);
  assign GemmCtrl_OutData_Cnt_En = (mData_fire_1 && (! SwitchConv));
  assign when_WaCounter_l40 = ((Fsm_currentState & CONVOUTPUT_ENUM_INIT) != 4'b0000);
  assign Init_Cnt_valid = ((Init_Cnt_count == 3'b101) && when_WaCounter_l40);
  assign Fsm_Inited = Init_Cnt_valid;
  assign Fsm_LayerEnd = ((ConvCtrl_Fsm_LayerEnd && SwitchConv) || (GemmCtrl_Fsm_LayerEnd && (! SwitchConv)));
  assign Fsm_Data_AllOut = ((ConvCtrl_Fsm_Data_AllOut && SwitchConv) || (GemmCtrl_Fsm_Data_AllOut && (! SwitchConv)));
  always @(*) begin
    mData_payload = 64'h0;
    if(when_SA3D_DataArrange_l131) begin
      mData_payload = streamFifo_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_1) begin
      mData_payload = streamFifo_1_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_2) begin
      mData_payload = streamFifo_2_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_3) begin
      mData_payload = streamFifo_3_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_4) begin
      mData_payload = streamFifo_4_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_5) begin
      mData_payload = streamFifo_5_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_6) begin
      mData_payload = streamFifo_6_io_pop_payload;
    end
    if(when_SA3D_DataArrange_l131_7) begin
      mData_payload = streamFifo_7_io_pop_payload;
    end
  end

  always @(*) begin
    mData_valid = 1'b0;
    if(when_SA3D_DataArrange_l131) begin
      mData_valid = streamFifo_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_1) begin
      mData_valid = streamFifo_1_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_2) begin
      mData_valid = streamFifo_2_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_3) begin
      mData_valid = streamFifo_3_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_4) begin
      mData_valid = streamFifo_4_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_5) begin
      mData_valid = streamFifo_5_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_6) begin
      mData_valid = streamFifo_6_io_pop_valid;
    end
    if(when_SA3D_DataArrange_l131_7) begin
      mData_valid = streamFifo_7_io_pop_valid;
    end
  end

  assign when_SA3D_DataArrange_l108 = ((Fsm_currentState & CONVOUTPUT_ENUM_INIT) != 4'b0000);
  assign when_SA3D_DataArrange_l112 = (ConvCtrl_OutSwitch_Rotate || GemmCtrl_OutSwitch_Rotate);
  assign sReady = (axisDataConverter_8_inStream_ready && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  assign axisDataConverter_8_inStream_valid = (sValid[0] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131) begin
      streamFifo_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131 = _zz_when_SA3D_DataArrange_l131[0];
  assign axisDataConverter_9_inStream_valid = (sValid[1] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_1_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_1) begin
      streamFifo_1_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_1 = _zz_when_SA3D_DataArrange_l131_1[0];
  assign axisDataConverter_10_inStream_valid = (sValid[2] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_2_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_2) begin
      streamFifo_2_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_2 = _zz_when_SA3D_DataArrange_l131_2[0];
  assign axisDataConverter_11_inStream_valid = (sValid[3] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_3_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_3) begin
      streamFifo_3_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_3 = _zz_when_SA3D_DataArrange_l131_3[0];
  assign axisDataConverter_12_inStream_valid = (sValid[4] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_4_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_4) begin
      streamFifo_4_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_4 = _zz_when_SA3D_DataArrange_l131_4[0];
  assign axisDataConverter_13_inStream_valid = (sValid[5] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_5_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_5) begin
      streamFifo_5_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_5 = _zz_when_SA3D_DataArrange_l131_5[0];
  assign axisDataConverter_14_inStream_valid = (sValid[6] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_6_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_6) begin
      streamFifo_6_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_6 = _zz_when_SA3D_DataArrange_l131_6[0];
  assign axisDataConverter_15_inStream_valid = (sValid[7] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_7_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_7) begin
      streamFifo_7_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_7 = _zz_when_SA3D_DataArrange_l131_7[0];
  assign mLast = Fsm_Data_AllOut;
  assign LayerEnd = Fsm_Data_AllOut;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= CONVOUTPUT_ENUM_IDLE;
      Init_Cnt_count <= 3'b000;
      OutSwitch <= 8'h01;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Cnt_valid) begin
          Init_Cnt_count <= 3'b000;
        end else begin
          Init_Cnt_count <= (Init_Cnt_count + 3'b001);
        end
      end
      if(when_SA3D_DataArrange_l108) begin
        OutSwitch <= 8'h01;
      end else begin
        if(ConvCtrl_OutSwitch_Reset) begin
          OutSwitch <= 8'h01;
        end else begin
          if(when_SA3D_DataArrange_l112) begin
            OutSwitch <= {OutSwitch[6 : 0],OutSwitch[7 : 7]};
          end
        end
      end
    end
  end


endmodule

module Flatten (
  input               sData_valid_0,
  input               sData_valid_1,
  input               sData_valid_2,
  input               sData_valid_3,
  input               sData_valid_4,
  input               sData_valid_5,
  input               sData_valid_6,
  input               sData_valid_7,
  input      [31:0]   sData_payload_0_0,
  input      [31:0]   sData_payload_1_0,
  input      [31:0]   sData_payload_2_0,
  input      [31:0]   sData_payload_3_0,
  input      [31:0]   sData_payload_4_0,
  input      [31:0]   sData_payload_5_0,
  input      [31:0]   sData_payload_6_0,
  input      [31:0]   sData_payload_7_0,
  output              mData_0_valid,
  input               mData_0_ready,
  output     [31:0]   mData_0_payload,
  output              mData_1_valid,
  input               mData_1_ready,
  output     [31:0]   mData_1_payload,
  output              mData_2_valid,
  input               mData_2_ready,
  output     [31:0]   mData_2_payload,
  output              mData_3_valid,
  input               mData_3_ready,
  output     [31:0]   mData_3_payload,
  output              mData_4_valid,
  input               mData_4_ready,
  output     [31:0]   mData_4_payload,
  output              mData_5_valid,
  input               mData_5_ready,
  output     [31:0]   mData_5_payload,
  output              mData_6_valid,
  input               mData_6_ready,
  output     [31:0]   mData_6_payload,
  output              mData_7_valid,
  input               mData_7_ready,
  output     [31:0]   mData_7_payload,
  input               clk
);

  wire       [31:0]   mData_payload0;
  wire       [31:0]   mData_payload1;
  wire       [31:0]   mData_payload2;
  wire       [31:0]   mData_payload3;
  wire       [31:0]   mData_payload4;
  wire       [31:0]   mData_payload5;
  wire       [31:0]   mData_payload6;
  wire       [31:0]   mData_payload7;
  wire       [0:0]    mData_valid0;
  wire       [0:0]    mData_valid1;
  wire       [0:0]    mData_valid2;
  wire       [0:0]    mData_valid3;
  wire       [0:0]    mData_valid4;
  wire       [0:0]    mData_valid5;
  wire       [0:0]    mData_valid6;
  wire       [0:0]    mData_valid7;

  ila_Flatten xil_ila (
    .probe0  (mData_payload0[31:0]), //i
    .probe1  (mData_payload1[31:0]), //i
    .probe2  (mData_payload2[31:0]), //i
    .probe3  (mData_payload3[31:0]), //i
    .probe4  (mData_payload4[31:0]), //i
    .probe5  (mData_payload5[31:0]), //i
    .probe6  (mData_payload6[31:0]), //i
    .probe7  (mData_payload7[31:0]), //i
    .probe8  (mData_valid0        ), //i
    .probe9  (mData_valid1        ), //i
    .probe10 (mData_valid2        ), //i
    .probe11 (mData_valid3        ), //i
    .probe12 (mData_valid4        ), //i
    .probe13 (mData_valid5        ), //i
    .probe14 (mData_valid6        ), //i
    .probe15 (mData_valid7        ), //i
    .clk     (clk                 )  //i
  );
  assign mData_0_payload = sData_payload_0_0;
  assign mData_0_valid = sData_valid_0;
  assign mData_1_payload = sData_payload_1_0;
  assign mData_1_valid = sData_valid_1;
  assign mData_2_payload = sData_payload_2_0;
  assign mData_2_valid = sData_valid_2;
  assign mData_3_payload = sData_payload_3_0;
  assign mData_3_valid = sData_valid_3;
  assign mData_4_payload = sData_payload_4_0;
  assign mData_4_valid = sData_valid_4;
  assign mData_5_payload = sData_payload_5_0;
  assign mData_5_valid = sData_valid_5;
  assign mData_6_payload = sData_payload_6_0;
  assign mData_6_valid = sData_valid_6;
  assign mData_7_payload = sData_payload_7_0;
  assign mData_7_valid = sData_valid_7;
  assign mData_payload0 = mData_0_payload;
  assign mData_payload1 = mData_1_payload;
  assign mData_payload2 = mData_2_payload;
  assign mData_payload3 = mData_3_payload;
  assign mData_payload4 = mData_4_payload;
  assign mData_payload5 = mData_5_payload;
  assign mData_payload6 = mData_6_payload;
  assign mData_payload7 = mData_7_payload;
  assign mData_valid0 = mData_0_valid;
  assign mData_valid1 = mData_1_valid;
  assign mData_valid2 = mData_2_valid;
  assign mData_valid3 = mData_3_valid;
  assign mData_valid4 = mData_4_valid;
  assign mData_valid5 = mData_5_valid;
  assign mData_valid6 = mData_6_valid;
  assign mData_valid7 = mData_7_valid;

endmodule

module SA_3D (
  input               start,
  input      [7:0]    _zz_io_MatrixA_0,
  input      [7:0]    _zz_io_MatrixA_1,
  input      [7:0]    _zz_io_MatrixA_2,
  input      [7:0]    _zz_io_MatrixA_3,
  input      [7:0]    _zz_io_MatrixA_4,
  input      [7:0]    _zz_io_MatrixA_5,
  input      [7:0]    _zz_io_MatrixA_6,
  input      [7:0]    _zz_io_MatrixA_7,
  input      [7:0]    _zz_io_MatrixB_0,
  input      [7:0]    _zz_io_MatrixB_1,
  input      [7:0]    _zz_io_MatrixB_2,
  input      [7:0]    _zz_io_MatrixB_3,
  input      [7:0]    _zz_io_MatrixB_4,
  input      [7:0]    _zz_io_MatrixB_5,
  input      [7:0]    _zz_io_MatrixB_6,
  input      [7:0]    _zz_io_MatrixB_7,
  input               _zz_io_A_Valid_0,
  input               _zz_io_A_Valid_1,
  input               _zz_io_A_Valid_2,
  input               _zz_io_A_Valid_3,
  input               _zz_io_A_Valid_4,
  input               _zz_io_A_Valid_5,
  input               _zz_io_A_Valid_6,
  input               _zz_io_A_Valid_7,
  input               _zz_io_B_Valid_0,
  input               _zz_io_B_Valid_1,
  input               _zz_io_B_Valid_2,
  input               _zz_io_B_Valid_3,
  input               _zz_io_B_Valid_4,
  input               _zz_io_B_Valid_5,
  input               _zz_io_B_Valid_6,
  input               _zz_io_B_Valid_7,
  input      [15:0]   _zz_io_signCount,
  input               clk,
  output              Matrix_C_valid_0,
  output              Matrix_C_valid_1,
  output              Matrix_C_valid_2,
  output              Matrix_C_valid_3,
  output              Matrix_C_valid_4,
  output              Matrix_C_valid_5,
  output              Matrix_C_valid_6,
  output              Matrix_C_valid_7,
  output     [31:0]   Matrix_C_payload_0,
  output     [31:0]   Matrix_C_payload_1,
  output     [31:0]   Matrix_C_payload_2,
  output     [31:0]   Matrix_C_payload_3,
  output     [31:0]   Matrix_C_payload_4,
  output     [31:0]   Matrix_C_payload_5,
  output     [31:0]   Matrix_C_payload_6,
  output     [31:0]   Matrix_C_payload_7,
  input               reset
);

  wire       [31:0]   Slice0_MatrixC_0;
  wire       [31:0]   Slice0_MatrixC_1;
  wire       [31:0]   Slice0_MatrixC_2;
  wire       [31:0]   Slice0_MatrixC_3;
  wire       [31:0]   Slice0_MatrixC_4;
  wire       [31:0]   Slice0_MatrixC_5;
  wire       [31:0]   Slice0_MatrixC_6;
  wire       [31:0]   Slice0_MatrixC_7;
  wire                Slice0_C_Valid_0;
  wire                Slice0_C_Valid_1;
  wire                Slice0_C_Valid_2;
  wire                Slice0_C_Valid_3;
  wire                Slice0_C_Valid_4;
  wire                Slice0_C_Valid_5;
  wire                Slice0_C_Valid_6;
  wire                Slice0_C_Valid_7;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_4;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_5;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_6;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_7;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_8;
  reg                 SubModule_SA_3D_Slice0_C_Valid_0_delay_9;
  reg        [31:0]   _zz_Matrix_C_payload_0;
  reg        [31:0]   _zz_Matrix_C_payload_0_1;
  reg        [31:0]   _zz_Matrix_C_payload_0_2;
  reg        [31:0]   _zz_Matrix_C_payload_0_3;
  reg        [31:0]   _zz_Matrix_C_payload_0_4;
  reg        [31:0]   _zz_Matrix_C_payload_0_5;
  reg        [31:0]   _zz_Matrix_C_payload_0_6;
  reg        [31:0]   _zz_Matrix_C_payload_0_7;
  reg        [31:0]   _zz_Matrix_C_payload_0_8;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_4;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_5;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_6;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_7;
  reg                 SubModule_SA_3D_Slice0_C_Valid_1_delay_8;
  reg        [31:0]   _zz_Matrix_C_payload_1;
  reg        [31:0]   _zz_Matrix_C_payload_1_1;
  reg        [31:0]   _zz_Matrix_C_payload_1_2;
  reg        [31:0]   _zz_Matrix_C_payload_1_3;
  reg        [31:0]   _zz_Matrix_C_payload_1_4;
  reg        [31:0]   _zz_Matrix_C_payload_1_5;
  reg        [31:0]   _zz_Matrix_C_payload_1_6;
  reg        [31:0]   _zz_Matrix_C_payload_1_7;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_4;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_5;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_6;
  reg                 SubModule_SA_3D_Slice0_C_Valid_2_delay_7;
  reg        [31:0]   _zz_Matrix_C_payload_2;
  reg        [31:0]   _zz_Matrix_C_payload_2_1;
  reg        [31:0]   _zz_Matrix_C_payload_2_2;
  reg        [31:0]   _zz_Matrix_C_payload_2_3;
  reg        [31:0]   _zz_Matrix_C_payload_2_4;
  reg        [31:0]   _zz_Matrix_C_payload_2_5;
  reg        [31:0]   _zz_Matrix_C_payload_2_6;
  reg                 SubModule_SA_3D_Slice0_C_Valid_3_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_3_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_3_delay_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_3_delay_4;
  reg                 SubModule_SA_3D_Slice0_C_Valid_3_delay_5;
  reg                 SubModule_SA_3D_Slice0_C_Valid_3_delay_6;
  reg        [31:0]   _zz_Matrix_C_payload_3;
  reg        [31:0]   _zz_Matrix_C_payload_3_1;
  reg        [31:0]   _zz_Matrix_C_payload_3_2;
  reg        [31:0]   _zz_Matrix_C_payload_3_3;
  reg        [31:0]   _zz_Matrix_C_payload_3_4;
  reg        [31:0]   _zz_Matrix_C_payload_3_5;
  reg                 SubModule_SA_3D_Slice0_C_Valid_4_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_4_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_4_delay_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_4_delay_4;
  reg                 SubModule_SA_3D_Slice0_C_Valid_4_delay_5;
  reg        [31:0]   _zz_Matrix_C_payload_4;
  reg        [31:0]   _zz_Matrix_C_payload_4_1;
  reg        [31:0]   _zz_Matrix_C_payload_4_2;
  reg        [31:0]   _zz_Matrix_C_payload_4_3;
  reg        [31:0]   _zz_Matrix_C_payload_4_4;
  reg                 SubModule_SA_3D_Slice0_C_Valid_5_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_5_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_5_delay_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_5_delay_4;
  reg        [31:0]   _zz_Matrix_C_payload_5;
  reg        [31:0]   _zz_Matrix_C_payload_5_1;
  reg        [31:0]   _zz_Matrix_C_payload_5_2;
  reg        [31:0]   _zz_Matrix_C_payload_5_3;
  reg                 SubModule_SA_3D_Slice0_C_Valid_6_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_6_delay_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_6_delay_3;
  reg        [31:0]   _zz_Matrix_C_payload_6;
  reg        [31:0]   _zz_Matrix_C_payload_6_1;
  reg        [31:0]   _zz_Matrix_C_payload_6_2;
  reg                 SubModule_SA_3D_Slice0_C_Valid_7_delay_1;
  reg                 SubModule_SA_3D_Slice0_C_Valid_7_delay_2;
  reg        [31:0]   _zz_Matrix_C_payload_7;
  reg        [31:0]   _zz_Matrix_C_payload_7_1;

  SA_2D Slice0 (
    .io_MatrixA_0 (_zz_io_MatrixA_0[7:0] ), //i
    .io_MatrixA_1 (_zz_io_MatrixA_1[7:0] ), //i
    .io_MatrixA_2 (_zz_io_MatrixA_2[7:0] ), //i
    .io_MatrixA_3 (_zz_io_MatrixA_3[7:0] ), //i
    .io_MatrixA_4 (_zz_io_MatrixA_4[7:0] ), //i
    .io_MatrixA_5 (_zz_io_MatrixA_5[7:0] ), //i
    .io_MatrixA_6 (_zz_io_MatrixA_6[7:0] ), //i
    .io_MatrixA_7 (_zz_io_MatrixA_7[7:0] ), //i
    .io_MatrixB_0 (_zz_io_MatrixB_0[7:0] ), //i
    .io_MatrixB_1 (_zz_io_MatrixB_1[7:0] ), //i
    .io_MatrixB_2 (_zz_io_MatrixB_2[7:0] ), //i
    .io_MatrixB_3 (_zz_io_MatrixB_3[7:0] ), //i
    .io_MatrixB_4 (_zz_io_MatrixB_4[7:0] ), //i
    .io_MatrixB_5 (_zz_io_MatrixB_5[7:0] ), //i
    .io_MatrixB_6 (_zz_io_MatrixB_6[7:0] ), //i
    .io_MatrixB_7 (_zz_io_MatrixB_7[7:0] ), //i
    .io_A_Valid_0 (_zz_io_A_Valid_0      ), //i
    .io_A_Valid_1 (_zz_io_A_Valid_1      ), //i
    .io_A_Valid_2 (_zz_io_A_Valid_2      ), //i
    .io_A_Valid_3 (_zz_io_A_Valid_3      ), //i
    .io_A_Valid_4 (_zz_io_A_Valid_4      ), //i
    .io_A_Valid_5 (_zz_io_A_Valid_5      ), //i
    .io_A_Valid_6 (_zz_io_A_Valid_6      ), //i
    .io_A_Valid_7 (_zz_io_A_Valid_7      ), //i
    .io_B_Valid_0 (_zz_io_B_Valid_0      ), //i
    .io_B_Valid_1 (_zz_io_B_Valid_1      ), //i
    .io_B_Valid_2 (_zz_io_B_Valid_2      ), //i
    .io_B_Valid_3 (_zz_io_B_Valid_3      ), //i
    .io_B_Valid_4 (_zz_io_B_Valid_4      ), //i
    .io_B_Valid_5 (_zz_io_B_Valid_5      ), //i
    .io_B_Valid_6 (_zz_io_B_Valid_6      ), //i
    .io_B_Valid_7 (_zz_io_B_Valid_7      ), //i
    .io_signCount (_zz_io_signCount[15:0]), //i
    .MatrixC_0    (Slice0_MatrixC_0[31:0]), //o
    .MatrixC_1    (Slice0_MatrixC_1[31:0]), //o
    .MatrixC_2    (Slice0_MatrixC_2[31:0]), //o
    .MatrixC_3    (Slice0_MatrixC_3[31:0]), //o
    .MatrixC_4    (Slice0_MatrixC_4[31:0]), //o
    .MatrixC_5    (Slice0_MatrixC_5[31:0]), //o
    .MatrixC_6    (Slice0_MatrixC_6[31:0]), //o
    .MatrixC_7    (Slice0_MatrixC_7[31:0]), //o
    .C_Valid_0    (Slice0_C_Valid_0      ), //o
    .C_Valid_1    (Slice0_C_Valid_1      ), //o
    .C_Valid_2    (Slice0_C_Valid_2      ), //o
    .C_Valid_3    (Slice0_C_Valid_3      ), //o
    .C_Valid_4    (Slice0_C_Valid_4      ), //o
    .C_Valid_5    (Slice0_C_Valid_5      ), //o
    .C_Valid_6    (Slice0_C_Valid_6      ), //o
    .C_Valid_7    (Slice0_C_Valid_7      ), //o
    .start        (start                 ), //i
    .clk          (clk                   ), //i
    .reset        (reset                 )  //i
  );
  assign Matrix_C_valid_0 = SubModule_SA_3D_Slice0_C_Valid_0_delay_9;
  assign Matrix_C_payload_0[31 : 0] = _zz_Matrix_C_payload_0_8;
  assign Matrix_C_valid_1 = SubModule_SA_3D_Slice0_C_Valid_1_delay_8;
  assign Matrix_C_payload_1[31 : 0] = _zz_Matrix_C_payload_1_7;
  assign Matrix_C_valid_2 = SubModule_SA_3D_Slice0_C_Valid_2_delay_7;
  assign Matrix_C_payload_2[31 : 0] = _zz_Matrix_C_payload_2_6;
  assign Matrix_C_valid_3 = SubModule_SA_3D_Slice0_C_Valid_3_delay_6;
  assign Matrix_C_payload_3[31 : 0] = _zz_Matrix_C_payload_3_5;
  assign Matrix_C_valid_4 = SubModule_SA_3D_Slice0_C_Valid_4_delay_5;
  assign Matrix_C_payload_4[31 : 0] = _zz_Matrix_C_payload_4_4;
  assign Matrix_C_valid_5 = SubModule_SA_3D_Slice0_C_Valid_5_delay_4;
  assign Matrix_C_payload_5[31 : 0] = _zz_Matrix_C_payload_5_3;
  assign Matrix_C_valid_6 = SubModule_SA_3D_Slice0_C_Valid_6_delay_3;
  assign Matrix_C_payload_6[31 : 0] = _zz_Matrix_C_payload_6_2;
  assign Matrix_C_valid_7 = SubModule_SA_3D_Slice0_C_Valid_7_delay_2;
  assign Matrix_C_payload_7[31 : 0] = _zz_Matrix_C_payload_7_1;
  always @(posedge clk) begin
    SubModule_SA_3D_Slice0_C_Valid_0_delay_1 <= Slice0_C_Valid_0;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_2;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_4 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_3;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_5 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_4;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_6 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_5;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_7 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_6;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_8 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_7;
    SubModule_SA_3D_Slice0_C_Valid_0_delay_9 <= SubModule_SA_3D_Slice0_C_Valid_0_delay_8;
    _zz_Matrix_C_payload_0 <= Slice0_MatrixC_0;
    _zz_Matrix_C_payload_0_1 <= _zz_Matrix_C_payload_0;
    _zz_Matrix_C_payload_0_2 <= _zz_Matrix_C_payload_0_1;
    _zz_Matrix_C_payload_0_3 <= _zz_Matrix_C_payload_0_2;
    _zz_Matrix_C_payload_0_4 <= _zz_Matrix_C_payload_0_3;
    _zz_Matrix_C_payload_0_5 <= _zz_Matrix_C_payload_0_4;
    _zz_Matrix_C_payload_0_6 <= _zz_Matrix_C_payload_0_5;
    _zz_Matrix_C_payload_0_7 <= _zz_Matrix_C_payload_0_6;
    _zz_Matrix_C_payload_0_8 <= _zz_Matrix_C_payload_0_7;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_1 <= Slice0_C_Valid_1;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_2;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_4 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_3;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_5 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_4;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_6 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_5;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_7 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_6;
    SubModule_SA_3D_Slice0_C_Valid_1_delay_8 <= SubModule_SA_3D_Slice0_C_Valid_1_delay_7;
    _zz_Matrix_C_payload_1 <= Slice0_MatrixC_1;
    _zz_Matrix_C_payload_1_1 <= _zz_Matrix_C_payload_1;
    _zz_Matrix_C_payload_1_2 <= _zz_Matrix_C_payload_1_1;
    _zz_Matrix_C_payload_1_3 <= _zz_Matrix_C_payload_1_2;
    _zz_Matrix_C_payload_1_4 <= _zz_Matrix_C_payload_1_3;
    _zz_Matrix_C_payload_1_5 <= _zz_Matrix_C_payload_1_4;
    _zz_Matrix_C_payload_1_6 <= _zz_Matrix_C_payload_1_5;
    _zz_Matrix_C_payload_1_7 <= _zz_Matrix_C_payload_1_6;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_1 <= Slice0_C_Valid_2;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_2_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_2_delay_2;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_4 <= SubModule_SA_3D_Slice0_C_Valid_2_delay_3;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_5 <= SubModule_SA_3D_Slice0_C_Valid_2_delay_4;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_6 <= SubModule_SA_3D_Slice0_C_Valid_2_delay_5;
    SubModule_SA_3D_Slice0_C_Valid_2_delay_7 <= SubModule_SA_3D_Slice0_C_Valid_2_delay_6;
    _zz_Matrix_C_payload_2 <= Slice0_MatrixC_2;
    _zz_Matrix_C_payload_2_1 <= _zz_Matrix_C_payload_2;
    _zz_Matrix_C_payload_2_2 <= _zz_Matrix_C_payload_2_1;
    _zz_Matrix_C_payload_2_3 <= _zz_Matrix_C_payload_2_2;
    _zz_Matrix_C_payload_2_4 <= _zz_Matrix_C_payload_2_3;
    _zz_Matrix_C_payload_2_5 <= _zz_Matrix_C_payload_2_4;
    _zz_Matrix_C_payload_2_6 <= _zz_Matrix_C_payload_2_5;
    SubModule_SA_3D_Slice0_C_Valid_3_delay_1 <= Slice0_C_Valid_3;
    SubModule_SA_3D_Slice0_C_Valid_3_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_3_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_3_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_3_delay_2;
    SubModule_SA_3D_Slice0_C_Valid_3_delay_4 <= SubModule_SA_3D_Slice0_C_Valid_3_delay_3;
    SubModule_SA_3D_Slice0_C_Valid_3_delay_5 <= SubModule_SA_3D_Slice0_C_Valid_3_delay_4;
    SubModule_SA_3D_Slice0_C_Valid_3_delay_6 <= SubModule_SA_3D_Slice0_C_Valid_3_delay_5;
    _zz_Matrix_C_payload_3 <= Slice0_MatrixC_3;
    _zz_Matrix_C_payload_3_1 <= _zz_Matrix_C_payload_3;
    _zz_Matrix_C_payload_3_2 <= _zz_Matrix_C_payload_3_1;
    _zz_Matrix_C_payload_3_3 <= _zz_Matrix_C_payload_3_2;
    _zz_Matrix_C_payload_3_4 <= _zz_Matrix_C_payload_3_3;
    _zz_Matrix_C_payload_3_5 <= _zz_Matrix_C_payload_3_4;
    SubModule_SA_3D_Slice0_C_Valid_4_delay_1 <= Slice0_C_Valid_4;
    SubModule_SA_3D_Slice0_C_Valid_4_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_4_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_4_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_4_delay_2;
    SubModule_SA_3D_Slice0_C_Valid_4_delay_4 <= SubModule_SA_3D_Slice0_C_Valid_4_delay_3;
    SubModule_SA_3D_Slice0_C_Valid_4_delay_5 <= SubModule_SA_3D_Slice0_C_Valid_4_delay_4;
    _zz_Matrix_C_payload_4 <= Slice0_MatrixC_4;
    _zz_Matrix_C_payload_4_1 <= _zz_Matrix_C_payload_4;
    _zz_Matrix_C_payload_4_2 <= _zz_Matrix_C_payload_4_1;
    _zz_Matrix_C_payload_4_3 <= _zz_Matrix_C_payload_4_2;
    _zz_Matrix_C_payload_4_4 <= _zz_Matrix_C_payload_4_3;
    SubModule_SA_3D_Slice0_C_Valid_5_delay_1 <= Slice0_C_Valid_5;
    SubModule_SA_3D_Slice0_C_Valid_5_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_5_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_5_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_5_delay_2;
    SubModule_SA_3D_Slice0_C_Valid_5_delay_4 <= SubModule_SA_3D_Slice0_C_Valid_5_delay_3;
    _zz_Matrix_C_payload_5 <= Slice0_MatrixC_5;
    _zz_Matrix_C_payload_5_1 <= _zz_Matrix_C_payload_5;
    _zz_Matrix_C_payload_5_2 <= _zz_Matrix_C_payload_5_1;
    _zz_Matrix_C_payload_5_3 <= _zz_Matrix_C_payload_5_2;
    SubModule_SA_3D_Slice0_C_Valid_6_delay_1 <= Slice0_C_Valid_6;
    SubModule_SA_3D_Slice0_C_Valid_6_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_6_delay_1;
    SubModule_SA_3D_Slice0_C_Valid_6_delay_3 <= SubModule_SA_3D_Slice0_C_Valid_6_delay_2;
    _zz_Matrix_C_payload_6 <= Slice0_MatrixC_6;
    _zz_Matrix_C_payload_6_1 <= _zz_Matrix_C_payload_6;
    _zz_Matrix_C_payload_6_2 <= _zz_Matrix_C_payload_6_1;
    SubModule_SA_3D_Slice0_C_Valid_7_delay_1 <= Slice0_C_Valid_7;
    SubModule_SA_3D_Slice0_C_Valid_7_delay_2 <= SubModule_SA_3D_Slice0_C_Valid_7_delay_1;
    _zz_Matrix_C_payload_7 <= Slice0_MatrixC_7;
    _zz_Matrix_C_payload_7_1 <= _zz_Matrix_C_payload_7;
  end


endmodule

module LayerNorm_Top (
  input      [7:0]    sData_0,
  input      [7:0]    sData_1,
  input      [7:0]    sData_2,
  input      [7:0]    sData_3,
  input      [7:0]    sData_4,
  input      [7:0]    sData_5,
  input      [7:0]    sData_6,
  input      [7:0]    sData_7,
  input               sValid,
  output              sReady,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  output              mLast,
  output              QuantPara_Cached,
  input               ScaleBias_In_valid,
  output              ScaleBias_In_ready,
  input      [63:0]   ScaleBias_In_payload,
  input      [7:0]    ZeroPoint,
  input               clk,
  input               reset
);
  localparam LayerNorm_Status_IDLE = 6'd1;
  localparam LayerNorm_Status_INIT = 6'd2;
  localparam LayerNorm_Status_LOAD_QUANT_DATA = 6'd4;
  localparam LayerNorm_Status_WAIT_MREADY = 6'd8;
  localparam LayerNorm_Status_WAIT_COMPUTE_END = 6'd16;
  localparam LayerNorm_Status_WAIT_OUTPUT_END = 6'd32;

  wire                ScaleBias_Converter_inStream_valid;
  wire       [18:0]   SubModule_sData_0;
  wire       [18:0]   SubModule_sData_1;
  wire       [18:0]   SubModule_sData_2;
  wire       [18:0]   SubModule_sData_3;
  wire       [18:0]   SubModule_sData_4;
  wire       [18:0]   SubModule_sData_5;
  wire       [18:0]   SubModule_sData_6;
  wire       [18:0]   SubModule_sData_7;
  wire                SubModule_sValid;
  wire       [7:0]    SubModule_Scale_1;
  wire       [7:0]    SubModule_Bias_1;
  wire       [7:0]    ScaleMem_1_dina;
  wire                ScaleMem_1_ena;
  wire       [7:0]    BiasMem_dina;
  wire                BiasMem_ena;
  wire                PTF_FactorMem_ena;
  wire                ScaleBias_Converter_inStream_ready;
  wire                ScaleBias_Converter_outStream_valid;
  wire       [15:0]   ScaleBias_Converter_outStream_payload;
  wire                SubModule_sReady;
  wire       [9:0]    SubModule_Bias_Read_Addr;
  wire       [9:0]    SubModule_Scale_Read_Addr;
  wire                SubModule_mData_valid;
  wire       [63:0]   SubModule_mData_payload;
  wire                SubModule_mLast;
  wire       [7:0]    ScaleMem_1_doutb;
  wire       [7:0]    BiasMem_doutb;
  wire       [1:0]    PTF_FactorMem_doutb;
  wire                OutPut_Cache_io_push_ready;
  wire                OutPut_Cache_io_pop_valid;
  wire       [63:0]   OutPut_Cache_io_pop_payload;
  wire       [6:0]    OutPut_Cache_io_occupancy;
  wire       [6:0]    OutPut_Cache_io_availability;
  wire       [9:0]    _zz_Ptf_In_Cnt_valid;
  wire       [5:0]    _zz_Ptf_In_Cnt_valid_1;
  wire       [5:0]    _zz_Ptf_In_Cnt_valid_2;
  wire       [4:0]    _zz_Ptf_In_Cnt_valid_3;
  wire       [4:0]    _zz_Ptf_In_Cnt_valid_4;
  wire       [14:0]   _zz_Ptf_Out_Cnt_valid;
  wire       [9:0]    _zz_Ptf_Out_Cnt_valid_1;
  wire       [9:0]    _zz_QuantCache_Cnt_valid;
  wire       [15:0]   _zz_sData_0;
  wire       [15:0]   _zz_sData_0_1;
  wire       [15:0]   _zz_sData_0_2;
  wire       [15:0]   _zz_sData_1;
  wire       [15:0]   _zz_sData_1_1;
  wire       [15:0]   _zz_sData_1_2;
  wire       [15:0]   _zz_sData_2;
  wire       [15:0]   _zz_sData_2_1;
  wire       [15:0]   _zz_sData_2_2;
  wire       [15:0]   _zz_sData_3;
  wire       [15:0]   _zz_sData_3_1;
  wire       [15:0]   _zz_sData_3_2;
  wire       [15:0]   _zz_sData_4;
  wire       [15:0]   _zz_sData_4_1;
  wire       [15:0]   _zz_sData_4_2;
  wire       [15:0]   _zz_sData_5;
  wire       [15:0]   _zz_sData_5_1;
  wire       [15:0]   _zz_sData_5_2;
  wire       [15:0]   _zz_sData_6;
  wire       [15:0]   _zz_sData_6_1;
  wire       [15:0]   _zz_sData_6_2;
  wire       [15:0]   _zz_sData_7;
  wire       [15:0]   _zz_sData_7_1;
  wire       [15:0]   _zz_sData_7_2;
  wire       [9:0]    _zz_OutCol_Cnt_valid;
  wire       [19:0]   _zz_OutRow_Cnt_valid;
  wire       [19:0]   _zz_OutRow_Cnt_valid_1;
  reg        [5:0]    Fsm_currentState;
  reg        [5:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_QuantData_Loaded;
  wire                Fsm_Compute_End;
  wire                Fsm_Output_End;
  wire                Fsm_mReady;
  wire                when_SumXq_Stage1_l637;
  wire                ScaleBias_sValid;
  reg                 ScaleBias_sReady;
  wire       [7:0]    Scale_1;
  wire       [7:0]    Bias_1;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  reg                 ScaleBias_Cached;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Ptf_In_Cnt_count;
  wire                Ptf_In_Cnt_valid;
  reg        [14:0]   Ptf_Out_Cnt_count;
  wire                Ptf_Out_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [9:0]    QuantCache_Cnt_count;
  wire                QuantCache_Cnt_valid;
  wire                when_SumXq_Stage1_l762;
  wire                mData_fire;
  reg        [9:0]    OutCol_Cnt_count;
  wire                OutCol_Cnt_valid;
  reg        [9:0]    OutRow_Cnt_count;
  wire                OutRow_Cnt_valid;
  `ifndef SYNTHESIS
  reg [127:0] Fsm_currentState_string;
  reg [127:0] Fsm_nextState_string;
  `endif


  assign _zz_Ptf_In_Cnt_valid_1 = ((Channel_Nums < 10'h0) ? 6'h20 : _zz_Ptf_In_Cnt_valid_2);
  assign _zz_Ptf_In_Cnt_valid = {4'd0, _zz_Ptf_In_Cnt_valid_1};
  assign _zz_Ptf_In_Cnt_valid_3 = (_zz_Ptf_In_Cnt_valid_4 - 5'h01);
  assign _zz_Ptf_In_Cnt_valid_2 = {1'd0, _zz_Ptf_In_Cnt_valid_3};
  assign _zz_Ptf_In_Cnt_valid_4 = (Channel_Nums >>> 5);
  assign _zz_Ptf_Out_Cnt_valid_1 = (Channel_Nums - 10'h001);
  assign _zz_Ptf_Out_Cnt_valid = {5'd0, _zz_Ptf_Out_Cnt_valid_1};
  assign _zz_QuantCache_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_sData_0 = ($signed(_zz_sData_0_1) + $signed(_zz_sData_0_2));
  assign _zz_sData_0_1 = {{8{sData_0[7]}}, sData_0};
  assign _zz_sData_0_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_1 = ($signed(_zz_sData_1_1) + $signed(_zz_sData_1_2));
  assign _zz_sData_1_1 = {{8{sData_1[7]}}, sData_1};
  assign _zz_sData_1_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_2 = ($signed(_zz_sData_2_1) + $signed(_zz_sData_2_2));
  assign _zz_sData_2_1 = {{8{sData_2[7]}}, sData_2};
  assign _zz_sData_2_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_3 = ($signed(_zz_sData_3_1) + $signed(_zz_sData_3_2));
  assign _zz_sData_3_1 = {{8{sData_3[7]}}, sData_3};
  assign _zz_sData_3_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_4 = ($signed(_zz_sData_4_1) + $signed(_zz_sData_4_2));
  assign _zz_sData_4_1 = {{8{sData_4[7]}}, sData_4};
  assign _zz_sData_4_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_5 = ($signed(_zz_sData_5_1) + $signed(_zz_sData_5_2));
  assign _zz_sData_5_1 = {{8{sData_5[7]}}, sData_5};
  assign _zz_sData_5_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_6 = ($signed(_zz_sData_6_1) + $signed(_zz_sData_6_2));
  assign _zz_sData_6_1 = {{8{sData_6[7]}}, sData_6};
  assign _zz_sData_6_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_sData_7 = ($signed(_zz_sData_7_1) + $signed(_zz_sData_7_2));
  assign _zz_sData_7_1 = {{8{sData_7[7]}}, sData_7};
  assign _zz_sData_7_2 = {{8{ZeroPoint[7]}}, ZeroPoint};
  assign _zz_OutCol_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_OutRow_Cnt_valid = {10'd0, OutRow_Cnt_count};
  assign _zz_OutRow_Cnt_valid_1 = (Token_Nums - 20'h00001);
  LayerNorm_ScaleBias_Converter ScaleBias_Converter (
    .inStream_valid    (ScaleBias_Converter_inStream_valid         ), //i
    .inStream_ready    (ScaleBias_Converter_inStream_ready         ), //o
    .inStream_payload  (ScaleBias_In_payload[63:0]                 ), //i
    .outStream_valid   (ScaleBias_Converter_outStream_valid        ), //o
    .outStream_ready   (ScaleBias_sReady                           ), //i
    .outStream_payload (ScaleBias_Converter_outStream_payload[15:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  LayerNorm_Module SubModule (
    .sData_0         (SubModule_sData_0[18:0]       ), //i
    .sData_1         (SubModule_sData_1[18:0]       ), //i
    .sData_2         (SubModule_sData_2[18:0]       ), //i
    .sData_3         (SubModule_sData_3[18:0]       ), //i
    .sData_4         (SubModule_sData_4[18:0]       ), //i
    .sData_5         (SubModule_sData_5[18:0]       ), //i
    .sData_6         (SubModule_sData_6[18:0]       ), //i
    .sData_7         (SubModule_sData_7[18:0]       ), //i
    .sValid          (SubModule_sValid              ), //i
    .sReady          (SubModule_sReady              ), //o
    .start           (Fsm_QuantData_Loaded          ), //i
    .Channel_Nums    (Channel_Nums[9:0]             ), //i
    .Token_Nums      (Token_Nums[19:0]              ), //i
    .Bias_Read_Addr  (SubModule_Bias_Read_Addr[9:0] ), //o
    .Scale_Read_Addr (SubModule_Scale_Read_Addr[9:0]), //o
    .Scale_1         (SubModule_Scale_1[7:0]        ), //i
    .Bias_1          (SubModule_Bias_1[7:0]         ), //i
    .mData_valid     (SubModule_mData_valid         ), //o
    .mData_ready     (OutPut_Cache_io_push_ready    ), //i
    .mData_payload   (SubModule_mData_payload[63:0] ), //o
    .mLast           (SubModule_mLast               ), //o
    .clk             (clk                           ), //i
    .reset           (reset                         )  //i
  );
  ScaleMem ScaleMem_1 (
    .clka  (clk                           ), //i
    .addra (QuantCache_Cnt_count[9:0]     ), //i
    .dina  (ScaleMem_1_dina[7:0]          ), //i
    .ena   (ScaleMem_1_ena                ), //i
    .wea   (1'b1                          ), //i
    .addrb (SubModule_Scale_Read_Addr[9:0]), //i
    .doutb (ScaleMem_1_doutb[7:0]         ), //o
    .clkb  (clk                           )  //i
  );
  ScaleMem BiasMem (
    .clka  (clk                          ), //i
    .addra (QuantCache_Cnt_count[9:0]    ), //i
    .dina  (BiasMem_dina[7:0]            ), //i
    .ena   (BiasMem_ena                  ), //i
    .wea   (1'b1                         ), //i
    .addrb (SubModule_Bias_Read_Addr[9:0]), //i
    .doutb (BiasMem_doutb[7:0]           ), //o
    .clkb  (clk                          )  //i
  );
  PtfMem PTF_FactorMem (
    .clka  (clk                       ), //i
    .addra (Ptf_In_Cnt_count[9:0]     ), //i
    .dina  (ScaleBias_In_payload[63:0]), //i
    .ena   (PTF_FactorMem_ena         ), //i
    .wea   (1'b1                      ), //i
    .addrb (Ptf_Out_Cnt_count[14:0]   ), //i
    .doutb (PTF_FactorMem_doutb[1:0]  ), //o
    .clkb  (clk                       )  //i
  );
  LayerNorm_OutputCache_Fifo OutPut_Cache (
    .io_push_valid   (SubModule_mData_valid            ), //i
    .io_push_ready   (OutPut_Cache_io_push_ready       ), //o
    .io_push_payload (SubModule_mData_payload[63:0]    ), //i
    .io_pop_valid    (OutPut_Cache_io_pop_valid        ), //o
    .io_pop_ready    (mData_ready                      ), //i
    .io_pop_payload  (OutPut_Cache_io_pop_payload[63:0]), //o
    .io_flush        (1'b0                             ), //i
    .io_occupancy    (OutPut_Cache_io_occupancy[6:0]   ), //o
    .io_availability (OutPut_Cache_io_availability[6:0]), //o
    .clk             (clk                              ), //i
    .reset           (reset                            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      LayerNorm_Status_IDLE : Fsm_currentState_string = "IDLE            ";
      LayerNorm_Status_INIT : Fsm_currentState_string = "INIT            ";
      LayerNorm_Status_LOAD_QUANT_DATA : Fsm_currentState_string = "LOAD_QUANT_DATA ";
      LayerNorm_Status_WAIT_MREADY : Fsm_currentState_string = "WAIT_MREADY     ";
      LayerNorm_Status_WAIT_COMPUTE_END : Fsm_currentState_string = "WAIT_COMPUTE_END";
      LayerNorm_Status_WAIT_OUTPUT_END : Fsm_currentState_string = "WAIT_OUTPUT_END ";
      default : Fsm_currentState_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      LayerNorm_Status_IDLE : Fsm_nextState_string = "IDLE            ";
      LayerNorm_Status_INIT : Fsm_nextState_string = "INIT            ";
      LayerNorm_Status_LOAD_QUANT_DATA : Fsm_nextState_string = "LOAD_QUANT_DATA ";
      LayerNorm_Status_WAIT_MREADY : Fsm_nextState_string = "WAIT_MREADY     ";
      LayerNorm_Status_WAIT_COMPUTE_END : Fsm_nextState_string = "WAIT_COMPUTE_END";
      LayerNorm_Status_WAIT_OUTPUT_END : Fsm_nextState_string = "WAIT_OUTPUT_END ";
      default : Fsm_nextState_string = "????????????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & LayerNorm_Status_IDLE) == LayerNorm_Status_IDLE) : begin
        if(start) begin
          Fsm_nextState = LayerNorm_Status_INIT;
        end else begin
          Fsm_nextState = LayerNorm_Status_IDLE;
        end
      end
      (((Fsm_currentState) & LayerNorm_Status_INIT) == LayerNorm_Status_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = LayerNorm_Status_LOAD_QUANT_DATA;
        end else begin
          Fsm_nextState = LayerNorm_Status_INIT;
        end
      end
      (((Fsm_currentState) & LayerNorm_Status_LOAD_QUANT_DATA) == LayerNorm_Status_LOAD_QUANT_DATA) : begin
        if(Fsm_QuantData_Loaded) begin
          Fsm_nextState = LayerNorm_Status_WAIT_MREADY;
        end else begin
          Fsm_nextState = LayerNorm_Status_LOAD_QUANT_DATA;
        end
      end
      (((Fsm_currentState) & LayerNorm_Status_WAIT_MREADY) == LayerNorm_Status_WAIT_MREADY) : begin
        if(Fsm_mReady) begin
          Fsm_nextState = LayerNorm_Status_WAIT_COMPUTE_END;
        end else begin
          Fsm_nextState = LayerNorm_Status_WAIT_MREADY;
        end
      end
      (((Fsm_currentState) & LayerNorm_Status_WAIT_COMPUTE_END) == LayerNorm_Status_WAIT_COMPUTE_END) : begin
        if(when_SumXq_Stage1_l637) begin
          Fsm_nextState = LayerNorm_Status_WAIT_MREADY;
        end else begin
          if(Fsm_Compute_End) begin
            Fsm_nextState = LayerNorm_Status_WAIT_OUTPUT_END;
          end else begin
            Fsm_nextState = LayerNorm_Status_WAIT_COMPUTE_END;
          end
        end
      end
      default : begin
        if(Fsm_Output_End) begin
          Fsm_nextState = LayerNorm_Status_IDLE;
        end else begin
          Fsm_nextState = LayerNorm_Status_WAIT_OUTPUT_END;
        end
      end
    endcase
  end

  assign when_SumXq_Stage1_l637 = (! Fsm_mReady);
  assign ScaleBias_Converter_inStream_valid = (ScaleBias_In_valid && ((Fsm_currentState & LayerNorm_Status_LOAD_QUANT_DATA) != 6'b000000));
  assign ScaleBias_In_ready = ScaleBias_Converter_inStream_ready;
  assign Bias_1 = ScaleBias_Converter_outStream_payload[15 : 8];
  assign Scale_1 = ScaleBias_Converter_outStream_payload[7 : 0];
  assign ScaleBias_sValid = ScaleBias_Converter_outStream_valid;
  assign when_WaCounter_l40 = ((Fsm_currentState & LayerNorm_Status_INIT) != 6'b000000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((ScaleBias_In_valid && ScaleBias_In_ready) && ScaleBias_Cached);
  assign Ptf_In_Cnt_valid = ((Ptf_In_Cnt_count == _zz_Ptf_In_Cnt_valid) && when_WaCounter_l40_1);
  assign Ptf_Out_Cnt_valid = ((Ptf_Out_Cnt_count == _zz_Ptf_Out_Cnt_valid) && sValid);
  assign Fsm_Init_End = Init_Count_valid;
  assign when_WaCounter_l40_2 = ((ScaleBias_sValid && ScaleBias_sReady) && (! ScaleBias_Cached));
  assign QuantCache_Cnt_valid = ((QuantCache_Cnt_count == _zz_QuantCache_Cnt_valid) && when_WaCounter_l40_2);
  assign QuantPara_Cached = Ptf_In_Cnt_valid;
  assign Fsm_QuantData_Loaded = Ptf_In_Cnt_valid;
  assign ScaleMem_1_dina = Scale_1;
  assign ScaleMem_1_ena = ((ScaleBias_sValid && ScaleBias_sReady) && (! ScaleBias_Cached));
  assign BiasMem_dina = Bias_1;
  assign BiasMem_ena = ((ScaleBias_sValid && ScaleBias_sReady) && (! ScaleBias_Cached));
  assign PTF_FactorMem_ena = (ScaleBias_In_valid && ScaleBias_Cached);
  assign SubModule_Scale_1 = ScaleMem_1_doutb;
  assign SubModule_Bias_1 = BiasMem_doutb;
  assign SubModule_sData_0 = ({{3{_zz_sData_0[15]}},_zz_sData_0} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_1 = ({{3{_zz_sData_1[15]}},_zz_sData_1} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_2 = ({{3{_zz_sData_2[15]}},_zz_sData_2} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_3 = ({{3{_zz_sData_3[15]}},_zz_sData_3} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_4 = ({{3{_zz_sData_4[15]}},_zz_sData_4} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_5 = ({{3{_zz_sData_5[15]}},_zz_sData_5} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_6 = ({{3{_zz_sData_6[15]}},_zz_sData_6} <<< PTF_FactorMem_doutb);
  assign SubModule_sData_7 = ({{3{_zz_sData_7[15]}},_zz_sData_7} <<< PTF_FactorMem_doutb);
  assign SubModule_sValid = (sValid && sReady);
  assign sReady = (SubModule_sReady && ((Fsm_currentState & LayerNorm_Status_WAIT_COMPUTE_END) != 6'b000000));
  assign when_SumXq_Stage1_l762 = ((Fsm_currentState & LayerNorm_Status_LOAD_QUANT_DATA) != 6'b000000);
  always @(*) begin
    if(when_SumXq_Stage1_l762) begin
      ScaleBias_sReady = 1'b1;
    end else begin
      ScaleBias_sReady = 1'b0;
    end
  end

  assign Fsm_mReady = mData_ready;
  assign Fsm_Compute_End = SubModule_mLast;
  assign mData_valid = OutPut_Cache_io_pop_valid;
  assign mData_payload = OutPut_Cache_io_pop_payload;
  assign mData_fire = (mData_valid && mData_ready);
  assign OutCol_Cnt_valid = ((OutCol_Cnt_count == _zz_OutCol_Cnt_valid) && mData_fire);
  assign OutRow_Cnt_valid = ((_zz_OutRow_Cnt_valid == _zz_OutRow_Cnt_valid_1) && OutCol_Cnt_valid);
  assign Fsm_Output_End = mLast;
  assign mLast = OutRow_Cnt_valid;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= LayerNorm_Status_IDLE;
      Init_Count_count <= 3'b000;
      ScaleBias_Cached <= 1'b0;
      Ptf_In_Cnt_count <= 10'h0;
      Ptf_Out_Cnt_count <= 15'h0;
      QuantCache_Cnt_count <= 10'h0;
      OutCol_Cnt_count <= 10'h0;
      OutRow_Cnt_count <= 10'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Ptf_In_Cnt_valid) begin
          Ptf_In_Cnt_count <= 10'h0;
        end else begin
          Ptf_In_Cnt_count <= (Ptf_In_Cnt_count + 10'h001);
        end
      end
      if(sValid) begin
        if(Ptf_Out_Cnt_valid) begin
          Ptf_Out_Cnt_count <= 15'h0;
        end else begin
          Ptf_Out_Cnt_count <= (Ptf_Out_Cnt_count + 15'h0001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(QuantCache_Cnt_valid) begin
          QuantCache_Cnt_count <= 10'h0;
        end else begin
          QuantCache_Cnt_count <= (QuantCache_Cnt_count + 10'h001);
        end
      end
      if(start) begin
        ScaleBias_Cached <= 1'b0;
      end else begin
        if(QuantCache_Cnt_valid) begin
          ScaleBias_Cached <= 1'b1;
        end
      end
      if(mData_fire) begin
        if(OutCol_Cnt_valid) begin
          OutCol_Cnt_count <= 10'h0;
        end else begin
          OutCol_Cnt_count <= (OutCol_Cnt_count + 10'h001);
        end
      end
      if(OutCol_Cnt_valid) begin
        if(OutRow_Cnt_valid) begin
          OutRow_Cnt_count <= 10'h0;
        end else begin
          OutRow_Cnt_count <= (OutRow_Cnt_count + 10'h001);
        end
      end
    end
  end


endmodule

module Img2ColStreamV2 (
  output reg [63:0]   mData,
  output reg [7:0]    mValid,
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  input               start,
  output              Raddr_Valid,
  output              LayerEnd,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutRow_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  input               enPadding,
  input      [7:0]    zeroDara,
  input      [1:0]    zeroNum,
  input               clk,
  input               reset
);

  wire                SubModule_Fifo_Clear;
  wire       [15:0]   SubModule_OutFeature_Channel;
  wire       [15:0]   SubModule_Test_Generate_Period;
  wire                streamFifo_io_push_valid;
  wire                streamFifo_1_io_push_valid;
  wire                streamFifo_2_io_push_valid;
  wire                streamFifo_3_io_push_valid;
  wire                streamFifo_4_io_push_valid;
  wire                streamFifo_5_io_push_valid;
  wire                streamFifo_6_io_push_valid;
  wire                streamFifo_7_io_push_valid;
  wire                SubModule_sData_ready;
  wire       [63:0]   SubModule_mData;
  wire                SubModule_mValid;
  wire                SubModule_mLast;
  wire                SubModule_Test_Signal;
  wire                SubModule_Test_End;
  wire                SubModule_Raddr_Valid;
  wire                SubModule_LayerEnd;
  wire                SubModule_SA_Row_Cnt_Valid;
  wire                streamFifo_io_push_ready;
  wire                streamFifo_io_pop_valid;
  wire       [63:0]   streamFifo_io_pop_payload;
  wire       [4:0]    streamFifo_io_occupancy;
  wire       [4:0]    streamFifo_io_availability;
  wire                axisDataConverter_8_inStream_ready;
  wire                axisDataConverter_8_outStream_valid;
  wire       [7:0]    axisDataConverter_8_outStream_payload;
  wire                streamFifo_1_io_push_ready;
  wire                streamFifo_1_io_pop_valid;
  wire       [63:0]   streamFifo_1_io_pop_payload;
  wire       [4:0]    streamFifo_1_io_occupancy;
  wire       [4:0]    streamFifo_1_io_availability;
  wire                axisDataConverter_9_inStream_ready;
  wire                axisDataConverter_9_outStream_valid;
  wire       [7:0]    axisDataConverter_9_outStream_payload;
  wire                streamFifo_2_io_push_ready;
  wire                streamFifo_2_io_pop_valid;
  wire       [63:0]   streamFifo_2_io_pop_payload;
  wire       [4:0]    streamFifo_2_io_occupancy;
  wire       [4:0]    streamFifo_2_io_availability;
  wire                axisDataConverter_10_inStream_ready;
  wire                axisDataConverter_10_outStream_valid;
  wire       [7:0]    axisDataConverter_10_outStream_payload;
  wire                streamFifo_3_io_push_ready;
  wire                streamFifo_3_io_pop_valid;
  wire       [63:0]   streamFifo_3_io_pop_payload;
  wire       [4:0]    streamFifo_3_io_occupancy;
  wire       [4:0]    streamFifo_3_io_availability;
  wire                axisDataConverter_11_inStream_ready;
  wire                axisDataConverter_11_outStream_valid;
  wire       [7:0]    axisDataConverter_11_outStream_payload;
  wire                streamFifo_4_io_push_ready;
  wire                streamFifo_4_io_pop_valid;
  wire       [63:0]   streamFifo_4_io_pop_payload;
  wire       [4:0]    streamFifo_4_io_occupancy;
  wire       [4:0]    streamFifo_4_io_availability;
  wire                axisDataConverter_12_inStream_ready;
  wire                axisDataConverter_12_outStream_valid;
  wire       [7:0]    axisDataConverter_12_outStream_payload;
  wire                streamFifo_5_io_push_ready;
  wire                streamFifo_5_io_pop_valid;
  wire       [63:0]   streamFifo_5_io_pop_payload;
  wire       [4:0]    streamFifo_5_io_occupancy;
  wire       [4:0]    streamFifo_5_io_availability;
  wire                axisDataConverter_13_inStream_ready;
  wire                axisDataConverter_13_outStream_valid;
  wire       [7:0]    axisDataConverter_13_outStream_payload;
  wire                streamFifo_6_io_push_ready;
  wire                streamFifo_6_io_pop_valid;
  wire       [63:0]   streamFifo_6_io_pop_payload;
  wire       [4:0]    streamFifo_6_io_occupancy;
  wire       [4:0]    streamFifo_6_io_availability;
  wire                axisDataConverter_14_inStream_ready;
  wire                axisDataConverter_14_outStream_valid;
  wire       [7:0]    axisDataConverter_14_outStream_payload;
  wire                streamFifo_7_io_push_ready;
  wire                streamFifo_7_io_pop_valid;
  wire       [63:0]   streamFifo_7_io_pop_payload;
  wire       [4:0]    streamFifo_7_io_occupancy;
  wire       [4:0]    streamFifo_7_io_availability;
  wire                axisDataConverter_15_inStream_ready;
  wire                axisDataConverter_15_outStream_valid;
  wire       [7:0]    axisDataConverter_15_outStream_payload;
  wire                padding_1_sData_ready;
  wire                padding_1_mData_valid;
  wire       [63:0]   padding_1_mData_payload;
  wire       [15:0]   padding_1_row_colNumOut;
  wire                padding_1_last;
  reg        [7:0]    OutData_Switch;
  reg                 Switch_Reset;
  wire                TestValid_Signal_0;
  wire                TestValid_Signal_1;
  wire                TestValid_Signal_2;
  wire                TestValid_Signal_3;
  wire                TestValid_Signal_4;
  wire                TestValid_Signal_5;
  wire                TestValid_Signal_6;
  wire                TestValid_Signal_7;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_8_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_8_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_9_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_9_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_10_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_10_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_11_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_11_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_12_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_12_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_13_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_13_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_14_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_14_outStream_valid_regNext;
  reg        [7:0]    SubModule_Img2Col_axisDataConverter_15_outStream_payload_regNext;
  reg                 SubModule_Img2Col_axisDataConverter_15_outStream_valid_regNext;
  reg                 SubModule_Img2Col_SubModule_LayerEnd_delay_1;
  reg                 SubModule_Img2Col_SubModule_LayerEnd_delay_2;
  reg                 SubModule_Img2Col_SubModule_LayerEnd_delay_3;

  Img2Col_Top SubModule (
    .start                          (start                               ), //i
    .sData_valid                    (padding_1_mData_valid               ), //i
    .sData_ready                    (SubModule_sData_ready               ), //o
    .sData_payload                  (padding_1_mData_payload[63:0]       ), //i
    .mData                          (SubModule_mData[63:0]               ), //o
    .mReady                         (streamFifo_io_push_ready            ), //i
    .mValid                         (SubModule_mValid                    ), //o
    .Fifo_Clear                     (SubModule_Fifo_Clear                ), //i
    .mLast                          (SubModule_mLast                     ), //o
    .Stride                         (Stride[4:0]                         ), //i
    .Kernel_Size                    (Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Window_Size[15:0]                   ), //i
    .InFeature_Size                 (padding_1_row_colNumOut[15:0]       ), //i
    .InFeature_Channel              (InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (SubModule_OutFeature_Channel[15:0]  ), //i
    .OutFeature_Size                (OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (InCol_Count_Times[15:0]             ), //i
    .OutRow_Count_Times             (OutRow_Count_Times[15:0]            ), //i
    .OutFeature_Channel_Count_Times (OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Sliding_Size[12:0]                  ), //i
    .Test_Signal                    (SubModule_Test_Signal               ), //o
    .Test_Generate_Period           (SubModule_Test_Generate_Period[15:0]), //i
    .Test_End                       (SubModule_Test_End                  ), //o
    .Raddr_Valid                    (SubModule_Raddr_Valid               ), //o
    .LayerEnd                       (SubModule_LayerEnd                  ), //o
    .SA_Row_Cnt_Valid               (SubModule_SA_Row_Cnt_Valid          ), //o
    .clk                            (clk                                 ), //i
    .reset                          (reset                               )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo (
    .io_push_valid   (streamFifo_io_push_valid          ), //i
    .io_push_ready   (streamFifo_io_push_ready          ), //o
    .io_push_payload (SubModule_mData[63:0]             ), //i
    .io_pop_valid    (streamFifo_io_pop_valid           ), //o
    .io_pop_ready    (axisDataConverter_8_inStream_ready), //i
    .io_pop_payload  (streamFifo_io_pop_payload[63:0]   ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_io_occupancy[4:0]      ), //o
    .io_availability (streamFifo_io_availability[4:0]   ), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  AxisDataConverter axisDataConverter_8 (
    .inStream_valid    (streamFifo_io_pop_valid                   ), //i
    .inStream_ready    (axisDataConverter_8_inStream_ready        ), //o
    .inStream_payload  (streamFifo_io_pop_payload[63:0]           ), //i
    .outStream_valid   (axisDataConverter_8_outStream_valid       ), //o
    .outStream_ready   (1'b1                                      ), //i
    .outStream_payload (axisDataConverter_8_outStream_payload[7:0]), //o
    .clk               (clk                                       ), //i
    .reset             (reset                                     )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_1 (
    .io_push_valid   (streamFifo_1_io_push_valid        ), //i
    .io_push_ready   (streamFifo_1_io_push_ready        ), //o
    .io_push_payload (SubModule_mData[63:0]             ), //i
    .io_pop_valid    (streamFifo_1_io_pop_valid         ), //o
    .io_pop_ready    (axisDataConverter_9_inStream_ready), //i
    .io_pop_payload  (streamFifo_1_io_pop_payload[63:0] ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_1_io_occupancy[4:0]    ), //o
    .io_availability (streamFifo_1_io_availability[4:0] ), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  AxisDataConverter axisDataConverter_9 (
    .inStream_valid    (streamFifo_1_io_pop_valid                 ), //i
    .inStream_ready    (axisDataConverter_9_inStream_ready        ), //o
    .inStream_payload  (streamFifo_1_io_pop_payload[63:0]         ), //i
    .outStream_valid   (axisDataConverter_9_outStream_valid       ), //o
    .outStream_ready   (1'b1                                      ), //i
    .outStream_payload (axisDataConverter_9_outStream_payload[7:0]), //o
    .clk               (clk                                       ), //i
    .reset             (reset                                     )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_2 (
    .io_push_valid   (streamFifo_2_io_push_valid         ), //i
    .io_push_ready   (streamFifo_2_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_2_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_10_inStream_ready), //i
    .io_pop_payload  (streamFifo_2_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_2_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_2_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_10 (
    .inStream_valid    (streamFifo_2_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_10_inStream_ready        ), //o
    .inStream_payload  (streamFifo_2_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_10_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_10_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_3 (
    .io_push_valid   (streamFifo_3_io_push_valid         ), //i
    .io_push_ready   (streamFifo_3_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_3_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_11_inStream_ready), //i
    .io_pop_payload  (streamFifo_3_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_3_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_3_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_11 (
    .inStream_valid    (streamFifo_3_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_11_inStream_ready        ), //o
    .inStream_payload  (streamFifo_3_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_11_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_11_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_4 (
    .io_push_valid   (streamFifo_4_io_push_valid         ), //i
    .io_push_ready   (streamFifo_4_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_4_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_12_inStream_ready), //i
    .io_pop_payload  (streamFifo_4_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_4_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_4_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_12 (
    .inStream_valid    (streamFifo_4_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_12_inStream_ready        ), //o
    .inStream_payload  (streamFifo_4_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_12_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_12_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_5 (
    .io_push_valid   (streamFifo_5_io_push_valid         ), //i
    .io_push_ready   (streamFifo_5_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_5_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_13_inStream_ready), //i
    .io_pop_payload  (streamFifo_5_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_5_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_5_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_13 (
    .inStream_valid    (streamFifo_5_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_13_inStream_ready        ), //o
    .inStream_payload  (streamFifo_5_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_13_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_13_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_6 (
    .io_push_valid   (streamFifo_6_io_push_valid         ), //i
    .io_push_ready   (streamFifo_6_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_6_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_14_inStream_ready), //i
    .io_pop_payload  (streamFifo_6_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_6_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_6_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_14 (
    .inStream_valid    (streamFifo_6_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_14_inStream_ready        ), //o
    .inStream_payload  (streamFifo_6_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_14_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_14_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_7 (
    .io_push_valid   (streamFifo_7_io_push_valid         ), //i
    .io_push_ready   (streamFifo_7_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_7_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_15_inStream_ready), //i
    .io_pop_payload  (streamFifo_7_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_7_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_7_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_15 (
    .inStream_valid    (streamFifo_7_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_15_inStream_ready        ), //o
    .inStream_payload  (streamFifo_7_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_15_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_15_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Padding padding_1 (
    .sData_valid   (s_axis_s2mm_tvalid           ), //i
    .sData_ready   (padding_1_sData_ready        ), //o
    .sData_payload (s_axis_s2mm_tdata[63:0]      ), //i
    .mData_valid   (padding_1_mData_valid        ), //o
    .mData_ready   (SubModule_sData_ready        ), //i
    .mData_payload (padding_1_mData_payload[63:0]), //o
    .enPadding     (enPadding                    ), //i
    .channelIn     (InFeature_Channel[15:0]      ), //i
    .start         (start                        ), //i
    .row_colNumIn  (InFeature_Size[15:0]         ), //i
    .row_colNumOut (padding_1_row_colNumOut[15:0]), //o
    .zeroDara      (zeroDara[7:0]                ), //i
    .zeroNum       (zeroNum[1:0]                 ), //i
    .last          (padding_1_last               ), //o
    .clk           (clk                          ), //i
    .reset         (reset                        )  //i
  );
  assign streamFifo_io_push_valid = (OutData_Switch[0] && SubModule_mValid);
  always @(*) begin
    mData[7 : 0] = SubModule_Img2Col_axisDataConverter_8_outStream_payload_regNext;
    mData[15 : 8] = SubModule_Img2Col_axisDataConverter_9_outStream_payload_regNext;
    mData[23 : 16] = SubModule_Img2Col_axisDataConverter_10_outStream_payload_regNext;
    mData[31 : 24] = SubModule_Img2Col_axisDataConverter_11_outStream_payload_regNext;
    mData[39 : 32] = SubModule_Img2Col_axisDataConverter_12_outStream_payload_regNext;
    mData[47 : 40] = SubModule_Img2Col_axisDataConverter_13_outStream_payload_regNext;
    mData[55 : 48] = SubModule_Img2Col_axisDataConverter_14_outStream_payload_regNext;
    mData[63 : 56] = SubModule_Img2Col_axisDataConverter_15_outStream_payload_regNext;
  end

  always @(*) begin
    mValid[0] = SubModule_Img2Col_axisDataConverter_8_outStream_valid_regNext;
    mValid[1] = SubModule_Img2Col_axisDataConverter_9_outStream_valid_regNext;
    mValid[2] = SubModule_Img2Col_axisDataConverter_10_outStream_valid_regNext;
    mValid[3] = SubModule_Img2Col_axisDataConverter_11_outStream_valid_regNext;
    mValid[4] = SubModule_Img2Col_axisDataConverter_12_outStream_valid_regNext;
    mValid[5] = SubModule_Img2Col_axisDataConverter_13_outStream_valid_regNext;
    mValid[6] = SubModule_Img2Col_axisDataConverter_14_outStream_valid_regNext;
    mValid[7] = SubModule_Img2Col_axisDataConverter_15_outStream_valid_regNext;
  end

  assign streamFifo_1_io_push_valid = (OutData_Switch[1] && SubModule_mValid);
  assign streamFifo_2_io_push_valid = (OutData_Switch[2] && SubModule_mValid);
  assign streamFifo_3_io_push_valid = (OutData_Switch[3] && SubModule_mValid);
  assign streamFifo_4_io_push_valid = (OutData_Switch[4] && SubModule_mValid);
  assign streamFifo_5_io_push_valid = (OutData_Switch[5] && SubModule_mValid);
  assign streamFifo_6_io_push_valid = (OutData_Switch[6] && SubModule_mValid);
  assign streamFifo_7_io_push_valid = (OutData_Switch[7] && SubModule_mValid);
  assign Raddr_Valid = axisDataConverter_8_outStream_valid;
  assign SubModule_Fifo_Clear = (! streamFifo_io_pop_valid);
  assign LayerEnd = SubModule_Img2Col_SubModule_LayerEnd_delay_3;
  assign s_axis_s2mm_tready = padding_1_sData_ready;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      OutData_Switch <= 8'h01;
    end else begin
      if(Switch_Reset) begin
        OutData_Switch <= 8'h01;
      end else begin
        if(SubModule_mValid) begin
          OutData_Switch <= {OutData_Switch[6 : 0],OutData_Switch[7 : 7]};
        end
      end
    end
  end

  always @(posedge clk) begin
    Switch_Reset <= SubModule_SA_Row_Cnt_Valid;
    SubModule_Img2Col_axisDataConverter_8_outStream_payload_regNext <= axisDataConverter_8_outStream_payload;
    SubModule_Img2Col_axisDataConverter_8_outStream_valid_regNext <= axisDataConverter_8_outStream_valid;
    SubModule_Img2Col_axisDataConverter_9_outStream_payload_regNext <= axisDataConverter_9_outStream_payload;
    SubModule_Img2Col_axisDataConverter_9_outStream_valid_regNext <= axisDataConverter_9_outStream_valid;
    SubModule_Img2Col_axisDataConverter_10_outStream_payload_regNext <= axisDataConverter_10_outStream_payload;
    SubModule_Img2Col_axisDataConverter_10_outStream_valid_regNext <= axisDataConverter_10_outStream_valid;
    SubModule_Img2Col_axisDataConverter_11_outStream_payload_regNext <= axisDataConverter_11_outStream_payload;
    SubModule_Img2Col_axisDataConverter_11_outStream_valid_regNext <= axisDataConverter_11_outStream_valid;
    SubModule_Img2Col_axisDataConverter_12_outStream_payload_regNext <= axisDataConverter_12_outStream_payload;
    SubModule_Img2Col_axisDataConverter_12_outStream_valid_regNext <= axisDataConverter_12_outStream_valid;
    SubModule_Img2Col_axisDataConverter_13_outStream_payload_regNext <= axisDataConverter_13_outStream_payload;
    SubModule_Img2Col_axisDataConverter_13_outStream_valid_regNext <= axisDataConverter_13_outStream_valid;
    SubModule_Img2Col_axisDataConverter_14_outStream_payload_regNext <= axisDataConverter_14_outStream_payload;
    SubModule_Img2Col_axisDataConverter_14_outStream_valid_regNext <= axisDataConverter_14_outStream_valid;
    SubModule_Img2Col_axisDataConverter_15_outStream_payload_regNext <= axisDataConverter_15_outStream_payload;
    SubModule_Img2Col_axisDataConverter_15_outStream_valid_regNext <= axisDataConverter_15_outStream_valid;
    SubModule_Img2Col_SubModule_LayerEnd_delay_1 <= SubModule_LayerEnd;
    SubModule_Img2Col_SubModule_LayerEnd_delay_2 <= SubModule_Img2Col_SubModule_LayerEnd_delay_1;
    SubModule_Img2Col_SubModule_LayerEnd_delay_3 <= SubModule_Img2Col_SubModule_LayerEnd_delay_2;
  end


endmodule

module ConvQuant (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  input      [15:0]   OutMatrix_Col,
  input               LayerEnd,
  output              QuantPara_Cached,
  input      [31:0]   dataIn_0,
  input      [31:0]   dataIn_1,
  input      [31:0]   dataIn_2,
  input      [31:0]   dataIn_3,
  input      [31:0]   dataIn_4,
  input      [31:0]   dataIn_5,
  input      [31:0]   dataIn_6,
  input      [31:0]   dataIn_7,
  output     [63:0]   dataOut,
  input      [7:0]    zeroIn,
  input               SAOutput_Valid,
  output              Quant_State,
  input               clk,
  input               reset
);
  localparam ConvQuan_ENUM_IDLE = 6'd1;
  localparam ConvQuan_ENUM_INIT = 6'd2;
  localparam ConvQuan_ENUM_LOAD_BIAS = 6'd4;
  localparam ConvQuan_ENUM_LOAD_SCALE = 6'd8;
  localparam ConvQuan_ENUM_LOAD_SHIFT = 6'd16;
  localparam ConvQuan_ENUM_QUANT = 6'd32;

  wire                BiasCache_ena;
  wire                ScaleCache_ena;
  wire                ShiftCache_ena;
  wire       [31:0]   BiasCache_doutb;
  wire       [31:0]   ScaleCache_doutb;
  wire       [31:0]   ShiftCache_doutb;
  wire       [63:0]   Quant_Module_dataOut;
  wire       [14:0]   _zz_InMatrixCol_Cnt_valid;
  wire       [14:0]   _zz_InMatrixCol_Cnt_valid_1;
  wire       [14:0]   _zz_InMatrixCol_Cnt_valid_2;
  wire       [15:0]   _zz_OutCol_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_valid_1;
  reg                 start_regNext;
  wire                when_Quan_l36;
  reg        [5:0]    Fsm_currentState;
  reg        [5:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Bias_Loaded;
  wire                Fsm_Scale_Loaded;
  wire                Fsm_Shift_Loaded;
  wire                Fsm_LayerEnd;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                sData_fire;
  reg        [8:0]    InMatrixCol_Cnt_count;
  wire                InMatrixCol_Cnt_valid;
  reg        [9:0]    OutCol_Cnt_count;
  wire                OutCol_Cnt_valid;
  wire       [63:0]   Debug_dataOut;
  wire       [0:0]    Debug_SAOutput_Valid;
  `ifndef SYNTHESIS
  reg [79:0] Fsm_currentState_string;
  reg [79:0] Fsm_nextState_string;
  `endif


  assign _zz_InMatrixCol_Cnt_valid = {6'd0, InMatrixCol_Cnt_count};
  assign _zz_InMatrixCol_Cnt_valid_1 = (_zz_InMatrixCol_Cnt_valid_2 - 15'h0001);
  assign _zz_InMatrixCol_Cnt_valid_2 = (OutMatrix_Col >>> 1);
  assign _zz_OutCol_Cnt_valid = {6'd0, OutCol_Cnt_count};
  assign _zz_OutCol_Cnt_valid_1 = (OutMatrix_Col - 16'h0001);
  ConvQuan_Bram BiasCache (
    .clka  (clk                       ), //i
    .addra (InMatrixCol_Cnt_count[8:0]), //i
    .dina  (sData_payload[63:0]       ), //i
    .ena   (BiasCache_ena             ), //i
    .wea   (1'b1                      ), //i
    .addrb (OutCol_Cnt_count[9:0]     ), //i
    .doutb (BiasCache_doutb[31:0]     ), //o
    .clkb  (clk                       )  //i
  );
  ConvQuan_Bram ScaleCache (
    .clka  (clk                       ), //i
    .addra (InMatrixCol_Cnt_count[8:0]), //i
    .dina  (sData_payload[63:0]       ), //i
    .ena   (ScaleCache_ena            ), //i
    .wea   (1'b1                      ), //i
    .addrb (OutCol_Cnt_count[9:0]     ), //i
    .doutb (ScaleCache_doutb[31:0]    ), //o
    .clkb  (clk                       )  //i
  );
  ConvQuan_Bram ShiftCache (
    .clka  (clk                       ), //i
    .addra (InMatrixCol_Cnt_count[8:0]), //i
    .dina  (sData_payload[63:0]       ), //i
    .ena   (ShiftCache_ena            ), //i
    .wea   (1'b1                      ), //i
    .addrb (OutCol_Cnt_count[9:0]     ), //i
    .doutb (ShiftCache_doutb[31:0]    ), //o
    .clkb  (clk                       )  //i
  );
  Quan Quant_Module (
    .dataIn_0 (dataIn_0[31:0]            ), //i
    .dataIn_1 (dataIn_1[31:0]            ), //i
    .dataIn_2 (dataIn_2[31:0]            ), //i
    .dataIn_3 (dataIn_3[31:0]            ), //i
    .dataIn_4 (dataIn_4[31:0]            ), //i
    .dataIn_5 (dataIn_5[31:0]            ), //i
    .dataIn_6 (dataIn_6[31:0]            ), //i
    .dataIn_7 (dataIn_7[31:0]            ), //i
    .biasIn   (BiasCache_doutb[31:0]     ), //i
    .scaleIn  (ScaleCache_doutb[31:0]    ), //i
    .shiftIn  (ShiftCache_doutb[31:0]    ), //i
    .zeroIn   (zeroIn[7:0]               ), //i
    .dataOut  (Quant_Module_dataOut[63:0]), //o
    .clk      (clk                       ), //i
    .reset    (reset                     )  //i
  );
  ila_QuantModule xil_ila (
    .probe0 (Debug_dataOut[63:0] ), //i
    .probe1 (Debug_SAOutput_Valid), //i
    .clk    (clk                 )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      ConvQuan_ENUM_IDLE : Fsm_currentState_string = "IDLE      ";
      ConvQuan_ENUM_INIT : Fsm_currentState_string = "INIT      ";
      ConvQuan_ENUM_LOAD_BIAS : Fsm_currentState_string = "LOAD_BIAS ";
      ConvQuan_ENUM_LOAD_SCALE : Fsm_currentState_string = "LOAD_SCALE";
      ConvQuan_ENUM_LOAD_SHIFT : Fsm_currentState_string = "LOAD_SHIFT";
      ConvQuan_ENUM_QUANT : Fsm_currentState_string = "QUANT     ";
      default : Fsm_currentState_string = "??????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      ConvQuan_ENUM_IDLE : Fsm_nextState_string = "IDLE      ";
      ConvQuan_ENUM_INIT : Fsm_nextState_string = "INIT      ";
      ConvQuan_ENUM_LOAD_BIAS : Fsm_nextState_string = "LOAD_BIAS ";
      ConvQuan_ENUM_LOAD_SCALE : Fsm_nextState_string = "LOAD_SCALE";
      ConvQuan_ENUM_LOAD_SHIFT : Fsm_nextState_string = "LOAD_SHIFT";
      ConvQuan_ENUM_QUANT : Fsm_nextState_string = "QUANT     ";
      default : Fsm_nextState_string = "??????????";
    endcase
  end
  `endif

  assign when_Quan_l36 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & ConvQuan_ENUM_IDLE) == ConvQuan_ENUM_IDLE) : begin
        if(when_Quan_l36) begin
          Fsm_nextState = ConvQuan_ENUM_INIT;
        end else begin
          Fsm_nextState = ConvQuan_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & ConvQuan_ENUM_INIT) == ConvQuan_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = ConvQuan_ENUM_LOAD_BIAS;
        end else begin
          Fsm_nextState = ConvQuan_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & ConvQuan_ENUM_LOAD_BIAS) == ConvQuan_ENUM_LOAD_BIAS) : begin
        if(Fsm_Bias_Loaded) begin
          Fsm_nextState = ConvQuan_ENUM_LOAD_SCALE;
        end else begin
          Fsm_nextState = ConvQuan_ENUM_LOAD_BIAS;
        end
      end
      (((Fsm_currentState) & ConvQuan_ENUM_LOAD_SCALE) == ConvQuan_ENUM_LOAD_SCALE) : begin
        if(Fsm_Scale_Loaded) begin
          Fsm_nextState = ConvQuan_ENUM_LOAD_SHIFT;
        end else begin
          Fsm_nextState = ConvQuan_ENUM_LOAD_SCALE;
        end
      end
      (((Fsm_currentState) & ConvQuan_ENUM_LOAD_SHIFT) == ConvQuan_ENUM_LOAD_SHIFT) : begin
        if(Fsm_Shift_Loaded) begin
          Fsm_nextState = ConvQuan_ENUM_QUANT;
        end else begin
          Fsm_nextState = ConvQuan_ENUM_LOAD_SHIFT;
        end
      end
      default : begin
        if(Fsm_LayerEnd) begin
          Fsm_nextState = ConvQuan_ENUM_IDLE;
        end else begin
          Fsm_nextState = ConvQuan_ENUM_QUANT;
        end
      end
    endcase
  end

  assign Quant_State = ((Fsm_currentState & ConvQuan_ENUM_QUANT) != 6'b000000);
  assign when_WaCounter_l19 = ((Fsm_currentState & ConvQuan_ENUM_INIT) != 6'b000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_LayerEnd = LayerEnd;
  assign sData_fire = (sData_valid && sData_ready);
  assign InMatrixCol_Cnt_valid = ((_zz_InMatrixCol_Cnt_valid == _zz_InMatrixCol_Cnt_valid_1) && sData_fire);
  assign Fsm_Bias_Loaded = (InMatrixCol_Cnt_valid && ((Fsm_currentState & ConvQuan_ENUM_LOAD_BIAS) != 6'b000000));
  assign Fsm_Scale_Loaded = (InMatrixCol_Cnt_valid && ((Fsm_currentState & ConvQuan_ENUM_LOAD_SCALE) != 6'b000000));
  assign Fsm_Shift_Loaded = (InMatrixCol_Cnt_valid && ((Fsm_currentState & ConvQuan_ENUM_LOAD_SHIFT) != 6'b000000));
  assign BiasCache_ena = (((Fsm_currentState & ConvQuan_ENUM_LOAD_BIAS) != 6'b000000) && sData_valid);
  assign ScaleCache_ena = (((Fsm_currentState & ConvQuan_ENUM_LOAD_SCALE) != 6'b000000) && sData_valid);
  assign ShiftCache_ena = (((Fsm_currentState & ConvQuan_ENUM_LOAD_SHIFT) != 6'b000000) && sData_valid);
  assign sData_ready = ((((Fsm_currentState & ConvQuan_ENUM_LOAD_BIAS) != 6'b000000) || ((Fsm_currentState & ConvQuan_ENUM_LOAD_SCALE) != 6'b000000)) || ((Fsm_currentState & ConvQuan_ENUM_LOAD_SHIFT) != 6'b000000));
  assign QuantPara_Cached = Fsm_Shift_Loaded;
  assign OutCol_Cnt_valid = ((_zz_OutCol_Cnt_valid == _zz_OutCol_Cnt_valid_1) && SAOutput_Valid);
  assign dataOut = Quant_Module_dataOut;
  assign Debug_dataOut = Quant_Module_dataOut;
  assign Debug_SAOutput_Valid = SAOutput_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= ConvQuan_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      InMatrixCol_Cnt_count <= 9'h0;
      OutCol_Cnt_count <= 10'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(sData_fire) begin
        if(InMatrixCol_Cnt_valid) begin
          InMatrixCol_Cnt_count <= 9'h0;
        end else begin
          InMatrixCol_Cnt_count <= (InMatrixCol_Cnt_count + 9'h001);
        end
      end
      if(SAOutput_Valid) begin
        if(OutCol_Cnt_valid) begin
          OutCol_Cnt_count <= 10'h0;
        end else begin
          OutCol_Cnt_count <= (OutCol_Cnt_count + 10'h001);
        end
      end
    end
  end


endmodule

module WeightCache_Stream (
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  input               start,
  input      [15:0]   Matrix_Row,
  input      [15:0]   Matrix_Col,
  output     [7:0]    mData_0,
  output     [7:0]    mData_1,
  output     [7:0]    mData_2,
  output     [7:0]    mData_3,
  output     [7:0]    mData_4,
  output     [7:0]    mData_5,
  output     [7:0]    mData_6,
  output     [7:0]    mData_7,
  input               Raddr_Valid,
  output              Weight_Cached,
  input               LayerEnd,
  output     [7:0]    MatrixCol_Switch,
  input               clk,
  input               reset
);

  wire                WeightCache_sData_ready;
  wire       [7:0]    WeightCache_mData_0;
  wire       [7:0]    WeightCache_mData_1;
  wire       [7:0]    WeightCache_mData_2;
  wire       [7:0]    WeightCache_mData_3;
  wire       [7:0]    WeightCache_mData_4;
  wire       [7:0]    WeightCache_mData_5;
  wire       [7:0]    WeightCache_mData_6;
  wire       [7:0]    WeightCache_mData_7;
  wire                WeightCache_Weight_Cached;
  wire       [7:0]    WeightCache_MatrixCol_Switch;

  Weight_Cache WeightCache (
    .start            (start                            ), //i
    .sData_valid      (s_axis_s2mm_tvalid               ), //i
    .sData_ready      (WeightCache_sData_ready          ), //o
    .sData_payload    (s_axis_s2mm_tdata[63:0]          ), //i
    .Matrix_Row       (Matrix_Row[15:0]                 ), //i
    .Matrix_Col       (Matrix_Col[15:0]                 ), //i
    .mData_0          (WeightCache_mData_0[7:0]         ), //o
    .mData_1          (WeightCache_mData_1[7:0]         ), //o
    .mData_2          (WeightCache_mData_2[7:0]         ), //o
    .mData_3          (WeightCache_mData_3[7:0]         ), //o
    .mData_4          (WeightCache_mData_4[7:0]         ), //o
    .mData_5          (WeightCache_mData_5[7:0]         ), //o
    .mData_6          (WeightCache_mData_6[7:0]         ), //o
    .mData_7          (WeightCache_mData_7[7:0]         ), //o
    .Raddr_Valid      (Raddr_Valid                      ), //i
    .Weight_Cached    (WeightCache_Weight_Cached        ), //o
    .LayerEnd         (LayerEnd                         ), //i
    .MatrixCol_Switch (WeightCache_MatrixCol_Switch[7:0]), //o
    .clk              (clk                              ), //i
    .reset            (reset                            )  //i
  );
  assign mData_0 = WeightCache_mData_0;
  assign mData_1 = WeightCache_mData_1;
  assign mData_2 = WeightCache_mData_2;
  assign mData_3 = WeightCache_mData_3;
  assign mData_4 = WeightCache_mData_4;
  assign mData_5 = WeightCache_mData_5;
  assign mData_6 = WeightCache_mData_6;
  assign mData_7 = WeightCache_mData_7;
  assign Weight_Cached = WeightCache_Weight_Cached;
  assign MatrixCol_Switch = WeightCache_MatrixCol_Switch;
  assign s_axis_s2mm_tready = WeightCache_sData_ready;

endmodule

module Axis_Switch_M2S (
  input      [1:0]    Switch,
  output reg [63:0]   m0_axis_mm2s_tdata,
  output reg [7:0]    m0_axis_mm2s_tkeep,
  output reg          m0_axis_mm2s_tlast,
  input               m0_axis_mm2s_tready,
  output reg          m0_axis_mm2s_tvalid,
  input      [63:0]   s_0_axis_s2mm_tdata,
  input      [7:0]    s_0_axis_s2mm_tkeep,
  input               s_0_axis_s2mm_tlast,
  output reg          s_0_axis_s2mm_tready,
  input               s_0_axis_s2mm_tvalid,
  input      [63:0]   s_1_axis_s2mm_tdata,
  input      [7:0]    s_1_axis_s2mm_tkeep,
  input               s_1_axis_s2mm_tlast,
  output reg          s_1_axis_s2mm_tready,
  input               s_1_axis_s2mm_tvalid
);

  wire                when_SA_3D_SwitchVersion_l40;
  wire                when_SA_3D_SwitchVersion_l40_1;

  always @(*) begin
    s_0_axis_s2mm_tready = 1'b0;
    if(when_SA_3D_SwitchVersion_l40) begin
      s_0_axis_s2mm_tready = m0_axis_mm2s_tready;
    end
  end

  always @(*) begin
    s_1_axis_s2mm_tready = 1'b0;
    if(when_SA_3D_SwitchVersion_l40_1) begin
      s_1_axis_s2mm_tready = m0_axis_mm2s_tready;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tdata = 64'h0;
    if(when_SA_3D_SwitchVersion_l40) begin
      m0_axis_mm2s_tdata = s_0_axis_s2mm_tdata;
    end
    if(when_SA_3D_SwitchVersion_l40_1) begin
      m0_axis_mm2s_tdata = s_1_axis_s2mm_tdata;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tkeep = 8'h0;
    if(when_SA_3D_SwitchVersion_l40) begin
      m0_axis_mm2s_tkeep = s_0_axis_s2mm_tkeep;
    end
    if(when_SA_3D_SwitchVersion_l40_1) begin
      m0_axis_mm2s_tkeep = s_1_axis_s2mm_tkeep;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tlast = 1'b0;
    if(when_SA_3D_SwitchVersion_l40) begin
      m0_axis_mm2s_tlast = s_0_axis_s2mm_tlast;
    end
    if(when_SA_3D_SwitchVersion_l40_1) begin
      m0_axis_mm2s_tlast = s_1_axis_s2mm_tlast;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tvalid = 1'b0;
    if(when_SA_3D_SwitchVersion_l40) begin
      m0_axis_mm2s_tvalid = s_0_axis_s2mm_tvalid;
    end
    if(when_SA_3D_SwitchVersion_l40_1) begin
      m0_axis_mm2s_tvalid = s_1_axis_s2mm_tvalid;
    end
  end

  assign when_SA_3D_SwitchVersion_l40 = Switch[0];
  assign when_SA_3D_SwitchVersion_l40_1 = Switch[1];

endmodule

module Axis_Switch_S2M (
  input      [1:0]    Switch,
  input      [63:0]   s0_axis_s2mm_tdata,
  input      [7:0]    s0_axis_s2mm_tkeep,
  input               s0_axis_s2mm_tlast,
  output reg          s0_axis_s2mm_tready,
  input               s0_axis_s2mm_tvalid,
  output reg [63:0]   m_0_axis_mm2s_tdata,
  output     [7:0]    m_0_axis_mm2s_tkeep,
  output reg          m_0_axis_mm2s_tlast,
  input               m_0_axis_mm2s_tready,
  output reg          m_0_axis_mm2s_tvalid,
  output reg [63:0]   m_1_axis_mm2s_tdata,
  output     [7:0]    m_1_axis_mm2s_tkeep,
  output reg          m_1_axis_mm2s_tlast,
  input               m_1_axis_mm2s_tready,
  output reg          m_1_axis_mm2s_tvalid
);

  wire                when_SA_3D_SwitchVersion_l72;
  wire                when_SA_3D_SwitchVersion_l72_1;

  assign m_0_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_1_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  always @(*) begin
    s0_axis_s2mm_tready = 1'b0;
    if(when_SA_3D_SwitchVersion_l72) begin
      s0_axis_s2mm_tready = m_0_axis_mm2s_tready;
    end
    if(when_SA_3D_SwitchVersion_l72_1) begin
      s0_axis_s2mm_tready = m_1_axis_mm2s_tready;
    end
  end

  assign when_SA_3D_SwitchVersion_l72 = Switch[0];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72) begin
      m_0_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_0_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72) begin
      m_0_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_0_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72) begin
      m_0_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_0_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_SA_3D_SwitchVersion_l72_1 = Switch[1];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_1) begin
      m_1_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_1_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_1) begin
      m_1_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_1_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_1) begin
      m_1_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_1_axis_mm2s_tvalid = 1'b0;
    end
  end


endmodule

module Compute_DataIn_Switch (
  input      [4:0]    Switch,
  input      [63:0]   s0_axis_s2mm_tdata,
  input      [7:0]    s0_axis_s2mm_tkeep,
  input               s0_axis_s2mm_tlast,
  output reg          s0_axis_s2mm_tready,
  input               s0_axis_s2mm_tvalid,
  output reg [63:0]   m_0_axis_mm2s_tdata,
  output     [7:0]    m_0_axis_mm2s_tkeep,
  output reg          m_0_axis_mm2s_tlast,
  input               m_0_axis_mm2s_tready,
  output reg          m_0_axis_mm2s_tvalid,
  output reg [63:0]   m_1_axis_mm2s_tdata,
  output     [7:0]    m_1_axis_mm2s_tkeep,
  output reg          m_1_axis_mm2s_tlast,
  input               m_1_axis_mm2s_tready,
  output reg          m_1_axis_mm2s_tvalid,
  output reg [63:0]   m_2_axis_mm2s_tdata,
  output     [7:0]    m_2_axis_mm2s_tkeep,
  output reg          m_2_axis_mm2s_tlast,
  input               m_2_axis_mm2s_tready,
  output reg          m_2_axis_mm2s_tvalid,
  output reg [63:0]   m_3_axis_mm2s_tdata,
  output     [7:0]    m_3_axis_mm2s_tkeep,
  output reg          m_3_axis_mm2s_tlast,
  input               m_3_axis_mm2s_tready,
  output reg          m_3_axis_mm2s_tvalid,
  output reg [63:0]   m_4_axis_mm2s_tdata,
  output     [7:0]    m_4_axis_mm2s_tkeep,
  output reg          m_4_axis_mm2s_tlast,
  input               m_4_axis_mm2s_tready,
  output reg          m_4_axis_mm2s_tvalid
);

  wire                when_SA_3D_SwitchVersion_l72;
  wire                when_SA_3D_SwitchVersion_l72_1;
  wire                when_SA_3D_SwitchVersion_l72_2;
  wire                when_SA_3D_SwitchVersion_l72_3;
  wire                when_SA_3D_SwitchVersion_l72_4;

  assign m_0_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_1_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_2_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_3_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_4_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  always @(*) begin
    s0_axis_s2mm_tready = 1'b0;
    if(when_SA_3D_SwitchVersion_l72) begin
      s0_axis_s2mm_tready = m_0_axis_mm2s_tready;
    end
    if(when_SA_3D_SwitchVersion_l72_1) begin
      s0_axis_s2mm_tready = m_1_axis_mm2s_tready;
    end
    if(when_SA_3D_SwitchVersion_l72_2) begin
      s0_axis_s2mm_tready = m_2_axis_mm2s_tready;
    end
    if(when_SA_3D_SwitchVersion_l72_3) begin
      s0_axis_s2mm_tready = m_3_axis_mm2s_tready;
    end
    if(when_SA_3D_SwitchVersion_l72_4) begin
      s0_axis_s2mm_tready = m_4_axis_mm2s_tready;
    end
  end

  assign when_SA_3D_SwitchVersion_l72 = Switch[0];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72) begin
      m_0_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_0_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72) begin
      m_0_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_0_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72) begin
      m_0_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_0_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_SA_3D_SwitchVersion_l72_1 = Switch[1];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_1) begin
      m_1_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_1_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_1) begin
      m_1_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_1_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_1) begin
      m_1_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_1_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_SA_3D_SwitchVersion_l72_2 = Switch[2];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_2) begin
      m_2_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_2_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_2) begin
      m_2_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_2_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_2) begin
      m_2_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_2_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_SA_3D_SwitchVersion_l72_3 = Switch[3];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_3) begin
      m_3_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_3_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_3) begin
      m_3_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_3_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_3) begin
      m_3_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_3_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_SA_3D_SwitchVersion_l72_4 = Switch[4];
  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_4) begin
      m_4_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_4_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_4) begin
      m_4_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_4_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_SA_3D_SwitchVersion_l72_4) begin
      m_4_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_4_axis_mm2s_tvalid = 1'b0;
    end
  end


endmodule

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Converter replaced by ConvOutput_Converter

//ConvOutput_Fifo replaced by ConvOutput_Fifo

module ConvOutput_Converter (
  input               inStream_valid,
  output              inStream_ready,
  input      [7:0]    inStream_payload,
  output              outStream_valid,
  input               outStream_ready,
  output     [63:0]   outStream_payload,
  input               clk,
  input               reset
);

  wire       [2:0]    _zz__zz_inStream_ready_1;
  wire       [0:0]    _zz__zz_inStream_ready_1_1;
  wire       [47:0]   _zz__zz_outStream_payload;
  wire       [63:0]   _zz_outStream_payload_1;
  wire       [63:0]   _zz_outStream_payload_2;
  wire                inStream_fire;
  reg                 _zz_inStream_ready;
  reg        [2:0]    _zz_inStream_ready_1;
  reg        [2:0]    _zz_inStream_ready_2;
  wire                _zz_inStream_ready_3;
  reg        [55:0]   _zz_outStream_payload;
  wire                inStream_fire_1;

  assign _zz__zz_inStream_ready_1_1 = _zz_inStream_ready;
  assign _zz__zz_inStream_ready_1 = {2'd0, _zz__zz_inStream_ready_1_1};
  assign _zz__zz_outStream_payload = (_zz_outStream_payload >>> 8);
  assign _zz_outStream_payload_2 = {inStream_payload,_zz_outStream_payload};
  assign _zz_outStream_payload_1 = _zz_outStream_payload_2;
  assign inStream_fire = (inStream_valid && inStream_ready);
  always @(*) begin
    _zz_inStream_ready = 1'b0;
    if(inStream_fire) begin
      _zz_inStream_ready = 1'b1;
    end
  end

  assign _zz_inStream_ready_3 = (_zz_inStream_ready_2 == 3'b111);
  always @(*) begin
    _zz_inStream_ready_1 = (_zz_inStream_ready_2 + _zz__zz_inStream_ready_1);
    if(1'b0) begin
      _zz_inStream_ready_1 = 3'b000;
    end
  end

  assign inStream_fire_1 = (inStream_valid && inStream_ready);
  assign outStream_valid = (inStream_valid && _zz_inStream_ready_3);
  assign outStream_payload = _zz_outStream_payload_1;
  assign inStream_ready = (! ((! outStream_ready) && _zz_inStream_ready_3));
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      _zz_inStream_ready_2 <= 3'b000;
    end else begin
      _zz_inStream_ready_2 <= _zz_inStream_ready_1;
    end
  end

  always @(posedge clk) begin
    if(inStream_fire_1) begin
      _zz_outStream_payload <= {inStream_payload,_zz__zz_outStream_payload};
    end
  end


endmodule

module ConvOutput_Fifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [9:0]    io_occupancy,
  output     [9:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [8:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [8:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [8:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [8:0]    logic_pushPtr_valueNext;
  reg        [8:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [8:0]    logic_popPtr_valueNext;
  reg        [8:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1122;
  wire       [8:0]    logic_ptrDif;
  reg [63:0] logic_ram [0:511];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {8'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {8'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 9'h1ff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 9'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 9'h1ff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 9'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 9'h0;
      logic_popPtr_value <= 9'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module GemmOutput_Ctrl (
  input               ResetCnt,
  input               InData_Cnt_En,
  input               OutData_Cnt_En,
  input      [11:0]   MatrixCol,
  input      [19:0]   MatrixRow,
  output              Fsm_LayerEnd,
  output              Fsm_Data_AllOut,
  output              OutSwitch_Rotate,
  input               clk,
  input               reset
);

  wire       [11:0]   _zz_In_Col_Cnt_valid;
  wire       [19:0]   _zz_In_Row_Cnt_valid;
  wire       [19:0]   _zz_In_Row_Cnt_count_1;
  wire       [8:0]    _zz_Out_Col_Cnt_valid;
  wire       [8:0]    _zz_Out_Col_Cnt_valid_1;
  wire       [19:0]   _zz_Out_Row_Cnt_valid;
  reg        [11:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  wire       [3:0]    _zz_In_Row_Cnt_count;
  reg        [19:0]   In_Row_Cnt_count;
  reg                 In_Row_Cnt_valid;
  reg        [8:0]    Out_Col_Cnt_count;
  wire                Out_Col_Cnt_valid;
  reg        [19:0]   Out_Row_Cnt_count;
  wire                Out_Row_Cnt_valid;

  assign _zz_In_Col_Cnt_valid = (MatrixCol - 12'h001);
  assign _zz_In_Row_Cnt_valid = {16'd0, _zz_In_Row_Cnt_count};
  assign _zz_In_Row_Cnt_count_1 = {16'd0, _zz_In_Row_Cnt_count};
  assign _zz_Out_Col_Cnt_valid = (_zz_Out_Col_Cnt_valid_1 - 9'h001);
  assign _zz_Out_Col_Cnt_valid_1 = (MatrixCol >>> 3);
  assign _zz_Out_Row_Cnt_valid = (MatrixRow - 20'h00001);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == _zz_In_Col_Cnt_valid) && InData_Cnt_En);
  assign _zz_In_Row_Cnt_count = 4'b1000;
  always @(*) begin
    In_Row_Cnt_valid = ((In_Row_Cnt_count <= _zz_In_Row_Cnt_valid) && In_Col_Cnt_valid);
    if(ResetCnt) begin
      In_Row_Cnt_valid = 1'b0;
    end
  end

  assign Out_Col_Cnt_valid = ((Out_Col_Cnt_count == _zz_Out_Col_Cnt_valid) && OutData_Cnt_En);
  assign Out_Row_Cnt_valid = ((Out_Row_Cnt_count == _zz_Out_Row_Cnt_valid) && Out_Col_Cnt_valid);
  assign Fsm_Data_AllOut = Out_Row_Cnt_valid;
  assign OutSwitch_Rotate = Out_Col_Cnt_valid;
  assign Fsm_LayerEnd = In_Row_Cnt_valid;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      In_Col_Cnt_count <= 12'h0;
      Out_Col_Cnt_count <= 9'h0;
      Out_Row_Cnt_count <= 20'h0;
    end else begin
      if(InData_Cnt_En) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= 12'h0;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count + 12'h001);
        end
      end
      if(OutData_Cnt_En) begin
        if(Out_Col_Cnt_valid) begin
          Out_Col_Cnt_count <= 9'h0;
        end else begin
          Out_Col_Cnt_count <= (Out_Col_Cnt_count + 9'h001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        if(Out_Row_Cnt_valid) begin
          Out_Row_Cnt_count <= 20'h0;
        end else begin
          Out_Row_Cnt_count <= (Out_Row_Cnt_count + 20'h00001);
        end
      end
    end
  end

  always @(posedge clk) begin
    if(In_Col_Cnt_valid) begin
      if(In_Row_Cnt_valid) begin
        In_Row_Cnt_count <= MatrixRow;
      end else begin
        In_Row_Cnt_count <= (In_Row_Cnt_count - _zz_In_Row_Cnt_count_1);
      end
    end
    if(ResetCnt) begin
      In_Row_Cnt_count <= MatrixRow;
    end
  end


endmodule

module ConvOutput_Ctrl (
  input               ResetCnt,
  input               InData_Cnt_En,
  input               OutData_Cnt_En,
  input      [9:0]    OutChannel,
  input      [15:0]   OutFeatureSize,
  output              Fsm_LayerEnd,
  output              Fsm_Data_AllOut,
  output              OutSwitch_Rotate,
  output              OutSwitch_Reset,
  input               clk,
  input               reset
);

  wire       [9:0]    _zz_InChannel_Cnt_valid;
  wire       [9:0]    _zz_InChannel_Cnt_valid_1;
  wire       [15:0]   _zz_In_Col_Cnt_valid;
  wire       [15:0]   _zz_In_Col_Cnt_count_1;
  wire       [19:0]   _zz_In_Row_Cnt_valid;
  wire       [15:0]   _zz_In_Row_Cnt_valid_1;
  wire       [8:0]    _zz_OutChannel_Cnt_valid;
  wire       [6:0]    _zz_OutChannel_Cnt_valid_1;
  wire       [6:0]    _zz_OutChannel_Cnt_valid_2;
  wire       [19:0]   _zz_Out_Col_Cnt_valid;
  wire       [15:0]   _zz_Out_Col_Cnt_valid_1;
  wire       [19:0]   _zz_Out_Row_Cnt_valid;
  wire       [15:0]   _zz_Out_Row_Cnt_valid_1;
  reg        [9:0]    InChannel_Cnt_count;
  wire                InChannel_Cnt_valid;
  wire       [3:0]    _zz_In_Col_Cnt_count;
  reg        [15:0]   In_Col_Cnt_count;
  reg                 In_Col_Cnt_valid;
  reg        [19:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  reg        [8:0]    OutChannel_Cnt_count;
  wire                OutChannel_Cnt_valid;
  reg        [19:0]   Out_Col_Cnt_count;
  wire                Out_Col_Cnt_valid;
  reg        [19:0]   Out_Row_Cnt_count;
  wire                Out_Row_Cnt_valid;

  assign _zz_InChannel_Cnt_valid = (_zz_InChannel_Cnt_valid_1 >>> 0);
  assign _zz_InChannel_Cnt_valid_1 = (OutChannel - 10'h001);
  assign _zz_In_Col_Cnt_valid = {12'd0, _zz_In_Col_Cnt_count};
  assign _zz_In_Col_Cnt_count_1 = {12'd0, _zz_In_Col_Cnt_count};
  assign _zz_In_Row_Cnt_valid_1 = (OutFeatureSize - 16'h0001);
  assign _zz_In_Row_Cnt_valid = {4'd0, _zz_In_Row_Cnt_valid_1};
  assign _zz_OutChannel_Cnt_valid_1 = (_zz_OutChannel_Cnt_valid_2 - 7'h01);
  assign _zz_OutChannel_Cnt_valid = {2'd0, _zz_OutChannel_Cnt_valid_1};
  assign _zz_OutChannel_Cnt_valid_2 = (OutChannel >>> 3);
  assign _zz_Out_Col_Cnt_valid_1 = (OutFeatureSize - 16'h0001);
  assign _zz_Out_Col_Cnt_valid = {4'd0, _zz_Out_Col_Cnt_valid_1};
  assign _zz_Out_Row_Cnt_valid_1 = (OutFeatureSize - 16'h0001);
  assign _zz_Out_Row_Cnt_valid = {4'd0, _zz_Out_Row_Cnt_valid_1};
  assign InChannel_Cnt_valid = ((InChannel_Cnt_count == _zz_InChannel_Cnt_valid) && InData_Cnt_En);
  assign _zz_In_Col_Cnt_count = 4'b1000;
  always @(*) begin
    In_Col_Cnt_valid = ((In_Col_Cnt_count <= _zz_In_Col_Cnt_valid) && InChannel_Cnt_valid);
    if(ResetCnt) begin
      In_Col_Cnt_valid = 1'b0;
    end
  end

  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && In_Col_Cnt_valid);
  assign Fsm_LayerEnd = In_Row_Cnt_valid;
  assign OutChannel_Cnt_valid = ((OutChannel_Cnt_count == _zz_OutChannel_Cnt_valid) && OutData_Cnt_En);
  assign Out_Col_Cnt_valid = ((Out_Col_Cnt_count == _zz_Out_Col_Cnt_valid) && OutChannel_Cnt_valid);
  assign Out_Row_Cnt_valid = ((Out_Row_Cnt_count == _zz_Out_Row_Cnt_valid) && Out_Col_Cnt_valid);
  assign Fsm_Data_AllOut = Out_Row_Cnt_valid;
  assign OutSwitch_Reset = Out_Col_Cnt_valid;
  assign OutSwitch_Rotate = OutChannel_Cnt_valid;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      InChannel_Cnt_count <= 10'h0;
      In_Row_Cnt_count <= 20'h0;
      OutChannel_Cnt_count <= 9'h0;
      Out_Col_Cnt_count <= 20'h0;
      Out_Row_Cnt_count <= 20'h0;
    end else begin
      if(InData_Cnt_En) begin
        if(InChannel_Cnt_valid) begin
          InChannel_Cnt_count <= 10'h0;
        end else begin
          InChannel_Cnt_count <= (InChannel_Cnt_count + 10'h001);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 20'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 20'h00001);
        end
      end
      if(OutData_Cnt_En) begin
        if(OutChannel_Cnt_valid) begin
          OutChannel_Cnt_count <= 9'h0;
        end else begin
          OutChannel_Cnt_count <= (OutChannel_Cnt_count + 9'h001);
        end
      end
      if(OutChannel_Cnt_valid) begin
        if(Out_Col_Cnt_valid) begin
          Out_Col_Cnt_count <= 20'h0;
        end else begin
          Out_Col_Cnt_count <= (Out_Col_Cnt_count + 20'h00001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        if(Out_Row_Cnt_valid) begin
          Out_Row_Cnt_count <= 20'h0;
        end else begin
          Out_Row_Cnt_count <= (Out_Row_Cnt_count + 20'h00001);
        end
      end
    end
  end

  always @(posedge clk) begin
    if(InChannel_Cnt_valid) begin
      if(In_Col_Cnt_valid) begin
        In_Col_Cnt_count <= OutFeatureSize;
      end else begin
        In_Col_Cnt_count <= (In_Col_Cnt_count - _zz_In_Col_Cnt_count_1);
      end
    end
    if(ResetCnt) begin
      In_Col_Cnt_count <= OutFeatureSize;
    end
  end


endmodule

module SA_2D (
  input      [7:0]    io_MatrixA_0,
  input      [7:0]    io_MatrixA_1,
  input      [7:0]    io_MatrixA_2,
  input      [7:0]    io_MatrixA_3,
  input      [7:0]    io_MatrixA_4,
  input      [7:0]    io_MatrixA_5,
  input      [7:0]    io_MatrixA_6,
  input      [7:0]    io_MatrixA_7,
  input      [7:0]    io_MatrixB_0,
  input      [7:0]    io_MatrixB_1,
  input      [7:0]    io_MatrixB_2,
  input      [7:0]    io_MatrixB_3,
  input      [7:0]    io_MatrixB_4,
  input      [7:0]    io_MatrixB_5,
  input      [7:0]    io_MatrixB_6,
  input      [7:0]    io_MatrixB_7,
  input               io_A_Valid_0,
  input               io_A_Valid_1,
  input               io_A_Valid_2,
  input               io_A_Valid_3,
  input               io_A_Valid_4,
  input               io_A_Valid_5,
  input               io_A_Valid_6,
  input               io_A_Valid_7,
  input               io_B_Valid_0,
  input               io_B_Valid_1,
  input               io_B_Valid_2,
  input               io_B_Valid_3,
  input               io_B_Valid_4,
  input               io_B_Valid_5,
  input               io_B_Valid_6,
  input               io_B_Valid_7,
  input      [15:0]   io_signCount,
  output reg [31:0]   MatrixC_0,
  output reg [31:0]   MatrixC_1,
  output reg [31:0]   MatrixC_2,
  output reg [31:0]   MatrixC_3,
  output reg [31:0]   MatrixC_4,
  output reg [31:0]   MatrixC_5,
  output reg [31:0]   MatrixC_6,
  output reg [31:0]   MatrixC_7,
  output              C_Valid_0,
  output              C_Valid_1,
  output              C_Valid_2,
  output              C_Valid_3,
  output              C_Valid_4,
  output              C_Valid_5,
  output              C_Valid_6,
  output              C_Valid_7,
  input               start,
  input               clk,
  input               reset
);

  wire                PE00_valid;
  wire                PE01_valid;
  wire                PE02_valid;
  wire                PE03_valid;
  wire                PE04_valid;
  wire                PE05_valid;
  wire                PE06_valid;
  wire                PE07_valid;
  wire                PE10_valid;
  wire                PE11_valid;
  wire                PE12_valid;
  wire                PE13_valid;
  wire                PE14_valid;
  wire                PE15_valid;
  wire                PE16_valid;
  wire                PE17_valid;
  wire                PE20_valid;
  wire                PE21_valid;
  wire                PE22_valid;
  wire                PE23_valid;
  wire                PE24_valid;
  wire                PE25_valid;
  wire                PE26_valid;
  wire                PE27_valid;
  wire                PE30_valid;
  wire                PE31_valid;
  wire                PE32_valid;
  wire                PE33_valid;
  wire                PE34_valid;
  wire                PE35_valid;
  wire                PE36_valid;
  wire                PE37_valid;
  wire                PE40_valid;
  wire                PE41_valid;
  wire                PE42_valid;
  wire                PE43_valid;
  wire                PE44_valid;
  wire                PE45_valid;
  wire                PE46_valid;
  wire                PE47_valid;
  wire                PE50_valid;
  wire                PE51_valid;
  wire                PE52_valid;
  wire                PE53_valid;
  wire                PE54_valid;
  wire                PE55_valid;
  wire                PE56_valid;
  wire                PE57_valid;
  wire                PE60_valid;
  wire                PE61_valid;
  wire                PE62_valid;
  wire                PE63_valid;
  wire                PE64_valid;
  wire                PE65_valid;
  wire                PE66_valid;
  wire                PE67_valid;
  wire                PE70_valid;
  wire                PE71_valid;
  wire                PE72_valid;
  wire                PE73_valid;
  wire                PE74_valid;
  wire                PE75_valid;
  wire                PE76_valid;
  wire                PE77_valid;
  wire       [7:0]    PE00_acount;
  wire       [7:0]    PE00_bcount;
  wire       [31:0]   PE00_PE_OUT;
  wire                PE00_finish;
  wire       [7:0]    PE01_acount;
  wire       [7:0]    PE01_bcount;
  wire       [31:0]   PE01_PE_OUT;
  wire                PE01_finish;
  wire       [7:0]    PE02_acount;
  wire       [7:0]    PE02_bcount;
  wire       [31:0]   PE02_PE_OUT;
  wire                PE02_finish;
  wire       [7:0]    PE03_acount;
  wire       [7:0]    PE03_bcount;
  wire       [31:0]   PE03_PE_OUT;
  wire                PE03_finish;
  wire       [7:0]    PE04_acount;
  wire       [7:0]    PE04_bcount;
  wire       [31:0]   PE04_PE_OUT;
  wire                PE04_finish;
  wire       [7:0]    PE05_acount;
  wire       [7:0]    PE05_bcount;
  wire       [31:0]   PE05_PE_OUT;
  wire                PE05_finish;
  wire       [7:0]    PE06_acount;
  wire       [7:0]    PE06_bcount;
  wire       [31:0]   PE06_PE_OUT;
  wire                PE06_finish;
  wire       [7:0]    PE07_acount;
  wire       [7:0]    PE07_bcount;
  wire       [31:0]   PE07_PE_OUT;
  wire                PE07_finish;
  wire       [7:0]    PE10_acount;
  wire       [7:0]    PE10_bcount;
  wire       [31:0]   PE10_PE_OUT;
  wire                PE10_finish;
  wire       [7:0]    PE11_acount;
  wire       [7:0]    PE11_bcount;
  wire       [31:0]   PE11_PE_OUT;
  wire                PE11_finish;
  wire       [7:0]    PE12_acount;
  wire       [7:0]    PE12_bcount;
  wire       [31:0]   PE12_PE_OUT;
  wire                PE12_finish;
  wire       [7:0]    PE13_acount;
  wire       [7:0]    PE13_bcount;
  wire       [31:0]   PE13_PE_OUT;
  wire                PE13_finish;
  wire       [7:0]    PE14_acount;
  wire       [7:0]    PE14_bcount;
  wire       [31:0]   PE14_PE_OUT;
  wire                PE14_finish;
  wire       [7:0]    PE15_acount;
  wire       [7:0]    PE15_bcount;
  wire       [31:0]   PE15_PE_OUT;
  wire                PE15_finish;
  wire       [7:0]    PE16_acount;
  wire       [7:0]    PE16_bcount;
  wire       [31:0]   PE16_PE_OUT;
  wire                PE16_finish;
  wire       [7:0]    PE17_acount;
  wire       [7:0]    PE17_bcount;
  wire       [31:0]   PE17_PE_OUT;
  wire                PE17_finish;
  wire       [7:0]    PE20_acount;
  wire       [7:0]    PE20_bcount;
  wire       [31:0]   PE20_PE_OUT;
  wire                PE20_finish;
  wire       [7:0]    PE21_acount;
  wire       [7:0]    PE21_bcount;
  wire       [31:0]   PE21_PE_OUT;
  wire                PE21_finish;
  wire       [7:0]    PE22_acount;
  wire       [7:0]    PE22_bcount;
  wire       [31:0]   PE22_PE_OUT;
  wire                PE22_finish;
  wire       [7:0]    PE23_acount;
  wire       [7:0]    PE23_bcount;
  wire       [31:0]   PE23_PE_OUT;
  wire                PE23_finish;
  wire       [7:0]    PE24_acount;
  wire       [7:0]    PE24_bcount;
  wire       [31:0]   PE24_PE_OUT;
  wire                PE24_finish;
  wire       [7:0]    PE25_acount;
  wire       [7:0]    PE25_bcount;
  wire       [31:0]   PE25_PE_OUT;
  wire                PE25_finish;
  wire       [7:0]    PE26_acount;
  wire       [7:0]    PE26_bcount;
  wire       [31:0]   PE26_PE_OUT;
  wire                PE26_finish;
  wire       [7:0]    PE27_acount;
  wire       [7:0]    PE27_bcount;
  wire       [31:0]   PE27_PE_OUT;
  wire                PE27_finish;
  wire       [7:0]    PE30_acount;
  wire       [7:0]    PE30_bcount;
  wire       [31:0]   PE30_PE_OUT;
  wire                PE30_finish;
  wire       [7:0]    PE31_acount;
  wire       [7:0]    PE31_bcount;
  wire       [31:0]   PE31_PE_OUT;
  wire                PE31_finish;
  wire       [7:0]    PE32_acount;
  wire       [7:0]    PE32_bcount;
  wire       [31:0]   PE32_PE_OUT;
  wire                PE32_finish;
  wire       [7:0]    PE33_acount;
  wire       [7:0]    PE33_bcount;
  wire       [31:0]   PE33_PE_OUT;
  wire                PE33_finish;
  wire       [7:0]    PE34_acount;
  wire       [7:0]    PE34_bcount;
  wire       [31:0]   PE34_PE_OUT;
  wire                PE34_finish;
  wire       [7:0]    PE35_acount;
  wire       [7:0]    PE35_bcount;
  wire       [31:0]   PE35_PE_OUT;
  wire                PE35_finish;
  wire       [7:0]    PE36_acount;
  wire       [7:0]    PE36_bcount;
  wire       [31:0]   PE36_PE_OUT;
  wire                PE36_finish;
  wire       [7:0]    PE37_acount;
  wire       [7:0]    PE37_bcount;
  wire       [31:0]   PE37_PE_OUT;
  wire                PE37_finish;
  wire       [7:0]    PE40_acount;
  wire       [7:0]    PE40_bcount;
  wire       [31:0]   PE40_PE_OUT;
  wire                PE40_finish;
  wire       [7:0]    PE41_acount;
  wire       [7:0]    PE41_bcount;
  wire       [31:0]   PE41_PE_OUT;
  wire                PE41_finish;
  wire       [7:0]    PE42_acount;
  wire       [7:0]    PE42_bcount;
  wire       [31:0]   PE42_PE_OUT;
  wire                PE42_finish;
  wire       [7:0]    PE43_acount;
  wire       [7:0]    PE43_bcount;
  wire       [31:0]   PE43_PE_OUT;
  wire                PE43_finish;
  wire       [7:0]    PE44_acount;
  wire       [7:0]    PE44_bcount;
  wire       [31:0]   PE44_PE_OUT;
  wire                PE44_finish;
  wire       [7:0]    PE45_acount;
  wire       [7:0]    PE45_bcount;
  wire       [31:0]   PE45_PE_OUT;
  wire                PE45_finish;
  wire       [7:0]    PE46_acount;
  wire       [7:0]    PE46_bcount;
  wire       [31:0]   PE46_PE_OUT;
  wire                PE46_finish;
  wire       [7:0]    PE47_acount;
  wire       [7:0]    PE47_bcount;
  wire       [31:0]   PE47_PE_OUT;
  wire                PE47_finish;
  wire       [7:0]    PE50_acount;
  wire       [7:0]    PE50_bcount;
  wire       [31:0]   PE50_PE_OUT;
  wire                PE50_finish;
  wire       [7:0]    PE51_acount;
  wire       [7:0]    PE51_bcount;
  wire       [31:0]   PE51_PE_OUT;
  wire                PE51_finish;
  wire       [7:0]    PE52_acount;
  wire       [7:0]    PE52_bcount;
  wire       [31:0]   PE52_PE_OUT;
  wire                PE52_finish;
  wire       [7:0]    PE53_acount;
  wire       [7:0]    PE53_bcount;
  wire       [31:0]   PE53_PE_OUT;
  wire                PE53_finish;
  wire       [7:0]    PE54_acount;
  wire       [7:0]    PE54_bcount;
  wire       [31:0]   PE54_PE_OUT;
  wire                PE54_finish;
  wire       [7:0]    PE55_acount;
  wire       [7:0]    PE55_bcount;
  wire       [31:0]   PE55_PE_OUT;
  wire                PE55_finish;
  wire       [7:0]    PE56_acount;
  wire       [7:0]    PE56_bcount;
  wire       [31:0]   PE56_PE_OUT;
  wire                PE56_finish;
  wire       [7:0]    PE57_acount;
  wire       [7:0]    PE57_bcount;
  wire       [31:0]   PE57_PE_OUT;
  wire                PE57_finish;
  wire       [7:0]    PE60_acount;
  wire       [7:0]    PE60_bcount;
  wire       [31:0]   PE60_PE_OUT;
  wire                PE60_finish;
  wire       [7:0]    PE61_acount;
  wire       [7:0]    PE61_bcount;
  wire       [31:0]   PE61_PE_OUT;
  wire                PE61_finish;
  wire       [7:0]    PE62_acount;
  wire       [7:0]    PE62_bcount;
  wire       [31:0]   PE62_PE_OUT;
  wire                PE62_finish;
  wire       [7:0]    PE63_acount;
  wire       [7:0]    PE63_bcount;
  wire       [31:0]   PE63_PE_OUT;
  wire                PE63_finish;
  wire       [7:0]    PE64_acount;
  wire       [7:0]    PE64_bcount;
  wire       [31:0]   PE64_PE_OUT;
  wire                PE64_finish;
  wire       [7:0]    PE65_acount;
  wire       [7:0]    PE65_bcount;
  wire       [31:0]   PE65_PE_OUT;
  wire                PE65_finish;
  wire       [7:0]    PE66_acount;
  wire       [7:0]    PE66_bcount;
  wire       [31:0]   PE66_PE_OUT;
  wire                PE66_finish;
  wire       [7:0]    PE67_acount;
  wire       [7:0]    PE67_bcount;
  wire       [31:0]   PE67_PE_OUT;
  wire                PE67_finish;
  wire       [7:0]    PE70_acount;
  wire       [7:0]    PE70_bcount;
  wire       [31:0]   PE70_PE_OUT;
  wire                PE70_finish;
  wire       [7:0]    PE71_acount;
  wire       [7:0]    PE71_bcount;
  wire       [31:0]   PE71_PE_OUT;
  wire                PE71_finish;
  wire       [7:0]    PE72_acount;
  wire       [7:0]    PE72_bcount;
  wire       [31:0]   PE72_PE_OUT;
  wire                PE72_finish;
  wire       [7:0]    PE73_acount;
  wire       [7:0]    PE73_bcount;
  wire       [31:0]   PE73_PE_OUT;
  wire                PE73_finish;
  wire       [7:0]    PE74_acount;
  wire       [7:0]    PE74_bcount;
  wire       [31:0]   PE74_PE_OUT;
  wire                PE74_finish;
  wire       [7:0]    PE75_acount;
  wire       [7:0]    PE75_bcount;
  wire       [31:0]   PE75_PE_OUT;
  wire                PE75_finish;
  wire       [7:0]    PE76_acount;
  wire       [7:0]    PE76_bcount;
  wire       [31:0]   PE76_PE_OUT;
  wire                PE76_finish;
  wire       [7:0]    PE77_acount;
  wire       [7:0]    PE77_bcount;
  wire       [31:0]   PE77_PE_OUT;
  wire                PE77_finish;
  reg        [7:0]    _zz_C_Valid_0;
  reg        [7:0]    _zz_C_Valid_1;
  reg        [7:0]    _zz_C_Valid_2;
  reg        [7:0]    _zz_C_Valid_3;
  reg        [7:0]    _zz_C_Valid_4;
  reg        [7:0]    _zz_C_Valid_5;
  reg        [7:0]    _zz_C_Valid_6;
  reg        [7:0]    _zz_C_Valid_7;
  reg        [15:0]   io_signCount_regNextWhen;
  reg                 io_A_Valid_0_delay_1;
  reg                 io_A_Valid_0_delay_1_1;
  reg                 io_A_Valid_0_delay_2;
  reg                 io_A_Valid_0_delay_1_2;
  reg                 io_A_Valid_0_delay_2_1;
  reg                 io_A_Valid_0_delay_3;
  reg                 io_A_Valid_0_delay_1_3;
  reg                 io_A_Valid_0_delay_2_2;
  reg                 io_A_Valid_0_delay_3_1;
  reg                 io_A_Valid_0_delay_4;
  reg                 io_A_Valid_0_delay_1_4;
  reg                 io_A_Valid_0_delay_2_3;
  reg                 io_A_Valid_0_delay_3_2;
  reg                 io_A_Valid_0_delay_4_1;
  reg                 io_A_Valid_0_delay_5;
  reg                 io_A_Valid_0_delay_1_5;
  reg                 io_A_Valid_0_delay_2_4;
  reg                 io_A_Valid_0_delay_3_3;
  reg                 io_A_Valid_0_delay_4_2;
  reg                 io_A_Valid_0_delay_5_1;
  reg                 io_A_Valid_0_delay_6;
  reg                 io_A_Valid_0_delay_1_6;
  reg                 io_A_Valid_0_delay_2_5;
  reg                 io_A_Valid_0_delay_3_4;
  reg                 io_A_Valid_0_delay_4_3;
  reg                 io_A_Valid_0_delay_5_2;
  reg                 io_A_Valid_0_delay_6_1;
  reg                 io_A_Valid_0_delay_7;
  reg        [15:0]   io_signCount_regNextWhen_1;
  reg                 io_B_Valid_0_delay_1;
  reg                 io_A_Valid_1_delay_1;
  reg                 io_B_Valid_1_delay_1;
  reg                 io_A_Valid_1_delay_1_1;
  reg                 io_A_Valid_1_delay_2;
  reg                 io_B_Valid_2_delay_1;
  reg                 io_A_Valid_1_delay_1_2;
  reg                 io_A_Valid_1_delay_2_1;
  reg                 io_A_Valid_1_delay_3;
  reg                 io_B_Valid_3_delay_1;
  reg                 io_A_Valid_1_delay_1_3;
  reg                 io_A_Valid_1_delay_2_2;
  reg                 io_A_Valid_1_delay_3_1;
  reg                 io_A_Valid_1_delay_4;
  reg                 io_B_Valid_4_delay_1;
  reg                 io_A_Valid_1_delay_1_4;
  reg                 io_A_Valid_1_delay_2_3;
  reg                 io_A_Valid_1_delay_3_2;
  reg                 io_A_Valid_1_delay_4_1;
  reg                 io_A_Valid_1_delay_5;
  reg                 io_B_Valid_5_delay_1;
  reg                 io_A_Valid_1_delay_1_5;
  reg                 io_A_Valid_1_delay_2_4;
  reg                 io_A_Valid_1_delay_3_3;
  reg                 io_A_Valid_1_delay_4_2;
  reg                 io_A_Valid_1_delay_5_1;
  reg                 io_A_Valid_1_delay_6;
  reg                 io_B_Valid_6_delay_1;
  reg                 io_A_Valid_1_delay_1_6;
  reg                 io_A_Valid_1_delay_2_5;
  reg                 io_A_Valid_1_delay_3_4;
  reg                 io_A_Valid_1_delay_4_3;
  reg                 io_A_Valid_1_delay_5_2;
  reg                 io_A_Valid_1_delay_6_1;
  reg                 io_A_Valid_1_delay_7;
  reg                 io_B_Valid_7_delay_1;
  reg        [15:0]   io_signCount_regNextWhen_2;
  reg                 io_B_Valid_0_delay_1_1;
  reg                 io_B_Valid_0_delay_2;
  reg                 io_A_Valid_2_delay_1;
  reg                 io_B_Valid_1_delay_1_1;
  reg                 io_B_Valid_1_delay_2;
  reg                 io_A_Valid_2_delay_1_1;
  reg                 io_A_Valid_2_delay_2;
  reg                 io_B_Valid_2_delay_1_1;
  reg                 io_B_Valid_2_delay_2;
  reg                 io_A_Valid_2_delay_1_2;
  reg                 io_A_Valid_2_delay_2_1;
  reg                 io_A_Valid_2_delay_3;
  reg                 io_B_Valid_3_delay_1_1;
  reg                 io_B_Valid_3_delay_2;
  reg                 io_A_Valid_2_delay_1_3;
  reg                 io_A_Valid_2_delay_2_2;
  reg                 io_A_Valid_2_delay_3_1;
  reg                 io_A_Valid_2_delay_4;
  reg                 io_B_Valid_4_delay_1_1;
  reg                 io_B_Valid_4_delay_2;
  reg                 io_A_Valid_2_delay_1_4;
  reg                 io_A_Valid_2_delay_2_3;
  reg                 io_A_Valid_2_delay_3_2;
  reg                 io_A_Valid_2_delay_4_1;
  reg                 io_A_Valid_2_delay_5;
  reg                 io_B_Valid_5_delay_1_1;
  reg                 io_B_Valid_5_delay_2;
  reg                 io_A_Valid_2_delay_1_5;
  reg                 io_A_Valid_2_delay_2_4;
  reg                 io_A_Valid_2_delay_3_3;
  reg                 io_A_Valid_2_delay_4_2;
  reg                 io_A_Valid_2_delay_5_1;
  reg                 io_A_Valid_2_delay_6;
  reg                 io_B_Valid_6_delay_1_1;
  reg                 io_B_Valid_6_delay_2;
  reg                 io_A_Valid_2_delay_1_6;
  reg                 io_A_Valid_2_delay_2_5;
  reg                 io_A_Valid_2_delay_3_4;
  reg                 io_A_Valid_2_delay_4_3;
  reg                 io_A_Valid_2_delay_5_2;
  reg                 io_A_Valid_2_delay_6_1;
  reg                 io_A_Valid_2_delay_7;
  reg                 io_B_Valid_7_delay_1_1;
  reg                 io_B_Valid_7_delay_2;
  reg        [15:0]   io_signCount_regNextWhen_3;
  reg                 io_B_Valid_0_delay_1_2;
  reg                 io_B_Valid_0_delay_2_1;
  reg                 io_B_Valid_0_delay_3;
  reg                 io_A_Valid_3_delay_1;
  reg                 io_B_Valid_1_delay_1_2;
  reg                 io_B_Valid_1_delay_2_1;
  reg                 io_B_Valid_1_delay_3;
  reg                 io_A_Valid_3_delay_1_1;
  reg                 io_A_Valid_3_delay_2;
  reg                 io_B_Valid_2_delay_1_2;
  reg                 io_B_Valid_2_delay_2_1;
  reg                 io_B_Valid_2_delay_3;
  reg                 io_A_Valid_3_delay_1_2;
  reg                 io_A_Valid_3_delay_2_1;
  reg                 io_A_Valid_3_delay_3;
  reg                 io_B_Valid_3_delay_1_2;
  reg                 io_B_Valid_3_delay_2_1;
  reg                 io_B_Valid_3_delay_3;
  reg                 io_A_Valid_3_delay_1_3;
  reg                 io_A_Valid_3_delay_2_2;
  reg                 io_A_Valid_3_delay_3_1;
  reg                 io_A_Valid_3_delay_4;
  reg                 io_B_Valid_4_delay_1_2;
  reg                 io_B_Valid_4_delay_2_1;
  reg                 io_B_Valid_4_delay_3;
  reg                 io_A_Valid_3_delay_1_4;
  reg                 io_A_Valid_3_delay_2_3;
  reg                 io_A_Valid_3_delay_3_2;
  reg                 io_A_Valid_3_delay_4_1;
  reg                 io_A_Valid_3_delay_5;
  reg                 io_B_Valid_5_delay_1_2;
  reg                 io_B_Valid_5_delay_2_1;
  reg                 io_B_Valid_5_delay_3;
  reg                 io_A_Valid_3_delay_1_5;
  reg                 io_A_Valid_3_delay_2_4;
  reg                 io_A_Valid_3_delay_3_3;
  reg                 io_A_Valid_3_delay_4_2;
  reg                 io_A_Valid_3_delay_5_1;
  reg                 io_A_Valid_3_delay_6;
  reg                 io_B_Valid_6_delay_1_2;
  reg                 io_B_Valid_6_delay_2_1;
  reg                 io_B_Valid_6_delay_3;
  reg                 io_A_Valid_3_delay_1_6;
  reg                 io_A_Valid_3_delay_2_5;
  reg                 io_A_Valid_3_delay_3_4;
  reg                 io_A_Valid_3_delay_4_3;
  reg                 io_A_Valid_3_delay_5_2;
  reg                 io_A_Valid_3_delay_6_1;
  reg                 io_A_Valid_3_delay_7;
  reg                 io_B_Valid_7_delay_1_2;
  reg                 io_B_Valid_7_delay_2_1;
  reg                 io_B_Valid_7_delay_3;
  reg        [15:0]   io_signCount_regNextWhen_4;
  reg                 io_B_Valid_0_delay_1_3;
  reg                 io_B_Valid_0_delay_2_2;
  reg                 io_B_Valid_0_delay_3_1;
  reg                 io_B_Valid_0_delay_4;
  reg                 io_A_Valid_4_delay_1;
  reg                 io_B_Valid_1_delay_1_3;
  reg                 io_B_Valid_1_delay_2_2;
  reg                 io_B_Valid_1_delay_3_1;
  reg                 io_B_Valid_1_delay_4;
  reg                 io_A_Valid_4_delay_1_1;
  reg                 io_A_Valid_4_delay_2;
  reg                 io_B_Valid_2_delay_1_3;
  reg                 io_B_Valid_2_delay_2_2;
  reg                 io_B_Valid_2_delay_3_1;
  reg                 io_B_Valid_2_delay_4;
  reg                 io_A_Valid_4_delay_1_2;
  reg                 io_A_Valid_4_delay_2_1;
  reg                 io_A_Valid_4_delay_3;
  reg                 io_B_Valid_3_delay_1_3;
  reg                 io_B_Valid_3_delay_2_2;
  reg                 io_B_Valid_3_delay_3_1;
  reg                 io_B_Valid_3_delay_4;
  reg                 io_A_Valid_4_delay_1_3;
  reg                 io_A_Valid_4_delay_2_2;
  reg                 io_A_Valid_4_delay_3_1;
  reg                 io_A_Valid_4_delay_4;
  reg                 io_B_Valid_4_delay_1_3;
  reg                 io_B_Valid_4_delay_2_2;
  reg                 io_B_Valid_4_delay_3_1;
  reg                 io_B_Valid_4_delay_4;
  reg                 io_A_Valid_4_delay_1_4;
  reg                 io_A_Valid_4_delay_2_3;
  reg                 io_A_Valid_4_delay_3_2;
  reg                 io_A_Valid_4_delay_4_1;
  reg                 io_A_Valid_4_delay_5;
  reg                 io_B_Valid_5_delay_1_3;
  reg                 io_B_Valid_5_delay_2_2;
  reg                 io_B_Valid_5_delay_3_1;
  reg                 io_B_Valid_5_delay_4;
  reg                 io_A_Valid_4_delay_1_5;
  reg                 io_A_Valid_4_delay_2_4;
  reg                 io_A_Valid_4_delay_3_3;
  reg                 io_A_Valid_4_delay_4_2;
  reg                 io_A_Valid_4_delay_5_1;
  reg                 io_A_Valid_4_delay_6;
  reg                 io_B_Valid_6_delay_1_3;
  reg                 io_B_Valid_6_delay_2_2;
  reg                 io_B_Valid_6_delay_3_1;
  reg                 io_B_Valid_6_delay_4;
  reg                 io_A_Valid_4_delay_1_6;
  reg                 io_A_Valid_4_delay_2_5;
  reg                 io_A_Valid_4_delay_3_4;
  reg                 io_A_Valid_4_delay_4_3;
  reg                 io_A_Valid_4_delay_5_2;
  reg                 io_A_Valid_4_delay_6_1;
  reg                 io_A_Valid_4_delay_7;
  reg                 io_B_Valid_7_delay_1_3;
  reg                 io_B_Valid_7_delay_2_2;
  reg                 io_B_Valid_7_delay_3_1;
  reg                 io_B_Valid_7_delay_4;
  reg        [15:0]   io_signCount_regNextWhen_5;
  reg                 io_B_Valid_0_delay_1_4;
  reg                 io_B_Valid_0_delay_2_3;
  reg                 io_B_Valid_0_delay_3_2;
  reg                 io_B_Valid_0_delay_4_1;
  reg                 io_B_Valid_0_delay_5;
  reg                 io_A_Valid_5_delay_1;
  reg                 io_B_Valid_1_delay_1_4;
  reg                 io_B_Valid_1_delay_2_3;
  reg                 io_B_Valid_1_delay_3_2;
  reg                 io_B_Valid_1_delay_4_1;
  reg                 io_B_Valid_1_delay_5;
  reg                 io_A_Valid_5_delay_1_1;
  reg                 io_A_Valid_5_delay_2;
  reg                 io_B_Valid_2_delay_1_4;
  reg                 io_B_Valid_2_delay_2_3;
  reg                 io_B_Valid_2_delay_3_2;
  reg                 io_B_Valid_2_delay_4_1;
  reg                 io_B_Valid_2_delay_5;
  reg                 io_A_Valid_5_delay_1_2;
  reg                 io_A_Valid_5_delay_2_1;
  reg                 io_A_Valid_5_delay_3;
  reg                 io_B_Valid_3_delay_1_4;
  reg                 io_B_Valid_3_delay_2_3;
  reg                 io_B_Valid_3_delay_3_2;
  reg                 io_B_Valid_3_delay_4_1;
  reg                 io_B_Valid_3_delay_5;
  reg                 io_A_Valid_5_delay_1_3;
  reg                 io_A_Valid_5_delay_2_2;
  reg                 io_A_Valid_5_delay_3_1;
  reg                 io_A_Valid_5_delay_4;
  reg                 io_B_Valid_4_delay_1_4;
  reg                 io_B_Valid_4_delay_2_3;
  reg                 io_B_Valid_4_delay_3_2;
  reg                 io_B_Valid_4_delay_4_1;
  reg                 io_B_Valid_4_delay_5;
  reg                 io_A_Valid_5_delay_1_4;
  reg                 io_A_Valid_5_delay_2_3;
  reg                 io_A_Valid_5_delay_3_2;
  reg                 io_A_Valid_5_delay_4_1;
  reg                 io_A_Valid_5_delay_5;
  reg                 io_B_Valid_5_delay_1_4;
  reg                 io_B_Valid_5_delay_2_3;
  reg                 io_B_Valid_5_delay_3_2;
  reg                 io_B_Valid_5_delay_4_1;
  reg                 io_B_Valid_5_delay_5;
  reg                 io_A_Valid_5_delay_1_5;
  reg                 io_A_Valid_5_delay_2_4;
  reg                 io_A_Valid_5_delay_3_3;
  reg                 io_A_Valid_5_delay_4_2;
  reg                 io_A_Valid_5_delay_5_1;
  reg                 io_A_Valid_5_delay_6;
  reg                 io_B_Valid_6_delay_1_4;
  reg                 io_B_Valid_6_delay_2_3;
  reg                 io_B_Valid_6_delay_3_2;
  reg                 io_B_Valid_6_delay_4_1;
  reg                 io_B_Valid_6_delay_5;
  reg                 io_A_Valid_5_delay_1_6;
  reg                 io_A_Valid_5_delay_2_5;
  reg                 io_A_Valid_5_delay_3_4;
  reg                 io_A_Valid_5_delay_4_3;
  reg                 io_A_Valid_5_delay_5_2;
  reg                 io_A_Valid_5_delay_6_1;
  reg                 io_A_Valid_5_delay_7;
  reg                 io_B_Valid_7_delay_1_4;
  reg                 io_B_Valid_7_delay_2_3;
  reg                 io_B_Valid_7_delay_3_2;
  reg                 io_B_Valid_7_delay_4_1;
  reg                 io_B_Valid_7_delay_5;
  reg        [15:0]   io_signCount_regNextWhen_6;
  reg                 io_B_Valid_0_delay_1_5;
  reg                 io_B_Valid_0_delay_2_4;
  reg                 io_B_Valid_0_delay_3_3;
  reg                 io_B_Valid_0_delay_4_2;
  reg                 io_B_Valid_0_delay_5_1;
  reg                 io_B_Valid_0_delay_6;
  reg                 io_A_Valid_6_delay_1;
  reg                 io_B_Valid_1_delay_1_5;
  reg                 io_B_Valid_1_delay_2_4;
  reg                 io_B_Valid_1_delay_3_3;
  reg                 io_B_Valid_1_delay_4_2;
  reg                 io_B_Valid_1_delay_5_1;
  reg                 io_B_Valid_1_delay_6;
  reg                 io_A_Valid_6_delay_1_1;
  reg                 io_A_Valid_6_delay_2;
  reg                 io_B_Valid_2_delay_1_5;
  reg                 io_B_Valid_2_delay_2_4;
  reg                 io_B_Valid_2_delay_3_3;
  reg                 io_B_Valid_2_delay_4_2;
  reg                 io_B_Valid_2_delay_5_1;
  reg                 io_B_Valid_2_delay_6;
  reg                 io_A_Valid_6_delay_1_2;
  reg                 io_A_Valid_6_delay_2_1;
  reg                 io_A_Valid_6_delay_3;
  reg                 io_B_Valid_3_delay_1_5;
  reg                 io_B_Valid_3_delay_2_4;
  reg                 io_B_Valid_3_delay_3_3;
  reg                 io_B_Valid_3_delay_4_2;
  reg                 io_B_Valid_3_delay_5_1;
  reg                 io_B_Valid_3_delay_6;
  reg                 io_A_Valid_6_delay_1_3;
  reg                 io_A_Valid_6_delay_2_2;
  reg                 io_A_Valid_6_delay_3_1;
  reg                 io_A_Valid_6_delay_4;
  reg                 io_B_Valid_4_delay_1_5;
  reg                 io_B_Valid_4_delay_2_4;
  reg                 io_B_Valid_4_delay_3_3;
  reg                 io_B_Valid_4_delay_4_2;
  reg                 io_B_Valid_4_delay_5_1;
  reg                 io_B_Valid_4_delay_6;
  reg                 io_A_Valid_6_delay_1_4;
  reg                 io_A_Valid_6_delay_2_3;
  reg                 io_A_Valid_6_delay_3_2;
  reg                 io_A_Valid_6_delay_4_1;
  reg                 io_A_Valid_6_delay_5;
  reg                 io_B_Valid_5_delay_1_5;
  reg                 io_B_Valid_5_delay_2_4;
  reg                 io_B_Valid_5_delay_3_3;
  reg                 io_B_Valid_5_delay_4_2;
  reg                 io_B_Valid_5_delay_5_1;
  reg                 io_B_Valid_5_delay_6;
  reg                 io_A_Valid_6_delay_1_5;
  reg                 io_A_Valid_6_delay_2_4;
  reg                 io_A_Valid_6_delay_3_3;
  reg                 io_A_Valid_6_delay_4_2;
  reg                 io_A_Valid_6_delay_5_1;
  reg                 io_A_Valid_6_delay_6;
  reg                 io_B_Valid_6_delay_1_5;
  reg                 io_B_Valid_6_delay_2_4;
  reg                 io_B_Valid_6_delay_3_3;
  reg                 io_B_Valid_6_delay_4_2;
  reg                 io_B_Valid_6_delay_5_1;
  reg                 io_B_Valid_6_delay_6;
  reg                 io_A_Valid_6_delay_1_6;
  reg                 io_A_Valid_6_delay_2_5;
  reg                 io_A_Valid_6_delay_3_4;
  reg                 io_A_Valid_6_delay_4_3;
  reg                 io_A_Valid_6_delay_5_2;
  reg                 io_A_Valid_6_delay_6_1;
  reg                 io_A_Valid_6_delay_7;
  reg                 io_B_Valid_7_delay_1_5;
  reg                 io_B_Valid_7_delay_2_4;
  reg                 io_B_Valid_7_delay_3_3;
  reg                 io_B_Valid_7_delay_4_2;
  reg                 io_B_Valid_7_delay_5_1;
  reg                 io_B_Valid_7_delay_6;
  reg        [15:0]   io_signCount_regNextWhen_7;
  reg                 io_B_Valid_0_delay_1_6;
  reg                 io_B_Valid_0_delay_2_5;
  reg                 io_B_Valid_0_delay_3_4;
  reg                 io_B_Valid_0_delay_4_3;
  reg                 io_B_Valid_0_delay_5_2;
  reg                 io_B_Valid_0_delay_6_1;
  reg                 io_B_Valid_0_delay_7;
  reg                 io_A_Valid_7_delay_1;
  reg                 io_B_Valid_1_delay_1_6;
  reg                 io_B_Valid_1_delay_2_5;
  reg                 io_B_Valid_1_delay_3_4;
  reg                 io_B_Valid_1_delay_4_3;
  reg                 io_B_Valid_1_delay_5_2;
  reg                 io_B_Valid_1_delay_6_1;
  reg                 io_B_Valid_1_delay_7;
  reg                 io_A_Valid_7_delay_1_1;
  reg                 io_A_Valid_7_delay_2;
  reg                 io_B_Valid_2_delay_1_6;
  reg                 io_B_Valid_2_delay_2_5;
  reg                 io_B_Valid_2_delay_3_4;
  reg                 io_B_Valid_2_delay_4_3;
  reg                 io_B_Valid_2_delay_5_2;
  reg                 io_B_Valid_2_delay_6_1;
  reg                 io_B_Valid_2_delay_7;
  reg                 io_A_Valid_7_delay_1_2;
  reg                 io_A_Valid_7_delay_2_1;
  reg                 io_A_Valid_7_delay_3;
  reg                 io_B_Valid_3_delay_1_6;
  reg                 io_B_Valid_3_delay_2_5;
  reg                 io_B_Valid_3_delay_3_4;
  reg                 io_B_Valid_3_delay_4_3;
  reg                 io_B_Valid_3_delay_5_2;
  reg                 io_B_Valid_3_delay_6_1;
  reg                 io_B_Valid_3_delay_7;
  reg                 io_A_Valid_7_delay_1_3;
  reg                 io_A_Valid_7_delay_2_2;
  reg                 io_A_Valid_7_delay_3_1;
  reg                 io_A_Valid_7_delay_4;
  reg                 io_B_Valid_4_delay_1_6;
  reg                 io_B_Valid_4_delay_2_5;
  reg                 io_B_Valid_4_delay_3_4;
  reg                 io_B_Valid_4_delay_4_3;
  reg                 io_B_Valid_4_delay_5_2;
  reg                 io_B_Valid_4_delay_6_1;
  reg                 io_B_Valid_4_delay_7;
  reg                 io_A_Valid_7_delay_1_4;
  reg                 io_A_Valid_7_delay_2_3;
  reg                 io_A_Valid_7_delay_3_2;
  reg                 io_A_Valid_7_delay_4_1;
  reg                 io_A_Valid_7_delay_5;
  reg                 io_B_Valid_5_delay_1_6;
  reg                 io_B_Valid_5_delay_2_5;
  reg                 io_B_Valid_5_delay_3_4;
  reg                 io_B_Valid_5_delay_4_3;
  reg                 io_B_Valid_5_delay_5_2;
  reg                 io_B_Valid_5_delay_6_1;
  reg                 io_B_Valid_5_delay_7;
  reg                 io_A_Valid_7_delay_1_5;
  reg                 io_A_Valid_7_delay_2_4;
  reg                 io_A_Valid_7_delay_3_3;
  reg                 io_A_Valid_7_delay_4_2;
  reg                 io_A_Valid_7_delay_5_1;
  reg                 io_A_Valid_7_delay_6;
  reg                 io_B_Valid_6_delay_1_6;
  reg                 io_B_Valid_6_delay_2_5;
  reg                 io_B_Valid_6_delay_3_4;
  reg                 io_B_Valid_6_delay_4_3;
  reg                 io_B_Valid_6_delay_5_2;
  reg                 io_B_Valid_6_delay_6_1;
  reg                 io_B_Valid_6_delay_7;
  reg                 io_A_Valid_7_delay_1_6;
  reg                 io_A_Valid_7_delay_2_5;
  reg                 io_A_Valid_7_delay_3_4;
  reg                 io_A_Valid_7_delay_4_3;
  reg                 io_A_Valid_7_delay_5_2;
  reg                 io_A_Valid_7_delay_6_1;
  reg                 io_A_Valid_7_delay_7;
  reg                 io_B_Valid_7_delay_1_6;
  reg                 io_B_Valid_7_delay_2_5;
  reg                 io_B_Valid_7_delay_3_4;
  reg                 io_B_Valid_7_delay_4_3;
  reg                 io_B_Valid_7_delay_5_2;
  reg                 io_B_Valid_7_delay_6_1;
  reg                 io_B_Valid_7_delay_7;

  PE PE00 (
    .activate  (io_MatrixA_0[7:0]             ), //i
    .weight    (io_MatrixB_0[7:0]             ), //i
    .valid     (PE00_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE00_acount[7:0]              ), //o
    .bcount    (PE00_bcount[7:0]              ), //o
    .PE_OUT    (PE00_PE_OUT[31:0]             ), //o
    .finish    (PE00_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE01 (
    .activate  (PE00_acount[7:0]              ), //i
    .weight    (io_MatrixB_1[7:0]             ), //i
    .valid     (PE01_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE01_acount[7:0]              ), //o
    .bcount    (PE01_bcount[7:0]              ), //o
    .PE_OUT    (PE01_PE_OUT[31:0]             ), //o
    .finish    (PE01_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE02 (
    .activate  (PE01_acount[7:0]              ), //i
    .weight    (io_MatrixB_2[7:0]             ), //i
    .valid     (PE02_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE02_acount[7:0]              ), //o
    .bcount    (PE02_bcount[7:0]              ), //o
    .PE_OUT    (PE02_PE_OUT[31:0]             ), //o
    .finish    (PE02_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE03 (
    .activate  (PE02_acount[7:0]              ), //i
    .weight    (io_MatrixB_3[7:0]             ), //i
    .valid     (PE03_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE03_acount[7:0]              ), //o
    .bcount    (PE03_bcount[7:0]              ), //o
    .PE_OUT    (PE03_PE_OUT[31:0]             ), //o
    .finish    (PE03_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE04 (
    .activate  (PE03_acount[7:0]              ), //i
    .weight    (io_MatrixB_4[7:0]             ), //i
    .valid     (PE04_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE04_acount[7:0]              ), //o
    .bcount    (PE04_bcount[7:0]              ), //o
    .PE_OUT    (PE04_PE_OUT[31:0]             ), //o
    .finish    (PE04_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE05 (
    .activate  (PE04_acount[7:0]              ), //i
    .weight    (io_MatrixB_5[7:0]             ), //i
    .valid     (PE05_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE05_acount[7:0]              ), //o
    .bcount    (PE05_bcount[7:0]              ), //o
    .PE_OUT    (PE05_PE_OUT[31:0]             ), //o
    .finish    (PE05_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE06 (
    .activate  (PE05_acount[7:0]              ), //i
    .weight    (io_MatrixB_6[7:0]             ), //i
    .valid     (PE06_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE06_acount[7:0]              ), //o
    .bcount    (PE06_bcount[7:0]              ), //o
    .PE_OUT    (PE06_PE_OUT[31:0]             ), //o
    .finish    (PE06_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE07 (
    .activate  (PE06_acount[7:0]              ), //i
    .weight    (io_MatrixB_7[7:0]             ), //i
    .valid     (PE07_valid                    ), //i
    .signCount (io_signCount_regNextWhen[15:0]), //i
    .acount    (PE07_acount[7:0]              ), //o
    .bcount    (PE07_bcount[7:0]              ), //o
    .PE_OUT    (PE07_PE_OUT[31:0]             ), //o
    .finish    (PE07_finish                   ), //o
    .clk       (clk                           ), //i
    .reset     (reset                         )  //i
  );
  PE PE10 (
    .activate  (io_MatrixA_1[7:0]               ), //i
    .weight    (PE00_bcount[7:0]                ), //i
    .valid     (PE10_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE10_acount[7:0]                ), //o
    .bcount    (PE10_bcount[7:0]                ), //o
    .PE_OUT    (PE10_PE_OUT[31:0]               ), //o
    .finish    (PE10_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE11 (
    .activate  (PE10_acount[7:0]                ), //i
    .weight    (PE01_bcount[7:0]                ), //i
    .valid     (PE11_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE11_acount[7:0]                ), //o
    .bcount    (PE11_bcount[7:0]                ), //o
    .PE_OUT    (PE11_PE_OUT[31:0]               ), //o
    .finish    (PE11_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE12 (
    .activate  (PE11_acount[7:0]                ), //i
    .weight    (PE02_bcount[7:0]                ), //i
    .valid     (PE12_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE12_acount[7:0]                ), //o
    .bcount    (PE12_bcount[7:0]                ), //o
    .PE_OUT    (PE12_PE_OUT[31:0]               ), //o
    .finish    (PE12_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE13 (
    .activate  (PE12_acount[7:0]                ), //i
    .weight    (PE03_bcount[7:0]                ), //i
    .valid     (PE13_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE13_acount[7:0]                ), //o
    .bcount    (PE13_bcount[7:0]                ), //o
    .PE_OUT    (PE13_PE_OUT[31:0]               ), //o
    .finish    (PE13_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE14 (
    .activate  (PE13_acount[7:0]                ), //i
    .weight    (PE04_bcount[7:0]                ), //i
    .valid     (PE14_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE14_acount[7:0]                ), //o
    .bcount    (PE14_bcount[7:0]                ), //o
    .PE_OUT    (PE14_PE_OUT[31:0]               ), //o
    .finish    (PE14_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE15 (
    .activate  (PE14_acount[7:0]                ), //i
    .weight    (PE05_bcount[7:0]                ), //i
    .valid     (PE15_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE15_acount[7:0]                ), //o
    .bcount    (PE15_bcount[7:0]                ), //o
    .PE_OUT    (PE15_PE_OUT[31:0]               ), //o
    .finish    (PE15_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE16 (
    .activate  (PE15_acount[7:0]                ), //i
    .weight    (PE06_bcount[7:0]                ), //i
    .valid     (PE16_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE16_acount[7:0]                ), //o
    .bcount    (PE16_bcount[7:0]                ), //o
    .PE_OUT    (PE16_PE_OUT[31:0]               ), //o
    .finish    (PE16_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE17 (
    .activate  (PE16_acount[7:0]                ), //i
    .weight    (PE07_bcount[7:0]                ), //i
    .valid     (PE17_valid                      ), //i
    .signCount (io_signCount_regNextWhen_1[15:0]), //i
    .acount    (PE17_acount[7:0]                ), //o
    .bcount    (PE17_bcount[7:0]                ), //o
    .PE_OUT    (PE17_PE_OUT[31:0]               ), //o
    .finish    (PE17_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE20 (
    .activate  (io_MatrixA_2[7:0]               ), //i
    .weight    (PE10_bcount[7:0]                ), //i
    .valid     (PE20_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE20_acount[7:0]                ), //o
    .bcount    (PE20_bcount[7:0]                ), //o
    .PE_OUT    (PE20_PE_OUT[31:0]               ), //o
    .finish    (PE20_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE21 (
    .activate  (PE20_acount[7:0]                ), //i
    .weight    (PE11_bcount[7:0]                ), //i
    .valid     (PE21_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE21_acount[7:0]                ), //o
    .bcount    (PE21_bcount[7:0]                ), //o
    .PE_OUT    (PE21_PE_OUT[31:0]               ), //o
    .finish    (PE21_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE22 (
    .activate  (PE21_acount[7:0]                ), //i
    .weight    (PE12_bcount[7:0]                ), //i
    .valid     (PE22_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE22_acount[7:0]                ), //o
    .bcount    (PE22_bcount[7:0]                ), //o
    .PE_OUT    (PE22_PE_OUT[31:0]               ), //o
    .finish    (PE22_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE23 (
    .activate  (PE22_acount[7:0]                ), //i
    .weight    (PE13_bcount[7:0]                ), //i
    .valid     (PE23_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE23_acount[7:0]                ), //o
    .bcount    (PE23_bcount[7:0]                ), //o
    .PE_OUT    (PE23_PE_OUT[31:0]               ), //o
    .finish    (PE23_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE24 (
    .activate  (PE23_acount[7:0]                ), //i
    .weight    (PE14_bcount[7:0]                ), //i
    .valid     (PE24_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE24_acount[7:0]                ), //o
    .bcount    (PE24_bcount[7:0]                ), //o
    .PE_OUT    (PE24_PE_OUT[31:0]               ), //o
    .finish    (PE24_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE25 (
    .activate  (PE24_acount[7:0]                ), //i
    .weight    (PE15_bcount[7:0]                ), //i
    .valid     (PE25_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE25_acount[7:0]                ), //o
    .bcount    (PE25_bcount[7:0]                ), //o
    .PE_OUT    (PE25_PE_OUT[31:0]               ), //o
    .finish    (PE25_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE26 (
    .activate  (PE25_acount[7:0]                ), //i
    .weight    (PE16_bcount[7:0]                ), //i
    .valid     (PE26_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE26_acount[7:0]                ), //o
    .bcount    (PE26_bcount[7:0]                ), //o
    .PE_OUT    (PE26_PE_OUT[31:0]               ), //o
    .finish    (PE26_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE27 (
    .activate  (PE26_acount[7:0]                ), //i
    .weight    (PE17_bcount[7:0]                ), //i
    .valid     (PE27_valid                      ), //i
    .signCount (io_signCount_regNextWhen_2[15:0]), //i
    .acount    (PE27_acount[7:0]                ), //o
    .bcount    (PE27_bcount[7:0]                ), //o
    .PE_OUT    (PE27_PE_OUT[31:0]               ), //o
    .finish    (PE27_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE30 (
    .activate  (io_MatrixA_3[7:0]               ), //i
    .weight    (PE20_bcount[7:0]                ), //i
    .valid     (PE30_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE30_acount[7:0]                ), //o
    .bcount    (PE30_bcount[7:0]                ), //o
    .PE_OUT    (PE30_PE_OUT[31:0]               ), //o
    .finish    (PE30_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE31 (
    .activate  (PE30_acount[7:0]                ), //i
    .weight    (PE21_bcount[7:0]                ), //i
    .valid     (PE31_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE31_acount[7:0]                ), //o
    .bcount    (PE31_bcount[7:0]                ), //o
    .PE_OUT    (PE31_PE_OUT[31:0]               ), //o
    .finish    (PE31_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE32 (
    .activate  (PE31_acount[7:0]                ), //i
    .weight    (PE22_bcount[7:0]                ), //i
    .valid     (PE32_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE32_acount[7:0]                ), //o
    .bcount    (PE32_bcount[7:0]                ), //o
    .PE_OUT    (PE32_PE_OUT[31:0]               ), //o
    .finish    (PE32_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE33 (
    .activate  (PE32_acount[7:0]                ), //i
    .weight    (PE23_bcount[7:0]                ), //i
    .valid     (PE33_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE33_acount[7:0]                ), //o
    .bcount    (PE33_bcount[7:0]                ), //o
    .PE_OUT    (PE33_PE_OUT[31:0]               ), //o
    .finish    (PE33_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE34 (
    .activate  (PE33_acount[7:0]                ), //i
    .weight    (PE24_bcount[7:0]                ), //i
    .valid     (PE34_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE34_acount[7:0]                ), //o
    .bcount    (PE34_bcount[7:0]                ), //o
    .PE_OUT    (PE34_PE_OUT[31:0]               ), //o
    .finish    (PE34_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE35 (
    .activate  (PE34_acount[7:0]                ), //i
    .weight    (PE25_bcount[7:0]                ), //i
    .valid     (PE35_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE35_acount[7:0]                ), //o
    .bcount    (PE35_bcount[7:0]                ), //o
    .PE_OUT    (PE35_PE_OUT[31:0]               ), //o
    .finish    (PE35_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE36 (
    .activate  (PE35_acount[7:0]                ), //i
    .weight    (PE26_bcount[7:0]                ), //i
    .valid     (PE36_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE36_acount[7:0]                ), //o
    .bcount    (PE36_bcount[7:0]                ), //o
    .PE_OUT    (PE36_PE_OUT[31:0]               ), //o
    .finish    (PE36_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE37 (
    .activate  (PE36_acount[7:0]                ), //i
    .weight    (PE27_bcount[7:0]                ), //i
    .valid     (PE37_valid                      ), //i
    .signCount (io_signCount_regNextWhen_3[15:0]), //i
    .acount    (PE37_acount[7:0]                ), //o
    .bcount    (PE37_bcount[7:0]                ), //o
    .PE_OUT    (PE37_PE_OUT[31:0]               ), //o
    .finish    (PE37_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE40 (
    .activate  (io_MatrixA_4[7:0]               ), //i
    .weight    (PE30_bcount[7:0]                ), //i
    .valid     (PE40_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE40_acount[7:0]                ), //o
    .bcount    (PE40_bcount[7:0]                ), //o
    .PE_OUT    (PE40_PE_OUT[31:0]               ), //o
    .finish    (PE40_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE41 (
    .activate  (PE40_acount[7:0]                ), //i
    .weight    (PE31_bcount[7:0]                ), //i
    .valid     (PE41_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE41_acount[7:0]                ), //o
    .bcount    (PE41_bcount[7:0]                ), //o
    .PE_OUT    (PE41_PE_OUT[31:0]               ), //o
    .finish    (PE41_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE42 (
    .activate  (PE41_acount[7:0]                ), //i
    .weight    (PE32_bcount[7:0]                ), //i
    .valid     (PE42_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE42_acount[7:0]                ), //o
    .bcount    (PE42_bcount[7:0]                ), //o
    .PE_OUT    (PE42_PE_OUT[31:0]               ), //o
    .finish    (PE42_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE43 (
    .activate  (PE42_acount[7:0]                ), //i
    .weight    (PE33_bcount[7:0]                ), //i
    .valid     (PE43_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE43_acount[7:0]                ), //o
    .bcount    (PE43_bcount[7:0]                ), //o
    .PE_OUT    (PE43_PE_OUT[31:0]               ), //o
    .finish    (PE43_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE44 (
    .activate  (PE43_acount[7:0]                ), //i
    .weight    (PE34_bcount[7:0]                ), //i
    .valid     (PE44_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE44_acount[7:0]                ), //o
    .bcount    (PE44_bcount[7:0]                ), //o
    .PE_OUT    (PE44_PE_OUT[31:0]               ), //o
    .finish    (PE44_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE45 (
    .activate  (PE44_acount[7:0]                ), //i
    .weight    (PE35_bcount[7:0]                ), //i
    .valid     (PE45_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE45_acount[7:0]                ), //o
    .bcount    (PE45_bcount[7:0]                ), //o
    .PE_OUT    (PE45_PE_OUT[31:0]               ), //o
    .finish    (PE45_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE46 (
    .activate  (PE45_acount[7:0]                ), //i
    .weight    (PE36_bcount[7:0]                ), //i
    .valid     (PE46_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE46_acount[7:0]                ), //o
    .bcount    (PE46_bcount[7:0]                ), //o
    .PE_OUT    (PE46_PE_OUT[31:0]               ), //o
    .finish    (PE46_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE47 (
    .activate  (PE46_acount[7:0]                ), //i
    .weight    (PE37_bcount[7:0]                ), //i
    .valid     (PE47_valid                      ), //i
    .signCount (io_signCount_regNextWhen_4[15:0]), //i
    .acount    (PE47_acount[7:0]                ), //o
    .bcount    (PE47_bcount[7:0]                ), //o
    .PE_OUT    (PE47_PE_OUT[31:0]               ), //o
    .finish    (PE47_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE50 (
    .activate  (io_MatrixA_5[7:0]               ), //i
    .weight    (PE40_bcount[7:0]                ), //i
    .valid     (PE50_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE50_acount[7:0]                ), //o
    .bcount    (PE50_bcount[7:0]                ), //o
    .PE_OUT    (PE50_PE_OUT[31:0]               ), //o
    .finish    (PE50_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE51 (
    .activate  (PE50_acount[7:0]                ), //i
    .weight    (PE41_bcount[7:0]                ), //i
    .valid     (PE51_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE51_acount[7:0]                ), //o
    .bcount    (PE51_bcount[7:0]                ), //o
    .PE_OUT    (PE51_PE_OUT[31:0]               ), //o
    .finish    (PE51_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE52 (
    .activate  (PE51_acount[7:0]                ), //i
    .weight    (PE42_bcount[7:0]                ), //i
    .valid     (PE52_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE52_acount[7:0]                ), //o
    .bcount    (PE52_bcount[7:0]                ), //o
    .PE_OUT    (PE52_PE_OUT[31:0]               ), //o
    .finish    (PE52_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE53 (
    .activate  (PE52_acount[7:0]                ), //i
    .weight    (PE43_bcount[7:0]                ), //i
    .valid     (PE53_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE53_acount[7:0]                ), //o
    .bcount    (PE53_bcount[7:0]                ), //o
    .PE_OUT    (PE53_PE_OUT[31:0]               ), //o
    .finish    (PE53_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE54 (
    .activate  (PE53_acount[7:0]                ), //i
    .weight    (PE44_bcount[7:0]                ), //i
    .valid     (PE54_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE54_acount[7:0]                ), //o
    .bcount    (PE54_bcount[7:0]                ), //o
    .PE_OUT    (PE54_PE_OUT[31:0]               ), //o
    .finish    (PE54_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE55 (
    .activate  (PE54_acount[7:0]                ), //i
    .weight    (PE45_bcount[7:0]                ), //i
    .valid     (PE55_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE55_acount[7:0]                ), //o
    .bcount    (PE55_bcount[7:0]                ), //o
    .PE_OUT    (PE55_PE_OUT[31:0]               ), //o
    .finish    (PE55_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE56 (
    .activate  (PE55_acount[7:0]                ), //i
    .weight    (PE46_bcount[7:0]                ), //i
    .valid     (PE56_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE56_acount[7:0]                ), //o
    .bcount    (PE56_bcount[7:0]                ), //o
    .PE_OUT    (PE56_PE_OUT[31:0]               ), //o
    .finish    (PE56_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE57 (
    .activate  (PE56_acount[7:0]                ), //i
    .weight    (PE47_bcount[7:0]                ), //i
    .valid     (PE57_valid                      ), //i
    .signCount (io_signCount_regNextWhen_5[15:0]), //i
    .acount    (PE57_acount[7:0]                ), //o
    .bcount    (PE57_bcount[7:0]                ), //o
    .PE_OUT    (PE57_PE_OUT[31:0]               ), //o
    .finish    (PE57_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE60 (
    .activate  (io_MatrixA_6[7:0]               ), //i
    .weight    (PE50_bcount[7:0]                ), //i
    .valid     (PE60_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE60_acount[7:0]                ), //o
    .bcount    (PE60_bcount[7:0]                ), //o
    .PE_OUT    (PE60_PE_OUT[31:0]               ), //o
    .finish    (PE60_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE61 (
    .activate  (PE60_acount[7:0]                ), //i
    .weight    (PE51_bcount[7:0]                ), //i
    .valid     (PE61_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE61_acount[7:0]                ), //o
    .bcount    (PE61_bcount[7:0]                ), //o
    .PE_OUT    (PE61_PE_OUT[31:0]               ), //o
    .finish    (PE61_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE62 (
    .activate  (PE61_acount[7:0]                ), //i
    .weight    (PE52_bcount[7:0]                ), //i
    .valid     (PE62_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE62_acount[7:0]                ), //o
    .bcount    (PE62_bcount[7:0]                ), //o
    .PE_OUT    (PE62_PE_OUT[31:0]               ), //o
    .finish    (PE62_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE63 (
    .activate  (PE62_acount[7:0]                ), //i
    .weight    (PE53_bcount[7:0]                ), //i
    .valid     (PE63_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE63_acount[7:0]                ), //o
    .bcount    (PE63_bcount[7:0]                ), //o
    .PE_OUT    (PE63_PE_OUT[31:0]               ), //o
    .finish    (PE63_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE64 (
    .activate  (PE63_acount[7:0]                ), //i
    .weight    (PE54_bcount[7:0]                ), //i
    .valid     (PE64_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE64_acount[7:0]                ), //o
    .bcount    (PE64_bcount[7:0]                ), //o
    .PE_OUT    (PE64_PE_OUT[31:0]               ), //o
    .finish    (PE64_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE65 (
    .activate  (PE64_acount[7:0]                ), //i
    .weight    (PE55_bcount[7:0]                ), //i
    .valid     (PE65_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE65_acount[7:0]                ), //o
    .bcount    (PE65_bcount[7:0]                ), //o
    .PE_OUT    (PE65_PE_OUT[31:0]               ), //o
    .finish    (PE65_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE66 (
    .activate  (PE65_acount[7:0]                ), //i
    .weight    (PE56_bcount[7:0]                ), //i
    .valid     (PE66_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE66_acount[7:0]                ), //o
    .bcount    (PE66_bcount[7:0]                ), //o
    .PE_OUT    (PE66_PE_OUT[31:0]               ), //o
    .finish    (PE66_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE67 (
    .activate  (PE66_acount[7:0]                ), //i
    .weight    (PE57_bcount[7:0]                ), //i
    .valid     (PE67_valid                      ), //i
    .signCount (io_signCount_regNextWhen_6[15:0]), //i
    .acount    (PE67_acount[7:0]                ), //o
    .bcount    (PE67_bcount[7:0]                ), //o
    .PE_OUT    (PE67_PE_OUT[31:0]               ), //o
    .finish    (PE67_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE70 (
    .activate  (io_MatrixA_7[7:0]               ), //i
    .weight    (PE60_bcount[7:0]                ), //i
    .valid     (PE70_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE70_acount[7:0]                ), //o
    .bcount    (PE70_bcount[7:0]                ), //o
    .PE_OUT    (PE70_PE_OUT[31:0]               ), //o
    .finish    (PE70_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE71 (
    .activate  (PE70_acount[7:0]                ), //i
    .weight    (PE61_bcount[7:0]                ), //i
    .valid     (PE71_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE71_acount[7:0]                ), //o
    .bcount    (PE71_bcount[7:0]                ), //o
    .PE_OUT    (PE71_PE_OUT[31:0]               ), //o
    .finish    (PE71_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE72 (
    .activate  (PE71_acount[7:0]                ), //i
    .weight    (PE62_bcount[7:0]                ), //i
    .valid     (PE72_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE72_acount[7:0]                ), //o
    .bcount    (PE72_bcount[7:0]                ), //o
    .PE_OUT    (PE72_PE_OUT[31:0]               ), //o
    .finish    (PE72_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE73 (
    .activate  (PE72_acount[7:0]                ), //i
    .weight    (PE63_bcount[7:0]                ), //i
    .valid     (PE73_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE73_acount[7:0]                ), //o
    .bcount    (PE73_bcount[7:0]                ), //o
    .PE_OUT    (PE73_PE_OUT[31:0]               ), //o
    .finish    (PE73_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE74 (
    .activate  (PE73_acount[7:0]                ), //i
    .weight    (PE64_bcount[7:0]                ), //i
    .valid     (PE74_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE74_acount[7:0]                ), //o
    .bcount    (PE74_bcount[7:0]                ), //o
    .PE_OUT    (PE74_PE_OUT[31:0]               ), //o
    .finish    (PE74_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE75 (
    .activate  (PE74_acount[7:0]                ), //i
    .weight    (PE65_bcount[7:0]                ), //i
    .valid     (PE75_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE75_acount[7:0]                ), //o
    .bcount    (PE75_bcount[7:0]                ), //o
    .PE_OUT    (PE75_PE_OUT[31:0]               ), //o
    .finish    (PE75_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE76 (
    .activate  (PE75_acount[7:0]                ), //i
    .weight    (PE66_bcount[7:0]                ), //i
    .valid     (PE76_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE76_acount[7:0]                ), //o
    .bcount    (PE76_bcount[7:0]                ), //o
    .PE_OUT    (PE76_PE_OUT[31:0]               ), //o
    .finish    (PE76_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  PE PE77 (
    .activate  (PE76_acount[7:0]                ), //i
    .weight    (PE67_bcount[7:0]                ), //i
    .valid     (PE77_valid                      ), //i
    .signCount (io_signCount_regNextWhen_7[15:0]), //i
    .acount    (PE77_acount[7:0]                ), //o
    .bcount    (PE77_bcount[7:0]                ), //o
    .PE_OUT    (PE77_PE_OUT[31:0]               ), //o
    .finish    (PE77_finish                     ), //o
    .clk       (clk                             ), //i
    .reset     (reset                           )  //i
  );
  always @(*) begin
    MatrixC_0 = 32'h0;
    if(PE00_finish) begin
      MatrixC_0 = PE00_PE_OUT;
    end
    if(PE01_finish) begin
      MatrixC_0 = PE01_PE_OUT;
    end
    if(PE02_finish) begin
      MatrixC_0 = PE02_PE_OUT;
    end
    if(PE03_finish) begin
      MatrixC_0 = PE03_PE_OUT;
    end
    if(PE04_finish) begin
      MatrixC_0 = PE04_PE_OUT;
    end
    if(PE05_finish) begin
      MatrixC_0 = PE05_PE_OUT;
    end
    if(PE06_finish) begin
      MatrixC_0 = PE06_PE_OUT;
    end
    if(PE07_finish) begin
      MatrixC_0 = PE07_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_0[0] = PE00_finish;
    _zz_C_Valid_0[1] = PE01_finish;
    _zz_C_Valid_0[2] = PE02_finish;
    _zz_C_Valid_0[3] = PE03_finish;
    _zz_C_Valid_0[4] = PE04_finish;
    _zz_C_Valid_0[5] = PE05_finish;
    _zz_C_Valid_0[6] = PE06_finish;
    _zz_C_Valid_0[7] = PE07_finish;
  end

  assign C_Valid_0 = (|_zz_C_Valid_0);
  always @(*) begin
    MatrixC_1 = 32'h0;
    if(PE10_finish) begin
      MatrixC_1 = PE10_PE_OUT;
    end
    if(PE11_finish) begin
      MatrixC_1 = PE11_PE_OUT;
    end
    if(PE12_finish) begin
      MatrixC_1 = PE12_PE_OUT;
    end
    if(PE13_finish) begin
      MatrixC_1 = PE13_PE_OUT;
    end
    if(PE14_finish) begin
      MatrixC_1 = PE14_PE_OUT;
    end
    if(PE15_finish) begin
      MatrixC_1 = PE15_PE_OUT;
    end
    if(PE16_finish) begin
      MatrixC_1 = PE16_PE_OUT;
    end
    if(PE17_finish) begin
      MatrixC_1 = PE17_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_1[0] = PE10_finish;
    _zz_C_Valid_1[1] = PE11_finish;
    _zz_C_Valid_1[2] = PE12_finish;
    _zz_C_Valid_1[3] = PE13_finish;
    _zz_C_Valid_1[4] = PE14_finish;
    _zz_C_Valid_1[5] = PE15_finish;
    _zz_C_Valid_1[6] = PE16_finish;
    _zz_C_Valid_1[7] = PE17_finish;
  end

  assign C_Valid_1 = (|_zz_C_Valid_1);
  always @(*) begin
    MatrixC_2 = 32'h0;
    if(PE20_finish) begin
      MatrixC_2 = PE20_PE_OUT;
    end
    if(PE21_finish) begin
      MatrixC_2 = PE21_PE_OUT;
    end
    if(PE22_finish) begin
      MatrixC_2 = PE22_PE_OUT;
    end
    if(PE23_finish) begin
      MatrixC_2 = PE23_PE_OUT;
    end
    if(PE24_finish) begin
      MatrixC_2 = PE24_PE_OUT;
    end
    if(PE25_finish) begin
      MatrixC_2 = PE25_PE_OUT;
    end
    if(PE26_finish) begin
      MatrixC_2 = PE26_PE_OUT;
    end
    if(PE27_finish) begin
      MatrixC_2 = PE27_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_2[0] = PE20_finish;
    _zz_C_Valid_2[1] = PE21_finish;
    _zz_C_Valid_2[2] = PE22_finish;
    _zz_C_Valid_2[3] = PE23_finish;
    _zz_C_Valid_2[4] = PE24_finish;
    _zz_C_Valid_2[5] = PE25_finish;
    _zz_C_Valid_2[6] = PE26_finish;
    _zz_C_Valid_2[7] = PE27_finish;
  end

  assign C_Valid_2 = (|_zz_C_Valid_2);
  always @(*) begin
    MatrixC_3 = 32'h0;
    if(PE30_finish) begin
      MatrixC_3 = PE30_PE_OUT;
    end
    if(PE31_finish) begin
      MatrixC_3 = PE31_PE_OUT;
    end
    if(PE32_finish) begin
      MatrixC_3 = PE32_PE_OUT;
    end
    if(PE33_finish) begin
      MatrixC_3 = PE33_PE_OUT;
    end
    if(PE34_finish) begin
      MatrixC_3 = PE34_PE_OUT;
    end
    if(PE35_finish) begin
      MatrixC_3 = PE35_PE_OUT;
    end
    if(PE36_finish) begin
      MatrixC_3 = PE36_PE_OUT;
    end
    if(PE37_finish) begin
      MatrixC_3 = PE37_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_3[0] = PE30_finish;
    _zz_C_Valid_3[1] = PE31_finish;
    _zz_C_Valid_3[2] = PE32_finish;
    _zz_C_Valid_3[3] = PE33_finish;
    _zz_C_Valid_3[4] = PE34_finish;
    _zz_C_Valid_3[5] = PE35_finish;
    _zz_C_Valid_3[6] = PE36_finish;
    _zz_C_Valid_3[7] = PE37_finish;
  end

  assign C_Valid_3 = (|_zz_C_Valid_3);
  always @(*) begin
    MatrixC_4 = 32'h0;
    if(PE40_finish) begin
      MatrixC_4 = PE40_PE_OUT;
    end
    if(PE41_finish) begin
      MatrixC_4 = PE41_PE_OUT;
    end
    if(PE42_finish) begin
      MatrixC_4 = PE42_PE_OUT;
    end
    if(PE43_finish) begin
      MatrixC_4 = PE43_PE_OUT;
    end
    if(PE44_finish) begin
      MatrixC_4 = PE44_PE_OUT;
    end
    if(PE45_finish) begin
      MatrixC_4 = PE45_PE_OUT;
    end
    if(PE46_finish) begin
      MatrixC_4 = PE46_PE_OUT;
    end
    if(PE47_finish) begin
      MatrixC_4 = PE47_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_4[0] = PE40_finish;
    _zz_C_Valid_4[1] = PE41_finish;
    _zz_C_Valid_4[2] = PE42_finish;
    _zz_C_Valid_4[3] = PE43_finish;
    _zz_C_Valid_4[4] = PE44_finish;
    _zz_C_Valid_4[5] = PE45_finish;
    _zz_C_Valid_4[6] = PE46_finish;
    _zz_C_Valid_4[7] = PE47_finish;
  end

  assign C_Valid_4 = (|_zz_C_Valid_4);
  always @(*) begin
    MatrixC_5 = 32'h0;
    if(PE50_finish) begin
      MatrixC_5 = PE50_PE_OUT;
    end
    if(PE51_finish) begin
      MatrixC_5 = PE51_PE_OUT;
    end
    if(PE52_finish) begin
      MatrixC_5 = PE52_PE_OUT;
    end
    if(PE53_finish) begin
      MatrixC_5 = PE53_PE_OUT;
    end
    if(PE54_finish) begin
      MatrixC_5 = PE54_PE_OUT;
    end
    if(PE55_finish) begin
      MatrixC_5 = PE55_PE_OUT;
    end
    if(PE56_finish) begin
      MatrixC_5 = PE56_PE_OUT;
    end
    if(PE57_finish) begin
      MatrixC_5 = PE57_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_5[0] = PE50_finish;
    _zz_C_Valid_5[1] = PE51_finish;
    _zz_C_Valid_5[2] = PE52_finish;
    _zz_C_Valid_5[3] = PE53_finish;
    _zz_C_Valid_5[4] = PE54_finish;
    _zz_C_Valid_5[5] = PE55_finish;
    _zz_C_Valid_5[6] = PE56_finish;
    _zz_C_Valid_5[7] = PE57_finish;
  end

  assign C_Valid_5 = (|_zz_C_Valid_5);
  always @(*) begin
    MatrixC_6 = 32'h0;
    if(PE60_finish) begin
      MatrixC_6 = PE60_PE_OUT;
    end
    if(PE61_finish) begin
      MatrixC_6 = PE61_PE_OUT;
    end
    if(PE62_finish) begin
      MatrixC_6 = PE62_PE_OUT;
    end
    if(PE63_finish) begin
      MatrixC_6 = PE63_PE_OUT;
    end
    if(PE64_finish) begin
      MatrixC_6 = PE64_PE_OUT;
    end
    if(PE65_finish) begin
      MatrixC_6 = PE65_PE_OUT;
    end
    if(PE66_finish) begin
      MatrixC_6 = PE66_PE_OUT;
    end
    if(PE67_finish) begin
      MatrixC_6 = PE67_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_6[0] = PE60_finish;
    _zz_C_Valid_6[1] = PE61_finish;
    _zz_C_Valid_6[2] = PE62_finish;
    _zz_C_Valid_6[3] = PE63_finish;
    _zz_C_Valid_6[4] = PE64_finish;
    _zz_C_Valid_6[5] = PE65_finish;
    _zz_C_Valid_6[6] = PE66_finish;
    _zz_C_Valid_6[7] = PE67_finish;
  end

  assign C_Valid_6 = (|_zz_C_Valid_6);
  always @(*) begin
    MatrixC_7 = 32'h0;
    if(PE70_finish) begin
      MatrixC_7 = PE70_PE_OUT;
    end
    if(PE71_finish) begin
      MatrixC_7 = PE71_PE_OUT;
    end
    if(PE72_finish) begin
      MatrixC_7 = PE72_PE_OUT;
    end
    if(PE73_finish) begin
      MatrixC_7 = PE73_PE_OUT;
    end
    if(PE74_finish) begin
      MatrixC_7 = PE74_PE_OUT;
    end
    if(PE75_finish) begin
      MatrixC_7 = PE75_PE_OUT;
    end
    if(PE76_finish) begin
      MatrixC_7 = PE76_PE_OUT;
    end
    if(PE77_finish) begin
      MatrixC_7 = PE77_PE_OUT;
    end
  end

  always @(*) begin
    _zz_C_Valid_7[0] = PE70_finish;
    _zz_C_Valid_7[1] = PE71_finish;
    _zz_C_Valid_7[2] = PE72_finish;
    _zz_C_Valid_7[3] = PE73_finish;
    _zz_C_Valid_7[4] = PE74_finish;
    _zz_C_Valid_7[5] = PE75_finish;
    _zz_C_Valid_7[6] = PE76_finish;
    _zz_C_Valid_7[7] = PE77_finish;
  end

  assign C_Valid_7 = (|_zz_C_Valid_7);
  assign PE00_valid = (io_A_Valid_0 && io_B_Valid_0);
  assign PE01_valid = (io_A_Valid_0_delay_1 && io_B_Valid_1);
  assign PE02_valid = (io_A_Valid_0_delay_2 && io_B_Valid_2);
  assign PE03_valid = (io_A_Valid_0_delay_3 && io_B_Valid_3);
  assign PE04_valid = (io_A_Valid_0_delay_4 && io_B_Valid_4);
  assign PE05_valid = (io_A_Valid_0_delay_5 && io_B_Valid_5);
  assign PE06_valid = (io_A_Valid_0_delay_6 && io_B_Valid_6);
  assign PE07_valid = (io_A_Valid_0_delay_7 && io_B_Valid_7);
  assign PE10_valid = (io_A_Valid_1 && io_B_Valid_0_delay_1);
  assign PE11_valid = (io_A_Valid_1_delay_1 && io_B_Valid_1_delay_1);
  assign PE12_valid = (io_A_Valid_1_delay_2 && io_B_Valid_2_delay_1);
  assign PE13_valid = (io_A_Valid_1_delay_3 && io_B_Valid_3_delay_1);
  assign PE14_valid = (io_A_Valid_1_delay_4 && io_B_Valid_4_delay_1);
  assign PE15_valid = (io_A_Valid_1_delay_5 && io_B_Valid_5_delay_1);
  assign PE16_valid = (io_A_Valid_1_delay_6 && io_B_Valid_6_delay_1);
  assign PE17_valid = (io_A_Valid_1_delay_7 && io_B_Valid_7_delay_1);
  assign PE20_valid = (io_A_Valid_2 && io_B_Valid_0_delay_2);
  assign PE21_valid = (io_A_Valid_2_delay_1 && io_B_Valid_1_delay_2);
  assign PE22_valid = (io_A_Valid_2_delay_2 && io_B_Valid_2_delay_2);
  assign PE23_valid = (io_A_Valid_2_delay_3 && io_B_Valid_3_delay_2);
  assign PE24_valid = (io_A_Valid_2_delay_4 && io_B_Valid_4_delay_2);
  assign PE25_valid = (io_A_Valid_2_delay_5 && io_B_Valid_5_delay_2);
  assign PE26_valid = (io_A_Valid_2_delay_6 && io_B_Valid_6_delay_2);
  assign PE27_valid = (io_A_Valid_2_delay_7 && io_B_Valid_7_delay_2);
  assign PE30_valid = (io_A_Valid_3 && io_B_Valid_0_delay_3);
  assign PE31_valid = (io_A_Valid_3_delay_1 && io_B_Valid_1_delay_3);
  assign PE32_valid = (io_A_Valid_3_delay_2 && io_B_Valid_2_delay_3);
  assign PE33_valid = (io_A_Valid_3_delay_3 && io_B_Valid_3_delay_3);
  assign PE34_valid = (io_A_Valid_3_delay_4 && io_B_Valid_4_delay_3);
  assign PE35_valid = (io_A_Valid_3_delay_5 && io_B_Valid_5_delay_3);
  assign PE36_valid = (io_A_Valid_3_delay_6 && io_B_Valid_6_delay_3);
  assign PE37_valid = (io_A_Valid_3_delay_7 && io_B_Valid_7_delay_3);
  assign PE40_valid = (io_A_Valid_4 && io_B_Valid_0_delay_4);
  assign PE41_valid = (io_A_Valid_4_delay_1 && io_B_Valid_1_delay_4);
  assign PE42_valid = (io_A_Valid_4_delay_2 && io_B_Valid_2_delay_4);
  assign PE43_valid = (io_A_Valid_4_delay_3 && io_B_Valid_3_delay_4);
  assign PE44_valid = (io_A_Valid_4_delay_4 && io_B_Valid_4_delay_4);
  assign PE45_valid = (io_A_Valid_4_delay_5 && io_B_Valid_5_delay_4);
  assign PE46_valid = (io_A_Valid_4_delay_6 && io_B_Valid_6_delay_4);
  assign PE47_valid = (io_A_Valid_4_delay_7 && io_B_Valid_7_delay_4);
  assign PE50_valid = (io_A_Valid_5 && io_B_Valid_0_delay_5);
  assign PE51_valid = (io_A_Valid_5_delay_1 && io_B_Valid_1_delay_5);
  assign PE52_valid = (io_A_Valid_5_delay_2 && io_B_Valid_2_delay_5);
  assign PE53_valid = (io_A_Valid_5_delay_3 && io_B_Valid_3_delay_5);
  assign PE54_valid = (io_A_Valid_5_delay_4 && io_B_Valid_4_delay_5);
  assign PE55_valid = (io_A_Valid_5_delay_5 && io_B_Valid_5_delay_5);
  assign PE56_valid = (io_A_Valid_5_delay_6 && io_B_Valid_6_delay_5);
  assign PE57_valid = (io_A_Valid_5_delay_7 && io_B_Valid_7_delay_5);
  assign PE60_valid = (io_A_Valid_6 && io_B_Valid_0_delay_6);
  assign PE61_valid = (io_A_Valid_6_delay_1 && io_B_Valid_1_delay_6);
  assign PE62_valid = (io_A_Valid_6_delay_2 && io_B_Valid_2_delay_6);
  assign PE63_valid = (io_A_Valid_6_delay_3 && io_B_Valid_3_delay_6);
  assign PE64_valid = (io_A_Valid_6_delay_4 && io_B_Valid_4_delay_6);
  assign PE65_valid = (io_A_Valid_6_delay_5 && io_B_Valid_5_delay_6);
  assign PE66_valid = (io_A_Valid_6_delay_6 && io_B_Valid_6_delay_6);
  assign PE67_valid = (io_A_Valid_6_delay_7 && io_B_Valid_7_delay_6);
  assign PE70_valid = (io_A_Valid_7 && io_B_Valid_0_delay_7);
  assign PE71_valid = (io_A_Valid_7_delay_1 && io_B_Valid_1_delay_7);
  assign PE72_valid = (io_A_Valid_7_delay_2 && io_B_Valid_2_delay_7);
  assign PE73_valid = (io_A_Valid_7_delay_3 && io_B_Valid_3_delay_7);
  assign PE74_valid = (io_A_Valid_7_delay_4 && io_B_Valid_4_delay_7);
  assign PE75_valid = (io_A_Valid_7_delay_5 && io_B_Valid_5_delay_7);
  assign PE76_valid = (io_A_Valid_7_delay_6 && io_B_Valid_6_delay_7);
  assign PE77_valid = (io_A_Valid_7_delay_7 && io_B_Valid_7_delay_7);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      io_signCount_regNextWhen <= 16'h0;
      io_signCount_regNextWhen_1 <= 16'h0;
      io_signCount_regNextWhen_2 <= 16'h0;
      io_signCount_regNextWhen_3 <= 16'h0;
      io_signCount_regNextWhen_4 <= 16'h0;
      io_signCount_regNextWhen_5 <= 16'h0;
      io_signCount_regNextWhen_6 <= 16'h0;
      io_signCount_regNextWhen_7 <= 16'h0;
    end else begin
      if(start) begin
        io_signCount_regNextWhen <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_1 <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_2 <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_3 <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_4 <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_5 <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_6 <= io_signCount;
      end
      if(start) begin
        io_signCount_regNextWhen_7 <= io_signCount;
      end
    end
  end

  always @(posedge clk) begin
    io_A_Valid_0_delay_1 <= io_A_Valid_0;
    io_A_Valid_0_delay_1_1 <= io_A_Valid_0;
    io_A_Valid_0_delay_2 <= io_A_Valid_0_delay_1_1;
    io_A_Valid_0_delay_1_2 <= io_A_Valid_0;
    io_A_Valid_0_delay_2_1 <= io_A_Valid_0_delay_1_2;
    io_A_Valid_0_delay_3 <= io_A_Valid_0_delay_2_1;
    io_A_Valid_0_delay_1_3 <= io_A_Valid_0;
    io_A_Valid_0_delay_2_2 <= io_A_Valid_0_delay_1_3;
    io_A_Valid_0_delay_3_1 <= io_A_Valid_0_delay_2_2;
    io_A_Valid_0_delay_4 <= io_A_Valid_0_delay_3_1;
    io_A_Valid_0_delay_1_4 <= io_A_Valid_0;
    io_A_Valid_0_delay_2_3 <= io_A_Valid_0_delay_1_4;
    io_A_Valid_0_delay_3_2 <= io_A_Valid_0_delay_2_3;
    io_A_Valid_0_delay_4_1 <= io_A_Valid_0_delay_3_2;
    io_A_Valid_0_delay_5 <= io_A_Valid_0_delay_4_1;
    io_A_Valid_0_delay_1_5 <= io_A_Valid_0;
    io_A_Valid_0_delay_2_4 <= io_A_Valid_0_delay_1_5;
    io_A_Valid_0_delay_3_3 <= io_A_Valid_0_delay_2_4;
    io_A_Valid_0_delay_4_2 <= io_A_Valid_0_delay_3_3;
    io_A_Valid_0_delay_5_1 <= io_A_Valid_0_delay_4_2;
    io_A_Valid_0_delay_6 <= io_A_Valid_0_delay_5_1;
    io_A_Valid_0_delay_1_6 <= io_A_Valid_0;
    io_A_Valid_0_delay_2_5 <= io_A_Valid_0_delay_1_6;
    io_A_Valid_0_delay_3_4 <= io_A_Valid_0_delay_2_5;
    io_A_Valid_0_delay_4_3 <= io_A_Valid_0_delay_3_4;
    io_A_Valid_0_delay_5_2 <= io_A_Valid_0_delay_4_3;
    io_A_Valid_0_delay_6_1 <= io_A_Valid_0_delay_5_2;
    io_A_Valid_0_delay_7 <= io_A_Valid_0_delay_6_1;
    io_B_Valid_0_delay_1 <= io_B_Valid_0;
    io_A_Valid_1_delay_1 <= io_A_Valid_1;
    io_B_Valid_1_delay_1 <= io_B_Valid_1;
    io_A_Valid_1_delay_1_1 <= io_A_Valid_1;
    io_A_Valid_1_delay_2 <= io_A_Valid_1_delay_1_1;
    io_B_Valid_2_delay_1 <= io_B_Valid_2;
    io_A_Valid_1_delay_1_2 <= io_A_Valid_1;
    io_A_Valid_1_delay_2_1 <= io_A_Valid_1_delay_1_2;
    io_A_Valid_1_delay_3 <= io_A_Valid_1_delay_2_1;
    io_B_Valid_3_delay_1 <= io_B_Valid_3;
    io_A_Valid_1_delay_1_3 <= io_A_Valid_1;
    io_A_Valid_1_delay_2_2 <= io_A_Valid_1_delay_1_3;
    io_A_Valid_1_delay_3_1 <= io_A_Valid_1_delay_2_2;
    io_A_Valid_1_delay_4 <= io_A_Valid_1_delay_3_1;
    io_B_Valid_4_delay_1 <= io_B_Valid_4;
    io_A_Valid_1_delay_1_4 <= io_A_Valid_1;
    io_A_Valid_1_delay_2_3 <= io_A_Valid_1_delay_1_4;
    io_A_Valid_1_delay_3_2 <= io_A_Valid_1_delay_2_3;
    io_A_Valid_1_delay_4_1 <= io_A_Valid_1_delay_3_2;
    io_A_Valid_1_delay_5 <= io_A_Valid_1_delay_4_1;
    io_B_Valid_5_delay_1 <= io_B_Valid_5;
    io_A_Valid_1_delay_1_5 <= io_A_Valid_1;
    io_A_Valid_1_delay_2_4 <= io_A_Valid_1_delay_1_5;
    io_A_Valid_1_delay_3_3 <= io_A_Valid_1_delay_2_4;
    io_A_Valid_1_delay_4_2 <= io_A_Valid_1_delay_3_3;
    io_A_Valid_1_delay_5_1 <= io_A_Valid_1_delay_4_2;
    io_A_Valid_1_delay_6 <= io_A_Valid_1_delay_5_1;
    io_B_Valid_6_delay_1 <= io_B_Valid_6;
    io_A_Valid_1_delay_1_6 <= io_A_Valid_1;
    io_A_Valid_1_delay_2_5 <= io_A_Valid_1_delay_1_6;
    io_A_Valid_1_delay_3_4 <= io_A_Valid_1_delay_2_5;
    io_A_Valid_1_delay_4_3 <= io_A_Valid_1_delay_3_4;
    io_A_Valid_1_delay_5_2 <= io_A_Valid_1_delay_4_3;
    io_A_Valid_1_delay_6_1 <= io_A_Valid_1_delay_5_2;
    io_A_Valid_1_delay_7 <= io_A_Valid_1_delay_6_1;
    io_B_Valid_7_delay_1 <= io_B_Valid_7;
    io_B_Valid_0_delay_1_1 <= io_B_Valid_0;
    io_B_Valid_0_delay_2 <= io_B_Valid_0_delay_1_1;
    io_A_Valid_2_delay_1 <= io_A_Valid_2;
    io_B_Valid_1_delay_1_1 <= io_B_Valid_1;
    io_B_Valid_1_delay_2 <= io_B_Valid_1_delay_1_1;
    io_A_Valid_2_delay_1_1 <= io_A_Valid_2;
    io_A_Valid_2_delay_2 <= io_A_Valid_2_delay_1_1;
    io_B_Valid_2_delay_1_1 <= io_B_Valid_2;
    io_B_Valid_2_delay_2 <= io_B_Valid_2_delay_1_1;
    io_A_Valid_2_delay_1_2 <= io_A_Valid_2;
    io_A_Valid_2_delay_2_1 <= io_A_Valid_2_delay_1_2;
    io_A_Valid_2_delay_3 <= io_A_Valid_2_delay_2_1;
    io_B_Valid_3_delay_1_1 <= io_B_Valid_3;
    io_B_Valid_3_delay_2 <= io_B_Valid_3_delay_1_1;
    io_A_Valid_2_delay_1_3 <= io_A_Valid_2;
    io_A_Valid_2_delay_2_2 <= io_A_Valid_2_delay_1_3;
    io_A_Valid_2_delay_3_1 <= io_A_Valid_2_delay_2_2;
    io_A_Valid_2_delay_4 <= io_A_Valid_2_delay_3_1;
    io_B_Valid_4_delay_1_1 <= io_B_Valid_4;
    io_B_Valid_4_delay_2 <= io_B_Valid_4_delay_1_1;
    io_A_Valid_2_delay_1_4 <= io_A_Valid_2;
    io_A_Valid_2_delay_2_3 <= io_A_Valid_2_delay_1_4;
    io_A_Valid_2_delay_3_2 <= io_A_Valid_2_delay_2_3;
    io_A_Valid_2_delay_4_1 <= io_A_Valid_2_delay_3_2;
    io_A_Valid_2_delay_5 <= io_A_Valid_2_delay_4_1;
    io_B_Valid_5_delay_1_1 <= io_B_Valid_5;
    io_B_Valid_5_delay_2 <= io_B_Valid_5_delay_1_1;
    io_A_Valid_2_delay_1_5 <= io_A_Valid_2;
    io_A_Valid_2_delay_2_4 <= io_A_Valid_2_delay_1_5;
    io_A_Valid_2_delay_3_3 <= io_A_Valid_2_delay_2_4;
    io_A_Valid_2_delay_4_2 <= io_A_Valid_2_delay_3_3;
    io_A_Valid_2_delay_5_1 <= io_A_Valid_2_delay_4_2;
    io_A_Valid_2_delay_6 <= io_A_Valid_2_delay_5_1;
    io_B_Valid_6_delay_1_1 <= io_B_Valid_6;
    io_B_Valid_6_delay_2 <= io_B_Valid_6_delay_1_1;
    io_A_Valid_2_delay_1_6 <= io_A_Valid_2;
    io_A_Valid_2_delay_2_5 <= io_A_Valid_2_delay_1_6;
    io_A_Valid_2_delay_3_4 <= io_A_Valid_2_delay_2_5;
    io_A_Valid_2_delay_4_3 <= io_A_Valid_2_delay_3_4;
    io_A_Valid_2_delay_5_2 <= io_A_Valid_2_delay_4_3;
    io_A_Valid_2_delay_6_1 <= io_A_Valid_2_delay_5_2;
    io_A_Valid_2_delay_7 <= io_A_Valid_2_delay_6_1;
    io_B_Valid_7_delay_1_1 <= io_B_Valid_7;
    io_B_Valid_7_delay_2 <= io_B_Valid_7_delay_1_1;
    io_B_Valid_0_delay_1_2 <= io_B_Valid_0;
    io_B_Valid_0_delay_2_1 <= io_B_Valid_0_delay_1_2;
    io_B_Valid_0_delay_3 <= io_B_Valid_0_delay_2_1;
    io_A_Valid_3_delay_1 <= io_A_Valid_3;
    io_B_Valid_1_delay_1_2 <= io_B_Valid_1;
    io_B_Valid_1_delay_2_1 <= io_B_Valid_1_delay_1_2;
    io_B_Valid_1_delay_3 <= io_B_Valid_1_delay_2_1;
    io_A_Valid_3_delay_1_1 <= io_A_Valid_3;
    io_A_Valid_3_delay_2 <= io_A_Valid_3_delay_1_1;
    io_B_Valid_2_delay_1_2 <= io_B_Valid_2;
    io_B_Valid_2_delay_2_1 <= io_B_Valid_2_delay_1_2;
    io_B_Valid_2_delay_3 <= io_B_Valid_2_delay_2_1;
    io_A_Valid_3_delay_1_2 <= io_A_Valid_3;
    io_A_Valid_3_delay_2_1 <= io_A_Valid_3_delay_1_2;
    io_A_Valid_3_delay_3 <= io_A_Valid_3_delay_2_1;
    io_B_Valid_3_delay_1_2 <= io_B_Valid_3;
    io_B_Valid_3_delay_2_1 <= io_B_Valid_3_delay_1_2;
    io_B_Valid_3_delay_3 <= io_B_Valid_3_delay_2_1;
    io_A_Valid_3_delay_1_3 <= io_A_Valid_3;
    io_A_Valid_3_delay_2_2 <= io_A_Valid_3_delay_1_3;
    io_A_Valid_3_delay_3_1 <= io_A_Valid_3_delay_2_2;
    io_A_Valid_3_delay_4 <= io_A_Valid_3_delay_3_1;
    io_B_Valid_4_delay_1_2 <= io_B_Valid_4;
    io_B_Valid_4_delay_2_1 <= io_B_Valid_4_delay_1_2;
    io_B_Valid_4_delay_3 <= io_B_Valid_4_delay_2_1;
    io_A_Valid_3_delay_1_4 <= io_A_Valid_3;
    io_A_Valid_3_delay_2_3 <= io_A_Valid_3_delay_1_4;
    io_A_Valid_3_delay_3_2 <= io_A_Valid_3_delay_2_3;
    io_A_Valid_3_delay_4_1 <= io_A_Valid_3_delay_3_2;
    io_A_Valid_3_delay_5 <= io_A_Valid_3_delay_4_1;
    io_B_Valid_5_delay_1_2 <= io_B_Valid_5;
    io_B_Valid_5_delay_2_1 <= io_B_Valid_5_delay_1_2;
    io_B_Valid_5_delay_3 <= io_B_Valid_5_delay_2_1;
    io_A_Valid_3_delay_1_5 <= io_A_Valid_3;
    io_A_Valid_3_delay_2_4 <= io_A_Valid_3_delay_1_5;
    io_A_Valid_3_delay_3_3 <= io_A_Valid_3_delay_2_4;
    io_A_Valid_3_delay_4_2 <= io_A_Valid_3_delay_3_3;
    io_A_Valid_3_delay_5_1 <= io_A_Valid_3_delay_4_2;
    io_A_Valid_3_delay_6 <= io_A_Valid_3_delay_5_1;
    io_B_Valid_6_delay_1_2 <= io_B_Valid_6;
    io_B_Valid_6_delay_2_1 <= io_B_Valid_6_delay_1_2;
    io_B_Valid_6_delay_3 <= io_B_Valid_6_delay_2_1;
    io_A_Valid_3_delay_1_6 <= io_A_Valid_3;
    io_A_Valid_3_delay_2_5 <= io_A_Valid_3_delay_1_6;
    io_A_Valid_3_delay_3_4 <= io_A_Valid_3_delay_2_5;
    io_A_Valid_3_delay_4_3 <= io_A_Valid_3_delay_3_4;
    io_A_Valid_3_delay_5_2 <= io_A_Valid_3_delay_4_3;
    io_A_Valid_3_delay_6_1 <= io_A_Valid_3_delay_5_2;
    io_A_Valid_3_delay_7 <= io_A_Valid_3_delay_6_1;
    io_B_Valid_7_delay_1_2 <= io_B_Valid_7;
    io_B_Valid_7_delay_2_1 <= io_B_Valid_7_delay_1_2;
    io_B_Valid_7_delay_3 <= io_B_Valid_7_delay_2_1;
    io_B_Valid_0_delay_1_3 <= io_B_Valid_0;
    io_B_Valid_0_delay_2_2 <= io_B_Valid_0_delay_1_3;
    io_B_Valid_0_delay_3_1 <= io_B_Valid_0_delay_2_2;
    io_B_Valid_0_delay_4 <= io_B_Valid_0_delay_3_1;
    io_A_Valid_4_delay_1 <= io_A_Valid_4;
    io_B_Valid_1_delay_1_3 <= io_B_Valid_1;
    io_B_Valid_1_delay_2_2 <= io_B_Valid_1_delay_1_3;
    io_B_Valid_1_delay_3_1 <= io_B_Valid_1_delay_2_2;
    io_B_Valid_1_delay_4 <= io_B_Valid_1_delay_3_1;
    io_A_Valid_4_delay_1_1 <= io_A_Valid_4;
    io_A_Valid_4_delay_2 <= io_A_Valid_4_delay_1_1;
    io_B_Valid_2_delay_1_3 <= io_B_Valid_2;
    io_B_Valid_2_delay_2_2 <= io_B_Valid_2_delay_1_3;
    io_B_Valid_2_delay_3_1 <= io_B_Valid_2_delay_2_2;
    io_B_Valid_2_delay_4 <= io_B_Valid_2_delay_3_1;
    io_A_Valid_4_delay_1_2 <= io_A_Valid_4;
    io_A_Valid_4_delay_2_1 <= io_A_Valid_4_delay_1_2;
    io_A_Valid_4_delay_3 <= io_A_Valid_4_delay_2_1;
    io_B_Valid_3_delay_1_3 <= io_B_Valid_3;
    io_B_Valid_3_delay_2_2 <= io_B_Valid_3_delay_1_3;
    io_B_Valid_3_delay_3_1 <= io_B_Valid_3_delay_2_2;
    io_B_Valid_3_delay_4 <= io_B_Valid_3_delay_3_1;
    io_A_Valid_4_delay_1_3 <= io_A_Valid_4;
    io_A_Valid_4_delay_2_2 <= io_A_Valid_4_delay_1_3;
    io_A_Valid_4_delay_3_1 <= io_A_Valid_4_delay_2_2;
    io_A_Valid_4_delay_4 <= io_A_Valid_4_delay_3_1;
    io_B_Valid_4_delay_1_3 <= io_B_Valid_4;
    io_B_Valid_4_delay_2_2 <= io_B_Valid_4_delay_1_3;
    io_B_Valid_4_delay_3_1 <= io_B_Valid_4_delay_2_2;
    io_B_Valid_4_delay_4 <= io_B_Valid_4_delay_3_1;
    io_A_Valid_4_delay_1_4 <= io_A_Valid_4;
    io_A_Valid_4_delay_2_3 <= io_A_Valid_4_delay_1_4;
    io_A_Valid_4_delay_3_2 <= io_A_Valid_4_delay_2_3;
    io_A_Valid_4_delay_4_1 <= io_A_Valid_4_delay_3_2;
    io_A_Valid_4_delay_5 <= io_A_Valid_4_delay_4_1;
    io_B_Valid_5_delay_1_3 <= io_B_Valid_5;
    io_B_Valid_5_delay_2_2 <= io_B_Valid_5_delay_1_3;
    io_B_Valid_5_delay_3_1 <= io_B_Valid_5_delay_2_2;
    io_B_Valid_5_delay_4 <= io_B_Valid_5_delay_3_1;
    io_A_Valid_4_delay_1_5 <= io_A_Valid_4;
    io_A_Valid_4_delay_2_4 <= io_A_Valid_4_delay_1_5;
    io_A_Valid_4_delay_3_3 <= io_A_Valid_4_delay_2_4;
    io_A_Valid_4_delay_4_2 <= io_A_Valid_4_delay_3_3;
    io_A_Valid_4_delay_5_1 <= io_A_Valid_4_delay_4_2;
    io_A_Valid_4_delay_6 <= io_A_Valid_4_delay_5_1;
    io_B_Valid_6_delay_1_3 <= io_B_Valid_6;
    io_B_Valid_6_delay_2_2 <= io_B_Valid_6_delay_1_3;
    io_B_Valid_6_delay_3_1 <= io_B_Valid_6_delay_2_2;
    io_B_Valid_6_delay_4 <= io_B_Valid_6_delay_3_1;
    io_A_Valid_4_delay_1_6 <= io_A_Valid_4;
    io_A_Valid_4_delay_2_5 <= io_A_Valid_4_delay_1_6;
    io_A_Valid_4_delay_3_4 <= io_A_Valid_4_delay_2_5;
    io_A_Valid_4_delay_4_3 <= io_A_Valid_4_delay_3_4;
    io_A_Valid_4_delay_5_2 <= io_A_Valid_4_delay_4_3;
    io_A_Valid_4_delay_6_1 <= io_A_Valid_4_delay_5_2;
    io_A_Valid_4_delay_7 <= io_A_Valid_4_delay_6_1;
    io_B_Valid_7_delay_1_3 <= io_B_Valid_7;
    io_B_Valid_7_delay_2_2 <= io_B_Valid_7_delay_1_3;
    io_B_Valid_7_delay_3_1 <= io_B_Valid_7_delay_2_2;
    io_B_Valid_7_delay_4 <= io_B_Valid_7_delay_3_1;
    io_B_Valid_0_delay_1_4 <= io_B_Valid_0;
    io_B_Valid_0_delay_2_3 <= io_B_Valid_0_delay_1_4;
    io_B_Valid_0_delay_3_2 <= io_B_Valid_0_delay_2_3;
    io_B_Valid_0_delay_4_1 <= io_B_Valid_0_delay_3_2;
    io_B_Valid_0_delay_5 <= io_B_Valid_0_delay_4_1;
    io_A_Valid_5_delay_1 <= io_A_Valid_5;
    io_B_Valid_1_delay_1_4 <= io_B_Valid_1;
    io_B_Valid_1_delay_2_3 <= io_B_Valid_1_delay_1_4;
    io_B_Valid_1_delay_3_2 <= io_B_Valid_1_delay_2_3;
    io_B_Valid_1_delay_4_1 <= io_B_Valid_1_delay_3_2;
    io_B_Valid_1_delay_5 <= io_B_Valid_1_delay_4_1;
    io_A_Valid_5_delay_1_1 <= io_A_Valid_5;
    io_A_Valid_5_delay_2 <= io_A_Valid_5_delay_1_1;
    io_B_Valid_2_delay_1_4 <= io_B_Valid_2;
    io_B_Valid_2_delay_2_3 <= io_B_Valid_2_delay_1_4;
    io_B_Valid_2_delay_3_2 <= io_B_Valid_2_delay_2_3;
    io_B_Valid_2_delay_4_1 <= io_B_Valid_2_delay_3_2;
    io_B_Valid_2_delay_5 <= io_B_Valid_2_delay_4_1;
    io_A_Valid_5_delay_1_2 <= io_A_Valid_5;
    io_A_Valid_5_delay_2_1 <= io_A_Valid_5_delay_1_2;
    io_A_Valid_5_delay_3 <= io_A_Valid_5_delay_2_1;
    io_B_Valid_3_delay_1_4 <= io_B_Valid_3;
    io_B_Valid_3_delay_2_3 <= io_B_Valid_3_delay_1_4;
    io_B_Valid_3_delay_3_2 <= io_B_Valid_3_delay_2_3;
    io_B_Valid_3_delay_4_1 <= io_B_Valid_3_delay_3_2;
    io_B_Valid_3_delay_5 <= io_B_Valid_3_delay_4_1;
    io_A_Valid_5_delay_1_3 <= io_A_Valid_5;
    io_A_Valid_5_delay_2_2 <= io_A_Valid_5_delay_1_3;
    io_A_Valid_5_delay_3_1 <= io_A_Valid_5_delay_2_2;
    io_A_Valid_5_delay_4 <= io_A_Valid_5_delay_3_1;
    io_B_Valid_4_delay_1_4 <= io_B_Valid_4;
    io_B_Valid_4_delay_2_3 <= io_B_Valid_4_delay_1_4;
    io_B_Valid_4_delay_3_2 <= io_B_Valid_4_delay_2_3;
    io_B_Valid_4_delay_4_1 <= io_B_Valid_4_delay_3_2;
    io_B_Valid_4_delay_5 <= io_B_Valid_4_delay_4_1;
    io_A_Valid_5_delay_1_4 <= io_A_Valid_5;
    io_A_Valid_5_delay_2_3 <= io_A_Valid_5_delay_1_4;
    io_A_Valid_5_delay_3_2 <= io_A_Valid_5_delay_2_3;
    io_A_Valid_5_delay_4_1 <= io_A_Valid_5_delay_3_2;
    io_A_Valid_5_delay_5 <= io_A_Valid_5_delay_4_1;
    io_B_Valid_5_delay_1_4 <= io_B_Valid_5;
    io_B_Valid_5_delay_2_3 <= io_B_Valid_5_delay_1_4;
    io_B_Valid_5_delay_3_2 <= io_B_Valid_5_delay_2_3;
    io_B_Valid_5_delay_4_1 <= io_B_Valid_5_delay_3_2;
    io_B_Valid_5_delay_5 <= io_B_Valid_5_delay_4_1;
    io_A_Valid_5_delay_1_5 <= io_A_Valid_5;
    io_A_Valid_5_delay_2_4 <= io_A_Valid_5_delay_1_5;
    io_A_Valid_5_delay_3_3 <= io_A_Valid_5_delay_2_4;
    io_A_Valid_5_delay_4_2 <= io_A_Valid_5_delay_3_3;
    io_A_Valid_5_delay_5_1 <= io_A_Valid_5_delay_4_2;
    io_A_Valid_5_delay_6 <= io_A_Valid_5_delay_5_1;
    io_B_Valid_6_delay_1_4 <= io_B_Valid_6;
    io_B_Valid_6_delay_2_3 <= io_B_Valid_6_delay_1_4;
    io_B_Valid_6_delay_3_2 <= io_B_Valid_6_delay_2_3;
    io_B_Valid_6_delay_4_1 <= io_B_Valid_6_delay_3_2;
    io_B_Valid_6_delay_5 <= io_B_Valid_6_delay_4_1;
    io_A_Valid_5_delay_1_6 <= io_A_Valid_5;
    io_A_Valid_5_delay_2_5 <= io_A_Valid_5_delay_1_6;
    io_A_Valid_5_delay_3_4 <= io_A_Valid_5_delay_2_5;
    io_A_Valid_5_delay_4_3 <= io_A_Valid_5_delay_3_4;
    io_A_Valid_5_delay_5_2 <= io_A_Valid_5_delay_4_3;
    io_A_Valid_5_delay_6_1 <= io_A_Valid_5_delay_5_2;
    io_A_Valid_5_delay_7 <= io_A_Valid_5_delay_6_1;
    io_B_Valid_7_delay_1_4 <= io_B_Valid_7;
    io_B_Valid_7_delay_2_3 <= io_B_Valid_7_delay_1_4;
    io_B_Valid_7_delay_3_2 <= io_B_Valid_7_delay_2_3;
    io_B_Valid_7_delay_4_1 <= io_B_Valid_7_delay_3_2;
    io_B_Valid_7_delay_5 <= io_B_Valid_7_delay_4_1;
    io_B_Valid_0_delay_1_5 <= io_B_Valid_0;
    io_B_Valid_0_delay_2_4 <= io_B_Valid_0_delay_1_5;
    io_B_Valid_0_delay_3_3 <= io_B_Valid_0_delay_2_4;
    io_B_Valid_0_delay_4_2 <= io_B_Valid_0_delay_3_3;
    io_B_Valid_0_delay_5_1 <= io_B_Valid_0_delay_4_2;
    io_B_Valid_0_delay_6 <= io_B_Valid_0_delay_5_1;
    io_A_Valid_6_delay_1 <= io_A_Valid_6;
    io_B_Valid_1_delay_1_5 <= io_B_Valid_1;
    io_B_Valid_1_delay_2_4 <= io_B_Valid_1_delay_1_5;
    io_B_Valid_1_delay_3_3 <= io_B_Valid_1_delay_2_4;
    io_B_Valid_1_delay_4_2 <= io_B_Valid_1_delay_3_3;
    io_B_Valid_1_delay_5_1 <= io_B_Valid_1_delay_4_2;
    io_B_Valid_1_delay_6 <= io_B_Valid_1_delay_5_1;
    io_A_Valid_6_delay_1_1 <= io_A_Valid_6;
    io_A_Valid_6_delay_2 <= io_A_Valid_6_delay_1_1;
    io_B_Valid_2_delay_1_5 <= io_B_Valid_2;
    io_B_Valid_2_delay_2_4 <= io_B_Valid_2_delay_1_5;
    io_B_Valid_2_delay_3_3 <= io_B_Valid_2_delay_2_4;
    io_B_Valid_2_delay_4_2 <= io_B_Valid_2_delay_3_3;
    io_B_Valid_2_delay_5_1 <= io_B_Valid_2_delay_4_2;
    io_B_Valid_2_delay_6 <= io_B_Valid_2_delay_5_1;
    io_A_Valid_6_delay_1_2 <= io_A_Valid_6;
    io_A_Valid_6_delay_2_1 <= io_A_Valid_6_delay_1_2;
    io_A_Valid_6_delay_3 <= io_A_Valid_6_delay_2_1;
    io_B_Valid_3_delay_1_5 <= io_B_Valid_3;
    io_B_Valid_3_delay_2_4 <= io_B_Valid_3_delay_1_5;
    io_B_Valid_3_delay_3_3 <= io_B_Valid_3_delay_2_4;
    io_B_Valid_3_delay_4_2 <= io_B_Valid_3_delay_3_3;
    io_B_Valid_3_delay_5_1 <= io_B_Valid_3_delay_4_2;
    io_B_Valid_3_delay_6 <= io_B_Valid_3_delay_5_1;
    io_A_Valid_6_delay_1_3 <= io_A_Valid_6;
    io_A_Valid_6_delay_2_2 <= io_A_Valid_6_delay_1_3;
    io_A_Valid_6_delay_3_1 <= io_A_Valid_6_delay_2_2;
    io_A_Valid_6_delay_4 <= io_A_Valid_6_delay_3_1;
    io_B_Valid_4_delay_1_5 <= io_B_Valid_4;
    io_B_Valid_4_delay_2_4 <= io_B_Valid_4_delay_1_5;
    io_B_Valid_4_delay_3_3 <= io_B_Valid_4_delay_2_4;
    io_B_Valid_4_delay_4_2 <= io_B_Valid_4_delay_3_3;
    io_B_Valid_4_delay_5_1 <= io_B_Valid_4_delay_4_2;
    io_B_Valid_4_delay_6 <= io_B_Valid_4_delay_5_1;
    io_A_Valid_6_delay_1_4 <= io_A_Valid_6;
    io_A_Valid_6_delay_2_3 <= io_A_Valid_6_delay_1_4;
    io_A_Valid_6_delay_3_2 <= io_A_Valid_6_delay_2_3;
    io_A_Valid_6_delay_4_1 <= io_A_Valid_6_delay_3_2;
    io_A_Valid_6_delay_5 <= io_A_Valid_6_delay_4_1;
    io_B_Valid_5_delay_1_5 <= io_B_Valid_5;
    io_B_Valid_5_delay_2_4 <= io_B_Valid_5_delay_1_5;
    io_B_Valid_5_delay_3_3 <= io_B_Valid_5_delay_2_4;
    io_B_Valid_5_delay_4_2 <= io_B_Valid_5_delay_3_3;
    io_B_Valid_5_delay_5_1 <= io_B_Valid_5_delay_4_2;
    io_B_Valid_5_delay_6 <= io_B_Valid_5_delay_5_1;
    io_A_Valid_6_delay_1_5 <= io_A_Valid_6;
    io_A_Valid_6_delay_2_4 <= io_A_Valid_6_delay_1_5;
    io_A_Valid_6_delay_3_3 <= io_A_Valid_6_delay_2_4;
    io_A_Valid_6_delay_4_2 <= io_A_Valid_6_delay_3_3;
    io_A_Valid_6_delay_5_1 <= io_A_Valid_6_delay_4_2;
    io_A_Valid_6_delay_6 <= io_A_Valid_6_delay_5_1;
    io_B_Valid_6_delay_1_5 <= io_B_Valid_6;
    io_B_Valid_6_delay_2_4 <= io_B_Valid_6_delay_1_5;
    io_B_Valid_6_delay_3_3 <= io_B_Valid_6_delay_2_4;
    io_B_Valid_6_delay_4_2 <= io_B_Valid_6_delay_3_3;
    io_B_Valid_6_delay_5_1 <= io_B_Valid_6_delay_4_2;
    io_B_Valid_6_delay_6 <= io_B_Valid_6_delay_5_1;
    io_A_Valid_6_delay_1_6 <= io_A_Valid_6;
    io_A_Valid_6_delay_2_5 <= io_A_Valid_6_delay_1_6;
    io_A_Valid_6_delay_3_4 <= io_A_Valid_6_delay_2_5;
    io_A_Valid_6_delay_4_3 <= io_A_Valid_6_delay_3_4;
    io_A_Valid_6_delay_5_2 <= io_A_Valid_6_delay_4_3;
    io_A_Valid_6_delay_6_1 <= io_A_Valid_6_delay_5_2;
    io_A_Valid_6_delay_7 <= io_A_Valid_6_delay_6_1;
    io_B_Valid_7_delay_1_5 <= io_B_Valid_7;
    io_B_Valid_7_delay_2_4 <= io_B_Valid_7_delay_1_5;
    io_B_Valid_7_delay_3_3 <= io_B_Valid_7_delay_2_4;
    io_B_Valid_7_delay_4_2 <= io_B_Valid_7_delay_3_3;
    io_B_Valid_7_delay_5_1 <= io_B_Valid_7_delay_4_2;
    io_B_Valid_7_delay_6 <= io_B_Valid_7_delay_5_1;
    io_B_Valid_0_delay_1_6 <= io_B_Valid_0;
    io_B_Valid_0_delay_2_5 <= io_B_Valid_0_delay_1_6;
    io_B_Valid_0_delay_3_4 <= io_B_Valid_0_delay_2_5;
    io_B_Valid_0_delay_4_3 <= io_B_Valid_0_delay_3_4;
    io_B_Valid_0_delay_5_2 <= io_B_Valid_0_delay_4_3;
    io_B_Valid_0_delay_6_1 <= io_B_Valid_0_delay_5_2;
    io_B_Valid_0_delay_7 <= io_B_Valid_0_delay_6_1;
    io_A_Valid_7_delay_1 <= io_A_Valid_7;
    io_B_Valid_1_delay_1_6 <= io_B_Valid_1;
    io_B_Valid_1_delay_2_5 <= io_B_Valid_1_delay_1_6;
    io_B_Valid_1_delay_3_4 <= io_B_Valid_1_delay_2_5;
    io_B_Valid_1_delay_4_3 <= io_B_Valid_1_delay_3_4;
    io_B_Valid_1_delay_5_2 <= io_B_Valid_1_delay_4_3;
    io_B_Valid_1_delay_6_1 <= io_B_Valid_1_delay_5_2;
    io_B_Valid_1_delay_7 <= io_B_Valid_1_delay_6_1;
    io_A_Valid_7_delay_1_1 <= io_A_Valid_7;
    io_A_Valid_7_delay_2 <= io_A_Valid_7_delay_1_1;
    io_B_Valid_2_delay_1_6 <= io_B_Valid_2;
    io_B_Valid_2_delay_2_5 <= io_B_Valid_2_delay_1_6;
    io_B_Valid_2_delay_3_4 <= io_B_Valid_2_delay_2_5;
    io_B_Valid_2_delay_4_3 <= io_B_Valid_2_delay_3_4;
    io_B_Valid_2_delay_5_2 <= io_B_Valid_2_delay_4_3;
    io_B_Valid_2_delay_6_1 <= io_B_Valid_2_delay_5_2;
    io_B_Valid_2_delay_7 <= io_B_Valid_2_delay_6_1;
    io_A_Valid_7_delay_1_2 <= io_A_Valid_7;
    io_A_Valid_7_delay_2_1 <= io_A_Valid_7_delay_1_2;
    io_A_Valid_7_delay_3 <= io_A_Valid_7_delay_2_1;
    io_B_Valid_3_delay_1_6 <= io_B_Valid_3;
    io_B_Valid_3_delay_2_5 <= io_B_Valid_3_delay_1_6;
    io_B_Valid_3_delay_3_4 <= io_B_Valid_3_delay_2_5;
    io_B_Valid_3_delay_4_3 <= io_B_Valid_3_delay_3_4;
    io_B_Valid_3_delay_5_2 <= io_B_Valid_3_delay_4_3;
    io_B_Valid_3_delay_6_1 <= io_B_Valid_3_delay_5_2;
    io_B_Valid_3_delay_7 <= io_B_Valid_3_delay_6_1;
    io_A_Valid_7_delay_1_3 <= io_A_Valid_7;
    io_A_Valid_7_delay_2_2 <= io_A_Valid_7_delay_1_3;
    io_A_Valid_7_delay_3_1 <= io_A_Valid_7_delay_2_2;
    io_A_Valid_7_delay_4 <= io_A_Valid_7_delay_3_1;
    io_B_Valid_4_delay_1_6 <= io_B_Valid_4;
    io_B_Valid_4_delay_2_5 <= io_B_Valid_4_delay_1_6;
    io_B_Valid_4_delay_3_4 <= io_B_Valid_4_delay_2_5;
    io_B_Valid_4_delay_4_3 <= io_B_Valid_4_delay_3_4;
    io_B_Valid_4_delay_5_2 <= io_B_Valid_4_delay_4_3;
    io_B_Valid_4_delay_6_1 <= io_B_Valid_4_delay_5_2;
    io_B_Valid_4_delay_7 <= io_B_Valid_4_delay_6_1;
    io_A_Valid_7_delay_1_4 <= io_A_Valid_7;
    io_A_Valid_7_delay_2_3 <= io_A_Valid_7_delay_1_4;
    io_A_Valid_7_delay_3_2 <= io_A_Valid_7_delay_2_3;
    io_A_Valid_7_delay_4_1 <= io_A_Valid_7_delay_3_2;
    io_A_Valid_7_delay_5 <= io_A_Valid_7_delay_4_1;
    io_B_Valid_5_delay_1_6 <= io_B_Valid_5;
    io_B_Valid_5_delay_2_5 <= io_B_Valid_5_delay_1_6;
    io_B_Valid_5_delay_3_4 <= io_B_Valid_5_delay_2_5;
    io_B_Valid_5_delay_4_3 <= io_B_Valid_5_delay_3_4;
    io_B_Valid_5_delay_5_2 <= io_B_Valid_5_delay_4_3;
    io_B_Valid_5_delay_6_1 <= io_B_Valid_5_delay_5_2;
    io_B_Valid_5_delay_7 <= io_B_Valid_5_delay_6_1;
    io_A_Valid_7_delay_1_5 <= io_A_Valid_7;
    io_A_Valid_7_delay_2_4 <= io_A_Valid_7_delay_1_5;
    io_A_Valid_7_delay_3_3 <= io_A_Valid_7_delay_2_4;
    io_A_Valid_7_delay_4_2 <= io_A_Valid_7_delay_3_3;
    io_A_Valid_7_delay_5_1 <= io_A_Valid_7_delay_4_2;
    io_A_Valid_7_delay_6 <= io_A_Valid_7_delay_5_1;
    io_B_Valid_6_delay_1_6 <= io_B_Valid_6;
    io_B_Valid_6_delay_2_5 <= io_B_Valid_6_delay_1_6;
    io_B_Valid_6_delay_3_4 <= io_B_Valid_6_delay_2_5;
    io_B_Valid_6_delay_4_3 <= io_B_Valid_6_delay_3_4;
    io_B_Valid_6_delay_5_2 <= io_B_Valid_6_delay_4_3;
    io_B_Valid_6_delay_6_1 <= io_B_Valid_6_delay_5_2;
    io_B_Valid_6_delay_7 <= io_B_Valid_6_delay_6_1;
    io_A_Valid_7_delay_1_6 <= io_A_Valid_7;
    io_A_Valid_7_delay_2_5 <= io_A_Valid_7_delay_1_6;
    io_A_Valid_7_delay_3_4 <= io_A_Valid_7_delay_2_5;
    io_A_Valid_7_delay_4_3 <= io_A_Valid_7_delay_3_4;
    io_A_Valid_7_delay_5_2 <= io_A_Valid_7_delay_4_3;
    io_A_Valid_7_delay_6_1 <= io_A_Valid_7_delay_5_2;
    io_A_Valid_7_delay_7 <= io_A_Valid_7_delay_6_1;
    io_B_Valid_7_delay_1_6 <= io_B_Valid_7;
    io_B_Valid_7_delay_2_5 <= io_B_Valid_7_delay_1_6;
    io_B_Valid_7_delay_3_4 <= io_B_Valid_7_delay_2_5;
    io_B_Valid_7_delay_4_3 <= io_B_Valid_7_delay_3_4;
    io_B_Valid_7_delay_5_2 <= io_B_Valid_7_delay_4_3;
    io_B_Valid_7_delay_6_1 <= io_B_Valid_7_delay_5_2;
    io_B_Valid_7_delay_7 <= io_B_Valid_7_delay_6_1;
  end


endmodule

module LayerNorm_OutputCache_Fifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [6:0]    io_occupancy,
  output     [6:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [5:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1122;
  wire       [5:0]    logic_ptrDif;
  reg [63:0] logic_ram [0:63];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h3f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h3f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module LayerNorm_Module (
  input      [18:0]   sData_0,
  input      [18:0]   sData_1,
  input      [18:0]   sData_2,
  input      [18:0]   sData_3,
  input      [18:0]   sData_4,
  input      [18:0]   sData_5,
  input      [18:0]   sData_6,
  input      [18:0]   sData_7,
  input               sValid,
  output              sReady,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Bias_Read_Addr,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  output              mLast,
  input               clk,
  input               reset
);

  wire                Stage1_0_mData_ready;
  wire                Stage1_1_mData_ready;
  wire                Stage1_2_mData_ready;
  wire                Stage1_3_mData_ready;
  wire                Stage1_4_mData_ready;
  wire                Stage1_5_mData_ready;
  wire                Stage1_6_mData_ready;
  wire                Stage1_7_mData_ready;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_0;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_2;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_3;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_4;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_5;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_6;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_7;
  wire                Stage2_Recipro_Sqrt_Result_Valid;
  wire       [9:0]    Stage2_Bias_Read_Addr;
  wire                Stage2_mLast;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_0_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_1_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_2_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_3_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_4_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_5_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_6_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_7_1;
  wire                Stage1_0_sData_ready;
  wire       [9:0]    Stage1_0_Scale_Read_Addr;
  wire                Stage1_0_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_0_Sqrt_In_Truncated;
  wire                Stage1_0_ScaleA_Fifo_Popfire;
  wire                Stage1_0_mData_valid;
  wire       [7:0]    Stage1_0_mData_payload;
  wire                Stage1_1_sData_ready;
  wire       [9:0]    Stage1_1_Scale_Read_Addr;
  wire                Stage1_1_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_1_Sqrt_In_Truncated;
  wire                Stage1_1_ScaleA_Fifo_Popfire;
  wire                Stage1_1_mData_valid;
  wire       [7:0]    Stage1_1_mData_payload;
  wire                Stage1_2_sData_ready;
  wire       [9:0]    Stage1_2_Scale_Read_Addr;
  wire                Stage1_2_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_2_Sqrt_In_Truncated;
  wire                Stage1_2_ScaleA_Fifo_Popfire;
  wire                Stage1_2_mData_valid;
  wire       [7:0]    Stage1_2_mData_payload;
  wire                Stage1_3_sData_ready;
  wire       [9:0]    Stage1_3_Scale_Read_Addr;
  wire                Stage1_3_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_3_Sqrt_In_Truncated;
  wire                Stage1_3_ScaleA_Fifo_Popfire;
  wire                Stage1_3_mData_valid;
  wire       [7:0]    Stage1_3_mData_payload;
  wire                Stage1_4_sData_ready;
  wire       [9:0]    Stage1_4_Scale_Read_Addr;
  wire                Stage1_4_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_4_Sqrt_In_Truncated;
  wire                Stage1_4_ScaleA_Fifo_Popfire;
  wire                Stage1_4_mData_valid;
  wire       [7:0]    Stage1_4_mData_payload;
  wire                Stage1_5_sData_ready;
  wire       [9:0]    Stage1_5_Scale_Read_Addr;
  wire                Stage1_5_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_5_Sqrt_In_Truncated;
  wire                Stage1_5_ScaleA_Fifo_Popfire;
  wire                Stage1_5_mData_valid;
  wire       [7:0]    Stage1_5_mData_payload;
  wire                Stage1_6_sData_ready;
  wire       [9:0]    Stage1_6_Scale_Read_Addr;
  wire                Stage1_6_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_6_Sqrt_In_Truncated;
  wire                Stage1_6_ScaleA_Fifo_Popfire;
  wire                Stage1_6_mData_valid;
  wire       [7:0]    Stage1_6_mData_payload;
  wire                Stage1_7_sData_ready;
  wire       [9:0]    Stage1_7_Scale_Read_Addr;
  wire                Stage1_7_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_7_Sqrt_In_Truncated;
  wire                Stage1_7_ScaleA_Fifo_Popfire;
  wire                Stage1_7_mData_valid;
  wire       [7:0]    Stage1_7_mData_payload;
  reg        [7:0]    Bias_1_delay_1;
  reg        [7:0]    Bias_1_delay_2;
  reg        [7:0]    Bias_1_delay_3;
  reg        [7:0]    Bias_1_delay_4;
  reg        [7:0]    Bias_1_delay_5;
  reg        [7:0]    Bias_1_delay_6;
  reg        [7:0]    Bias_1_delay_7;
  reg        [7:0]    Bias_1_delay_1_1;
  reg        [7:0]    Bias_1_delay_2_1;
  reg        [7:0]    Bias_1_delay_3_1;
  reg        [7:0]    Bias_1_delay_4_1;
  reg        [7:0]    Bias_1_delay_5_1;
  reg        [7:0]    Bias_1_delay_6_1;
  reg        [7:0]    Bias_1_delay_7_1;
  reg        [7:0]    Bias_1_delay_1_2;
  reg        [7:0]    Bias_1_delay_2_2;
  reg        [7:0]    Bias_1_delay_3_2;
  reg        [7:0]    Bias_1_delay_4_2;
  reg        [7:0]    Bias_1_delay_5_2;
  reg        [7:0]    Bias_1_delay_6_2;
  reg        [7:0]    Bias_1_delay_7_2;
  reg        [7:0]    Bias_1_delay_1_3;
  reg        [7:0]    Bias_1_delay_2_3;
  reg        [7:0]    Bias_1_delay_3_3;
  reg        [7:0]    Bias_1_delay_4_3;
  reg        [7:0]    Bias_1_delay_5_3;
  reg        [7:0]    Bias_1_delay_6_3;
  reg        [7:0]    Bias_1_delay_7_3;
  reg        [7:0]    Bias_1_delay_1_4;
  reg        [7:0]    Bias_1_delay_2_4;
  reg        [7:0]    Bias_1_delay_3_4;
  reg        [7:0]    Bias_1_delay_4_4;
  reg        [7:0]    Bias_1_delay_5_4;
  reg        [7:0]    Bias_1_delay_6_4;
  reg        [7:0]    Bias_1_delay_7_4;
  reg        [7:0]    Bias_1_delay_1_5;
  reg        [7:0]    Bias_1_delay_2_5;
  reg        [7:0]    Bias_1_delay_3_5;
  reg        [7:0]    Bias_1_delay_4_5;
  reg        [7:0]    Bias_1_delay_5_5;
  reg        [7:0]    Bias_1_delay_6_5;
  reg        [7:0]    Bias_1_delay_7_5;
  reg        [7:0]    Bias_1_delay_1_6;
  reg        [7:0]    Bias_1_delay_2_6;
  reg        [7:0]    Bias_1_delay_3_6;
  reg        [7:0]    Bias_1_delay_4_6;
  reg        [7:0]    Bias_1_delay_5_6;
  reg        [7:0]    Bias_1_delay_6_6;
  reg        [7:0]    Bias_1_delay_7_6;
  reg        [7:0]    Bias_1_delay_1_7;
  reg        [7:0]    Bias_1_delay_2_7;
  reg        [7:0]    Bias_1_delay_3_7;
  reg        [7:0]    Bias_1_delay_4_7;
  reg        [7:0]    Bias_1_delay_5_7;
  reg        [7:0]    Bias_1_delay_6_7;
  reg        [7:0]    Bias_1_delay_7_7;

  Reci_Sqrt_Compute Stage2 (
    .Channel_Nums                  (Channel_Nums[9:0]                         ), //i
    .Token_Nums                    (Token_Nums[19:0]                          ), //i
    .Sqrt_In_Valid_0               (Stage1_0_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_1               (Stage1_1_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_2               (Stage1_2_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_3               (Stage1_3_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_4               (Stage1_4_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_5               (Stage1_5_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_6               (Stage1_6_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_7               (Stage1_7_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Truncated_0           (Stage1_0_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_1           (Stage1_1_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_2           (Stage1_2_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_3           (Stage1_3_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_4           (Stage1_4_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_5           (Stage1_5_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_6           (Stage1_6_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_7           (Stage1_7_Sqrt_In_Truncated[31:0]          ), //i
    .ScaleA_Fifo_Popfire           (Stage1_0_ScaleA_Fifo_Popfire              ), //i
    .Recipro_Sqrt_Result_Latch_0   (Stage2_Recipro_Sqrt_Result_Latch_0[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_1   (Stage2_Recipro_Sqrt_Result_Latch_1[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_2   (Stage2_Recipro_Sqrt_Result_Latch_2[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_3   (Stage2_Recipro_Sqrt_Result_Latch_3[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_4   (Stage2_Recipro_Sqrt_Result_Latch_4[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_5   (Stage2_Recipro_Sqrt_Result_Latch_5[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_6   (Stage2_Recipro_Sqrt_Result_Latch_6[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_7   (Stage2_Recipro_Sqrt_Result_Latch_7[31:0]  ), //o
    .Recipro_Sqrt_Result_Valid     (Stage2_Recipro_Sqrt_Result_Valid          ), //o
    .Bias_Read_Addr                (Stage2_Bias_Read_Addr[9:0]                ), //o
    .mLast                         (Stage2_mLast                              ), //o
    .clk                           (clk                                       ), //i
    .Recipro_Sqrt_Result_Latch_0_1 (Stage2_Recipro_Sqrt_Result_Latch_0_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_1_1 (Stage2_Recipro_Sqrt_Result_Latch_1_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_2_1 (Stage2_Recipro_Sqrt_Result_Latch_2_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_3_1 (Stage2_Recipro_Sqrt_Result_Latch_3_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_4_1 (Stage2_Recipro_Sqrt_Result_Latch_4_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_5_1 (Stage2_Recipro_Sqrt_Result_Latch_5_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_6_1 (Stage2_Recipro_Sqrt_Result_Latch_6_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_7_1 (Stage2_Recipro_Sqrt_Result_Latch_7_1[31:0]), //o
    .reset                         (reset                                     )  //i
  );
  Sum_Xq Stage1_0 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_0_sData_ready                    ), //o
    .sData_payload             (sData_0[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_0_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_0_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_0_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_0_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_0[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_0_mData_valid                    ), //o
    .mData_ready               (Stage1_0_mData_ready                    ), //i
    .mData_payload             (Stage1_0_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_1 Stage1_1 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_1_sData_ready                    ), //o
    .sData_payload             (sData_1[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_1_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_1[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_1_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_1_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_1_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_1[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_1_mData_valid                    ), //o
    .mData_ready               (Stage1_1_mData_ready                    ), //i
    .mData_payload             (Stage1_1_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_2 Stage1_2 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_2_sData_ready                    ), //o
    .sData_payload             (sData_2[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_2_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_2[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_2_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_2_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_2_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_2[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_2_mData_valid                    ), //o
    .mData_ready               (Stage1_2_mData_ready                    ), //i
    .mData_payload             (Stage1_2_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_3 Stage1_3 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_3_sData_ready                    ), //o
    .sData_payload             (sData_3[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_3_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_3[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_3_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_3_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_3_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_3[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_3_mData_valid                    ), //o
    .mData_ready               (Stage1_3_mData_ready                    ), //i
    .mData_payload             (Stage1_3_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_4 Stage1_4 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_4_sData_ready                    ), //o
    .sData_payload             (sData_4[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_4_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_4[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_4_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_4_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_4_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_4[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_4_mData_valid                    ), //o
    .mData_ready               (Stage1_4_mData_ready                    ), //i
    .mData_payload             (Stage1_4_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_5 Stage1_5 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_5_sData_ready                    ), //o
    .sData_payload             (sData_5[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_5_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_5[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_5_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_5_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_5_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_5[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_5_mData_valid                    ), //o
    .mData_ready               (Stage1_5_mData_ready                    ), //i
    .mData_payload             (Stage1_5_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_6 Stage1_6 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_6_sData_ready                    ), //o
    .sData_payload             (sData_6[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_6_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_6[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_6_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_6_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_6_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_6[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_6_mData_valid                    ), //o
    .mData_ready               (Stage1_6_mData_ready                    ), //i
    .mData_payload             (Stage1_6_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_7 Stage1_7 (
    .sData_valid               (sValid                                  ), //i
    .sData_ready               (Stage1_7_sData_ready                    ), //o
    .sData_payload             (sData_7[18:0]                           ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[9:0]                       ), //i
    .Token_Nums                (Token_Nums[19:0]                        ), //i
    .Scale_Read_Addr           (Stage1_7_Scale_Read_Addr[9:0]           ), //o
    .Scale_1                   (Scale_1[7:0]                            ), //i
    .Bias_1                    (Bias_1_delay_7_7[7:0]                   ), //i
    .Sqrt_Out_Valid            (Stage1_7_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_7_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_7_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_7[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_7_mData_valid                    ), //o
    .mData_ready               (Stage1_7_mData_ready                    ), //i
    .mData_payload             (Stage1_7_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  always @(*) begin
    mData_payload[7 : 0] = Stage1_0_mData_payload;
    mData_payload[15 : 8] = Stage1_1_mData_payload;
    mData_payload[23 : 16] = Stage1_2_mData_payload;
    mData_payload[31 : 24] = Stage1_3_mData_payload;
    mData_payload[39 : 32] = Stage1_4_mData_payload;
    mData_payload[47 : 40] = Stage1_5_mData_payload;
    mData_payload[55 : 48] = Stage1_6_mData_payload;
    mData_payload[63 : 56] = Stage1_7_mData_payload;
  end

  assign sReady = Stage1_0_sData_ready;
  assign Scale_Read_Addr = Stage1_0_Scale_Read_Addr;
  assign Bias_Read_Addr = Stage2_Bias_Read_Addr;
  assign mData_valid = Stage1_0_mData_valid;
  assign mLast = Stage2_mLast;
  always @(posedge clk) begin
    Bias_1_delay_1 <= Bias_1;
    Bias_1_delay_2 <= Bias_1_delay_1;
    Bias_1_delay_3 <= Bias_1_delay_2;
    Bias_1_delay_4 <= Bias_1_delay_3;
    Bias_1_delay_5 <= Bias_1_delay_4;
    Bias_1_delay_6 <= Bias_1_delay_5;
    Bias_1_delay_7 <= Bias_1_delay_6;
    Bias_1_delay_1_1 <= Bias_1;
    Bias_1_delay_2_1 <= Bias_1_delay_1_1;
    Bias_1_delay_3_1 <= Bias_1_delay_2_1;
    Bias_1_delay_4_1 <= Bias_1_delay_3_1;
    Bias_1_delay_5_1 <= Bias_1_delay_4_1;
    Bias_1_delay_6_1 <= Bias_1_delay_5_1;
    Bias_1_delay_7_1 <= Bias_1_delay_6_1;
    Bias_1_delay_1_2 <= Bias_1;
    Bias_1_delay_2_2 <= Bias_1_delay_1_2;
    Bias_1_delay_3_2 <= Bias_1_delay_2_2;
    Bias_1_delay_4_2 <= Bias_1_delay_3_2;
    Bias_1_delay_5_2 <= Bias_1_delay_4_2;
    Bias_1_delay_6_2 <= Bias_1_delay_5_2;
    Bias_1_delay_7_2 <= Bias_1_delay_6_2;
    Bias_1_delay_1_3 <= Bias_1;
    Bias_1_delay_2_3 <= Bias_1_delay_1_3;
    Bias_1_delay_3_3 <= Bias_1_delay_2_3;
    Bias_1_delay_4_3 <= Bias_1_delay_3_3;
    Bias_1_delay_5_3 <= Bias_1_delay_4_3;
    Bias_1_delay_6_3 <= Bias_1_delay_5_3;
    Bias_1_delay_7_3 <= Bias_1_delay_6_3;
    Bias_1_delay_1_4 <= Bias_1;
    Bias_1_delay_2_4 <= Bias_1_delay_1_4;
    Bias_1_delay_3_4 <= Bias_1_delay_2_4;
    Bias_1_delay_4_4 <= Bias_1_delay_3_4;
    Bias_1_delay_5_4 <= Bias_1_delay_4_4;
    Bias_1_delay_6_4 <= Bias_1_delay_5_4;
    Bias_1_delay_7_4 <= Bias_1_delay_6_4;
    Bias_1_delay_1_5 <= Bias_1;
    Bias_1_delay_2_5 <= Bias_1_delay_1_5;
    Bias_1_delay_3_5 <= Bias_1_delay_2_5;
    Bias_1_delay_4_5 <= Bias_1_delay_3_5;
    Bias_1_delay_5_5 <= Bias_1_delay_4_5;
    Bias_1_delay_6_5 <= Bias_1_delay_5_5;
    Bias_1_delay_7_5 <= Bias_1_delay_6_5;
    Bias_1_delay_1_6 <= Bias_1;
    Bias_1_delay_2_6 <= Bias_1_delay_1_6;
    Bias_1_delay_3_6 <= Bias_1_delay_2_6;
    Bias_1_delay_4_6 <= Bias_1_delay_3_6;
    Bias_1_delay_5_6 <= Bias_1_delay_4_6;
    Bias_1_delay_6_6 <= Bias_1_delay_5_6;
    Bias_1_delay_7_6 <= Bias_1_delay_6_6;
    Bias_1_delay_1_7 <= Bias_1;
    Bias_1_delay_2_7 <= Bias_1_delay_1_7;
    Bias_1_delay_3_7 <= Bias_1_delay_2_7;
    Bias_1_delay_4_7 <= Bias_1_delay_3_7;
    Bias_1_delay_5_7 <= Bias_1_delay_4_7;
    Bias_1_delay_6_7 <= Bias_1_delay_5_7;
    Bias_1_delay_7_7 <= Bias_1_delay_6_7;
  end


endmodule

module LayerNorm_ScaleBias_Converter (
  input               inStream_valid,
  output              inStream_ready,
  input      [63:0]   inStream_payload,
  output              outStream_valid,
  input               outStream_ready,
  output     [15:0]   outStream_payload,
  input               clk,
  input               reset
);

  wire       [1:0]    _zz__zz_outStream_payload_1;
  wire       [0:0]    _zz__zz_outStream_payload_1_1;
  wire       [63:0]   _zz__zz_outStream_payload_3;
  reg        [15:0]   _zz_outStream_payload_4;
  wire                outStream_fire;
  reg                 _zz_outStream_payload;
  reg        [1:0]    _zz_outStream_payload_1;
  reg        [1:0]    _zz_outStream_payload_2;
  wire                _zz_inStream_ready;
  wire       [63:0]   _zz_outStream_payload_3;

  assign _zz__zz_outStream_payload_1_1 = _zz_outStream_payload;
  assign _zz__zz_outStream_payload_1 = {1'd0, _zz__zz_outStream_payload_1_1};
  assign _zz__zz_outStream_payload_3 = inStream_payload;
  always @(*) begin
    case(_zz_outStream_payload_2)
      2'b00 : _zz_outStream_payload_4 = _zz_outStream_payload_3[15 : 0];
      2'b01 : _zz_outStream_payload_4 = _zz_outStream_payload_3[31 : 16];
      2'b10 : _zz_outStream_payload_4 = _zz_outStream_payload_3[47 : 32];
      default : _zz_outStream_payload_4 = _zz_outStream_payload_3[63 : 48];
    endcase
  end

  assign outStream_fire = (outStream_valid && outStream_ready);
  always @(*) begin
    _zz_outStream_payload = 1'b0;
    if(outStream_fire) begin
      _zz_outStream_payload = 1'b1;
    end
  end

  assign _zz_inStream_ready = (_zz_outStream_payload_2 == 2'b11);
  always @(*) begin
    _zz_outStream_payload_1 = (_zz_outStream_payload_2 + _zz__zz_outStream_payload_1);
    if(1'b0) begin
      _zz_outStream_payload_1 = 2'b00;
    end
  end

  assign outStream_valid = inStream_valid;
  assign _zz_outStream_payload_3 = _zz__zz_outStream_payload_3;
  assign outStream_payload = _zz_outStream_payload_4;
  assign inStream_ready = (outStream_ready && _zz_inStream_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      _zz_outStream_payload_2 <= 2'b00;
    end else begin
      _zz_outStream_payload_2 <= _zz_outStream_payload_1;
    end
  end


endmodule

module Padding (
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  input               enPadding,
  input      [15:0]   channelIn,
  input               start,
  input      [15:0]   row_colNumIn,
  output reg [15:0]   row_colNumOut,
  input      [7:0]    zeroDara,
  input      [1:0]    zeroNum,
  output reg          last,
  input               clk,
  input               reset
);
  localparam PaddingEnum_IDLE = 7'd1;
  localparam PaddingEnum_INIT = 7'd2;
  localparam PaddingEnum_UPDOWN = 7'd4;
  localparam PaddingEnum_LEFT = 7'd8;
  localparam PaddingEnum_CENTER = 7'd16;
  localparam PaddingEnum_RIGHT = 7'd32;
  localparam PaddingEnum_END_1 = 7'd64;

  reg                 fifo_push_valid;
  reg        [63:0]   fifo_push_payload;
  wire                fifo_push_ready;
  wire                fifo_pop_valid;
  wire       [63:0]   fifo_pop_payload;
  wire       [2:0]    fifo_occupancy;
  wire       [2:0]    fifo_availability;
  wire                fifo_almost_full;
  wire       [15:0]   _zz_row_colNumOut;
  wire       [2:0]    _zz_row_colNumOut_1;
  wire       [15:0]   _zz_when_WaCounter_l14_1;
  wire       [12:0]   _zz_when_WaCounter_l14_1_1;
  wire       [15:0]   _zz_when_WaCounter_l14_2;
  wire       [15:0]   _zz_when_WaCounter_l14_3;
  wire       [15:0]   _zz_when_Padding_l144_1;
  wire       [1:0]    _zz_when_Padding_l144_1_1;
  wire       [15:0]   _zz_when_Padding_l144_2;
  wire       [15:0]   _zz_when_Padding_l144_3;
  wire       [15:0]   _zz_when_Padding_l144_4;
  wire       [15:0]   _zz_when_Padding_l144_4_1;
  wire       [15:0]   _zz_when_Padding_l144_4_2;
  wire       [15:0]   _zz_when_Padding_l144_5;
  wire       [15:0]   _zz_when_Padding_l144_5_1;
  wire       [15:0]   _zz_when_Padding_l144_5_2;
  wire       [15:0]   _zz_when_Padding_l144_6;
  wire       [15:0]   _zz_when_Padding_l144_6_1;
  wire       [15:0]   _zz_when_Padding_l144_6_2;
  wire       [15:0]   _zz_when_Padding_l144_6_3;
  reg        [12:0]   channelTimes;
  wire                fsm_initEnd;
  reg                 fsm_leftEnd;
  reg                 fsm_rightEnd;
  reg                 fsm_upDownEnd;
  reg                 fsm_centerEnd;
  reg                 fsm_endEnd;
  wire                fsm_enPadding;
  reg                 fsm_enUpDown;
  reg        [6:0]    fsm_currentState;
  reg        [6:0]    fsm_nextState;
  reg                 initEn;
  wire                when_Padding_l151;
  wire                when_Padding_l151_1;
  reg        [4:0]    initCount_count;
  reg                 initCount_valid;
  wire                when_WaCounter_l14;
  wire                when_Padding_l153;
  reg                 zeroValid;
  wire                when_Padding_l160;
  wire       [7:0]    _zz_push_payload;
  wire                padding_1_fifo_push_fire;
  reg        [15:0]   channelCnt_count;
  reg                 channelCnt_valid;
  wire                when_WaCounter_l14_1;
  wire                when_Padding_l169;
  wire                padding_1_fifo_push_fire_1;
  wire                when_WaCounter_l19;
  reg        [15:0]   colCnt_count;
  reg                 colCnt_valid;
  wire                when_WaCounter_l14_2;
  wire                when_Padding_l173;
  wire                when_WaCounter_l19_1;
  reg        [15:0]   rowCnt_count;
  reg                 rowCnt_valid;
  wire                when_WaCounter_l14_3;
  wire                when_Padding_l177;
  wire                when_Padding_l144;
  wire                padding_1_fifo_push_fire_2;
  wire                when_Padding_l144_1;
  wire                padding_1_fifo_push_fire_3;
  wire                when_Padding_l144_2;
  wire                when_Padding_l144_3;
  wire                padding_1_fifo_push_fire_4;
  wire                when_Padding_l144_4;
  wire                padding_1_fifo_push_fire_5;
  wire                when_Padding_l144_5;
  wire                when_Padding_l144_6;
  wire                when_Padding_l144_7;
  `ifndef SYNTHESIS
  reg [47:0] fsm_currentState_string;
  reg [47:0] fsm_nextState_string;
  `endif


  assign _zz_row_colNumOut_1 = ({1'd0,zeroNum} <<< 1);
  assign _zz_row_colNumOut = {13'd0, _zz_row_colNumOut_1};
  assign _zz_when_WaCounter_l14_1_1 = (channelTimes - 13'h0001);
  assign _zz_when_WaCounter_l14_1 = {3'd0, _zz_when_WaCounter_l14_1_1};
  assign _zz_when_WaCounter_l14_2 = (row_colNumOut - 16'h0001);
  assign _zz_when_WaCounter_l14_3 = (row_colNumOut - 16'h0001);
  assign _zz_when_Padding_l144_1_1 = (zeroNum - 2'b01);
  assign _zz_when_Padding_l144_1 = {14'd0, _zz_when_Padding_l144_1_1};
  assign _zz_when_Padding_l144_2 = (row_colNumOut - 16'h0001);
  assign _zz_when_Padding_l144_3 = (row_colNumOut - 16'h0001);
  assign _zz_when_Padding_l144_4 = (_zz_when_Padding_l144_4_1 - 16'h0001);
  assign _zz_when_Padding_l144_4_1 = (row_colNumOut - _zz_when_Padding_l144_4_2);
  assign _zz_when_Padding_l144_4_2 = {14'd0, zeroNum};
  assign _zz_when_Padding_l144_5 = (_zz_when_Padding_l144_5_1 - 16'h0001);
  assign _zz_when_Padding_l144_5_1 = (row_colNumOut - _zz_when_Padding_l144_5_2);
  assign _zz_when_Padding_l144_5_2 = {14'd0, zeroNum};
  assign _zz_when_Padding_l144_6 = {14'd0, zeroNum};
  assign _zz_when_Padding_l144_6_1 = (_zz_when_Padding_l144_6_2 - 16'h0001);
  assign _zz_when_Padding_l144_6_2 = (row_colNumOut - _zz_when_Padding_l144_6_3);
  assign _zz_when_Padding_l144_6_3 = {14'd0, zeroNum};
  WaStreamFifo fifo (
    .push_valid   (fifo_push_valid        ), //i
    .push_ready   (fifo_push_ready        ), //o
    .push_payload (fifo_push_payload[63:0]), //i
    .pop_valid    (fifo_pop_valid         ), //o
    .pop_ready    (mData_ready            ), //i
    .pop_payload  (fifo_pop_payload[63:0] ), //o
    .flush        (1'b0                   ), //i
    .occupancy    (fifo_occupancy[2:0]    ), //o
    .availability (fifo_availability[2:0] ), //o
    .almost_full  (fifo_almost_full       ), //o
    .clk          (clk                    ), //i
    .reset        (reset                  )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(fsm_currentState)
      PaddingEnum_IDLE : fsm_currentState_string = "IDLE  ";
      PaddingEnum_INIT : fsm_currentState_string = "INIT  ";
      PaddingEnum_UPDOWN : fsm_currentState_string = "UPDOWN";
      PaddingEnum_LEFT : fsm_currentState_string = "LEFT  ";
      PaddingEnum_CENTER : fsm_currentState_string = "CENTER";
      PaddingEnum_RIGHT : fsm_currentState_string = "RIGHT ";
      PaddingEnum_END_1 : fsm_currentState_string = "END_1 ";
      default : fsm_currentState_string = "??????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      PaddingEnum_IDLE : fsm_nextState_string = "IDLE  ";
      PaddingEnum_INIT : fsm_nextState_string = "INIT  ";
      PaddingEnum_UPDOWN : fsm_nextState_string = "UPDOWN";
      PaddingEnum_LEFT : fsm_nextState_string = "LEFT  ";
      PaddingEnum_CENTER : fsm_nextState_string = "CENTER";
      PaddingEnum_RIGHT : fsm_nextState_string = "RIGHT ";
      PaddingEnum_END_1 : fsm_nextState_string = "END_1 ";
      default : fsm_nextState_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    if(enPadding) begin
      row_colNumOut = (_zz_row_colNumOut + row_colNumIn);
    end else begin
      row_colNumOut = row_colNumIn;
    end
  end

  assign mData_valid = fifo_pop_valid;
  assign mData_payload = fifo_pop_payload;
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((fsm_currentState) & PaddingEnum_IDLE) == PaddingEnum_IDLE) : begin
        if(start) begin
          fsm_nextState = PaddingEnum_INIT;
        end else begin
          fsm_nextState = PaddingEnum_IDLE;
        end
      end
      (((fsm_currentState) & PaddingEnum_INIT) == PaddingEnum_INIT) : begin
        if(fsm_initEnd) begin
          if(fsm_enPadding) begin
            fsm_nextState = PaddingEnum_LEFT;
          end else begin
            fsm_nextState = PaddingEnum_CENTER;
          end
        end else begin
          fsm_nextState = PaddingEnum_INIT;
        end
      end
      (((fsm_currentState) & PaddingEnum_UPDOWN) == PaddingEnum_UPDOWN) : begin
        if(fsm_upDownEnd) begin
          fsm_nextState = PaddingEnum_RIGHT;
        end else begin
          fsm_nextState = PaddingEnum_UPDOWN;
        end
      end
      (((fsm_currentState) & PaddingEnum_LEFT) == PaddingEnum_LEFT) : begin
        if(fsm_leftEnd) begin
          if(fsm_enUpDown) begin
            fsm_nextState = PaddingEnum_UPDOWN;
          end else begin
            fsm_nextState = PaddingEnum_CENTER;
          end
        end else begin
          fsm_nextState = PaddingEnum_LEFT;
        end
      end
      (((fsm_currentState) & PaddingEnum_CENTER) == PaddingEnum_CENTER) : begin
        if(fsm_centerEnd) begin
          if(fsm_enPadding) begin
            fsm_nextState = PaddingEnum_RIGHT;
          end else begin
            fsm_nextState = PaddingEnum_END_1;
          end
        end else begin
          fsm_nextState = PaddingEnum_CENTER;
        end
      end
      (((fsm_currentState) & PaddingEnum_RIGHT) == PaddingEnum_RIGHT) : begin
        if(fsm_rightEnd) begin
          fsm_nextState = PaddingEnum_END_1;
        end else begin
          fsm_nextState = PaddingEnum_RIGHT;
        end
      end
      default : begin
        if(fsm_endEnd) begin
          fsm_nextState = PaddingEnum_IDLE;
        end else begin
          if(fsm_enPadding) begin
            fsm_nextState = PaddingEnum_LEFT;
          end else begin
            fsm_nextState = PaddingEnum_CENTER;
          end
        end
      end
    endcase
  end

  assign fsm_enPadding = enPadding;
  assign sData_ready = (fifo_push_ready && ((fsm_currentState & PaddingEnum_CENTER) != 7'b0000000));
  assign when_Padding_l151 = ((fsm_currentState & PaddingEnum_INIT) != 7'b0000000);
  assign when_Padding_l151_1 = ((fsm_nextState & PaddingEnum_INIT) == 7'b0000000);
  assign when_WaCounter_l14 = (initCount_count == 5'h08);
  always @(*) begin
    if(when_WaCounter_l14) begin
      initCount_valid = 1'b1;
    end else begin
      initCount_valid = 1'b0;
    end
    if(when_Padding_l153) begin
      initCount_valid = 1'b0;
    end
  end

  assign when_Padding_l153 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign fsm_initEnd = initCount_valid;
  assign when_Padding_l160 = ((fsm_currentState & PaddingEnum_CENTER) != 7'b0000000);
  always @(*) begin
    if(when_Padding_l160) begin
      fifo_push_valid = sData_valid;
    end else begin
      fifo_push_valid = zeroValid;
    end
  end

  always @(*) begin
    if(when_Padding_l160) begin
      fifo_push_payload = sData_payload;
    end else begin
      fifo_push_payload[7 : 0] = _zz_push_payload;
      fifo_push_payload[15 : 8] = _zz_push_payload;
      fifo_push_payload[23 : 16] = _zz_push_payload;
      fifo_push_payload[31 : 24] = _zz_push_payload;
      fifo_push_payload[39 : 32] = _zz_push_payload;
      fifo_push_payload[47 : 40] = _zz_push_payload;
      fifo_push_payload[55 : 48] = _zz_push_payload;
      fifo_push_payload[63 : 56] = _zz_push_payload;
    end
  end

  assign _zz_push_payload = zeroDara;
  assign padding_1_fifo_push_fire = (fifo_push_valid && fifo_push_ready);
  assign when_WaCounter_l14_1 = (channelCnt_count == _zz_when_WaCounter_l14_1);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      channelCnt_valid = 1'b1;
    end else begin
      channelCnt_valid = 1'b0;
    end
    if(when_Padding_l169) begin
      channelCnt_valid = 1'b0;
    end
  end

  assign when_Padding_l169 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign padding_1_fifo_push_fire_1 = (fifo_push_valid && fifo_push_ready);
  assign when_WaCounter_l19 = (channelCnt_valid && padding_1_fifo_push_fire_1);
  assign when_WaCounter_l14_2 = (colCnt_count == _zz_when_WaCounter_l14_2);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      colCnt_valid = 1'b1;
    end else begin
      colCnt_valid = 1'b0;
    end
    if(when_Padding_l173) begin
      colCnt_valid = 1'b0;
    end
  end

  assign when_Padding_l173 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign when_WaCounter_l19_1 = ((fsm_nextState & PaddingEnum_END_1) != 7'b0000000);
  assign when_WaCounter_l14_3 = (rowCnt_count == _zz_when_WaCounter_l14_3);
  always @(*) begin
    if(when_WaCounter_l14_3) begin
      rowCnt_valid = 1'b1;
    end else begin
      rowCnt_valid = 1'b0;
    end
    if(when_Padding_l177) begin
      rowCnt_valid = 1'b0;
    end
  end

  assign when_Padding_l177 = ((fsm_currentState & PaddingEnum_IDLE) != 7'b0000000);
  assign when_Padding_l144 = ((((fsm_currentState & PaddingEnum_LEFT) != 7'b0000000) || ((fsm_currentState & PaddingEnum_RIGHT) != 7'b0000000)) || ((fsm_currentState & PaddingEnum_UPDOWN) != 7'b0000000));
  always @(*) begin
    if(when_Padding_l144) begin
      zeroValid = 1'b1;
    end else begin
      zeroValid = 1'b0;
    end
  end

  assign padding_1_fifo_push_fire_2 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_1 = (((colCnt_count == _zz_when_Padding_l144_1) && channelCnt_valid) && padding_1_fifo_push_fire_2);
  always @(*) begin
    if(when_Padding_l144_1) begin
      fsm_leftEnd = 1'b1;
    end else begin
      fsm_leftEnd = 1'b0;
    end
  end

  assign padding_1_fifo_push_fire_3 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_2 = (((colCnt_count == _zz_when_Padding_l144_2) && channelCnt_valid) && padding_1_fifo_push_fire_3);
  always @(*) begin
    if(when_Padding_l144_2) begin
      fsm_rightEnd = 1'b1;
    end else begin
      fsm_rightEnd = 1'b0;
    end
  end

  assign when_Padding_l144_3 = (rowCnt_count == _zz_when_Padding_l144_3);
  assign padding_1_fifo_push_fire_4 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_4 = (((colCnt_count == _zz_when_Padding_l144_4) && channelCnt_valid) && padding_1_fifo_push_fire_4);
  always @(*) begin
    if(when_Padding_l144_4) begin
      fsm_upDownEnd = 1'b1;
    end else begin
      fsm_upDownEnd = 1'b0;
    end
  end

  assign padding_1_fifo_push_fire_5 = (fifo_push_valid && fifo_push_ready);
  assign when_Padding_l144_5 = (((colCnt_count == _zz_when_Padding_l144_5) && channelCnt_valid) && padding_1_fifo_push_fire_5);
  always @(*) begin
    if(when_Padding_l144_5) begin
      fsm_centerEnd = 1'b1;
    end else begin
      fsm_centerEnd = 1'b0;
    end
  end

  assign when_Padding_l144_6 = ((rowCnt_count < _zz_when_Padding_l144_6) || (_zz_when_Padding_l144_6_1 < rowCnt_count));
  always @(*) begin
    if(when_Padding_l144_6) begin
      fsm_enUpDown = 1'b1;
    end else begin
      fsm_enUpDown = 1'b0;
    end
  end

  assign when_Padding_l144_7 = (((fsm_currentState & PaddingEnum_END_1) != 7'b0000000) && ((fsm_nextState & PaddingEnum_IDLE) != 7'b0000000));
  always @(*) begin
    if(when_Padding_l144_7) begin
      last = 1'b1;
    end else begin
      last = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      channelTimes <= 13'h0;
      fsm_currentState <= PaddingEnum_IDLE;
      initEn <= 1'b0;
      initCount_count <= 5'h0;
      channelCnt_count <= 16'h0;
      colCnt_count <= 16'h0;
      rowCnt_count <= 16'h0;
    end else begin
      channelTimes <= (channelIn >>> 3);
      fsm_currentState <= fsm_nextState;
      if(when_Padding_l151) begin
        initEn <= 1'b1;
      end
      if(when_Padding_l151_1) begin
        initEn <= 1'b0;
      end
      if(initEn) begin
        initCount_count <= (initCount_count + 5'h01);
        if(initCount_valid) begin
          initCount_count <= 5'h0;
        end
      end
      if(when_Padding_l153) begin
        initCount_count <= 5'h0;
      end
      if(padding_1_fifo_push_fire) begin
        channelCnt_count <= (channelCnt_count + 16'h0001);
        if(channelCnt_valid) begin
          channelCnt_count <= 16'h0;
        end
      end
      if(when_Padding_l169) begin
        channelCnt_count <= 16'h0;
      end
      if(when_WaCounter_l19) begin
        colCnt_count <= (colCnt_count + 16'h0001);
        if(colCnt_valid) begin
          colCnt_count <= 16'h0;
        end
      end
      if(when_Padding_l173) begin
        colCnt_count <= 16'h0;
      end
      if(when_WaCounter_l19_1) begin
        rowCnt_count <= (rowCnt_count + 16'h0001);
        if(rowCnt_valid) begin
          rowCnt_count <= 16'h0;
        end
      end
      if(when_Padding_l177) begin
        rowCnt_count <= 16'h0;
      end
    end
  end

  always @(posedge clk) begin
    if(when_Padding_l144_3) begin
      fsm_endEnd <= 1'b1;
    end else begin
      fsm_endEnd <= 1'b0;
    end
  end


endmodule

//AxisDataConverter_7 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_6 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_5 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_4 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_3 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_2 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_1 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

module AxisDataConverter (
  input               inStream_valid,
  output              inStream_ready,
  input      [63:0]   inStream_payload,
  output              outStream_valid,
  input               outStream_ready,
  output     [7:0]    outStream_payload,
  input               clk,
  input               reset
);

  wire       [2:0]    _zz__zz_outStream_payload_1;
  wire       [0:0]    _zz__zz_outStream_payload_1_1;
  wire       [63:0]   _zz__zz_outStream_payload_3;
  reg        [7:0]    _zz_outStream_payload_4;
  wire                outStream_fire;
  reg                 _zz_outStream_payload;
  reg        [2:0]    _zz_outStream_payload_1;
  reg        [2:0]    _zz_outStream_payload_2;
  wire                _zz_inStream_ready;
  wire       [63:0]   _zz_outStream_payload_3;

  assign _zz__zz_outStream_payload_1_1 = _zz_outStream_payload;
  assign _zz__zz_outStream_payload_1 = {2'd0, _zz__zz_outStream_payload_1_1};
  assign _zz__zz_outStream_payload_3 = inStream_payload;
  always @(*) begin
    case(_zz_outStream_payload_2)
      3'b000 : _zz_outStream_payload_4 = _zz_outStream_payload_3[7 : 0];
      3'b001 : _zz_outStream_payload_4 = _zz_outStream_payload_3[15 : 8];
      3'b010 : _zz_outStream_payload_4 = _zz_outStream_payload_3[23 : 16];
      3'b011 : _zz_outStream_payload_4 = _zz_outStream_payload_3[31 : 24];
      3'b100 : _zz_outStream_payload_4 = _zz_outStream_payload_3[39 : 32];
      3'b101 : _zz_outStream_payload_4 = _zz_outStream_payload_3[47 : 40];
      3'b110 : _zz_outStream_payload_4 = _zz_outStream_payload_3[55 : 48];
      default : _zz_outStream_payload_4 = _zz_outStream_payload_3[63 : 56];
    endcase
  end

  assign outStream_fire = (outStream_valid && outStream_ready);
  always @(*) begin
    _zz_outStream_payload = 1'b0;
    if(outStream_fire) begin
      _zz_outStream_payload = 1'b1;
    end
  end

  assign _zz_inStream_ready = (_zz_outStream_payload_2 == 3'b111);
  always @(*) begin
    _zz_outStream_payload_1 = (_zz_outStream_payload_2 + _zz__zz_outStream_payload_1);
    if(1'b0) begin
      _zz_outStream_payload_1 = 3'b000;
    end
  end

  assign outStream_valid = inStream_valid;
  assign _zz_outStream_payload_3 = _zz__zz_outStream_payload_3;
  assign outStream_payload = _zz_outStream_payload_4;
  assign inStream_ready = (outStream_ready && _zz_inStream_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      _zz_outStream_payload_2 <= 3'b000;
    end else begin
      _zz_outStream_payload_2 <= _zz_outStream_payload_1;
    end
  end


endmodule

module Img2Col_WidthConverter_Fifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [4:0]    io_occupancy,
  output     [4:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [3:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [3:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [3:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [3:0]    logic_pushPtr_valueNext;
  reg        [3:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [3:0]    logic_popPtr_valueNext;
  reg        [3:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1122;
  wire       [3:0]    logic_ptrDif;
  reg [63:0] logic_ram [0:15];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {3'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {3'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 4'b1111);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 4'b0000;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 4'b1111);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 4'b0000;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 4'b0000;
      logic_popPtr_value <= 4'b0000;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module Img2Col_Top (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output     [63:0]   mData,
  input               mReady,
  output              mValid,
  input               Fifo_Clear,
  output              mLast,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutRow_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  output              Test_Signal,
  input      [15:0]   Test_Generate_Period,
  output              Test_End,
  output              Raddr_Valid,
  output              LayerEnd,
  output              SA_Row_Cnt_Valid,
  input               clk,
  input               reset
);
  localparam IMG2COL_ENUM_IDLE = 7'd1;
  localparam IMG2COL_ENUM_INIT = 7'd2;
  localparam IMG2COL_ENUM_INIT_ADDR = 7'd4;
  localparam IMG2COL_ENUM_DATA_CACHE = 7'd8;
  localparam IMG2COL_ENUM_WAIT_COMPUTE = 7'd16;
  localparam IMG2COL_ENUM_UPDATE_ADDR = 7'd32;
  localparam IMG2COL_ENUM_START_COMPUTE = 7'd64;

  reg                 AddrFifo_io_push_valid;
  reg                 AddrFifo_io_pop_ready;
  wire                AddrFifo_io_flush;
  reg                 RaddrFifo0_io_push_valid;
  reg        [15:0]   RaddrFifo0_io_push_payload;
  reg                 RaddrFifo0_io_pop_ready;
  wire                RaddrFifo0_io_flush;
  wire                Img2Col_SubModule_start;
  wire                Img2Col_SubModule_NewAddrIn_valid;
  wire       [13:0]   DGB_addra;
  wire       [13:0]   DGB_addrb;
  wire                AddrFifo_io_push_ready;
  wire                AddrFifo_io_pop_valid;
  wire       [15:0]   AddrFifo_io_pop_payload;
  wire       [5:0]    AddrFifo_io_occupancy;
  wire       [5:0]    AddrFifo_io_availability;
  wire                RaddrFifo0_io_push_ready;
  wire                RaddrFifo0_io_pop_valid;
  wire       [15:0]   RaddrFifo0_io_pop_payload;
  wire       [5:0]    RaddrFifo0_io_occupancy;
  wire       [5:0]    RaddrFifo0_io_availability;
  wire                Img2Col_SubModule_NewAddrIn_ready;
  wire                Img2Col_SubModule_SA_Idle;
  wire       [15:0]   Img2Col_SubModule_Raddr;
  wire                Img2Col_SubModule_Raddr_Valid;
  wire                Img2Col_SubModule_SA_End;
  wire                Img2Col_SubModule_AddrReceived;
  wire                Img2Col_SubModule_SA_Row_Cnt_Valid;
  wire       [63:0]   DGB_doutb;
  wire       [4:0]    _zz_Addr_Init_Cnt_valid;
  wire       [4:0]    _zz_Addr_Init_Cnt_valid_1;
  wire       [15:0]   _zz_In_Col_Cnt_valid;
  wire       [4:0]    _zz_Row_Cache_Cnt_valid;
  wire       [15:0]   _zz_In_Row_Cnt_valid;
  wire       [15:0]   _zz_when_Data_Generate_V2_l217;
  wire       [4:0]    _zz_when_Data_Generate_V2_l217_1;
  wire       [15:0]   _zz_Out_Row_Cnt_valid;
  wire       [15:0]   _zz_Test_Valid;
  reg                 start_regNext;
  wire                when_Data_Generate_V2_l59;
  reg        [6:0]    Fsm_currentState;
  reg        [6:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Addr_Inited;
  wire                Fsm_Data_Cached;
  wire                Fsm_Addr_Updated;
  wire                Fsm_SA_Ready;
  wire                Fsm_Cache_End;
  wire                Fsm_Layer_End;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l40;
  reg        [4:0]    Addr_Init_Cnt_count;
  wire                Addr_Init_Cnt_valid;
  reg        [15:0]   WaddrOffset;
  wire                when_Data_Generate_V2_l170;
  wire                when_Data_Generate_V2_l175;
  wire                SubModule_AddrFifo_io_pop_fire;
  wire                when_Data_Generate_V2_l179;
  wire                when_Data_Generate_V2_l183;
  reg        [15:0]   Raddr_Initialization;
  wire                when_Data_Generate_V2_l193;
  wire                when_Data_Generate_V2_l197;
  reg        [4:0]    Cache_Row_Num;
  reg        [4:0]    Raddr_Updata_Cnt_Num;
  wire                sData_fire;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [4:0]    Row_Cache_Cnt_count;
  wire                Row_Cache_Cnt_valid;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  wire                when_Data_Generate_V2_l217;
  reg                 CacheEnd_Flag;
  wire                when_Data_Generate_V2_l228;
  wire                Img2ColOutput_Module_Ready_Receive_Addr;
  wire                when_Data_Generate_V2_l245;
  wire                SubModule_RaddrFifo0_io_pop_fire;
  reg        [15:0]   Out_Row_Cnt_count;
  wire                Out_Row_Cnt_valid;
  wire       [15:0]   Waddr;
  wire                sData_fire_1;
  reg                 SubModule_Img2Col_SubModule_Raddr_Valid_regNext;
  reg                 Out_Row_Cnt_valid_regNext;
  reg        [15:0]   Out_Row_Cnt_count_regNext;
  wire                Test_Valid;
  reg                 Test_Valid_regNext;
  `ifndef SYNTHESIS
  reg [103:0] Fsm_currentState_string;
  reg [103:0] Fsm_nextState_string;
  `endif


  assign _zz_Addr_Init_Cnt_valid = (_zz_Addr_Init_Cnt_valid_1 - 5'h01);
  assign _zz_Addr_Init_Cnt_valid_1 = (Kernel_Size + Stride);
  assign _zz_In_Col_Cnt_valid = (InCol_Count_Times - 16'h0001);
  assign _zz_Row_Cache_Cnt_valid = (Cache_Row_Num - 5'h01);
  assign _zz_In_Row_Cnt_valid = (InFeature_Size - 16'h0001);
  assign _zz_when_Data_Generate_V2_l217_1 = (Kernel_Size - 5'h01);
  assign _zz_when_Data_Generate_V2_l217 = {11'd0, _zz_when_Data_Generate_V2_l217_1};
  assign _zz_Out_Row_Cnt_valid = (OutRow_Count_Times - 16'h0001);
  assign _zz_Test_Valid = (Test_Generate_Period - 16'h0001);
  WaddrOffset_Fifo_2 AddrFifo (
    .io_push_valid   (AddrFifo_io_push_valid       ), //i
    .io_push_ready   (AddrFifo_io_push_ready       ), //o
    .io_push_payload (WaddrOffset[15:0]            ), //i
    .io_pop_valid    (AddrFifo_io_pop_valid        ), //o
    .io_pop_ready    (AddrFifo_io_pop_ready        ), //i
    .io_pop_payload  (AddrFifo_io_pop_payload[15:0]), //o
    .io_flush        (AddrFifo_io_flush            ), //i
    .io_occupancy    (AddrFifo_io_occupancy[5:0]   ), //o
    .io_availability (AddrFifo_io_availability[5:0]), //o
    .clk             (clk                          ), //i
    .reset           (reset                        )  //i
  );
  WaddrOffset_Fifo_2 RaddrFifo0 (
    .io_push_valid   (RaddrFifo0_io_push_valid        ), //i
    .io_push_ready   (RaddrFifo0_io_push_ready        ), //o
    .io_push_payload (RaddrFifo0_io_push_payload[15:0]), //i
    .io_pop_valid    (RaddrFifo0_io_pop_valid         ), //o
    .io_pop_ready    (RaddrFifo0_io_pop_ready         ), //i
    .io_pop_payload  (RaddrFifo0_io_pop_payload[15:0] ), //o
    .io_flush        (RaddrFifo0_io_flush             ), //i
    .io_occupancy    (RaddrFifo0_io_occupancy[5:0]    ), //o
    .io_availability (RaddrFifo0_io_availability[5:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  Img2Col_OutPut Img2Col_SubModule (
    .start                          (Img2Col_SubModule_start             ), //i
    .NewAddrIn_valid                (Img2Col_SubModule_NewAddrIn_valid   ), //i
    .NewAddrIn_ready                (Img2Col_SubModule_NewAddrIn_ready   ), //o
    .NewAddrIn_payload              (RaddrFifo0_io_pop_payload[15:0]     ), //i
    .SA_Idle                        (Img2Col_SubModule_SA_Idle           ), //o
    .Raddr                          (Img2Col_SubModule_Raddr[15:0]       ), //o
    .Raddr_Valid                    (Img2Col_SubModule_Raddr_Valid       ), //o
    .SA_End                         (Img2Col_SubModule_SA_End            ), //o
    .Stride                         (Stride[4:0]                         ), //i
    .Kernel_Size                    (Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Window_Size[15:0]                   ), //i
    .InFeature_Size                 (InFeature_Size[15:0]                ), //i
    .InFeature_Channel              (InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (OutFeature_Channel[15:0]            ), //i
    .OutFeature_Size                (OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (InCol_Count_Times[15:0]             ), //i
    .OutFeature_Channel_Count_Times (OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Sliding_Size[12:0]                  ), //i
    .mReady                         (mReady                              ), //i
    .Fifo_Clear                     (Fifo_Clear                          ), //i
    .AddrReceived                   (Img2Col_SubModule_AddrReceived      ), //o
    .LayerEnd                       (Fsm_Layer_End                       ), //i
    .SA_Row_Cnt_Valid               (Img2Col_SubModule_SA_Row_Cnt_Valid  ), //o
    .clk                            (clk                                 ), //i
    .reset                          (reset                               )  //i
  );
  DataGen_Bram DGB (
    .clka  (clk                ), //i
    .addra (DGB_addra[13:0]    ), //i
    .dina  (sData_payload[63:0]), //i
    .ena   (sData_fire_1       ), //i
    .wea   (1'b1               ), //i
    .addrb (DGB_addrb[13:0]    ), //i
    .doutb (DGB_doutb[63:0]    ), //o
    .clkb  (clk                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      IMG2COL_ENUM_IDLE : Fsm_currentState_string = "IDLE         ";
      IMG2COL_ENUM_INIT : Fsm_currentState_string = "INIT         ";
      IMG2COL_ENUM_INIT_ADDR : Fsm_currentState_string = "INIT_ADDR    ";
      IMG2COL_ENUM_DATA_CACHE : Fsm_currentState_string = "DATA_CACHE   ";
      IMG2COL_ENUM_WAIT_COMPUTE : Fsm_currentState_string = "WAIT_COMPUTE ";
      IMG2COL_ENUM_UPDATE_ADDR : Fsm_currentState_string = "UPDATE_ADDR  ";
      IMG2COL_ENUM_START_COMPUTE : Fsm_currentState_string = "START_COMPUTE";
      default : Fsm_currentState_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      IMG2COL_ENUM_IDLE : Fsm_nextState_string = "IDLE         ";
      IMG2COL_ENUM_INIT : Fsm_nextState_string = "INIT         ";
      IMG2COL_ENUM_INIT_ADDR : Fsm_nextState_string = "INIT_ADDR    ";
      IMG2COL_ENUM_DATA_CACHE : Fsm_nextState_string = "DATA_CACHE   ";
      IMG2COL_ENUM_WAIT_COMPUTE : Fsm_nextState_string = "WAIT_COMPUTE ";
      IMG2COL_ENUM_UPDATE_ADDR : Fsm_nextState_string = "UPDATE_ADDR  ";
      IMG2COL_ENUM_START_COMPUTE : Fsm_nextState_string = "START_COMPUTE";
      default : Fsm_nextState_string = "?????????????";
    endcase
  end
  `endif

  assign when_Data_Generate_V2_l59 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & IMG2COL_ENUM_IDLE) == IMG2COL_ENUM_IDLE) : begin
        if(when_Data_Generate_V2_l59) begin
          Fsm_nextState = IMG2COL_ENUM_INIT;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_INIT) == IMG2COL_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = IMG2COL_ENUM_INIT_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_INIT_ADDR) == IMG2COL_ENUM_INIT_ADDR) : begin
        if(Fsm_Addr_Inited) begin
          Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_INIT_ADDR;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_DATA_CACHE) == IMG2COL_ENUM_DATA_CACHE) : begin
        if(Fsm_Data_Cached) begin
          Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_WAIT_COMPUTE) == IMG2COL_ENUM_WAIT_COMPUTE) : begin
        if(Fsm_Layer_End) begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end else begin
          if(Fsm_SA_Ready) begin
            Fsm_nextState = IMG2COL_ENUM_UPDATE_ADDR;
          end else begin
            Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
          end
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_UPDATE_ADDR) == IMG2COL_ENUM_UPDATE_ADDR) : begin
        if(Fsm_Addr_Updated) begin
          Fsm_nextState = IMG2COL_ENUM_START_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_UPDATE_ADDR;
        end
      end
      default : begin
        if(Fsm_Layer_End) begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end else begin
          if(Fsm_Cache_End) begin
            Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
          end else begin
            Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
          end
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & IMG2COL_ENUM_INIT) != 7'b0000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign when_WaCounter_l40 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign Addr_Init_Cnt_valid = ((Addr_Init_Cnt_count == _zz_Addr_Init_Cnt_valid) && when_WaCounter_l40);
  assign Fsm_Addr_Inited = Addr_Init_Cnt_valid;
  always @(*) begin
    AddrFifo_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l170) begin
      AddrFifo_io_push_valid = 1'b1;
    end
    if(In_Col_Cnt_valid) begin
      AddrFifo_io_push_valid = 1'b1;
    end
  end

  always @(*) begin
    AddrFifo_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l183) begin
      AddrFifo_io_pop_ready = 1'b1;
    end
    if(In_Col_Cnt_valid) begin
      AddrFifo_io_pop_ready = 1'b1;
    end
  end

  assign when_Data_Generate_V2_l170 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l175 = ((Fsm_currentState & IMG2COL_ENUM_INIT) != 7'b0000000);
  assign SubModule_AddrFifo_io_pop_fire = (AddrFifo_io_pop_valid && AddrFifo_io_pop_ready);
  assign when_Data_Generate_V2_l179 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l183 = (((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_ENUM_DATA_CACHE) != 7'b0000000));
  always @(*) begin
    RaddrFifo0_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l193) begin
      RaddrFifo0_io_push_valid = 1'b1;
    end
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_push_valid = SubModule_RaddrFifo0_io_pop_fire;
    end
  end

  always @(*) begin
    RaddrFifo0_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_pop_ready = Img2ColOutput_Module_Ready_Receive_Addr;
    end
  end

  always @(*) begin
    RaddrFifo0_io_push_payload = RaddrFifo0_io_pop_payload;
    if(when_Data_Generate_V2_l193) begin
      RaddrFifo0_io_push_payload = Raddr_Initialization;
    end
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_push_payload = RaddrFifo0_io_pop_payload;
    end
  end

  assign when_Data_Generate_V2_l193 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l197 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign sData_fire = (sData_valid && sData_ready);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == _zz_In_Col_Cnt_valid) && sData_fire);
  assign Row_Cache_Cnt_valid = ((Row_Cache_Cnt_count == _zz_Row_Cache_Cnt_valid) && In_Col_Cnt_valid);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && In_Col_Cnt_valid);
  assign when_Data_Generate_V2_l217 = (_zz_when_Data_Generate_V2_l217 < In_Row_Cnt_count);
  always @(*) begin
    if(when_Data_Generate_V2_l217) begin
      Cache_Row_Num = Stride;
    end else begin
      Cache_Row_Num = Kernel_Size;
    end
  end

  always @(*) begin
    if(when_Data_Generate_V2_l217) begin
      Raddr_Updata_Cnt_Num = Stride;
    end else begin
      Raddr_Updata_Cnt_Num = Kernel_Size;
    end
  end

  assign Fsm_Data_Cached = Row_Cache_Cnt_valid;
  assign when_Data_Generate_V2_l228 = ((Fsm_currentState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign Fsm_Cache_End = CacheEnd_Flag;
  assign sData_ready = ((Fsm_currentState & IMG2COL_ENUM_DATA_CACHE) != 7'b0000000);
  assign when_Data_Generate_V2_l245 = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign SubModule_RaddrFifo0_io_pop_fire = (RaddrFifo0_io_pop_valid && RaddrFifo0_io_pop_ready);
  assign Img2Col_SubModule_start = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign Fsm_SA_Ready = Img2Col_SubModule_SA_Idle;
  assign Img2ColOutput_Module_Ready_Receive_Addr = Img2Col_SubModule_NewAddrIn_ready;
  assign Img2Col_SubModule_NewAddrIn_valid = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign SA_Row_Cnt_Valid = Img2Col_SubModule_SA_Row_Cnt_Valid;
  assign LayerEnd = Fsm_Layer_End;
  assign Fsm_Addr_Updated = Img2Col_SubModule_AddrReceived;
  assign Out_Row_Cnt_valid = ((Out_Row_Cnt_count == _zz_Out_Row_Cnt_valid) && Img2Col_SubModule_SA_End);
  assign Fsm_Layer_End = Out_Row_Cnt_valid;
  assign Waddr = (WaddrOffset + In_Col_Cnt_count);
  assign DGB_addra = Waddr[13:0];
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign DGB_addrb = Img2Col_SubModule_Raddr[13:0];
  assign mData = DGB_doutb;
  assign mValid = SubModule_Img2Col_SubModule_Raddr_Valid_regNext;
  assign mLast = Out_Row_Cnt_valid_regNext;
  assign Test_Valid = (_zz_Test_Valid == Out_Row_Cnt_count_regNext);
  assign Test_Signal = Test_Valid;
  assign Test_End = ((! Test_Valid) && Test_Valid_regNext);
  assign AddrFifo_io_flush = ((Fsm_nextState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign RaddrFifo0_io_flush = ((Fsm_nextState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign Raddr_Valid = Img2Col_SubModule_Raddr_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    SubModule_Img2Col_SubModule_Raddr_Valid_regNext <= Img2Col_SubModule_Raddr_Valid;
    Out_Row_Cnt_valid_regNext <= Out_Row_Cnt_valid;
    Out_Row_Cnt_count_regNext <= Out_Row_Cnt_count;
    Test_Valid_regNext <= Test_Valid;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= IMG2COL_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Addr_Init_Cnt_count <= 5'h0;
      WaddrOffset <= 16'h0;
      Raddr_Initialization <= 16'h0;
      In_Col_Cnt_count <= 16'h0;
      Row_Cache_Cnt_count <= 5'h0;
      In_Row_Cnt_count <= 16'h0;
      CacheEnd_Flag <= 1'b0;
      Out_Row_Cnt_count <= 16'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l40) begin
        if(Addr_Init_Cnt_valid) begin
          Addr_Init_Cnt_count <= 5'h0;
        end else begin
          Addr_Init_Cnt_count <= (Addr_Init_Cnt_count + 5'h01);
        end
      end
      if(when_Data_Generate_V2_l175) begin
        WaddrOffset <= 16'h0;
      end else begin
        if(SubModule_AddrFifo_io_pop_fire) begin
          WaddrOffset <= AddrFifo_io_pop_payload;
        end else begin
          if(when_Data_Generate_V2_l179) begin
            WaddrOffset <= (WaddrOffset + InCol_Count_Times);
          end
        end
      end
      if(when_Data_Generate_V2_l197) begin
        Raddr_Initialization <= (Raddr_Initialization + InCol_Count_Times);
      end else begin
        Raddr_Initialization <= 16'h0;
      end
      if(sData_fire) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= 16'h0;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count + 16'h0001);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(Row_Cache_Cnt_valid) begin
          Row_Cache_Cnt_count <= 5'h0;
        end else begin
          Row_Cache_Cnt_count <= (Row_Cache_Cnt_count + 5'h01);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 16'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 16'h0001);
        end
      end
      if(In_Row_Cnt_valid) begin
        CacheEnd_Flag <= 1'b1;
      end else begin
        if(when_Data_Generate_V2_l228) begin
          CacheEnd_Flag <= 1'b0;
        end
      end
      if(Img2Col_SubModule_SA_End) begin
        if(Out_Row_Cnt_valid) begin
          Out_Row_Cnt_count <= 16'h0;
        end else begin
          Out_Row_Cnt_count <= (Out_Row_Cnt_count + 16'h0001);
        end
      end
    end
  end


endmodule

module Quan (
  input      [31:0]   dataIn_0,
  input      [31:0]   dataIn_1,
  input      [31:0]   dataIn_2,
  input      [31:0]   dataIn_3,
  input      [31:0]   dataIn_4,
  input      [31:0]   dataIn_5,
  input      [31:0]   dataIn_6,
  input      [31:0]   dataIn_7,
  input      [31:0]   biasIn,
  input      [31:0]   scaleIn,
  input      [31:0]   shiftIn,
  input      [7:0]    zeroIn,
  output reg [63:0]   dataOut,
  input               clk,
  input               reset
);

  wire       [47:0]   bias_1_Bias_dataOut_0;
  wire       [47:0]   bias_1_Bias_dataOut_1;
  wire       [47:0]   bias_1_Bias_dataOut_2;
  wire       [47:0]   bias_1_Bias_dataOut_3;
  wire       [47:0]   bias_1_Bias_dataOut_4;
  wire       [47:0]   bias_1_Bias_dataOut_5;
  wire       [47:0]   bias_1_Bias_dataOut_6;
  wire       [47:0]   bias_1_Bias_dataOut_7;
  wire       [31:0]   scale_1_Scale_dataOut_0;
  wire       [31:0]   scale_1_Scale_dataOut_1;
  wire       [31:0]   scale_1_Scale_dataOut_2;
  wire       [31:0]   scale_1_Scale_dataOut_3;
  wire       [31:0]   scale_1_Scale_dataOut_4;
  wire       [31:0]   scale_1_Scale_dataOut_5;
  wire       [31:0]   scale_1_Scale_dataOut_6;
  wire       [31:0]   scale_1_Scale_dataOut_7;
  wire       [15:0]   shift_1_shift_dataOut_0;
  wire       [15:0]   shift_1_shift_dataOut_1;
  wire       [15:0]   shift_1_shift_dataOut_2;
  wire       [15:0]   shift_1_shift_dataOut_3;
  wire       [15:0]   shift_1_shift_dataOut_4;
  wire       [15:0]   shift_1_shift_dataOut_5;
  wire       [15:0]   shift_1_shift_dataOut_6;
  wire       [15:0]   shift_1_shift_dataOut_7;
  wire       [7:0]    zero_1_dataOut_0;
  wire       [7:0]    zero_1_dataOut_1;
  wire       [7:0]    zero_1_dataOut_2;
  wire       [7:0]    zero_1_dataOut_3;
  wire       [7:0]    zero_1_dataOut_4;
  wire       [7:0]    zero_1_dataOut_5;
  wire       [7:0]    zero_1_dataOut_6;
  wire       [7:0]    zero_1_dataOut_7;
  reg        [31:0]   dataIn_regNext_0;
  reg        [31:0]   dataIn_regNext_1;
  reg        [31:0]   dataIn_regNext_2;
  reg        [31:0]   dataIn_regNext_3;
  reg        [31:0]   dataIn_regNext_4;
  reg        [31:0]   dataIn_regNext_5;
  reg        [31:0]   dataIn_regNext_6;
  reg        [31:0]   dataIn_regNext_7;
  reg        [31:0]   scaleIn_delay_1;
  reg        [31:0]   scaleIn_delay_2;
  reg        [31:0]   shiftIn_delay_1;
  reg        [31:0]   shiftIn_delay_2;
  reg        [31:0]   shiftIn_delay_3;
  reg        [31:0]   shiftIn_delay_4;
  reg        [31:0]   shiftIn_delay_5;
  reg        [31:0]   shiftIn_delay_6;
  reg        [31:0]   shiftIn_delay_7;
  reg        [31:0]   shiftIn_delay_8;
  reg        [31:0]   shiftIn_delay_9;
  reg        [31:0]   shiftIn_delay_10;
  reg        [31:0]   shiftIn_delay_11;
  wire       [383:0]  Debug_Bias;
  wire       [255:0]  Debug_Scale;
  wire       [127:0]  Debug_Shift;
  wire       [63:0]   Debug_DataOut;

  Bias bias_1 (
    .Bias_dataIn_0  (dataIn_regNext_0[31:0]     ), //i
    .Bias_dataIn_1  (dataIn_regNext_1[31:0]     ), //i
    .Bias_dataIn_2  (dataIn_regNext_2[31:0]     ), //i
    .Bias_dataIn_3  (dataIn_regNext_3[31:0]     ), //i
    .Bias_dataIn_4  (dataIn_regNext_4[31:0]     ), //i
    .Bias_dataIn_5  (dataIn_regNext_5[31:0]     ), //i
    .Bias_dataIn_6  (dataIn_regNext_6[31:0]     ), //i
    .Bias_dataIn_7  (dataIn_regNext_7[31:0]     ), //i
    .Bias_quan      (biasIn[31:0]               ), //i
    .Bias_dataOut_0 (bias_1_Bias_dataOut_0[47:0]), //o
    .Bias_dataOut_1 (bias_1_Bias_dataOut_1[47:0]), //o
    .Bias_dataOut_2 (bias_1_Bias_dataOut_2[47:0]), //o
    .Bias_dataOut_3 (bias_1_Bias_dataOut_3[47:0]), //o
    .Bias_dataOut_4 (bias_1_Bias_dataOut_4[47:0]), //o
    .Bias_dataOut_5 (bias_1_Bias_dataOut_5[47:0]), //o
    .Bias_dataOut_6 (bias_1_Bias_dataOut_6[47:0]), //o
    .Bias_dataOut_7 (bias_1_Bias_dataOut_7[47:0]), //o
    .clk            (clk                        ), //i
    .reset          (reset                      )  //i
  );
  Scale scale_1 (
    .Scale_dataIn_0  (bias_1_Bias_dataOut_0[47:0]  ), //i
    .Scale_dataIn_1  (bias_1_Bias_dataOut_1[47:0]  ), //i
    .Scale_dataIn_2  (bias_1_Bias_dataOut_2[47:0]  ), //i
    .Scale_dataIn_3  (bias_1_Bias_dataOut_3[47:0]  ), //i
    .Scale_dataIn_4  (bias_1_Bias_dataOut_4[47:0]  ), //i
    .Scale_dataIn_5  (bias_1_Bias_dataOut_5[47:0]  ), //i
    .Scale_dataIn_6  (bias_1_Bias_dataOut_6[47:0]  ), //i
    .Scale_dataIn_7  (bias_1_Bias_dataOut_7[47:0]  ), //i
    .Scale_quan      (scaleIn_delay_2[31:0]        ), //i
    .Scale_dataOut_0 (scale_1_Scale_dataOut_0[31:0]), //o
    .Scale_dataOut_1 (scale_1_Scale_dataOut_1[31:0]), //o
    .Scale_dataOut_2 (scale_1_Scale_dataOut_2[31:0]), //o
    .Scale_dataOut_3 (scale_1_Scale_dataOut_3[31:0]), //o
    .Scale_dataOut_4 (scale_1_Scale_dataOut_4[31:0]), //o
    .Scale_dataOut_5 (scale_1_Scale_dataOut_5[31:0]), //o
    .Scale_dataOut_6 (scale_1_Scale_dataOut_6[31:0]), //o
    .Scale_dataOut_7 (scale_1_Scale_dataOut_7[31:0]), //o
    .clk             (clk                          ), //i
    .reset           (reset                        )  //i
  );
  Shift shift_1 (
    .shift_dataIn_0  (scale_1_Scale_dataOut_0[31:0]), //i
    .shift_dataIn_1  (scale_1_Scale_dataOut_1[31:0]), //i
    .shift_dataIn_2  (scale_1_Scale_dataOut_2[31:0]), //i
    .shift_dataIn_3  (scale_1_Scale_dataOut_3[31:0]), //i
    .shift_dataIn_4  (scale_1_Scale_dataOut_4[31:0]), //i
    .shift_dataIn_5  (scale_1_Scale_dataOut_5[31:0]), //i
    .shift_dataIn_6  (scale_1_Scale_dataOut_6[31:0]), //i
    .shift_dataIn_7  (scale_1_Scale_dataOut_7[31:0]), //i
    .shift_quan      (shiftIn_delay_11[31:0]       ), //i
    .shift_dataOut_0 (shift_1_shift_dataOut_0[15:0]), //o
    .shift_dataOut_1 (shift_1_shift_dataOut_1[15:0]), //o
    .shift_dataOut_2 (shift_1_shift_dataOut_2[15:0]), //o
    .shift_dataOut_3 (shift_1_shift_dataOut_3[15:0]), //o
    .shift_dataOut_4 (shift_1_shift_dataOut_4[15:0]), //o
    .shift_dataOut_5 (shift_1_shift_dataOut_5[15:0]), //o
    .shift_dataOut_6 (shift_1_shift_dataOut_6[15:0]), //o
    .shift_dataOut_7 (shift_1_shift_dataOut_7[15:0]), //o
    .clk             (clk                          ), //i
    .reset           (reset                        )  //i
  );
  Zero zero_1 (
    .dataIn_0  (shift_1_shift_dataOut_0[15:0]), //i
    .dataIn_1  (shift_1_shift_dataOut_1[15:0]), //i
    .dataIn_2  (shift_1_shift_dataOut_2[15:0]), //i
    .dataIn_3  (shift_1_shift_dataOut_3[15:0]), //i
    .dataIn_4  (shift_1_shift_dataOut_4[15:0]), //i
    .dataIn_5  (shift_1_shift_dataOut_5[15:0]), //i
    .dataIn_6  (shift_1_shift_dataOut_6[15:0]), //i
    .dataIn_7  (shift_1_shift_dataOut_7[15:0]), //i
    .quan_1    (zeroIn[7:0]                  ), //i
    .dataOut_0 (zero_1_dataOut_0[7:0]        ), //o
    .dataOut_1 (zero_1_dataOut_1[7:0]        ), //o
    .dataOut_2 (zero_1_dataOut_2[7:0]        ), //o
    .dataOut_3 (zero_1_dataOut_3[7:0]        ), //o
    .dataOut_4 (zero_1_dataOut_4[7:0]        ), //o
    .dataOut_5 (zero_1_dataOut_5[7:0]        ), //o
    .dataOut_6 (zero_1_dataOut_6[7:0]        ), //o
    .dataOut_7 (zero_1_dataOut_7[7:0]        ), //o
    .clk       (clk                          ), //i
    .reset     (reset                        )  //i
  );
  ila_BiasScaleShift xil_ila (
    .probe0 (Debug_Bias[383:0]  ), //i
    .probe1 (Debug_Scale[255:0] ), //i
    .probe2 (Debug_Shift[127:0] ), //i
    .probe3 (Debug_DataOut[63:0]), //i
    .clk    (clk                )  //i
  );
  always @(*) begin
    dataOut[7 : 0] = zero_1_dataOut_0;
    dataOut[15 : 8] = zero_1_dataOut_1;
    dataOut[23 : 16] = zero_1_dataOut_2;
    dataOut[31 : 24] = zero_1_dataOut_3;
    dataOut[39 : 32] = zero_1_dataOut_4;
    dataOut[47 : 40] = zero_1_dataOut_5;
    dataOut[55 : 48] = zero_1_dataOut_6;
    dataOut[63 : 56] = zero_1_dataOut_7;
  end

  assign Debug_Bias = {bias_1_Bias_dataOut_7,{bias_1_Bias_dataOut_6,{bias_1_Bias_dataOut_5,{bias_1_Bias_dataOut_4,{bias_1_Bias_dataOut_3,{bias_1_Bias_dataOut_2,{bias_1_Bias_dataOut_1,bias_1_Bias_dataOut_0}}}}}}};
  assign Debug_Scale = {scale_1_Scale_dataOut_7,{scale_1_Scale_dataOut_6,{scale_1_Scale_dataOut_5,{scale_1_Scale_dataOut_4,{scale_1_Scale_dataOut_3,{scale_1_Scale_dataOut_2,{scale_1_Scale_dataOut_1,scale_1_Scale_dataOut_0}}}}}}};
  assign Debug_Shift = {shift_1_shift_dataOut_7,{shift_1_shift_dataOut_6,{shift_1_shift_dataOut_5,{shift_1_shift_dataOut_4,{shift_1_shift_dataOut_3,{shift_1_shift_dataOut_2,{shift_1_shift_dataOut_1,shift_1_shift_dataOut_0}}}}}}};
  assign Debug_DataOut = dataOut;
  always @(posedge clk) begin
    dataIn_regNext_0 <= dataIn_0;
    dataIn_regNext_1 <= dataIn_1;
    dataIn_regNext_2 <= dataIn_2;
    dataIn_regNext_3 <= dataIn_3;
    dataIn_regNext_4 <= dataIn_4;
    dataIn_regNext_5 <= dataIn_5;
    dataIn_regNext_6 <= dataIn_6;
    dataIn_regNext_7 <= dataIn_7;
    scaleIn_delay_1 <= scaleIn;
    scaleIn_delay_2 <= scaleIn_delay_1;
    shiftIn_delay_1 <= shiftIn;
    shiftIn_delay_2 <= shiftIn_delay_1;
    shiftIn_delay_3 <= shiftIn_delay_2;
    shiftIn_delay_4 <= shiftIn_delay_3;
    shiftIn_delay_5 <= shiftIn_delay_4;
    shiftIn_delay_6 <= shiftIn_delay_5;
    shiftIn_delay_7 <= shiftIn_delay_6;
    shiftIn_delay_8 <= shiftIn_delay_7;
    shiftIn_delay_9 <= shiftIn_delay_8;
    shiftIn_delay_10 <= shiftIn_delay_9;
    shiftIn_delay_11 <= shiftIn_delay_10;
  end


endmodule

module Weight_Cache (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  input      [15:0]   Matrix_Row,
  input      [15:0]   Matrix_Col,
  output     [7:0]    mData_0,
  output     [7:0]    mData_1,
  output     [7:0]    mData_2,
  output     [7:0]    mData_3,
  output     [7:0]    mData_4,
  output     [7:0]    mData_5,
  output     [7:0]    mData_6,
  output     [7:0]    mData_7,
  input               Raddr_Valid,
  output              Weight_Cached,
  input               LayerEnd,
  output     [7:0]    MatrixCol_Switch,
  input               clk,
  input               reset
);
  localparam WEIGHT_CACHE_STATUS_IDLE = 4'd1;
  localparam WEIGHT_CACHE_STATUS_INIT = 4'd2;
  localparam WEIGHT_CACHE_STATUS_CACHE_WEIGHT = 4'd4;
  localparam WEIGHT_CACHE_STATUS_SA_COMPUTE = 4'd8;

  wire       [14:0]   xil_SimpleDualBram_addra;
  wire                xil_SimpleDualBram_ena;
  wire       [17:0]   xil_SimpleDualBram_addrb;
  wire       [14:0]   xil_SimpleDualBram_1_addra;
  wire                xil_SimpleDualBram_1_ena;
  wire       [17:0]   xil_SimpleDualBram_1_addrb;
  wire       [14:0]   xil_SimpleDualBram_2_addra;
  wire                xil_SimpleDualBram_2_ena;
  wire       [17:0]   xil_SimpleDualBram_2_addrb;
  wire       [14:0]   xil_SimpleDualBram_3_addra;
  wire                xil_SimpleDualBram_3_ena;
  wire       [17:0]   xil_SimpleDualBram_3_addrb;
  wire       [14:0]   xil_SimpleDualBram_4_addra;
  wire                xil_SimpleDualBram_4_ena;
  wire       [17:0]   xil_SimpleDualBram_4_addrb;
  wire       [14:0]   xil_SimpleDualBram_5_addra;
  wire                xil_SimpleDualBram_5_ena;
  wire       [17:0]   xil_SimpleDualBram_5_addrb;
  wire       [14:0]   xil_SimpleDualBram_6_addra;
  wire                xil_SimpleDualBram_6_ena;
  wire       [17:0]   xil_SimpleDualBram_6_addrb;
  wire       [14:0]   xil_SimpleDualBram_7_addra;
  wire                xil_SimpleDualBram_7_ena;
  wire       [17:0]   xil_SimpleDualBram_7_addrb;
  wire       [7:0]    xil_SimpleDualBram_doutb;
  wire       [7:0]    xil_SimpleDualBram_1_doutb;
  wire       [7:0]    xil_SimpleDualBram_2_doutb;
  wire       [7:0]    xil_SimpleDualBram_3_doutb;
  wire       [7:0]    xil_SimpleDualBram_4_doutb;
  wire       [7:0]    xil_SimpleDualBram_5_doutb;
  wire       [7:0]    xil_SimpleDualBram_6_doutb;
  wire       [7:0]    xil_SimpleDualBram_7_doutb;
  wire       [15:0]   _zz_In_Row_Cnt_valid;
  wire       [12:0]   _zz_In_Row_Cnt_valid_1;
  wire       [15:0]   _zz_In_Col_Cnt_valid;
  wire       [15:0]   _zz_OutRow_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_count_1;
  wire       [17:0]   _zz_Read_Row_Base_Addr;
  wire       [14:0]   _zz_Write_Row_Base_Addr;
  wire       [15:0]   _zz_addra;
  wire       [15:0]   _zz_addra_1;
  wire       [17:0]   _zz_addrb;
  wire       [0:0]    _zz_ena;
  wire       [15:0]   _zz_addra_2;
  wire       [15:0]   _zz_addra_3;
  wire       [17:0]   _zz_addrb_1;
  wire       [0:0]    _zz_ena_1;
  wire       [15:0]   _zz_addra_4;
  wire       [15:0]   _zz_addra_5;
  wire       [17:0]   _zz_addrb_2;
  wire       [0:0]    _zz_ena_2;
  wire       [15:0]   _zz_addra_6;
  wire       [15:0]   _zz_addra_7;
  wire       [17:0]   _zz_addrb_3;
  wire       [0:0]    _zz_ena_3;
  wire       [15:0]   _zz_addra_8;
  wire       [15:0]   _zz_addra_9;
  wire       [17:0]   _zz_addrb_4;
  wire       [0:0]    _zz_ena_4;
  wire       [15:0]   _zz_addra_10;
  wire       [15:0]   _zz_addra_11;
  wire       [17:0]   _zz_addrb_5;
  wire       [0:0]    _zz_ena_5;
  wire       [15:0]   _zz_addra_12;
  wire       [15:0]   _zz_addra_13;
  wire       [17:0]   _zz_addrb_6;
  wire       [0:0]    _zz_ena_6;
  wire       [15:0]   _zz_addra_14;
  wire       [15:0]   _zz_addra_15;
  wire       [17:0]   _zz_addrb_7;
  wire       [0:0]    _zz_ena_7;
  reg                 start_regNext;
  wire                when_SA3D_WeightCache_l34;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Weight_All_Cached;
  wire                Fsm_SA_Computed;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  reg        [7:0]    InData_Switch;
  wire       [12:0]   Matrix_In_MaxCnt;
  wire                sData_fire;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [17:0]   Read_Row_Base_Addr;
  reg        [14:0]   Write_Row_Base_Addr;
  wire                when_WaCounter_l40;
  reg        [15:0]   OutRow_Cnt_count;
  wire                OutRow_Cnt_valid;
  wire       [3:0]    _zz_OutCol_Cnt_count;
  reg        [15:0]   OutCol_Cnt_count;
  reg                 OutCol_Cnt_valid;
  wire                when_SA3D_WeightCache_l114;
  reg        [2:0]    Col_In_8_Cnt_count;
  reg                 Col_In_8_Cnt_valid;
  wire                when_SA3D_WeightCache_l133;
  wire                when_SA3D_WeightCache_l138;
  wire                sData_fire_1;
  wire                sData_fire_2;
  wire                sData_fire_3;
  wire                sData_fire_4;
  wire                sData_fire_5;
  wire                sData_fire_6;
  wire                sData_fire_7;
  wire                sData_fire_8;
  reg        [7:0]    MatrixCol_Switch_1;
  reg        [7:0]    MatrixCol_Switch_1_regNext;
  wire       [7:0]    Debug_MatrixCol_Switch;
  wire       [15:0]   Debug_OutCol_Cnt;
  wire       [2:0]    Debug_Col_In_8_Cnt;
  wire       [15:0]   Debug_In_Row_Cnt;
  wire       [15:0]   Debug_In_Col_Cnt;
  wire       [7:0]    Debug_InData_Switch;
  wire       [0:0]    Debug_sready;
  wire       [0:0]    Debug_svalid;
  wire       [3:0]    Debug_fsm;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_In_Row_Cnt_valid_1 = (Matrix_In_MaxCnt - 13'h0001);
  assign _zz_In_Row_Cnt_valid = {3'd0, _zz_In_Row_Cnt_valid_1};
  assign _zz_In_Col_Cnt_valid = (Matrix_Col - 16'h0001);
  assign _zz_OutRow_Cnt_valid = (Matrix_Row - 16'h0001);
  assign _zz_OutCol_Cnt_valid = {12'd0, _zz_OutCol_Cnt_count};
  assign _zz_OutCol_Cnt_count_1 = {12'd0, _zz_OutCol_Cnt_count};
  assign _zz_Read_Row_Base_Addr = {2'd0, Matrix_Row};
  assign _zz_Write_Row_Base_Addr = {2'd0, Matrix_In_MaxCnt};
  assign _zz_addra = (In_Row_Cnt_count + _zz_addra_1);
  assign _zz_addra_1 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb = {2'd0, OutRow_Cnt_count};
  assign _zz_ena = InData_Switch[0 : 0];
  assign _zz_addra_2 = (In_Row_Cnt_count + _zz_addra_3);
  assign _zz_addra_3 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_1 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_1 = InData_Switch[1 : 1];
  assign _zz_addra_4 = (In_Row_Cnt_count + _zz_addra_5);
  assign _zz_addra_5 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_2 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_2 = InData_Switch[2 : 2];
  assign _zz_addra_6 = (In_Row_Cnt_count + _zz_addra_7);
  assign _zz_addra_7 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_3 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_3 = InData_Switch[3 : 3];
  assign _zz_addra_8 = (In_Row_Cnt_count + _zz_addra_9);
  assign _zz_addra_9 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_4 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_4 = InData_Switch[4 : 4];
  assign _zz_addra_10 = (In_Row_Cnt_count + _zz_addra_11);
  assign _zz_addra_11 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_5 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_5 = InData_Switch[5 : 5];
  assign _zz_addra_12 = (In_Row_Cnt_count + _zz_addra_13);
  assign _zz_addra_13 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_6 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_6 = InData_Switch[6 : 6];
  assign _zz_addra_14 = (In_Row_Cnt_count + _zz_addra_15);
  assign _zz_addra_15 = {1'd0, Write_Row_Base_Addr};
  assign _zz_addrb_7 = {2'd0, OutRow_Cnt_count};
  assign _zz_ena_7 = InData_Switch[7 : 7];
  Weight_Bram xil_SimpleDualBram (
    .clka  (clk                           ), //i
    .addra (xil_SimpleDualBram_addra[14:0]), //i
    .dina  (sData_payload[63:0]           ), //i
    .ena   (xil_SimpleDualBram_ena        ), //i
    .wea   (1'b1                          ), //i
    .addrb (xil_SimpleDualBram_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_doutb[7:0] ), //o
    .clkb  (clk                           )  //i
  );
  Weight_Bram xil_SimpleDualBram_1 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_1_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_1_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_1_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_1_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_2 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_2_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_2_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_2_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_2_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_3 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_3_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_3_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_3_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_3_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_4 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_4_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_4_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_4_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_4_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_5 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_5_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_5_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_5_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_5_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_6 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_6_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_6_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_6_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_6_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_7 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_7_addra[14:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_7_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_7_addrb[17:0]), //i
    .doutb (xil_SimpleDualBram_7_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  ila_Weightcache xil_ila (
    .probe0 (Debug_MatrixCol_Switch[7:0]), //i
    .probe1 (Debug_OutCol_Cnt[15:0]     ), //i
    .probe2 (Debug_Col_In_8_Cnt[2:0]    ), //i
    .probe3 (Debug_In_Row_Cnt[15:0]     ), //i
    .probe4 (Debug_In_Col_Cnt[15:0]     ), //i
    .probe5 (Debug_InData_Switch[7:0]   ), //i
    .probe6 (Debug_sready               ), //i
    .probe7 (Debug_svalid               ), //i
    .probe8 (Debug_fsm[3:0]             ), //i
    .clk    (clk                        )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      WEIGHT_CACHE_STATUS_IDLE : Fsm_currentState_string = "IDLE        ";
      WEIGHT_CACHE_STATUS_INIT : Fsm_currentState_string = "INIT        ";
      WEIGHT_CACHE_STATUS_CACHE_WEIGHT : Fsm_currentState_string = "CACHE_WEIGHT";
      WEIGHT_CACHE_STATUS_SA_COMPUTE : Fsm_currentState_string = "SA_COMPUTE  ";
      default : Fsm_currentState_string = "????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      WEIGHT_CACHE_STATUS_IDLE : Fsm_nextState_string = "IDLE        ";
      WEIGHT_CACHE_STATUS_INIT : Fsm_nextState_string = "INIT        ";
      WEIGHT_CACHE_STATUS_CACHE_WEIGHT : Fsm_nextState_string = "CACHE_WEIGHT";
      WEIGHT_CACHE_STATUS_SA_COMPUTE : Fsm_nextState_string = "SA_COMPUTE  ";
      default : Fsm_nextState_string = "????????????";
    endcase
  end
  `endif

  assign when_SA3D_WeightCache_l34 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_IDLE) == WEIGHT_CACHE_STATUS_IDLE) : begin
        if(when_SA3D_WeightCache_l34) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_INIT;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_IDLE;
        end
      end
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_INIT) == WEIGHT_CACHE_STATUS_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_CACHE_WEIGHT;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_INIT;
        end
      end
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) == WEIGHT_CACHE_STATUS_CACHE_WEIGHT) : begin
        if(Fsm_Weight_All_Cached) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_SA_COMPUTE;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_CACHE_WEIGHT;
        end
      end
      default : begin
        if(Fsm_SA_Computed) begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_IDLE;
        end else begin
          Fsm_nextState = WEIGHT_CACHE_STATUS_SA_COMPUTE;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Matrix_In_MaxCnt = (Matrix_Row >>> 3);
  assign sData_fire = (sData_valid && sData_ready);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && sData_fire);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == _zz_In_Col_Cnt_valid) && In_Row_Cnt_valid);
  assign when_WaCounter_l40 = (Raddr_Valid && ((Fsm_currentState & WEIGHT_CACHE_STATUS_SA_COMPUTE) != 4'b0000));
  assign OutRow_Cnt_valid = ((OutRow_Cnt_count == _zz_OutRow_Cnt_valid) && when_WaCounter_l40);
  assign _zz_OutCol_Cnt_count = 4'b1000;
  always @(*) begin
    OutCol_Cnt_valid = ((OutCol_Cnt_count <= _zz_OutCol_Cnt_valid) && OutRow_Cnt_valid);
    if(when_SA3D_WeightCache_l114) begin
      OutCol_Cnt_valid = 1'b0;
    end
  end

  assign when_SA3D_WeightCache_l114 = (start && ((Fsm_currentState & WEIGHT_CACHE_STATUS_IDLE) != 4'b0000));
  always @(*) begin
    Col_In_8_Cnt_valid = ((Col_In_8_Cnt_count == 3'b111) && In_Row_Cnt_valid);
    if(OutCol_Cnt_valid) begin
      Col_In_8_Cnt_valid = 1'b0;
    end
  end

  assign when_SA3D_WeightCache_l133 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_SA3D_WeightCache_l138 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign Fsm_Weight_All_Cached = In_Col_Cnt_valid;
  assign Weight_Cached = In_Col_Cnt_valid;
  assign xil_SimpleDualBram_addra = _zz_addra[14:0];
  assign xil_SimpleDualBram_addrb = (Read_Row_Base_Addr + _zz_addrb);
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_ena = (_zz_ena[0] && sData_fire_1);
  assign mData_0 = xil_SimpleDualBram_doutb;
  assign xil_SimpleDualBram_1_addra = _zz_addra_2[14:0];
  assign xil_SimpleDualBram_1_addrb = (Read_Row_Base_Addr + _zz_addrb_1);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_1_ena = (_zz_ena_1[0] && sData_fire_2);
  assign mData_1 = xil_SimpleDualBram_1_doutb;
  assign xil_SimpleDualBram_2_addra = _zz_addra_4[14:0];
  assign xil_SimpleDualBram_2_addrb = (Read_Row_Base_Addr + _zz_addrb_2);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_2_ena = (_zz_ena_2[0] && sData_fire_3);
  assign mData_2 = xil_SimpleDualBram_2_doutb;
  assign xil_SimpleDualBram_3_addra = _zz_addra_6[14:0];
  assign xil_SimpleDualBram_3_addrb = (Read_Row_Base_Addr + _zz_addrb_3);
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_3_ena = (_zz_ena_3[0] && sData_fire_4);
  assign mData_3 = xil_SimpleDualBram_3_doutb;
  assign xil_SimpleDualBram_4_addra = _zz_addra_8[14:0];
  assign xil_SimpleDualBram_4_addrb = (Read_Row_Base_Addr + _zz_addrb_4);
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_4_ena = (_zz_ena_4[0] && sData_fire_5);
  assign mData_4 = xil_SimpleDualBram_4_doutb;
  assign xil_SimpleDualBram_5_addra = _zz_addra_10[14:0];
  assign xil_SimpleDualBram_5_addrb = (Read_Row_Base_Addr + _zz_addrb_5);
  assign sData_fire_6 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_5_ena = (_zz_ena_5[0] && sData_fire_6);
  assign mData_5 = xil_SimpleDualBram_5_doutb;
  assign xil_SimpleDualBram_6_addra = _zz_addra_12[14:0];
  assign xil_SimpleDualBram_6_addrb = (Read_Row_Base_Addr + _zz_addrb_6);
  assign sData_fire_7 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_6_ena = (_zz_ena_6[0] && sData_fire_7);
  assign mData_6 = xil_SimpleDualBram_6_doutb;
  assign xil_SimpleDualBram_7_addra = _zz_addra_14[14:0];
  assign xil_SimpleDualBram_7_addrb = (Read_Row_Base_Addr + _zz_addrb_7);
  assign sData_fire_8 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_7_ena = (_zz_ena_7[0] && sData_fire_8);
  assign mData_7 = xil_SimpleDualBram_7_doutb;
  assign sData_ready = ((Fsm_currentState & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) != 4'b0000);
  assign Fsm_SA_Computed = LayerEnd;
  always @(*) begin
    case(OutCol_Cnt_count)
      16'h0001 : begin
        MatrixCol_Switch_1[0 : 0] = 1'b1;
        MatrixCol_Switch_1[7 : 1] = 7'h0;
      end
      16'h0002 : begin
        MatrixCol_Switch_1[1 : 0] = 2'b11;
        MatrixCol_Switch_1[7 : 2] = 6'h0;
      end
      16'h0003 : begin
        MatrixCol_Switch_1[2 : 0] = 3'b111;
        MatrixCol_Switch_1[7 : 3] = 5'h0;
      end
      16'h0004 : begin
        MatrixCol_Switch_1[3 : 0] = 4'b1111;
        MatrixCol_Switch_1[7 : 4] = 4'b0000;
      end
      16'h0005 : begin
        MatrixCol_Switch_1[4 : 0] = 5'h1f;
        MatrixCol_Switch_1[7 : 5] = 3'b000;
      end
      16'h0006 : begin
        MatrixCol_Switch_1[5 : 0] = 6'h3f;
        MatrixCol_Switch_1[7 : 6] = 2'b00;
      end
      16'h0007 : begin
        MatrixCol_Switch_1[6 : 0] = 7'h7f;
        MatrixCol_Switch_1[7 : 7] = 1'b0;
      end
      default : begin
        MatrixCol_Switch_1 = 8'hff;
      end
    endcase
  end

  assign MatrixCol_Switch = MatrixCol_Switch_1_regNext;
  assign Debug_MatrixCol_Switch = MatrixCol_Switch_1;
  assign Debug_OutCol_Cnt = OutCol_Cnt_count;
  assign Debug_Col_In_8_Cnt = Col_In_8_Cnt_count;
  assign Debug_In_Row_Cnt = In_Row_Cnt_count;
  assign Debug_In_Col_Cnt = In_Col_Cnt_count;
  assign Debug_InData_Switch = InData_Switch;
  assign Debug_sready = sData_ready;
  assign Debug_svalid = sData_valid;
  assign Debug_fsm = Fsm_currentState;
  always @(posedge clk) begin
    start_regNext <= start;
    if(OutRow_Cnt_valid) begin
      if(OutCol_Cnt_valid) begin
        OutCol_Cnt_count <= Matrix_Col;
      end else begin
        OutCol_Cnt_count <= (OutCol_Cnt_count - _zz_OutCol_Cnt_count_1);
      end
    end
    if(when_SA3D_WeightCache_l114) begin
      OutCol_Cnt_count <= Matrix_Col;
    end
    MatrixCol_Switch_1_regNext <= MatrixCol_Switch_1;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= WEIGHT_CACHE_STATUS_IDLE;
      Init_Count_count <= 3'b000;
      InData_Switch <= 8'h01;
      In_Row_Cnt_count <= 16'h0;
      In_Col_Cnt_count <= 16'h0;
      Read_Row_Base_Addr <= 18'h0;
      Write_Row_Base_Addr <= 15'h0;
      OutRow_Cnt_count <= 16'h0;
      Col_In_8_Cnt_count <= 3'b000;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(sData_fire) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 16'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 16'h0001);
        end
      end
      if(In_Row_Cnt_valid) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= 16'h0;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count + 16'h0001);
        end
      end
      if(when_WaCounter_l40) begin
        if(OutRow_Cnt_valid) begin
          OutRow_Cnt_count <= 16'h0;
        end else begin
          OutRow_Cnt_count <= (OutRow_Cnt_count + 16'h0001);
        end
      end
      if(In_Row_Cnt_valid) begin
        if(Col_In_8_Cnt_valid) begin
          Col_In_8_Cnt_count <= 3'b000;
        end else begin
          Col_In_8_Cnt_count <= (Col_In_8_Cnt_count + 3'b001);
        end
      end
      if(OutCol_Cnt_valid) begin
        Col_In_8_Cnt_count <= 3'b000;
        Read_Row_Base_Addr <= 18'h0;
      end else begin
        if(OutRow_Cnt_valid) begin
          Read_Row_Base_Addr <= (Read_Row_Base_Addr + _zz_Read_Row_Base_Addr);
        end
      end
      if(when_SA3D_WeightCache_l133) begin
        InData_Switch <= 8'h01;
      end else begin
        if(In_Row_Cnt_valid) begin
          InData_Switch <= {InData_Switch[6 : 0],InData_Switch[7 : 7]};
        end
      end
      if(when_SA3D_WeightCache_l138) begin
        Write_Row_Base_Addr <= 15'h0;
      end else begin
        if(Col_In_8_Cnt_valid) begin
          Write_Row_Base_Addr <= (Write_Row_Base_Addr + _zz_Write_Row_Base_Addr);
        end
      end
    end
  end


endmodule

//PE_63 replaced by PE

//PE_62 replaced by PE

//PE_61 replaced by PE

//PE_60 replaced by PE

//PE_59 replaced by PE

//PE_58 replaced by PE

//PE_57 replaced by PE

//PE_56 replaced by PE

//PE_55 replaced by PE

//PE_54 replaced by PE

//PE_53 replaced by PE

//PE_52 replaced by PE

//PE_51 replaced by PE

//PE_50 replaced by PE

//PE_49 replaced by PE

//PE_48 replaced by PE

//PE_47 replaced by PE

//PE_46 replaced by PE

//PE_45 replaced by PE

//PE_44 replaced by PE

//PE_43 replaced by PE

//PE_42 replaced by PE

//PE_41 replaced by PE

//PE_40 replaced by PE

//PE_39 replaced by PE

//PE_38 replaced by PE

//PE_37 replaced by PE

//PE_36 replaced by PE

//PE_35 replaced by PE

//PE_34 replaced by PE

//PE_33 replaced by PE

//PE_32 replaced by PE

//PE_31 replaced by PE

//PE_30 replaced by PE

//PE_29 replaced by PE

//PE_28 replaced by PE

//PE_27 replaced by PE

//PE_26 replaced by PE

//PE_25 replaced by PE

//PE_24 replaced by PE

//PE_23 replaced by PE

//PE_22 replaced by PE

//PE_21 replaced by PE

//PE_20 replaced by PE

//PE_19 replaced by PE

//PE_18 replaced by PE

//PE_17 replaced by PE

//PE_16 replaced by PE

//PE_15 replaced by PE

//PE_14 replaced by PE

//PE_13 replaced by PE

//PE_12 replaced by PE

//PE_11 replaced by PE

//PE_10 replaced by PE

//PE_9 replaced by PE

//PE_8 replaced by PE

//PE_7 replaced by PE

//PE_6 replaced by PE

//PE_5 replaced by PE

//PE_4 replaced by PE

//PE_3 replaced by PE

//PE_2 replaced by PE

//PE_1 replaced by PE

module PE (
  input      [7:0]    activate,
  input      [7:0]    weight,
  input               valid,
  input      [15:0]   signCount,
  output     [7:0]    acount,
  output     [7:0]    bcount,
  output reg [31:0]   PE_OUT,
  output              finish,
  input               clk,
  input               reset
);

  wire       [8:0]    dsp_A;
  wire       [16:0]   dsp_P;
  wire       [31:0]   _zz_reg1;
  wire       [31:0]   _zz_reg1_1;
  wire       [31:0]   _zz_reg1_2;
  wire       [0:0]    _zz_A;
  reg        [31:0]   reg1;
  reg                 valid_regNext;
  reg                 valid_regNext_regNext;
  reg        [15:0]   finishCnt_count;
  wire                finishCnt_valid;
  reg                 valid_regNext_1;
  reg        [7:0]    activate_regNext;
  reg        [7:0]    weight_regNext;

  assign _zz_reg1 = {{15{dsp_P[16]}}, dsp_P};
  assign _zz_reg1_1 = 32'h0;
  assign _zz_reg1_2 = {{15{dsp_P[16]}}, dsp_P};
  assign _zz_A = 1'b0;
  dsp_marco dsp (
    .CLK (clk        ), //i
    .A   (dsp_A[8:0] ), //i
    .B   (weight[7:0]), //i
    .P   (dsp_P[16:0])  //o
  );
  assign finishCnt_valid = ((finishCnt_count == signCount) && valid_regNext_regNext);
  assign finish = finishCnt_valid;
  always @(*) begin
    PE_OUT = 32'h0;
    if(finishCnt_valid) begin
      PE_OUT = reg1;
    end
  end

  assign dsp_A = {_zz_A,activate};
  assign acount = activate_regNext;
  assign bcount = weight_regNext;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      reg1 <= 32'h0;
      finishCnt_count <= 16'h0;
    end else begin
      if(valid_regNext_regNext) begin
        if(finishCnt_valid) begin
          finishCnt_count <= 16'h0;
        end else begin
          finishCnt_count <= (finishCnt_count + 16'h0001);
        end
      end
      if(finishCnt_valid) begin
        reg1 <= (valid ? _zz_reg1 : _zz_reg1_1);
      end else begin
        if(valid_regNext_1) begin
          reg1 <= ($signed(_zz_reg1_2) + $signed(reg1));
        end
      end
    end
  end

  always @(posedge clk) begin
    valid_regNext <= valid;
    valid_regNext_regNext <= valid_regNext;
    valid_regNext_1 <= valid;
    activate_regNext <= activate;
    weight_regNext <= weight;
  end


endmodule

module Sum_Xq_7 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_7_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_7_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_7_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_7_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_7_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_6 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_6_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_6_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_6_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_6_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_6_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_5 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_5_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_5_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_5_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_5_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_5_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_4 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_4_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_4_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_4_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_4_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_4_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_3 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_3_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_3_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_3_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_3_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_3_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_2 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_2_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_2_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_2_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_2_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_2_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_1 (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_1_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_1_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_1_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_1_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_1_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq (
  input               sData_valid,
  output              sData_ready,
  input      [18:0]   sData_payload,
  input               start,
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  output     [9:0]    Scale_Read_Addr,
  input      [7:0]    Scale_1,
  input      [7:0]    Bias_1,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [28:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [28:0]   _zz_Row_Mem_port0;
  wire       [28:0]   XqC_Module_P;
  wire       [47:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [9:0]    _zz_Col_Cnt_valid;
  wire       [19:0]   _zz_Row_Cnt_valid;
  wire       [28:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Shifted;
  wire       [63:0]   _zz_SAB_Add_Bias;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l135;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l40;
  reg        [2:0]    Init_Count_count;
  wire                Init_Count_valid;
  wire                when_WaCounter_l40_1;
  reg        [9:0]    Col_Cnt_count;
  wire                Col_Cnt_valid;
  wire                when_WaCounter_l40_2;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [28:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [28:0]   Write_Row_Mem_Data;
  reg        [9:0]    Col_Cnt_count_delay_1;
  reg        [9:0]    Col_Cnt_count_delay_2;
  reg        [9:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                when_SumXq_Stage1_l352;
  wire                sData_fire_3;
  reg        [18:0]   sData_payload_delay_1;
  reg        [18:0]   sData_payload_delay_2;
  reg        [18:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  wire                when_SumXq_Stage1_l372;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_0_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_0_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [28:0] Row_Mem [0:1023];

  assign _zz_Col_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00002);
  assign _zz_Xq_Sum = {{1{sData_payload[18]}}, sData_payload};
  assign _zz_XqC_Substract_M2 = {{3{Read_Row_Mem_Data[28]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Shifted = ScaleA_Mul_ReSqrt_P;
  assign _zz_SAB_Add_Bias = {{56{Bias_1[7]}}, Bias_1};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[18:0]), //i
    .B   (Channel_Nums[9:0]  ), //i
    .P   (XqC_Module_P[28:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[28:0]        ), //i
    .B   (sData_payload_delay_3[18:0]), //i
    .P   (Xq2C_Module_P[47:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale_1[7:0]          ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l135 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l135) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l40 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign Init_Count_valid = ((Init_Count_count == 3'b101) && when_WaCounter_l40);
  assign when_WaCounter_l40_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Col_Cnt_valid = ((Col_Cnt_count == _zz_Col_Cnt_valid) && when_WaCounter_l40_1);
  assign when_WaCounter_l40_2 = (Col_Cnt_valid && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000));
  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && when_WaCounter_l40_2);
  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 20'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign when_SumXq_Stage1_l352 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign when_SumXq_Stage1_l372 = ((Fsm_currentState & SUM_XQ_ENUM_IDLE) != 5'b00000);
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_0_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_0_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_0_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = ($signed(_zz_SAB_Shifted) >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(SAB_Shifted) + $signed(_zz_SAB_Add_Bias));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 10'h0;
      Row_Cnt_count <= 20'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l40) begin
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end else begin
          Init_Count_count <= (Init_Count_count + 3'b001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 10'h0;
        end else begin
          Col_Cnt_count <= (Col_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
      if(when_SumXq_Stage1_l352) begin
        Xq_Sum <= 20'h0;
      end else begin
        if(sData_fire_3) begin
          if(Xq_Sum_Clear) begin
            Xq_Sum <= {{1{sData_payload[18]}}, sData_payload};
          end else begin
            Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
          end
        end
      end
      if(when_SumXq_Stage1_l372) begin
        Xq2C_Sum <= 48'h0;
      end else begin
        if(Xq2C_Valid) begin
          if(Xq2C_Sum_Clear) begin
            Xq2C_Sum <= Xq2C_Module_P;
          end else begin
            Xq2C_Sum <= (Xq2C_Sum + Xq2C_Module_P);
          end
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Reci_Sqrt_Compute (
  input      [9:0]    Channel_Nums,
  input      [19:0]   Token_Nums,
  input               Sqrt_In_Valid_0,
  input               Sqrt_In_Valid_1,
  input               Sqrt_In_Valid_2,
  input               Sqrt_In_Valid_3,
  input               Sqrt_In_Valid_4,
  input               Sqrt_In_Valid_5,
  input               Sqrt_In_Valid_6,
  input               Sqrt_In_Valid_7,
  input      [31:0]   Sqrt_In_Truncated_0,
  input      [31:0]   Sqrt_In_Truncated_1,
  input      [31:0]   Sqrt_In_Truncated_2,
  input      [31:0]   Sqrt_In_Truncated_3,
  input      [31:0]   Sqrt_In_Truncated_4,
  input      [31:0]   Sqrt_In_Truncated_5,
  input      [31:0]   Sqrt_In_Truncated_6,
  input      [31:0]   Sqrt_In_Truncated_7,
  input               ScaleA_Fifo_Popfire,
  output     [31:0]   Recipro_Sqrt_Result_Latch_0,
  output     [31:0]   Recipro_Sqrt_Result_Latch_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_2,
  output     [31:0]   Recipro_Sqrt_Result_Latch_3,
  output     [31:0]   Recipro_Sqrt_Result_Latch_4,
  output     [31:0]   Recipro_Sqrt_Result_Latch_5,
  output     [31:0]   Recipro_Sqrt_Result_Latch_6,
  output     [31:0]   Recipro_Sqrt_Result_Latch_7,
  output              Recipro_Sqrt_Result_Valid,
  output     [9:0]    Bias_Read_Addr,
  output              mLast,
  input               clk,
  output     [31:0]   Recipro_Sqrt_Result_Latch_0_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_1_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_2_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_3_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_4_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_5_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_6_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_7_1,
  input               reset
);
  localparam SQRT_COMPUTE_ENUM_COMPUTE_0 = 9'd1;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_1 = 9'd2;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_2 = 9'd4;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_3 = 9'd8;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_4 = 9'd16;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_5 = 9'd32;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_6 = 9'd64;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_7 = 9'd128;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_8 = 9'd256;
  localparam SCALEA_MUL_RESQRT_ENUM_IDLE = 3'd1;
  localparam SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID = 3'd2;
  localparam SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN = 3'd4;

  reg                 Fi32_2_Single_s_axis_a_tvalid;
  wire                Fi32_2_Single_s_axis_a_tready;
  wire       [31:0]   Fi32_2_Single_m_axis_result_tdata;
  wire                Fi32_2_Single_m_axis_result_tvalid;
  wire                Reci_Sqrt_s_axis_a_tready;
  wire       [31:0]   Reci_Sqrt_m_axis_result_tdata;
  wire                Reci_Sqrt_m_axis_result_tvalid;
  wire       [9:0]    _zz_SAB_Cnt_valid;
  wire       [9:0]    _zz_when;
  wire       [19:0]   _zz_Row_Cnt_valid;
  reg        [8:0]    Sqrt_Compute_Fsm_currentState;
  reg        [8:0]    Sqrt_Compute_Fsm_nextState;
  wire                Sqrt_Compute_Fsm_Data_Sended;
  wire                Sqrt_Compute_Fsm_Send_Data_0;
  wire                Sqrt_Compute_Fsm_Send_Data_1;
  wire                Sqrt_Compute_Fsm_Send_Data_2;
  wire                Sqrt_Compute_Fsm_Send_Data_3;
  wire                Sqrt_Compute_Fsm_Send_Data_4;
  wire                Sqrt_Compute_Fsm_Send_Data_5;
  wire                Sqrt_Compute_Fsm_Send_Data_6;
  wire                Sqrt_Compute_Fsm_Send_Data_7;
  wire                Sqrt_Compute_Fsm_Send_Data_8;
  reg        [2:0]    Recipro_Pointer_Result_count;
  wire                Recipro_Pointer_Result_valid;
  reg        [2:0]    SAB_Fsm_currentState;
  reg        [2:0]    SAB_Fsm_nextState;
  wire                SAB_Fsm_ScaleA_Mul_ReSqrt_End;
  wire                SAB_Fsm_Row_All_Computed;
  wire                when_SumXq_Stage1_l231;
  reg        [9:0]    SAB_Cnt_count;
  wire                SAB_Cnt_valid;
  wire                when_WaCounter_l40;
  reg        [9:0]    _zz_Bias_Read_Addr;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_0_1_regNext;
  reg                 SAB_Cnt_valid_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_0_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_1_1_regNext;
  reg                 SAB_Cnt_valid_regNext_1;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_1_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_2_1_regNext;
  reg                 SAB_Cnt_valid_regNext_2;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_2_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_3_1_regNext;
  reg                 SAB_Cnt_valid_regNext_3;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_3_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_4_1_regNext;
  reg                 SAB_Cnt_valid_regNext_4;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_4_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_5_1_regNext;
  reg                 SAB_Cnt_valid_regNext_5;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_5_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_6_1_regNext;
  reg                 SAB_Cnt_valid_regNext_6;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_6_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_7_1_regNext;
  reg                 SAB_Cnt_valid_regNext_7;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_7_regNext;
  wire                when_WaCounter_l40_1;
  reg        [2:0]    Recipro_Pointer_DataIn_count;
  wire                Recipro_Pointer_DataIn_valid;
  reg        [31:0]   _zz_s_axis_a_tdata;
  reg        [19:0]   Row_Cnt_count;
  wire                Row_Cnt_valid;
  `ifndef SYNTHESIS
  reg [71:0] Sqrt_Compute_Fsm_currentState_string;
  reg [71:0] Sqrt_Compute_Fsm_nextState_string;
  reg [143:0] SAB_Fsm_currentState_string;
  reg [143:0] SAB_Fsm_nextState_string;
  `endif


  assign _zz_SAB_Cnt_valid = (Channel_Nums - 10'h001);
  assign _zz_when = (Channel_Nums - 10'h001);
  assign _zz_Row_Cnt_valid = (Token_Nums - 20'h00001);
  Fi32_to_Single Fi32_2_Single (
    .s_axis_a_tdata       (_zz_s_axis_a_tdata[31:0]               ), //i
    .s_axis_a_tready      (Fi32_2_Single_s_axis_a_tready          ), //o
    .s_axis_a_tvalid      (Fi32_2_Single_s_axis_a_tvalid          ), //i
    .aclk                 (clk                                    ), //i
    .m_axis_result_tdata  (Fi32_2_Single_m_axis_result_tdata[31:0]), //o
    .m_axis_result_tready (Reci_Sqrt_s_axis_a_tready              ), //i
    .m_axis_result_tvalid (Fi32_2_Single_m_axis_result_tvalid     )  //o
  );
  Reciprocal_Sqrt Reci_Sqrt (
    .s_axis_a_tdata       (Fi32_2_Single_m_axis_result_tdata[31:0]), //i
    .s_axis_a_tready      (Reci_Sqrt_s_axis_a_tready              ), //o
    .s_axis_a_tvalid      (Fi32_2_Single_m_axis_result_tvalid     ), //i
    .aclk                 (clk                                    ), //i
    .m_axis_result_tdata  (Reci_Sqrt_m_axis_result_tdata[31:0]    ), //o
    .m_axis_result_tready (1'b1                                   ), //i
    .m_axis_result_tvalid (Reci_Sqrt_m_axis_result_tvalid         )  //o
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Sqrt_Compute_Fsm_currentState)
      SQRT_COMPUTE_ENUM_COMPUTE_0 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_0";
      SQRT_COMPUTE_ENUM_COMPUTE_1 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_1";
      SQRT_COMPUTE_ENUM_COMPUTE_2 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_2";
      SQRT_COMPUTE_ENUM_COMPUTE_3 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_3";
      SQRT_COMPUTE_ENUM_COMPUTE_4 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_4";
      SQRT_COMPUTE_ENUM_COMPUTE_5 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_5";
      SQRT_COMPUTE_ENUM_COMPUTE_6 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_6";
      SQRT_COMPUTE_ENUM_COMPUTE_7 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_7";
      SQRT_COMPUTE_ENUM_COMPUTE_8 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_8";
      default : Sqrt_Compute_Fsm_currentState_string = "?????????";
    endcase
  end
  always @(*) begin
    case(Sqrt_Compute_Fsm_nextState)
      SQRT_COMPUTE_ENUM_COMPUTE_0 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_0";
      SQRT_COMPUTE_ENUM_COMPUTE_1 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_1";
      SQRT_COMPUTE_ENUM_COMPUTE_2 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_2";
      SQRT_COMPUTE_ENUM_COMPUTE_3 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_3";
      SQRT_COMPUTE_ENUM_COMPUTE_4 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_4";
      SQRT_COMPUTE_ENUM_COMPUTE_5 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_5";
      SQRT_COMPUTE_ENUM_COMPUTE_6 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_6";
      SQRT_COMPUTE_ENUM_COMPUTE_7 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_7";
      SQRT_COMPUTE_ENUM_COMPUTE_8 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_8";
      default : Sqrt_Compute_Fsm_nextState_string = "?????????";
    endcase
  end
  always @(*) begin
    case(SAB_Fsm_currentState)
      SCALEA_MUL_RESQRT_ENUM_IDLE : SAB_Fsm_currentState_string = "IDLE              ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID : SAB_Fsm_currentState_string = "RESQRT_VALID      ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN : SAB_Fsm_currentState_string = "RESQRT_VALID_AGAIN";
      default : SAB_Fsm_currentState_string = "??????????????????";
    endcase
  end
  always @(*) begin
    case(SAB_Fsm_nextState)
      SCALEA_MUL_RESQRT_ENUM_IDLE : SAB_Fsm_nextState_string = "IDLE              ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID : SAB_Fsm_nextState_string = "RESQRT_VALID      ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN : SAB_Fsm_nextState_string = "RESQRT_VALID_AGAIN";
      default : SAB_Fsm_nextState_string = "??????????????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_0) == SQRT_COMPUTE_ENUM_COMPUTE_0) : begin
        if(Sqrt_Compute_Fsm_Send_Data_0) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_1;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_0;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_1) == SQRT_COMPUTE_ENUM_COMPUTE_1) : begin
        if(Sqrt_Compute_Fsm_Send_Data_1) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_2;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_1;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_2) == SQRT_COMPUTE_ENUM_COMPUTE_2) : begin
        if(Sqrt_Compute_Fsm_Send_Data_2) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_3;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_2;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_3) == SQRT_COMPUTE_ENUM_COMPUTE_3) : begin
        if(Sqrt_Compute_Fsm_Send_Data_3) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_4;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_3;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_4) == SQRT_COMPUTE_ENUM_COMPUTE_4) : begin
        if(Sqrt_Compute_Fsm_Send_Data_4) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_5;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_4;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_5) == SQRT_COMPUTE_ENUM_COMPUTE_5) : begin
        if(Sqrt_Compute_Fsm_Send_Data_5) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_6;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_5;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_6) == SQRT_COMPUTE_ENUM_COMPUTE_6) : begin
        if(Sqrt_Compute_Fsm_Send_Data_6) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_7;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_6;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_7) == SQRT_COMPUTE_ENUM_COMPUTE_7) : begin
        if(Sqrt_Compute_Fsm_Send_Data_7) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_8;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_7;
        end
      end
      default : begin
        if(Sqrt_Compute_Fsm_Send_Data_8) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_0;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_8;
        end
      end
    endcase
  end

  assign Sqrt_Compute_Fsm_Send_Data_0 = (Sqrt_In_Valid_0 && Fi32_2_Single_s_axis_a_tready);
  assign Sqrt_Compute_Fsm_Send_Data_1 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_2 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_3 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_4 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_5 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_6 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_7 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_8 = Fi32_2_Single_s_axis_a_tready;
  assign Recipro_Pointer_Result_valid = ((Recipro_Pointer_Result_count == 3'b111) && Reci_Sqrt_m_axis_result_tvalid);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((SAB_Fsm_currentState) & SCALEA_MUL_RESQRT_ENUM_IDLE) == SCALEA_MUL_RESQRT_ENUM_IDLE) : begin
        if(Recipro_Pointer_Result_valid) begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
        end else begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
        end
      end
      (((SAB_Fsm_currentState) & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) == SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) : begin
        if(SAB_Fsm_Row_All_Computed) begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
        end else begin
          if(when_SumXq_Stage1_l231) begin
            SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
          end else begin
            if(Recipro_Pointer_Result_valid) begin
              SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN;
            end else begin
              if(SAB_Fsm_ScaleA_Mul_ReSqrt_End) begin
                SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
              end else begin
                SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
              end
            end
          end
        end
      end
      default : begin
        if(SAB_Fsm_Row_All_Computed) begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
        end else begin
          if(SAB_Fsm_ScaleA_Mul_ReSqrt_End) begin
            SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
          end else begin
            SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN;
          end
        end
      end
    endcase
  end

  assign when_SumXq_Stage1_l231 = (Recipro_Pointer_Result_valid && SAB_Fsm_ScaleA_Mul_ReSqrt_End);
  assign SAB_Cnt_valid = ((SAB_Cnt_count == _zz_SAB_Cnt_valid) && ScaleA_Fifo_Popfire);
  assign SAB_Fsm_ScaleA_Mul_ReSqrt_End = SAB_Cnt_valid;
  assign Recipro_Sqrt_Result_Valid = (((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN) != 3'b000));
  assign when_WaCounter_l40 = ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000);
  assign Bias_Read_Addr = _zz_Bias_Read_Addr;
  assign Recipro_Sqrt_Result_Latch_0_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b000)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_0_1_regNext);
  assign Recipro_Sqrt_Result_Latch_0 = (((SAB_Cnt_valid_regNext && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_0_1 : Recipro_Sqrt_Result_Latch_0_regNext);
  assign Recipro_Sqrt_Result_Latch_1_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b001)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_1_1_regNext);
  assign Recipro_Sqrt_Result_Latch_1 = (((SAB_Cnt_valid_regNext_1 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_1_1 : Recipro_Sqrt_Result_Latch_1_regNext);
  assign Recipro_Sqrt_Result_Latch_2_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b010)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_2_1_regNext);
  assign Recipro_Sqrt_Result_Latch_2 = (((SAB_Cnt_valid_regNext_2 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_2_1 : Recipro_Sqrt_Result_Latch_2_regNext);
  assign Recipro_Sqrt_Result_Latch_3_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b011)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_3_1_regNext);
  assign Recipro_Sqrt_Result_Latch_3 = (((SAB_Cnt_valid_regNext_3 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_3_1 : Recipro_Sqrt_Result_Latch_3_regNext);
  assign Recipro_Sqrt_Result_Latch_4_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b100)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_4_1_regNext);
  assign Recipro_Sqrt_Result_Latch_4 = (((SAB_Cnt_valid_regNext_4 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_4_1 : Recipro_Sqrt_Result_Latch_4_regNext);
  assign Recipro_Sqrt_Result_Latch_5_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b101)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_5_1_regNext);
  assign Recipro_Sqrt_Result_Latch_5 = (((SAB_Cnt_valid_regNext_5 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_5_1 : Recipro_Sqrt_Result_Latch_5_regNext);
  assign Recipro_Sqrt_Result_Latch_6_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b110)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_6_1_regNext);
  assign Recipro_Sqrt_Result_Latch_6 = (((SAB_Cnt_valid_regNext_6 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_6_1 : Recipro_Sqrt_Result_Latch_6_regNext);
  assign Recipro_Sqrt_Result_Latch_7_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b111)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_7_1_regNext);
  assign Recipro_Sqrt_Result_Latch_7 = (((SAB_Cnt_valid_regNext_7 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_7_1 : Recipro_Sqrt_Result_Latch_7_regNext);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_1) == SQRT_COMPUTE_ENUM_COMPUTE_1) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_2) == SQRT_COMPUTE_ENUM_COMPUTE_2) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_3) == SQRT_COMPUTE_ENUM_COMPUTE_3) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_4) == SQRT_COMPUTE_ENUM_COMPUTE_4) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_5) == SQRT_COMPUTE_ENUM_COMPUTE_5) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_6) == SQRT_COMPUTE_ENUM_COMPUTE_6) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_7) == SQRT_COMPUTE_ENUM_COMPUTE_7) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_8) == SQRT_COMPUTE_ENUM_COMPUTE_8) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      default : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b0;
      end
    endcase
  end

  assign when_WaCounter_l40_1 = (Fi32_2_Single_s_axis_a_tvalid && Fi32_2_Single_s_axis_a_tready);
  assign Recipro_Pointer_DataIn_valid = ((Recipro_Pointer_DataIn_count == 3'b111) && when_WaCounter_l40_1);
  always @(*) begin
    case(Recipro_Pointer_DataIn_count)
      3'b000 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_0;
      end
      3'b001 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_1;
      end
      3'b010 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_2;
      end
      3'b011 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_3;
      end
      3'b100 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_4;
      end
      3'b101 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_5;
      end
      3'b110 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_6;
      end
      default : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_7;
      end
    endcase
  end

  assign Row_Cnt_valid = ((Row_Cnt_count == _zz_Row_Cnt_valid) && SAB_Cnt_valid);
  assign SAB_Fsm_Row_All_Computed = (Row_Cnt_valid && SAB_Cnt_valid);
  assign mLast = SAB_Fsm_Row_All_Computed;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Sqrt_Compute_Fsm_currentState <= SQRT_COMPUTE_ENUM_COMPUTE_0;
      Recipro_Pointer_Result_count <= 3'b000;
      SAB_Fsm_currentState <= SCALEA_MUL_RESQRT_ENUM_IDLE;
      SAB_Cnt_count <= 10'h0;
      _zz_Bias_Read_Addr <= 10'h0;
      Recipro_Pointer_DataIn_count <= 3'b000;
      Row_Cnt_count <= 20'h0;
    end else begin
      Sqrt_Compute_Fsm_currentState <= Sqrt_Compute_Fsm_nextState;
      if(Reci_Sqrt_m_axis_result_tvalid) begin
        if(Recipro_Pointer_Result_valid) begin
          Recipro_Pointer_Result_count <= 3'b000;
        end else begin
          Recipro_Pointer_Result_count <= (Recipro_Pointer_Result_count + 3'b001);
        end
      end
      SAB_Fsm_currentState <= SAB_Fsm_nextState;
      if(ScaleA_Fifo_Popfire) begin
        if(SAB_Cnt_valid) begin
          SAB_Cnt_count <= 10'h0;
        end else begin
          SAB_Cnt_count <= (SAB_Cnt_count + 10'h001);
        end
      end
      if(when_WaCounter_l40) begin
        if(((_zz_Bias_Read_Addr == _zz_when) && when_WaCounter_l40)) begin
          _zz_Bias_Read_Addr <= 10'h0;
        end else begin
          _zz_Bias_Read_Addr <= (_zz_Bias_Read_Addr + 10'h001);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Recipro_Pointer_DataIn_valid) begin
          Recipro_Pointer_DataIn_count <= 3'b000;
        end else begin
          Recipro_Pointer_DataIn_count <= (Recipro_Pointer_DataIn_count + 3'b001);
        end
      end
      if(SAB_Cnt_valid) begin
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 20'h0;
        end else begin
          Row_Cnt_count <= (Row_Cnt_count + 20'h00001);
        end
      end
    end
  end

  always @(posedge clk) begin
    Recipro_Sqrt_Result_Latch_0_1_regNext <= Recipro_Sqrt_Result_Latch_0_1;
    SAB_Cnt_valid_regNext <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_0_regNext <= Recipro_Sqrt_Result_Latch_0;
    Recipro_Sqrt_Result_Latch_1_1_regNext <= Recipro_Sqrt_Result_Latch_1_1;
    SAB_Cnt_valid_regNext_1 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_1_regNext <= Recipro_Sqrt_Result_Latch_1;
    Recipro_Sqrt_Result_Latch_2_1_regNext <= Recipro_Sqrt_Result_Latch_2_1;
    SAB_Cnt_valid_regNext_2 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_2_regNext <= Recipro_Sqrt_Result_Latch_2;
    Recipro_Sqrt_Result_Latch_3_1_regNext <= Recipro_Sqrt_Result_Latch_3_1;
    SAB_Cnt_valid_regNext_3 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_3_regNext <= Recipro_Sqrt_Result_Latch_3;
    Recipro_Sqrt_Result_Latch_4_1_regNext <= Recipro_Sqrt_Result_Latch_4_1;
    SAB_Cnt_valid_regNext_4 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_4_regNext <= Recipro_Sqrt_Result_Latch_4;
    Recipro_Sqrt_Result_Latch_5_1_regNext <= Recipro_Sqrt_Result_Latch_5_1;
    SAB_Cnt_valid_regNext_5 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_5_regNext <= Recipro_Sqrt_Result_Latch_5;
    Recipro_Sqrt_Result_Latch_6_1_regNext <= Recipro_Sqrt_Result_Latch_6_1;
    SAB_Cnt_valid_regNext_6 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_6_regNext <= Recipro_Sqrt_Result_Latch_6;
    Recipro_Sqrt_Result_Latch_7_1_regNext <= Recipro_Sqrt_Result_Latch_7_1;
    SAB_Cnt_valid_regNext_7 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_7_regNext <= Recipro_Sqrt_Result_Latch_7;
  end


endmodule

module WaStreamFifo (
  input               push_valid,
  output              push_ready,
  input      [63:0]   push_payload,
  output              pop_valid,
  input               pop_ready,
  output     [63:0]   pop_payload,
  input               flush,
  output reg [2:0]    occupancy,
  output reg [2:0]    availability,
  output reg          almost_full,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [2:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [2:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [2:0]    _zz_occupancy;
  wire       [2:0]    _zz_availability;
  wire       [2:0]    _zz_availability_1;
  wire       [2:0]    _zz_availability_2;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [2:0]    logic_pushPtr_valueNext;
  reg        [2:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [2:0]    logic_popPtr_valueNext;
  reg        [2:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_pop_valid;
  wire                when_Stream_l1122;
  wire       [2:0]    logic_ptrDif;
  wire                when_WaFifo_l21;
  reg [63:0] logic_ram [0:4];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {2'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {2'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_occupancy = (3'b101 + logic_ptrDif);
  assign _zz_availability = (3'b101 + _zz_availability_1);
  assign _zz_availability_1 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_availability_2 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = push_payload;
  always @(posedge clk) begin
    if(_zz_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 3'b100);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    if(logic_pushPtr_willOverflow) begin
      logic_pushPtr_valueNext = 3'b000;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    end
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 3'b000;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 3'b100);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    if(logic_popPtr_willOverflow) begin
      logic_popPtr_valueNext = 3'b000;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    end
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 3'b000;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (push_valid && push_ready);
  assign logic_popping = (pop_valid && pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign push_ready = (! logic_full);
  assign pop_valid = ((! logic_empty) && (! (_zz_pop_valid && (! logic_full))));
  assign pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  always @(*) begin
    if(logic_ptrMatch) begin
      occupancy = (logic_risingOccupancy ? 3'b101 : 3'b000);
    end else begin
      occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_occupancy);
    end
  end

  always @(*) begin
    if(logic_ptrMatch) begin
      availability = (logic_risingOccupancy ? 3'b000 : 3'b101);
    end else begin
      availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_availability : _zz_availability_2);
    end
  end

  assign when_WaFifo_l21 = (availability <= 3'b001);
  always @(*) begin
    if(when_WaFifo_l21) begin
      almost_full = 1'b1;
    end else begin
      almost_full = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 3'b000;
      logic_popPtr_value <= 3'b000;
      logic_risingOccupancy <= 1'b0;
      _zz_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module Img2Col_OutPut (
  input               start,
  input               NewAddrIn_valid,
  output              NewAddrIn_ready,
  input      [15:0]   NewAddrIn_payload,
  output              SA_Idle,
  output     [15:0]   Raddr,
  output              Raddr_Valid,
  output              SA_End,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  input               mReady,
  input               Fifo_Clear,
  output reg          AddrReceived,
  input               LayerEnd,
  output              SA_Row_Cnt_Valid,
  input               clk,
  input               reset
);
  localparam IMG2COL_OUTPUT_ENUM_IDLE = 7'd1;
  localparam IMG2COL_OUTPUT_ENUM_INIT = 7'd2;
  localparam IMG2COL_OUTPUT_ENUM_INIT_ADDR = 7'd4;
  localparam IMG2COL_OUTPUT_ENUM_SA_COMPUTE = 7'd8;
  localparam IMG2COL_OUTPUT_ENUM_UPDATE_ADDR = 7'd16;
  localparam IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY = 7'd32;
  localparam IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR = 7'd64;

  reg                 RaddrFifo1_io_push_valid;
  reg        [15:0]   RaddrFifo1_io_push_payload;
  reg                 RaddrFifo1_io_pop_ready;
  wire                RaddrFifo1_io_flush;
  wire                RaddrFifo1_io_push_ready;
  wire                RaddrFifo1_io_pop_valid;
  wire       [15:0]   RaddrFifo1_io_pop_payload;
  wire       [5:0]    RaddrFifo1_io_occupancy;
  wire       [5:0]    RaddrFifo1_io_availability;
  wire       [4:0]    _zz_Raddr_Init_Cnt_valid;
  wire       [4:0]    _zz_Raddr_Update_Cnt_valid;
  wire       [12:0]   _zz_In_Channel_Process_Cnt_valid;
  wire       [12:0]   _zz_In_Channel_Process_Cnt_valid_1;
  wire       [15:0]   _zz_Window_Col_Cnt_valid;
  wire       [4:0]    _zz_Window_Col_Cnt_valid_1;
  wire       [15:0]   _zz_Window_Row_Cnt_valid;
  wire       [4:0]    _zz_Window_Row_Cnt_valid_1;
  wire       [15:0]   _zz_Out_Channel_Cnt_valid;
  wire       [15:0]   _zz_Out_Col_Cnt_valid;
  wire       [15:0]   _zz_when_Data_Generate_V2_l498;
  wire       [15:0]   _zz_when_Data_Generate_V2_l498_1;
  wire       [15:0]   _zz_WindowSize_Cnt_valid;
  wire       [15:0]   _zz_WindowSize_Cnt_valid_1;
  wire       [31:0]   _zz_Kernel_Base_Addr;
  wire       [15:0]   _zz_Kernel_Base_Addr_1;
  wire       [31:0]   _zz_Kernel_Addr;
  wire       [15:0]   _zz_Kernel_Addr_1;
  wire       [31:0]   _zz_Kernel_Addr_2;
  wire       [31:0]   _zz_Kernel_Addr_3;
  wire       [31:0]   _zz_Kernel_Addr_4;
  wire       [31:0]   _zz_Raddr;
  wire       [31:0]   _zz_Raddr_1;
  reg                 start_regNext;
  wire                when_Data_Generate_V2_l344;
  reg        [6:0]    Fsm_currentState;
  reg        [6:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Addr_Inited;
  wire                Fsm_SA_Computed;
  wire                Fsm_Addr_Updated;
  wire                Fsm_LayerEnd;
  wire                Fsm_NextReady;
  wire                Fsm_Fifo_Clear;
  wire                when_Data_Generate_V2_l376;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  reg        [15:0]   Row_Base_Addr;
  wire                Img2Col_SubModule_RaddrFifo1_io_pop_fire;
  wire                Img2Col_SubModule_RaddrFifo1_io_push_fire;
  wire                when_WaCounter_l40;
  reg        [4:0]    Raddr_Init_Cnt_count;
  wire                Raddr_Init_Cnt_valid;
  wire                Img2Col_SubModule_RaddrFifo1_io_push_fire_1;
  wire                when_WaCounter_l40_1;
  reg        [4:0]    Raddr_Update_Cnt_count;
  wire                Raddr_Update_Cnt_valid;
  wire                when_Data_Generate_V2_l463;
  wire                when_WaCounter_l40_2;
  reg        [2:0]    SA_Row_Cnt_count;
  reg                 SA_Row_Cnt_valid_1;
  reg        [12:0]   In_Channel_Process_Cnt_count;
  wire                In_Channel_Process_Cnt_valid;
  reg        [15:0]   Window_Col_Cnt_count;
  wire                Window_Col_Cnt_valid;
  reg        [15:0]   Window_Row_Cnt_count;
  wire                Window_Row_Cnt_valid;
  reg        [15:0]   Out_Channel_Cnt_count;
  wire                Out_Channel_Cnt_valid;
  reg        [15:0]   Out_Col_Cnt_count;
  wire                Out_Col_Cnt_valid;
  reg        [15:0]   OutFeature_Col_Lefted;
  wire                when_Data_Generate_V2_l495;
  wire                when_Data_Generate_V2_l498;
  reg        [12:0]   WindowSize_Cnt_count;
  wire                WindowSize_Cnt_valid;
  reg        [31:0]   Kernel_Addr;
  reg        [31:0]   Kernel_Base_Addr;
  wire                when_Data_Generate_V2_l523;
  wire                when_Data_Generate_V2_l533;
  wire                Img2Col_SubModule_RaddrFifo1_io_push_fire_2;
  wire                when_Data_Generate_V2_l537;
  wire       [6:0]    Debug_Fsm_currentState;
  wire       [0:0]    Debug_SA_Idle;
  wire       [0:0]    Debug_SA_End;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif


  assign _zz_Raddr_Init_Cnt_valid = (Kernel_Size - 5'h01);
  assign _zz_Raddr_Update_Cnt_valid = (Stride - 5'h01);
  assign _zz_In_Channel_Process_Cnt_valid = (_zz_In_Channel_Process_Cnt_valid_1 - 13'h0001);
  assign _zz_In_Channel_Process_Cnt_valid_1 = (InFeature_Channel >>> 3);
  assign _zz_Window_Col_Cnt_valid_1 = (Kernel_Size - 5'h01);
  assign _zz_Window_Col_Cnt_valid = {11'd0, _zz_Window_Col_Cnt_valid_1};
  assign _zz_Window_Row_Cnt_valid_1 = (Kernel_Size - 5'h01);
  assign _zz_Window_Row_Cnt_valid = {11'd0, _zz_Window_Row_Cnt_valid_1};
  assign _zz_Out_Channel_Cnt_valid = (OutFeature_Channel_Count_Times - 16'h0001);
  assign _zz_Out_Col_Cnt_valid = (OutCol_Count_Times - 16'h0001);
  assign _zz_when_Data_Generate_V2_l498 = {13'd0, SA_Row_Cnt_count};
  assign _zz_when_Data_Generate_V2_l498_1 = (OutFeature_Col_Lefted - 16'h0001);
  assign _zz_WindowSize_Cnt_valid = {3'd0, WindowSize_Cnt_count};
  assign _zz_WindowSize_Cnt_valid_1 = (Window_Size - 16'h0001);
  assign _zz_Kernel_Base_Addr_1 = ({3'd0,Sliding_Size} <<< 3);
  assign _zz_Kernel_Base_Addr = {16'd0, _zz_Kernel_Base_Addr_1};
  assign _zz_Kernel_Addr_1 = ({3'd0,Sliding_Size} <<< 3);
  assign _zz_Kernel_Addr = {16'd0, _zz_Kernel_Addr_1};
  assign _zz_Kernel_Addr_2 = (Kernel_Base_Addr + _zz_Kernel_Addr_3);
  assign _zz_Kernel_Addr_3 = {19'd0, WindowSize_Cnt_count};
  assign _zz_Kernel_Addr_4 = {19'd0, Sliding_Size};
  assign _zz_Raddr = (Kernel_Addr + _zz_Raddr_1);
  assign _zz_Raddr_1 = {16'd0, Row_Base_Addr};
  WaddrOffset_Fifo_2 RaddrFifo1 (
    .io_push_valid   (RaddrFifo1_io_push_valid        ), //i
    .io_push_ready   (RaddrFifo1_io_push_ready        ), //o
    .io_push_payload (RaddrFifo1_io_push_payload[15:0]), //i
    .io_pop_valid    (RaddrFifo1_io_pop_valid         ), //o
    .io_pop_ready    (RaddrFifo1_io_pop_ready         ), //i
    .io_pop_payload  (RaddrFifo1_io_pop_payload[15:0] ), //o
    .io_flush        (RaddrFifo1_io_flush             ), //i
    .io_occupancy    (RaddrFifo1_io_occupancy[5:0]    ), //o
    .io_availability (RaddrFifo1_io_availability[5:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  ila_Img2Col xil_ila (
    .probe0 (Debug_Fsm_currentState[6:0]), //i
    .probe1 (Debug_SA_Idle              ), //i
    .probe2 (Debug_SA_End               ), //i
    .clk    (clk                        )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      IMG2COL_OUTPUT_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      IMG2COL_OUTPUT_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      IMG2COL_OUTPUT_ENUM_INIT_ADDR : Fsm_currentState_string = "INIT_ADDR      ";
      IMG2COL_OUTPUT_ENUM_SA_COMPUTE : Fsm_currentState_string = "SA_COMPUTE     ";
      IMG2COL_OUTPUT_ENUM_UPDATE_ADDR : Fsm_currentState_string = "UPDATE_ADDR    ";
      IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY : Fsm_currentState_string = "WAIT_NEXT_READY";
      IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR : Fsm_currentState_string = "WAIT_FIFO_CLEAR";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      IMG2COL_OUTPUT_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      IMG2COL_OUTPUT_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      IMG2COL_OUTPUT_ENUM_INIT_ADDR : Fsm_nextState_string = "INIT_ADDR      ";
      IMG2COL_OUTPUT_ENUM_SA_COMPUTE : Fsm_nextState_string = "SA_COMPUTE     ";
      IMG2COL_OUTPUT_ENUM_UPDATE_ADDR : Fsm_nextState_string = "UPDATE_ADDR    ";
      IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY : Fsm_nextState_string = "WAIT_NEXT_READY";
      IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR : Fsm_nextState_string = "WAIT_FIFO_CLEAR";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_Data_Generate_V2_l344 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_IDLE) == IMG2COL_OUTPUT_ENUM_IDLE) : begin
        if(when_Data_Generate_V2_l344) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_INIT) == IMG2COL_OUTPUT_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_INIT_ADDR) == IMG2COL_OUTPUT_ENUM_INIT_ADDR) : begin
        if(Fsm_Addr_Inited) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT_ADDR;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) == IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) : begin
        if(Fsm_NextReady) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_SA_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) == IMG2COL_OUTPUT_ENUM_SA_COMPUTE) : begin
        if(Fsm_LayerEnd) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_IDLE;
        end else begin
          if(Fsm_SA_Computed) begin
            Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR;
          end else begin
            if(when_Data_Generate_V2_l376) begin
              Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
            end else begin
              Fsm_nextState = IMG2COL_OUTPUT_ENUM_SA_COMPUTE;
            end
          end
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR) == IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR) : begin
        if(Fsm_Fifo_Clear) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_UPDATE_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR;
        end
      end
      default : begin
        if(Fsm_Addr_Updated) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_UPDATE_ADDR;
        end
      end
    endcase
  end

  assign when_Data_Generate_V2_l376 = (! Fsm_NextReady);
  assign when_WaCounter_l19 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT) != 7'b0000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Fifo_Clear = Fifo_Clear;
  assign NewAddrIn_ready = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) || ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000));
  always @(*) begin
    RaddrFifo1_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l533) begin
      RaddrFifo1_io_push_valid = NewAddrIn_valid;
    end else begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_push_valid = NewAddrIn_valid;
      end else begin
        RaddrFifo1_io_push_valid = Window_Col_Cnt_valid;
      end
    end
  end

  always @(*) begin
    RaddrFifo1_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l463) begin
      RaddrFifo1_io_pop_ready = 1'b1;
    end
    if(!when_Data_Generate_V2_l533) begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_pop_ready = Img2Col_SubModule_RaddrFifo1_io_push_fire_2;
      end
    end
    if(Window_Col_Cnt_valid) begin
      RaddrFifo1_io_pop_ready = 1'b1;
    end
  end

  assign Img2Col_SubModule_RaddrFifo1_io_pop_fire = (RaddrFifo1_io_pop_valid && RaddrFifo1_io_pop_ready);
  assign Img2Col_SubModule_RaddrFifo1_io_push_fire = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_WaCounter_l40 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) && Img2Col_SubModule_RaddrFifo1_io_push_fire);
  assign Raddr_Init_Cnt_valid = ((Raddr_Init_Cnt_count == _zz_Raddr_Init_Cnt_valid) && when_WaCounter_l40);
  assign Fsm_Addr_Inited = Raddr_Init_Cnt_valid;
  assign Img2Col_SubModule_RaddrFifo1_io_push_fire_1 = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_WaCounter_l40_1 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000) && Img2Col_SubModule_RaddrFifo1_io_push_fire_1);
  assign Raddr_Update_Cnt_valid = ((Raddr_Update_Cnt_count == _zz_Raddr_Update_Cnt_valid) && when_WaCounter_l40_1);
  assign Fsm_Addr_Updated = Raddr_Update_Cnt_valid;
  assign Fsm_NextReady = mReady;
  always @(*) begin
    AddrReceived = 1'b0;
    if(when_Data_Generate_V2_l463) begin
      AddrReceived = 1'b1;
    end
  end

  assign when_Data_Generate_V2_l463 = ((((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) != 7'b0000000)) || (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) != 7'b0000000)));
  assign when_WaCounter_l40_2 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  always @(*) begin
    SA_Row_Cnt_valid_1 = ((SA_Row_Cnt_count == 3'b111) && when_WaCounter_l40_2);
    if(when_Data_Generate_V2_l498) begin
      SA_Row_Cnt_valid_1 = 1'b1;
    end
  end

  assign SA_Row_Cnt_Valid = SA_Row_Cnt_valid_1;
  assign In_Channel_Process_Cnt_valid = ((In_Channel_Process_Cnt_count == _zz_In_Channel_Process_Cnt_valid) && SA_Row_Cnt_valid_1);
  assign Window_Col_Cnt_valid = ((Window_Col_Cnt_count == _zz_Window_Col_Cnt_valid) && In_Channel_Process_Cnt_valid);
  assign Window_Row_Cnt_valid = ((Window_Row_Cnt_count == _zz_Window_Row_Cnt_valid) && Window_Col_Cnt_valid);
  assign Out_Channel_Cnt_valid = ((Out_Channel_Cnt_count == _zz_Out_Channel_Cnt_valid) && Window_Row_Cnt_valid);
  assign Out_Col_Cnt_valid = ((Out_Col_Cnt_count == _zz_Out_Col_Cnt_valid) && Out_Channel_Cnt_valid);
  assign SA_End = Out_Col_Cnt_valid;
  assign when_Data_Generate_V2_l495 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT) != 7'b0000000);
  assign when_Data_Generate_V2_l498 = (((_zz_when_Data_Generate_V2_l498 == _zz_when_Data_Generate_V2_l498_1) && mReady) && ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000));
  assign WindowSize_Cnt_valid = ((_zz_WindowSize_Cnt_valid == _zz_WindowSize_Cnt_valid_1) && SA_Row_Cnt_valid_1);
  assign when_Data_Generate_V2_l523 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  assign Raddr = _zz_Raddr[15:0];
  assign Fsm_SA_Computed = Out_Col_Cnt_valid;
  assign SA_Idle = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_IDLE) != 7'b0000000) || ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000));
  assign when_Data_Generate_V2_l533 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000);
  always @(*) begin
    if(when_Data_Generate_V2_l533) begin
      RaddrFifo1_io_push_payload = NewAddrIn_payload;
    end else begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_push_payload = NewAddrIn_payload;
      end else begin
        RaddrFifo1_io_push_payload = Row_Base_Addr;
      end
    end
  end

  assign Img2Col_SubModule_RaddrFifo1_io_push_fire_2 = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_Data_Generate_V2_l537 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign Raddr_Valid = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  assign Fsm_LayerEnd = LayerEnd;
  assign RaddrFifo1_io_flush = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_IDLE) != 7'b0000000);
  assign Debug_Fsm_currentState = Fsm_currentState;
  assign Debug_SA_Idle = SA_Idle;
  assign Debug_SA_End = SA_End;
  always @(posedge clk) begin
    start_regNext <= start;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= IMG2COL_OUTPUT_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Row_Base_Addr <= 16'h0;
      Raddr_Init_Cnt_count <= 5'h0;
      Raddr_Update_Cnt_count <= 5'h0;
      SA_Row_Cnt_count <= 3'b000;
      In_Channel_Process_Cnt_count <= 13'h0;
      Window_Col_Cnt_count <= 16'h0;
      Window_Row_Cnt_count <= 16'h0;
      Out_Channel_Cnt_count <= 16'h0;
      Out_Col_Cnt_count <= 16'h0;
      OutFeature_Col_Lefted <= 16'h0;
      WindowSize_Cnt_count <= 13'h0;
      Kernel_Addr <= 32'h0;
      Kernel_Base_Addr <= 32'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(Img2Col_SubModule_RaddrFifo1_io_pop_fire) begin
        Row_Base_Addr <= RaddrFifo1_io_pop_payload;
      end
      if(when_WaCounter_l40) begin
        if(Raddr_Init_Cnt_valid) begin
          Raddr_Init_Cnt_count <= 5'h0;
        end else begin
          Raddr_Init_Cnt_count <= (Raddr_Init_Cnt_count + 5'h01);
        end
      end
      if(when_WaCounter_l40_1) begin
        if(Raddr_Update_Cnt_valid) begin
          Raddr_Update_Cnt_count <= 5'h0;
        end else begin
          Raddr_Update_Cnt_count <= (Raddr_Update_Cnt_count + 5'h01);
        end
      end
      if(when_WaCounter_l40_2) begin
        if(SA_Row_Cnt_valid_1) begin
          SA_Row_Cnt_count <= 3'b000;
        end else begin
          SA_Row_Cnt_count <= (SA_Row_Cnt_count + 3'b001);
        end
      end
      if(SA_Row_Cnt_valid_1) begin
        if(In_Channel_Process_Cnt_valid) begin
          In_Channel_Process_Cnt_count <= 13'h0;
        end else begin
          In_Channel_Process_Cnt_count <= (In_Channel_Process_Cnt_count + 13'h0001);
        end
      end
      if(In_Channel_Process_Cnt_valid) begin
        if(Window_Col_Cnt_valid) begin
          Window_Col_Cnt_count <= 16'h0;
        end else begin
          Window_Col_Cnt_count <= (Window_Col_Cnt_count + 16'h0001);
        end
      end
      if(Window_Col_Cnt_valid) begin
        if(Window_Row_Cnt_valid) begin
          Window_Row_Cnt_count <= 16'h0;
        end else begin
          Window_Row_Cnt_count <= (Window_Row_Cnt_count + 16'h0001);
        end
      end
      if(Window_Row_Cnt_valid) begin
        if(Out_Channel_Cnt_valid) begin
          Out_Channel_Cnt_count <= 16'h0;
        end else begin
          Out_Channel_Cnt_count <= (Out_Channel_Cnt_count + 16'h0001);
        end
      end
      if(Out_Channel_Cnt_valid) begin
        if(Out_Col_Cnt_valid) begin
          Out_Col_Cnt_count <= 16'h0;
        end else begin
          Out_Col_Cnt_count <= (Out_Col_Cnt_count + 16'h0001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        OutFeature_Col_Lefted <= OutFeature_Size;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          OutFeature_Col_Lefted <= (OutFeature_Col_Lefted - 16'h0008);
        end else begin
          if(when_Data_Generate_V2_l495) begin
            OutFeature_Col_Lefted <= OutFeature_Size;
          end
        end
      end
      if(when_Data_Generate_V2_l498) begin
        SA_Row_Cnt_count <= 3'b000;
      end
      if(SA_Row_Cnt_valid_1) begin
        if(WindowSize_Cnt_valid) begin
          WindowSize_Cnt_count <= 13'h0;
        end else begin
          WindowSize_Cnt_count <= (WindowSize_Cnt_count + 13'h0001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        Kernel_Base_Addr <= 32'h0;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          Kernel_Base_Addr <= (Kernel_Base_Addr + _zz_Kernel_Base_Addr);
        end
      end
      if(Out_Col_Cnt_valid) begin
        Kernel_Addr <= 32'h0;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          Kernel_Addr <= (Kernel_Base_Addr + _zz_Kernel_Addr);
        end else begin
          if(Window_Row_Cnt_valid) begin
            Kernel_Addr <= Kernel_Base_Addr;
          end else begin
            if(WindowSize_Cnt_valid) begin
              Kernel_Addr <= Kernel_Base_Addr;
            end else begin
              if(SA_Row_Cnt_valid_1) begin
                Kernel_Addr <= (_zz_Kernel_Addr_2 + 32'h00000001);
              end else begin
                if(when_Data_Generate_V2_l523) begin
                  Kernel_Addr <= (Kernel_Addr + _zz_Kernel_Addr_4);
                end
              end
            end
          end
        end
      end
    end
  end


endmodule

//WaddrOffset_Fifo_1 replaced by WaddrOffset_Fifo_2

//WaddrOffset_Fifo replaced by WaddrOffset_Fifo_2

module Zero (
  input      [15:0]   dataIn_0,
  input      [15:0]   dataIn_1,
  input      [15:0]   dataIn_2,
  input      [15:0]   dataIn_3,
  input      [15:0]   dataIn_4,
  input      [15:0]   dataIn_5,
  input      [15:0]   dataIn_6,
  input      [15:0]   dataIn_7,
  input      [7:0]    quan_1,
  output     [7:0]    dataOut_0,
  output     [7:0]    dataOut_1,
  output     [7:0]    dataOut_2,
  output     [7:0]    dataOut_3,
  output     [7:0]    dataOut_4,
  output     [7:0]    dataOut_5,
  output     [7:0]    dataOut_6,
  output     [7:0]    dataOut_7,
  input               clk,
  input               reset
);

  wire       [15:0]   addZero_0_S;
  wire       [15:0]   addZero_1_S;
  wire       [15:0]   addZero_2_S;
  wire       [15:0]   addZero_3_S;
  wire       [15:0]   addZero_4_S;
  wire       [15:0]   addZero_5_S;
  wire       [15:0]   addZero_6_S;
  wire       [15:0]   addZero_7_S;
  wire       [15:0]   _zz_normalData_0;
  wire       [15:0]   _zz_when_QuantModule_l179;
  wire       [15:0]   _zz_normalData_1;
  wire       [15:0]   _zz_when_QuantModule_l179_1;
  wire       [15:0]   _zz_normalData_2;
  wire       [15:0]   _zz_when_QuantModule_l179_2;
  wire       [15:0]   _zz_normalData_3;
  wire       [15:0]   _zz_when_QuantModule_l179_3;
  wire       [15:0]   _zz_normalData_4;
  wire       [15:0]   _zz_when_QuantModule_l179_4;
  wire       [15:0]   _zz_normalData_5;
  wire       [15:0]   _zz_when_QuantModule_l179_5;
  wire       [15:0]   _zz_normalData_6;
  wire       [15:0]   _zz_when_QuantModule_l179_6;
  wire       [15:0]   _zz_normalData_7;
  wire       [15:0]   _zz_when_QuantModule_l179_7;
  wire       [15:0]   addZeroTemp_0;
  wire       [15:0]   addZeroTemp_1;
  wire       [15:0]   addZeroTemp_2;
  wire       [15:0]   addZeroTemp_3;
  wire       [15:0]   addZeroTemp_4;
  wire       [15:0]   addZeroTemp_5;
  wire       [15:0]   addZeroTemp_6;
  wire       [15:0]   addZeroTemp_7;
  reg        [7:0]    normalData_0;
  reg        [7:0]    normalData_1;
  reg        [7:0]    normalData_2;
  reg        [7:0]    normalData_3;
  reg        [7:0]    normalData_4;
  reg        [7:0]    normalData_5;
  reg        [7:0]    normalData_6;
  reg        [7:0]    normalData_7;
  wire                when_QuantModule_l177;
  wire                when_QuantModule_l179;
  wire                when_QuantModule_l177_1;
  wire                when_QuantModule_l179_1;
  wire                when_QuantModule_l177_2;
  wire                when_QuantModule_l179_2;
  wire                when_QuantModule_l177_3;
  wire                when_QuantModule_l179_3;
  wire                when_QuantModule_l177_4;
  wire                when_QuantModule_l179_4;
  wire                when_QuantModule_l177_5;
  wire                when_QuantModule_l179_5;
  wire                when_QuantModule_l177_6;
  wire                when_QuantModule_l179_6;
  wire                when_QuantModule_l177_7;
  wire                when_QuantModule_l179_7;

  assign _zz_normalData_0 = addZeroTemp_0;
  assign _zz_when_QuantModule_l179 = 16'h00ff;
  assign _zz_normalData_1 = addZeroTemp_1;
  assign _zz_when_QuantModule_l179_1 = 16'h00ff;
  assign _zz_normalData_2 = addZeroTemp_2;
  assign _zz_when_QuantModule_l179_2 = 16'h00ff;
  assign _zz_normalData_3 = addZeroTemp_3;
  assign _zz_when_QuantModule_l179_3 = 16'h00ff;
  assign _zz_normalData_4 = addZeroTemp_4;
  assign _zz_when_QuantModule_l179_4 = 16'h00ff;
  assign _zz_normalData_5 = addZeroTemp_5;
  assign _zz_when_QuantModule_l179_5 = 16'h00ff;
  assign _zz_normalData_6 = addZeroTemp_6;
  assign _zz_when_QuantModule_l179_6 = 16'h00ff;
  assign _zz_normalData_7 = addZeroTemp_7;
  assign _zz_when_QuantModule_l179_7 = 16'h00ff;
  AddZero addZero_0 (
    .A   (dataIn_0[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_0_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_1 (
    .A   (dataIn_1[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_1_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_2 (
    .A   (dataIn_2[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_2_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_3 (
    .A   (dataIn_3[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_3_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_4 (
    .A   (dataIn_4[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_4_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_5 (
    .A   (dataIn_5[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_5_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_6 (
    .A   (dataIn_6[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_6_S[15:0]), //o
    .CLK (clk              )  //i
  );
  AddZero addZero_7 (
    .A   (dataIn_7[15:0]   ), //i
    .B   (quan_1[7:0]      ), //i
    .S   (addZero_7_S[15:0]), //o
    .CLK (clk              )  //i
  );
  assign addZeroTemp_0 = addZero_0_S;
  assign addZeroTemp_1 = addZero_1_S;
  assign addZeroTemp_2 = addZero_2_S;
  assign addZeroTemp_3 = addZero_3_S;
  assign addZeroTemp_4 = addZero_4_S;
  assign addZeroTemp_5 = addZero_5_S;
  assign addZeroTemp_6 = addZero_6_S;
  assign addZeroTemp_7 = addZero_7_S;
  assign dataOut_0 = normalData_0;
  assign dataOut_1 = normalData_1;
  assign dataOut_2 = normalData_2;
  assign dataOut_3 = normalData_3;
  assign dataOut_4 = normalData_4;
  assign dataOut_5 = normalData_5;
  assign dataOut_6 = normalData_6;
  assign dataOut_7 = normalData_7;
  assign when_QuantModule_l177 = addZeroTemp_0[15];
  assign when_QuantModule_l179 = ($signed(_zz_when_QuantModule_l179) < $signed(addZeroTemp_0));
  assign when_QuantModule_l177_1 = addZeroTemp_1[15];
  assign when_QuantModule_l179_1 = ($signed(_zz_when_QuantModule_l179_1) < $signed(addZeroTemp_1));
  assign when_QuantModule_l177_2 = addZeroTemp_2[15];
  assign when_QuantModule_l179_2 = ($signed(_zz_when_QuantModule_l179_2) < $signed(addZeroTemp_2));
  assign when_QuantModule_l177_3 = addZeroTemp_3[15];
  assign when_QuantModule_l179_3 = ($signed(_zz_when_QuantModule_l179_3) < $signed(addZeroTemp_3));
  assign when_QuantModule_l177_4 = addZeroTemp_4[15];
  assign when_QuantModule_l179_4 = ($signed(_zz_when_QuantModule_l179_4) < $signed(addZeroTemp_4));
  assign when_QuantModule_l177_5 = addZeroTemp_5[15];
  assign when_QuantModule_l179_5 = ($signed(_zz_when_QuantModule_l179_5) < $signed(addZeroTemp_5));
  assign when_QuantModule_l177_6 = addZeroTemp_6[15];
  assign when_QuantModule_l179_6 = ($signed(_zz_when_QuantModule_l179_6) < $signed(addZeroTemp_6));
  assign when_QuantModule_l177_7 = addZeroTemp_7[15];
  assign when_QuantModule_l179_7 = ($signed(_zz_when_QuantModule_l179_7) < $signed(addZeroTemp_7));
  always @(posedge clk) begin
    if(when_QuantModule_l177) begin
      normalData_0 <= 8'h0;
    end else begin
      if(when_QuantModule_l179) begin
        normalData_0 <= 8'hff;
      end else begin
        normalData_0 <= _zz_normalData_0[7:0];
      end
    end
    if(when_QuantModule_l177_1) begin
      normalData_1 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_1) begin
        normalData_1 <= 8'hff;
      end else begin
        normalData_1 <= _zz_normalData_1[7:0];
      end
    end
    if(when_QuantModule_l177_2) begin
      normalData_2 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_2) begin
        normalData_2 <= 8'hff;
      end else begin
        normalData_2 <= _zz_normalData_2[7:0];
      end
    end
    if(when_QuantModule_l177_3) begin
      normalData_3 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_3) begin
        normalData_3 <= 8'hff;
      end else begin
        normalData_3 <= _zz_normalData_3[7:0];
      end
    end
    if(when_QuantModule_l177_4) begin
      normalData_4 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_4) begin
        normalData_4 <= 8'hff;
      end else begin
        normalData_4 <= _zz_normalData_4[7:0];
      end
    end
    if(when_QuantModule_l177_5) begin
      normalData_5 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_5) begin
        normalData_5 <= 8'hff;
      end else begin
        normalData_5 <= _zz_normalData_5[7:0];
      end
    end
    if(when_QuantModule_l177_6) begin
      normalData_6 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_6) begin
        normalData_6 <= 8'hff;
      end else begin
        normalData_6 <= _zz_normalData_6[7:0];
      end
    end
    if(when_QuantModule_l177_7) begin
      normalData_7 <= 8'h0;
    end else begin
      if(when_QuantModule_l179_7) begin
        normalData_7 <= 8'hff;
      end else begin
        normalData_7 <= _zz_normalData_7[7:0];
      end
    end
  end


endmodule

module Shift (
  input      [31:0]   shift_dataIn_0,
  input      [31:0]   shift_dataIn_1,
  input      [31:0]   shift_dataIn_2,
  input      [31:0]   shift_dataIn_3,
  input      [31:0]   shift_dataIn_4,
  input      [31:0]   shift_dataIn_5,
  input      [31:0]   shift_dataIn_6,
  input      [31:0]   shift_dataIn_7,
  input      [31:0]   shift_quan,
  output     [15:0]   shift_dataOut_0,
  output     [15:0]   shift_dataOut_1,
  output     [15:0]   shift_dataOut_2,
  output     [15:0]   shift_dataOut_3,
  output     [15:0]   shift_dataOut_4,
  output     [15:0]   shift_dataOut_5,
  output     [15:0]   shift_dataOut_6,
  output     [15:0]   shift_dataOut_7,
  input               clk,
  input               reset
);

  wire       [15:0]   _zz__zz_shift_dataOut_0;
  wire       [0:0]    _zz__zz_shift_dataOut_0_1;
  wire       [14:0]   _zz__zz_shift_dataOut_0_2;
  wire       [15:0]   _zz__zz_shift_dataOut_0_3;
  wire       [0:0]    _zz__zz_shift_dataOut_0_4;
  wire       [14:0]   _zz__zz_shift_dataOut_0_5;
  wire       [15:0]   _zz__zz_shift_dataOut_1;
  wire       [0:0]    _zz__zz_shift_dataOut_1_1;
  wire       [14:0]   _zz__zz_shift_dataOut_1_2;
  wire       [15:0]   _zz__zz_shift_dataOut_1_3;
  wire       [0:0]    _zz__zz_shift_dataOut_1_4;
  wire       [14:0]   _zz__zz_shift_dataOut_1_5;
  wire       [15:0]   _zz__zz_shift_dataOut_2;
  wire       [0:0]    _zz__zz_shift_dataOut_2_1;
  wire       [14:0]   _zz__zz_shift_dataOut_2_2;
  wire       [15:0]   _zz__zz_shift_dataOut_2_3;
  wire       [0:0]    _zz__zz_shift_dataOut_2_4;
  wire       [14:0]   _zz__zz_shift_dataOut_2_5;
  wire       [15:0]   _zz__zz_shift_dataOut_3;
  wire       [0:0]    _zz__zz_shift_dataOut_3_1;
  wire       [14:0]   _zz__zz_shift_dataOut_3_2;
  wire       [15:0]   _zz__zz_shift_dataOut_3_3;
  wire       [0:0]    _zz__zz_shift_dataOut_3_4;
  wire       [14:0]   _zz__zz_shift_dataOut_3_5;
  wire       [15:0]   _zz__zz_shift_dataOut_4;
  wire       [0:0]    _zz__zz_shift_dataOut_4_1;
  wire       [14:0]   _zz__zz_shift_dataOut_4_2;
  wire       [15:0]   _zz__zz_shift_dataOut_4_3;
  wire       [0:0]    _zz__zz_shift_dataOut_4_4;
  wire       [14:0]   _zz__zz_shift_dataOut_4_5;
  wire       [15:0]   _zz__zz_shift_dataOut_5;
  wire       [0:0]    _zz__zz_shift_dataOut_5_1;
  wire       [14:0]   _zz__zz_shift_dataOut_5_2;
  wire       [15:0]   _zz__zz_shift_dataOut_5_3;
  wire       [0:0]    _zz__zz_shift_dataOut_5_4;
  wire       [14:0]   _zz__zz_shift_dataOut_5_5;
  wire       [15:0]   _zz__zz_shift_dataOut_6;
  wire       [0:0]    _zz__zz_shift_dataOut_6_1;
  wire       [14:0]   _zz__zz_shift_dataOut_6_2;
  wire       [15:0]   _zz__zz_shift_dataOut_6_3;
  wire       [0:0]    _zz__zz_shift_dataOut_6_4;
  wire       [14:0]   _zz__zz_shift_dataOut_6_5;
  wire       [15:0]   _zz__zz_shift_dataOut_7;
  wire       [0:0]    _zz__zz_shift_dataOut_7_1;
  wire       [14:0]   _zz__zz_shift_dataOut_7_2;
  wire       [15:0]   _zz__zz_shift_dataOut_7_3;
  wire       [0:0]    _zz__zz_shift_dataOut_7_4;
  wire       [14:0]   _zz__zz_shift_dataOut_7_5;
  wire       [31:0]   _zz_when_QuantModule_l136;
  reg        [15:0]   _zz_shift_dataOut_0;
  wire                when_QuantModule_l136;
  wire       [31:0]   _zz_when_QuantModule_l136_1;
  reg        [15:0]   _zz_shift_dataOut_1;
  wire                when_QuantModule_l136_1;
  wire       [31:0]   _zz_when_QuantModule_l136_2;
  reg        [15:0]   _zz_shift_dataOut_2;
  wire                when_QuantModule_l136_2;
  wire       [31:0]   _zz_when_QuantModule_l136_3;
  reg        [15:0]   _zz_shift_dataOut_3;
  wire                when_QuantModule_l136_3;
  wire       [31:0]   _zz_when_QuantModule_l136_4;
  reg        [15:0]   _zz_shift_dataOut_4;
  wire                when_QuantModule_l136_4;
  wire       [31:0]   _zz_when_QuantModule_l136_5;
  reg        [15:0]   _zz_shift_dataOut_5;
  wire                when_QuantModule_l136_5;
  wire       [31:0]   _zz_when_QuantModule_l136_6;
  reg        [15:0]   _zz_shift_dataOut_6;
  wire                when_QuantModule_l136_6;
  wire       [31:0]   _zz_when_QuantModule_l136_7;
  reg        [15:0]   _zz_shift_dataOut_7;
  wire                when_QuantModule_l136_7;

  assign _zz__zz_shift_dataOut_0 = {_zz__zz_shift_dataOut_0_1,_zz__zz_shift_dataOut_0_2};
  assign _zz__zz_shift_dataOut_0_1 = _zz_when_QuantModule_l136[31];
  assign _zz__zz_shift_dataOut_0_2 = _zz_when_QuantModule_l136[15 : 1];
  assign _zz__zz_shift_dataOut_0_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_0_4 = _zz_when_QuantModule_l136[31];
  assign _zz__zz_shift_dataOut_0_5 = _zz_when_QuantModule_l136[15 : 1];
  assign _zz__zz_shift_dataOut_1 = {_zz__zz_shift_dataOut_1_1,_zz__zz_shift_dataOut_1_2};
  assign _zz__zz_shift_dataOut_1_1 = _zz_when_QuantModule_l136_1[31];
  assign _zz__zz_shift_dataOut_1_2 = _zz_when_QuantModule_l136_1[15 : 1];
  assign _zz__zz_shift_dataOut_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_1_4 = _zz_when_QuantModule_l136_1[31];
  assign _zz__zz_shift_dataOut_1_5 = _zz_when_QuantModule_l136_1[15 : 1];
  assign _zz__zz_shift_dataOut_2 = {_zz__zz_shift_dataOut_2_1,_zz__zz_shift_dataOut_2_2};
  assign _zz__zz_shift_dataOut_2_1 = _zz_when_QuantModule_l136_2[31];
  assign _zz__zz_shift_dataOut_2_2 = _zz_when_QuantModule_l136_2[15 : 1];
  assign _zz__zz_shift_dataOut_2_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_2_4 = _zz_when_QuantModule_l136_2[31];
  assign _zz__zz_shift_dataOut_2_5 = _zz_when_QuantModule_l136_2[15 : 1];
  assign _zz__zz_shift_dataOut_3 = {_zz__zz_shift_dataOut_3_1,_zz__zz_shift_dataOut_3_2};
  assign _zz__zz_shift_dataOut_3_1 = _zz_when_QuantModule_l136_3[31];
  assign _zz__zz_shift_dataOut_3_2 = _zz_when_QuantModule_l136_3[15 : 1];
  assign _zz__zz_shift_dataOut_3_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_3_4 = _zz_when_QuantModule_l136_3[31];
  assign _zz__zz_shift_dataOut_3_5 = _zz_when_QuantModule_l136_3[15 : 1];
  assign _zz__zz_shift_dataOut_4 = {_zz__zz_shift_dataOut_4_1,_zz__zz_shift_dataOut_4_2};
  assign _zz__zz_shift_dataOut_4_1 = _zz_when_QuantModule_l136_4[31];
  assign _zz__zz_shift_dataOut_4_2 = _zz_when_QuantModule_l136_4[15 : 1];
  assign _zz__zz_shift_dataOut_4_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_4_4 = _zz_when_QuantModule_l136_4[31];
  assign _zz__zz_shift_dataOut_4_5 = _zz_when_QuantModule_l136_4[15 : 1];
  assign _zz__zz_shift_dataOut_5 = {_zz__zz_shift_dataOut_5_1,_zz__zz_shift_dataOut_5_2};
  assign _zz__zz_shift_dataOut_5_1 = _zz_when_QuantModule_l136_5[31];
  assign _zz__zz_shift_dataOut_5_2 = _zz_when_QuantModule_l136_5[15 : 1];
  assign _zz__zz_shift_dataOut_5_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_5_4 = _zz_when_QuantModule_l136_5[31];
  assign _zz__zz_shift_dataOut_5_5 = _zz_when_QuantModule_l136_5[15 : 1];
  assign _zz__zz_shift_dataOut_6 = {_zz__zz_shift_dataOut_6_1,_zz__zz_shift_dataOut_6_2};
  assign _zz__zz_shift_dataOut_6_1 = _zz_when_QuantModule_l136_6[31];
  assign _zz__zz_shift_dataOut_6_2 = _zz_when_QuantModule_l136_6[15 : 1];
  assign _zz__zz_shift_dataOut_6_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_6_4 = _zz_when_QuantModule_l136_6[31];
  assign _zz__zz_shift_dataOut_6_5 = _zz_when_QuantModule_l136_6[15 : 1];
  assign _zz__zz_shift_dataOut_7 = {_zz__zz_shift_dataOut_7_1,_zz__zz_shift_dataOut_7_2};
  assign _zz__zz_shift_dataOut_7_1 = _zz_when_QuantModule_l136_7[31];
  assign _zz__zz_shift_dataOut_7_2 = _zz_when_QuantModule_l136_7[15 : 1];
  assign _zz__zz_shift_dataOut_7_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_7_4 = _zz_when_QuantModule_l136_7[31];
  assign _zz__zz_shift_dataOut_7_5 = _zz_when_QuantModule_l136_7[15 : 1];
  assign _zz_when_QuantModule_l136 = ($signed(shift_dataIn_0) >>> shift_quan);
  assign when_QuantModule_l136 = _zz_when_QuantModule_l136[0];
  assign shift_dataOut_0 = _zz_shift_dataOut_0;
  assign _zz_when_QuantModule_l136_1 = ($signed(shift_dataIn_1) >>> shift_quan);
  assign when_QuantModule_l136_1 = _zz_when_QuantModule_l136_1[0];
  assign shift_dataOut_1 = _zz_shift_dataOut_1;
  assign _zz_when_QuantModule_l136_2 = ($signed(shift_dataIn_2) >>> shift_quan);
  assign when_QuantModule_l136_2 = _zz_when_QuantModule_l136_2[0];
  assign shift_dataOut_2 = _zz_shift_dataOut_2;
  assign _zz_when_QuantModule_l136_3 = ($signed(shift_dataIn_3) >>> shift_quan);
  assign when_QuantModule_l136_3 = _zz_when_QuantModule_l136_3[0];
  assign shift_dataOut_3 = _zz_shift_dataOut_3;
  assign _zz_when_QuantModule_l136_4 = ($signed(shift_dataIn_4) >>> shift_quan);
  assign when_QuantModule_l136_4 = _zz_when_QuantModule_l136_4[0];
  assign shift_dataOut_4 = _zz_shift_dataOut_4;
  assign _zz_when_QuantModule_l136_5 = ($signed(shift_dataIn_5) >>> shift_quan);
  assign when_QuantModule_l136_5 = _zz_when_QuantModule_l136_5[0];
  assign shift_dataOut_5 = _zz_shift_dataOut_5;
  assign _zz_when_QuantModule_l136_6 = ($signed(shift_dataIn_6) >>> shift_quan);
  assign when_QuantModule_l136_6 = _zz_when_QuantModule_l136_6[0];
  assign shift_dataOut_6 = _zz_shift_dataOut_6;
  assign _zz_when_QuantModule_l136_7 = ($signed(shift_dataIn_7) >>> shift_quan);
  assign when_QuantModule_l136_7 = _zz_when_QuantModule_l136_7[0];
  assign shift_dataOut_7 = _zz_shift_dataOut_7;
  always @(posedge clk) begin
    if(when_QuantModule_l136) begin
      _zz_shift_dataOut_0 <= ($signed(_zz__zz_shift_dataOut_0) + $signed(_zz__zz_shift_dataOut_0_3));
    end else begin
      _zz_shift_dataOut_0 <= {_zz__zz_shift_dataOut_0_4,_zz__zz_shift_dataOut_0_5};
    end
    if(when_QuantModule_l136_1) begin
      _zz_shift_dataOut_1 <= ($signed(_zz__zz_shift_dataOut_1) + $signed(_zz__zz_shift_dataOut_1_3));
    end else begin
      _zz_shift_dataOut_1 <= {_zz__zz_shift_dataOut_1_4,_zz__zz_shift_dataOut_1_5};
    end
    if(when_QuantModule_l136_2) begin
      _zz_shift_dataOut_2 <= ($signed(_zz__zz_shift_dataOut_2) + $signed(_zz__zz_shift_dataOut_2_3));
    end else begin
      _zz_shift_dataOut_2 <= {_zz__zz_shift_dataOut_2_4,_zz__zz_shift_dataOut_2_5};
    end
    if(when_QuantModule_l136_3) begin
      _zz_shift_dataOut_3 <= ($signed(_zz__zz_shift_dataOut_3) + $signed(_zz__zz_shift_dataOut_3_3));
    end else begin
      _zz_shift_dataOut_3 <= {_zz__zz_shift_dataOut_3_4,_zz__zz_shift_dataOut_3_5};
    end
    if(when_QuantModule_l136_4) begin
      _zz_shift_dataOut_4 <= ($signed(_zz__zz_shift_dataOut_4) + $signed(_zz__zz_shift_dataOut_4_3));
    end else begin
      _zz_shift_dataOut_4 <= {_zz__zz_shift_dataOut_4_4,_zz__zz_shift_dataOut_4_5};
    end
    if(when_QuantModule_l136_5) begin
      _zz_shift_dataOut_5 <= ($signed(_zz__zz_shift_dataOut_5) + $signed(_zz__zz_shift_dataOut_5_3));
    end else begin
      _zz_shift_dataOut_5 <= {_zz__zz_shift_dataOut_5_4,_zz__zz_shift_dataOut_5_5};
    end
    if(when_QuantModule_l136_6) begin
      _zz_shift_dataOut_6 <= ($signed(_zz__zz_shift_dataOut_6) + $signed(_zz__zz_shift_dataOut_6_3));
    end else begin
      _zz_shift_dataOut_6 <= {_zz__zz_shift_dataOut_6_4,_zz__zz_shift_dataOut_6_5};
    end
    if(when_QuantModule_l136_7) begin
      _zz_shift_dataOut_7 <= ($signed(_zz__zz_shift_dataOut_7) + $signed(_zz__zz_shift_dataOut_7_3));
    end else begin
      _zz_shift_dataOut_7 <= {_zz__zz_shift_dataOut_7_4,_zz__zz_shift_dataOut_7_5};
    end
  end


endmodule

module Scale (
  input      [47:0]   Scale_dataIn_0,
  input      [47:0]   Scale_dataIn_1,
  input      [47:0]   Scale_dataIn_2,
  input      [47:0]   Scale_dataIn_3,
  input      [47:0]   Scale_dataIn_4,
  input      [47:0]   Scale_dataIn_5,
  input      [47:0]   Scale_dataIn_6,
  input      [47:0]   Scale_dataIn_7,
  input      [31:0]   Scale_quan,
  output     [31:0]   Scale_dataOut_0,
  output     [31:0]   Scale_dataOut_1,
  output     [31:0]   Scale_dataOut_2,
  output     [31:0]   Scale_dataOut_3,
  output     [31:0]   Scale_dataOut_4,
  output     [31:0]   Scale_dataOut_5,
  output     [31:0]   Scale_dataOut_6,
  output     [31:0]   Scale_dataOut_7,
  input               clk,
  input               reset
);

  wire       [31:0]   mul_P;
  wire       [31:0]   mul_1_P;
  wire       [31:0]   mul_2_P;
  wire       [31:0]   mul_3_P;
  wire       [31:0]   mul_4_P;
  wire       [31:0]   mul_5_P;
  wire       [31:0]   mul_6_P;
  wire       [31:0]   mul_7_P;
  wire       [31:0]   scaleMulOut_0;
  wire       [31:0]   scaleMulOut_1;
  wire       [31:0]   scaleMulOut_2;
  wire       [31:0]   scaleMulOut_3;
  wire       [31:0]   scaleMulOut_4;
  wire       [31:0]   scaleMulOut_5;
  wire       [31:0]   scaleMulOut_6;
  wire       [31:0]   scaleMulOut_7;
  reg        [31:0]   scaleMulOut_0_regNext;
  reg        [31:0]   scaleMulOut_1_regNext;
  reg        [31:0]   scaleMulOut_2_regNext;
  reg        [31:0]   scaleMulOut_3_regNext;
  reg        [31:0]   scaleMulOut_4_regNext;
  reg        [31:0]   scaleMulOut_5_regNext;
  reg        [31:0]   scaleMulOut_6_regNext;
  reg        [31:0]   scaleMulOut_7_regNext;

  scaleMul mul (
    .A   (Scale_dataIn_0[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_P[31:0]         ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_1 (
    .A   (Scale_dataIn_1[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_1_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_2 (
    .A   (Scale_dataIn_2[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_2_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_3 (
    .A   (Scale_dataIn_3[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_3_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_4 (
    .A   (Scale_dataIn_4[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_4_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_5 (
    .A   (Scale_dataIn_5[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_5_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_6 (
    .A   (Scale_dataIn_6[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_6_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  scaleMul mul_7 (
    .A   (Scale_dataIn_7[47:0]), //i
    .B   (Scale_quan[31:0]    ), //i
    .P   (mul_7_P[31:0]       ), //o
    .CLK (clk                 )  //i
  );
  assign scaleMulOut_0 = mul_P;
  assign scaleMulOut_1 = mul_1_P;
  assign scaleMulOut_2 = mul_2_P;
  assign scaleMulOut_3 = mul_3_P;
  assign scaleMulOut_4 = mul_4_P;
  assign scaleMulOut_5 = mul_5_P;
  assign scaleMulOut_6 = mul_6_P;
  assign scaleMulOut_7 = mul_7_P;
  assign Scale_dataOut_0 = scaleMulOut_0_regNext;
  assign Scale_dataOut_1 = scaleMulOut_1_regNext;
  assign Scale_dataOut_2 = scaleMulOut_2_regNext;
  assign Scale_dataOut_3 = scaleMulOut_3_regNext;
  assign Scale_dataOut_4 = scaleMulOut_4_regNext;
  assign Scale_dataOut_5 = scaleMulOut_5_regNext;
  assign Scale_dataOut_6 = scaleMulOut_6_regNext;
  assign Scale_dataOut_7 = scaleMulOut_7_regNext;
  always @(posedge clk) begin
    scaleMulOut_0_regNext <= scaleMulOut_0;
    scaleMulOut_1_regNext <= scaleMulOut_1;
    scaleMulOut_2_regNext <= scaleMulOut_2;
    scaleMulOut_3_regNext <= scaleMulOut_3;
    scaleMulOut_4_regNext <= scaleMulOut_4;
    scaleMulOut_5_regNext <= scaleMulOut_5;
    scaleMulOut_6_regNext <= scaleMulOut_6;
    scaleMulOut_7_regNext <= scaleMulOut_7;
  end


endmodule

module Bias (
  input      [31:0]   Bias_dataIn_0,
  input      [31:0]   Bias_dataIn_1,
  input      [31:0]   Bias_dataIn_2,
  input      [31:0]   Bias_dataIn_3,
  input      [31:0]   Bias_dataIn_4,
  input      [31:0]   Bias_dataIn_5,
  input      [31:0]   Bias_dataIn_6,
  input      [31:0]   Bias_dataIn_7,
  input      [31:0]   Bias_quan,
  output     [47:0]   Bias_dataOut_0,
  output     [47:0]   Bias_dataOut_1,
  output     [47:0]   Bias_dataOut_2,
  output     [47:0]   Bias_dataOut_3,
  output     [47:0]   Bias_dataOut_4,
  output     [47:0]   Bias_dataOut_5,
  output     [47:0]   Bias_dataOut_6,
  output     [47:0]   Bias_dataOut_7,
  input               clk,
  input               reset
);

  wire       [47:0]   addSub_S;
  wire       [47:0]   addSub_1_S;
  wire       [47:0]   addSub_2_S;
  wire       [47:0]   addSub_3_S;
  wire       [47:0]   addSub_4_S;
  wire       [47:0]   addSub_5_S;
  wire       [47:0]   addSub_6_S;
  wire       [47:0]   addSub_7_S;
  wire       [15:0]   _zz_dataInTemp_0;
  wire       [7:0]    _zz_biasInTemp_0;
  wire       [0:0]    _zz_biasInTemp_0_1;
  wire       [8:0]    _zz_biasInTemp_0_2;
  wire       [0:0]    _zz_biasInTemp_0_3;
  wire       [9:0]    _zz_biasInTemp_0_4;
  wire       [0:0]    _zz_biasInTemp_0_5;
  wire       [10:0]   _zz_biasInTemp_0_6;
  wire       [0:0]    _zz_biasInTemp_0_7;
  wire       [11:0]   _zz_biasInTemp_0_8;
  wire       [0:0]    _zz_biasInTemp_0_9;
  wire       [12:0]   _zz_biasInTemp_0_10;
  wire       [0:0]    _zz_biasInTemp_0_11;
  wire       [13:0]   _zz_biasInTemp_0_12;
  wire       [0:0]    _zz_biasInTemp_0_13;
  wire       [14:0]   _zz_biasInTemp_0_14;
  wire       [0:0]    _zz_biasInTemp_0_15;
  wire       [15:0]   _zz_biasInTemp_0_16;
  wire       [0:0]    _zz_biasInTemp_0_17;
  wire       [16:0]   _zz_biasInTemp_0_18;
  wire       [0:0]    _zz_biasInTemp_0_19;
  wire       [17:0]   _zz_biasInTemp_0_20;
  wire       [0:0]    _zz_biasInTemp_0_21;
  wire       [18:0]   _zz_biasInTemp_0_22;
  wire       [0:0]    _zz_biasInTemp_0_23;
  wire       [19:0]   _zz_biasInTemp_0_24;
  wire       [0:0]    _zz_biasInTemp_0_25;
  wire       [20:0]   _zz_biasInTemp_0_26;
  wire       [0:0]    _zz_biasInTemp_0_27;
  wire       [21:0]   _zz_biasInTemp_0_28;
  wire       [0:0]    _zz_biasInTemp_0_29;
  wire       [22:0]   _zz_biasInTemp_0_30;
  wire       [0:0]    _zz_biasInTemp_0_31;
  wire       [23:0]   _zz_biasInTemp_0_32;
  wire       [0:0]    _zz_biasInTemp_0_33;
  wire       [15:0]   _zz_dataInTemp_1;
  wire       [7:0]    _zz_biasInTemp_1;
  wire       [0:0]    _zz_biasInTemp_1_1;
  wire       [8:0]    _zz_biasInTemp_1_2;
  wire       [0:0]    _zz_biasInTemp_1_3;
  wire       [9:0]    _zz_biasInTemp_1_4;
  wire       [0:0]    _zz_biasInTemp_1_5;
  wire       [10:0]   _zz_biasInTemp_1_6;
  wire       [0:0]    _zz_biasInTemp_1_7;
  wire       [11:0]   _zz_biasInTemp_1_8;
  wire       [0:0]    _zz_biasInTemp_1_9;
  wire       [12:0]   _zz_biasInTemp_1_10;
  wire       [0:0]    _zz_biasInTemp_1_11;
  wire       [13:0]   _zz_biasInTemp_1_12;
  wire       [0:0]    _zz_biasInTemp_1_13;
  wire       [14:0]   _zz_biasInTemp_1_14;
  wire       [0:0]    _zz_biasInTemp_1_15;
  wire       [15:0]   _zz_biasInTemp_1_16;
  wire       [0:0]    _zz_biasInTemp_1_17;
  wire       [16:0]   _zz_biasInTemp_1_18;
  wire       [0:0]    _zz_biasInTemp_1_19;
  wire       [17:0]   _zz_biasInTemp_1_20;
  wire       [0:0]    _zz_biasInTemp_1_21;
  wire       [18:0]   _zz_biasInTemp_1_22;
  wire       [0:0]    _zz_biasInTemp_1_23;
  wire       [19:0]   _zz_biasInTemp_1_24;
  wire       [0:0]    _zz_biasInTemp_1_25;
  wire       [20:0]   _zz_biasInTemp_1_26;
  wire       [0:0]    _zz_biasInTemp_1_27;
  wire       [21:0]   _zz_biasInTemp_1_28;
  wire       [0:0]    _zz_biasInTemp_1_29;
  wire       [22:0]   _zz_biasInTemp_1_30;
  wire       [0:0]    _zz_biasInTemp_1_31;
  wire       [23:0]   _zz_biasInTemp_1_32;
  wire       [0:0]    _zz_biasInTemp_1_33;
  wire       [15:0]   _zz_dataInTemp_2;
  wire       [7:0]    _zz_biasInTemp_2;
  wire       [0:0]    _zz_biasInTemp_2_1;
  wire       [8:0]    _zz_biasInTemp_2_2;
  wire       [0:0]    _zz_biasInTemp_2_3;
  wire       [9:0]    _zz_biasInTemp_2_4;
  wire       [0:0]    _zz_biasInTemp_2_5;
  wire       [10:0]   _zz_biasInTemp_2_6;
  wire       [0:0]    _zz_biasInTemp_2_7;
  wire       [11:0]   _zz_biasInTemp_2_8;
  wire       [0:0]    _zz_biasInTemp_2_9;
  wire       [12:0]   _zz_biasInTemp_2_10;
  wire       [0:0]    _zz_biasInTemp_2_11;
  wire       [13:0]   _zz_biasInTemp_2_12;
  wire       [0:0]    _zz_biasInTemp_2_13;
  wire       [14:0]   _zz_biasInTemp_2_14;
  wire       [0:0]    _zz_biasInTemp_2_15;
  wire       [15:0]   _zz_biasInTemp_2_16;
  wire       [0:0]    _zz_biasInTemp_2_17;
  wire       [16:0]   _zz_biasInTemp_2_18;
  wire       [0:0]    _zz_biasInTemp_2_19;
  wire       [17:0]   _zz_biasInTemp_2_20;
  wire       [0:0]    _zz_biasInTemp_2_21;
  wire       [18:0]   _zz_biasInTemp_2_22;
  wire       [0:0]    _zz_biasInTemp_2_23;
  wire       [19:0]   _zz_biasInTemp_2_24;
  wire       [0:0]    _zz_biasInTemp_2_25;
  wire       [20:0]   _zz_biasInTemp_2_26;
  wire       [0:0]    _zz_biasInTemp_2_27;
  wire       [21:0]   _zz_biasInTemp_2_28;
  wire       [0:0]    _zz_biasInTemp_2_29;
  wire       [22:0]   _zz_biasInTemp_2_30;
  wire       [0:0]    _zz_biasInTemp_2_31;
  wire       [23:0]   _zz_biasInTemp_2_32;
  wire       [0:0]    _zz_biasInTemp_2_33;
  wire       [15:0]   _zz_dataInTemp_3;
  wire       [7:0]    _zz_biasInTemp_3;
  wire       [0:0]    _zz_biasInTemp_3_1;
  wire       [8:0]    _zz_biasInTemp_3_2;
  wire       [0:0]    _zz_biasInTemp_3_3;
  wire       [9:0]    _zz_biasInTemp_3_4;
  wire       [0:0]    _zz_biasInTemp_3_5;
  wire       [10:0]   _zz_biasInTemp_3_6;
  wire       [0:0]    _zz_biasInTemp_3_7;
  wire       [11:0]   _zz_biasInTemp_3_8;
  wire       [0:0]    _zz_biasInTemp_3_9;
  wire       [12:0]   _zz_biasInTemp_3_10;
  wire       [0:0]    _zz_biasInTemp_3_11;
  wire       [13:0]   _zz_biasInTemp_3_12;
  wire       [0:0]    _zz_biasInTemp_3_13;
  wire       [14:0]   _zz_biasInTemp_3_14;
  wire       [0:0]    _zz_biasInTemp_3_15;
  wire       [15:0]   _zz_biasInTemp_3_16;
  wire       [0:0]    _zz_biasInTemp_3_17;
  wire       [16:0]   _zz_biasInTemp_3_18;
  wire       [0:0]    _zz_biasInTemp_3_19;
  wire       [17:0]   _zz_biasInTemp_3_20;
  wire       [0:0]    _zz_biasInTemp_3_21;
  wire       [18:0]   _zz_biasInTemp_3_22;
  wire       [0:0]    _zz_biasInTemp_3_23;
  wire       [19:0]   _zz_biasInTemp_3_24;
  wire       [0:0]    _zz_biasInTemp_3_25;
  wire       [20:0]   _zz_biasInTemp_3_26;
  wire       [0:0]    _zz_biasInTemp_3_27;
  wire       [21:0]   _zz_biasInTemp_3_28;
  wire       [0:0]    _zz_biasInTemp_3_29;
  wire       [22:0]   _zz_biasInTemp_3_30;
  wire       [0:0]    _zz_biasInTemp_3_31;
  wire       [23:0]   _zz_biasInTemp_3_32;
  wire       [0:0]    _zz_biasInTemp_3_33;
  wire       [15:0]   _zz_dataInTemp_4;
  wire       [7:0]    _zz_biasInTemp_4;
  wire       [0:0]    _zz_biasInTemp_4_1;
  wire       [8:0]    _zz_biasInTemp_4_2;
  wire       [0:0]    _zz_biasInTemp_4_3;
  wire       [9:0]    _zz_biasInTemp_4_4;
  wire       [0:0]    _zz_biasInTemp_4_5;
  wire       [10:0]   _zz_biasInTemp_4_6;
  wire       [0:0]    _zz_biasInTemp_4_7;
  wire       [11:0]   _zz_biasInTemp_4_8;
  wire       [0:0]    _zz_biasInTemp_4_9;
  wire       [12:0]   _zz_biasInTemp_4_10;
  wire       [0:0]    _zz_biasInTemp_4_11;
  wire       [13:0]   _zz_biasInTemp_4_12;
  wire       [0:0]    _zz_biasInTemp_4_13;
  wire       [14:0]   _zz_biasInTemp_4_14;
  wire       [0:0]    _zz_biasInTemp_4_15;
  wire       [15:0]   _zz_biasInTemp_4_16;
  wire       [0:0]    _zz_biasInTemp_4_17;
  wire       [16:0]   _zz_biasInTemp_4_18;
  wire       [0:0]    _zz_biasInTemp_4_19;
  wire       [17:0]   _zz_biasInTemp_4_20;
  wire       [0:0]    _zz_biasInTemp_4_21;
  wire       [18:0]   _zz_biasInTemp_4_22;
  wire       [0:0]    _zz_biasInTemp_4_23;
  wire       [19:0]   _zz_biasInTemp_4_24;
  wire       [0:0]    _zz_biasInTemp_4_25;
  wire       [20:0]   _zz_biasInTemp_4_26;
  wire       [0:0]    _zz_biasInTemp_4_27;
  wire       [21:0]   _zz_biasInTemp_4_28;
  wire       [0:0]    _zz_biasInTemp_4_29;
  wire       [22:0]   _zz_biasInTemp_4_30;
  wire       [0:0]    _zz_biasInTemp_4_31;
  wire       [23:0]   _zz_biasInTemp_4_32;
  wire       [0:0]    _zz_biasInTemp_4_33;
  wire       [15:0]   _zz_dataInTemp_5;
  wire       [7:0]    _zz_biasInTemp_5;
  wire       [0:0]    _zz_biasInTemp_5_1;
  wire       [8:0]    _zz_biasInTemp_5_2;
  wire       [0:0]    _zz_biasInTemp_5_3;
  wire       [9:0]    _zz_biasInTemp_5_4;
  wire       [0:0]    _zz_biasInTemp_5_5;
  wire       [10:0]   _zz_biasInTemp_5_6;
  wire       [0:0]    _zz_biasInTemp_5_7;
  wire       [11:0]   _zz_biasInTemp_5_8;
  wire       [0:0]    _zz_biasInTemp_5_9;
  wire       [12:0]   _zz_biasInTemp_5_10;
  wire       [0:0]    _zz_biasInTemp_5_11;
  wire       [13:0]   _zz_biasInTemp_5_12;
  wire       [0:0]    _zz_biasInTemp_5_13;
  wire       [14:0]   _zz_biasInTemp_5_14;
  wire       [0:0]    _zz_biasInTemp_5_15;
  wire       [15:0]   _zz_biasInTemp_5_16;
  wire       [0:0]    _zz_biasInTemp_5_17;
  wire       [16:0]   _zz_biasInTemp_5_18;
  wire       [0:0]    _zz_biasInTemp_5_19;
  wire       [17:0]   _zz_biasInTemp_5_20;
  wire       [0:0]    _zz_biasInTemp_5_21;
  wire       [18:0]   _zz_biasInTemp_5_22;
  wire       [0:0]    _zz_biasInTemp_5_23;
  wire       [19:0]   _zz_biasInTemp_5_24;
  wire       [0:0]    _zz_biasInTemp_5_25;
  wire       [20:0]   _zz_biasInTemp_5_26;
  wire       [0:0]    _zz_biasInTemp_5_27;
  wire       [21:0]   _zz_biasInTemp_5_28;
  wire       [0:0]    _zz_biasInTemp_5_29;
  wire       [22:0]   _zz_biasInTemp_5_30;
  wire       [0:0]    _zz_biasInTemp_5_31;
  wire       [23:0]   _zz_biasInTemp_5_32;
  wire       [0:0]    _zz_biasInTemp_5_33;
  wire       [15:0]   _zz_dataInTemp_6;
  wire       [7:0]    _zz_biasInTemp_6;
  wire       [0:0]    _zz_biasInTemp_6_1;
  wire       [8:0]    _zz_biasInTemp_6_2;
  wire       [0:0]    _zz_biasInTemp_6_3;
  wire       [9:0]    _zz_biasInTemp_6_4;
  wire       [0:0]    _zz_biasInTemp_6_5;
  wire       [10:0]   _zz_biasInTemp_6_6;
  wire       [0:0]    _zz_biasInTemp_6_7;
  wire       [11:0]   _zz_biasInTemp_6_8;
  wire       [0:0]    _zz_biasInTemp_6_9;
  wire       [12:0]   _zz_biasInTemp_6_10;
  wire       [0:0]    _zz_biasInTemp_6_11;
  wire       [13:0]   _zz_biasInTemp_6_12;
  wire       [0:0]    _zz_biasInTemp_6_13;
  wire       [14:0]   _zz_biasInTemp_6_14;
  wire       [0:0]    _zz_biasInTemp_6_15;
  wire       [15:0]   _zz_biasInTemp_6_16;
  wire       [0:0]    _zz_biasInTemp_6_17;
  wire       [16:0]   _zz_biasInTemp_6_18;
  wire       [0:0]    _zz_biasInTemp_6_19;
  wire       [17:0]   _zz_biasInTemp_6_20;
  wire       [0:0]    _zz_biasInTemp_6_21;
  wire       [18:0]   _zz_biasInTemp_6_22;
  wire       [0:0]    _zz_biasInTemp_6_23;
  wire       [19:0]   _zz_biasInTemp_6_24;
  wire       [0:0]    _zz_biasInTemp_6_25;
  wire       [20:0]   _zz_biasInTemp_6_26;
  wire       [0:0]    _zz_biasInTemp_6_27;
  wire       [21:0]   _zz_biasInTemp_6_28;
  wire       [0:0]    _zz_biasInTemp_6_29;
  wire       [22:0]   _zz_biasInTemp_6_30;
  wire       [0:0]    _zz_biasInTemp_6_31;
  wire       [23:0]   _zz_biasInTemp_6_32;
  wire       [0:0]    _zz_biasInTemp_6_33;
  wire       [15:0]   _zz_dataInTemp_7;
  wire       [7:0]    _zz_biasInTemp_7;
  wire       [0:0]    _zz_biasInTemp_7_1;
  wire       [8:0]    _zz_biasInTemp_7_2;
  wire       [0:0]    _zz_biasInTemp_7_3;
  wire       [9:0]    _zz_biasInTemp_7_4;
  wire       [0:0]    _zz_biasInTemp_7_5;
  wire       [10:0]   _zz_biasInTemp_7_6;
  wire       [0:0]    _zz_biasInTemp_7_7;
  wire       [11:0]   _zz_biasInTemp_7_8;
  wire       [0:0]    _zz_biasInTemp_7_9;
  wire       [12:0]   _zz_biasInTemp_7_10;
  wire       [0:0]    _zz_biasInTemp_7_11;
  wire       [13:0]   _zz_biasInTemp_7_12;
  wire       [0:0]    _zz_biasInTemp_7_13;
  wire       [14:0]   _zz_biasInTemp_7_14;
  wire       [0:0]    _zz_biasInTemp_7_15;
  wire       [15:0]   _zz_biasInTemp_7_16;
  wire       [0:0]    _zz_biasInTemp_7_17;
  wire       [16:0]   _zz_biasInTemp_7_18;
  wire       [0:0]    _zz_biasInTemp_7_19;
  wire       [17:0]   _zz_biasInTemp_7_20;
  wire       [0:0]    _zz_biasInTemp_7_21;
  wire       [18:0]   _zz_biasInTemp_7_22;
  wire       [0:0]    _zz_biasInTemp_7_23;
  wire       [19:0]   _zz_biasInTemp_7_24;
  wire       [0:0]    _zz_biasInTemp_7_25;
  wire       [20:0]   _zz_biasInTemp_7_26;
  wire       [0:0]    _zz_biasInTemp_7_27;
  wire       [21:0]   _zz_biasInTemp_7_28;
  wire       [0:0]    _zz_biasInTemp_7_29;
  wire       [22:0]   _zz_biasInTemp_7_30;
  wire       [0:0]    _zz_biasInTemp_7_31;
  wire       [23:0]   _zz_biasInTemp_7_32;
  wire       [0:0]    _zz_biasInTemp_7_33;
  reg        [47:0]   dataInTemp_0;
  reg        [47:0]   dataInTemp_1;
  reg        [47:0]   dataInTemp_2;
  reg        [47:0]   dataInTemp_3;
  reg        [47:0]   dataInTemp_4;
  reg        [47:0]   dataInTemp_5;
  reg        [47:0]   dataInTemp_6;
  reg        [47:0]   dataInTemp_7;
  reg        [47:0]   biasInTemp_0;
  reg        [47:0]   biasInTemp_1;
  reg        [47:0]   biasInTemp_2;
  reg        [47:0]   biasInTemp_3;
  reg        [47:0]   biasInTemp_4;
  reg        [47:0]   biasInTemp_5;
  reg        [47:0]   biasInTemp_6;
  reg        [47:0]   biasInTemp_7;
  wire       [6:0]    switch_QuantModule_l83;
  wire       [6:0]    switch_QuantModule_l83_1;
  wire       [6:0]    switch_QuantModule_l83_2;
  wire       [6:0]    switch_QuantModule_l83_3;
  wire       [6:0]    switch_QuantModule_l83_4;
  wire       [6:0]    switch_QuantModule_l83_5;
  wire       [6:0]    switch_QuantModule_l83_6;
  wire       [6:0]    switch_QuantModule_l83_7;

  assign _zz_dataInTemp_0 = 16'h0;
  assign _zz_biasInTemp_0_1 = Bias_quan[31];
  assign _zz_biasInTemp_0 = {{7{_zz_biasInTemp_0_1[0]}}, _zz_biasInTemp_0_1};
  assign _zz_biasInTemp_0_3 = Bias_quan[31];
  assign _zz_biasInTemp_0_2 = {{8{_zz_biasInTemp_0_3[0]}}, _zz_biasInTemp_0_3};
  assign _zz_biasInTemp_0_5 = Bias_quan[31];
  assign _zz_biasInTemp_0_4 = {{9{_zz_biasInTemp_0_5[0]}}, _zz_biasInTemp_0_5};
  assign _zz_biasInTemp_0_7 = Bias_quan[31];
  assign _zz_biasInTemp_0_6 = {{10{_zz_biasInTemp_0_7[0]}}, _zz_biasInTemp_0_7};
  assign _zz_biasInTemp_0_9 = Bias_quan[31];
  assign _zz_biasInTemp_0_8 = {{11{_zz_biasInTemp_0_9[0]}}, _zz_biasInTemp_0_9};
  assign _zz_biasInTemp_0_11 = Bias_quan[31];
  assign _zz_biasInTemp_0_10 = {{12{_zz_biasInTemp_0_11[0]}}, _zz_biasInTemp_0_11};
  assign _zz_biasInTemp_0_13 = Bias_quan[31];
  assign _zz_biasInTemp_0_12 = {{13{_zz_biasInTemp_0_13[0]}}, _zz_biasInTemp_0_13};
  assign _zz_biasInTemp_0_15 = Bias_quan[31];
  assign _zz_biasInTemp_0_14 = {{14{_zz_biasInTemp_0_15[0]}}, _zz_biasInTemp_0_15};
  assign _zz_biasInTemp_0_17 = Bias_quan[31];
  assign _zz_biasInTemp_0_16 = {{15{_zz_biasInTemp_0_17[0]}}, _zz_biasInTemp_0_17};
  assign _zz_biasInTemp_0_19 = Bias_quan[31];
  assign _zz_biasInTemp_0_18 = {{16{_zz_biasInTemp_0_19[0]}}, _zz_biasInTemp_0_19};
  assign _zz_biasInTemp_0_21 = Bias_quan[31];
  assign _zz_biasInTemp_0_20 = {{17{_zz_biasInTemp_0_21[0]}}, _zz_biasInTemp_0_21};
  assign _zz_biasInTemp_0_23 = Bias_quan[31];
  assign _zz_biasInTemp_0_22 = {{18{_zz_biasInTemp_0_23[0]}}, _zz_biasInTemp_0_23};
  assign _zz_biasInTemp_0_25 = Bias_quan[31];
  assign _zz_biasInTemp_0_24 = {{19{_zz_biasInTemp_0_25[0]}}, _zz_biasInTemp_0_25};
  assign _zz_biasInTemp_0_27 = Bias_quan[31];
  assign _zz_biasInTemp_0_26 = {{20{_zz_biasInTemp_0_27[0]}}, _zz_biasInTemp_0_27};
  assign _zz_biasInTemp_0_29 = Bias_quan[31];
  assign _zz_biasInTemp_0_28 = {{21{_zz_biasInTemp_0_29[0]}}, _zz_biasInTemp_0_29};
  assign _zz_biasInTemp_0_31 = Bias_quan[31];
  assign _zz_biasInTemp_0_30 = {{22{_zz_biasInTemp_0_31[0]}}, _zz_biasInTemp_0_31};
  assign _zz_biasInTemp_0_33 = Bias_quan[31];
  assign _zz_biasInTemp_0_32 = {{23{_zz_biasInTemp_0_33[0]}}, _zz_biasInTemp_0_33};
  assign _zz_dataInTemp_1 = 16'h0;
  assign _zz_biasInTemp_1_1 = Bias_quan[31];
  assign _zz_biasInTemp_1 = {{7{_zz_biasInTemp_1_1[0]}}, _zz_biasInTemp_1_1};
  assign _zz_biasInTemp_1_3 = Bias_quan[31];
  assign _zz_biasInTemp_1_2 = {{8{_zz_biasInTemp_1_3[0]}}, _zz_biasInTemp_1_3};
  assign _zz_biasInTemp_1_5 = Bias_quan[31];
  assign _zz_biasInTemp_1_4 = {{9{_zz_biasInTemp_1_5[0]}}, _zz_biasInTemp_1_5};
  assign _zz_biasInTemp_1_7 = Bias_quan[31];
  assign _zz_biasInTemp_1_6 = {{10{_zz_biasInTemp_1_7[0]}}, _zz_biasInTemp_1_7};
  assign _zz_biasInTemp_1_9 = Bias_quan[31];
  assign _zz_biasInTemp_1_8 = {{11{_zz_biasInTemp_1_9[0]}}, _zz_biasInTemp_1_9};
  assign _zz_biasInTemp_1_11 = Bias_quan[31];
  assign _zz_biasInTemp_1_10 = {{12{_zz_biasInTemp_1_11[0]}}, _zz_biasInTemp_1_11};
  assign _zz_biasInTemp_1_13 = Bias_quan[31];
  assign _zz_biasInTemp_1_12 = {{13{_zz_biasInTemp_1_13[0]}}, _zz_biasInTemp_1_13};
  assign _zz_biasInTemp_1_15 = Bias_quan[31];
  assign _zz_biasInTemp_1_14 = {{14{_zz_biasInTemp_1_15[0]}}, _zz_biasInTemp_1_15};
  assign _zz_biasInTemp_1_17 = Bias_quan[31];
  assign _zz_biasInTemp_1_16 = {{15{_zz_biasInTemp_1_17[0]}}, _zz_biasInTemp_1_17};
  assign _zz_biasInTemp_1_19 = Bias_quan[31];
  assign _zz_biasInTemp_1_18 = {{16{_zz_biasInTemp_1_19[0]}}, _zz_biasInTemp_1_19};
  assign _zz_biasInTemp_1_21 = Bias_quan[31];
  assign _zz_biasInTemp_1_20 = {{17{_zz_biasInTemp_1_21[0]}}, _zz_biasInTemp_1_21};
  assign _zz_biasInTemp_1_23 = Bias_quan[31];
  assign _zz_biasInTemp_1_22 = {{18{_zz_biasInTemp_1_23[0]}}, _zz_biasInTemp_1_23};
  assign _zz_biasInTemp_1_25 = Bias_quan[31];
  assign _zz_biasInTemp_1_24 = {{19{_zz_biasInTemp_1_25[0]}}, _zz_biasInTemp_1_25};
  assign _zz_biasInTemp_1_27 = Bias_quan[31];
  assign _zz_biasInTemp_1_26 = {{20{_zz_biasInTemp_1_27[0]}}, _zz_biasInTemp_1_27};
  assign _zz_biasInTemp_1_29 = Bias_quan[31];
  assign _zz_biasInTemp_1_28 = {{21{_zz_biasInTemp_1_29[0]}}, _zz_biasInTemp_1_29};
  assign _zz_biasInTemp_1_31 = Bias_quan[31];
  assign _zz_biasInTemp_1_30 = {{22{_zz_biasInTemp_1_31[0]}}, _zz_biasInTemp_1_31};
  assign _zz_biasInTemp_1_33 = Bias_quan[31];
  assign _zz_biasInTemp_1_32 = {{23{_zz_biasInTemp_1_33[0]}}, _zz_biasInTemp_1_33};
  assign _zz_dataInTemp_2 = 16'h0;
  assign _zz_biasInTemp_2_1 = Bias_quan[31];
  assign _zz_biasInTemp_2 = {{7{_zz_biasInTemp_2_1[0]}}, _zz_biasInTemp_2_1};
  assign _zz_biasInTemp_2_3 = Bias_quan[31];
  assign _zz_biasInTemp_2_2 = {{8{_zz_biasInTemp_2_3[0]}}, _zz_biasInTemp_2_3};
  assign _zz_biasInTemp_2_5 = Bias_quan[31];
  assign _zz_biasInTemp_2_4 = {{9{_zz_biasInTemp_2_5[0]}}, _zz_biasInTemp_2_5};
  assign _zz_biasInTemp_2_7 = Bias_quan[31];
  assign _zz_biasInTemp_2_6 = {{10{_zz_biasInTemp_2_7[0]}}, _zz_biasInTemp_2_7};
  assign _zz_biasInTemp_2_9 = Bias_quan[31];
  assign _zz_biasInTemp_2_8 = {{11{_zz_biasInTemp_2_9[0]}}, _zz_biasInTemp_2_9};
  assign _zz_biasInTemp_2_11 = Bias_quan[31];
  assign _zz_biasInTemp_2_10 = {{12{_zz_biasInTemp_2_11[0]}}, _zz_biasInTemp_2_11};
  assign _zz_biasInTemp_2_13 = Bias_quan[31];
  assign _zz_biasInTemp_2_12 = {{13{_zz_biasInTemp_2_13[0]}}, _zz_biasInTemp_2_13};
  assign _zz_biasInTemp_2_15 = Bias_quan[31];
  assign _zz_biasInTemp_2_14 = {{14{_zz_biasInTemp_2_15[0]}}, _zz_biasInTemp_2_15};
  assign _zz_biasInTemp_2_17 = Bias_quan[31];
  assign _zz_biasInTemp_2_16 = {{15{_zz_biasInTemp_2_17[0]}}, _zz_biasInTemp_2_17};
  assign _zz_biasInTemp_2_19 = Bias_quan[31];
  assign _zz_biasInTemp_2_18 = {{16{_zz_biasInTemp_2_19[0]}}, _zz_biasInTemp_2_19};
  assign _zz_biasInTemp_2_21 = Bias_quan[31];
  assign _zz_biasInTemp_2_20 = {{17{_zz_biasInTemp_2_21[0]}}, _zz_biasInTemp_2_21};
  assign _zz_biasInTemp_2_23 = Bias_quan[31];
  assign _zz_biasInTemp_2_22 = {{18{_zz_biasInTemp_2_23[0]}}, _zz_biasInTemp_2_23};
  assign _zz_biasInTemp_2_25 = Bias_quan[31];
  assign _zz_biasInTemp_2_24 = {{19{_zz_biasInTemp_2_25[0]}}, _zz_biasInTemp_2_25};
  assign _zz_biasInTemp_2_27 = Bias_quan[31];
  assign _zz_biasInTemp_2_26 = {{20{_zz_biasInTemp_2_27[0]}}, _zz_biasInTemp_2_27};
  assign _zz_biasInTemp_2_29 = Bias_quan[31];
  assign _zz_biasInTemp_2_28 = {{21{_zz_biasInTemp_2_29[0]}}, _zz_biasInTemp_2_29};
  assign _zz_biasInTemp_2_31 = Bias_quan[31];
  assign _zz_biasInTemp_2_30 = {{22{_zz_biasInTemp_2_31[0]}}, _zz_biasInTemp_2_31};
  assign _zz_biasInTemp_2_33 = Bias_quan[31];
  assign _zz_biasInTemp_2_32 = {{23{_zz_biasInTemp_2_33[0]}}, _zz_biasInTemp_2_33};
  assign _zz_dataInTemp_3 = 16'h0;
  assign _zz_biasInTemp_3_1 = Bias_quan[31];
  assign _zz_biasInTemp_3 = {{7{_zz_biasInTemp_3_1[0]}}, _zz_biasInTemp_3_1};
  assign _zz_biasInTemp_3_3 = Bias_quan[31];
  assign _zz_biasInTemp_3_2 = {{8{_zz_biasInTemp_3_3[0]}}, _zz_biasInTemp_3_3};
  assign _zz_biasInTemp_3_5 = Bias_quan[31];
  assign _zz_biasInTemp_3_4 = {{9{_zz_biasInTemp_3_5[0]}}, _zz_biasInTemp_3_5};
  assign _zz_biasInTemp_3_7 = Bias_quan[31];
  assign _zz_biasInTemp_3_6 = {{10{_zz_biasInTemp_3_7[0]}}, _zz_biasInTemp_3_7};
  assign _zz_biasInTemp_3_9 = Bias_quan[31];
  assign _zz_biasInTemp_3_8 = {{11{_zz_biasInTemp_3_9[0]}}, _zz_biasInTemp_3_9};
  assign _zz_biasInTemp_3_11 = Bias_quan[31];
  assign _zz_biasInTemp_3_10 = {{12{_zz_biasInTemp_3_11[0]}}, _zz_biasInTemp_3_11};
  assign _zz_biasInTemp_3_13 = Bias_quan[31];
  assign _zz_biasInTemp_3_12 = {{13{_zz_biasInTemp_3_13[0]}}, _zz_biasInTemp_3_13};
  assign _zz_biasInTemp_3_15 = Bias_quan[31];
  assign _zz_biasInTemp_3_14 = {{14{_zz_biasInTemp_3_15[0]}}, _zz_biasInTemp_3_15};
  assign _zz_biasInTemp_3_17 = Bias_quan[31];
  assign _zz_biasInTemp_3_16 = {{15{_zz_biasInTemp_3_17[0]}}, _zz_biasInTemp_3_17};
  assign _zz_biasInTemp_3_19 = Bias_quan[31];
  assign _zz_biasInTemp_3_18 = {{16{_zz_biasInTemp_3_19[0]}}, _zz_biasInTemp_3_19};
  assign _zz_biasInTemp_3_21 = Bias_quan[31];
  assign _zz_biasInTemp_3_20 = {{17{_zz_biasInTemp_3_21[0]}}, _zz_biasInTemp_3_21};
  assign _zz_biasInTemp_3_23 = Bias_quan[31];
  assign _zz_biasInTemp_3_22 = {{18{_zz_biasInTemp_3_23[0]}}, _zz_biasInTemp_3_23};
  assign _zz_biasInTemp_3_25 = Bias_quan[31];
  assign _zz_biasInTemp_3_24 = {{19{_zz_biasInTemp_3_25[0]}}, _zz_biasInTemp_3_25};
  assign _zz_biasInTemp_3_27 = Bias_quan[31];
  assign _zz_biasInTemp_3_26 = {{20{_zz_biasInTemp_3_27[0]}}, _zz_biasInTemp_3_27};
  assign _zz_biasInTemp_3_29 = Bias_quan[31];
  assign _zz_biasInTemp_3_28 = {{21{_zz_biasInTemp_3_29[0]}}, _zz_biasInTemp_3_29};
  assign _zz_biasInTemp_3_31 = Bias_quan[31];
  assign _zz_biasInTemp_3_30 = {{22{_zz_biasInTemp_3_31[0]}}, _zz_biasInTemp_3_31};
  assign _zz_biasInTemp_3_33 = Bias_quan[31];
  assign _zz_biasInTemp_3_32 = {{23{_zz_biasInTemp_3_33[0]}}, _zz_biasInTemp_3_33};
  assign _zz_dataInTemp_4 = 16'h0;
  assign _zz_biasInTemp_4_1 = Bias_quan[31];
  assign _zz_biasInTemp_4 = {{7{_zz_biasInTemp_4_1[0]}}, _zz_biasInTemp_4_1};
  assign _zz_biasInTemp_4_3 = Bias_quan[31];
  assign _zz_biasInTemp_4_2 = {{8{_zz_biasInTemp_4_3[0]}}, _zz_biasInTemp_4_3};
  assign _zz_biasInTemp_4_5 = Bias_quan[31];
  assign _zz_biasInTemp_4_4 = {{9{_zz_biasInTemp_4_5[0]}}, _zz_biasInTemp_4_5};
  assign _zz_biasInTemp_4_7 = Bias_quan[31];
  assign _zz_biasInTemp_4_6 = {{10{_zz_biasInTemp_4_7[0]}}, _zz_biasInTemp_4_7};
  assign _zz_biasInTemp_4_9 = Bias_quan[31];
  assign _zz_biasInTemp_4_8 = {{11{_zz_biasInTemp_4_9[0]}}, _zz_biasInTemp_4_9};
  assign _zz_biasInTemp_4_11 = Bias_quan[31];
  assign _zz_biasInTemp_4_10 = {{12{_zz_biasInTemp_4_11[0]}}, _zz_biasInTemp_4_11};
  assign _zz_biasInTemp_4_13 = Bias_quan[31];
  assign _zz_biasInTemp_4_12 = {{13{_zz_biasInTemp_4_13[0]}}, _zz_biasInTemp_4_13};
  assign _zz_biasInTemp_4_15 = Bias_quan[31];
  assign _zz_biasInTemp_4_14 = {{14{_zz_biasInTemp_4_15[0]}}, _zz_biasInTemp_4_15};
  assign _zz_biasInTemp_4_17 = Bias_quan[31];
  assign _zz_biasInTemp_4_16 = {{15{_zz_biasInTemp_4_17[0]}}, _zz_biasInTemp_4_17};
  assign _zz_biasInTemp_4_19 = Bias_quan[31];
  assign _zz_biasInTemp_4_18 = {{16{_zz_biasInTemp_4_19[0]}}, _zz_biasInTemp_4_19};
  assign _zz_biasInTemp_4_21 = Bias_quan[31];
  assign _zz_biasInTemp_4_20 = {{17{_zz_biasInTemp_4_21[0]}}, _zz_biasInTemp_4_21};
  assign _zz_biasInTemp_4_23 = Bias_quan[31];
  assign _zz_biasInTemp_4_22 = {{18{_zz_biasInTemp_4_23[0]}}, _zz_biasInTemp_4_23};
  assign _zz_biasInTemp_4_25 = Bias_quan[31];
  assign _zz_biasInTemp_4_24 = {{19{_zz_biasInTemp_4_25[0]}}, _zz_biasInTemp_4_25};
  assign _zz_biasInTemp_4_27 = Bias_quan[31];
  assign _zz_biasInTemp_4_26 = {{20{_zz_biasInTemp_4_27[0]}}, _zz_biasInTemp_4_27};
  assign _zz_biasInTemp_4_29 = Bias_quan[31];
  assign _zz_biasInTemp_4_28 = {{21{_zz_biasInTemp_4_29[0]}}, _zz_biasInTemp_4_29};
  assign _zz_biasInTemp_4_31 = Bias_quan[31];
  assign _zz_biasInTemp_4_30 = {{22{_zz_biasInTemp_4_31[0]}}, _zz_biasInTemp_4_31};
  assign _zz_biasInTemp_4_33 = Bias_quan[31];
  assign _zz_biasInTemp_4_32 = {{23{_zz_biasInTemp_4_33[0]}}, _zz_biasInTemp_4_33};
  assign _zz_dataInTemp_5 = 16'h0;
  assign _zz_biasInTemp_5_1 = Bias_quan[31];
  assign _zz_biasInTemp_5 = {{7{_zz_biasInTemp_5_1[0]}}, _zz_biasInTemp_5_1};
  assign _zz_biasInTemp_5_3 = Bias_quan[31];
  assign _zz_biasInTemp_5_2 = {{8{_zz_biasInTemp_5_3[0]}}, _zz_biasInTemp_5_3};
  assign _zz_biasInTemp_5_5 = Bias_quan[31];
  assign _zz_biasInTemp_5_4 = {{9{_zz_biasInTemp_5_5[0]}}, _zz_biasInTemp_5_5};
  assign _zz_biasInTemp_5_7 = Bias_quan[31];
  assign _zz_biasInTemp_5_6 = {{10{_zz_biasInTemp_5_7[0]}}, _zz_biasInTemp_5_7};
  assign _zz_biasInTemp_5_9 = Bias_quan[31];
  assign _zz_biasInTemp_5_8 = {{11{_zz_biasInTemp_5_9[0]}}, _zz_biasInTemp_5_9};
  assign _zz_biasInTemp_5_11 = Bias_quan[31];
  assign _zz_biasInTemp_5_10 = {{12{_zz_biasInTemp_5_11[0]}}, _zz_biasInTemp_5_11};
  assign _zz_biasInTemp_5_13 = Bias_quan[31];
  assign _zz_biasInTemp_5_12 = {{13{_zz_biasInTemp_5_13[0]}}, _zz_biasInTemp_5_13};
  assign _zz_biasInTemp_5_15 = Bias_quan[31];
  assign _zz_biasInTemp_5_14 = {{14{_zz_biasInTemp_5_15[0]}}, _zz_biasInTemp_5_15};
  assign _zz_biasInTemp_5_17 = Bias_quan[31];
  assign _zz_biasInTemp_5_16 = {{15{_zz_biasInTemp_5_17[0]}}, _zz_biasInTemp_5_17};
  assign _zz_biasInTemp_5_19 = Bias_quan[31];
  assign _zz_biasInTemp_5_18 = {{16{_zz_biasInTemp_5_19[0]}}, _zz_biasInTemp_5_19};
  assign _zz_biasInTemp_5_21 = Bias_quan[31];
  assign _zz_biasInTemp_5_20 = {{17{_zz_biasInTemp_5_21[0]}}, _zz_biasInTemp_5_21};
  assign _zz_biasInTemp_5_23 = Bias_quan[31];
  assign _zz_biasInTemp_5_22 = {{18{_zz_biasInTemp_5_23[0]}}, _zz_biasInTemp_5_23};
  assign _zz_biasInTemp_5_25 = Bias_quan[31];
  assign _zz_biasInTemp_5_24 = {{19{_zz_biasInTemp_5_25[0]}}, _zz_biasInTemp_5_25};
  assign _zz_biasInTemp_5_27 = Bias_quan[31];
  assign _zz_biasInTemp_5_26 = {{20{_zz_biasInTemp_5_27[0]}}, _zz_biasInTemp_5_27};
  assign _zz_biasInTemp_5_29 = Bias_quan[31];
  assign _zz_biasInTemp_5_28 = {{21{_zz_biasInTemp_5_29[0]}}, _zz_biasInTemp_5_29};
  assign _zz_biasInTemp_5_31 = Bias_quan[31];
  assign _zz_biasInTemp_5_30 = {{22{_zz_biasInTemp_5_31[0]}}, _zz_biasInTemp_5_31};
  assign _zz_biasInTemp_5_33 = Bias_quan[31];
  assign _zz_biasInTemp_5_32 = {{23{_zz_biasInTemp_5_33[0]}}, _zz_biasInTemp_5_33};
  assign _zz_dataInTemp_6 = 16'h0;
  assign _zz_biasInTemp_6_1 = Bias_quan[31];
  assign _zz_biasInTemp_6 = {{7{_zz_biasInTemp_6_1[0]}}, _zz_biasInTemp_6_1};
  assign _zz_biasInTemp_6_3 = Bias_quan[31];
  assign _zz_biasInTemp_6_2 = {{8{_zz_biasInTemp_6_3[0]}}, _zz_biasInTemp_6_3};
  assign _zz_biasInTemp_6_5 = Bias_quan[31];
  assign _zz_biasInTemp_6_4 = {{9{_zz_biasInTemp_6_5[0]}}, _zz_biasInTemp_6_5};
  assign _zz_biasInTemp_6_7 = Bias_quan[31];
  assign _zz_biasInTemp_6_6 = {{10{_zz_biasInTemp_6_7[0]}}, _zz_biasInTemp_6_7};
  assign _zz_biasInTemp_6_9 = Bias_quan[31];
  assign _zz_biasInTemp_6_8 = {{11{_zz_biasInTemp_6_9[0]}}, _zz_biasInTemp_6_9};
  assign _zz_biasInTemp_6_11 = Bias_quan[31];
  assign _zz_biasInTemp_6_10 = {{12{_zz_biasInTemp_6_11[0]}}, _zz_biasInTemp_6_11};
  assign _zz_biasInTemp_6_13 = Bias_quan[31];
  assign _zz_biasInTemp_6_12 = {{13{_zz_biasInTemp_6_13[0]}}, _zz_biasInTemp_6_13};
  assign _zz_biasInTemp_6_15 = Bias_quan[31];
  assign _zz_biasInTemp_6_14 = {{14{_zz_biasInTemp_6_15[0]}}, _zz_biasInTemp_6_15};
  assign _zz_biasInTemp_6_17 = Bias_quan[31];
  assign _zz_biasInTemp_6_16 = {{15{_zz_biasInTemp_6_17[0]}}, _zz_biasInTemp_6_17};
  assign _zz_biasInTemp_6_19 = Bias_quan[31];
  assign _zz_biasInTemp_6_18 = {{16{_zz_biasInTemp_6_19[0]}}, _zz_biasInTemp_6_19};
  assign _zz_biasInTemp_6_21 = Bias_quan[31];
  assign _zz_biasInTemp_6_20 = {{17{_zz_biasInTemp_6_21[0]}}, _zz_biasInTemp_6_21};
  assign _zz_biasInTemp_6_23 = Bias_quan[31];
  assign _zz_biasInTemp_6_22 = {{18{_zz_biasInTemp_6_23[0]}}, _zz_biasInTemp_6_23};
  assign _zz_biasInTemp_6_25 = Bias_quan[31];
  assign _zz_biasInTemp_6_24 = {{19{_zz_biasInTemp_6_25[0]}}, _zz_biasInTemp_6_25};
  assign _zz_biasInTemp_6_27 = Bias_quan[31];
  assign _zz_biasInTemp_6_26 = {{20{_zz_biasInTemp_6_27[0]}}, _zz_biasInTemp_6_27};
  assign _zz_biasInTemp_6_29 = Bias_quan[31];
  assign _zz_biasInTemp_6_28 = {{21{_zz_biasInTemp_6_29[0]}}, _zz_biasInTemp_6_29};
  assign _zz_biasInTemp_6_31 = Bias_quan[31];
  assign _zz_biasInTemp_6_30 = {{22{_zz_biasInTemp_6_31[0]}}, _zz_biasInTemp_6_31};
  assign _zz_biasInTemp_6_33 = Bias_quan[31];
  assign _zz_biasInTemp_6_32 = {{23{_zz_biasInTemp_6_33[0]}}, _zz_biasInTemp_6_33};
  assign _zz_dataInTemp_7 = 16'h0;
  assign _zz_biasInTemp_7_1 = Bias_quan[31];
  assign _zz_biasInTemp_7 = {{7{_zz_biasInTemp_7_1[0]}}, _zz_biasInTemp_7_1};
  assign _zz_biasInTemp_7_3 = Bias_quan[31];
  assign _zz_biasInTemp_7_2 = {{8{_zz_biasInTemp_7_3[0]}}, _zz_biasInTemp_7_3};
  assign _zz_biasInTemp_7_5 = Bias_quan[31];
  assign _zz_biasInTemp_7_4 = {{9{_zz_biasInTemp_7_5[0]}}, _zz_biasInTemp_7_5};
  assign _zz_biasInTemp_7_7 = Bias_quan[31];
  assign _zz_biasInTemp_7_6 = {{10{_zz_biasInTemp_7_7[0]}}, _zz_biasInTemp_7_7};
  assign _zz_biasInTemp_7_9 = Bias_quan[31];
  assign _zz_biasInTemp_7_8 = {{11{_zz_biasInTemp_7_9[0]}}, _zz_biasInTemp_7_9};
  assign _zz_biasInTemp_7_11 = Bias_quan[31];
  assign _zz_biasInTemp_7_10 = {{12{_zz_biasInTemp_7_11[0]}}, _zz_biasInTemp_7_11};
  assign _zz_biasInTemp_7_13 = Bias_quan[31];
  assign _zz_biasInTemp_7_12 = {{13{_zz_biasInTemp_7_13[0]}}, _zz_biasInTemp_7_13};
  assign _zz_biasInTemp_7_15 = Bias_quan[31];
  assign _zz_biasInTemp_7_14 = {{14{_zz_biasInTemp_7_15[0]}}, _zz_biasInTemp_7_15};
  assign _zz_biasInTemp_7_17 = Bias_quan[31];
  assign _zz_biasInTemp_7_16 = {{15{_zz_biasInTemp_7_17[0]}}, _zz_biasInTemp_7_17};
  assign _zz_biasInTemp_7_19 = Bias_quan[31];
  assign _zz_biasInTemp_7_18 = {{16{_zz_biasInTemp_7_19[0]}}, _zz_biasInTemp_7_19};
  assign _zz_biasInTemp_7_21 = Bias_quan[31];
  assign _zz_biasInTemp_7_20 = {{17{_zz_biasInTemp_7_21[0]}}, _zz_biasInTemp_7_21};
  assign _zz_biasInTemp_7_23 = Bias_quan[31];
  assign _zz_biasInTemp_7_22 = {{18{_zz_biasInTemp_7_23[0]}}, _zz_biasInTemp_7_23};
  assign _zz_biasInTemp_7_25 = Bias_quan[31];
  assign _zz_biasInTemp_7_24 = {{19{_zz_biasInTemp_7_25[0]}}, _zz_biasInTemp_7_25};
  assign _zz_biasInTemp_7_27 = Bias_quan[31];
  assign _zz_biasInTemp_7_26 = {{20{_zz_biasInTemp_7_27[0]}}, _zz_biasInTemp_7_27};
  assign _zz_biasInTemp_7_29 = Bias_quan[31];
  assign _zz_biasInTemp_7_28 = {{21{_zz_biasInTemp_7_29[0]}}, _zz_biasInTemp_7_29};
  assign _zz_biasInTemp_7_31 = Bias_quan[31];
  assign _zz_biasInTemp_7_30 = {{22{_zz_biasInTemp_7_31[0]}}, _zz_biasInTemp_7_31};
  assign _zz_biasInTemp_7_33 = Bias_quan[31];
  assign _zz_biasInTemp_7_32 = {{23{_zz_biasInTemp_7_33[0]}}, _zz_biasInTemp_7_33};
  biasAdd addSub (
    .A   (dataInTemp_0[47:0]), //i
    .B   (biasInTemp_0[47:0]), //i
    .S   (addSub_S[47:0]    ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_1 (
    .A   (dataInTemp_1[47:0]), //i
    .B   (biasInTemp_1[47:0]), //i
    .S   (addSub_1_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_2 (
    .A   (dataInTemp_2[47:0]), //i
    .B   (biasInTemp_2[47:0]), //i
    .S   (addSub_2_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_3 (
    .A   (dataInTemp_3[47:0]), //i
    .B   (biasInTemp_3[47:0]), //i
    .S   (addSub_3_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_4 (
    .A   (dataInTemp_4[47:0]), //i
    .B   (biasInTemp_4[47:0]), //i
    .S   (addSub_4_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_5 (
    .A   (dataInTemp_5[47:0]), //i
    .B   (biasInTemp_5[47:0]), //i
    .S   (addSub_5_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_6 (
    .A   (dataInTemp_6[47:0]), //i
    .B   (biasInTemp_6[47:0]), //i
    .S   (addSub_6_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  biasAdd addSub_7 (
    .A   (dataInTemp_7[47:0]), //i
    .B   (biasInTemp_7[47:0]), //i
    .S   (addSub_7_S[47:0]  ), //o
    .CLK (clk               )  //i
  );
  assign switch_QuantModule_l83 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_1 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_2 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_3 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_4 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_5 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_6 = Bias_quan[30 : 24];
  assign switch_QuantModule_l83_7 = Bias_quan[30 : 24];
  assign Bias_dataOut_0 = addSub_S;
  assign Bias_dataOut_1 = addSub_1_S;
  assign Bias_dataOut_2 = addSub_2_S;
  assign Bias_dataOut_3 = addSub_3_S;
  assign Bias_dataOut_4 = addSub_4_S;
  assign Bias_dataOut_5 = addSub_5_S;
  assign Bias_dataOut_6 = addSub_6_S;
  assign Bias_dataOut_7 = addSub_7_S;
  always @(posedge clk) begin
    dataInTemp_0 <= {Bias_dataIn_0,_zz_dataInTemp_0};
    case(switch_QuantModule_l83)
      7'h0 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_0 <= {{_zz_biasInTemp_0_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_0 <= {_zz_biasInTemp_0_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_0 <= 48'h0;
      end
    endcase
    dataInTemp_1 <= {Bias_dataIn_1,_zz_dataInTemp_1};
    case(switch_QuantModule_l83_1)
      7'h0 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_1 <= {{_zz_biasInTemp_1_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_1 <= {_zz_biasInTemp_1_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_1 <= 48'h0;
      end
    endcase
    dataInTemp_2 <= {Bias_dataIn_2,_zz_dataInTemp_2};
    case(switch_QuantModule_l83_2)
      7'h0 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_2 <= {{_zz_biasInTemp_2_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_2 <= {_zz_biasInTemp_2_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_2 <= 48'h0;
      end
    endcase
    dataInTemp_3 <= {Bias_dataIn_3,_zz_dataInTemp_3};
    case(switch_QuantModule_l83_3)
      7'h0 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_3 <= {{_zz_biasInTemp_3_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_3 <= {_zz_biasInTemp_3_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_3 <= 48'h0;
      end
    endcase
    dataInTemp_4 <= {Bias_dataIn_4,_zz_dataInTemp_4};
    case(switch_QuantModule_l83_4)
      7'h0 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_4 <= {{_zz_biasInTemp_4_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_4 <= {_zz_biasInTemp_4_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_4 <= 48'h0;
      end
    endcase
    dataInTemp_5 <= {Bias_dataIn_5,_zz_dataInTemp_5};
    case(switch_QuantModule_l83_5)
      7'h0 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_5 <= {{_zz_biasInTemp_5_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_5 <= {_zz_biasInTemp_5_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_5 <= 48'h0;
      end
    endcase
    dataInTemp_6 <= {Bias_dataIn_6,_zz_dataInTemp_6};
    case(switch_QuantModule_l83_6)
      7'h0 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_6 <= {{_zz_biasInTemp_6_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_6 <= {_zz_biasInTemp_6_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_6 <= 48'h0;
      end
    endcase
    dataInTemp_7 <= {Bias_dataIn_7,_zz_dataInTemp_7};
    case(switch_QuantModule_l83_7)
      7'h0 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7,Bias_quan[23 : 0]},16'h0};
      end
      7'h01 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_2,Bias_quan[23 : 0]},15'h0};
      end
      7'h02 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_4,Bias_quan[23 : 0]},14'h0};
      end
      7'h03 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_6,Bias_quan[23 : 0]},13'h0};
      end
      7'h04 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_8,Bias_quan[23 : 0]},12'h0};
      end
      7'h05 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_10,Bias_quan[23 : 0]},11'h0};
      end
      7'h06 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_12,Bias_quan[23 : 0]},10'h0};
      end
      7'h07 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_14,Bias_quan[23 : 0]},9'h0};
      end
      7'h08 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_16,Bias_quan[23 : 0]},8'h0};
      end
      7'h09 : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_18,Bias_quan[23 : 0]},7'h0};
      end
      7'h0a : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_20,Bias_quan[23 : 0]},6'h0};
      end
      7'h0b : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_22,Bias_quan[23 : 0]},5'h0};
      end
      7'h0c : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_24,Bias_quan[23 : 0]},4'b0000};
      end
      7'h0d : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_26,Bias_quan[23 : 0]},3'b000};
      end
      7'h0e : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_28,Bias_quan[23 : 0]},2'b00};
      end
      7'h0f : begin
        biasInTemp_7 <= {{_zz_biasInTemp_7_30,Bias_quan[23 : 0]},1'b0};
      end
      7'h10 : begin
        biasInTemp_7 <= {_zz_biasInTemp_7_32,Bias_quan[23 : 0]};
      end
      default : begin
        biasInTemp_7 <= 48'h0;
      end
    endcase
  end


endmodule

//Scale_A_Fifo replaced by Scale_A_Fifo_7

//Scale_A_Fifo_1 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_2 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_3 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_4 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_5 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_6 replaced by Scale_A_Fifo_7

module Scale_A_Fifo_7 (
  input               io_push_valid,
  output              io_push_ready,
  input      [39:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [39:0]   io_pop_payload,
  input               io_flush,
  output     [7:0]    io_occupancy,
  output     [7:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [39:0]   _zz_logic_ram_port0;
  wire       [6:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [6:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [39:0]   _zz_logic_ram_port_1;
  wire       [6:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [6:0]    logic_pushPtr_valueNext;
  reg        [6:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [6:0]    logic_popPtr_valueNext;
  reg        [6:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1122;
  wire       [6:0]    logic_ptrDif;
  reg [39:0] logic_ram [0:127];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {6'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {6'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 7'h7f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 7'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 7'h7f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 7'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 7'h0;
      logic_popPtr_value <= 7'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

module WaddrOffset_Fifo_2 (
  input               io_push_valid,
  output              io_push_ready,
  input      [15:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [15:0]   io_pop_payload,
  input               io_flush,
  output reg [5:0]    io_occupancy,
  output reg [5:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [15:0]   _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [15:0]   _zz_logic_ram_port_1;
  wire       [5:0]    _zz_io_occupancy;
  wire       [5:0]    _zz_io_availability;
  wire       [5:0]    _zz_io_availability_1;
  wire       [5:0]    _zz_io_availability_2;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1122;
  wire       [5:0]    logic_ptrDif;
  reg [15:0] logic_ram [0:32];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_occupancy = (6'h21 + logic_ptrDif);
  assign _zz_io_availability = (6'h21 + _zz_io_availability_1);
  assign _zz_io_availability_1 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_availability_2 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h20);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    if(logic_pushPtr_willOverflow) begin
      logic_pushPtr_valueNext = 6'h0;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    end
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h20);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    if(logic_popPtr_willOverflow) begin
      logic_popPtr_valueNext = 6'h0;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    end
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1122 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  always @(*) begin
    if(logic_ptrMatch) begin
      io_occupancy = (logic_risingOccupancy ? 6'h21 : 6'h0);
    end else begin
      io_occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_io_occupancy);
    end
  end

  always @(*) begin
    if(logic_ptrMatch) begin
      io_availability = (logic_risingOccupancy ? 6'h0 : 6'h21);
    end else begin
      io_availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_io_availability : _zz_io_availability_2);
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1122) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
