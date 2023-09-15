// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : NandFlash_Check
// Git hash  : cbf189b3125b7722ee9e0933e0c737508955b7fe

`timescale 1ns/1ps

module NandFlash_Check (
  input               start,
  input      [15:0]   Check_Times,
  input      [31:0]   Check_Data_Num,
  input      [23:0]   Check_Start_Addr,
  output     [23:0]   Wr_Addr,
  output              done_flag,
  input      [7:0]    wr_data,
  input               wr_valid,
  input      [7:0]    rd_data,
  input               rd_valid,
  output              clr_opt,
  output              wr_opt,
  output              rd_opt,
  input               clk,
  input               reset
);
  localparam RW_STATUS_IDLE = 5'd1;
  localparam RW_STATUS_CLEAR = 5'd2;
  localparam RW_STATUS_WRITE = 5'd4;
  localparam RW_STATUS_READ_AND_CHECK = 5'd8;
  localparam RW_STATUS_IS_LAST_TEST = 5'd16;

  wire                Data_Cache_io_push_valid;
  wire                Data_Cache_io_pop_ready;
  wire                Data_Cache_io_push_ready;
  wire                Data_Cache_io_pop_valid;
  wire       [7:0]    Data_Cache_io_pop_payload;
  wire       [13:0]   Data_Cache_io_occupancy;
  wire       [13:0]   Data_Cache_io_availability;
  wire       [31:0]   _zz_wr_cnt_valid;
  wire       [31:0]   _zz_rd_cnt_valid;
  wire       [15:0]   _zz_Fsm_is_last_test;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_clear_done;
  wire                Fsm_write_done;
  wire                Fsm_read_done;
  wire                Fsm_is_last_test;
  reg                 _zz_clr_opt;
  reg                 _zz_clr_opt_1;
  reg                 _zz_clr_opt_2;
  reg                 _zz_clr_opt_3;
  reg                 _zz_clr_opt_4;
  reg        [9:0]    Clr_Delay_Cnt;
  wire                when_NandFlash_Check_l100;
  reg                 _zz_wr_opt;
  reg                 _zz_wr_opt_1;
  reg                 _zz_wr_opt_2;
  reg                 _zz_wr_opt_3;
  reg                 _zz_wr_opt_4;
  wire                when_WaCounter_l40;
  reg        [31:0]   wr_cnt_count;
  wire                wr_cnt_valid;
  reg                 Write_Done_Flag;
  reg        [9:0]    Wr_Delay_Cnt;
  wire                when_NandFlash_Check_l122;
  reg                 _zz_rd_opt;
  reg                 _zz_rd_opt_1;
  reg                 _zz_rd_opt_2;
  reg                 _zz_rd_opt_3;
  reg                 _zz_rd_opt_4;
  wire                when_WaCounter_l40_1;
  reg        [31:0]   rd_cnt_count;
  wire                rd_cnt_valid;
  reg                 Read_Done_Flag;
  reg        [9:0]    Rd_Delay_Cnt;
  wire                when_NandFlash_Check_l140;
  reg        [31:0]   Error_Cnt;
  reg                 Error_Flag;
  reg        [7:0]    rd_data_regNext;
  wire                when_NandFlash_Check_l154;
  reg        [15:0]   Check_Times_Cnt;
  wire                when_NandFlash_Check_l165;
  reg        [23:0]   Wr_Addr_1;
  wire                when_NandFlash_Check_l175;
  `ifndef SYNTHESIS
  reg [111:0] Fsm_currentState_string;
  reg [111:0] Fsm_nextState_string;
  `endif


  assign _zz_wr_cnt_valid = (Check_Data_Num - 32'h00000001);
  assign _zz_rd_cnt_valid = (Check_Data_Num - 32'h00000001);
  assign _zz_Fsm_is_last_test = (Check_Times - 16'h0001);
  StreamFifo Data_Cache (
    .io_push_valid   (Data_Cache_io_push_valid        ), //i
    .io_push_ready   (Data_Cache_io_push_ready        ), //o
    .io_push_payload (wr_data[7:0]                    ), //i
    .io_pop_valid    (Data_Cache_io_pop_valid         ), //o
    .io_pop_ready    (Data_Cache_io_pop_ready         ), //i
    .io_pop_payload  (Data_Cache_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                            ), //i
    .io_occupancy    (Data_Cache_io_occupancy[13:0]   ), //o
    .io_availability (Data_Cache_io_availability[13:0]), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      RW_STATUS_IDLE : Fsm_currentState_string = "IDLE          ";
      RW_STATUS_CLEAR : Fsm_currentState_string = "CLEAR         ";
      RW_STATUS_WRITE : Fsm_currentState_string = "WRITE         ";
      RW_STATUS_READ_AND_CHECK : Fsm_currentState_string = "READ_AND_CHECK";
      RW_STATUS_IS_LAST_TEST : Fsm_currentState_string = "IS_LAST_TEST  ";
      default : Fsm_currentState_string = "??????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      RW_STATUS_IDLE : Fsm_nextState_string = "IDLE          ";
      RW_STATUS_CLEAR : Fsm_nextState_string = "CLEAR         ";
      RW_STATUS_WRITE : Fsm_nextState_string = "WRITE         ";
      RW_STATUS_READ_AND_CHECK : Fsm_nextState_string = "READ_AND_CHECK";
      RW_STATUS_IS_LAST_TEST : Fsm_nextState_string = "IS_LAST_TEST  ";
      default : Fsm_nextState_string = "??????????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & RW_STATUS_IDLE) == RW_STATUS_IDLE) : begin
        if(start) begin
          Fsm_nextState = RW_STATUS_CLEAR;
        end else begin
          Fsm_nextState = RW_STATUS_IDLE;
        end
      end
      (((Fsm_currentState) & RW_STATUS_CLEAR) == RW_STATUS_CLEAR) : begin
        if(Fsm_clear_done) begin
          Fsm_nextState = RW_STATUS_WRITE;
        end else begin
          Fsm_nextState = RW_STATUS_CLEAR;
        end
      end
      (((Fsm_currentState) & RW_STATUS_WRITE) == RW_STATUS_WRITE) : begin
        if(Fsm_write_done) begin
          Fsm_nextState = RW_STATUS_READ_AND_CHECK;
        end else begin
          Fsm_nextState = RW_STATUS_WRITE;
        end
      end
      (((Fsm_currentState) & RW_STATUS_READ_AND_CHECK) == RW_STATUS_READ_AND_CHECK) : begin
        if(Fsm_read_done) begin
          Fsm_nextState = RW_STATUS_IS_LAST_TEST;
        end else begin
          Fsm_nextState = RW_STATUS_READ_AND_CHECK;
        end
      end
      default : begin
        if(Fsm_is_last_test) begin
          Fsm_nextState = RW_STATUS_IDLE;
        end else begin
          Fsm_nextState = RW_STATUS_CLEAR;
        end
      end
    endcase
  end

  assign Data_Cache_io_push_valid = (wr_valid && ((Fsm_currentState & RW_STATUS_WRITE) != 5'b00000));
  assign Data_Cache_io_pop_ready = (rd_valid && ((Fsm_currentState & RW_STATUS_READ_AND_CHECK) != 5'b00000));
  assign clr_opt = _zz_clr_opt_4;
  assign when_NandFlash_Check_l100 = ((Fsm_currentState & RW_STATUS_CLEAR) != 5'b00000);
  assign Fsm_clear_done = Clr_Delay_Cnt[9];
  assign wr_opt = _zz_wr_opt_4;
  assign when_WaCounter_l40 = (wr_valid && ((Fsm_currentState & RW_STATUS_WRITE) != 5'b00000));
  assign wr_cnt_valid = ((wr_cnt_count == _zz_wr_cnt_valid) && when_WaCounter_l40);
  assign Fsm_write_done = Wr_Delay_Cnt[9];
  assign when_NandFlash_Check_l122 = Wr_Delay_Cnt[9];
  assign rd_opt = _zz_rd_opt_4;
  assign when_WaCounter_l40_1 = (rd_valid && ((Fsm_currentState & RW_STATUS_READ_AND_CHECK) != 5'b00000));
  assign rd_cnt_valid = ((rd_cnt_count == _zz_rd_cnt_valid) && when_WaCounter_l40_1);
  assign Fsm_read_done = Rd_Delay_Cnt[9];
  assign when_NandFlash_Check_l140 = Rd_Delay_Cnt[9];
  assign when_NandFlash_Check_l154 = (rd_data_regNext != Data_Cache_io_pop_payload);
  assign when_NandFlash_Check_l165 = (((Fsm_currentState & RW_STATUS_IS_LAST_TEST) != 5'b00000) && ((Fsm_nextState & RW_STATUS_CLEAR) != 5'b00000));
  assign Fsm_is_last_test = (Check_Times_Cnt == _zz_Fsm_is_last_test);
  assign when_NandFlash_Check_l175 = ((Fsm_nextState & RW_STATUS_IS_LAST_TEST) != 5'b00000);
  assign Wr_Addr = Wr_Addr_1;
  assign done_flag = Error_Flag;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= RW_STATUS_IDLE;
      Clr_Delay_Cnt <= 10'h0;
      wr_cnt_count <= 32'h0;
      Write_Done_Flag <= 1'b0;
      Wr_Delay_Cnt <= 10'h0;
      rd_cnt_count <= 32'h0;
      Read_Done_Flag <= 1'b0;
      Rd_Delay_Cnt <= 10'h0;
      Error_Cnt <= 32'h0;
      Error_Flag <= 1'b0;
      Check_Times_Cnt <= 16'h0;
      Wr_Addr_1 <= 24'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_NandFlash_Check_l100) begin
        Clr_Delay_Cnt <= (Clr_Delay_Cnt + 10'h001);
      end else begin
        Clr_Delay_Cnt <= 10'h0;
      end
      if(when_WaCounter_l40) begin
        if(wr_cnt_valid) begin
          wr_cnt_count <= 32'h0;
        end else begin
          wr_cnt_count <= (wr_cnt_count + 32'h00000001);
        end
      end
      if(Write_Done_Flag) begin
        Wr_Delay_Cnt <= (Wr_Delay_Cnt + 10'h001);
      end else begin
        Wr_Delay_Cnt <= 10'h0;
      end
      if(wr_cnt_valid) begin
        Write_Done_Flag <= 1'b1;
      end else begin
        if(when_NandFlash_Check_l122) begin
          Write_Done_Flag <= 1'b0;
        end
      end
      if(when_WaCounter_l40_1) begin
        if(rd_cnt_valid) begin
          rd_cnt_count <= 32'h0;
        end else begin
          rd_cnt_count <= (rd_cnt_count + 32'h00000001);
        end
      end
      if(Read_Done_Flag) begin
        Rd_Delay_Cnt <= (Rd_Delay_Cnt + 10'h001);
      end else begin
        Rd_Delay_Cnt <= 10'h0;
      end
      if(rd_cnt_valid) begin
        Read_Done_Flag <= 1'b1;
      end else begin
        if(when_NandFlash_Check_l140) begin
          Read_Done_Flag <= 1'b0;
        end
      end
      if(start) begin
        Error_Cnt <= 32'h0;
      end else begin
        if(Error_Flag) begin
          Error_Cnt <= (Error_Cnt + 32'h00000001);
        end
      end
      if(rd_valid) begin
        if(when_NandFlash_Check_l154) begin
          Error_Flag <= 1'b1;
        end
      end else begin
        if(Fsm_clear_done) begin
          Error_Flag <= 1'b0;
        end
      end
      if(when_NandFlash_Check_l165) begin
        Check_Times_Cnt <= (Check_Times_Cnt + 16'h0001);
      end else begin
        if(start) begin
          Check_Times_Cnt <= 16'h0;
        end
      end
      if(start) begin
        Wr_Addr_1 <= Check_Start_Addr;
      end else begin
        if(when_NandFlash_Check_l175) begin
          Wr_Addr_1 <= (Wr_Addr_1 + 24'h001000);
        end
      end
    end
  end

  always @(posedge clk) begin
    _zz_clr_opt <= ((Fsm_currentState & RW_STATUS_CLEAR) != 5'b00000);
    _zz_clr_opt_1 <= _zz_clr_opt;
    _zz_clr_opt_2 <= _zz_clr_opt_1;
    _zz_clr_opt_3 <= _zz_clr_opt_2;
    _zz_clr_opt_4 <= _zz_clr_opt_3;
    _zz_wr_opt <= ((Fsm_currentState & RW_STATUS_WRITE) != 5'b00000);
    _zz_wr_opt_1 <= _zz_wr_opt;
    _zz_wr_opt_2 <= _zz_wr_opt_1;
    _zz_wr_opt_3 <= _zz_wr_opt_2;
    _zz_wr_opt_4 <= _zz_wr_opt_3;
    _zz_rd_opt <= ((Fsm_currentState & RW_STATUS_READ_AND_CHECK) != 5'b00000);
    _zz_rd_opt_1 <= _zz_rd_opt;
    _zz_rd_opt_2 <= _zz_rd_opt_1;
    _zz_rd_opt_3 <= _zz_rd_opt_2;
    _zz_rd_opt_4 <= _zz_rd_opt_3;
  end

  always @(posedge clk) begin
    rd_data_regNext <= rd_data;
  end


endmodule

module StreamFifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [7:0]    io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [7:0]    io_pop_payload,
  input               io_flush,
  output     [13:0]   io_occupancy,
  output     [13:0]   io_availability,
  input               clk,
  input               reset
);

  reg        [7:0]    _zz_logic_ram_port0;
  wire       [12:0]   _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [12:0]   _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [7:0]    _zz_logic_ram_port_1;
  wire       [12:0]   _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [12:0]   logic_pushPtr_valueNext;
  reg        [12:0]   logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [12:0]   logic_popPtr_valueNext;
  reg        [12:0]   logic_popPtr_value;
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
  wire       [12:0]   logic_ptrDif;
  reg [7:0] logic_ram [0:8191];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {12'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {12'd0, _zz_logic_popPtr_valueNext_1};
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 13'h1fff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 13'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 13'h1fff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 13'h0;
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
      logic_pushPtr_value <= 13'h0;
      logic_popPtr_value <= 13'h0;
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
