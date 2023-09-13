// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : ConvQuant
// Git hash  : b2a922209f98818aa020387be356cd793579745a

`timescale 1ns/1ps

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
  wire                when_Quan_l35;
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
  reg        [7:0]    InMatrixCol_Cnt_count;
  wire                InMatrixCol_Cnt_valid;
  reg        [8:0]    OutCol_Cnt_count;
  wire                OutCol_Cnt_valid;
  `ifndef SYNTHESIS
  reg [79:0] Fsm_currentState_string;
  reg [79:0] Fsm_nextState_string;
  `endif


  assign _zz_InMatrixCol_Cnt_valid = {7'd0, InMatrixCol_Cnt_count};
  assign _zz_InMatrixCol_Cnt_valid_1 = (_zz_InMatrixCol_Cnt_valid_2 - 15'h0001);
  assign _zz_InMatrixCol_Cnt_valid_2 = (OutMatrix_Col >>> 1);
  assign _zz_OutCol_Cnt_valid = {7'd0, OutCol_Cnt_count};
  assign _zz_OutCol_Cnt_valid_1 = (OutMatrix_Col - 16'h0001);
  ConvQuan_Bram BiasCache (
    .clka  (clk                       ), //i
    .addra (InMatrixCol_Cnt_count[7:0]), //i
    .dina  (sData_payload[63:0]       ), //i
    .ena   (BiasCache_ena             ), //i
    .wea   (1'b1                      ), //i
    .addrb (OutCol_Cnt_count[8:0]     ), //i
    .doutb (BiasCache_doutb[31:0]     ), //o
    .clkb  (clk                       )  //i
  );
  ConvQuan_Bram ScaleCache (
    .clka  (clk                       ), //i
    .addra (InMatrixCol_Cnt_count[7:0]), //i
    .dina  (sData_payload[63:0]       ), //i
    .ena   (ScaleCache_ena            ), //i
    .wea   (1'b1                      ), //i
    .addrb (OutCol_Cnt_count[8:0]     ), //i
    .doutb (ScaleCache_doutb[31:0]    ), //o
    .clkb  (clk                       )  //i
  );
  ConvQuan_Bram ShiftCache (
    .clka  (clk                       ), //i
    .addra (InMatrixCol_Cnt_count[7:0]), //i
    .dina  (sData_payload[63:0]       ), //i
    .ena   (ShiftCache_ena            ), //i
    .wea   (1'b1                      ), //i
    .addrb (OutCol_Cnt_count[8:0]     ), //i
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

  assign when_Quan_l35 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & ConvQuan_ENUM_IDLE) == ConvQuan_ENUM_IDLE) : begin
        if(when_Quan_l35) begin
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
  always @(posedge clk) begin
    start_regNext <= start;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= ConvQuan_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      InMatrixCol_Cnt_count <= 8'h0;
      OutCol_Cnt_count <= 9'h0;
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
          InMatrixCol_Cnt_count <= 8'h0;
        end else begin
          InMatrixCol_Cnt_count <= (InMatrixCol_Cnt_count + 8'h01);
        end
      end
      if(SAOutput_Valid) begin
        if(OutCol_Cnt_valid) begin
          OutCol_Cnt_count <= 9'h0;
        end else begin
          OutCol_Cnt_count <= (OutCol_Cnt_count + 9'h001);
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
  wire       [15:0]   _zz_when_QuantModule_l163;
  wire       [15:0]   _zz_normalData_1;
  wire       [15:0]   _zz_when_QuantModule_l163_1;
  wire       [15:0]   _zz_normalData_2;
  wire       [15:0]   _zz_when_QuantModule_l163_2;
  wire       [15:0]   _zz_normalData_3;
  wire       [15:0]   _zz_when_QuantModule_l163_3;
  wire       [15:0]   _zz_normalData_4;
  wire       [15:0]   _zz_when_QuantModule_l163_4;
  wire       [15:0]   _zz_normalData_5;
  wire       [15:0]   _zz_when_QuantModule_l163_5;
  wire       [15:0]   _zz_normalData_6;
  wire       [15:0]   _zz_when_QuantModule_l163_6;
  wire       [15:0]   _zz_normalData_7;
  wire       [15:0]   _zz_when_QuantModule_l163_7;
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
  wire                when_QuantModule_l161;
  wire                when_QuantModule_l163;
  wire                when_QuantModule_l161_1;
  wire                when_QuantModule_l163_1;
  wire                when_QuantModule_l161_2;
  wire                when_QuantModule_l163_2;
  wire                when_QuantModule_l161_3;
  wire                when_QuantModule_l163_3;
  wire                when_QuantModule_l161_4;
  wire                when_QuantModule_l163_4;
  wire                when_QuantModule_l161_5;
  wire                when_QuantModule_l163_5;
  wire                when_QuantModule_l161_6;
  wire                when_QuantModule_l163_6;
  wire                when_QuantModule_l161_7;
  wire                when_QuantModule_l163_7;

  assign _zz_normalData_0 = addZeroTemp_0;
  assign _zz_when_QuantModule_l163 = 16'h00ff;
  assign _zz_normalData_1 = addZeroTemp_1;
  assign _zz_when_QuantModule_l163_1 = 16'h00ff;
  assign _zz_normalData_2 = addZeroTemp_2;
  assign _zz_when_QuantModule_l163_2 = 16'h00ff;
  assign _zz_normalData_3 = addZeroTemp_3;
  assign _zz_when_QuantModule_l163_3 = 16'h00ff;
  assign _zz_normalData_4 = addZeroTemp_4;
  assign _zz_when_QuantModule_l163_4 = 16'h00ff;
  assign _zz_normalData_5 = addZeroTemp_5;
  assign _zz_when_QuantModule_l163_5 = 16'h00ff;
  assign _zz_normalData_6 = addZeroTemp_6;
  assign _zz_when_QuantModule_l163_6 = 16'h00ff;
  assign _zz_normalData_7 = addZeroTemp_7;
  assign _zz_when_QuantModule_l163_7 = 16'h00ff;
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
  assign when_QuantModule_l161 = addZeroTemp_0[15];
  assign when_QuantModule_l163 = ($signed(_zz_when_QuantModule_l163) < $signed(addZeroTemp_0));
  assign when_QuantModule_l161_1 = addZeroTemp_1[15];
  assign when_QuantModule_l163_1 = ($signed(_zz_when_QuantModule_l163_1) < $signed(addZeroTemp_1));
  assign when_QuantModule_l161_2 = addZeroTemp_2[15];
  assign when_QuantModule_l163_2 = ($signed(_zz_when_QuantModule_l163_2) < $signed(addZeroTemp_2));
  assign when_QuantModule_l161_3 = addZeroTemp_3[15];
  assign when_QuantModule_l163_3 = ($signed(_zz_when_QuantModule_l163_3) < $signed(addZeroTemp_3));
  assign when_QuantModule_l161_4 = addZeroTemp_4[15];
  assign when_QuantModule_l163_4 = ($signed(_zz_when_QuantModule_l163_4) < $signed(addZeroTemp_4));
  assign when_QuantModule_l161_5 = addZeroTemp_5[15];
  assign when_QuantModule_l163_5 = ($signed(_zz_when_QuantModule_l163_5) < $signed(addZeroTemp_5));
  assign when_QuantModule_l161_6 = addZeroTemp_6[15];
  assign when_QuantModule_l163_6 = ($signed(_zz_when_QuantModule_l163_6) < $signed(addZeroTemp_6));
  assign when_QuantModule_l161_7 = addZeroTemp_7[15];
  assign when_QuantModule_l163_7 = ($signed(_zz_when_QuantModule_l163_7) < $signed(addZeroTemp_7));
  always @(posedge clk) begin
    if(when_QuantModule_l161) begin
      normalData_0 <= 8'h0;
    end else begin
      if(when_QuantModule_l163) begin
        normalData_0 <= 8'hff;
      end else begin
        normalData_0 <= _zz_normalData_0[7:0];
      end
    end
    if(when_QuantModule_l161_1) begin
      normalData_1 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_1) begin
        normalData_1 <= 8'hff;
      end else begin
        normalData_1 <= _zz_normalData_1[7:0];
      end
    end
    if(when_QuantModule_l161_2) begin
      normalData_2 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_2) begin
        normalData_2 <= 8'hff;
      end else begin
        normalData_2 <= _zz_normalData_2[7:0];
      end
    end
    if(when_QuantModule_l161_3) begin
      normalData_3 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_3) begin
        normalData_3 <= 8'hff;
      end else begin
        normalData_3 <= _zz_normalData_3[7:0];
      end
    end
    if(when_QuantModule_l161_4) begin
      normalData_4 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_4) begin
        normalData_4 <= 8'hff;
      end else begin
        normalData_4 <= _zz_normalData_4[7:0];
      end
    end
    if(when_QuantModule_l161_5) begin
      normalData_5 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_5) begin
        normalData_5 <= 8'hff;
      end else begin
        normalData_5 <= _zz_normalData_5[7:0];
      end
    end
    if(when_QuantModule_l161_6) begin
      normalData_6 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_6) begin
        normalData_6 <= 8'hff;
      end else begin
        normalData_6 <= _zz_normalData_6[7:0];
      end
    end
    if(when_QuantModule_l161_7) begin
      normalData_7 <= 8'h0;
    end else begin
      if(when_QuantModule_l163_7) begin
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
  wire       [31:0]   _zz_when_QuantModule_l120;
  reg        [15:0]   _zz_shift_dataOut_0;
  wire                when_QuantModule_l120;
  wire       [31:0]   _zz_when_QuantModule_l120_1;
  reg        [15:0]   _zz_shift_dataOut_1;
  wire                when_QuantModule_l120_1;
  wire       [31:0]   _zz_when_QuantModule_l120_2;
  reg        [15:0]   _zz_shift_dataOut_2;
  wire                when_QuantModule_l120_2;
  wire       [31:0]   _zz_when_QuantModule_l120_3;
  reg        [15:0]   _zz_shift_dataOut_3;
  wire                when_QuantModule_l120_3;
  wire       [31:0]   _zz_when_QuantModule_l120_4;
  reg        [15:0]   _zz_shift_dataOut_4;
  wire                when_QuantModule_l120_4;
  wire       [31:0]   _zz_when_QuantModule_l120_5;
  reg        [15:0]   _zz_shift_dataOut_5;
  wire                when_QuantModule_l120_5;
  wire       [31:0]   _zz_when_QuantModule_l120_6;
  reg        [15:0]   _zz_shift_dataOut_6;
  wire                when_QuantModule_l120_6;
  wire       [31:0]   _zz_when_QuantModule_l120_7;
  reg        [15:0]   _zz_shift_dataOut_7;
  wire                when_QuantModule_l120_7;

  assign _zz__zz_shift_dataOut_0 = {_zz__zz_shift_dataOut_0_1,_zz__zz_shift_dataOut_0_2};
  assign _zz__zz_shift_dataOut_0_1 = _zz_when_QuantModule_l120[31];
  assign _zz__zz_shift_dataOut_0_2 = _zz_when_QuantModule_l120[15 : 1];
  assign _zz__zz_shift_dataOut_0_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_0_4 = _zz_when_QuantModule_l120[31];
  assign _zz__zz_shift_dataOut_0_5 = _zz_when_QuantModule_l120[15 : 1];
  assign _zz__zz_shift_dataOut_1 = {_zz__zz_shift_dataOut_1_1,_zz__zz_shift_dataOut_1_2};
  assign _zz__zz_shift_dataOut_1_1 = _zz_when_QuantModule_l120_1[31];
  assign _zz__zz_shift_dataOut_1_2 = _zz_when_QuantModule_l120_1[15 : 1];
  assign _zz__zz_shift_dataOut_1_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_1_4 = _zz_when_QuantModule_l120_1[31];
  assign _zz__zz_shift_dataOut_1_5 = _zz_when_QuantModule_l120_1[15 : 1];
  assign _zz__zz_shift_dataOut_2 = {_zz__zz_shift_dataOut_2_1,_zz__zz_shift_dataOut_2_2};
  assign _zz__zz_shift_dataOut_2_1 = _zz_when_QuantModule_l120_2[31];
  assign _zz__zz_shift_dataOut_2_2 = _zz_when_QuantModule_l120_2[15 : 1];
  assign _zz__zz_shift_dataOut_2_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_2_4 = _zz_when_QuantModule_l120_2[31];
  assign _zz__zz_shift_dataOut_2_5 = _zz_when_QuantModule_l120_2[15 : 1];
  assign _zz__zz_shift_dataOut_3 = {_zz__zz_shift_dataOut_3_1,_zz__zz_shift_dataOut_3_2};
  assign _zz__zz_shift_dataOut_3_1 = _zz_when_QuantModule_l120_3[31];
  assign _zz__zz_shift_dataOut_3_2 = _zz_when_QuantModule_l120_3[15 : 1];
  assign _zz__zz_shift_dataOut_3_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_3_4 = _zz_when_QuantModule_l120_3[31];
  assign _zz__zz_shift_dataOut_3_5 = _zz_when_QuantModule_l120_3[15 : 1];
  assign _zz__zz_shift_dataOut_4 = {_zz__zz_shift_dataOut_4_1,_zz__zz_shift_dataOut_4_2};
  assign _zz__zz_shift_dataOut_4_1 = _zz_when_QuantModule_l120_4[31];
  assign _zz__zz_shift_dataOut_4_2 = _zz_when_QuantModule_l120_4[15 : 1];
  assign _zz__zz_shift_dataOut_4_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_4_4 = _zz_when_QuantModule_l120_4[31];
  assign _zz__zz_shift_dataOut_4_5 = _zz_when_QuantModule_l120_4[15 : 1];
  assign _zz__zz_shift_dataOut_5 = {_zz__zz_shift_dataOut_5_1,_zz__zz_shift_dataOut_5_2};
  assign _zz__zz_shift_dataOut_5_1 = _zz_when_QuantModule_l120_5[31];
  assign _zz__zz_shift_dataOut_5_2 = _zz_when_QuantModule_l120_5[15 : 1];
  assign _zz__zz_shift_dataOut_5_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_5_4 = _zz_when_QuantModule_l120_5[31];
  assign _zz__zz_shift_dataOut_5_5 = _zz_when_QuantModule_l120_5[15 : 1];
  assign _zz__zz_shift_dataOut_6 = {_zz__zz_shift_dataOut_6_1,_zz__zz_shift_dataOut_6_2};
  assign _zz__zz_shift_dataOut_6_1 = _zz_when_QuantModule_l120_6[31];
  assign _zz__zz_shift_dataOut_6_2 = _zz_when_QuantModule_l120_6[15 : 1];
  assign _zz__zz_shift_dataOut_6_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_6_4 = _zz_when_QuantModule_l120_6[31];
  assign _zz__zz_shift_dataOut_6_5 = _zz_when_QuantModule_l120_6[15 : 1];
  assign _zz__zz_shift_dataOut_7 = {_zz__zz_shift_dataOut_7_1,_zz__zz_shift_dataOut_7_2};
  assign _zz__zz_shift_dataOut_7_1 = _zz_when_QuantModule_l120_7[31];
  assign _zz__zz_shift_dataOut_7_2 = _zz_when_QuantModule_l120_7[15 : 1];
  assign _zz__zz_shift_dataOut_7_3 = 16'h0001;
  assign _zz__zz_shift_dataOut_7_4 = _zz_when_QuantModule_l120_7[31];
  assign _zz__zz_shift_dataOut_7_5 = _zz_when_QuantModule_l120_7[15 : 1];
  assign _zz_when_QuantModule_l120 = ($signed(shift_dataIn_0) >>> shift_quan);
  assign when_QuantModule_l120 = _zz_when_QuantModule_l120[0];
  assign shift_dataOut_0 = _zz_shift_dataOut_0;
  assign _zz_when_QuantModule_l120_1 = ($signed(shift_dataIn_1) >>> shift_quan);
  assign when_QuantModule_l120_1 = _zz_when_QuantModule_l120_1[0];
  assign shift_dataOut_1 = _zz_shift_dataOut_1;
  assign _zz_when_QuantModule_l120_2 = ($signed(shift_dataIn_2) >>> shift_quan);
  assign when_QuantModule_l120_2 = _zz_when_QuantModule_l120_2[0];
  assign shift_dataOut_2 = _zz_shift_dataOut_2;
  assign _zz_when_QuantModule_l120_3 = ($signed(shift_dataIn_3) >>> shift_quan);
  assign when_QuantModule_l120_3 = _zz_when_QuantModule_l120_3[0];
  assign shift_dataOut_3 = _zz_shift_dataOut_3;
  assign _zz_when_QuantModule_l120_4 = ($signed(shift_dataIn_4) >>> shift_quan);
  assign when_QuantModule_l120_4 = _zz_when_QuantModule_l120_4[0];
  assign shift_dataOut_4 = _zz_shift_dataOut_4;
  assign _zz_when_QuantModule_l120_5 = ($signed(shift_dataIn_5) >>> shift_quan);
  assign when_QuantModule_l120_5 = _zz_when_QuantModule_l120_5[0];
  assign shift_dataOut_5 = _zz_shift_dataOut_5;
  assign _zz_when_QuantModule_l120_6 = ($signed(shift_dataIn_6) >>> shift_quan);
  assign when_QuantModule_l120_6 = _zz_when_QuantModule_l120_6[0];
  assign shift_dataOut_6 = _zz_shift_dataOut_6;
  assign _zz_when_QuantModule_l120_7 = ($signed(shift_dataIn_7) >>> shift_quan);
  assign when_QuantModule_l120_7 = _zz_when_QuantModule_l120_7[0];
  assign shift_dataOut_7 = _zz_shift_dataOut_7;
  always @(posedge clk) begin
    if(when_QuantModule_l120) begin
      _zz_shift_dataOut_0 <= ($signed(_zz__zz_shift_dataOut_0) + $signed(_zz__zz_shift_dataOut_0_3));
    end else begin
      _zz_shift_dataOut_0 <= {_zz__zz_shift_dataOut_0_4,_zz__zz_shift_dataOut_0_5};
    end
    if(when_QuantModule_l120_1) begin
      _zz_shift_dataOut_1 <= ($signed(_zz__zz_shift_dataOut_1) + $signed(_zz__zz_shift_dataOut_1_3));
    end else begin
      _zz_shift_dataOut_1 <= {_zz__zz_shift_dataOut_1_4,_zz__zz_shift_dataOut_1_5};
    end
    if(when_QuantModule_l120_2) begin
      _zz_shift_dataOut_2 <= ($signed(_zz__zz_shift_dataOut_2) + $signed(_zz__zz_shift_dataOut_2_3));
    end else begin
      _zz_shift_dataOut_2 <= {_zz__zz_shift_dataOut_2_4,_zz__zz_shift_dataOut_2_5};
    end
    if(when_QuantModule_l120_3) begin
      _zz_shift_dataOut_3 <= ($signed(_zz__zz_shift_dataOut_3) + $signed(_zz__zz_shift_dataOut_3_3));
    end else begin
      _zz_shift_dataOut_3 <= {_zz__zz_shift_dataOut_3_4,_zz__zz_shift_dataOut_3_5};
    end
    if(when_QuantModule_l120_4) begin
      _zz_shift_dataOut_4 <= ($signed(_zz__zz_shift_dataOut_4) + $signed(_zz__zz_shift_dataOut_4_3));
    end else begin
      _zz_shift_dataOut_4 <= {_zz__zz_shift_dataOut_4_4,_zz__zz_shift_dataOut_4_5};
    end
    if(when_QuantModule_l120_5) begin
      _zz_shift_dataOut_5 <= ($signed(_zz__zz_shift_dataOut_5) + $signed(_zz__zz_shift_dataOut_5_3));
    end else begin
      _zz_shift_dataOut_5 <= {_zz__zz_shift_dataOut_5_4,_zz__zz_shift_dataOut_5_5};
    end
    if(when_QuantModule_l120_6) begin
      _zz_shift_dataOut_6 <= ($signed(_zz__zz_shift_dataOut_6) + $signed(_zz__zz_shift_dataOut_6_3));
    end else begin
      _zz_shift_dataOut_6 <= {_zz__zz_shift_dataOut_6_4,_zz__zz_shift_dataOut_6_5};
    end
    if(when_QuantModule_l120_7) begin
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
  wire       [6:0]    switch_QuantModule_l67;
  wire       [6:0]    switch_QuantModule_l67_1;
  wire       [6:0]    switch_QuantModule_l67_2;
  wire       [6:0]    switch_QuantModule_l67_3;
  wire       [6:0]    switch_QuantModule_l67_4;
  wire       [6:0]    switch_QuantModule_l67_5;
  wire       [6:0]    switch_QuantModule_l67_6;
  wire       [6:0]    switch_QuantModule_l67_7;

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
  assign switch_QuantModule_l67 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_1 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_2 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_3 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_4 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_5 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_6 = Bias_quan[30 : 24];
  assign switch_QuantModule_l67_7 = Bias_quan[30 : 24];
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
    case(switch_QuantModule_l67)
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
    case(switch_QuantModule_l67_1)
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
    case(switch_QuantModule_l67_2)
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
    case(switch_QuantModule_l67_3)
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
    case(switch_QuantModule_l67_4)
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
    case(switch_QuantModule_l67_5)
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
    case(switch_QuantModule_l67_6)
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
    case(switch_QuantModule_l67_7)
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
