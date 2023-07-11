// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : ConvArrangeV3
// Git hash  : 004d9e187bb1a9a81da41bc917389f312106aff9

`timescale 1ns/1ps

module ConvArrangeV3 (
  input      [63:0]   sData_0,
  input      [63:0]   sData_1,
  input      [63:0]   sData_2,
  input      [63:0]   sData_3,
  input      [63:0]   sData_4,
  input      [63:0]   sData_5,
  input      [63:0]   sData_6,
  input      [63:0]   sData_7,
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
  wire                axisDataConverter_inStream_valid;
  reg                 streamFifo_1_io_pop_ready;
  wire                axisDataConverter_1_inStream_valid;
  reg                 streamFifo_2_io_pop_ready;
  wire                axisDataConverter_2_inStream_valid;
  reg                 streamFifo_3_io_pop_ready;
  wire                axisDataConverter_3_inStream_valid;
  reg                 streamFifo_4_io_pop_ready;
  wire                axisDataConverter_4_inStream_valid;
  reg                 streamFifo_5_io_pop_ready;
  wire                axisDataConverter_5_inStream_valid;
  reg                 streamFifo_6_io_pop_ready;
  wire                axisDataConverter_6_inStream_valid;
  reg                 streamFifo_7_io_pop_ready;
  wire                axisDataConverter_7_inStream_valid;
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
  wire                axisDataConverter_inStream_ready;
  wire                axisDataConverter_outStream_valid;
  wire       [63:0]   axisDataConverter_outStream_payload;
  wire                streamFifo_1_io_push_ready;
  wire                streamFifo_1_io_pop_valid;
  wire       [63:0]   streamFifo_1_io_pop_payload;
  wire       [9:0]    streamFifo_1_io_occupancy;
  wire       [9:0]    streamFifo_1_io_availability;
  wire                axisDataConverter_1_inStream_ready;
  wire                axisDataConverter_1_outStream_valid;
  wire       [63:0]   axisDataConverter_1_outStream_payload;
  wire                streamFifo_2_io_push_ready;
  wire                streamFifo_2_io_pop_valid;
  wire       [63:0]   streamFifo_2_io_pop_payload;
  wire       [9:0]    streamFifo_2_io_occupancy;
  wire       [9:0]    streamFifo_2_io_availability;
  wire                axisDataConverter_2_inStream_ready;
  wire                axisDataConverter_2_outStream_valid;
  wire       [63:0]   axisDataConverter_2_outStream_payload;
  wire                streamFifo_3_io_push_ready;
  wire                streamFifo_3_io_pop_valid;
  wire       [63:0]   streamFifo_3_io_pop_payload;
  wire       [9:0]    streamFifo_3_io_occupancy;
  wire       [9:0]    streamFifo_3_io_availability;
  wire                axisDataConverter_3_inStream_ready;
  wire                axisDataConverter_3_outStream_valid;
  wire       [63:0]   axisDataConverter_3_outStream_payload;
  wire                streamFifo_4_io_push_ready;
  wire                streamFifo_4_io_pop_valid;
  wire       [63:0]   streamFifo_4_io_pop_payload;
  wire       [9:0]    streamFifo_4_io_occupancy;
  wire       [9:0]    streamFifo_4_io_availability;
  wire                axisDataConverter_4_inStream_ready;
  wire                axisDataConverter_4_outStream_valid;
  wire       [63:0]   axisDataConverter_4_outStream_payload;
  wire                streamFifo_5_io_push_ready;
  wire                streamFifo_5_io_pop_valid;
  wire       [63:0]   streamFifo_5_io_pop_payload;
  wire       [9:0]    streamFifo_5_io_occupancy;
  wire       [9:0]    streamFifo_5_io_availability;
  wire                axisDataConverter_5_inStream_ready;
  wire                axisDataConverter_5_outStream_valid;
  wire       [63:0]   axisDataConverter_5_outStream_payload;
  wire                streamFifo_6_io_push_ready;
  wire                streamFifo_6_io_pop_valid;
  wire       [63:0]   streamFifo_6_io_pop_payload;
  wire       [9:0]    streamFifo_6_io_occupancy;
  wire       [9:0]    streamFifo_6_io_availability;
  wire                axisDataConverter_6_inStream_ready;
  wire                axisDataConverter_6_outStream_valid;
  wire       [63:0]   axisDataConverter_6_outStream_payload;
  wire                streamFifo_7_io_push_ready;
  wire                streamFifo_7_io_pop_valid;
  wire       [63:0]   streamFifo_7_io_pop_payload;
  wire       [9:0]    streamFifo_7_io_occupancy;
  wire       [9:0]    streamFifo_7_io_availability;
  wire                axisDataConverter_7_inStream_ready;
  wire                axisDataConverter_7_outStream_valid;
  wire       [63:0]   axisDataConverter_7_outStream_payload;
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
    .io_push_valid   (axisDataConverter_outStream_valid        ), //i
    .io_push_ready   (streamFifo_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                     ), //i
    .io_occupancy    (streamFifo_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_io_availability[9:0]          ), //o
    .clk             (clk                                      ), //i
    .reset           (reset                                    )  //i
  );
  ConvOutput_Converter axisDataConverter (
    .inStream_valid    (axisDataConverter_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_inStream_ready         ), //o
    .inStream_payload  (sData_0[63:0]                            ), //i
    .outStream_valid   (axisDataConverter_outStream_valid        ), //o
    .outStream_ready   (streamFifo_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_1 (
    .io_push_valid   (axisDataConverter_1_outStream_valid        ), //i
    .io_push_ready   (streamFifo_1_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_1_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_1_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_1_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_1_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_1_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_1_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_1 (
    .inStream_valid    (axisDataConverter_1_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_1_inStream_ready         ), //o
    .inStream_payload  (sData_1[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_1_outStream_valid        ), //o
    .outStream_ready   (streamFifo_1_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_1_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_2 (
    .io_push_valid   (axisDataConverter_2_outStream_valid        ), //i
    .io_push_ready   (streamFifo_2_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_2_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_2_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_2_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_2_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_2_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_2_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_2 (
    .inStream_valid    (axisDataConverter_2_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_2_inStream_ready         ), //o
    .inStream_payload  (sData_2[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_2_outStream_valid        ), //o
    .outStream_ready   (streamFifo_2_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_2_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_3 (
    .io_push_valid   (axisDataConverter_3_outStream_valid        ), //i
    .io_push_ready   (streamFifo_3_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_3_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_3_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_3_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_3_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_3_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_3_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_3 (
    .inStream_valid    (axisDataConverter_3_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_3_inStream_ready         ), //o
    .inStream_payload  (sData_3[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_3_outStream_valid        ), //o
    .outStream_ready   (streamFifo_3_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_3_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_4 (
    .io_push_valid   (axisDataConverter_4_outStream_valid        ), //i
    .io_push_ready   (streamFifo_4_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_4_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_4_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_4_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_4_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_4_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_4_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_4 (
    .inStream_valid    (axisDataConverter_4_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_4_inStream_ready         ), //o
    .inStream_payload  (sData_4[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_4_outStream_valid        ), //o
    .outStream_ready   (streamFifo_4_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_4_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_5 (
    .io_push_valid   (axisDataConverter_5_outStream_valid        ), //i
    .io_push_ready   (streamFifo_5_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_5_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_5_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_5_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_5_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_5_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_5_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_5 (
    .inStream_valid    (axisDataConverter_5_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_5_inStream_ready         ), //o
    .inStream_payload  (sData_5[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_5_outStream_valid        ), //o
    .outStream_ready   (streamFifo_5_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_5_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_6 (
    .io_push_valid   (axisDataConverter_6_outStream_valid        ), //i
    .io_push_ready   (streamFifo_6_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_6_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_6_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_6_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_6_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_6_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_6_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_6 (
    .inStream_valid    (axisDataConverter_6_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_6_inStream_ready         ), //o
    .inStream_payload  (sData_6[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_6_outStream_valid        ), //o
    .outStream_ready   (streamFifo_6_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_6_outStream_payload[63:0])  //o
  );
  ConvOutput_Fifo streamFifo_7 (
    .io_push_valid   (axisDataConverter_7_outStream_valid        ), //i
    .io_push_ready   (streamFifo_7_io_push_ready                 ), //o
    .io_push_payload (axisDataConverter_7_outStream_payload[63:0]), //i
    .io_pop_valid    (streamFifo_7_io_pop_valid                  ), //o
    .io_pop_ready    (streamFifo_7_io_pop_ready                  ), //i
    .io_pop_payload  (streamFifo_7_io_pop_payload[63:0]          ), //o
    .io_flush        (1'b0                                       ), //i
    .io_occupancy    (streamFifo_7_io_occupancy[9:0]             ), //o
    .io_availability (streamFifo_7_io_availability[9:0]          ), //o
    .clk             (clk                                        ), //i
    .reset           (reset                                      )  //i
  );
  ConvOutput_Converter axisDataConverter_7 (
    .inStream_valid    (axisDataConverter_7_inStream_valid         ), //i
    .inStream_ready    (axisDataConverter_7_inStream_ready         ), //o
    .inStream_payload  (sData_7[63:0]                              ), //i
    .outStream_valid   (axisDataConverter_7_outStream_valid        ), //o
    .outStream_ready   (streamFifo_7_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_7_outStream_payload[63:0])  //o
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
  assign sReady = (axisDataConverter_inStream_ready && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  assign axisDataConverter_inStream_valid = (sValid[0] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131) begin
      streamFifo_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131 = _zz_when_SA3D_DataArrange_l131[0];
  assign axisDataConverter_1_inStream_valid = (sValid[1] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_1_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_1) begin
      streamFifo_1_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_1 = _zz_when_SA3D_DataArrange_l131_1[0];
  assign axisDataConverter_2_inStream_valid = (sValid[2] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_2_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_2) begin
      streamFifo_2_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_2 = _zz_when_SA3D_DataArrange_l131_2[0];
  assign axisDataConverter_3_inStream_valid = (sValid[3] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_3_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_3) begin
      streamFifo_3_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_3 = _zz_when_SA3D_DataArrange_l131_3[0];
  assign axisDataConverter_4_inStream_valid = (sValid[4] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_4_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_4) begin
      streamFifo_4_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_4 = _zz_when_SA3D_DataArrange_l131_4[0];
  assign axisDataConverter_5_inStream_valid = (sValid[5] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_5_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_5) begin
      streamFifo_5_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_5 = _zz_when_SA3D_DataArrange_l131_5[0];
  assign axisDataConverter_6_inStream_valid = (sValid[6] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_6_io_pop_ready = 1'b0;
    if(when_SA3D_DataArrange_l131_6) begin
      streamFifo_6_io_pop_ready = mData_ready;
    end
  end

  assign when_SA3D_DataArrange_l131_6 = _zz_when_SA3D_DataArrange_l131_6[0];
  assign axisDataConverter_7_inStream_valid = (sValid[7] && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
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
  input      [63:0]   inStream_payload,
  output              outStream_valid,
  input               outStream_ready,
  output     [63:0]   outStream_payload
);


  assign outStream_valid = inStream_valid;
  assign inStream_ready = outStream_ready;
  assign outStream_payload = inStream_payload;

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
      In_Row_Cnt_count <= MatrixRow;
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
  wire       [6:0]    _zz_InChannel_Cnt_valid_1;
  wire       [9:0]    _zz_InChannel_Cnt_valid_2;
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

  assign _zz_InChannel_Cnt_valid_1 = (_zz_InChannel_Cnt_valid_2 >>> 3);
  assign _zz_InChannel_Cnt_valid = {3'd0, _zz_InChannel_Cnt_valid_1};
  assign _zz_InChannel_Cnt_valid_2 = (OutChannel - 10'h001);
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
      In_Col_Cnt_count <= OutFeatureSize;
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


endmodule
