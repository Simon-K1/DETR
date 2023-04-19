// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : ConvQuant
// Git hash  : 9b959e96c7b17e3105294b01693a4e764cea42a8

`timescale 1ns/1ps

module ConvQuant (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output     [31:0]   Bias,
  output     [31:0]   Scale,
  output     [31:0]   Shift,
  input      [15:0]   OutMatrix_Col,
  input               LayerEnd,
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
  wire       [14:0]   _zz_InMatrixCol_Cnt_valid;
  wire       [14:0]   _zz_InMatrixCol_Cnt_valid_1;
  wire       [14:0]   _zz_InMatrixCol_Cnt_valid_2;
  wire       [15:0]   _zz_OutCol_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_valid_1;
  reg                 start_regNext;
  wire                when_Quan_l32;
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

  assign when_Quan_l32 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & ConvQuan_ENUM_IDLE) == ConvQuan_ENUM_IDLE) : begin
        if(when_Quan_l32) begin
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
  assign Fsm_Bias_Loaded = InMatrixCol_Cnt_valid;
  assign Fsm_Scale_Loaded = InMatrixCol_Cnt_valid;
  assign Fsm_Shift_Loaded = InMatrixCol_Cnt_valid;
  assign BiasCache_ena = (((Fsm_currentState & ConvQuan_ENUM_LOAD_BIAS) != 6'b000000) && sData_valid);
  assign ScaleCache_ena = (((Fsm_currentState & ConvQuan_ENUM_LOAD_SCALE) != 6'b000000) && sData_valid);
  assign ShiftCache_ena = (((Fsm_currentState & ConvQuan_ENUM_LOAD_SHIFT) != 6'b000000) && sData_valid);
  assign Bias = BiasCache_doutb;
  assign Scale = ScaleCache_doutb;
  assign Shift = ShiftCache_doutb;
  assign sData_ready = ((((Fsm_currentState & ConvQuan_ENUM_LOAD_BIAS) != 6'b000000) || ((Fsm_currentState & ConvQuan_ENUM_LOAD_SCALE) != 6'b000000)) || ((Fsm_currentState & ConvQuan_ENUM_LOAD_SHIFT) != 6'b000000));
  assign OutCol_Cnt_valid = ((_zz_OutCol_Cnt_valid == _zz_OutCol_Cnt_valid_1) && SAOutput_Valid);
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
