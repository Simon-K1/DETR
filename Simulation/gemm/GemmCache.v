// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : GemmCache
// Git hash  : d42f1a3e0e73b77b3d560f5db402e42b8da7d992

`timescale 1ns/1ps

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
  localparam GEMM_ENUM_IDLE = 5'd1;
  localparam GEMM_ENUM_INIT = 5'd2;
  localparam GEMM_ENUM_WRITE = 5'd4;
  localparam GEMM_ENUM_READ = 5'd8;
  localparam GEMM_ENUM_CHECK = 5'd16;
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
  reg        [12:0]   reg_1;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                fsm_initEnd;
  wire                fsm_readFinish;
  wire                fsm_writeEnd;
  wire                fsm_judge;
  wire                fsm_otherWrite;
  wire                when_GEMM_l151;
  wire                writeend;
  reg                 Switch_regNext;
  reg                 Switch_regNext_1;
  wire                when_GEMM_l44;
  reg        [1:0]    rwfsm_currentState;
  reg        [1:0]    rwfsm_nextState;
  reg                 rwfsm_writeEnd;
  wire                when_WaCounter_l39;
  reg        [2:0]    initCount_count;
  wire                initCount_valid;
  reg        [15:0]   colCnt_count;
  wire                colCnt_valid;
  wire                when_WaCounter_l39_1;
  reg        [12:0]   rAddrCnt_count;
  wire                rAddrCnt_valid;
  reg        [11:0]   totalCnt_count;
  wire                totalCnt_valid;
  reg                 finish;
  wire                sData_fire;
  reg        [15:0]   OneColCnt_count;
  wire                OneColCnt_valid;
  reg        [9:0]    Write_Row_Base_Addr;
  reg        [7:0]    InData_Switch;
  wire                when_GEMM_l169;
  wire                sData_fire_1;
  reg                 _zz_1;
  reg                 writeend_delay_1;
  reg                 _zz_2;
  reg                 _zz_3;
  reg                 finish_delay_1;
  reg                 finish_regNext;
  reg        [63:0]   mdata_temp;
  wire                when_GEMM_l235;
  wire                sData_fire_2;
  wire                sData_fire_3;
  wire                when_GEMM_l235_1;
  wire                sData_fire_4;
  wire                sData_fire_5;
  wire                when_GEMM_l235_2;
  wire                sData_fire_6;
  wire                sData_fire_7;
  wire                when_GEMM_l235_3;
  wire                sData_fire_8;
  wire                sData_fire_9;
  wire                when_GEMM_l235_4;
  wire                sData_fire_10;
  wire                sData_fire_11;
  wire                when_GEMM_l235_5;
  wire                sData_fire_12;
  wire                sData_fire_13;
  wire                when_GEMM_l235_6;
  wire                sData_fire_14;
  wire                sData_fire_15;
  wire                when_GEMM_l235_7;
  wire                sData_fire_16;
  wire                sData_fire_17;
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
  wire                when_GEMM_l302;
  wire                when_GEMM_l308;
  reg                 _zz_4;
  wire                when_GEMM_l317;
  wire                when_GEMM_l317_1;
  wire                when_GEMM_l317_2;
  wire                when_GEMM_l317_3;
  wire                when_GEMM_l317_4;
  wire                when_GEMM_l317_5;
  wire                when_GEMM_l317_6;
  wire                when_GEMM_l317_7;
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
  wire                when_GEMM_l338;
  `ifndef SYNTHESIS
  reg [39:0] fsm_currentState_string;
  reg [39:0] fsm_nextState_string;
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
      GEMM_ENUM_IDLE : fsm_currentState_string = "IDLE ";
      GEMM_ENUM_INIT : fsm_currentState_string = "INIT ";
      GEMM_ENUM_WRITE : fsm_currentState_string = "WRITE";
      GEMM_ENUM_READ : fsm_currentState_string = "READ ";
      GEMM_ENUM_CHECK : fsm_currentState_string = "CHECK";
      default : fsm_currentState_string = "?????";
    endcase
  end
  always @(*) begin
    case(fsm_nextState)
      GEMM_ENUM_IDLE : fsm_nextState_string = "IDLE ";
      GEMM_ENUM_INIT : fsm_nextState_string = "INIT ";
      GEMM_ENUM_WRITE : fsm_nextState_string = "WRITE";
      GEMM_ENUM_READ : fsm_nextState_string = "READ ";
      GEMM_ENUM_CHECK : fsm_nextState_string = "CHECK";
      default : fsm_nextState_string = "?????";
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
        if(fsm_readFinish) begin
          fsm_nextState = GEMM_ENUM_IDLE;
        end else begin
          if(fsm_judge) begin
            fsm_nextState = GEMM_ENUM_CHECK;
          end else begin
            fsm_nextState = GEMM_ENUM_READ;
          end
        end
      end
      default : begin
        if(fsm_otherWrite) begin
          fsm_nextState = GEMM_ENUM_READ;
        end else begin
          fsm_nextState = GEMM_ENUM_CHECK;
        end
      end
    endcase
  end

  assign when_GEMM_l151 = ((fsm_currentState & GEMM_ENUM_IDLE) != 5'b00000);
  assign writeend = (((fsm_currentState & GEMM_ENUM_WRITE) != 5'b00000) && ((fsm_nextState & GEMM_ENUM_READ) != 5'b00000));
  assign when_GEMM_l44 = ((((! Switch) && Switch_regNext) || (Switch && (! Switch_regNext_1))) && ((fsm_currentState & GEMM_ENUM_IDLE) == 5'b00000));
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
        if(when_GEMM_l44) begin
          rwfsm_nextState = RW_ENUM_WRITE;
        end else begin
          rwfsm_nextState = RW_ENUM_IDLE;
        end
      end
    endcase
  end

  assign when_WaCounter_l39 = ((fsm_currentState & GEMM_ENUM_INIT) != 5'b00000);
  assign initCount_valid = ((initCount_count == 3'b101) && when_WaCounter_l39);
  assign colCnt_valid = ((colCnt_count == _zz_colCnt_valid) && validOut_0);
  assign when_WaCounter_l39_1 = ((fsm_currentState & GEMM_ENUM_READ) != 5'b00000);
  assign rAddrCnt_valid = ((rAddrCnt_count == _zz_rAddrCnt_valid) && when_WaCounter_l39_1);
  assign totalCnt_valid = ((totalCnt_count == _zz_totalCnt_valid) && rAddrCnt_valid);
  assign sData_fire = (sData_valid && sData_ready);
  assign OneColCnt_valid = ((OneColCnt_count == _zz_OneColCnt_valid) && sData_fire);
  assign when_GEMM_l169 = (totalCnt_valid && (reg_1 <= 13'h0008));
  always @(*) begin
    if(when_GEMM_l169) begin
      finish = 1'b1;
    end else begin
      finish = 1'b0;
    end
  end

  assign sData_fire_1 = (sData_valid && sData_ready);
  always @(*) begin
    rwfsm_writeEnd = colCnt_valid;
    if(when_GEMM_l308) begin
      rwfsm_writeEnd = 1'b1;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign fsm_judge = (totalCnt_valid && ((rwfsm_currentState & RW_ENUM_WRITE) != 2'b00));
  assign fsm_readFinish = finish;
  assign fsm_otherWrite = colCnt_valid;
  assign fsm_writeEnd = colCnt_valid;
  assign LayerEnd = finish_regNext;
  always @(*) begin
    xil_SimpleDualBram_addra = 10'h0;
    if(when_GEMM_l235) begin
      xil_SimpleDualBram_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_dina = 64'h0;
    if(when_GEMM_l235) begin
      xil_SimpleDualBram_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_ena = 1'b0;
    if(when_GEMM_l235) begin
      xil_SimpleDualBram_ena = (_zz_ena[0] && sData_fire_2);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_wea = 1'b1;
    if(when_GEMM_l235) begin
      xil_SimpleDualBram_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_addrb = 13'h0;
    if(when_GEMM_l235) begin
      xil_SimpleDualBram_1_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_addra = 10'h0;
    if(!when_GEMM_l235) begin
      xil_SimpleDualBram_1_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_dina = 64'h0;
    if(!when_GEMM_l235) begin
      xil_SimpleDualBram_1_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_ena = 1'b0;
    if(!when_GEMM_l235) begin
      xil_SimpleDualBram_1_ena = (_zz_ena_1[0] && sData_fire_3);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_1_wea = 1'b1;
    if(!when_GEMM_l235) begin
      xil_SimpleDualBram_1_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_addrb = 13'h0;
    if(!when_GEMM_l235) begin
      xil_SimpleDualBram_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235 = (Switch == 1'b0);
  assign sData_fire_2 = (sData_valid && sData_ready);
  always @(*) begin
    if(when_GEMM_l235) begin
      mdata_temp[7 : 0] = xil_SimpleDualBram_1_doutb;
    end else begin
      mdata_temp[7 : 0] = xil_SimpleDualBram_doutb;
    end
    if(when_GEMM_l235_1) begin
      mdata_temp[15 : 8] = xil_SimpleDualBram_3_doutb;
    end else begin
      mdata_temp[15 : 8] = xil_SimpleDualBram_2_doutb;
    end
    if(when_GEMM_l235_2) begin
      mdata_temp[23 : 16] = xil_SimpleDualBram_5_doutb;
    end else begin
      mdata_temp[23 : 16] = xil_SimpleDualBram_4_doutb;
    end
    if(when_GEMM_l235_3) begin
      mdata_temp[31 : 24] = xil_SimpleDualBram_7_doutb;
    end else begin
      mdata_temp[31 : 24] = xil_SimpleDualBram_6_doutb;
    end
    if(when_GEMM_l235_4) begin
      mdata_temp[39 : 32] = xil_SimpleDualBram_9_doutb;
    end else begin
      mdata_temp[39 : 32] = xil_SimpleDualBram_8_doutb;
    end
    if(when_GEMM_l235_5) begin
      mdata_temp[47 : 40] = xil_SimpleDualBram_11_doutb;
    end else begin
      mdata_temp[47 : 40] = xil_SimpleDualBram_10_doutb;
    end
    if(when_GEMM_l235_6) begin
      mdata_temp[55 : 48] = xil_SimpleDualBram_13_doutb;
    end else begin
      mdata_temp[55 : 48] = xil_SimpleDualBram_12_doutb;
    end
    if(when_GEMM_l235_7) begin
      mdata_temp[63 : 56] = xil_SimpleDualBram_15_doutb;
    end else begin
      mdata_temp[63 : 56] = xil_SimpleDualBram_14_doutb;
    end
  end

  assign sData_fire_3 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_2_addra = 10'h0;
    if(when_GEMM_l235_1) begin
      xil_SimpleDualBram_2_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_dina = 64'h0;
    if(when_GEMM_l235_1) begin
      xil_SimpleDualBram_2_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_ena = 1'b0;
    if(when_GEMM_l235_1) begin
      xil_SimpleDualBram_2_ena = (_zz_ena_2[0] && sData_fire_4);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_wea = 1'b1;
    if(when_GEMM_l235_1) begin
      xil_SimpleDualBram_2_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_addrb = 13'h0;
    if(when_GEMM_l235_1) begin
      xil_SimpleDualBram_3_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_addra = 10'h0;
    if(!when_GEMM_l235_1) begin
      xil_SimpleDualBram_3_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_dina = 64'h0;
    if(!when_GEMM_l235_1) begin
      xil_SimpleDualBram_3_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_ena = 1'b0;
    if(!when_GEMM_l235_1) begin
      xil_SimpleDualBram_3_ena = (_zz_ena_3[0] && sData_fire_5);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_3_wea = 1'b1;
    if(!when_GEMM_l235_1) begin
      xil_SimpleDualBram_3_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_2_addrb = 13'h0;
    if(!when_GEMM_l235_1) begin
      xil_SimpleDualBram_2_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_1 = (Switch == 1'b0);
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign sData_fire_5 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_4_addra = 10'h0;
    if(when_GEMM_l235_2) begin
      xil_SimpleDualBram_4_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_dina = 64'h0;
    if(when_GEMM_l235_2) begin
      xil_SimpleDualBram_4_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_ena = 1'b0;
    if(when_GEMM_l235_2) begin
      xil_SimpleDualBram_4_ena = (_zz_ena_4[0] && sData_fire_6);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_wea = 1'b1;
    if(when_GEMM_l235_2) begin
      xil_SimpleDualBram_4_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_addrb = 13'h0;
    if(when_GEMM_l235_2) begin
      xil_SimpleDualBram_5_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_addra = 10'h0;
    if(!when_GEMM_l235_2) begin
      xil_SimpleDualBram_5_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_dina = 64'h0;
    if(!when_GEMM_l235_2) begin
      xil_SimpleDualBram_5_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_ena = 1'b0;
    if(!when_GEMM_l235_2) begin
      xil_SimpleDualBram_5_ena = (_zz_ena_5[0] && sData_fire_7);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_5_wea = 1'b1;
    if(!when_GEMM_l235_2) begin
      xil_SimpleDualBram_5_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_4_addrb = 13'h0;
    if(!when_GEMM_l235_2) begin
      xil_SimpleDualBram_4_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_2 = (Switch == 1'b0);
  assign sData_fire_6 = (sData_valid && sData_ready);
  assign sData_fire_7 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_6_addra = 10'h0;
    if(when_GEMM_l235_3) begin
      xil_SimpleDualBram_6_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_dina = 64'h0;
    if(when_GEMM_l235_3) begin
      xil_SimpleDualBram_6_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_ena = 1'b0;
    if(when_GEMM_l235_3) begin
      xil_SimpleDualBram_6_ena = (_zz_ena_6[0] && sData_fire_8);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_wea = 1'b1;
    if(when_GEMM_l235_3) begin
      xil_SimpleDualBram_6_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_addrb = 13'h0;
    if(when_GEMM_l235_3) begin
      xil_SimpleDualBram_7_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_addra = 10'h0;
    if(!when_GEMM_l235_3) begin
      xil_SimpleDualBram_7_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_dina = 64'h0;
    if(!when_GEMM_l235_3) begin
      xil_SimpleDualBram_7_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_ena = 1'b0;
    if(!when_GEMM_l235_3) begin
      xil_SimpleDualBram_7_ena = (_zz_ena_7[0] && sData_fire_9);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_7_wea = 1'b1;
    if(!when_GEMM_l235_3) begin
      xil_SimpleDualBram_7_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_6_addrb = 13'h0;
    if(!when_GEMM_l235_3) begin
      xil_SimpleDualBram_6_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_3 = (Switch == 1'b0);
  assign sData_fire_8 = (sData_valid && sData_ready);
  assign sData_fire_9 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_8_addra = 10'h0;
    if(when_GEMM_l235_4) begin
      xil_SimpleDualBram_8_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_dina = 64'h0;
    if(when_GEMM_l235_4) begin
      xil_SimpleDualBram_8_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_ena = 1'b0;
    if(when_GEMM_l235_4) begin
      xil_SimpleDualBram_8_ena = (_zz_ena_8[0] && sData_fire_10);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_wea = 1'b1;
    if(when_GEMM_l235_4) begin
      xil_SimpleDualBram_8_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_addrb = 13'h0;
    if(when_GEMM_l235_4) begin
      xil_SimpleDualBram_9_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_addra = 10'h0;
    if(!when_GEMM_l235_4) begin
      xil_SimpleDualBram_9_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_dina = 64'h0;
    if(!when_GEMM_l235_4) begin
      xil_SimpleDualBram_9_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_ena = 1'b0;
    if(!when_GEMM_l235_4) begin
      xil_SimpleDualBram_9_ena = (_zz_ena_9[0] && sData_fire_11);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_9_wea = 1'b1;
    if(!when_GEMM_l235_4) begin
      xil_SimpleDualBram_9_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_8_addrb = 13'h0;
    if(!when_GEMM_l235_4) begin
      xil_SimpleDualBram_8_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_4 = (Switch == 1'b0);
  assign sData_fire_10 = (sData_valid && sData_ready);
  assign sData_fire_11 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_10_addra = 10'h0;
    if(when_GEMM_l235_5) begin
      xil_SimpleDualBram_10_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_dina = 64'h0;
    if(when_GEMM_l235_5) begin
      xil_SimpleDualBram_10_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_ena = 1'b0;
    if(when_GEMM_l235_5) begin
      xil_SimpleDualBram_10_ena = (_zz_ena_10[0] && sData_fire_12);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_wea = 1'b1;
    if(when_GEMM_l235_5) begin
      xil_SimpleDualBram_10_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_addrb = 13'h0;
    if(when_GEMM_l235_5) begin
      xil_SimpleDualBram_11_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_addra = 10'h0;
    if(!when_GEMM_l235_5) begin
      xil_SimpleDualBram_11_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_dina = 64'h0;
    if(!when_GEMM_l235_5) begin
      xil_SimpleDualBram_11_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_ena = 1'b0;
    if(!when_GEMM_l235_5) begin
      xil_SimpleDualBram_11_ena = (_zz_ena_11[0] && sData_fire_13);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_11_wea = 1'b1;
    if(!when_GEMM_l235_5) begin
      xil_SimpleDualBram_11_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_10_addrb = 13'h0;
    if(!when_GEMM_l235_5) begin
      xil_SimpleDualBram_10_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_5 = (Switch == 1'b0);
  assign sData_fire_12 = (sData_valid && sData_ready);
  assign sData_fire_13 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_12_addra = 10'h0;
    if(when_GEMM_l235_6) begin
      xil_SimpleDualBram_12_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_dina = 64'h0;
    if(when_GEMM_l235_6) begin
      xil_SimpleDualBram_12_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_ena = 1'b0;
    if(when_GEMM_l235_6) begin
      xil_SimpleDualBram_12_ena = (_zz_ena_12[0] && sData_fire_14);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_wea = 1'b1;
    if(when_GEMM_l235_6) begin
      xil_SimpleDualBram_12_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_addrb = 13'h0;
    if(when_GEMM_l235_6) begin
      xil_SimpleDualBram_13_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_addra = 10'h0;
    if(!when_GEMM_l235_6) begin
      xil_SimpleDualBram_13_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_dina = 64'h0;
    if(!when_GEMM_l235_6) begin
      xil_SimpleDualBram_13_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_ena = 1'b0;
    if(!when_GEMM_l235_6) begin
      xil_SimpleDualBram_13_ena = (_zz_ena_13[0] && sData_fire_15);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_13_wea = 1'b1;
    if(!when_GEMM_l235_6) begin
      xil_SimpleDualBram_13_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_12_addrb = 13'h0;
    if(!when_GEMM_l235_6) begin
      xil_SimpleDualBram_12_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_6 = (Switch == 1'b0);
  assign sData_fire_14 = (sData_valid && sData_ready);
  assign sData_fire_15 = (sData_valid && sData_ready);
  always @(*) begin
    xil_SimpleDualBram_14_addra = 10'h0;
    if(when_GEMM_l235_7) begin
      xil_SimpleDualBram_14_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_dina = 64'h0;
    if(when_GEMM_l235_7) begin
      xil_SimpleDualBram_14_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_ena = 1'b0;
    if(when_GEMM_l235_7) begin
      xil_SimpleDualBram_14_ena = (_zz_ena_14[0] && sData_fire_16);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_wea = 1'b1;
    if(when_GEMM_l235_7) begin
      xil_SimpleDualBram_14_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_addrb = 13'h0;
    if(when_GEMM_l235_7) begin
      xil_SimpleDualBram_15_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_addra = 10'h0;
    if(!when_GEMM_l235_7) begin
      xil_SimpleDualBram_15_addra = Write_Row_Base_Addr;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_dina = 64'h0;
    if(!when_GEMM_l235_7) begin
      xil_SimpleDualBram_15_dina = sData_payload;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_ena = 1'b0;
    if(!when_GEMM_l235_7) begin
      xil_SimpleDualBram_15_ena = (_zz_ena_15[0] && sData_fire_17);
    end
  end

  always @(*) begin
    xil_SimpleDualBram_15_wea = 1'b1;
    if(!when_GEMM_l235_7) begin
      xil_SimpleDualBram_15_wea = 1'b1;
    end
  end

  always @(*) begin
    xil_SimpleDualBram_14_addrb = 13'h0;
    if(!when_GEMM_l235_7) begin
      xil_SimpleDualBram_14_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMM_l235_7 = (Switch == 1'b0);
  assign sData_fire_16 = (sData_valid && sData_ready);
  assign sData_fire_17 = (sData_valid && sData_ready);
  assign when_GEMM_l302 = (((fsm_currentState & GEMM_ENUM_WRITE) != 5'b00000) || ((rwfsm_currentState & RW_ENUM_WRITE) != 2'b00));
  always @(*) begin
    if(when_GEMM_l302) begin
      sData_ready = 1'b1;
    end else begin
      sData_ready = 1'b0;
    end
  end

  assign when_GEMM_l308 = ((fsm_currentState & GEMM_ENUM_IDLE) != 5'b00000);
  always @(*) begin
    valid_0 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317) begin
        valid_0 = 1'b1;
      end else begin
        valid_0 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_1 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_1) begin
        valid_1 = 1'b1;
      end else begin
        valid_1 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_2 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_2) begin
        valid_2 = 1'b1;
      end else begin
        valid_2 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_3 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_3) begin
        valid_3 = 1'b1;
      end else begin
        valid_3 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_4 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_4) begin
        valid_4 = 1'b1;
      end else begin
        valid_4 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_5 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_5) begin
        valid_5 = 1'b1;
      end else begin
        valid_5 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_6 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_6) begin
        valid_6 = 1'b1;
      end else begin
        valid_6 = 1'b0;
      end
    end
  end

  always @(*) begin
    valid_7 = 1'b0;
    if(_zz_4) begin
      if(when_GEMM_l317_7) begin
        valid_7 = 1'b1;
      end else begin
        valid_7 = 1'b0;
      end
    end
  end

  assign when_GEMM_l317 = (13'h0 < reg_1);
  assign when_GEMM_l317_1 = (13'h0001 < reg_1);
  assign when_GEMM_l317_2 = (13'h0002 < reg_1);
  assign when_GEMM_l317_3 = (13'h0003 < reg_1);
  assign when_GEMM_l317_4 = (13'h0004 < reg_1);
  assign when_GEMM_l317_5 = (13'h0005 < reg_1);
  assign when_GEMM_l317_6 = (13'h0006 < reg_1);
  assign when_GEMM_l317_7 = (13'h0007 < reg_1);
  assign validOut_0 = valid_0;
  assign validOut_1 = valid_1_delay_1;
  assign validOut_2 = valid_2_delay_2;
  assign validOut_3 = valid_3_delay_3;
  assign validOut_4 = valid_4_delay_4;
  assign validOut_5 = valid_5_delay_5;
  assign validOut_6 = valid_6_delay_6;
  assign validOut_7 = valid_7_delay_7;
  assign when_GEMM_l338 = ((fsm_currentState & GEMM_ENUM_READ) != 5'b00000);
  always @(*) begin
    if(when_GEMM_l338) begin
      bvalid = 1'b1;
    end else begin
      bvalid = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Switch <= 1'b0;
      reg_1 <= 13'h0;
      fsm_currentState <= GEMM_ENUM_IDLE;
      rwfsm_currentState <= RW_ENUM_IDLE;
      initCount_count <= 3'b000;
      colCnt_count <= 16'h0;
      rAddrCnt_count <= 13'h0;
      totalCnt_count <= 12'h0;
      OneColCnt_count <= 16'h0;
      Write_Row_Base_Addr <= 10'h0;
      InData_Switch <= 8'h01;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_GEMM_l151) begin
        reg_1 <= HIGHT;
      end
      rwfsm_currentState <= rwfsm_nextState;
      if(when_WaCounter_l39) begin
        if(initCount_valid) begin
          initCount_count <= 3'b000;
        end else begin
          initCount_count <= (initCount_count + 3'b001);
        end
      end
      if(validOut_0) begin
        if(colCnt_valid) begin
          colCnt_count <= 16'h0;
        end else begin
          colCnt_count <= (colCnt_count + 16'h0001);
        end
      end
      if(when_WaCounter_l39_1) begin
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
      if(sData_fire) begin
        if(OneColCnt_valid) begin
          OneColCnt_count <= 16'h0;
        end else begin
          OneColCnt_count <= (OneColCnt_count + 16'h0001);
        end
      end
      if(sData_fire_1) begin
        Write_Row_Base_Addr <= (Write_Row_Base_Addr + 10'h001);
      end
      if(OneColCnt_valid) begin
        InData_Switch <= {InData_Switch[6 : 0],InData_Switch[7 : 7]};
        Write_Row_Base_Addr <= 10'h0;
      end
      if(_zz_1) begin
        reg_1 <= (reg_1 - 13'h0008);
      end
      if(writeend_delay_1) begin
        Switch <= (! Switch);
      end else begin
        if(_zz_2) begin
          Switch <= (! Switch);
        end else begin
          if(_zz_3) begin
            Switch <= (! Switch);
          end
        end
      end
      if(finish_delay_1) begin
        Switch <= (! Switch);
      end
    end
  end

  always @(posedge clk) begin
    Switch_regNext <= Switch;
    Switch_regNext_1 <= Switch;
    _zz_1 <= (totalCnt_valid && (! finish));
    writeend_delay_1 <= writeend;
    _zz_2 <= ((totalCnt_valid && ((rwfsm_currentState & RW_ENUM_IDLE) != 2'b00)) && (! finish));
    _zz_3 <= (colCnt_valid && ((fsm_currentState & GEMM_ENUM_CHECK) != 5'b00000));
    finish_delay_1 <= finish;
    finish_regNext <= finish;
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
    _zz_4 <= ((fsm_currentState & GEMM_ENUM_READ) != 5'b00000);
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
