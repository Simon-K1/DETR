// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : ConvOutput
// Git hash  : 1327eefc5a3869a7a129faaf31454f1f76d3e07d

`timescale 1ns/1ps

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
  wire       [0:0]    _zz_when_ConvOutput_l146;
  wire       [0:0]    _zz_when_ConvOutput_l146_1;
  wire       [0:0]    _zz_when_ConvOutput_l146_2;
  wire       [0:0]    _zz_when_ConvOutput_l146_3;
  wire       [0:0]    _zz_when_ConvOutput_l146_4;
  wire       [0:0]    _zz_when_ConvOutput_l146_5;
  wire       [0:0]    _zz_when_ConvOutput_l146_6;
  wire       [0:0]    _zz_when_ConvOutput_l146_7;
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
  wire                when_ConvOutput_l146;
  wire                when_ConvOutput_l146_1;
  wire                when_ConvOutput_l146_2;
  wire                when_ConvOutput_l146_3;
  wire                when_ConvOutput_l146_4;
  wire                when_ConvOutput_l146_5;
  wire                when_ConvOutput_l146_6;
  wire                when_ConvOutput_l146_7;
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
  assign _zz_when_ConvOutput_l146 = OutSwitch[0 : 0];
  assign _zz_when_ConvOutput_l146_1 = OutSwitch[1 : 1];
  assign _zz_when_ConvOutput_l146_2 = OutSwitch[2 : 2];
  assign _zz_when_ConvOutput_l146_3 = OutSwitch[3 : 3];
  assign _zz_when_ConvOutput_l146_4 = OutSwitch[4 : 4];
  assign _zz_when_ConvOutput_l146_5 = OutSwitch[5 : 5];
  assign _zz_when_ConvOutput_l146_6 = OutSwitch[6 : 6];
  assign _zz_when_ConvOutput_l146_7 = OutSwitch[7 : 7];
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
    if(when_ConvOutput_l146) begin
      mData_payload = streamFifo_io_pop_payload;
    end
    if(when_ConvOutput_l146_1) begin
      mData_payload = streamFifo_1_io_pop_payload;
    end
    if(when_ConvOutput_l146_2) begin
      mData_payload = streamFifo_2_io_pop_payload;
    end
    if(when_ConvOutput_l146_3) begin
      mData_payload = streamFifo_3_io_pop_payload;
    end
    if(when_ConvOutput_l146_4) begin
      mData_payload = streamFifo_4_io_pop_payload;
    end
    if(when_ConvOutput_l146_5) begin
      mData_payload = streamFifo_5_io_pop_payload;
    end
    if(when_ConvOutput_l146_6) begin
      mData_payload = streamFifo_6_io_pop_payload;
    end
    if(when_ConvOutput_l146_7) begin
      mData_payload = streamFifo_7_io_pop_payload;
    end
  end

  always @(*) begin
    mData_valid = 1'b0;
    if(when_ConvOutput_l146) begin
      mData_valid = streamFifo_io_pop_valid;
    end
    if(when_ConvOutput_l146_1) begin
      mData_valid = streamFifo_1_io_pop_valid;
    end
    if(when_ConvOutput_l146_2) begin
      mData_valid = streamFifo_2_io_pop_valid;
    end
    if(when_ConvOutput_l146_3) begin
      mData_valid = streamFifo_3_io_pop_valid;
    end
    if(when_ConvOutput_l146_4) begin
      mData_valid = streamFifo_4_io_pop_valid;
    end
    if(when_ConvOutput_l146_5) begin
      mData_valid = streamFifo_5_io_pop_valid;
    end
    if(when_ConvOutput_l146_6) begin
      mData_valid = streamFifo_6_io_pop_valid;
    end
    if(when_ConvOutput_l146_7) begin
      mData_valid = streamFifo_7_io_pop_valid;
    end
  end

  assign axisDataConverter_inStream_payload = sData[7 : 0];
  assign sReady = (axisDataConverter_inStream_ready && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  assign axisDataConverter_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146) begin
      streamFifo_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146 = _zz_when_ConvOutput_l146[0];
  assign axisDataConverter_1_inStream_payload = sData[15 : 8];
  assign axisDataConverter_1_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_1_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_1) begin
      streamFifo_1_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_1 = _zz_when_ConvOutput_l146_1[0];
  assign axisDataConverter_2_inStream_payload = sData[23 : 16];
  assign axisDataConverter_2_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_2_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_2) begin
      streamFifo_2_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_2 = _zz_when_ConvOutput_l146_2[0];
  assign axisDataConverter_3_inStream_payload = sData[31 : 24];
  assign axisDataConverter_3_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_3_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_3) begin
      streamFifo_3_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_3 = _zz_when_ConvOutput_l146_3[0];
  assign axisDataConverter_4_inStream_payload = sData[39 : 32];
  assign axisDataConverter_4_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_4_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_4) begin
      streamFifo_4_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_4 = _zz_when_ConvOutput_l146_4[0];
  assign axisDataConverter_5_inStream_payload = sData[47 : 40];
  assign axisDataConverter_5_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_5_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_5) begin
      streamFifo_5_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_5 = _zz_when_ConvOutput_l146_5[0];
  assign axisDataConverter_6_inStream_payload = sData[55 : 48];
  assign axisDataConverter_6_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_6_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_6) begin
      streamFifo_6_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_6 = _zz_when_ConvOutput_l146_6[0];
  assign axisDataConverter_7_inStream_payload = sData[63 : 56];
  assign axisDataConverter_7_inStream_valid = (sValid && ((Fsm_currentState & CONVOUTPUT_ENUM_DATA_ARRANGEMENT) != 4'b0000));
  always @(*) begin
    streamFifo_7_io_pop_ready = 1'b0;
    if(when_ConvOutput_l146_7) begin
      streamFifo_7_io_pop_ready = mData_ready;
    end
  end

  assign when_ConvOutput_l146_7 = _zz_when_ConvOutput_l146_7[0];
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
