// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : SA_Conv
// Git hash  : 4dd181c0c4d23f6a65f460539ea5c18933e721dc

`timescale 1ns/1ps

module SA_Conv (
  input      [63:0]   activate,
  input               a_Valid_0,
  input               a_Valid_1,
  input               a_Valid_2,
  input               a_Valid_3,
  input               a_Valid_4,
  input               a_Valid_5,
  input               a_Valid_6,
  input               a_Valid_7,
  input      [63:0]   weight,
  input               b_Valid_0,
  input               b_Valid_1,
  input               b_Valid_2,
  input               b_Valid_3,
  input               b_Valid_4,
  input               b_Valid_5,
  input               b_Valid_6,
  input               b_Valid_7,
  input      [15:0]   signCount,
  input      [9:0]    In_Channel,
  input      [11:0]   Matrix_Col,
  input      [11:0]   Matrix_Row,
  input               start,
  output              LayerEnd,
  output              mData_valid,
  input               mData_ready,
  output     [63:0]   mData_payload,
  output              mLast,
  input               clk,
  input               reset
);

  reg        [63:0]   Tile_Output_sData;
  wire       [19:0]   Tile_1_PE_OUT_0;
  wire       [19:0]   Tile_1_PE_OUT_1;
  wire       [19:0]   Tile_1_PE_OUT_2;
  wire       [19:0]   Tile_1_PE_OUT_3;
  wire       [19:0]   Tile_1_PE_OUT_4;
  wire       [19:0]   Tile_1_PE_OUT_5;
  wire       [19:0]   Tile_1_PE_OUT_6;
  wire       [19:0]   Tile_1_PE_OUT_7;
  wire                Tile_1_resultVaild_0;
  wire                Tile_1_resultVaild_1;
  wire                Tile_1_resultVaild_2;
  wire                Tile_1_resultVaild_3;
  wire                Tile_1_resultVaild_4;
  wire                Tile_1_resultVaild_5;
  wire                Tile_1_resultVaild_6;
  wire                Tile_1_resultVaild_7;
  wire                Tile_Output_sReady;
  wire                Tile_Output_mData_valid;
  wire       [63:0]   Tile_Output_mData_payload;
  wire                Tile_Output_mLast;
  wire                Tile_Output_LayerEnd;
  wire       [7:0]    _zz_sData;
  wire       [7:0]    _zz_sData_1;
  wire       [7:0]    _zz_sData_2;
  wire       [7:0]    _zz_sData_3;
  wire       [7:0]    _zz_sData_4;
  wire       [7:0]    _zz_sData_5;
  wire       [7:0]    _zz_sData_6;
  wire       [7:0]    _zz_sData_7;

  assign _zz_sData = Tile_1_PE_OUT_0[7 : 0];
  assign _zz_sData_1 = Tile_1_PE_OUT_1[7 : 0];
  assign _zz_sData_2 = Tile_1_PE_OUT_2[7 : 0];
  assign _zz_sData_3 = Tile_1_PE_OUT_3[7 : 0];
  assign _zz_sData_4 = Tile_1_PE_OUT_4[7 : 0];
  assign _zz_sData_5 = Tile_1_PE_OUT_5[7 : 0];
  assign _zz_sData_6 = Tile_1_PE_OUT_6[7 : 0];
  assign _zz_sData_7 = Tile_1_PE_OUT_7[7 : 0];
  Tile Tile_1 (
    .activate      (activate[63:0]       ), //i
    .a_Valid_0     (a_Valid_0            ), //i
    .a_Valid_1     (a_Valid_1            ), //i
    .a_Valid_2     (a_Valid_2            ), //i
    .a_Valid_3     (a_Valid_3            ), //i
    .a_Valid_4     (a_Valid_4            ), //i
    .a_Valid_5     (a_Valid_5            ), //i
    .a_Valid_6     (a_Valid_6            ), //i
    .a_Valid_7     (a_Valid_7            ), //i
    .weight        (weight[63:0]         ), //i
    .b_Valid_0     (b_Valid_0            ), //i
    .b_Valid_1     (b_Valid_1            ), //i
    .b_Valid_2     (b_Valid_2            ), //i
    .b_Valid_3     (b_Valid_3            ), //i
    .b_Valid_4     (b_Valid_4            ), //i
    .b_Valid_5     (b_Valid_5            ), //i
    .b_Valid_6     (b_Valid_6            ), //i
    .b_Valid_7     (b_Valid_7            ), //i
    .signCount     (signCount[15:0]      ), //i
    .PE_OUT_0      (Tile_1_PE_OUT_0[19:0]), //o
    .PE_OUT_1      (Tile_1_PE_OUT_1[19:0]), //o
    .PE_OUT_2      (Tile_1_PE_OUT_2[19:0]), //o
    .PE_OUT_3      (Tile_1_PE_OUT_3[19:0]), //o
    .PE_OUT_4      (Tile_1_PE_OUT_4[19:0]), //o
    .PE_OUT_5      (Tile_1_PE_OUT_5[19:0]), //o
    .PE_OUT_6      (Tile_1_PE_OUT_6[19:0]), //o
    .PE_OUT_7      (Tile_1_PE_OUT_7[19:0]), //o
    .resultVaild_0 (Tile_1_resultVaild_0 ), //o
    .resultVaild_1 (Tile_1_resultVaild_1 ), //o
    .resultVaild_2 (Tile_1_resultVaild_2 ), //o
    .resultVaild_3 (Tile_1_resultVaild_3 ), //o
    .resultVaild_4 (Tile_1_resultVaild_4 ), //o
    .resultVaild_5 (Tile_1_resultVaild_5 ), //o
    .resultVaild_6 (Tile_1_resultVaild_6 ), //o
    .resultVaild_7 (Tile_1_resultVaild_7 ), //o
    .clk           (clk                  ), //i
    .reset         (reset                )  //i
  );
  ConvOutput Tile_Output (
    .sData         (Tile_Output_sData[63:0]        ), //i
    .sReady        (Tile_Output_sReady             ), //o
    .sValid        (Tile_1_resultVaild_0           ), //i
    .In_Channel    (In_Channel[9:0]                ), //i
    .Matrix_Col    (Matrix_Col[11:0]               ), //i
    .Matrix_Row    (Matrix_Row[11:0]               ), //i
    .mData_valid   (Tile_Output_mData_valid        ), //o
    .mData_ready   (mData_ready                    ), //i
    .mData_payload (Tile_Output_mData_payload[63:0]), //o
    .mLast         (Tile_Output_mLast              ), //o
    .LayerEnd      (Tile_Output_LayerEnd           ), //o
    .start         (start                          ), //i
    .clk           (clk                            ), //i
    .reset         (reset                          )  //i
  );
  always @(*) begin
    Tile_Output_sData[7 : 0] = _zz_sData;
    Tile_Output_sData[15 : 8] = _zz_sData_1;
    Tile_Output_sData[23 : 16] = _zz_sData_2;
    Tile_Output_sData[31 : 24] = _zz_sData_3;
    Tile_Output_sData[39 : 32] = _zz_sData_4;
    Tile_Output_sData[47 : 40] = _zz_sData_5;
    Tile_Output_sData[55 : 48] = _zz_sData_6;
    Tile_Output_sData[63 : 56] = _zz_sData_7;
  end

  assign LayerEnd = Tile_Output_LayerEnd;
  assign mData_valid = Tile_Output_mData_valid;
  assign mData_payload = Tile_Output_mData_payload;
  assign mLast = Tile_Output_mLast;

endmodule

module ConvOutput (
  input      [63:0]   sData,
  output              sReady,
  input               sValid,
  input      [9:0]    In_Channel,
  input      [11:0]   Matrix_Col,
  input      [11:0]   Matrix_Row,
  output reg          mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  output              mLast,
  output              LayerEnd,
  input               start,
  input               clk,
  input               reset
);
  localparam CONVOUTPUT_ENUM_IDLE = 4'd1;
  localparam CONVOUTPUT_ENUM_INIT = 4'd2;
  localparam CONVOUTPUT_ENUM_DATA_ARRANGEMENT = 4'd4;
  localparam CONVOUTPUT_ENUM_WAIT_END = 4'd8;

  reg                 streamFifo_io_pop_ready;
  wire                axisDataConverter_inStream_valid;
  wire       [7:0]    axisDataConverter_inStream_payload;
  reg                 streamFifo_1_io_pop_ready;
  wire                axisDataConverter_1_inStream_valid;
  wire       [7:0]    axisDataConverter_1_inStream_payload;
  reg                 streamFifo_2_io_pop_ready;
  wire                axisDataConverter_2_inStream_valid;
  wire       [7:0]    axisDataConverter_2_inStream_payload;
  reg                 streamFifo_3_io_pop_ready;
  wire                axisDataConverter_3_inStream_valid;
  wire       [7:0]    axisDataConverter_3_inStream_payload;
  reg                 streamFifo_4_io_pop_ready;
  wire                axisDataConverter_4_inStream_valid;
  wire       [7:0]    axisDataConverter_4_inStream_payload;
  reg                 streamFifo_5_io_pop_ready;
  wire                axisDataConverter_5_inStream_valid;
  wire       [7:0]    axisDataConverter_5_inStream_payload;
  reg                 streamFifo_6_io_pop_ready;
  wire                axisDataConverter_6_inStream_valid;
  wire       [7:0]    axisDataConverter_6_inStream_payload;
  reg                 streamFifo_7_io_pop_ready;
  wire                axisDataConverter_7_inStream_valid;
  wire       [7:0]    axisDataConverter_7_inStream_payload;
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
  wire       [11:0]   _zz_InChannel_Cnt_valid;
  wire       [9:0]    _zz_InChannel_Cnt_valid_1;
  wire       [11:0]   _zz_In_Col_Cnt_valid;
  wire       [11:0]   _zz_In_Col_Cnt_count_1;
  wire       [11:0]   _zz_In_Row_Cnt_valid;
  wire       [8:0]    _zz_OutChannel_Cnt_valid;
  wire       [6:0]    _zz_OutChannel_Cnt_valid_1;
  wire       [6:0]    _zz_OutChannel_Cnt_valid_2;
  wire       [11:0]   _zz_Out_Col_Cnt_valid;
  wire       [11:0]   _zz_Out_Row_Cnt_valid;
  wire       [0:0]    _zz_when_ConvOutput_l150;
  wire       [0:0]    _zz_when_ConvOutput_l150_1;
  wire       [0:0]    _zz_when_ConvOutput_l150_2;
  wire       [0:0]    _zz_when_ConvOutput_l150_3;
  wire       [0:0]    _zz_when_ConvOutput_l150_4;
  wire       [0:0]    _zz_when_ConvOutput_l150_5;
  wire       [0:0]    _zz_when_ConvOutput_l150_6;
  wire       [0:0]    _zz_when_ConvOutput_l150_7;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_Inited;
  wire                Fsm_LayerEnd;
  wire                Fsm_Data_AllOut;
  wire                when_WaCounter_l39;
  reg        [2:0]    Init_Cnt_count;
  wire                Init_Cnt_valid;
  wire                when_WaCounter_l39_1;
  reg        [11:0]   InChannel_Cnt_count;
  wire                InChannel_Cnt_valid;
  wire       [3:0]    _zz_In_Col_Cnt_count;
  reg        [11:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [11:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  wire                mData_fire;
  reg        [8:0]    OutChannel_Cnt_count;
  wire                OutChannel_Cnt_valid;
  reg        [11:0]   Out_Col_Cnt_count;
  wire                Out_Col_Cnt_valid;
  reg        [11:0]   Out_Row_Cnt_count;
  wire                Out_Row_Cnt_valid;
  reg        [7:0]    OutSwitch;
  wire                when_ConvOutput_l150;
  wire                when_ConvOutput_l150_1;
  wire                when_ConvOutput_l150_2;
  wire                when_ConvOutput_l150_3;
  wire                when_ConvOutput_l150_4;
  wire                when_ConvOutput_l150_5;
  wire                when_ConvOutput_l150_6;
  wire                when_ConvOutput_l150_7;
  `ifndef SYNTHESIS
  reg [127:0] Fsm_currentState_string;
  reg [127:0] Fsm_nextState_string;
  `endif


  assign _zz_InChannel_Cnt_valid_1 = (In_Channel - 10'h001);
  assign _zz_InChannel_Cnt_valid = {2'd0, _zz_InChannel_Cnt_valid_1};
  assign _zz_In_Col_Cnt_valid = {8'd0, _zz_In_Col_Cnt_count};
  assign _zz_In_Col_Cnt_count_1 = {8'd0, _zz_In_Col_Cnt_count};
  assign _zz_In_Row_Cnt_valid = (Matrix_Row - 12'h001);
  assign _zz_OutChannel_Cnt_valid_1 = (_zz_OutChannel_Cnt_valid_2 - 7'h01);
  assign _zz_OutChannel_Cnt_valid = {2'd0, _zz_OutChannel_Cnt_valid_1};
  assign _zz_OutChannel_Cnt_valid_2 = (In_Channel >>> 3);
  assign _zz_Out_Col_Cnt_valid = (Matrix_Row - 12'h001);
  assign _zz_Out_Row_Cnt_valid = (Matrix_Row - 12'h001);
  assign _zz_when_ConvOutput_l150 = OutSwitch[0 : 0];
  assign _zz_when_ConvOutput_l150_1 = OutSwitch[1 : 1];
  assign _zz_when_ConvOutput_l150_2 = OutSwitch[2 : 2];
  assign _zz_when_ConvOutput_l150_3 = OutSwitch[3 : 3];
  assign _zz_when_ConvOutput_l150_4 = OutSwitch[4 : 4];
  assign _zz_when_ConvOutput_l150_5 = OutSwitch[5 : 5];
  assign _zz_when_ConvOutput_l150_6 = OutSwitch[6 : 6];
  assign _zz_when_ConvOutput_l150_7 = OutSwitch[7 : 7];
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
    .inStream_payload  (axisDataConverter_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_outStream_valid        ), //o
    .outStream_ready   (streamFifo_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_outStream_payload[63:0]), //o
    .clk               (clk                                      ), //i
    .reset             (reset                                    )  //i
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
    .inStream_payload  (axisDataConverter_1_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_1_outStream_valid        ), //o
    .outStream_ready   (streamFifo_1_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_1_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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
    .inStream_payload  (axisDataConverter_2_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_2_outStream_valid        ), //o
    .outStream_ready   (streamFifo_2_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_2_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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
    .inStream_payload  (axisDataConverter_3_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_3_outStream_valid        ), //o
    .outStream_ready   (streamFifo_3_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_3_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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
    .inStream_payload  (axisDataConverter_4_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_4_outStream_valid        ), //o
    .outStream_ready   (streamFifo_4_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_4_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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
    .inStream_payload  (axisDataConverter_5_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_5_outStream_valid        ), //o
    .outStream_ready   (streamFifo_5_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_5_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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
    .inStream_payload  (axisDataConverter_6_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_6_outStream_valid        ), //o
    .outStream_ready   (streamFifo_6_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_6_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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
    .inStream_payload  (axisDataConverter_7_inStream_payload[7:0]  ), //i
    .outStream_valid   (axisDataConverter_7_outStream_valid        ), //o
    .outStream_ready   (streamFifo_7_io_push_ready                 ), //i
    .outStream_payload (axisDataConverter_7_outStream_payload[63:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
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

  assign when_WaCounter_l39 = ((Fsm_currentState & CONVOUTPUT_ENUM_INIT) != 4'b0000);
  assign Init_Cnt_valid = ((Init_Cnt_count == 3'b101) && when_WaCounter_l39);
  assign Fsm_Inited = Init_Cnt_valid;
  assign when_WaCounter_l39_1 = (sReady && sValid);
  assign InChannel_Cnt_valid = ((InChannel_Cnt_count == _zz_InChannel_Cnt_valid) && when_WaCounter_l39_1);
  assign _zz_In_Col_Cnt_count = 4'b1000;
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count <= _zz_In_Col_Cnt_valid) && InChannel_Cnt_valid);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && In_Col_Cnt_valid);
  assign Fsm_LayerEnd = In_Row_Cnt_valid;
  assign mData_fire = (mData_valid && mData_ready);
  assign OutChannel_Cnt_valid = ((OutChannel_Cnt_count == _zz_OutChannel_Cnt_valid) && mData_fire);
  assign Out_Col_Cnt_valid = ((Out_Col_Cnt_count == _zz_Out_Col_Cnt_valid) && OutChannel_Cnt_valid);
  assign Out_Row_Cnt_valid = ((Out_Row_Cnt_count == _zz_Out_Row_Cnt_valid) && Out_Col_Cnt_valid);
  assign Fsm_Data_AllOut = Out_Row_Cnt_valid;
  always @(*) begin
    mData_payload = 64'h0;
    if(when_ConvOutput_l150) begin
      mData_payload = streamFifo_io_pop_payload;
    end
    if(when_ConvOutput_l150_1) begin
      mData_payload = streamFifo_1_io_pop_payload;
    end
    if(when_ConvOutput_l150_2) begin
      mData_payload = streamFifo_2_io_pop_payload;
    end
    if(when_ConvOutput_l150_3) begin
      mData_payload = streamFifo_3_io_pop_payload;
    end
    if(when_ConvOutput_l150_4) begin
      mData_payload = streamFifo_4_io_pop_payload;
    end
    if(when_ConvOutput_l150_5) begin
      mData_payload = streamFifo_5_io_pop_payload;
    end
    if(when_ConvOutput_l150_6) begin
      mData_payload = streamFifo_6_io_pop_payload;
    end
    if(when_ConvOutput_l150_7) begin
      mData_payload = streamFifo_7_io_pop_payload;
    end
  end

  always @(*) begin
    mData_valid = 1'b0;
    if(when_ConvOutput_l150) begin
      mData_valid = streamFifo_io_pop_valid;
    end
    if(when_ConvOutput_l150_1) begin
      mData_valid = streamFifo_1_io_pop_valid;
    end
    if(when_ConvOutput_l150_2) begin
      mData_valid = streamFifo_2_io_pop_valid;
    end
    if(when_ConvOutput_l150_3) begin
      mData_valid = streamFifo_3_io_pop_valid;
    end
    if(when_ConvOutput_l150_4) begin
      mData_valid = streamFifo_4_io_pop_valid;
    end
    if(when_ConvOutput_l150_5) begin
      mData_valid = streamFifo_5_io_pop_valid;
    end
    if(when_ConvOutput_l150_6) begin
      mData_valid = streamFifo_6_io_pop_valid;
    end
    if(when_ConvOutput_l150_7) begin
      mData_valid = streamFifo_7_io_pop_valid;
    end
  end

  assign axisDataConverter_inStream_payload = sData[7 : 0];
  assign sReady = (axisDataConverter_inStream_ready && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  assign axisDataConverter_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150) begin
      streamFifo_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150 = _zz_when_ConvOutput_l150[0];
  assign axisDataConverter_1_inStream_payload = sData[15 : 8];
  assign axisDataConverter_1_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_1_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_1) begin
      streamFifo_1_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_1 = _zz_when_ConvOutput_l150_1[0];
  assign axisDataConverter_2_inStream_payload = sData[23 : 16];
  assign axisDataConverter_2_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_2_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_2) begin
      streamFifo_2_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_2 = _zz_when_ConvOutput_l150_2[0];
  assign axisDataConverter_3_inStream_payload = sData[31 : 24];
  assign axisDataConverter_3_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_3_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_3) begin
      streamFifo_3_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_3 = _zz_when_ConvOutput_l150_3[0];
  assign axisDataConverter_4_inStream_payload = sData[39 : 32];
  assign axisDataConverter_4_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_4_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_4) begin
      streamFifo_4_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_4 = _zz_when_ConvOutput_l150_4[0];
  assign axisDataConverter_5_inStream_payload = sData[47 : 40];
  assign axisDataConverter_5_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_5_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_5) begin
      streamFifo_5_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_5 = _zz_when_ConvOutput_l150_5[0];
  assign axisDataConverter_6_inStream_payload = sData[55 : 48];
  assign axisDataConverter_6_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_6_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_6) begin
      streamFifo_6_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_6 = _zz_when_ConvOutput_l150_6[0];
  assign axisDataConverter_7_inStream_payload = sData[63 : 56];
  assign axisDataConverter_7_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_7_io_pop_ready = 1'b0;
    if(when_ConvOutput_l150_7) begin
      streamFifo_7_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l150_7 = _zz_when_ConvOutput_l150_7[0];
  assign mLast = Fsm_Data_AllOut;
  assign LayerEnd = Fsm_Data_AllOut;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= CONVOUTPUT_ENUM_IDLE;
      Init_Cnt_count <= 3'b000;
      InChannel_Cnt_count <= 12'h0;
      In_Col_Cnt_count <= Matrix_Col;
      In_Row_Cnt_count <= 12'h0;
      OutChannel_Cnt_count <= 9'h0;
      Out_Col_Cnt_count <= 12'h0;
      Out_Row_Cnt_count <= 12'h0;
      OutSwitch <= 8'h01;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l39) begin
        if(Init_Cnt_valid) begin
          Init_Cnt_count <= 3'b000;
        end else begin
          Init_Cnt_count <= (Init_Cnt_count + 3'b001);
        end
      end
      if(when_WaCounter_l39_1) begin
        if(InChannel_Cnt_valid) begin
          InChannel_Cnt_count <= 12'h0;
        end else begin
          InChannel_Cnt_count <= (InChannel_Cnt_count + 12'h001);
        end
      end
      if(InChannel_Cnt_valid) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= Matrix_Col;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count - _zz_In_Col_Cnt_count_1);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 12'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 12'h001);
        end
      end
      if(mData_fire) begin
        if(OutChannel_Cnt_valid) begin
          OutChannel_Cnt_count <= 9'h0;
        end else begin
          OutChannel_Cnt_count <= (OutChannel_Cnt_count + 9'h001);
        end
      end
      if(OutChannel_Cnt_valid) begin
        if(Out_Col_Cnt_valid) begin
          Out_Col_Cnt_count <= 12'h0;
        end else begin
          Out_Col_Cnt_count <= (Out_Col_Cnt_count + 12'h001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        if(Out_Row_Cnt_valid) begin
          Out_Row_Cnt_count <= 12'h0;
        end else begin
          Out_Row_Cnt_count <= (Out_Row_Cnt_count + 12'h001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        OutSwitch <= 8'h01;
      end else begin
        if(OutChannel_Cnt_valid) begin
          OutSwitch <= {OutSwitch[6 : 0],OutSwitch[7 : 7]};
        end
      end
    end
  end


endmodule

module Tile (
  input      [63:0]   activate,
  input               a_Valid_0,
  input               a_Valid_1,
  input               a_Valid_2,
  input               a_Valid_3,
  input               a_Valid_4,
  input               a_Valid_5,
  input               a_Valid_6,
  input               a_Valid_7,
  input      [63:0]   weight,
  input               b_Valid_0,
  input               b_Valid_1,
  input               b_Valid_2,
  input               b_Valid_3,
  input               b_Valid_4,
  input               b_Valid_5,
  input               b_Valid_6,
  input               b_Valid_7,
  input      [15:0]   signCount,
  output     [19:0]   PE_OUT_0,
  output     [19:0]   PE_OUT_1,
  output     [19:0]   PE_OUT_2,
  output     [19:0]   PE_OUT_3,
  output     [19:0]   PE_OUT_4,
  output     [19:0]   PE_OUT_5,
  output     [19:0]   PE_OUT_6,
  output     [19:0]   PE_OUT_7,
  output              resultVaild_0,
  output              resultVaild_1,
  output              resultVaild_2,
  output              resultVaild_3,
  output              resultVaild_4,
  output              resultVaild_5,
  output              resultVaild_6,
  output              resultVaild_7,
  input               clk,
  input               reset
);

  wire       [7:0]    pE_64_activate;
  wire       [7:0]    pE_64_weight;
  wire                pE_64_vaild;
  wire       [7:0]    left_activate;
  wire                left_vaild;
  wire       [7:0]    left_1_activate;
  wire                left_1_vaild;
  wire       [7:0]    left_2_activate;
  wire                left_2_vaild;
  wire       [7:0]    left_3_activate;
  wire                left_3_vaild;
  wire       [7:0]    left_4_activate;
  wire                left_4_vaild;
  wire       [7:0]    left_5_activate;
  wire                left_5_vaild;
  wire       [7:0]    left_6_activate;
  wire                left_6_vaild;
  wire                top_vaild;
  wire                top_1_vaild;
  wire                top_2_vaild;
  wire                top_3_vaild;
  wire                top_4_vaild;
  wire                top_5_vaild;
  wire                top_6_vaild;
  wire                mid_vaild;
  wire                mid_1_vaild;
  wire                mid_2_vaild;
  wire                mid_3_vaild;
  wire                mid_4_vaild;
  wire                mid_5_vaild;
  wire                mid_6_vaild;
  wire                mid_7_vaild;
  wire                mid_8_vaild;
  wire                mid_9_vaild;
  wire                mid_10_vaild;
  wire                mid_11_vaild;
  wire                mid_12_vaild;
  wire                mid_13_vaild;
  wire                mid_14_vaild;
  wire                mid_15_vaild;
  wire                mid_16_vaild;
  wire                mid_17_vaild;
  wire                mid_18_vaild;
  wire                mid_19_vaild;
  wire                mid_20_vaild;
  wire                mid_21_vaild;
  wire                mid_22_vaild;
  wire                mid_23_vaild;
  wire                mid_24_vaild;
  wire                mid_25_vaild;
  wire                mid_26_vaild;
  wire                mid_27_vaild;
  wire                mid_28_vaild;
  wire                mid_29_vaild;
  wire                mid_30_vaild;
  wire                mid_31_vaild;
  wire                mid_32_vaild;
  wire                mid_33_vaild;
  wire                mid_34_vaild;
  wire                mid_35_vaild;
  wire                mid_36_vaild;
  wire                mid_37_vaild;
  wire                mid_38_vaild;
  wire                mid_39_vaild;
  wire                mid_40_vaild;
  wire                mid_41_vaild;
  wire                mid_42_vaild;
  wire                mid_43_vaild;
  wire                mid_44_vaild;
  wire                mid_45_vaild;
  wire                mid_46_vaild;
  wire                mid_47_vaild;
  wire                mid_48_vaild;
  wire       [7:0]    pE_64_acount;
  wire       [7:0]    pE_64_bcount;
  wire       [19:0]   pE_64_PE_OUT;
  wire                pE_64_finish;
  wire       [7:0]    left_acount;
  wire       [7:0]    left_bcount;
  wire       [19:0]   left_PE_OUT;
  wire                left_finish;
  wire       [7:0]    left_1_acount;
  wire       [7:0]    left_1_bcount;
  wire       [19:0]   left_1_PE_OUT;
  wire                left_1_finish;
  wire       [7:0]    left_2_acount;
  wire       [7:0]    left_2_bcount;
  wire       [19:0]   left_2_PE_OUT;
  wire                left_2_finish;
  wire       [7:0]    left_3_acount;
  wire       [7:0]    left_3_bcount;
  wire       [19:0]   left_3_PE_OUT;
  wire                left_3_finish;
  wire       [7:0]    left_4_acount;
  wire       [7:0]    left_4_bcount;
  wire       [19:0]   left_4_PE_OUT;
  wire                left_4_finish;
  wire       [7:0]    left_5_acount;
  wire       [7:0]    left_5_bcount;
  wire       [19:0]   left_5_PE_OUT;
  wire                left_5_finish;
  wire       [7:0]    left_6_acount;
  wire       [7:0]    left_6_bcount;
  wire       [19:0]   left_6_PE_OUT;
  wire                left_6_finish;
  wire       [7:0]    top_acount;
  wire       [7:0]    top_bcount;
  wire       [19:0]   top_PE_OUT;
  wire                top_finish;
  wire       [7:0]    top_1_acount;
  wire       [7:0]    top_1_bcount;
  wire       [19:0]   top_1_PE_OUT;
  wire                top_1_finish;
  wire       [7:0]    top_2_acount;
  wire       [7:0]    top_2_bcount;
  wire       [19:0]   top_2_PE_OUT;
  wire                top_2_finish;
  wire       [7:0]    top_3_acount;
  wire       [7:0]    top_3_bcount;
  wire       [19:0]   top_3_PE_OUT;
  wire                top_3_finish;
  wire       [7:0]    top_4_acount;
  wire       [7:0]    top_4_bcount;
  wire       [19:0]   top_4_PE_OUT;
  wire                top_4_finish;
  wire       [7:0]    top_5_acount;
  wire       [7:0]    top_5_bcount;
  wire       [19:0]   top_5_PE_OUT;
  wire                top_5_finish;
  wire       [7:0]    top_6_acount;
  wire       [7:0]    top_6_bcount;
  wire       [19:0]   top_6_PE_OUT;
  wire                top_6_finish;
  wire       [7:0]    mid_acount;
  wire       [7:0]    mid_bcount;
  wire       [19:0]   mid_PE_OUT;
  wire                mid_finish;
  wire       [7:0]    mid_1_acount;
  wire       [7:0]    mid_1_bcount;
  wire       [19:0]   mid_1_PE_OUT;
  wire                mid_1_finish;
  wire       [7:0]    mid_2_acount;
  wire       [7:0]    mid_2_bcount;
  wire       [19:0]   mid_2_PE_OUT;
  wire                mid_2_finish;
  wire       [7:0]    mid_3_acount;
  wire       [7:0]    mid_3_bcount;
  wire       [19:0]   mid_3_PE_OUT;
  wire                mid_3_finish;
  wire       [7:0]    mid_4_acount;
  wire       [7:0]    mid_4_bcount;
  wire       [19:0]   mid_4_PE_OUT;
  wire                mid_4_finish;
  wire       [7:0]    mid_5_acount;
  wire       [7:0]    mid_5_bcount;
  wire       [19:0]   mid_5_PE_OUT;
  wire                mid_5_finish;
  wire       [7:0]    mid_6_acount;
  wire       [7:0]    mid_6_bcount;
  wire       [19:0]   mid_6_PE_OUT;
  wire                mid_6_finish;
  wire       [7:0]    mid_7_acount;
  wire       [7:0]    mid_7_bcount;
  wire       [19:0]   mid_7_PE_OUT;
  wire                mid_7_finish;
  wire       [7:0]    mid_8_acount;
  wire       [7:0]    mid_8_bcount;
  wire       [19:0]   mid_8_PE_OUT;
  wire                mid_8_finish;
  wire       [7:0]    mid_9_acount;
  wire       [7:0]    mid_9_bcount;
  wire       [19:0]   mid_9_PE_OUT;
  wire                mid_9_finish;
  wire       [7:0]    mid_10_acount;
  wire       [7:0]    mid_10_bcount;
  wire       [19:0]   mid_10_PE_OUT;
  wire                mid_10_finish;
  wire       [7:0]    mid_11_acount;
  wire       [7:0]    mid_11_bcount;
  wire       [19:0]   mid_11_PE_OUT;
  wire                mid_11_finish;
  wire       [7:0]    mid_12_acount;
  wire       [7:0]    mid_12_bcount;
  wire       [19:0]   mid_12_PE_OUT;
  wire                mid_12_finish;
  wire       [7:0]    mid_13_acount;
  wire       [7:0]    mid_13_bcount;
  wire       [19:0]   mid_13_PE_OUT;
  wire                mid_13_finish;
  wire       [7:0]    mid_14_acount;
  wire       [7:0]    mid_14_bcount;
  wire       [19:0]   mid_14_PE_OUT;
  wire                mid_14_finish;
  wire       [7:0]    mid_15_acount;
  wire       [7:0]    mid_15_bcount;
  wire       [19:0]   mid_15_PE_OUT;
  wire                mid_15_finish;
  wire       [7:0]    mid_16_acount;
  wire       [7:0]    mid_16_bcount;
  wire       [19:0]   mid_16_PE_OUT;
  wire                mid_16_finish;
  wire       [7:0]    mid_17_acount;
  wire       [7:0]    mid_17_bcount;
  wire       [19:0]   mid_17_PE_OUT;
  wire                mid_17_finish;
  wire       [7:0]    mid_18_acount;
  wire       [7:0]    mid_18_bcount;
  wire       [19:0]   mid_18_PE_OUT;
  wire                mid_18_finish;
  wire       [7:0]    mid_19_acount;
  wire       [7:0]    mid_19_bcount;
  wire       [19:0]   mid_19_PE_OUT;
  wire                mid_19_finish;
  wire       [7:0]    mid_20_acount;
  wire       [7:0]    mid_20_bcount;
  wire       [19:0]   mid_20_PE_OUT;
  wire                mid_20_finish;
  wire       [7:0]    mid_21_acount;
  wire       [7:0]    mid_21_bcount;
  wire       [19:0]   mid_21_PE_OUT;
  wire                mid_21_finish;
  wire       [7:0]    mid_22_acount;
  wire       [7:0]    mid_22_bcount;
  wire       [19:0]   mid_22_PE_OUT;
  wire                mid_22_finish;
  wire       [7:0]    mid_23_acount;
  wire       [7:0]    mid_23_bcount;
  wire       [19:0]   mid_23_PE_OUT;
  wire                mid_23_finish;
  wire       [7:0]    mid_24_acount;
  wire       [7:0]    mid_24_bcount;
  wire       [19:0]   mid_24_PE_OUT;
  wire                mid_24_finish;
  wire       [7:0]    mid_25_acount;
  wire       [7:0]    mid_25_bcount;
  wire       [19:0]   mid_25_PE_OUT;
  wire                mid_25_finish;
  wire       [7:0]    mid_26_acount;
  wire       [7:0]    mid_26_bcount;
  wire       [19:0]   mid_26_PE_OUT;
  wire                mid_26_finish;
  wire       [7:0]    mid_27_acount;
  wire       [7:0]    mid_27_bcount;
  wire       [19:0]   mid_27_PE_OUT;
  wire                mid_27_finish;
  wire       [7:0]    mid_28_acount;
  wire       [7:0]    mid_28_bcount;
  wire       [19:0]   mid_28_PE_OUT;
  wire                mid_28_finish;
  wire       [7:0]    mid_29_acount;
  wire       [7:0]    mid_29_bcount;
  wire       [19:0]   mid_29_PE_OUT;
  wire                mid_29_finish;
  wire       [7:0]    mid_30_acount;
  wire       [7:0]    mid_30_bcount;
  wire       [19:0]   mid_30_PE_OUT;
  wire                mid_30_finish;
  wire       [7:0]    mid_31_acount;
  wire       [7:0]    mid_31_bcount;
  wire       [19:0]   mid_31_PE_OUT;
  wire                mid_31_finish;
  wire       [7:0]    mid_32_acount;
  wire       [7:0]    mid_32_bcount;
  wire       [19:0]   mid_32_PE_OUT;
  wire                mid_32_finish;
  wire       [7:0]    mid_33_acount;
  wire       [7:0]    mid_33_bcount;
  wire       [19:0]   mid_33_PE_OUT;
  wire                mid_33_finish;
  wire       [7:0]    mid_34_acount;
  wire       [7:0]    mid_34_bcount;
  wire       [19:0]   mid_34_PE_OUT;
  wire                mid_34_finish;
  wire       [7:0]    mid_35_acount;
  wire       [7:0]    mid_35_bcount;
  wire       [19:0]   mid_35_PE_OUT;
  wire                mid_35_finish;
  wire       [7:0]    mid_36_acount;
  wire       [7:0]    mid_36_bcount;
  wire       [19:0]   mid_36_PE_OUT;
  wire                mid_36_finish;
  wire       [7:0]    mid_37_acount;
  wire       [7:0]    mid_37_bcount;
  wire       [19:0]   mid_37_PE_OUT;
  wire                mid_37_finish;
  wire       [7:0]    mid_38_acount;
  wire       [7:0]    mid_38_bcount;
  wire       [19:0]   mid_38_PE_OUT;
  wire                mid_38_finish;
  wire       [7:0]    mid_39_acount;
  wire       [7:0]    mid_39_bcount;
  wire       [19:0]   mid_39_PE_OUT;
  wire                mid_39_finish;
  wire       [7:0]    mid_40_acount;
  wire       [7:0]    mid_40_bcount;
  wire       [19:0]   mid_40_PE_OUT;
  wire                mid_40_finish;
  wire       [7:0]    mid_41_acount;
  wire       [7:0]    mid_41_bcount;
  wire       [19:0]   mid_41_PE_OUT;
  wire                mid_41_finish;
  wire       [7:0]    mid_42_acount;
  wire       [7:0]    mid_42_bcount;
  wire       [19:0]   mid_42_PE_OUT;
  wire                mid_42_finish;
  wire       [7:0]    mid_43_acount;
  wire       [7:0]    mid_43_bcount;
  wire       [19:0]   mid_43_PE_OUT;
  wire                mid_43_finish;
  wire       [7:0]    mid_44_acount;
  wire       [7:0]    mid_44_bcount;
  wire       [19:0]   mid_44_PE_OUT;
  wire                mid_44_finish;
  wire       [7:0]    mid_45_acount;
  wire       [7:0]    mid_45_bcount;
  wire       [19:0]   mid_45_PE_OUT;
  wire                mid_45_finish;
  wire       [7:0]    mid_46_acount;
  wire       [7:0]    mid_46_bcount;
  wire       [19:0]   mid_46_PE_OUT;
  wire                mid_46_finish;
  wire       [7:0]    mid_47_acount;
  wire       [7:0]    mid_47_bcount;
  wire       [19:0]   mid_47_PE_OUT;
  wire                mid_47_finish;
  wire       [7:0]    mid_48_acount;
  wire       [7:0]    mid_48_bcount;
  wire       [19:0]   mid_48_PE_OUT;
  wire                mid_48_finish;
  reg        [19:0]   PE_OUT_0_1;
  reg        [19:0]   PE_OUT_1_1;
  reg        [19:0]   PE_OUT_2_1;
  reg        [19:0]   PE_OUT_3_1;
  reg        [19:0]   PE_OUT_4_1;
  reg        [19:0]   PE_OUT_5_1;
  reg        [19:0]   PE_OUT_6_1;
  reg        [19:0]   PE_OUT_7_1;
  reg                 resultVaild_0_1;
  reg                 resultVaild_1_1;
  reg                 resultVaild_2_1;
  reg                 resultVaild_3_1;
  reg                 resultVaild_4_1;
  reg                 resultVaild_5_1;
  reg                 resultVaild_6_1;
  reg                 resultVaild_7_1;
  reg        [19:0]   PE_OUT_0_1_delay_1;
  reg        [19:0]   PE_OUT_0_1_delay_2;
  reg        [19:0]   PE_OUT_0_1_delay_3;
  reg        [19:0]   PE_OUT_0_1_delay_4;
  reg        [19:0]   PE_OUT_0_1_delay_5;
  reg        [19:0]   PE_OUT_0_1_delay_6;
  reg        [19:0]   PE_OUT_0_1_delay_7;
  reg        [19:0]   PE_OUT_0_1_delay_8;
  reg                 resultVaild_0_1_delay_1;
  reg                 resultVaild_0_1_delay_2;
  reg                 resultVaild_0_1_delay_3;
  reg                 resultVaild_0_1_delay_4;
  reg                 resultVaild_0_1_delay_5;
  reg                 resultVaild_0_1_delay_6;
  reg                 resultVaild_0_1_delay_7;
  reg                 resultVaild_0_1_delay_8;
  reg        [19:0]   PE_OUT_1_1_delay_1;
  reg        [19:0]   PE_OUT_1_1_delay_2;
  reg        [19:0]   PE_OUT_1_1_delay_3;
  reg        [19:0]   PE_OUT_1_1_delay_4;
  reg        [19:0]   PE_OUT_1_1_delay_5;
  reg        [19:0]   PE_OUT_1_1_delay_6;
  reg        [19:0]   PE_OUT_1_1_delay_7;
  reg                 resultVaild_1_1_delay_1;
  reg                 resultVaild_1_1_delay_2;
  reg                 resultVaild_1_1_delay_3;
  reg                 resultVaild_1_1_delay_4;
  reg                 resultVaild_1_1_delay_5;
  reg                 resultVaild_1_1_delay_6;
  reg                 resultVaild_1_1_delay_7;
  reg        [19:0]   PE_OUT_2_1_delay_1;
  reg        [19:0]   PE_OUT_2_1_delay_2;
  reg        [19:0]   PE_OUT_2_1_delay_3;
  reg        [19:0]   PE_OUT_2_1_delay_4;
  reg        [19:0]   PE_OUT_2_1_delay_5;
  reg        [19:0]   PE_OUT_2_1_delay_6;
  reg                 resultVaild_2_1_delay_1;
  reg                 resultVaild_2_1_delay_2;
  reg                 resultVaild_2_1_delay_3;
  reg                 resultVaild_2_1_delay_4;
  reg                 resultVaild_2_1_delay_5;
  reg                 resultVaild_2_1_delay_6;
  reg        [19:0]   PE_OUT_3_1_delay_1;
  reg        [19:0]   PE_OUT_3_1_delay_2;
  reg        [19:0]   PE_OUT_3_1_delay_3;
  reg        [19:0]   PE_OUT_3_1_delay_4;
  reg        [19:0]   PE_OUT_3_1_delay_5;
  reg                 resultVaild_3_1_delay_1;
  reg                 resultVaild_3_1_delay_2;
  reg                 resultVaild_3_1_delay_3;
  reg                 resultVaild_3_1_delay_4;
  reg                 resultVaild_3_1_delay_5;
  reg        [19:0]   PE_OUT_4_1_delay_1;
  reg        [19:0]   PE_OUT_4_1_delay_2;
  reg        [19:0]   PE_OUT_4_1_delay_3;
  reg        [19:0]   PE_OUT_4_1_delay_4;
  reg                 resultVaild_4_1_delay_1;
  reg                 resultVaild_4_1_delay_2;
  reg                 resultVaild_4_1_delay_3;
  reg                 resultVaild_4_1_delay_4;
  reg        [19:0]   PE_OUT_5_1_delay_1;
  reg        [19:0]   PE_OUT_5_1_delay_2;
  reg        [19:0]   PE_OUT_5_1_delay_3;
  reg                 resultVaild_5_1_delay_1;
  reg                 resultVaild_5_1_delay_2;
  reg                 resultVaild_5_1_delay_3;
  reg        [19:0]   PE_OUT_6_1_delay_1;
  reg        [19:0]   PE_OUT_6_1_delay_2;
  reg                 resultVaild_6_1_delay_1;
  reg                 resultVaild_6_1_delay_2;
  reg        [19:0]   PE_OUT_7_1_delay_1;
  reg                 resultVaild_7_1_delay_1;
  reg                 b_Valid_0_delay_1;
  reg                 b_Valid_0_delay_1_1;
  reg                 b_Valid_0_delay_2;
  reg                 b_Valid_0_delay_1_2;
  reg                 b_Valid_0_delay_2_1;
  reg                 b_Valid_0_delay_3;
  reg                 b_Valid_0_delay_1_3;
  reg                 b_Valid_0_delay_2_2;
  reg                 b_Valid_0_delay_3_1;
  reg                 b_Valid_0_delay_4;
  reg                 b_Valid_0_delay_1_4;
  reg                 b_Valid_0_delay_2_3;
  reg                 b_Valid_0_delay_3_2;
  reg                 b_Valid_0_delay_4_1;
  reg                 b_Valid_0_delay_5;
  reg                 b_Valid_0_delay_1_5;
  reg                 b_Valid_0_delay_2_4;
  reg                 b_Valid_0_delay_3_3;
  reg                 b_Valid_0_delay_4_2;
  reg                 b_Valid_0_delay_5_1;
  reg                 b_Valid_0_delay_6;
  reg                 b_Valid_0_delay_1_6;
  reg                 b_Valid_0_delay_2_5;
  reg                 b_Valid_0_delay_3_4;
  reg                 b_Valid_0_delay_4_3;
  reg                 b_Valid_0_delay_5_2;
  reg                 b_Valid_0_delay_6_1;
  reg                 b_Valid_0_delay_7;
  reg        [7:0]    _zz_weight;
  reg                 b_Valid_1_delay_1;
  reg                 a_Valid_0_delay_1;
  reg        [7:0]    _zz_weight_1;
  reg        [7:0]    _zz_weight_2;
  reg                 b_Valid_2_delay_1;
  reg                 b_Valid_2_delay_2;
  reg                 a_Valid_0_delay_1_1;
  reg                 a_Valid_0_delay_2;
  reg        [7:0]    _zz_weight_3;
  reg        [7:0]    _zz_weight_4;
  reg        [7:0]    _zz_weight_5;
  reg                 b_Valid_3_delay_1;
  reg                 b_Valid_3_delay_2;
  reg                 b_Valid_3_delay_3;
  reg                 a_Valid_0_delay_1_2;
  reg                 a_Valid_0_delay_2_1;
  reg                 a_Valid_0_delay_3;
  reg        [7:0]    _zz_weight_6;
  reg        [7:0]    _zz_weight_7;
  reg        [7:0]    _zz_weight_8;
  reg        [7:0]    _zz_weight_9;
  reg                 b_Valid_4_delay_1;
  reg                 b_Valid_4_delay_2;
  reg                 b_Valid_4_delay_3;
  reg                 b_Valid_4_delay_4;
  reg                 a_Valid_0_delay_1_3;
  reg                 a_Valid_0_delay_2_2;
  reg                 a_Valid_0_delay_3_1;
  reg                 a_Valid_0_delay_4;
  reg        [7:0]    _zz_weight_10;
  reg        [7:0]    _zz_weight_11;
  reg        [7:0]    _zz_weight_12;
  reg        [7:0]    _zz_weight_13;
  reg        [7:0]    _zz_weight_14;
  reg                 b_Valid_5_delay_1;
  reg                 b_Valid_5_delay_2;
  reg                 b_Valid_5_delay_3;
  reg                 b_Valid_5_delay_4;
  reg                 b_Valid_5_delay_5;
  reg                 a_Valid_0_delay_1_4;
  reg                 a_Valid_0_delay_2_3;
  reg                 a_Valid_0_delay_3_2;
  reg                 a_Valid_0_delay_4_1;
  reg                 a_Valid_0_delay_5;
  reg        [7:0]    _zz_weight_15;
  reg        [7:0]    _zz_weight_16;
  reg        [7:0]    _zz_weight_17;
  reg        [7:0]    _zz_weight_18;
  reg        [7:0]    _zz_weight_19;
  reg        [7:0]    _zz_weight_20;
  reg                 b_Valid_6_delay_1;
  reg                 b_Valid_6_delay_2;
  reg                 b_Valid_6_delay_3;
  reg                 b_Valid_6_delay_4;
  reg                 b_Valid_6_delay_5;
  reg                 b_Valid_6_delay_6;
  reg                 a_Valid_0_delay_1_5;
  reg                 a_Valid_0_delay_2_4;
  reg                 a_Valid_0_delay_3_3;
  reg                 a_Valid_0_delay_4_2;
  reg                 a_Valid_0_delay_5_1;
  reg                 a_Valid_0_delay_6;
  reg        [7:0]    _zz_weight_21;
  reg        [7:0]    _zz_weight_22;
  reg        [7:0]    _zz_weight_23;
  reg        [7:0]    _zz_weight_24;
  reg        [7:0]    _zz_weight_25;
  reg        [7:0]    _zz_weight_26;
  reg        [7:0]    _zz_weight_27;
  reg                 b_Valid_7_delay_1;
  reg                 b_Valid_7_delay_2;
  reg                 b_Valid_7_delay_3;
  reg                 b_Valid_7_delay_4;
  reg                 b_Valid_7_delay_5;
  reg                 b_Valid_7_delay_6;
  reg                 b_Valid_7_delay_7;
  reg                 a_Valid_0_delay_1_6;
  reg                 a_Valid_0_delay_2_5;
  reg                 a_Valid_0_delay_3_4;
  reg                 a_Valid_0_delay_4_3;
  reg                 a_Valid_0_delay_5_2;
  reg                 a_Valid_0_delay_6_1;
  reg                 a_Valid_0_delay_7;
  reg                 left_vaild_delay_1;
  reg                 top_vaild_delay_1;
  reg                 mid_vaild_delay_1;
  reg                 top_1_vaild_delay_1;
  reg                 mid_1_vaild_delay_1;
  reg                 top_2_vaild_delay_1;
  reg                 mid_2_vaild_delay_1;
  reg                 top_3_vaild_delay_1;
  reg                 mid_3_vaild_delay_1;
  reg                 top_4_vaild_delay_1;
  reg                 mid_4_vaild_delay_1;
  reg                 top_5_vaild_delay_1;
  reg                 mid_5_vaild_delay_1;
  reg                 top_6_vaild_delay_1;
  reg                 left_1_vaild_delay_1;
  reg                 mid_vaild_delay_1_1;
  reg                 mid_7_vaild_delay_1;
  reg                 mid_1_vaild_delay_1_1;
  reg                 mid_8_vaild_delay_1;
  reg                 mid_2_vaild_delay_1_1;
  reg                 mid_9_vaild_delay_1;
  reg                 mid_3_vaild_delay_1_1;
  reg                 mid_10_vaild_delay_1;
  reg                 mid_4_vaild_delay_1_1;
  reg                 mid_11_vaild_delay_1;
  reg                 mid_5_vaild_delay_1_1;
  reg                 mid_12_vaild_delay_1;
  reg                 mid_6_vaild_delay_1;
  reg                 left_2_vaild_delay_1;
  reg                 mid_7_vaild_delay_1_1;
  reg                 mid_14_vaild_delay_1;
  reg                 mid_8_vaild_delay_1_1;
  reg                 mid_15_vaild_delay_1;
  reg                 mid_9_vaild_delay_1_1;
  reg                 mid_16_vaild_delay_1;
  reg                 mid_10_vaild_delay_1_1;
  reg                 mid_17_vaild_delay_1;
  reg                 mid_11_vaild_delay_1_1;
  reg                 mid_18_vaild_delay_1;
  reg                 mid_12_vaild_delay_1_1;
  reg                 mid_19_vaild_delay_1;
  reg                 mid_13_vaild_delay_1;
  reg                 left_3_vaild_delay_1;
  reg                 mid_14_vaild_delay_1_1;
  reg                 mid_21_vaild_delay_1;
  reg                 mid_15_vaild_delay_1_1;
  reg                 mid_22_vaild_delay_1;
  reg                 mid_16_vaild_delay_1_1;
  reg                 mid_23_vaild_delay_1;
  reg                 mid_17_vaild_delay_1_1;
  reg                 mid_24_vaild_delay_1;
  reg                 mid_18_vaild_delay_1_1;
  reg                 mid_25_vaild_delay_1;
  reg                 mid_19_vaild_delay_1_1;
  reg                 mid_26_vaild_delay_1;
  reg                 mid_20_vaild_delay_1;
  reg                 left_4_vaild_delay_1;
  reg                 mid_21_vaild_delay_1_1;
  reg                 mid_28_vaild_delay_1;
  reg                 mid_22_vaild_delay_1_1;
  reg                 mid_29_vaild_delay_1;
  reg                 mid_23_vaild_delay_1_1;
  reg                 mid_30_vaild_delay_1;
  reg                 mid_24_vaild_delay_1_1;
  reg                 mid_31_vaild_delay_1;
  reg                 mid_25_vaild_delay_1_1;
  reg                 mid_32_vaild_delay_1;
  reg                 mid_26_vaild_delay_1_1;
  reg                 mid_33_vaild_delay_1;
  reg                 mid_27_vaild_delay_1;
  reg                 left_5_vaild_delay_1;
  reg                 mid_28_vaild_delay_1_1;
  reg                 mid_35_vaild_delay_1;
  reg                 mid_29_vaild_delay_1_1;
  reg                 mid_36_vaild_delay_1;
  reg                 mid_30_vaild_delay_1_1;
  reg                 mid_37_vaild_delay_1;
  reg                 mid_31_vaild_delay_1_1;
  reg                 mid_38_vaild_delay_1;
  reg                 mid_32_vaild_delay_1_1;
  reg                 mid_39_vaild_delay_1;
  reg                 mid_33_vaild_delay_1_1;
  reg                 mid_40_vaild_delay_1;
  reg                 mid_34_vaild_delay_1;
  reg                 left_6_vaild_delay_1;
  reg                 mid_35_vaild_delay_1_1;
  reg                 mid_42_vaild_delay_1;
  reg                 mid_36_vaild_delay_1_1;
  reg                 mid_43_vaild_delay_1;
  reg                 mid_37_vaild_delay_1_1;
  reg                 mid_44_vaild_delay_1;
  reg                 mid_38_vaild_delay_1_1;
  reg                 mid_45_vaild_delay_1;
  reg                 mid_39_vaild_delay_1_1;
  reg                 mid_46_vaild_delay_1;
  reg                 mid_40_vaild_delay_1_1;
  reg                 mid_47_vaild_delay_1;
  reg                 mid_41_vaild_delay_1;
  wire                when_Tile_l72;
  wire                when_Tile_l72_1;
  wire                when_Tile_l72_2;
  wire                when_Tile_l72_3;
  wire                when_Tile_l72_4;
  wire                when_Tile_l72_5;
  wire                when_Tile_l72_6;
  wire                when_Tile_l72_7;
  wire                when_Tile_l72_8;
  wire                when_Tile_l72_9;
  wire                when_Tile_l72_10;
  wire                when_Tile_l72_11;
  wire                when_Tile_l72_12;
  wire                when_Tile_l72_13;
  wire                when_Tile_l72_14;
  wire                when_Tile_l72_15;
  wire                when_Tile_l72_16;
  wire                when_Tile_l72_17;
  wire                when_Tile_l72_18;
  wire                when_Tile_l72_19;
  wire                when_Tile_l72_20;
  wire                when_Tile_l72_21;
  wire                when_Tile_l72_22;
  wire                when_Tile_l72_23;
  wire                when_Tile_l72_24;
  wire                when_Tile_l72_25;
  wire                when_Tile_l72_26;
  wire                when_Tile_l72_27;
  wire                when_Tile_l72_28;
  wire                when_Tile_l72_29;
  wire                when_Tile_l72_30;
  wire                when_Tile_l72_31;
  wire                when_Tile_l72_32;
  wire                when_Tile_l72_33;
  wire                when_Tile_l72_34;
  wire                when_Tile_l72_35;
  wire                when_Tile_l72_36;
  wire                when_Tile_l72_37;
  wire                when_Tile_l72_38;
  wire                when_Tile_l72_39;
  wire                when_Tile_l72_40;
  wire                when_Tile_l72_41;
  wire                when_Tile_l72_42;
  wire                when_Tile_l72_43;
  wire                when_Tile_l72_44;
  wire                when_Tile_l72_45;
  wire                when_Tile_l72_46;
  wire                when_Tile_l72_47;
  wire                when_Tile_l72_48;
  wire                when_Tile_l72_49;
  wire                when_Tile_l72_50;
  wire                when_Tile_l72_51;
  wire                when_Tile_l72_52;
  wire                when_Tile_l72_53;
  wire                when_Tile_l72_54;
  wire                when_Tile_l72_55;
  wire                when_Tile_l72_56;
  wire                when_Tile_l72_57;
  wire                when_Tile_l72_58;
  wire                when_Tile_l72_59;
  wire                when_Tile_l72_60;
  wire                when_Tile_l72_61;
  wire                when_Tile_l72_62;
  wire                when_Tile_l72_63;

  PE pE_64 (
    .activate  (pE_64_activate[7:0]), //i
    .weight    (pE_64_weight[7:0]  ), //i
    .vaild     (pE_64_vaild        ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (pE_64_acount[7:0]  ), //o
    .bcount    (pE_64_bcount[7:0]  ), //o
    .PE_OUT    (pE_64_PE_OUT[19:0] ), //o
    .finish    (pE_64_finish       ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE left (
    .activate  (left_activate[7:0]), //i
    .weight    (pE_64_bcount[7:0] ), //i
    .vaild     (left_vaild        ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (left_acount[7:0]  ), //o
    .bcount    (left_bcount[7:0]  ), //o
    .PE_OUT    (left_PE_OUT[19:0] ), //o
    .finish    (left_finish       ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE left_1 (
    .activate  (left_1_activate[7:0]), //i
    .weight    (left_bcount[7:0]    ), //i
    .vaild     (left_1_vaild        ), //i
    .signCount (signCount[15:0]     ), //i
    .acount    (left_1_acount[7:0]  ), //o
    .bcount    (left_1_bcount[7:0]  ), //o
    .PE_OUT    (left_1_PE_OUT[19:0] ), //o
    .finish    (left_1_finish       ), //o
    .clk       (clk                 ), //i
    .reset     (reset               )  //i
  );
  PE left_2 (
    .activate  (left_2_activate[7:0]), //i
    .weight    (left_1_bcount[7:0]  ), //i
    .vaild     (left_2_vaild        ), //i
    .signCount (signCount[15:0]     ), //i
    .acount    (left_2_acount[7:0]  ), //o
    .bcount    (left_2_bcount[7:0]  ), //o
    .PE_OUT    (left_2_PE_OUT[19:0] ), //o
    .finish    (left_2_finish       ), //o
    .clk       (clk                 ), //i
    .reset     (reset               )  //i
  );
  PE left_3 (
    .activate  (left_3_activate[7:0]), //i
    .weight    (left_2_bcount[7:0]  ), //i
    .vaild     (left_3_vaild        ), //i
    .signCount (signCount[15:0]     ), //i
    .acount    (left_3_acount[7:0]  ), //o
    .bcount    (left_3_bcount[7:0]  ), //o
    .PE_OUT    (left_3_PE_OUT[19:0] ), //o
    .finish    (left_3_finish       ), //o
    .clk       (clk                 ), //i
    .reset     (reset               )  //i
  );
  PE left_4 (
    .activate  (left_4_activate[7:0]), //i
    .weight    (left_3_bcount[7:0]  ), //i
    .vaild     (left_4_vaild        ), //i
    .signCount (signCount[15:0]     ), //i
    .acount    (left_4_acount[7:0]  ), //o
    .bcount    (left_4_bcount[7:0]  ), //o
    .PE_OUT    (left_4_PE_OUT[19:0] ), //o
    .finish    (left_4_finish       ), //o
    .clk       (clk                 ), //i
    .reset     (reset               )  //i
  );
  PE left_5 (
    .activate  (left_5_activate[7:0]), //i
    .weight    (left_4_bcount[7:0]  ), //i
    .vaild     (left_5_vaild        ), //i
    .signCount (signCount[15:0]     ), //i
    .acount    (left_5_acount[7:0]  ), //o
    .bcount    (left_5_bcount[7:0]  ), //o
    .PE_OUT    (left_5_PE_OUT[19:0] ), //o
    .finish    (left_5_finish       ), //o
    .clk       (clk                 ), //i
    .reset     (reset               )  //i
  );
  PE left_6 (
    .activate  (left_6_activate[7:0]), //i
    .weight    (left_5_bcount[7:0]  ), //i
    .vaild     (left_6_vaild        ), //i
    .signCount (signCount[15:0]     ), //i
    .acount    (left_6_acount[7:0]  ), //o
    .bcount    (left_6_bcount[7:0]  ), //o
    .PE_OUT    (left_6_PE_OUT[19:0] ), //o
    .finish    (left_6_finish       ), //o
    .clk       (clk                 ), //i
    .reset     (reset               )  //i
  );
  PE top (
    .activate  (pE_64_acount[7:0]), //i
    .weight    (_zz_weight[7:0]  ), //i
    .vaild     (top_vaild        ), //i
    .signCount (signCount[15:0]  ), //i
    .acount    (top_acount[7:0]  ), //o
    .bcount    (top_bcount[7:0]  ), //o
    .PE_OUT    (top_PE_OUT[19:0] ), //o
    .finish    (top_finish       ), //o
    .clk       (clk              ), //i
    .reset     (reset            )  //i
  );
  PE top_1 (
    .activate  (top_acount[7:0]   ), //i
    .weight    (_zz_weight_2[7:0] ), //i
    .vaild     (top_1_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (top_1_acount[7:0] ), //o
    .bcount    (top_1_bcount[7:0] ), //o
    .PE_OUT    (top_1_PE_OUT[19:0]), //o
    .finish    (top_1_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE top_2 (
    .activate  (top_1_acount[7:0] ), //i
    .weight    (_zz_weight_5[7:0] ), //i
    .vaild     (top_2_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (top_2_acount[7:0] ), //o
    .bcount    (top_2_bcount[7:0] ), //o
    .PE_OUT    (top_2_PE_OUT[19:0]), //o
    .finish    (top_2_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE top_3 (
    .activate  (top_2_acount[7:0] ), //i
    .weight    (_zz_weight_9[7:0] ), //i
    .vaild     (top_3_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (top_3_acount[7:0] ), //o
    .bcount    (top_3_bcount[7:0] ), //o
    .PE_OUT    (top_3_PE_OUT[19:0]), //o
    .finish    (top_3_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE top_4 (
    .activate  (top_3_acount[7:0] ), //i
    .weight    (_zz_weight_14[7:0]), //i
    .vaild     (top_4_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (top_4_acount[7:0] ), //o
    .bcount    (top_4_bcount[7:0] ), //o
    .PE_OUT    (top_4_PE_OUT[19:0]), //o
    .finish    (top_4_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE top_5 (
    .activate  (top_4_acount[7:0] ), //i
    .weight    (_zz_weight_20[7:0]), //i
    .vaild     (top_5_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (top_5_acount[7:0] ), //o
    .bcount    (top_5_bcount[7:0] ), //o
    .PE_OUT    (top_5_PE_OUT[19:0]), //o
    .finish    (top_5_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE top_6 (
    .activate  (top_5_acount[7:0] ), //i
    .weight    (_zz_weight_27[7:0]), //i
    .vaild     (top_6_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (top_6_acount[7:0] ), //o
    .bcount    (top_6_bcount[7:0] ), //o
    .PE_OUT    (top_6_PE_OUT[19:0]), //o
    .finish    (top_6_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid (
    .activate  (left_acount[7:0]), //i
    .weight    (top_bcount[7:0] ), //i
    .vaild     (mid_vaild       ), //i
    .signCount (signCount[15:0] ), //i
    .acount    (mid_acount[7:0] ), //o
    .bcount    (mid_bcount[7:0] ), //o
    .PE_OUT    (mid_PE_OUT[19:0]), //o
    .finish    (mid_finish      ), //o
    .clk       (clk             ), //i
    .reset     (reset           )  //i
  );
  PE mid_1 (
    .activate  (mid_acount[7:0]   ), //i
    .weight    (top_1_bcount[7:0] ), //i
    .vaild     (mid_1_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_1_acount[7:0] ), //o
    .bcount    (mid_1_bcount[7:0] ), //o
    .PE_OUT    (mid_1_PE_OUT[19:0]), //o
    .finish    (mid_1_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_2 (
    .activate  (mid_1_acount[7:0] ), //i
    .weight    (top_2_bcount[7:0] ), //i
    .vaild     (mid_2_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_2_acount[7:0] ), //o
    .bcount    (mid_2_bcount[7:0] ), //o
    .PE_OUT    (mid_2_PE_OUT[19:0]), //o
    .finish    (mid_2_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_3 (
    .activate  (mid_2_acount[7:0] ), //i
    .weight    (top_3_bcount[7:0] ), //i
    .vaild     (mid_3_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_3_acount[7:0] ), //o
    .bcount    (mid_3_bcount[7:0] ), //o
    .PE_OUT    (mid_3_PE_OUT[19:0]), //o
    .finish    (mid_3_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_4 (
    .activate  (mid_3_acount[7:0] ), //i
    .weight    (top_4_bcount[7:0] ), //i
    .vaild     (mid_4_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_4_acount[7:0] ), //o
    .bcount    (mid_4_bcount[7:0] ), //o
    .PE_OUT    (mid_4_PE_OUT[19:0]), //o
    .finish    (mid_4_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_5 (
    .activate  (mid_4_acount[7:0] ), //i
    .weight    (top_5_bcount[7:0] ), //i
    .vaild     (mid_5_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_5_acount[7:0] ), //o
    .bcount    (mid_5_bcount[7:0] ), //o
    .PE_OUT    (mid_5_PE_OUT[19:0]), //o
    .finish    (mid_5_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_6 (
    .activate  (mid_5_acount[7:0] ), //i
    .weight    (top_6_bcount[7:0] ), //i
    .vaild     (mid_6_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_6_acount[7:0] ), //o
    .bcount    (mid_6_bcount[7:0] ), //o
    .PE_OUT    (mid_6_PE_OUT[19:0]), //o
    .finish    (mid_6_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_7 (
    .activate  (left_1_acount[7:0]), //i
    .weight    (mid_bcount[7:0]   ), //i
    .vaild     (mid_7_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_7_acount[7:0] ), //o
    .bcount    (mid_7_bcount[7:0] ), //o
    .PE_OUT    (mid_7_PE_OUT[19:0]), //o
    .finish    (mid_7_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_8 (
    .activate  (mid_7_acount[7:0] ), //i
    .weight    (mid_1_bcount[7:0] ), //i
    .vaild     (mid_8_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_8_acount[7:0] ), //o
    .bcount    (mid_8_bcount[7:0] ), //o
    .PE_OUT    (mid_8_PE_OUT[19:0]), //o
    .finish    (mid_8_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_9 (
    .activate  (mid_8_acount[7:0] ), //i
    .weight    (mid_2_bcount[7:0] ), //i
    .vaild     (mid_9_vaild       ), //i
    .signCount (signCount[15:0]   ), //i
    .acount    (mid_9_acount[7:0] ), //o
    .bcount    (mid_9_bcount[7:0] ), //o
    .PE_OUT    (mid_9_PE_OUT[19:0]), //o
    .finish    (mid_9_finish      ), //o
    .clk       (clk               ), //i
    .reset     (reset             )  //i
  );
  PE mid_10 (
    .activate  (mid_9_acount[7:0]  ), //i
    .weight    (mid_3_bcount[7:0]  ), //i
    .vaild     (mid_10_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_10_acount[7:0] ), //o
    .bcount    (mid_10_bcount[7:0] ), //o
    .PE_OUT    (mid_10_PE_OUT[19:0]), //o
    .finish    (mid_10_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_11 (
    .activate  (mid_10_acount[7:0] ), //i
    .weight    (mid_4_bcount[7:0]  ), //i
    .vaild     (mid_11_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_11_acount[7:0] ), //o
    .bcount    (mid_11_bcount[7:0] ), //o
    .PE_OUT    (mid_11_PE_OUT[19:0]), //o
    .finish    (mid_11_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_12 (
    .activate  (mid_11_acount[7:0] ), //i
    .weight    (mid_5_bcount[7:0]  ), //i
    .vaild     (mid_12_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_12_acount[7:0] ), //o
    .bcount    (mid_12_bcount[7:0] ), //o
    .PE_OUT    (mid_12_PE_OUT[19:0]), //o
    .finish    (mid_12_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_13 (
    .activate  (mid_12_acount[7:0] ), //i
    .weight    (mid_6_bcount[7:0]  ), //i
    .vaild     (mid_13_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_13_acount[7:0] ), //o
    .bcount    (mid_13_bcount[7:0] ), //o
    .PE_OUT    (mid_13_PE_OUT[19:0]), //o
    .finish    (mid_13_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_14 (
    .activate  (left_2_acount[7:0] ), //i
    .weight    (mid_7_bcount[7:0]  ), //i
    .vaild     (mid_14_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_14_acount[7:0] ), //o
    .bcount    (mid_14_bcount[7:0] ), //o
    .PE_OUT    (mid_14_PE_OUT[19:0]), //o
    .finish    (mid_14_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_15 (
    .activate  (mid_14_acount[7:0] ), //i
    .weight    (mid_8_bcount[7:0]  ), //i
    .vaild     (mid_15_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_15_acount[7:0] ), //o
    .bcount    (mid_15_bcount[7:0] ), //o
    .PE_OUT    (mid_15_PE_OUT[19:0]), //o
    .finish    (mid_15_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_16 (
    .activate  (mid_15_acount[7:0] ), //i
    .weight    (mid_9_bcount[7:0]  ), //i
    .vaild     (mid_16_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_16_acount[7:0] ), //o
    .bcount    (mid_16_bcount[7:0] ), //o
    .PE_OUT    (mid_16_PE_OUT[19:0]), //o
    .finish    (mid_16_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_17 (
    .activate  (mid_16_acount[7:0] ), //i
    .weight    (mid_10_bcount[7:0] ), //i
    .vaild     (mid_17_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_17_acount[7:0] ), //o
    .bcount    (mid_17_bcount[7:0] ), //o
    .PE_OUT    (mid_17_PE_OUT[19:0]), //o
    .finish    (mid_17_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_18 (
    .activate  (mid_17_acount[7:0] ), //i
    .weight    (mid_11_bcount[7:0] ), //i
    .vaild     (mid_18_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_18_acount[7:0] ), //o
    .bcount    (mid_18_bcount[7:0] ), //o
    .PE_OUT    (mid_18_PE_OUT[19:0]), //o
    .finish    (mid_18_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_19 (
    .activate  (mid_18_acount[7:0] ), //i
    .weight    (mid_12_bcount[7:0] ), //i
    .vaild     (mid_19_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_19_acount[7:0] ), //o
    .bcount    (mid_19_bcount[7:0] ), //o
    .PE_OUT    (mid_19_PE_OUT[19:0]), //o
    .finish    (mid_19_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_20 (
    .activate  (mid_19_acount[7:0] ), //i
    .weight    (mid_13_bcount[7:0] ), //i
    .vaild     (mid_20_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_20_acount[7:0] ), //o
    .bcount    (mid_20_bcount[7:0] ), //o
    .PE_OUT    (mid_20_PE_OUT[19:0]), //o
    .finish    (mid_20_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_21 (
    .activate  (left_3_acount[7:0] ), //i
    .weight    (mid_14_bcount[7:0] ), //i
    .vaild     (mid_21_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_21_acount[7:0] ), //o
    .bcount    (mid_21_bcount[7:0] ), //o
    .PE_OUT    (mid_21_PE_OUT[19:0]), //o
    .finish    (mid_21_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_22 (
    .activate  (mid_21_acount[7:0] ), //i
    .weight    (mid_15_bcount[7:0] ), //i
    .vaild     (mid_22_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_22_acount[7:0] ), //o
    .bcount    (mid_22_bcount[7:0] ), //o
    .PE_OUT    (mid_22_PE_OUT[19:0]), //o
    .finish    (mid_22_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_23 (
    .activate  (mid_22_acount[7:0] ), //i
    .weight    (mid_16_bcount[7:0] ), //i
    .vaild     (mid_23_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_23_acount[7:0] ), //o
    .bcount    (mid_23_bcount[7:0] ), //o
    .PE_OUT    (mid_23_PE_OUT[19:0]), //o
    .finish    (mid_23_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_24 (
    .activate  (mid_23_acount[7:0] ), //i
    .weight    (mid_17_bcount[7:0] ), //i
    .vaild     (mid_24_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_24_acount[7:0] ), //o
    .bcount    (mid_24_bcount[7:0] ), //o
    .PE_OUT    (mid_24_PE_OUT[19:0]), //o
    .finish    (mid_24_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_25 (
    .activate  (mid_24_acount[7:0] ), //i
    .weight    (mid_18_bcount[7:0] ), //i
    .vaild     (mid_25_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_25_acount[7:0] ), //o
    .bcount    (mid_25_bcount[7:0] ), //o
    .PE_OUT    (mid_25_PE_OUT[19:0]), //o
    .finish    (mid_25_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_26 (
    .activate  (mid_25_acount[7:0] ), //i
    .weight    (mid_19_bcount[7:0] ), //i
    .vaild     (mid_26_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_26_acount[7:0] ), //o
    .bcount    (mid_26_bcount[7:0] ), //o
    .PE_OUT    (mid_26_PE_OUT[19:0]), //o
    .finish    (mid_26_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_27 (
    .activate  (mid_26_acount[7:0] ), //i
    .weight    (mid_20_bcount[7:0] ), //i
    .vaild     (mid_27_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_27_acount[7:0] ), //o
    .bcount    (mid_27_bcount[7:0] ), //o
    .PE_OUT    (mid_27_PE_OUT[19:0]), //o
    .finish    (mid_27_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_28 (
    .activate  (left_4_acount[7:0] ), //i
    .weight    (mid_21_bcount[7:0] ), //i
    .vaild     (mid_28_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_28_acount[7:0] ), //o
    .bcount    (mid_28_bcount[7:0] ), //o
    .PE_OUT    (mid_28_PE_OUT[19:0]), //o
    .finish    (mid_28_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_29 (
    .activate  (mid_28_acount[7:0] ), //i
    .weight    (mid_22_bcount[7:0] ), //i
    .vaild     (mid_29_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_29_acount[7:0] ), //o
    .bcount    (mid_29_bcount[7:0] ), //o
    .PE_OUT    (mid_29_PE_OUT[19:0]), //o
    .finish    (mid_29_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_30 (
    .activate  (mid_29_acount[7:0] ), //i
    .weight    (mid_23_bcount[7:0] ), //i
    .vaild     (mid_30_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_30_acount[7:0] ), //o
    .bcount    (mid_30_bcount[7:0] ), //o
    .PE_OUT    (mid_30_PE_OUT[19:0]), //o
    .finish    (mid_30_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_31 (
    .activate  (mid_30_acount[7:0] ), //i
    .weight    (mid_24_bcount[7:0] ), //i
    .vaild     (mid_31_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_31_acount[7:0] ), //o
    .bcount    (mid_31_bcount[7:0] ), //o
    .PE_OUT    (mid_31_PE_OUT[19:0]), //o
    .finish    (mid_31_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_32 (
    .activate  (mid_31_acount[7:0] ), //i
    .weight    (mid_25_bcount[7:0] ), //i
    .vaild     (mid_32_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_32_acount[7:0] ), //o
    .bcount    (mid_32_bcount[7:0] ), //o
    .PE_OUT    (mid_32_PE_OUT[19:0]), //o
    .finish    (mid_32_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_33 (
    .activate  (mid_32_acount[7:0] ), //i
    .weight    (mid_26_bcount[7:0] ), //i
    .vaild     (mid_33_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_33_acount[7:0] ), //o
    .bcount    (mid_33_bcount[7:0] ), //o
    .PE_OUT    (mid_33_PE_OUT[19:0]), //o
    .finish    (mid_33_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_34 (
    .activate  (mid_33_acount[7:0] ), //i
    .weight    (mid_27_bcount[7:0] ), //i
    .vaild     (mid_34_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_34_acount[7:0] ), //o
    .bcount    (mid_34_bcount[7:0] ), //o
    .PE_OUT    (mid_34_PE_OUT[19:0]), //o
    .finish    (mid_34_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_35 (
    .activate  (left_5_acount[7:0] ), //i
    .weight    (mid_28_bcount[7:0] ), //i
    .vaild     (mid_35_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_35_acount[7:0] ), //o
    .bcount    (mid_35_bcount[7:0] ), //o
    .PE_OUT    (mid_35_PE_OUT[19:0]), //o
    .finish    (mid_35_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_36 (
    .activate  (mid_35_acount[7:0] ), //i
    .weight    (mid_29_bcount[7:0] ), //i
    .vaild     (mid_36_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_36_acount[7:0] ), //o
    .bcount    (mid_36_bcount[7:0] ), //o
    .PE_OUT    (mid_36_PE_OUT[19:0]), //o
    .finish    (mid_36_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_37 (
    .activate  (mid_36_acount[7:0] ), //i
    .weight    (mid_30_bcount[7:0] ), //i
    .vaild     (mid_37_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_37_acount[7:0] ), //o
    .bcount    (mid_37_bcount[7:0] ), //o
    .PE_OUT    (mid_37_PE_OUT[19:0]), //o
    .finish    (mid_37_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_38 (
    .activate  (mid_37_acount[7:0] ), //i
    .weight    (mid_31_bcount[7:0] ), //i
    .vaild     (mid_38_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_38_acount[7:0] ), //o
    .bcount    (mid_38_bcount[7:0] ), //o
    .PE_OUT    (mid_38_PE_OUT[19:0]), //o
    .finish    (mid_38_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_39 (
    .activate  (mid_38_acount[7:0] ), //i
    .weight    (mid_32_bcount[7:0] ), //i
    .vaild     (mid_39_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_39_acount[7:0] ), //o
    .bcount    (mid_39_bcount[7:0] ), //o
    .PE_OUT    (mid_39_PE_OUT[19:0]), //o
    .finish    (mid_39_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_40 (
    .activate  (mid_39_acount[7:0] ), //i
    .weight    (mid_33_bcount[7:0] ), //i
    .vaild     (mid_40_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_40_acount[7:0] ), //o
    .bcount    (mid_40_bcount[7:0] ), //o
    .PE_OUT    (mid_40_PE_OUT[19:0]), //o
    .finish    (mid_40_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_41 (
    .activate  (mid_40_acount[7:0] ), //i
    .weight    (mid_34_bcount[7:0] ), //i
    .vaild     (mid_41_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_41_acount[7:0] ), //o
    .bcount    (mid_41_bcount[7:0] ), //o
    .PE_OUT    (mid_41_PE_OUT[19:0]), //o
    .finish    (mid_41_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_42 (
    .activate  (left_6_acount[7:0] ), //i
    .weight    (mid_35_bcount[7:0] ), //i
    .vaild     (mid_42_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_42_acount[7:0] ), //o
    .bcount    (mid_42_bcount[7:0] ), //o
    .PE_OUT    (mid_42_PE_OUT[19:0]), //o
    .finish    (mid_42_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_43 (
    .activate  (mid_42_acount[7:0] ), //i
    .weight    (mid_36_bcount[7:0] ), //i
    .vaild     (mid_43_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_43_acount[7:0] ), //o
    .bcount    (mid_43_bcount[7:0] ), //o
    .PE_OUT    (mid_43_PE_OUT[19:0]), //o
    .finish    (mid_43_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_44 (
    .activate  (mid_43_acount[7:0] ), //i
    .weight    (mid_37_bcount[7:0] ), //i
    .vaild     (mid_44_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_44_acount[7:0] ), //o
    .bcount    (mid_44_bcount[7:0] ), //o
    .PE_OUT    (mid_44_PE_OUT[19:0]), //o
    .finish    (mid_44_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_45 (
    .activate  (mid_44_acount[7:0] ), //i
    .weight    (mid_38_bcount[7:0] ), //i
    .vaild     (mid_45_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_45_acount[7:0] ), //o
    .bcount    (mid_45_bcount[7:0] ), //o
    .PE_OUT    (mid_45_PE_OUT[19:0]), //o
    .finish    (mid_45_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_46 (
    .activate  (mid_45_acount[7:0] ), //i
    .weight    (mid_39_bcount[7:0] ), //i
    .vaild     (mid_46_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_46_acount[7:0] ), //o
    .bcount    (mid_46_bcount[7:0] ), //o
    .PE_OUT    (mid_46_PE_OUT[19:0]), //o
    .finish    (mid_46_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_47 (
    .activate  (mid_46_acount[7:0] ), //i
    .weight    (mid_40_bcount[7:0] ), //i
    .vaild     (mid_47_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_47_acount[7:0] ), //o
    .bcount    (mid_47_bcount[7:0] ), //o
    .PE_OUT    (mid_47_PE_OUT[19:0]), //o
    .finish    (mid_47_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  PE mid_48 (
    .activate  (mid_47_acount[7:0] ), //i
    .weight    (mid_41_bcount[7:0] ), //i
    .vaild     (mid_48_vaild       ), //i
    .signCount (signCount[15:0]    ), //i
    .acount    (mid_48_acount[7:0] ), //o
    .bcount    (mid_48_bcount[7:0] ), //o
    .PE_OUT    (mid_48_PE_OUT[19:0]), //o
    .finish    (mid_48_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  always @(*) begin
    PE_OUT_0_1 = 20'h0;
    if(when_Tile_l72) begin
      PE_OUT_0_1 = pE_64_PE_OUT;
    end
    if(when_Tile_l72_1) begin
      PE_OUT_0_1 = top_PE_OUT;
    end
    if(when_Tile_l72_2) begin
      PE_OUT_0_1 = top_1_PE_OUT;
    end
    if(when_Tile_l72_3) begin
      PE_OUT_0_1 = top_2_PE_OUT;
    end
    if(when_Tile_l72_4) begin
      PE_OUT_0_1 = top_3_PE_OUT;
    end
    if(when_Tile_l72_5) begin
      PE_OUT_0_1 = top_4_PE_OUT;
    end
    if(when_Tile_l72_6) begin
      PE_OUT_0_1 = top_5_PE_OUT;
    end
    if(when_Tile_l72_7) begin
      PE_OUT_0_1 = top_6_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_0_1 = 1'b0;
    if(when_Tile_l72) begin
      resultVaild_0_1 = pE_64_finish;
    end
    if(when_Tile_l72_1) begin
      resultVaild_0_1 = top_finish;
    end
    if(when_Tile_l72_2) begin
      resultVaild_0_1 = top_1_finish;
    end
    if(when_Tile_l72_3) begin
      resultVaild_0_1 = top_2_finish;
    end
    if(when_Tile_l72_4) begin
      resultVaild_0_1 = top_3_finish;
    end
    if(when_Tile_l72_5) begin
      resultVaild_0_1 = top_4_finish;
    end
    if(when_Tile_l72_6) begin
      resultVaild_0_1 = top_5_finish;
    end
    if(when_Tile_l72_7) begin
      resultVaild_0_1 = top_6_finish;
    end
  end

  assign PE_OUT_0 = PE_OUT_0_1_delay_8;
  assign resultVaild_0 = resultVaild_0_1_delay_8;
  always @(*) begin
    PE_OUT_1_1 = 20'h0;
    if(when_Tile_l72_8) begin
      PE_OUT_1_1 = left_PE_OUT;
    end
    if(when_Tile_l72_9) begin
      PE_OUT_1_1 = mid_PE_OUT;
    end
    if(when_Tile_l72_10) begin
      PE_OUT_1_1 = mid_1_PE_OUT;
    end
    if(when_Tile_l72_11) begin
      PE_OUT_1_1 = mid_2_PE_OUT;
    end
    if(when_Tile_l72_12) begin
      PE_OUT_1_1 = mid_3_PE_OUT;
    end
    if(when_Tile_l72_13) begin
      PE_OUT_1_1 = mid_4_PE_OUT;
    end
    if(when_Tile_l72_14) begin
      PE_OUT_1_1 = mid_5_PE_OUT;
    end
    if(when_Tile_l72_15) begin
      PE_OUT_1_1 = mid_6_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_1_1 = 1'b0;
    if(when_Tile_l72_8) begin
      resultVaild_1_1 = left_finish;
    end
    if(when_Tile_l72_9) begin
      resultVaild_1_1 = mid_finish;
    end
    if(when_Tile_l72_10) begin
      resultVaild_1_1 = mid_1_finish;
    end
    if(when_Tile_l72_11) begin
      resultVaild_1_1 = mid_2_finish;
    end
    if(when_Tile_l72_12) begin
      resultVaild_1_1 = mid_3_finish;
    end
    if(when_Tile_l72_13) begin
      resultVaild_1_1 = mid_4_finish;
    end
    if(when_Tile_l72_14) begin
      resultVaild_1_1 = mid_5_finish;
    end
    if(when_Tile_l72_15) begin
      resultVaild_1_1 = mid_6_finish;
    end
  end

  assign PE_OUT_1 = PE_OUT_1_1_delay_7;
  assign resultVaild_1 = resultVaild_1_1_delay_7;
  always @(*) begin
    PE_OUT_2_1 = 20'h0;
    if(when_Tile_l72_16) begin
      PE_OUT_2_1 = left_1_PE_OUT;
    end
    if(when_Tile_l72_17) begin
      PE_OUT_2_1 = mid_7_PE_OUT;
    end
    if(when_Tile_l72_18) begin
      PE_OUT_2_1 = mid_8_PE_OUT;
    end
    if(when_Tile_l72_19) begin
      PE_OUT_2_1 = mid_9_PE_OUT;
    end
    if(when_Tile_l72_20) begin
      PE_OUT_2_1 = mid_10_PE_OUT;
    end
    if(when_Tile_l72_21) begin
      PE_OUT_2_1 = mid_11_PE_OUT;
    end
    if(when_Tile_l72_22) begin
      PE_OUT_2_1 = mid_12_PE_OUT;
    end
    if(when_Tile_l72_23) begin
      PE_OUT_2_1 = mid_13_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_2_1 = 1'b0;
    if(when_Tile_l72_16) begin
      resultVaild_2_1 = left_1_finish;
    end
    if(when_Tile_l72_17) begin
      resultVaild_2_1 = mid_7_finish;
    end
    if(when_Tile_l72_18) begin
      resultVaild_2_1 = mid_8_finish;
    end
    if(when_Tile_l72_19) begin
      resultVaild_2_1 = mid_9_finish;
    end
    if(when_Tile_l72_20) begin
      resultVaild_2_1 = mid_10_finish;
    end
    if(when_Tile_l72_21) begin
      resultVaild_2_1 = mid_11_finish;
    end
    if(when_Tile_l72_22) begin
      resultVaild_2_1 = mid_12_finish;
    end
    if(when_Tile_l72_23) begin
      resultVaild_2_1 = mid_13_finish;
    end
  end

  assign PE_OUT_2 = PE_OUT_2_1_delay_6;
  assign resultVaild_2 = resultVaild_2_1_delay_6;
  always @(*) begin
    PE_OUT_3_1 = 20'h0;
    if(when_Tile_l72_24) begin
      PE_OUT_3_1 = left_2_PE_OUT;
    end
    if(when_Tile_l72_25) begin
      PE_OUT_3_1 = mid_14_PE_OUT;
    end
    if(when_Tile_l72_26) begin
      PE_OUT_3_1 = mid_15_PE_OUT;
    end
    if(when_Tile_l72_27) begin
      PE_OUT_3_1 = mid_16_PE_OUT;
    end
    if(when_Tile_l72_28) begin
      PE_OUT_3_1 = mid_17_PE_OUT;
    end
    if(when_Tile_l72_29) begin
      PE_OUT_3_1 = mid_18_PE_OUT;
    end
    if(when_Tile_l72_30) begin
      PE_OUT_3_1 = mid_19_PE_OUT;
    end
    if(when_Tile_l72_31) begin
      PE_OUT_3_1 = mid_20_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_3_1 = 1'b0;
    if(when_Tile_l72_24) begin
      resultVaild_3_1 = left_2_finish;
    end
    if(when_Tile_l72_25) begin
      resultVaild_3_1 = mid_14_finish;
    end
    if(when_Tile_l72_26) begin
      resultVaild_3_1 = mid_15_finish;
    end
    if(when_Tile_l72_27) begin
      resultVaild_3_1 = mid_16_finish;
    end
    if(when_Tile_l72_28) begin
      resultVaild_3_1 = mid_17_finish;
    end
    if(when_Tile_l72_29) begin
      resultVaild_3_1 = mid_18_finish;
    end
    if(when_Tile_l72_30) begin
      resultVaild_3_1 = mid_19_finish;
    end
    if(when_Tile_l72_31) begin
      resultVaild_3_1 = mid_20_finish;
    end
  end

  assign PE_OUT_3 = PE_OUT_3_1_delay_5;
  assign resultVaild_3 = resultVaild_3_1_delay_5;
  always @(*) begin
    PE_OUT_4_1 = 20'h0;
    if(when_Tile_l72_32) begin
      PE_OUT_4_1 = left_3_PE_OUT;
    end
    if(when_Tile_l72_33) begin
      PE_OUT_4_1 = mid_21_PE_OUT;
    end
    if(when_Tile_l72_34) begin
      PE_OUT_4_1 = mid_22_PE_OUT;
    end
    if(when_Tile_l72_35) begin
      PE_OUT_4_1 = mid_23_PE_OUT;
    end
    if(when_Tile_l72_36) begin
      PE_OUT_4_1 = mid_24_PE_OUT;
    end
    if(when_Tile_l72_37) begin
      PE_OUT_4_1 = mid_25_PE_OUT;
    end
    if(when_Tile_l72_38) begin
      PE_OUT_4_1 = mid_26_PE_OUT;
    end
    if(when_Tile_l72_39) begin
      PE_OUT_4_1 = mid_27_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_4_1 = 1'b0;
    if(when_Tile_l72_32) begin
      resultVaild_4_1 = left_3_finish;
    end
    if(when_Tile_l72_33) begin
      resultVaild_4_1 = mid_21_finish;
    end
    if(when_Tile_l72_34) begin
      resultVaild_4_1 = mid_22_finish;
    end
    if(when_Tile_l72_35) begin
      resultVaild_4_1 = mid_23_finish;
    end
    if(when_Tile_l72_36) begin
      resultVaild_4_1 = mid_24_finish;
    end
    if(when_Tile_l72_37) begin
      resultVaild_4_1 = mid_25_finish;
    end
    if(when_Tile_l72_38) begin
      resultVaild_4_1 = mid_26_finish;
    end
    if(when_Tile_l72_39) begin
      resultVaild_4_1 = mid_27_finish;
    end
  end

  assign PE_OUT_4 = PE_OUT_4_1_delay_4;
  assign resultVaild_4 = resultVaild_4_1_delay_4;
  always @(*) begin
    PE_OUT_5_1 = 20'h0;
    if(when_Tile_l72_40) begin
      PE_OUT_5_1 = left_4_PE_OUT;
    end
    if(when_Tile_l72_41) begin
      PE_OUT_5_1 = mid_28_PE_OUT;
    end
    if(when_Tile_l72_42) begin
      PE_OUT_5_1 = mid_29_PE_OUT;
    end
    if(when_Tile_l72_43) begin
      PE_OUT_5_1 = mid_30_PE_OUT;
    end
    if(when_Tile_l72_44) begin
      PE_OUT_5_1 = mid_31_PE_OUT;
    end
    if(when_Tile_l72_45) begin
      PE_OUT_5_1 = mid_32_PE_OUT;
    end
    if(when_Tile_l72_46) begin
      PE_OUT_5_1 = mid_33_PE_OUT;
    end
    if(when_Tile_l72_47) begin
      PE_OUT_5_1 = mid_34_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_5_1 = 1'b0;
    if(when_Tile_l72_40) begin
      resultVaild_5_1 = left_4_finish;
    end
    if(when_Tile_l72_41) begin
      resultVaild_5_1 = mid_28_finish;
    end
    if(when_Tile_l72_42) begin
      resultVaild_5_1 = mid_29_finish;
    end
    if(when_Tile_l72_43) begin
      resultVaild_5_1 = mid_30_finish;
    end
    if(when_Tile_l72_44) begin
      resultVaild_5_1 = mid_31_finish;
    end
    if(when_Tile_l72_45) begin
      resultVaild_5_1 = mid_32_finish;
    end
    if(when_Tile_l72_46) begin
      resultVaild_5_1 = mid_33_finish;
    end
    if(when_Tile_l72_47) begin
      resultVaild_5_1 = mid_34_finish;
    end
  end

  assign PE_OUT_5 = PE_OUT_5_1_delay_3;
  assign resultVaild_5 = resultVaild_5_1_delay_3;
  always @(*) begin
    PE_OUT_6_1 = 20'h0;
    if(when_Tile_l72_48) begin
      PE_OUT_6_1 = left_5_PE_OUT;
    end
    if(when_Tile_l72_49) begin
      PE_OUT_6_1 = mid_35_PE_OUT;
    end
    if(when_Tile_l72_50) begin
      PE_OUT_6_1 = mid_36_PE_OUT;
    end
    if(when_Tile_l72_51) begin
      PE_OUT_6_1 = mid_37_PE_OUT;
    end
    if(when_Tile_l72_52) begin
      PE_OUT_6_1 = mid_38_PE_OUT;
    end
    if(when_Tile_l72_53) begin
      PE_OUT_6_1 = mid_39_PE_OUT;
    end
    if(when_Tile_l72_54) begin
      PE_OUT_6_1 = mid_40_PE_OUT;
    end
    if(when_Tile_l72_55) begin
      PE_OUT_6_1 = mid_41_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_6_1 = 1'b0;
    if(when_Tile_l72_48) begin
      resultVaild_6_1 = left_5_finish;
    end
    if(when_Tile_l72_49) begin
      resultVaild_6_1 = mid_35_finish;
    end
    if(when_Tile_l72_50) begin
      resultVaild_6_1 = mid_36_finish;
    end
    if(when_Tile_l72_51) begin
      resultVaild_6_1 = mid_37_finish;
    end
    if(when_Tile_l72_52) begin
      resultVaild_6_1 = mid_38_finish;
    end
    if(when_Tile_l72_53) begin
      resultVaild_6_1 = mid_39_finish;
    end
    if(when_Tile_l72_54) begin
      resultVaild_6_1 = mid_40_finish;
    end
    if(when_Tile_l72_55) begin
      resultVaild_6_1 = mid_41_finish;
    end
  end

  assign PE_OUT_6 = PE_OUT_6_1_delay_2;
  assign resultVaild_6 = resultVaild_6_1_delay_2;
  always @(*) begin
    PE_OUT_7_1 = 20'h0;
    if(when_Tile_l72_56) begin
      PE_OUT_7_1 = left_6_PE_OUT;
    end
    if(when_Tile_l72_57) begin
      PE_OUT_7_1 = mid_42_PE_OUT;
    end
    if(when_Tile_l72_58) begin
      PE_OUT_7_1 = mid_43_PE_OUT;
    end
    if(when_Tile_l72_59) begin
      PE_OUT_7_1 = mid_44_PE_OUT;
    end
    if(when_Tile_l72_60) begin
      PE_OUT_7_1 = mid_45_PE_OUT;
    end
    if(when_Tile_l72_61) begin
      PE_OUT_7_1 = mid_46_PE_OUT;
    end
    if(when_Tile_l72_62) begin
      PE_OUT_7_1 = mid_47_PE_OUT;
    end
    if(when_Tile_l72_63) begin
      PE_OUT_7_1 = mid_48_PE_OUT;
    end
  end

  always @(*) begin
    resultVaild_7_1 = 1'b0;
    if(when_Tile_l72_56) begin
      resultVaild_7_1 = left_6_finish;
    end
    if(when_Tile_l72_57) begin
      resultVaild_7_1 = mid_42_finish;
    end
    if(when_Tile_l72_58) begin
      resultVaild_7_1 = mid_43_finish;
    end
    if(when_Tile_l72_59) begin
      resultVaild_7_1 = mid_44_finish;
    end
    if(when_Tile_l72_60) begin
      resultVaild_7_1 = mid_45_finish;
    end
    if(when_Tile_l72_61) begin
      resultVaild_7_1 = mid_46_finish;
    end
    if(when_Tile_l72_62) begin
      resultVaild_7_1 = mid_47_finish;
    end
    if(when_Tile_l72_63) begin
      resultVaild_7_1 = mid_48_finish;
    end
  end

  assign PE_OUT_7 = PE_OUT_7_1_delay_1;
  assign resultVaild_7 = resultVaild_7_1_delay_1;
  assign pE_64_weight = weight[7 : 0];
  assign pE_64_activate = activate[7 : 0];
  assign pE_64_vaild = (a_Valid_0 && b_Valid_0);
  assign left_activate = activate[15 : 8];
  assign left_vaild = (a_Valid_1 && b_Valid_0_delay_1);
  assign left_1_activate = activate[23 : 16];
  assign left_1_vaild = (a_Valid_2 && b_Valid_0_delay_2);
  assign left_2_activate = activate[31 : 24];
  assign left_2_vaild = (a_Valid_3 && b_Valid_0_delay_3);
  assign left_3_activate = activate[39 : 32];
  assign left_3_vaild = (a_Valid_4 && b_Valid_0_delay_4);
  assign left_4_activate = activate[47 : 40];
  assign left_4_vaild = (a_Valid_5 && b_Valid_0_delay_5);
  assign left_5_activate = activate[55 : 48];
  assign left_5_vaild = (a_Valid_6 && b_Valid_0_delay_6);
  assign left_6_activate = activate[63 : 56];
  assign left_6_vaild = (a_Valid_7 && b_Valid_0_delay_7);
  assign top_vaild = (b_Valid_1_delay_1 && a_Valid_0_delay_1);
  assign top_1_vaild = (b_Valid_2_delay_2 && a_Valid_0_delay_2);
  assign top_2_vaild = (b_Valid_3_delay_3 && a_Valid_0_delay_3);
  assign top_3_vaild = (b_Valid_4_delay_4 && a_Valid_0_delay_4);
  assign top_4_vaild = (b_Valid_5_delay_5 && a_Valid_0_delay_5);
  assign top_5_vaild = (b_Valid_6_delay_6 && a_Valid_0_delay_6);
  assign top_6_vaild = (b_Valid_7_delay_7 && a_Valid_0_delay_7);
  assign mid_vaild = (left_vaild_delay_1 && top_vaild_delay_1);
  assign mid_1_vaild = (mid_vaild_delay_1 && top_1_vaild_delay_1);
  assign mid_2_vaild = (mid_1_vaild_delay_1 && top_2_vaild_delay_1);
  assign mid_3_vaild = (mid_2_vaild_delay_1 && top_3_vaild_delay_1);
  assign mid_4_vaild = (mid_3_vaild_delay_1 && top_4_vaild_delay_1);
  assign mid_5_vaild = (mid_4_vaild_delay_1 && top_5_vaild_delay_1);
  assign mid_6_vaild = (mid_5_vaild_delay_1 && top_6_vaild_delay_1);
  assign mid_7_vaild = (left_1_vaild_delay_1 && mid_vaild_delay_1_1);
  assign mid_8_vaild = (mid_7_vaild_delay_1 && mid_1_vaild_delay_1_1);
  assign mid_9_vaild = (mid_8_vaild_delay_1 && mid_2_vaild_delay_1_1);
  assign mid_10_vaild = (mid_9_vaild_delay_1 && mid_3_vaild_delay_1_1);
  assign mid_11_vaild = (mid_10_vaild_delay_1 && mid_4_vaild_delay_1_1);
  assign mid_12_vaild = (mid_11_vaild_delay_1 && mid_5_vaild_delay_1_1);
  assign mid_13_vaild = (mid_12_vaild_delay_1 && mid_6_vaild_delay_1);
  assign mid_14_vaild = (left_2_vaild_delay_1 && mid_7_vaild_delay_1_1);
  assign mid_15_vaild = (mid_14_vaild_delay_1 && mid_8_vaild_delay_1_1);
  assign mid_16_vaild = (mid_15_vaild_delay_1 && mid_9_vaild_delay_1_1);
  assign mid_17_vaild = (mid_16_vaild_delay_1 && mid_10_vaild_delay_1_1);
  assign mid_18_vaild = (mid_17_vaild_delay_1 && mid_11_vaild_delay_1_1);
  assign mid_19_vaild = (mid_18_vaild_delay_1 && mid_12_vaild_delay_1_1);
  assign mid_20_vaild = (mid_19_vaild_delay_1 && mid_13_vaild_delay_1);
  assign mid_21_vaild = (left_3_vaild_delay_1 && mid_14_vaild_delay_1_1);
  assign mid_22_vaild = (mid_21_vaild_delay_1 && mid_15_vaild_delay_1_1);
  assign mid_23_vaild = (mid_22_vaild_delay_1 && mid_16_vaild_delay_1_1);
  assign mid_24_vaild = (mid_23_vaild_delay_1 && mid_17_vaild_delay_1_1);
  assign mid_25_vaild = (mid_24_vaild_delay_1 && mid_18_vaild_delay_1_1);
  assign mid_26_vaild = (mid_25_vaild_delay_1 && mid_19_vaild_delay_1_1);
  assign mid_27_vaild = (mid_26_vaild_delay_1 && mid_20_vaild_delay_1);
  assign mid_28_vaild = (left_4_vaild_delay_1 && mid_21_vaild_delay_1_1);
  assign mid_29_vaild = (mid_28_vaild_delay_1 && mid_22_vaild_delay_1_1);
  assign mid_30_vaild = (mid_29_vaild_delay_1 && mid_23_vaild_delay_1_1);
  assign mid_31_vaild = (mid_30_vaild_delay_1 && mid_24_vaild_delay_1_1);
  assign mid_32_vaild = (mid_31_vaild_delay_1 && mid_25_vaild_delay_1_1);
  assign mid_33_vaild = (mid_32_vaild_delay_1 && mid_26_vaild_delay_1_1);
  assign mid_34_vaild = (mid_33_vaild_delay_1 && mid_27_vaild_delay_1);
  assign mid_35_vaild = (left_5_vaild_delay_1 && mid_28_vaild_delay_1_1);
  assign mid_36_vaild = (mid_35_vaild_delay_1 && mid_29_vaild_delay_1_1);
  assign mid_37_vaild = (mid_36_vaild_delay_1 && mid_30_vaild_delay_1_1);
  assign mid_38_vaild = (mid_37_vaild_delay_1 && mid_31_vaild_delay_1_1);
  assign mid_39_vaild = (mid_38_vaild_delay_1 && mid_32_vaild_delay_1_1);
  assign mid_40_vaild = (mid_39_vaild_delay_1 && mid_33_vaild_delay_1_1);
  assign mid_41_vaild = (mid_40_vaild_delay_1 && mid_34_vaild_delay_1);
  assign mid_42_vaild = (left_6_vaild_delay_1 && mid_35_vaild_delay_1_1);
  assign mid_43_vaild = (mid_42_vaild_delay_1 && mid_36_vaild_delay_1_1);
  assign mid_44_vaild = (mid_43_vaild_delay_1 && mid_37_vaild_delay_1_1);
  assign mid_45_vaild = (mid_44_vaild_delay_1 && mid_38_vaild_delay_1_1);
  assign mid_46_vaild = (mid_45_vaild_delay_1 && mid_39_vaild_delay_1_1);
  assign mid_47_vaild = (mid_46_vaild_delay_1 && mid_40_vaild_delay_1_1);
  assign mid_48_vaild = (mid_47_vaild_delay_1 && mid_41_vaild_delay_1);
  assign when_Tile_l72 = (pE_64_finish == 1'b1);
  assign when_Tile_l72_1 = (top_finish == 1'b1);
  assign when_Tile_l72_2 = (top_1_finish == 1'b1);
  assign when_Tile_l72_3 = (top_2_finish == 1'b1);
  assign when_Tile_l72_4 = (top_3_finish == 1'b1);
  assign when_Tile_l72_5 = (top_4_finish == 1'b1);
  assign when_Tile_l72_6 = (top_5_finish == 1'b1);
  assign when_Tile_l72_7 = (top_6_finish == 1'b1);
  assign when_Tile_l72_8 = (left_finish == 1'b1);
  assign when_Tile_l72_9 = (mid_finish == 1'b1);
  assign when_Tile_l72_10 = (mid_1_finish == 1'b1);
  assign when_Tile_l72_11 = (mid_2_finish == 1'b1);
  assign when_Tile_l72_12 = (mid_3_finish == 1'b1);
  assign when_Tile_l72_13 = (mid_4_finish == 1'b1);
  assign when_Tile_l72_14 = (mid_5_finish == 1'b1);
  assign when_Tile_l72_15 = (mid_6_finish == 1'b1);
  assign when_Tile_l72_16 = (left_1_finish == 1'b1);
  assign when_Tile_l72_17 = (mid_7_finish == 1'b1);
  assign when_Tile_l72_18 = (mid_8_finish == 1'b1);
  assign when_Tile_l72_19 = (mid_9_finish == 1'b1);
  assign when_Tile_l72_20 = (mid_10_finish == 1'b1);
  assign when_Tile_l72_21 = (mid_11_finish == 1'b1);
  assign when_Tile_l72_22 = (mid_12_finish == 1'b1);
  assign when_Tile_l72_23 = (mid_13_finish == 1'b1);
  assign when_Tile_l72_24 = (left_2_finish == 1'b1);
  assign when_Tile_l72_25 = (mid_14_finish == 1'b1);
  assign when_Tile_l72_26 = (mid_15_finish == 1'b1);
  assign when_Tile_l72_27 = (mid_16_finish == 1'b1);
  assign when_Tile_l72_28 = (mid_17_finish == 1'b1);
  assign when_Tile_l72_29 = (mid_18_finish == 1'b1);
  assign when_Tile_l72_30 = (mid_19_finish == 1'b1);
  assign when_Tile_l72_31 = (mid_20_finish == 1'b1);
  assign when_Tile_l72_32 = (left_3_finish == 1'b1);
  assign when_Tile_l72_33 = (mid_21_finish == 1'b1);
  assign when_Tile_l72_34 = (mid_22_finish == 1'b1);
  assign when_Tile_l72_35 = (mid_23_finish == 1'b1);
  assign when_Tile_l72_36 = (mid_24_finish == 1'b1);
  assign when_Tile_l72_37 = (mid_25_finish == 1'b1);
  assign when_Tile_l72_38 = (mid_26_finish == 1'b1);
  assign when_Tile_l72_39 = (mid_27_finish == 1'b1);
  assign when_Tile_l72_40 = (left_4_finish == 1'b1);
  assign when_Tile_l72_41 = (mid_28_finish == 1'b1);
  assign when_Tile_l72_42 = (mid_29_finish == 1'b1);
  assign when_Tile_l72_43 = (mid_30_finish == 1'b1);
  assign when_Tile_l72_44 = (mid_31_finish == 1'b1);
  assign when_Tile_l72_45 = (mid_32_finish == 1'b1);
  assign when_Tile_l72_46 = (mid_33_finish == 1'b1);
  assign when_Tile_l72_47 = (mid_34_finish == 1'b1);
  assign when_Tile_l72_48 = (left_5_finish == 1'b1);
  assign when_Tile_l72_49 = (mid_35_finish == 1'b1);
  assign when_Tile_l72_50 = (mid_36_finish == 1'b1);
  assign when_Tile_l72_51 = (mid_37_finish == 1'b1);
  assign when_Tile_l72_52 = (mid_38_finish == 1'b1);
  assign when_Tile_l72_53 = (mid_39_finish == 1'b1);
  assign when_Tile_l72_54 = (mid_40_finish == 1'b1);
  assign when_Tile_l72_55 = (mid_41_finish == 1'b1);
  assign when_Tile_l72_56 = (left_6_finish == 1'b1);
  assign when_Tile_l72_57 = (mid_42_finish == 1'b1);
  assign when_Tile_l72_58 = (mid_43_finish == 1'b1);
  assign when_Tile_l72_59 = (mid_44_finish == 1'b1);
  assign when_Tile_l72_60 = (mid_45_finish == 1'b1);
  assign when_Tile_l72_61 = (mid_46_finish == 1'b1);
  assign when_Tile_l72_62 = (mid_47_finish == 1'b1);
  assign when_Tile_l72_63 = (mid_48_finish == 1'b1);
  always @(posedge clk) begin
    PE_OUT_0_1_delay_1 <= PE_OUT_0_1;
    PE_OUT_0_1_delay_2 <= PE_OUT_0_1_delay_1;
    PE_OUT_0_1_delay_3 <= PE_OUT_0_1_delay_2;
    PE_OUT_0_1_delay_4 <= PE_OUT_0_1_delay_3;
    PE_OUT_0_1_delay_5 <= PE_OUT_0_1_delay_4;
    PE_OUT_0_1_delay_6 <= PE_OUT_0_1_delay_5;
    PE_OUT_0_1_delay_7 <= PE_OUT_0_1_delay_6;
    PE_OUT_0_1_delay_8 <= PE_OUT_0_1_delay_7;
    resultVaild_0_1_delay_1 <= resultVaild_0_1;
    resultVaild_0_1_delay_2 <= resultVaild_0_1_delay_1;
    resultVaild_0_1_delay_3 <= resultVaild_0_1_delay_2;
    resultVaild_0_1_delay_4 <= resultVaild_0_1_delay_3;
    resultVaild_0_1_delay_5 <= resultVaild_0_1_delay_4;
    resultVaild_0_1_delay_6 <= resultVaild_0_1_delay_5;
    resultVaild_0_1_delay_7 <= resultVaild_0_1_delay_6;
    resultVaild_0_1_delay_8 <= resultVaild_0_1_delay_7;
    PE_OUT_1_1_delay_1 <= PE_OUT_1_1;
    PE_OUT_1_1_delay_2 <= PE_OUT_1_1_delay_1;
    PE_OUT_1_1_delay_3 <= PE_OUT_1_1_delay_2;
    PE_OUT_1_1_delay_4 <= PE_OUT_1_1_delay_3;
    PE_OUT_1_1_delay_5 <= PE_OUT_1_1_delay_4;
    PE_OUT_1_1_delay_6 <= PE_OUT_1_1_delay_5;
    PE_OUT_1_1_delay_7 <= PE_OUT_1_1_delay_6;
    resultVaild_1_1_delay_1 <= resultVaild_1_1;
    resultVaild_1_1_delay_2 <= resultVaild_1_1_delay_1;
    resultVaild_1_1_delay_3 <= resultVaild_1_1_delay_2;
    resultVaild_1_1_delay_4 <= resultVaild_1_1_delay_3;
    resultVaild_1_1_delay_5 <= resultVaild_1_1_delay_4;
    resultVaild_1_1_delay_6 <= resultVaild_1_1_delay_5;
    resultVaild_1_1_delay_7 <= resultVaild_1_1_delay_6;
    PE_OUT_2_1_delay_1 <= PE_OUT_2_1;
    PE_OUT_2_1_delay_2 <= PE_OUT_2_1_delay_1;
    PE_OUT_2_1_delay_3 <= PE_OUT_2_1_delay_2;
    PE_OUT_2_1_delay_4 <= PE_OUT_2_1_delay_3;
    PE_OUT_2_1_delay_5 <= PE_OUT_2_1_delay_4;
    PE_OUT_2_1_delay_6 <= PE_OUT_2_1_delay_5;
    resultVaild_2_1_delay_1 <= resultVaild_2_1;
    resultVaild_2_1_delay_2 <= resultVaild_2_1_delay_1;
    resultVaild_2_1_delay_3 <= resultVaild_2_1_delay_2;
    resultVaild_2_1_delay_4 <= resultVaild_2_1_delay_3;
    resultVaild_2_1_delay_5 <= resultVaild_2_1_delay_4;
    resultVaild_2_1_delay_6 <= resultVaild_2_1_delay_5;
    PE_OUT_3_1_delay_1 <= PE_OUT_3_1;
    PE_OUT_3_1_delay_2 <= PE_OUT_3_1_delay_1;
    PE_OUT_3_1_delay_3 <= PE_OUT_3_1_delay_2;
    PE_OUT_3_1_delay_4 <= PE_OUT_3_1_delay_3;
    PE_OUT_3_1_delay_5 <= PE_OUT_3_1_delay_4;
    resultVaild_3_1_delay_1 <= resultVaild_3_1;
    resultVaild_3_1_delay_2 <= resultVaild_3_1_delay_1;
    resultVaild_3_1_delay_3 <= resultVaild_3_1_delay_2;
    resultVaild_3_1_delay_4 <= resultVaild_3_1_delay_3;
    resultVaild_3_1_delay_5 <= resultVaild_3_1_delay_4;
    PE_OUT_4_1_delay_1 <= PE_OUT_4_1;
    PE_OUT_4_1_delay_2 <= PE_OUT_4_1_delay_1;
    PE_OUT_4_1_delay_3 <= PE_OUT_4_1_delay_2;
    PE_OUT_4_1_delay_4 <= PE_OUT_4_1_delay_3;
    resultVaild_4_1_delay_1 <= resultVaild_4_1;
    resultVaild_4_1_delay_2 <= resultVaild_4_1_delay_1;
    resultVaild_4_1_delay_3 <= resultVaild_4_1_delay_2;
    resultVaild_4_1_delay_4 <= resultVaild_4_1_delay_3;
    PE_OUT_5_1_delay_1 <= PE_OUT_5_1;
    PE_OUT_5_1_delay_2 <= PE_OUT_5_1_delay_1;
    PE_OUT_5_1_delay_3 <= PE_OUT_5_1_delay_2;
    resultVaild_5_1_delay_1 <= resultVaild_5_1;
    resultVaild_5_1_delay_2 <= resultVaild_5_1_delay_1;
    resultVaild_5_1_delay_3 <= resultVaild_5_1_delay_2;
    PE_OUT_6_1_delay_1 <= PE_OUT_6_1;
    PE_OUT_6_1_delay_2 <= PE_OUT_6_1_delay_1;
    resultVaild_6_1_delay_1 <= resultVaild_6_1;
    resultVaild_6_1_delay_2 <= resultVaild_6_1_delay_1;
    PE_OUT_7_1_delay_1 <= PE_OUT_7_1;
    resultVaild_7_1_delay_1 <= resultVaild_7_1;
    b_Valid_0_delay_1 <= b_Valid_0;
    b_Valid_0_delay_1_1 <= b_Valid_0;
    b_Valid_0_delay_2 <= b_Valid_0_delay_1_1;
    b_Valid_0_delay_1_2 <= b_Valid_0;
    b_Valid_0_delay_2_1 <= b_Valid_0_delay_1_2;
    b_Valid_0_delay_3 <= b_Valid_0_delay_2_1;
    b_Valid_0_delay_1_3 <= b_Valid_0;
    b_Valid_0_delay_2_2 <= b_Valid_0_delay_1_3;
    b_Valid_0_delay_3_1 <= b_Valid_0_delay_2_2;
    b_Valid_0_delay_4 <= b_Valid_0_delay_3_1;
    b_Valid_0_delay_1_4 <= b_Valid_0;
    b_Valid_0_delay_2_3 <= b_Valid_0_delay_1_4;
    b_Valid_0_delay_3_2 <= b_Valid_0_delay_2_3;
    b_Valid_0_delay_4_1 <= b_Valid_0_delay_3_2;
    b_Valid_0_delay_5 <= b_Valid_0_delay_4_1;
    b_Valid_0_delay_1_5 <= b_Valid_0;
    b_Valid_0_delay_2_4 <= b_Valid_0_delay_1_5;
    b_Valid_0_delay_3_3 <= b_Valid_0_delay_2_4;
    b_Valid_0_delay_4_2 <= b_Valid_0_delay_3_3;
    b_Valid_0_delay_5_1 <= b_Valid_0_delay_4_2;
    b_Valid_0_delay_6 <= b_Valid_0_delay_5_1;
    b_Valid_0_delay_1_6 <= b_Valid_0;
    b_Valid_0_delay_2_5 <= b_Valid_0_delay_1_6;
    b_Valid_0_delay_3_4 <= b_Valid_0_delay_2_5;
    b_Valid_0_delay_4_3 <= b_Valid_0_delay_3_4;
    b_Valid_0_delay_5_2 <= b_Valid_0_delay_4_3;
    b_Valid_0_delay_6_1 <= b_Valid_0_delay_5_2;
    b_Valid_0_delay_7 <= b_Valid_0_delay_6_1;
    _zz_weight <= weight[15 : 8];
    b_Valid_1_delay_1 <= b_Valid_1;
    a_Valid_0_delay_1 <= a_Valid_0;
    _zz_weight_1 <= weight[23 : 16];
    _zz_weight_2 <= _zz_weight_1;
    b_Valid_2_delay_1 <= b_Valid_2;
    b_Valid_2_delay_2 <= b_Valid_2_delay_1;
    a_Valid_0_delay_1_1 <= a_Valid_0;
    a_Valid_0_delay_2 <= a_Valid_0_delay_1_1;
    _zz_weight_3 <= weight[31 : 24];
    _zz_weight_4 <= _zz_weight_3;
    _zz_weight_5 <= _zz_weight_4;
    b_Valid_3_delay_1 <= b_Valid_3;
    b_Valid_3_delay_2 <= b_Valid_3_delay_1;
    b_Valid_3_delay_3 <= b_Valid_3_delay_2;
    a_Valid_0_delay_1_2 <= a_Valid_0;
    a_Valid_0_delay_2_1 <= a_Valid_0_delay_1_2;
    a_Valid_0_delay_3 <= a_Valid_0_delay_2_1;
    _zz_weight_6 <= weight[39 : 32];
    _zz_weight_7 <= _zz_weight_6;
    _zz_weight_8 <= _zz_weight_7;
    _zz_weight_9 <= _zz_weight_8;
    b_Valid_4_delay_1 <= b_Valid_4;
    b_Valid_4_delay_2 <= b_Valid_4_delay_1;
    b_Valid_4_delay_3 <= b_Valid_4_delay_2;
    b_Valid_4_delay_4 <= b_Valid_4_delay_3;
    a_Valid_0_delay_1_3 <= a_Valid_0;
    a_Valid_0_delay_2_2 <= a_Valid_0_delay_1_3;
    a_Valid_0_delay_3_1 <= a_Valid_0_delay_2_2;
    a_Valid_0_delay_4 <= a_Valid_0_delay_3_1;
    _zz_weight_10 <= weight[47 : 40];
    _zz_weight_11 <= _zz_weight_10;
    _zz_weight_12 <= _zz_weight_11;
    _zz_weight_13 <= _zz_weight_12;
    _zz_weight_14 <= _zz_weight_13;
    b_Valid_5_delay_1 <= b_Valid_5;
    b_Valid_5_delay_2 <= b_Valid_5_delay_1;
    b_Valid_5_delay_3 <= b_Valid_5_delay_2;
    b_Valid_5_delay_4 <= b_Valid_5_delay_3;
    b_Valid_5_delay_5 <= b_Valid_5_delay_4;
    a_Valid_0_delay_1_4 <= a_Valid_0;
    a_Valid_0_delay_2_3 <= a_Valid_0_delay_1_4;
    a_Valid_0_delay_3_2 <= a_Valid_0_delay_2_3;
    a_Valid_0_delay_4_1 <= a_Valid_0_delay_3_2;
    a_Valid_0_delay_5 <= a_Valid_0_delay_4_1;
    _zz_weight_15 <= weight[55 : 48];
    _zz_weight_16 <= _zz_weight_15;
    _zz_weight_17 <= _zz_weight_16;
    _zz_weight_18 <= _zz_weight_17;
    _zz_weight_19 <= _zz_weight_18;
    _zz_weight_20 <= _zz_weight_19;
    b_Valid_6_delay_1 <= b_Valid_6;
    b_Valid_6_delay_2 <= b_Valid_6_delay_1;
    b_Valid_6_delay_3 <= b_Valid_6_delay_2;
    b_Valid_6_delay_4 <= b_Valid_6_delay_3;
    b_Valid_6_delay_5 <= b_Valid_6_delay_4;
    b_Valid_6_delay_6 <= b_Valid_6_delay_5;
    a_Valid_0_delay_1_5 <= a_Valid_0;
    a_Valid_0_delay_2_4 <= a_Valid_0_delay_1_5;
    a_Valid_0_delay_3_3 <= a_Valid_0_delay_2_4;
    a_Valid_0_delay_4_2 <= a_Valid_0_delay_3_3;
    a_Valid_0_delay_5_1 <= a_Valid_0_delay_4_2;
    a_Valid_0_delay_6 <= a_Valid_0_delay_5_1;
    _zz_weight_21 <= weight[63 : 56];
    _zz_weight_22 <= _zz_weight_21;
    _zz_weight_23 <= _zz_weight_22;
    _zz_weight_24 <= _zz_weight_23;
    _zz_weight_25 <= _zz_weight_24;
    _zz_weight_26 <= _zz_weight_25;
    _zz_weight_27 <= _zz_weight_26;
    b_Valid_7_delay_1 <= b_Valid_7;
    b_Valid_7_delay_2 <= b_Valid_7_delay_1;
    b_Valid_7_delay_3 <= b_Valid_7_delay_2;
    b_Valid_7_delay_4 <= b_Valid_7_delay_3;
    b_Valid_7_delay_5 <= b_Valid_7_delay_4;
    b_Valid_7_delay_6 <= b_Valid_7_delay_5;
    b_Valid_7_delay_7 <= b_Valid_7_delay_6;
    a_Valid_0_delay_1_6 <= a_Valid_0;
    a_Valid_0_delay_2_5 <= a_Valid_0_delay_1_6;
    a_Valid_0_delay_3_4 <= a_Valid_0_delay_2_5;
    a_Valid_0_delay_4_3 <= a_Valid_0_delay_3_4;
    a_Valid_0_delay_5_2 <= a_Valid_0_delay_4_3;
    a_Valid_0_delay_6_1 <= a_Valid_0_delay_5_2;
    a_Valid_0_delay_7 <= a_Valid_0_delay_6_1;
    left_vaild_delay_1 <= left_vaild;
    top_vaild_delay_1 <= top_vaild;
    mid_vaild_delay_1 <= mid_vaild;
    top_1_vaild_delay_1 <= top_1_vaild;
    mid_1_vaild_delay_1 <= mid_1_vaild;
    top_2_vaild_delay_1 <= top_2_vaild;
    mid_2_vaild_delay_1 <= mid_2_vaild;
    top_3_vaild_delay_1 <= top_3_vaild;
    mid_3_vaild_delay_1 <= mid_3_vaild;
    top_4_vaild_delay_1 <= top_4_vaild;
    mid_4_vaild_delay_1 <= mid_4_vaild;
    top_5_vaild_delay_1 <= top_5_vaild;
    mid_5_vaild_delay_1 <= mid_5_vaild;
    top_6_vaild_delay_1 <= top_6_vaild;
    left_1_vaild_delay_1 <= left_1_vaild;
    mid_vaild_delay_1_1 <= mid_vaild;
    mid_7_vaild_delay_1 <= mid_7_vaild;
    mid_1_vaild_delay_1_1 <= mid_1_vaild;
    mid_8_vaild_delay_1 <= mid_8_vaild;
    mid_2_vaild_delay_1_1 <= mid_2_vaild;
    mid_9_vaild_delay_1 <= mid_9_vaild;
    mid_3_vaild_delay_1_1 <= mid_3_vaild;
    mid_10_vaild_delay_1 <= mid_10_vaild;
    mid_4_vaild_delay_1_1 <= mid_4_vaild;
    mid_11_vaild_delay_1 <= mid_11_vaild;
    mid_5_vaild_delay_1_1 <= mid_5_vaild;
    mid_12_vaild_delay_1 <= mid_12_vaild;
    mid_6_vaild_delay_1 <= mid_6_vaild;
    left_2_vaild_delay_1 <= left_2_vaild;
    mid_7_vaild_delay_1_1 <= mid_7_vaild;
    mid_14_vaild_delay_1 <= mid_14_vaild;
    mid_8_vaild_delay_1_1 <= mid_8_vaild;
    mid_15_vaild_delay_1 <= mid_15_vaild;
    mid_9_vaild_delay_1_1 <= mid_9_vaild;
    mid_16_vaild_delay_1 <= mid_16_vaild;
    mid_10_vaild_delay_1_1 <= mid_10_vaild;
    mid_17_vaild_delay_1 <= mid_17_vaild;
    mid_11_vaild_delay_1_1 <= mid_11_vaild;
    mid_18_vaild_delay_1 <= mid_18_vaild;
    mid_12_vaild_delay_1_1 <= mid_12_vaild;
    mid_19_vaild_delay_1 <= mid_19_vaild;
    mid_13_vaild_delay_1 <= mid_13_vaild;
    left_3_vaild_delay_1 <= left_3_vaild;
    mid_14_vaild_delay_1_1 <= mid_14_vaild;
    mid_21_vaild_delay_1 <= mid_21_vaild;
    mid_15_vaild_delay_1_1 <= mid_15_vaild;
    mid_22_vaild_delay_1 <= mid_22_vaild;
    mid_16_vaild_delay_1_1 <= mid_16_vaild;
    mid_23_vaild_delay_1 <= mid_23_vaild;
    mid_17_vaild_delay_1_1 <= mid_17_vaild;
    mid_24_vaild_delay_1 <= mid_24_vaild;
    mid_18_vaild_delay_1_1 <= mid_18_vaild;
    mid_25_vaild_delay_1 <= mid_25_vaild;
    mid_19_vaild_delay_1_1 <= mid_19_vaild;
    mid_26_vaild_delay_1 <= mid_26_vaild;
    mid_20_vaild_delay_1 <= mid_20_vaild;
    left_4_vaild_delay_1 <= left_4_vaild;
    mid_21_vaild_delay_1_1 <= mid_21_vaild;
    mid_28_vaild_delay_1 <= mid_28_vaild;
    mid_22_vaild_delay_1_1 <= mid_22_vaild;
    mid_29_vaild_delay_1 <= mid_29_vaild;
    mid_23_vaild_delay_1_1 <= mid_23_vaild;
    mid_30_vaild_delay_1 <= mid_30_vaild;
    mid_24_vaild_delay_1_1 <= mid_24_vaild;
    mid_31_vaild_delay_1 <= mid_31_vaild;
    mid_25_vaild_delay_1_1 <= mid_25_vaild;
    mid_32_vaild_delay_1 <= mid_32_vaild;
    mid_26_vaild_delay_1_1 <= mid_26_vaild;
    mid_33_vaild_delay_1 <= mid_33_vaild;
    mid_27_vaild_delay_1 <= mid_27_vaild;
    left_5_vaild_delay_1 <= left_5_vaild;
    mid_28_vaild_delay_1_1 <= mid_28_vaild;
    mid_35_vaild_delay_1 <= mid_35_vaild;
    mid_29_vaild_delay_1_1 <= mid_29_vaild;
    mid_36_vaild_delay_1 <= mid_36_vaild;
    mid_30_vaild_delay_1_1 <= mid_30_vaild;
    mid_37_vaild_delay_1 <= mid_37_vaild;
    mid_31_vaild_delay_1_1 <= mid_31_vaild;
    mid_38_vaild_delay_1 <= mid_38_vaild;
    mid_32_vaild_delay_1_1 <= mid_32_vaild;
    mid_39_vaild_delay_1 <= mid_39_vaild;
    mid_33_vaild_delay_1_1 <= mid_33_vaild;
    mid_40_vaild_delay_1 <= mid_40_vaild;
    mid_34_vaild_delay_1 <= mid_34_vaild;
    left_6_vaild_delay_1 <= left_6_vaild;
    mid_35_vaild_delay_1_1 <= mid_35_vaild;
    mid_42_vaild_delay_1 <= mid_42_vaild;
    mid_36_vaild_delay_1_1 <= mid_36_vaild;
    mid_43_vaild_delay_1 <= mid_43_vaild;
    mid_37_vaild_delay_1_1 <= mid_37_vaild;
    mid_44_vaild_delay_1 <= mid_44_vaild;
    mid_38_vaild_delay_1_1 <= mid_38_vaild;
    mid_45_vaild_delay_1 <= mid_45_vaild;
    mid_39_vaild_delay_1_1 <= mid_39_vaild;
    mid_46_vaild_delay_1 <= mid_46_vaild;
    mid_40_vaild_delay_1_1 <= mid_40_vaild;
    mid_47_vaild_delay_1 <= mid_47_vaild;
    mid_41_vaild_delay_1 <= mid_41_vaild;
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
  wire                when_Stream_l1021;
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
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
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
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

//PE replaced by PE

module PE (
  input      [7:0]    activate,
  input      [7:0]    weight,
  input               vaild,
  input      [15:0]   signCount,
  output     [7:0]    acount,
  output     [7:0]    bcount,
  output reg [19:0]   PE_OUT,
  output              finish,
  input               clk,
  input               reset
);

  wire       [15:0]   dsp_P;
  wire       [19:0]   _zz_reg1;
  wire       [19:0]   _zz_reg1_1;
  wire       [19:0]   _zz_reg1_2;
  reg        [19:0]   reg1;
  reg                 vaild_regNext;
  reg                 vaild_regNext_1;
  reg                 vaild_regNext_1_regNext;
  reg        [15:0]   finishCnt_count;
  wire                finishCnt_valid;
  reg        [7:0]    activate_regNext;
  reg        [7:0]    weight_regNext;

  assign _zz_reg1 = {{4{dsp_P[15]}}, dsp_P};
  assign _zz_reg1_1 = {{4{dsp_P[15]}}, dsp_P};
  assign _zz_reg1_2 = 20'h0;
  dsp_marco dsp (
    .CLK (clk          ), //i
    .A   (activate[7:0]), //i
    .B   (weight[7:0]  ), //i
    .P   (dsp_P[15:0]  )  //o
  );
  assign finishCnt_valid = ((finishCnt_count == signCount) && vaild_regNext_1_regNext);
  assign finish = finishCnt_valid;
  always @(*) begin
    if(finishCnt_valid) begin
      PE_OUT = reg1;
    end else begin
      PE_OUT = 20'h0;
    end
  end

  assign acount = activate_regNext;
  assign bcount = weight_regNext;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      reg1 <= 20'h0;
      finishCnt_count <= 16'h0;
    end else begin
      if(vaild_regNext) begin
        reg1 <= ($signed(_zz_reg1) + $signed(reg1));
      end
      if(vaild_regNext_1_regNext) begin
        if(finishCnt_valid) begin
          finishCnt_count <= 16'h0;
        end else begin
          finishCnt_count <= (finishCnt_count + 16'h0001);
        end
      end
      if(finishCnt_valid) begin
        reg1 <= (vaild ? _zz_reg1_1 : _zz_reg1_2);
      end
    end
  end

  always @(posedge clk) begin
    vaild_regNext <= vaild;
    vaild_regNext_1 <= vaild;
    vaild_regNext_1_regNext <= vaild_regNext_1;
    activate_regNext <= activate;
    weight_regNext <= weight;
  end


endmodule
