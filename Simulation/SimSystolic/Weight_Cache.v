// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Weight_Cache
// Git hash  : 54eeb6ab5e44c9162766453013cfdd0dc8faff97

`timescale 1ns/1ps

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
  input               clk,
  input               reset
);
  localparam WEIGHT_CACHE_STATUS_IDLE = 4'd1;
  localparam WEIGHT_CACHE_STATUS_INIT = 4'd2;
  localparam WEIGHT_CACHE_STATUS_CACHE_WEIGHT = 4'd4;
  localparam WEIGHT_CACHE_STATUS_SA_COMPUTE = 4'd8;

  wire       [12:0]   xil_SimpleDualBram_addra;
  wire                xil_SimpleDualBram_ena;
  wire       [15:0]   xil_SimpleDualBram_addrb;
  wire       [12:0]   xil_SimpleDualBram_1_addra;
  wire                xil_SimpleDualBram_1_ena;
  wire       [15:0]   xil_SimpleDualBram_1_addrb;
  wire       [12:0]   xil_SimpleDualBram_2_addra;
  wire                xil_SimpleDualBram_2_ena;
  wire       [15:0]   xil_SimpleDualBram_2_addrb;
  wire       [12:0]   xil_SimpleDualBram_3_addra;
  wire                xil_SimpleDualBram_3_ena;
  wire       [15:0]   xil_SimpleDualBram_3_addrb;
  wire       [12:0]   xil_SimpleDualBram_4_addra;
  wire                xil_SimpleDualBram_4_ena;
  wire       [15:0]   xil_SimpleDualBram_4_addrb;
  wire       [12:0]   xil_SimpleDualBram_5_addra;
  wire                xil_SimpleDualBram_5_ena;
  wire       [15:0]   xil_SimpleDualBram_5_addrb;
  wire       [12:0]   xil_SimpleDualBram_6_addra;
  wire                xil_SimpleDualBram_6_ena;
  wire       [15:0]   xil_SimpleDualBram_6_addrb;
  wire       [12:0]   xil_SimpleDualBram_7_addra;
  wire                xil_SimpleDualBram_7_ena;
  wire       [15:0]   xil_SimpleDualBram_7_addrb;
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
  wire       [12:0]   _zz_OutCol_Cnt_valid;
  wire       [12:0]   _zz_OutCol_Cnt_valid_1;
  wire       [12:0]   _zz_OutCol_Cnt_valid_2;
  wire       [15:0]   _zz_Write_Row_Base_Addr;
  wire       [15:0]   _zz_addra;
  wire       [0:0]    _zz_ena;
  wire       [15:0]   _zz_addra_1;
  wire       [0:0]    _zz_ena_1;
  wire       [15:0]   _zz_addra_2;
  wire       [0:0]    _zz_ena_2;
  wire       [15:0]   _zz_addra_3;
  wire       [0:0]    _zz_ena_3;
  wire       [15:0]   _zz_addra_4;
  wire       [0:0]    _zz_ena_4;
  wire       [15:0]   _zz_addra_5;
  wire       [0:0]    _zz_ena_5;
  wire       [15:0]   _zz_addra_6;
  wire       [0:0]    _zz_ena_6;
  wire       [15:0]   _zz_addra_7;
  wire       [0:0]    _zz_ena_7;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Weight_All_Cached;
  wire                Fsm_SA_Computed;
  wire                when_WaCounter_l18;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l13;
  reg        [7:0]    InData_Switch;
  wire       [12:0]   Matrix_In_MaxCnt;
  wire                sData_fire;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [15:0]   Read_Row_Base_Addr;
  reg        [15:0]   Write_Row_Base_Addr;
  wire                when_WaCounter_l37;
  reg        [15:0]   OutRow_Cnt_count;
  wire                OutRow_Cnt_valid;
  reg        [11:0]   OutCol_Cnt_count;
  wire                OutCol_Cnt_valid;
  reg        [2:0]    Col_In_8_Cnt_count;
  wire                Col_In_8_Cnt_valid;
  wire                sData_fire_1;
  wire                sData_fire_2;
  reg        [7:0]    xil_SimpleDualBram_1_doutb_delay_1;
  wire                sData_fire_3;
  reg        [7:0]    xil_SimpleDualBram_2_doutb_delay_1;
  reg        [7:0]    xil_SimpleDualBram_2_doutb_delay_2;
  wire                sData_fire_4;
  reg        [7:0]    xil_SimpleDualBram_3_doutb_delay_1;
  reg        [7:0]    xil_SimpleDualBram_3_doutb_delay_2;
  reg        [7:0]    xil_SimpleDualBram_3_doutb_delay_3;
  wire                sData_fire_5;
  reg        [7:0]    xil_SimpleDualBram_4_doutb_delay_1;
  reg        [7:0]    xil_SimpleDualBram_4_doutb_delay_2;
  reg        [7:0]    xil_SimpleDualBram_4_doutb_delay_3;
  reg        [7:0]    xil_SimpleDualBram_4_doutb_delay_4;
  wire                sData_fire_6;
  reg        [7:0]    xil_SimpleDualBram_5_doutb_delay_1;
  reg        [7:0]    xil_SimpleDualBram_5_doutb_delay_2;
  reg        [7:0]    xil_SimpleDualBram_5_doutb_delay_3;
  reg        [7:0]    xil_SimpleDualBram_5_doutb_delay_4;
  reg        [7:0]    xil_SimpleDualBram_5_doutb_delay_5;
  wire                sData_fire_7;
  reg        [7:0]    xil_SimpleDualBram_6_doutb_delay_1;
  reg        [7:0]    xil_SimpleDualBram_6_doutb_delay_2;
  reg        [7:0]    xil_SimpleDualBram_6_doutb_delay_3;
  reg        [7:0]    xil_SimpleDualBram_6_doutb_delay_4;
  reg        [7:0]    xil_SimpleDualBram_6_doutb_delay_5;
  reg        [7:0]    xil_SimpleDualBram_6_doutb_delay_6;
  wire                sData_fire_8;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_1;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_2;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_3;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_4;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_5;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_6;
  reg        [7:0]    xil_SimpleDualBram_7_doutb_delay_7;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_In_Row_Cnt_valid_1 = (Matrix_In_MaxCnt - 13'h0001);
  assign _zz_In_Row_Cnt_valid = {3'd0, _zz_In_Row_Cnt_valid_1};
  assign _zz_In_Col_Cnt_valid = (Matrix_Col - 16'h0001);
  assign _zz_OutRow_Cnt_valid = (Matrix_Row - 16'h0001);
  assign _zz_OutCol_Cnt_valid = {1'd0, OutCol_Cnt_count};
  assign _zz_OutCol_Cnt_valid_1 = (_zz_OutCol_Cnt_valid_2 - 13'h0001);
  assign _zz_OutCol_Cnt_valid_2 = (Matrix_Col >>> 3);
  assign _zz_Write_Row_Base_Addr = {3'd0, Matrix_In_MaxCnt};
  assign _zz_addra = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena = InData_Switch[0 : 0];
  assign _zz_addra_1 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_1 = InData_Switch[1 : 1];
  assign _zz_addra_2 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_2 = InData_Switch[2 : 2];
  assign _zz_addra_3 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_3 = InData_Switch[3 : 3];
  assign _zz_addra_4 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_4 = InData_Switch[4 : 4];
  assign _zz_addra_5 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_5 = InData_Switch[5 : 5];
  assign _zz_addra_6 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_6 = InData_Switch[6 : 6];
  assign _zz_addra_7 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_ena_7 = InData_Switch[7 : 7];
  Weight_Bram xil_SimpleDualBram (
    .clka  (clk                           ), //i
    .addra (xil_SimpleDualBram_addra[12:0]), //i
    .dina  (sData_payload[63:0]           ), //i
    .ena   (xil_SimpleDualBram_ena        ), //i
    .wea   (1'b1                          ), //i
    .addrb (xil_SimpleDualBram_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_doutb[7:0] ), //o
    .clkb  (clk                           )  //i
  );
  Weight_Bram xil_SimpleDualBram_1 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_1_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_1_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_1_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_1_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_2 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_2_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_2_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_2_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_2_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_3 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_3_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_3_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_3_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_3_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_4 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_4_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_4_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_4_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_4_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_5 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_5_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_5_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_5_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_5_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_6 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_6_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_6_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_6_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_6_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_7 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_7_addra[12:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_7_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_7_addrb[15:0]), //i
    .doutb (xil_SimpleDualBram_7_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
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

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_IDLE) == WEIGHT_CACHE_STATUS_IDLE) : begin
        if(start) begin
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

  assign when_WaCounter_l18 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_WaCounter_l13 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l13) begin
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
  assign when_WaCounter_l37 = (Raddr_Valid && ((Fsm_currentState & WEIGHT_CACHE_STATUS_SA_COMPUTE) != 4'b0000));
  assign OutRow_Cnt_valid = ((OutRow_Cnt_count == _zz_OutRow_Cnt_valid) && when_WaCounter_l37);
  assign OutCol_Cnt_valid = ((_zz_OutCol_Cnt_valid == _zz_OutCol_Cnt_valid_1) && OutRow_Cnt_valid);
  assign Col_In_8_Cnt_valid = ((Col_In_8_Cnt_count == 3'b111) && In_Row_Cnt_valid);
  assign Fsm_Weight_All_Cached = In_Col_Cnt_valid;
  assign Weight_Cached = In_Col_Cnt_valid;
  assign xil_SimpleDualBram_addra = _zz_addra[12:0];
  assign xil_SimpleDualBram_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_ena = (_zz_ena[0] && sData_fire_1);
  assign mData_0 = xil_SimpleDualBram_doutb;
  assign xil_SimpleDualBram_1_addra = _zz_addra_1[12:0];
  assign xil_SimpleDualBram_1_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_1_ena = (_zz_ena_1[0] && sData_fire_2);
  assign mData_1 = xil_SimpleDualBram_1_doutb_delay_1;
  assign xil_SimpleDualBram_2_addra = _zz_addra_2[12:0];
  assign xil_SimpleDualBram_2_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_2_ena = (_zz_ena_2[0] && sData_fire_3);
  assign mData_2 = xil_SimpleDualBram_2_doutb_delay_2;
  assign xil_SimpleDualBram_3_addra = _zz_addra_3[12:0];
  assign xil_SimpleDualBram_3_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_3_ena = (_zz_ena_3[0] && sData_fire_4);
  assign mData_3 = xil_SimpleDualBram_3_doutb_delay_3;
  assign xil_SimpleDualBram_4_addra = _zz_addra_4[12:0];
  assign xil_SimpleDualBram_4_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_4_ena = (_zz_ena_4[0] && sData_fire_5);
  assign mData_4 = xil_SimpleDualBram_4_doutb_delay_4;
  assign xil_SimpleDualBram_5_addra = _zz_addra_5[12:0];
  assign xil_SimpleDualBram_5_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_6 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_5_ena = (_zz_ena_5[0] && sData_fire_6);
  assign mData_5 = xil_SimpleDualBram_5_doutb_delay_5;
  assign xil_SimpleDualBram_6_addra = _zz_addra_6[12:0];
  assign xil_SimpleDualBram_6_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_7 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_6_ena = (_zz_ena_6[0] && sData_fire_7);
  assign mData_6 = xil_SimpleDualBram_6_doutb_delay_6;
  assign xil_SimpleDualBram_7_addra = _zz_addra_7[12:0];
  assign xil_SimpleDualBram_7_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign sData_fire_8 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_7_ena = (_zz_ena_7[0] && sData_fire_8);
  assign mData_7 = xil_SimpleDualBram_7_doutb_delay_7;
  assign sData_ready = ((Fsm_currentState & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) != 4'b0000);
  assign Fsm_SA_Computed = LayerEnd;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= WEIGHT_CACHE_STATUS_IDLE;
      Init_Count_count <= 3'b000;
      InData_Switch <= 8'h01;
      In_Row_Cnt_count <= 16'h0;
      In_Col_Cnt_count <= 16'h0;
      Read_Row_Base_Addr <= 16'h0;
      Write_Row_Base_Addr <= 16'h0;
      OutRow_Cnt_count <= 16'h0;
      OutCol_Cnt_count <= 12'h0;
      Col_In_8_Cnt_count <= 3'b000;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l18) begin
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
      if(when_WaCounter_l37) begin
        if(OutRow_Cnt_valid) begin
          OutRow_Cnt_count <= 16'h0;
        end else begin
          OutRow_Cnt_count <= (OutRow_Cnt_count + 16'h0001);
        end
      end
      if(OutRow_Cnt_valid) begin
        if(OutCol_Cnt_valid) begin
          OutCol_Cnt_count <= 12'h0;
        end else begin
          OutCol_Cnt_count <= (OutCol_Cnt_count + 12'h001);
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
        Read_Row_Base_Addr <= 16'h0;
      end else begin
        if(OutRow_Cnt_valid) begin
          Read_Row_Base_Addr <= (Read_Row_Base_Addr + Matrix_Row);
        end
      end
      if(In_Row_Cnt_valid) begin
        InData_Switch <= {InData_Switch[6 : 0],InData_Switch[7 : 7]};
      end
      if(Col_In_8_Cnt_valid) begin
        Write_Row_Base_Addr <= (Write_Row_Base_Addr + _zz_Write_Row_Base_Addr);
      end
    end
  end

  always @(posedge clk) begin
    xil_SimpleDualBram_1_doutb_delay_1 <= xil_SimpleDualBram_1_doutb;
    xil_SimpleDualBram_2_doutb_delay_1 <= xil_SimpleDualBram_2_doutb;
    xil_SimpleDualBram_2_doutb_delay_2 <= xil_SimpleDualBram_2_doutb_delay_1;
    xil_SimpleDualBram_3_doutb_delay_1 <= xil_SimpleDualBram_3_doutb;
    xil_SimpleDualBram_3_doutb_delay_2 <= xil_SimpleDualBram_3_doutb_delay_1;
    xil_SimpleDualBram_3_doutb_delay_3 <= xil_SimpleDualBram_3_doutb_delay_2;
    xil_SimpleDualBram_4_doutb_delay_1 <= xil_SimpleDualBram_4_doutb;
    xil_SimpleDualBram_4_doutb_delay_2 <= xil_SimpleDualBram_4_doutb_delay_1;
    xil_SimpleDualBram_4_doutb_delay_3 <= xil_SimpleDualBram_4_doutb_delay_2;
    xil_SimpleDualBram_4_doutb_delay_4 <= xil_SimpleDualBram_4_doutb_delay_3;
    xil_SimpleDualBram_5_doutb_delay_1 <= xil_SimpleDualBram_5_doutb;
    xil_SimpleDualBram_5_doutb_delay_2 <= xil_SimpleDualBram_5_doutb_delay_1;
    xil_SimpleDualBram_5_doutb_delay_3 <= xil_SimpleDualBram_5_doutb_delay_2;
    xil_SimpleDualBram_5_doutb_delay_4 <= xil_SimpleDualBram_5_doutb_delay_3;
    xil_SimpleDualBram_5_doutb_delay_5 <= xil_SimpleDualBram_5_doutb_delay_4;
    xil_SimpleDualBram_6_doutb_delay_1 <= xil_SimpleDualBram_6_doutb;
    xil_SimpleDualBram_6_doutb_delay_2 <= xil_SimpleDualBram_6_doutb_delay_1;
    xil_SimpleDualBram_6_doutb_delay_3 <= xil_SimpleDualBram_6_doutb_delay_2;
    xil_SimpleDualBram_6_doutb_delay_4 <= xil_SimpleDualBram_6_doutb_delay_3;
    xil_SimpleDualBram_6_doutb_delay_5 <= xil_SimpleDualBram_6_doutb_delay_4;
    xil_SimpleDualBram_6_doutb_delay_6 <= xil_SimpleDualBram_6_doutb_delay_5;
    xil_SimpleDualBram_7_doutb_delay_1 <= xil_SimpleDualBram_7_doutb;
    xil_SimpleDualBram_7_doutb_delay_2 <= xil_SimpleDualBram_7_doutb_delay_1;
    xil_SimpleDualBram_7_doutb_delay_3 <= xil_SimpleDualBram_7_doutb_delay_2;
    xil_SimpleDualBram_7_doutb_delay_4 <= xil_SimpleDualBram_7_doutb_delay_3;
    xil_SimpleDualBram_7_doutb_delay_5 <= xil_SimpleDualBram_7_doutb_delay_4;
    xil_SimpleDualBram_7_doutb_delay_6 <= xil_SimpleDualBram_7_doutb_delay_5;
    xil_SimpleDualBram_7_doutb_delay_7 <= xil_SimpleDualBram_7_doutb_delay_6;
  end


endmodule
