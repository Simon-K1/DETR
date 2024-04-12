// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : NandFlash_Check
// Git hash  : d02bd5191eb8dded4b67f1053075c5fbb116982a

`timescale 1ns/1ps

module NandFlash_Check (
  input               start,
  input               device_ready,
  input               Check_Next_Page_En,
  input      [23:0]   Check_Times,
  input      [31:0]   Check_Data_Num,
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
  localparam RW_STATUS_IDLE = 6'd1;
  localparam RW_STATUS_CLEAR = 6'd2;
  localparam RW_STATUS_WRITE = 6'd4;
  localparam RW_STATUS_READ = 6'd8;
  localparam RW_STATUS_CHECK = 6'd16;
  localparam RW_STATUS_IS_LAST_TEST = 6'd32;

  wire       [13:0]   wdata_cahce_addra;
  wire       [13:0]   wdata_cahce_addrb;
  wire       [13:0]   rdata_cahce_addra;
  wire       [13:0]   rdata_cahce_addrb;
  wire       [7:0]    wdata_cahce_doutb;
  wire       [7:0]    rdata_cahce_doutb;
  wire       [31:0]   _zz_wr_cnt_valid;
  wire       [31:0]   _zz_wr_cnt_valid_1;
  wire       [31:0]   _zz_rd_cnt_valid;
  wire       [31:0]   _zz_rd_cnt_valid_1;
  wire       [31:0]   _zz_Fsm_check_done;
  wire       [23:0]   _zz_Fsm_is_last_test;
  reg        [5:0]    Fsm_currentState;
  reg        [5:0]    Fsm_nextState;
  wire                Fsm_clear_done;
  wire                Fsm_write_done;
  wire                Fsm_read_done;
  wire                Fsm_check_done;
  wire                Fsm_is_last_test;
  wire                Fsm_check_next_page;
  reg                 _zz_clr_opt;
  reg                 _zz_clr_opt_1;
  reg                 _zz_clr_opt_2;
  reg                 _zz_clr_opt_3;
  reg                 _zz_clr_opt_4;
  reg        [9:0]    Clr_Delay_Cnt;
  wire                when_NandFlash_Check_l107;
  wire                when_NandFlash_Check_l109;
  wire                when_WaCounter_l40;
  reg        [31:0]   wr_cnt_count;
  wire                wr_cnt_valid;
  reg                 Write_Done_Flag;
  reg        [9:0]    Wr_Delay_Cnt;
  wire                when_NandFlash_Check_l126;
  wire                when_NandFlash_Check_l130;
  wire                when_NandFlash_Check_l137;
  reg                 rd_valid_regNext;
  wire                rd_valid_1;
  wire                when_WaCounter_l40_1;
  reg        [31:0]   rd_cnt_count;
  wire                rd_cnt_valid;
  wire                Read_Done_Flag;
  wire       [9:0]    Rd_Delay_Cnt;
  reg        [31:0]   Error_Cnt;
  reg                 Error_Flag;
  reg        [31:0]   Check_Addr1;
  reg        [31:0]   Check_Addr2;
  wire                when_NandFlash_Check_l177;
  wire                when_NandFlash_Check_l197;
  wire                when_NandFlash_Check_l198;
  wire                update_page;
  reg        [6:0]    Page_Cnt_count;
  reg                 Page_Cnt_valid;
  reg        [10:0]   Block_Cnt_count;
  reg                 Block_Cnt_valid;
  reg        [0:0]    Plane_Cnt_count;
  reg                 Plane_Cnt_valid;
  reg        [0:0]    LUN_Cnt_count;
  reg                 LUN_Cnt_valid;
  wire                when_NandFlash_Check_l215;
  reg        [23:0]   Check_Times_Cnt;
  wire       [23:0]   Wr_Addr_1;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_wr_cnt_valid = (_zz_wr_cnt_valid_1 + 32'h00000007);
  assign _zz_wr_cnt_valid_1 = (Check_Data_Num - 32'h00000001);
  assign _zz_rd_cnt_valid = (_zz_rd_cnt_valid_1 + 32'h0);
  assign _zz_rd_cnt_valid_1 = (Check_Data_Num - 32'h00000001);
  assign _zz_Fsm_check_done = (Check_Data_Num - 32'h00000001);
  assign _zz_Fsm_is_last_test = (Check_Times - 24'h000001);
  NdFlash_Mem wdata_cahce (
    .clka  (clk                    ), //i
    .addra (wdata_cahce_addra[13:0]), //i
    .dina  (wr_data[7:0]           ), //i
    .ena   (wr_valid               ), //i
    .wea   (1'b1                   ), //i
    .addrb (wdata_cahce_addrb[13:0]), //i
    .doutb (wdata_cahce_doutb[7:0] ), //o
    .clkb  (clk                    )  //i
  );
  NdFlash_Mem rdata_cahce (
    .clka  (clk                    ), //i
    .addra (rdata_cahce_addra[13:0]), //i
    .dina  (rd_data[7:0]           ), //i
    .ena   (rd_valid_1             ), //i
    .wea   (1'b1                   ), //i
    .addrb (rdata_cahce_addrb[13:0]), //i
    .doutb (rdata_cahce_doutb[7:0] ), //o
    .clkb  (clk                    )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      RW_STATUS_IDLE : Fsm_currentState_string = "IDLE        ";
      RW_STATUS_CLEAR : Fsm_currentState_string = "CLEAR       ";
      RW_STATUS_WRITE : Fsm_currentState_string = "WRITE       ";
      RW_STATUS_READ : Fsm_currentState_string = "READ        ";
      RW_STATUS_CHECK : Fsm_currentState_string = "CHECK       ";
      RW_STATUS_IS_LAST_TEST : Fsm_currentState_string = "IS_LAST_TEST";
      default : Fsm_currentState_string = "????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      RW_STATUS_IDLE : Fsm_nextState_string = "IDLE        ";
      RW_STATUS_CLEAR : Fsm_nextState_string = "CLEAR       ";
      RW_STATUS_WRITE : Fsm_nextState_string = "WRITE       ";
      RW_STATUS_READ : Fsm_nextState_string = "READ        ";
      RW_STATUS_CHECK : Fsm_nextState_string = "CHECK       ";
      RW_STATUS_IS_LAST_TEST : Fsm_nextState_string = "IS_LAST_TEST";
      default : Fsm_nextState_string = "????????????";
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
          Fsm_nextState = RW_STATUS_READ;
        end else begin
          Fsm_nextState = RW_STATUS_WRITE;
        end
      end
      (((Fsm_currentState) & RW_STATUS_READ) == RW_STATUS_READ) : begin
        if(Fsm_read_done) begin
          Fsm_nextState = RW_STATUS_CHECK;
        end else begin
          Fsm_nextState = RW_STATUS_READ;
        end
      end
      (((Fsm_currentState) & RW_STATUS_CHECK) == RW_STATUS_CHECK) : begin
        if(Fsm_check_done) begin
          Fsm_nextState = RW_STATUS_IS_LAST_TEST;
        end else begin
          Fsm_nextState = RW_STATUS_CHECK;
        end
      end
      default : begin
        if(Fsm_is_last_test) begin
          Fsm_nextState = RW_STATUS_IDLE;
        end else begin
          if(Fsm_check_next_page) begin
            Fsm_nextState = RW_STATUS_CLEAR;
          end else begin
            Fsm_nextState = RW_STATUS_IS_LAST_TEST;
          end
        end
      end
    endcase
  end

  assign clr_opt = _zz_clr_opt_4;
  assign when_NandFlash_Check_l107 = (Clr_Delay_Cnt[9] && ((Fsm_currentState & RW_STATUS_CLEAR) != 6'b000000));
  assign when_NandFlash_Check_l109 = ((Fsm_currentState & RW_STATUS_CLEAR) != 6'b000000);
  assign Fsm_clear_done = (Clr_Delay_Cnt[9] && device_ready);
  assign wr_opt = ((Fsm_currentState & RW_STATUS_WRITE) != 6'b000000);
  assign when_WaCounter_l40 = (wr_valid && ((Fsm_currentState & RW_STATUS_WRITE) != 6'b000000));
  assign wr_cnt_valid = ((wr_cnt_count == _zz_wr_cnt_valid) && when_WaCounter_l40);
  assign Fsm_write_done = (Wr_Delay_Cnt[9] && device_ready);
  assign when_NandFlash_Check_l126 = ((Fsm_nextState & RW_STATUS_CLEAR) != 6'b000000);
  assign when_NandFlash_Check_l130 = Wr_Delay_Cnt[9];
  assign when_NandFlash_Check_l137 = Wr_Delay_Cnt[9];
  assign wdata_cahce_addra = wr_cnt_count[13:0];
  assign rd_valid_1 = (rd_valid && (! rd_valid_regNext));
  assign rd_opt = ((Fsm_currentState & RW_STATUS_READ) != 6'b000000);
  assign when_WaCounter_l40_1 = (rd_valid_1 && ((Fsm_currentState & RW_STATUS_READ) != 6'b000000));
  assign rd_cnt_valid = ((rd_cnt_count == _zz_rd_cnt_valid) && when_WaCounter_l40_1);
  assign Read_Done_Flag = 1'b0;
  assign Rd_Delay_Cnt = 10'h0;
  assign Fsm_read_done = rd_cnt_valid;
  assign rdata_cahce_addra = rd_cnt_count[13:0];
  assign when_NandFlash_Check_l177 = ((Fsm_currentState & RW_STATUS_CHECK) != 6'b000000);
  assign wdata_cahce_addrb = Check_Addr1[13:0];
  assign rdata_cahce_addrb = Check_Addr2[13:0];
  assign when_NandFlash_Check_l197 = ((Fsm_currentState & RW_STATUS_CHECK) != 6'b000000);
  assign when_NandFlash_Check_l198 = (wdata_cahce_doutb != rdata_cahce_doutb);
  assign Fsm_check_done = (Check_Addr1 == _zz_Fsm_check_done);
  assign update_page = (((Fsm_currentState & RW_STATUS_IS_LAST_TEST) != 6'b000000) && ((Fsm_nextState & RW_STATUS_CLEAR) != 6'b000000));
  always @(*) begin
    Page_Cnt_valid = ((Page_Cnt_count == 7'h7f) && update_page);
    if(when_NandFlash_Check_l215) begin
      Page_Cnt_valid = 1'b0;
    end
  end

  always @(*) begin
    Block_Cnt_valid = ((Block_Cnt_count == 11'h7ff) && Page_Cnt_valid);
    if(when_NandFlash_Check_l215) begin
      Block_Cnt_valid = 1'b0;
    end
  end

  always @(*) begin
    Plane_Cnt_valid = ((Plane_Cnt_count == 1'b1) && Block_Cnt_valid);
    if(when_NandFlash_Check_l215) begin
      Plane_Cnt_valid = 1'b0;
    end
  end

  always @(*) begin
    LUN_Cnt_valid = ((LUN_Cnt_count == 1'b1) && Plane_Cnt_valid);
    if(when_NandFlash_Check_l215) begin
      LUN_Cnt_valid = 1'b0;
    end
  end

  assign when_NandFlash_Check_l215 = ((Fsm_currentState & RW_STATUS_IDLE) != 6'b000000);
  assign Fsm_is_last_test = (Check_Times_Cnt == _zz_Fsm_is_last_test);
  assign Fsm_check_next_page = Check_Next_Page_En;
  assign Wr_Addr_1 = {{{4'b0000,LUN_Cnt_count},Block_Cnt_count},{Plane_Cnt_count,Page_Cnt_count}};
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
      Error_Cnt <= 32'h0;
      Error_Flag <= 1'b0;
      Check_Addr1 <= 32'h00000007;
      Check_Addr2 <= 32'h0;
      Page_Cnt_count <= 7'h0;
      Block_Cnt_count <= 11'h0;
      Plane_Cnt_count <= 1'b0;
      LUN_Cnt_count <= 1'b0;
      Check_Times_Cnt <= 24'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_NandFlash_Check_l107) begin
        Clr_Delay_Cnt <= Clr_Delay_Cnt;
      end else begin
        if(when_NandFlash_Check_l109) begin
          Clr_Delay_Cnt <= (Clr_Delay_Cnt + 10'h001);
        end else begin
          Clr_Delay_Cnt <= 10'h0;
        end
      end
      if(when_WaCounter_l40) begin
        if(wr_cnt_valid) begin
          wr_cnt_count <= 32'h0;
        end else begin
          wr_cnt_count <= (wr_cnt_count + 32'h00000001);
        end
      end
      if(start) begin
        Wr_Delay_Cnt <= 10'h0;
      end else begin
        if(when_NandFlash_Check_l126) begin
          Wr_Delay_Cnt <= 10'h0;
        end else begin
          if(Write_Done_Flag) begin
            Wr_Delay_Cnt <= (Wr_Delay_Cnt + 10'h001);
          end else begin
            if(when_NandFlash_Check_l130) begin
              Wr_Delay_Cnt <= Wr_Delay_Cnt;
            end else begin
              Wr_Delay_Cnt <= 10'h0;
            end
          end
        end
      end
      if(wr_cnt_valid) begin
        Write_Done_Flag <= 1'b1;
      end else begin
        if(when_NandFlash_Check_l137) begin
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
      if(start) begin
        Error_Cnt <= 32'h0;
      end else begin
        if(Error_Flag) begin
          Error_Cnt <= (Error_Cnt + 32'h00000001);
        end
      end
      if(when_NandFlash_Check_l177) begin
        Check_Addr1 <= (Check_Addr1 + 32'h00000001);
        Check_Addr2 <= (Check_Addr2 + 32'h00000001);
      end else begin
        Check_Addr1 <= 32'h00000006;
        Check_Addr2 <= 32'h0;
      end
      if(when_NandFlash_Check_l197) begin
        if(when_NandFlash_Check_l198) begin
          Error_Flag <= 1'b1;
        end
      end else begin
        if(Fsm_clear_done) begin
          Error_Flag <= 1'b0;
        end
      end
      if(update_page) begin
        if(Page_Cnt_valid) begin
          Page_Cnt_count <= 7'h0;
        end else begin
          Page_Cnt_count <= (Page_Cnt_count + 7'h01);
        end
      end
      if(Page_Cnt_valid) begin
        if(Block_Cnt_valid) begin
          Block_Cnt_count <= 11'h0;
        end else begin
          Block_Cnt_count <= (Block_Cnt_count + 11'h001);
        end
      end
      if(Block_Cnt_valid) begin
        if(Plane_Cnt_valid) begin
          Plane_Cnt_count <= 1'b0;
        end else begin
          Plane_Cnt_count <= (Plane_Cnt_count + 1'b1);
        end
      end
      if(Plane_Cnt_valid) begin
        if(LUN_Cnt_valid) begin
          LUN_Cnt_count <= 1'b0;
        end else begin
          LUN_Cnt_count <= (LUN_Cnt_count + 1'b1);
        end
      end
      if(when_NandFlash_Check_l215) begin
        Page_Cnt_count <= 7'h0;
        Block_Cnt_count <= 11'h0;
        Plane_Cnt_count <= 1'b0;
        LUN_Cnt_count <= 1'b0;
      end
      if(update_page) begin
        Check_Times_Cnt <= (Check_Times_Cnt + 24'h000001);
      end else begin
        if(start) begin
          Check_Times_Cnt <= 24'h0;
        end
      end
    end
  end

  always @(posedge clk) begin
    _zz_clr_opt <= ((Fsm_currentState & RW_STATUS_CLEAR) != 6'b000000);
    _zz_clr_opt_1 <= _zz_clr_opt;
    _zz_clr_opt_2 <= _zz_clr_opt_1;
    _zz_clr_opt_3 <= _zz_clr_opt_2;
    _zz_clr_opt_4 <= _zz_clr_opt_3;
    rd_valid_regNext <= rd_valid;
  end


endmodule
