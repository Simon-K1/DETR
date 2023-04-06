// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : GemmCache
// Git hash  : 5c021554a92363f3e077f8514744549a57285a7a

`timescale 1ns/1ps

module GemmCache (
  input               sData_valid,
  output reg          sData_ready,
  input      [63:0]   sData_payload,
  input      [11:0]   WIDTH,
  input      [11:0]   HIGHT,
  input      [7:0]    WEIGHTCOL,
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

  reg        [11:0]   buffer1_addra;
  reg        [63:0]   buffer1_dina;
  reg                 buffer1_ena;
  reg                 buffer1_wea;
  reg        [11:0]   buffer1_addrb;
  reg        [11:0]   buffer2_addra;
  reg        [63:0]   buffer2_dina;
  reg                 buffer2_ena;
  reg                 buffer2_wea;
  reg        [11:0]   buffer2_addrb;
  wire       [63:0]   buffer1_doutb;
  wire       [63:0]   buffer2_doutb;
  wire       [11:0]   _zz_colCnt_valid;
  wire       [11:0]   _zz_rAddrCnt_valid;
  wire       [7:0]    _zz_totalCnt_valid;
  wire       [7:0]    _zz_totalCnt_valid_1;
  wire       [7:0]    _zz_totalCnt_valid_2;
  reg                 Switch;
  reg                 valid_0;
  reg                 valid_1;
  reg                 valid_2;
  reg                 valid_3;
  reg                 valid_4;
  reg                 valid_5;
  reg                 valid_6;
  reg                 valid_7;
  reg        [63:0]   data;
  reg        [11:0]   reg_1;
  reg        [4:0]    fsm_currentState;
  reg        [4:0]    fsm_nextState;
  wire                fsm_initEnd;
  wire                fsm_readFinish;
  wire                fsm_writeEnd;
  wire                fsm_judge;
  wire                fsm_otherWrite;
  wire                when_GEMMCache_l149;
  wire                writeend;
  reg                 Switch_regNext;
  reg                 Switch_regNext_1;
  wire                when_GEMMCache_l42;
  reg        [1:0]    rwfsm_currentState;
  reg        [1:0]    rwfsm_nextState;
  reg                 rwfsm_writeEnd;
  wire                when_WaCounter_l39;
  reg        [2:0]    initCount_count;
  wire                initCount_valid;
  wire                sData_fire;
  reg        [11:0]   colCnt_count;
  wire                colCnt_valid;
  wire                when_WaCounter_l39_1;
  reg        [11:0]   rAddrCnt_count;
  wire                rAddrCnt_valid;
  reg        [2:0]    totalCnt_count;
  wire                totalCnt_valid;
  reg                 finish;
  wire                when_GEMMCache_l162;
  wire                when_GEMMCache_l170;
  reg                 writeend_regNext;
  reg                 _zz_1;
  reg                 _zz_2;
  reg                 finish_regNext;
  reg                 finish_regNext_1;
  wire                when_GEMMCache_l209;
  wire                sData_fire_1;
  wire                sData_fire_2;
  wire                when_GEMMCache_l235;
  wire                when_GEMMCache_l241;
  reg                 _zz_3;
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
  wire                when_GEMMCache_l271;
  `ifndef SYNTHESIS
  reg [39:0] fsm_currentState_string;
  reg [39:0] fsm_nextState_string;
  reg [39:0] rwfsm_currentState_string;
  reg [39:0] rwfsm_nextState_string;
  `endif


  assign _zz_colCnt_valid = (WIDTH - 12'h001);
  assign _zz_rAddrCnt_valid = (WIDTH - 12'h001);
  assign _zz_totalCnt_valid = {5'd0, totalCnt_count};
  assign _zz_totalCnt_valid_1 = (_zz_totalCnt_valid_2 - 8'h01);
  assign _zz_totalCnt_valid_2 = (WEIGHTCOL / 4'b1000);
  A_Bram buffer1 (
    .clka  (clk                ), //i
    .addra (buffer1_addra[11:0]), //i
    .dina  (buffer1_dina[63:0] ), //i
    .ena   (buffer1_ena        ), //i
    .wea   (buffer1_wea        ), //i
    .addrb (buffer1_addrb[11:0]), //i
    .doutb (buffer1_doutb[63:0]), //o
    .clkb  (clk                )  //i
  );
  B_Bram buffer2 (
    .clka  (clk                ), //i
    .addra (buffer2_addra[11:0]), //i
    .dina  (buffer2_dina[63:0] ), //i
    .ena   (buffer2_ena        ), //i
    .wea   (buffer2_wea        ), //i
    .addrb (buffer2_addrb[11:0]), //i
    .doutb (buffer2_doutb[63:0]), //o
    .clkb  (clk                )  //i
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
    mData[7 : 0] = data[7 : 0];
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

  assign when_GEMMCache_l149 = ((fsm_currentState & GEMM_ENUM_IDLE) != 5'b00000);
  assign writeend = (((fsm_currentState & GEMM_ENUM_WRITE) != 5'b00000) && ((fsm_nextState & GEMM_ENUM_READ) != 5'b00000));
  assign when_GEMMCache_l42 = ((((! Switch) && Switch_regNext) || (Switch && (! Switch_regNext_1))) && ((fsm_currentState & GEMM_ENUM_IDLE) == 5'b00000));
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
        if(when_GEMMCache_l42) begin
          rwfsm_nextState = RW_ENUM_WRITE;
        end else begin
          rwfsm_nextState = RW_ENUM_IDLE;
        end
      end
    endcase
  end

  assign when_WaCounter_l39 = ((fsm_currentState & GEMM_ENUM_INIT) != 5'b00000);
  assign initCount_valid = ((initCount_count == 3'b101) && when_WaCounter_l39);
  assign sData_fire = (sData_valid && sData_ready);
  assign colCnt_valid = ((colCnt_count == _zz_colCnt_valid) && sData_fire);
  assign when_WaCounter_l39_1 = ((fsm_currentState & GEMM_ENUM_READ) != 5'b00000);
  assign rAddrCnt_valid = ((rAddrCnt_count == _zz_rAddrCnt_valid) && when_WaCounter_l39_1);
  assign totalCnt_valid = ((_zz_totalCnt_valid == _zz_totalCnt_valid_1) && rAddrCnt_valid);
  assign when_GEMMCache_l162 = (totalCnt_valid && (reg_1 <= 12'h008));
  always @(*) begin
    if(when_GEMMCache_l162) begin
      finish = 1'b1;
    end else begin
      finish = 1'b0;
    end
  end

  assign when_GEMMCache_l170 = (totalCnt_valid && (! finish));
  always @(*) begin
    rwfsm_writeEnd = colCnt_valid;
    if(when_GEMMCache_l241) begin
      rwfsm_writeEnd = 1'b1;
    end
  end

  assign fsm_initEnd = initCount_valid;
  assign fsm_judge = (totalCnt_valid && ((rwfsm_currentState & RW_ENUM_WRITE) != 2'b00));
  assign fsm_readFinish = finish;
  assign fsm_otherWrite = colCnt_valid;
  assign fsm_writeEnd = colCnt_valid;
  assign LayerEnd = finish_regNext_1;
  always @(*) begin
    buffer1_addra = 12'h0;
    if(when_GEMMCache_l209) begin
      buffer1_addra = colCnt_count;
    end
  end

  always @(*) begin
    buffer1_dina = 64'h0;
    if(when_GEMMCache_l209) begin
      buffer1_dina = sData_payload;
    end
  end

  always @(*) begin
    buffer1_ena = 1'b0;
    if(when_GEMMCache_l209) begin
      buffer1_ena = sData_fire_1;
    end
  end

  always @(*) begin
    buffer1_wea = 1'b1;
    if(when_GEMMCache_l209) begin
      buffer1_wea = 1'b1;
    end
  end

  always @(*) begin
    buffer2_addrb = 12'h0;
    if(when_GEMMCache_l209) begin
      buffer2_addrb = rAddrCnt_count;
    end
  end

  always @(*) begin
    buffer2_addra = 12'h0;
    if(!when_GEMMCache_l209) begin
      buffer2_addra = colCnt_count;
    end
  end

  always @(*) begin
    buffer2_dina = 64'h0;
    if(!when_GEMMCache_l209) begin
      buffer2_dina = sData_payload;
    end
  end

  always @(*) begin
    buffer2_ena = 1'b0;
    if(!when_GEMMCache_l209) begin
      buffer2_ena = sData_fire_2;
    end
  end

  always @(*) begin
    buffer2_wea = 1'b1;
    if(!when_GEMMCache_l209) begin
      buffer2_wea = 1'b1;
    end
  end

  always @(*) begin
    buffer1_addrb = 12'h0;
    if(!when_GEMMCache_l209) begin
      buffer1_addrb = rAddrCnt_count;
    end
  end

  assign when_GEMMCache_l209 = (Switch == 1'b0);
  assign sData_fire_1 = (sData_valid && sData_ready);
  always @(*) begin
    if(when_GEMMCache_l209) begin
      data = buffer2_doutb;
    end else begin
      data = buffer1_doutb;
    end
  end

  assign sData_fire_2 = (sData_valid && sData_ready);
  assign when_GEMMCache_l235 = (((fsm_currentState & GEMM_ENUM_WRITE) != 5'b00000) || ((rwfsm_currentState & RW_ENUM_WRITE) != 2'b00));
  always @(*) begin
    if(when_GEMMCache_l235) begin
      sData_ready = 1'b1;
    end else begin
      sData_ready = 1'b0;
    end
  end

  assign when_GEMMCache_l241 = ((fsm_currentState & GEMM_ENUM_IDLE) != 5'b00000);
  always @(*) begin
    valid_0 = 1'b0;
    if(_zz_3) begin
      valid_0 = 1'b1;
    end
  end

  always @(*) begin
    valid_1 = 1'b0;
    if(_zz_3) begin
      valid_1 = 1'b1;
    end
  end

  always @(*) begin
    valid_2 = 1'b0;
    if(_zz_3) begin
      valid_2 = 1'b1;
    end
  end

  always @(*) begin
    valid_3 = 1'b0;
    if(_zz_3) begin
      valid_3 = 1'b1;
    end
  end

  always @(*) begin
    valid_4 = 1'b0;
    if(_zz_3) begin
      valid_4 = 1'b1;
    end
  end

  always @(*) begin
    valid_5 = 1'b0;
    if(_zz_3) begin
      valid_5 = 1'b1;
    end
  end

  always @(*) begin
    valid_6 = 1'b0;
    if(_zz_3) begin
      valid_6 = 1'b1;
    end
  end

  always @(*) begin
    valid_7 = 1'b0;
    if(_zz_3) begin
      valid_7 = 1'b1;
    end
  end

  assign validOut_0 = valid_0;
  assign validOut_1 = valid_1_delay_1;
  assign validOut_2 = valid_2_delay_2;
  assign validOut_3 = valid_3_delay_3;
  assign validOut_4 = valid_4_delay_4;
  assign validOut_5 = valid_5_delay_5;
  assign validOut_6 = valid_6_delay_6;
  assign validOut_7 = valid_7_delay_7;
  assign when_GEMMCache_l271 = ((fsm_currentState & GEMM_ENUM_READ) != 5'b00000);
  always @(*) begin
    if(when_GEMMCache_l271) begin
      bvalid = 1'b1;
    end else begin
      bvalid = 1'b0;
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Switch <= 1'b0;
      reg_1 <= 12'h0;
      fsm_currentState <= GEMM_ENUM_IDLE;
      rwfsm_currentState <= RW_ENUM_IDLE;
      initCount_count <= 3'b000;
      colCnt_count <= 12'h0;
      rAddrCnt_count <= 12'h0;
      totalCnt_count <= 3'b000;
    end else begin
      fsm_currentState <= fsm_nextState;
      if(when_GEMMCache_l149) begin
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
      if(sData_fire) begin
        if(colCnt_valid) begin
          colCnt_count <= 12'h0;
        end else begin
          colCnt_count <= (colCnt_count + 12'h001);
        end
      end
      if(when_WaCounter_l39_1) begin
        if(rAddrCnt_valid) begin
          rAddrCnt_count <= 12'h0;
        end else begin
          rAddrCnt_count <= (rAddrCnt_count + 12'h001);
        end
      end
      if(rAddrCnt_valid) begin
        if(totalCnt_valid) begin
          totalCnt_count <= 3'b000;
        end else begin
          totalCnt_count <= (totalCnt_count + 3'b001);
        end
      end
      if(when_GEMMCache_l170) begin
        reg_1 <= (reg_1 - 12'h008);
      end
      if(writeend_regNext) begin
        Switch <= (! Switch);
      end else begin
        if(_zz_1) begin
          Switch <= (! Switch);
        end else begin
          if(_zz_2) begin
            Switch <= (! Switch);
          end else begin
            if(finish_regNext) begin
              Switch <= 1'b0;
            end
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    Switch_regNext <= Switch;
    Switch_regNext_1 <= Switch;
    writeend_regNext <= writeend;
    _zz_1 <= (totalCnt_valid && ((rwfsm_currentState & RW_ENUM_IDLE) != 2'b00));
    _zz_2 <= (colCnt_valid && ((fsm_currentState & GEMM_ENUM_CHECK) != 5'b00000));
    finish_regNext <= finish;
    finish_regNext_1 <= finish;
    _zz_3 <= ((fsm_currentState & GEMM_ENUM_READ) != 5'b00000);
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
    _zz_mData <= data[15 : 8];
    _zz_mData_1 <= data[23 : 16];
    _zz_mData_2 <= _zz_mData_1;
    _zz_mData_3 <= data[31 : 24];
    _zz_mData_4 <= _zz_mData_3;
    _zz_mData_5 <= _zz_mData_4;
    _zz_mData_6 <= data[39 : 32];
    _zz_mData_7 <= _zz_mData_6;
    _zz_mData_8 <= _zz_mData_7;
    _zz_mData_9 <= _zz_mData_8;
    _zz_mData_10 <= data[47 : 40];
    _zz_mData_11 <= _zz_mData_10;
    _zz_mData_12 <= _zz_mData_11;
    _zz_mData_13 <= _zz_mData_12;
    _zz_mData_14 <= _zz_mData_13;
    _zz_mData_15 <= data[55 : 48];
    _zz_mData_16 <= _zz_mData_15;
    _zz_mData_17 <= _zz_mData_16;
    _zz_mData_18 <= _zz_mData_17;
    _zz_mData_19 <= _zz_mData_18;
    _zz_mData_20 <= _zz_mData_19;
    _zz_mData_21 <= data[63 : 56];
    _zz_mData_22 <= _zz_mData_21;
    _zz_mData_23 <= _zz_mData_22;
    _zz_mData_24 <= _zz_mData_23;
    _zz_mData_25 <= _zz_mData_24;
    _zz_mData_26 <= _zz_mData_25;
    _zz_mData_27 <= _zz_mData_26;
  end


endmodule
