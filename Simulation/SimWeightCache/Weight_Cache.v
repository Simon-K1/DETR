// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Weight_Cache
// Git hash  : a0abae15d23d67413d8cd3a23410d21962ff8434

`timescale 1ns/1ps

module Weight_Cache (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  input      [15:0]   Matrix_Row,
  input      [15:0]   Matrix_Col,
  output              mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  input               clk,
  input               reset
);
  localparam WEIGHT_CACHE_STATUS_IDLE = 4'd1;
  localparam WEIGHT_CACHE_STATUS_INIT = 4'd2;
  localparam WEIGHT_CACHE_STATUS_CACHE_WEIGHT = 4'd4;
  localparam WEIGHT_CACHE_STATUS_SA_COMPUTE = 4'd8;

  wire                xil_SimpleDualBram_ena;
  wire                xil_SimpleDualBram_1_ena;
  wire                xil_SimpleDualBram_2_ena;
  wire                xil_SimpleDualBram_3_ena;
  wire                xil_SimpleDualBram_4_ena;
  wire                xil_SimpleDualBram_5_ena;
  wire                xil_SimpleDualBram_6_ena;
  wire                xil_SimpleDualBram_7_ena;
  wire       [7:0]    xil_SimpleDualBram_doutb;
  wire       [7:0]    xil_SimpleDualBram_1_doutb;
  wire       [7:0]    xil_SimpleDualBram_2_doutb;
  wire       [7:0]    xil_SimpleDualBram_3_doutb;
  wire       [7:0]    xil_SimpleDualBram_4_doutb;
  wire       [7:0]    xil_SimpleDualBram_5_doutb;
  wire       [7:0]    xil_SimpleDualBram_6_doutb;
  wire       [7:0]    xil_SimpleDualBram_7_doutb;
  wire       [0:0]    _zz_ena;
  wire       [0:0]    _zz_ena_1;
  wire       [0:0]    _zz_ena_2;
  wire       [0:0]    _zz_ena_3;
  wire       [0:0]    _zz_ena_4;
  wire       [0:0]    _zz_ena_5;
  wire       [0:0]    _zz_ena_6;
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
  wire                sData_fire;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_ena = InData_Switch[0 : 0];
  assign _zz_ena_1 = InData_Switch[1 : 1];
  assign _zz_ena_2 = InData_Switch[2 : 2];
  assign _zz_ena_3 = InData_Switch[3 : 3];
  assign _zz_ena_4 = InData_Switch[4 : 4];
  assign _zz_ena_5 = InData_Switch[5 : 5];
  assign _zz_ena_6 = InData_Switch[6 : 6];
  assign _zz_ena_7 = InData_Switch[7 : 7];
  Weight_Bram xil_SimpleDualBram (
    .clka  (clk                          ), //i
    .addra (6'h0                         ), //i
    .dina  (64'h0                        ), //i
    .ena   (xil_SimpleDualBram_ena       ), //i
    .wea   (1'b1                         ), //i
    .addrb (16'h0                        ), //i
    .doutb (xil_SimpleDualBram_doutb[7:0]), //o
    .clkb  (clk                          )  //i
  );
  Weight_Bram xil_SimpleDualBram_1 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_1_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_1_doutb[7:0]), //o
    .clkb  (clk                            )  //i
  );
  Weight_Bram xil_SimpleDualBram_2 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_2_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_2_doutb[7:0]), //o
    .clkb  (clk                            )  //i
  );
  Weight_Bram xil_SimpleDualBram_3 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_3_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_3_doutb[7:0]), //o
    .clkb  (clk                            )  //i
  );
  Weight_Bram xil_SimpleDualBram_4 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_4_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_4_doutb[7:0]), //o
    .clkb  (clk                            )  //i
  );
  Weight_Bram xil_SimpleDualBram_5 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_5_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_5_doutb[7:0]), //o
    .clkb  (clk                            )  //i
  );
  Weight_Bram xil_SimpleDualBram_6 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_6_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_6_doutb[7:0]), //o
    .clkb  (clk                            )  //i
  );
  Weight_Bram xil_SimpleDualBram_7 (
    .clka  (clk                            ), //i
    .addra (6'h0                           ), //i
    .dina  (64'h0                          ), //i
    .ena   (xil_SimpleDualBram_7_ena       ), //i
    .wea   (1'b1                           ), //i
    .addrb (16'h0                          ), //i
    .doutb (xil_SimpleDualBram_7_doutb[7:0]), //o
    .clkb  (clk                            )  //i
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
  assign sData_fire = (sData_valid && sData_ready);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == Matrix_Row) && sData_fire);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == Matrix_Col) && In_Row_Cnt_valid);
  assign Fsm_Weight_All_Cached = In_Col_Cnt_valid;
  assign xil_SimpleDualBram_ena = _zz_ena[0];
  always @(*) begin
    mData_payload[7 : 0] = xil_SimpleDualBram_doutb;
    mData_payload[15 : 8] = xil_SimpleDualBram_1_doutb;
    mData_payload[23 : 16] = xil_SimpleDualBram_2_doutb;
    mData_payload[31 : 24] = xil_SimpleDualBram_3_doutb;
    mData_payload[39 : 32] = xil_SimpleDualBram_4_doutb;
    mData_payload[47 : 40] = xil_SimpleDualBram_5_doutb;
    mData_payload[55 : 48] = xil_SimpleDualBram_6_doutb;
    mData_payload[63 : 56] = xil_SimpleDualBram_7_doutb;
  end

  assign xil_SimpleDualBram_1_ena = _zz_ena_1[0];
  assign xil_SimpleDualBram_2_ena = _zz_ena_2[0];
  assign xil_SimpleDualBram_3_ena = _zz_ena_3[0];
  assign xil_SimpleDualBram_4_ena = _zz_ena_4[0];
  assign xil_SimpleDualBram_5_ena = _zz_ena_5[0];
  assign xil_SimpleDualBram_6_ena = _zz_ena_6[0];
  assign xil_SimpleDualBram_7_ena = _zz_ena_7[0];
  assign sData_ready = ((Fsm_currentState & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) != 4'b0000);
  assign Fsm_SA_Computed = 1'b0;
  assign mData_valid = 1'b0;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= WEIGHT_CACHE_STATUS_IDLE;
      Init_Count_count <= 3'b000;
      InData_Switch <= 8'h01;
      In_Row_Cnt_count <= 16'h0;
      In_Col_Cnt_count <= 16'h0;
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
      if(In_Row_Cnt_valid) begin
        InData_Switch <= {InData_Switch[6 : 0],InData_Switch[7 : 7]};
      end
    end
  end


endmodule
