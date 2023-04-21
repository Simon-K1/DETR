// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Conv
// Git hash  : 8b732f386b6c6c5e4593e679c58d3a2aaee62c68

`timescale 1ns/1ps

module Conv (
  input               Control_start,
  input               Control_Switch_Conv,
  input               Control_Matrix2Img,
  input               Control_LayerEnd,
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  output     [63:0]   mData_payload,
  input      [4:0]    Img2Col_Stride,
  input      [4:0]    Img2Col_Kernel_Size,
  input      [15:0]   Img2Col_Window_Size,
  input      [15:0]   Img2Col_InFeature_Size,
  input      [15:0]   Img2Col_InFeature_Channel,
  input      [15:0]   Img2Col_OutFeature_Channel,
  input      [15:0]   Img2Col_OutFeature_Size,
  input      [12:0]   Img2Col_Sliding_Size,
  input      [15:0]   Img2Col_OutCol_Count_Times,
  input      [15:0]   Img2Col_InCol_Count_Times,
  input      [15:0]   Img2Col_OutRow_Count_Times,
  input      [15:0]   Img2Col_OutFeature_Channel_Count_Times,
  input      [15:0]   Img2Col_WeightMatrix_Row,
  input      [11:0]   Img2Col_OutMatrix_Col,
  input      [15:0]   Img2Col_OutMatrix_Row,
  input      [15:0]   GemmInstru_WIDTH,
  input      [15:0]   GemmInstru_HEIGHT,
  input               clk,
  input               reset
);
  localparam TopCtrl_Enum_IDLE = 6'd1;
  localparam TopCtrl_Enum_INIT = 6'd2;
  localparam TopCtrl_Enum_WEIGHT_CACHE = 6'd4;
  localparam TopCtrl_Enum_RECEIVE_PICTURE = 6'd8;
  localparam TopCtrl_Enum_RECEIVE_MATRIX = 6'd16;
  localparam TopCtrl_Enum_WAIT_COMPUTE_END = 6'd32;

  reg        [1:0]    InputSwitch_Switch;
  reg                 InputSwitch_m_0_axis_mm2s_tready;
  reg        [63:0]   Compute_Unit_activate;
  reg        [7:0]    Compute_Unit_a_Valid;
  wire       [63:0]   Compute_Unit_weight;
  reg        [7:0]    Compute_Unit_b_Valid;
  wire       [15:0]   Compute_Unit_signCount;
  wire       [9:0]    Compute_Unit_OutChannel;
  wire                Weight_Unit_Raddr_Valid;
  wire                Img2Col_Unit_mReady;
  wire       [11:0]   LH_Gemm_WIDTH;
  wire       [11:0]   LH_Gemm_HIGHT;
  wire       [7:0]    LH_Gemm_WEIGHTCOL;
  wire                InputSwitch_s0_axis_s2mm_tready;
  wire       [63:0]   InputSwitch_m_0_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_0_axis_mm2s_tkeep;
  wire                InputSwitch_m_0_axis_mm2s_tlast;
  wire                InputSwitch_m_0_axis_mm2s_tvalid;
  wire       [63:0]   InputSwitch_m_1_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_1_axis_mm2s_tkeep;
  wire                InputSwitch_m_1_axis_mm2s_tlast;
  wire                InputSwitch_m_1_axis_mm2s_tvalid;
  wire       [63:0]   InputSwitch_m_2_axis_mm2s_tdata;
  wire       [7:0]    InputSwitch_m_2_axis_mm2s_tkeep;
  wire                InputSwitch_m_2_axis_mm2s_tlast;
  wire                InputSwitch_m_2_axis_mm2s_tvalid;
  wire                Compute_Unit_resultVaild_0;
  wire                Compute_Unit_resultVaild_1;
  wire                Compute_Unit_resultVaild_2;
  wire                Compute_Unit_resultVaild_3;
  wire                Compute_Unit_resultVaild_4;
  wire                Compute_Unit_resultVaild_5;
  wire                Compute_Unit_resultVaild_6;
  wire                Compute_Unit_resultVaild_7;
  wire       [31:0]   Compute_Unit_mData_0;
  wire       [31:0]   Compute_Unit_mData_1;
  wire       [31:0]   Compute_Unit_mData_2;
  wire       [31:0]   Compute_Unit_mData_3;
  wire       [31:0]   Compute_Unit_mData_4;
  wire       [31:0]   Compute_Unit_mData_5;
  wire       [31:0]   Compute_Unit_mData_6;
  wire       [31:0]   Compute_Unit_mData_7;
  wire                Weight_Unit_s_axis_s2mm_tready;
  wire       [63:0]   Weight_Unit_mData;
  wire                Weight_Unit_Weight_Cached;
  wire       [7:0]    Weight_Unit_MatrixCol_Switch;
  wire       [63:0]   Img2Col_Unit_mData;
  wire       [7:0]    Img2Col_Unit_mValid;
  wire                Img2Col_Unit_s_axis_s2mm_tready;
  wire                Img2Col_Unit_Raddr_Valid;
  wire                Img2Col_Unit_LayerEnd;
  wire                LH_Gemm_sData_ready;
  wire                LH_Gemm_validOut_0;
  wire                LH_Gemm_validOut_1;
  wire                LH_Gemm_validOut_2;
  wire                LH_Gemm_validOut_3;
  wire                LH_Gemm_validOut_4;
  wire                LH_Gemm_validOut_5;
  wire                LH_Gemm_validOut_6;
  wire                LH_Gemm_validOut_7;
  wire                LH_Gemm_LayerEnd;
  wire                LH_Gemm_bvalid;
  wire       [63:0]   LH_Gemm_mData;
  wire                ConvQuant_1_sData_ready;
  wire                ConvQuant_1_QuantPara_Cached;
  wire       [63:0]   ConvQuant_1_dataOut;
  wire       [0:0]    _zz_b_Valid;
  wire       [0:0]    _zz_b_Valid_1;
  wire       [0:0]    _zz_b_Valid_2;
  wire       [0:0]    _zz_b_Valid_3;
  wire       [0:0]    _zz_b_Valid_4;
  wire       [0:0]    _zz_b_Valid_5;
  wire       [0:0]    _zz_b_Valid_6;
  wire       [0:0]    _zz_b_Valid_7;
  reg        [5:0]    Fsm_currentState;
  reg        [5:0]    Fsm_nextState;
  wire                Fsm_Inited;
  wire                Fsm_WeightCached;
  wire                Fsm_Picture_Received;
  wire                Fsm_Matrix_Received;
  wire                Fsm_Compute_End;
  wire                Fsm_Switch_Conv;
  wire                when_Compute_TopV2_l225;
  wire                when_Compute_TopV2_l227;
  wire                when_WaCounter_l19;
  reg        [2:0]    InitCnt_count;
  reg                 InitCnt_valid;
  wire                when_WaCounter_l14;
  wire                when_Compute_TopV2_l316;
  reg                 toplevel_Weight_Unit_Weight_Cached_delay_1;
  reg                 toplevel_Weight_Unit_Weight_Cached_delay_2;
  reg                 toplevel_Weight_Unit_Weight_Cached_delay_3;
  reg                 _zz_start;
  reg                 _zz_start_1;
  reg                 _zz_start_2;
  reg                 _zz_start_3;
  reg                 _zz_start_4;
  reg                 _zz_start_5;
  `ifndef SYNTHESIS
  reg [127:0] Fsm_currentState_string;
  reg [127:0] Fsm_nextState_string;
  `endif


  assign _zz_b_Valid = Weight_Unit_MatrixCol_Switch[0 : 0];
  assign _zz_b_Valid_1 = Weight_Unit_MatrixCol_Switch[1 : 1];
  assign _zz_b_Valid_2 = Weight_Unit_MatrixCol_Switch[2 : 2];
  assign _zz_b_Valid_3 = Weight_Unit_MatrixCol_Switch[3 : 3];
  assign _zz_b_Valid_4 = Weight_Unit_MatrixCol_Switch[4 : 4];
  assign _zz_b_Valid_5 = Weight_Unit_MatrixCol_Switch[5 : 5];
  assign _zz_b_Valid_6 = Weight_Unit_MatrixCol_Switch[6 : 6];
  assign _zz_b_Valid_7 = Weight_Unit_MatrixCol_Switch[7 : 7];
  Compute_DataIn_Switch InputSwitch (
    .Switch               (InputSwitch_Switch[1:0]              ), //i
    .s0_axis_s2mm_tdata   (s_axis_s2mm_tdata[63:0]              ), //i
    .s0_axis_s2mm_tkeep   (s_axis_s2mm_tkeep[7:0]               ), //i
    .s0_axis_s2mm_tlast   (s_axis_s2mm_tlast                    ), //i
    .s0_axis_s2mm_tready  (InputSwitch_s0_axis_s2mm_tready      ), //o
    .s0_axis_s2mm_tvalid  (s_axis_s2mm_tvalid                   ), //i
    .m_0_axis_mm2s_tdata  (InputSwitch_m_0_axis_mm2s_tdata[63:0]), //o
    .m_0_axis_mm2s_tkeep  (InputSwitch_m_0_axis_mm2s_tkeep[7:0] ), //o
    .m_0_axis_mm2s_tlast  (InputSwitch_m_0_axis_mm2s_tlast      ), //o
    .m_0_axis_mm2s_tready (InputSwitch_m_0_axis_mm2s_tready     ), //i
    .m_0_axis_mm2s_tvalid (InputSwitch_m_0_axis_mm2s_tvalid     ), //o
    .m_1_axis_mm2s_tdata  (InputSwitch_m_1_axis_mm2s_tdata[63:0]), //o
    .m_1_axis_mm2s_tkeep  (InputSwitch_m_1_axis_mm2s_tkeep[7:0] ), //o
    .m_1_axis_mm2s_tlast  (InputSwitch_m_1_axis_mm2s_tlast      ), //o
    .m_1_axis_mm2s_tready (Img2Col_Unit_s_axis_s2mm_tready      ), //i
    .m_1_axis_mm2s_tvalid (InputSwitch_m_1_axis_mm2s_tvalid     ), //o
    .m_2_axis_mm2s_tdata  (InputSwitch_m_2_axis_mm2s_tdata[63:0]), //o
    .m_2_axis_mm2s_tkeep  (InputSwitch_m_2_axis_mm2s_tkeep[7:0] ), //o
    .m_2_axis_mm2s_tlast  (InputSwitch_m_2_axis_mm2s_tlast      ), //o
    .m_2_axis_mm2s_tready (LH_Gemm_sData_ready                  ), //i
    .m_2_axis_mm2s_tvalid (InputSwitch_m_2_axis_mm2s_tvalid     )  //o
  );
  SA_Conv Compute_Unit (
    .activate       (Compute_Unit_activate[63:0]  ), //i
    .a_Valid        (Compute_Unit_a_Valid[7:0]    ), //i
    .weight         (Compute_Unit_weight[63:0]    ), //i
    .b_Valid        (Compute_Unit_b_Valid[7:0]    ), //i
    .signCount      (Compute_Unit_signCount[15:0] ), //i
    .resultVaild_0  (Compute_Unit_resultVaild_0   ), //o
    .resultVaild_1  (Compute_Unit_resultVaild_1   ), //o
    .resultVaild_2  (Compute_Unit_resultVaild_2   ), //o
    .resultVaild_3  (Compute_Unit_resultVaild_3   ), //o
    .resultVaild_4  (Compute_Unit_resultVaild_4   ), //o
    .resultVaild_5  (Compute_Unit_resultVaild_5   ), //o
    .resultVaild_6  (Compute_Unit_resultVaild_6   ), //o
    .resultVaild_7  (Compute_Unit_resultVaild_7   ), //o
    .OutMatrix_Col  (Img2Col_OutMatrix_Col[11:0]  ), //i
    .OutMatrix_Row  (Img2Col_OutMatrix_Row[15:0]  ), //i
    .OutChannel     (Compute_Unit_OutChannel[9:0] ), //i
    .OutFeatureSize (Img2Col_OutFeature_Size[15:0]), //i
    .Matrix2Img     (Control_Matrix2Img           ), //i
    .start          (_zz_start_5                  ), //i
    .mData_0        (Compute_Unit_mData_0[31:0]   ), //o
    .mData_1        (Compute_Unit_mData_1[31:0]   ), //o
    .mData_2        (Compute_Unit_mData_2[31:0]   ), //o
    .mData_3        (Compute_Unit_mData_3[31:0]   ), //o
    .mData_4        (Compute_Unit_mData_4[31:0]   ), //o
    .mData_5        (Compute_Unit_mData_5[31:0]   ), //o
    .mData_6        (Compute_Unit_mData_6[31:0]   ), //o
    .mData_7        (Compute_Unit_mData_7[31:0]   ), //o
    .clk            (clk                          ), //i
    .reset          (reset                        )  //i
  );
  WeightCache_Stream Weight_Unit (
    .s_axis_s2mm_tdata  (InputSwitch_m_0_axis_mm2s_tdata[63:0]), //i
    .s_axis_s2mm_tkeep  (InputSwitch_m_0_axis_mm2s_tkeep[7:0] ), //i
    .s_axis_s2mm_tlast  (InputSwitch_m_0_axis_mm2s_tlast      ), //i
    .s_axis_s2mm_tready (Weight_Unit_s_axis_s2mm_tready       ), //o
    .s_axis_s2mm_tvalid (InputSwitch_m_0_axis_mm2s_tvalid     ), //i
    .start              (_zz_start_2                          ), //i
    .Matrix_Row         (Img2Col_WeightMatrix_Row[15:0]       ), //i
    .Matrix_Col         (Img2Col_OutFeature_Channel[15:0]     ), //i
    .mData              (Weight_Unit_mData[63:0]              ), //o
    .Raddr_Valid        (Weight_Unit_Raddr_Valid              ), //i
    .Weight_Cached      (Weight_Unit_Weight_Cached            ), //o
    .LayerEnd           (Control_LayerEnd                     ), //i
    .MatrixCol_Switch   (Weight_Unit_MatrixCol_Switch[7:0]    ), //o
    .clk                (clk                                  ), //i
    .reset              (reset                                )  //i
  );
  Img2ColStreamV2 Img2Col_Unit (
    .mData                          (Img2Col_Unit_mData[63:0]                    ), //o
    .mReady                         (Img2Col_Unit_mReady                         ), //i
    .mValid                         (Img2Col_Unit_mValid[7:0]                    ), //o
    .s_axis_s2mm_tdata              (InputSwitch_m_1_axis_mm2s_tdata[63:0]       ), //i
    .s_axis_s2mm_tkeep              (InputSwitch_m_1_axis_mm2s_tkeep[7:0]        ), //i
    .s_axis_s2mm_tlast              (InputSwitch_m_1_axis_mm2s_tlast             ), //i
    .s_axis_s2mm_tready             (Img2Col_Unit_s_axis_s2mm_tready             ), //o
    .s_axis_s2mm_tvalid             (InputSwitch_m_1_axis_mm2s_tvalid            ), //i
    .start                          (toplevel_Weight_Unit_Weight_Cached_delay_3  ), //i
    .Raddr_Valid                    (Img2Col_Unit_Raddr_Valid                    ), //o
    .LayerEnd                       (Img2Col_Unit_LayerEnd                       ), //o
    .Stride                         (Img2Col_Stride[4:0]                         ), //i
    .Kernel_Size                    (Img2Col_Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Img2Col_Window_Size[15:0]                   ), //i
    .InFeature_Size                 (Img2Col_InFeature_Size[15:0]                ), //i
    .InFeature_Channel              (Img2Col_InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (Img2Col_OutFeature_Channel[15:0]            ), //i
    .OutFeature_Size                (Img2Col_OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (Img2Col_OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (Img2Col_InCol_Count_Times[15:0]             ), //i
    .OutRow_Count_Times             (Img2Col_OutRow_Count_Times[15:0]            ), //i
    .OutFeature_Channel_Count_Times (Img2Col_OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Img2Col_Sliding_Size[12:0]                  ), //i
    .clk                            (clk                                         ), //i
    .reset                          (reset                                       )  //i
  );
  GemmCache LH_Gemm (
    .sData_valid   (InputSwitch_m_2_axis_mm2s_tvalid     ), //i
    .sData_ready   (LH_Gemm_sData_ready                  ), //o
    .sData_payload (InputSwitch_m_2_axis_mm2s_tdata[63:0]), //i
    .WIDTH         (LH_Gemm_WIDTH[11:0]                  ), //i
    .HIGHT         (LH_Gemm_HIGHT[11:0]                  ), //i
    .WEIGHTCOL     (LH_Gemm_WEIGHTCOL[7:0]               ), //i
    .start         (Weight_Unit_Weight_Cached            ), //i
    .validOut_0    (LH_Gemm_validOut_0                   ), //o
    .validOut_1    (LH_Gemm_validOut_1                   ), //o
    .validOut_2    (LH_Gemm_validOut_2                   ), //o
    .validOut_3    (LH_Gemm_validOut_3                   ), //o
    .validOut_4    (LH_Gemm_validOut_4                   ), //o
    .validOut_5    (LH_Gemm_validOut_5                   ), //o
    .validOut_6    (LH_Gemm_validOut_6                   ), //o
    .validOut_7    (LH_Gemm_validOut_7                   ), //o
    .LayerEnd      (LH_Gemm_LayerEnd                     ), //o
    .bvalid        (LH_Gemm_bvalid                       ), //o
    .mData         (LH_Gemm_mData[63:0]                  ), //o
    .clk           (clk                                  ), //i
    .reset         (reset                                )  //i
  );
  ConvQuant ConvQuant_1 (
    .start            (Weight_Unit_Weight_Cached            ), //i
    .sData_valid      (InputSwitch_m_0_axis_mm2s_tvalid     ), //i
    .sData_ready      (ConvQuant_1_sData_ready              ), //o
    .sData_payload    (InputSwitch_m_0_axis_mm2s_tdata[63:0]), //i
    .OutMatrix_Col    (Img2Col_OutFeature_Channel[15:0]     ), //i
    .LayerEnd         (Control_LayerEnd                     ), //i
    .QuantPara_Cached (ConvQuant_1_QuantPara_Cached         ), //o
    .dataIn_0         (Compute_Unit_mData_0[31:0]           ), //i
    .dataIn_1         (Compute_Unit_mData_1[31:0]           ), //i
    .dataIn_2         (Compute_Unit_mData_2[31:0]           ), //i
    .dataIn_3         (Compute_Unit_mData_3[31:0]           ), //i
    .dataIn_4         (Compute_Unit_mData_4[31:0]           ), //i
    .dataIn_5         (Compute_Unit_mData_5[31:0]           ), //i
    .dataIn_6         (Compute_Unit_mData_6[31:0]           ), //i
    .dataIn_7         (Compute_Unit_mData_7[31:0]           ), //i
    .dataOut          (ConvQuant_1_dataOut[63:0]            ), //o
    .zeroIn           (8'h3b                                ), //i
    .SAOutput_Valid   (Compute_Unit_resultVaild_0           ), //i
    .clk              (clk                                  ), //i
    .reset            (reset                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      TopCtrl_Enum_IDLE : Fsm_currentState_string = "IDLE            ";
      TopCtrl_Enum_INIT : Fsm_currentState_string = "INIT            ";
      TopCtrl_Enum_WEIGHT_CACHE : Fsm_currentState_string = "WEIGHT_CACHE    ";
      TopCtrl_Enum_RECEIVE_PICTURE : Fsm_currentState_string = "RECEIVE_PICTURE ";
      TopCtrl_Enum_RECEIVE_MATRIX : Fsm_currentState_string = "RECEIVE_MATRIX  ";
      TopCtrl_Enum_WAIT_COMPUTE_END : Fsm_currentState_string = "WAIT_COMPUTE_END";
      default : Fsm_currentState_string = "????????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      TopCtrl_Enum_IDLE : Fsm_nextState_string = "IDLE            ";
      TopCtrl_Enum_INIT : Fsm_nextState_string = "INIT            ";
      TopCtrl_Enum_WEIGHT_CACHE : Fsm_nextState_string = "WEIGHT_CACHE    ";
      TopCtrl_Enum_RECEIVE_PICTURE : Fsm_nextState_string = "RECEIVE_PICTURE ";
      TopCtrl_Enum_RECEIVE_MATRIX : Fsm_nextState_string = "RECEIVE_MATRIX  ";
      TopCtrl_Enum_WAIT_COMPUTE_END : Fsm_nextState_string = "WAIT_COMPUTE_END";
      default : Fsm_nextState_string = "????????????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & TopCtrl_Enum_IDLE) == TopCtrl_Enum_IDLE) : begin
        if(Control_start) begin
          Fsm_nextState = TopCtrl_Enum_INIT;
        end else begin
          Fsm_nextState = TopCtrl_Enum_IDLE;
        end
      end
      (((Fsm_currentState) & TopCtrl_Enum_INIT) == TopCtrl_Enum_INIT) : begin
        if(Fsm_Inited) begin
          Fsm_nextState = TopCtrl_Enum_WEIGHT_CACHE;
        end else begin
          Fsm_nextState = TopCtrl_Enum_INIT;
        end
      end
      (((Fsm_currentState) & TopCtrl_Enum_WEIGHT_CACHE) == TopCtrl_Enum_WEIGHT_CACHE) : begin
        if(when_Compute_TopV2_l225) begin
          Fsm_nextState = TopCtrl_Enum_RECEIVE_PICTURE;
        end else begin
          if(when_Compute_TopV2_l227) begin
            Fsm_nextState = TopCtrl_Enum_RECEIVE_MATRIX;
          end else begin
            Fsm_nextState = TopCtrl_Enum_WEIGHT_CACHE;
          end
        end
      end
      (((Fsm_currentState) & TopCtrl_Enum_RECEIVE_PICTURE) == TopCtrl_Enum_RECEIVE_PICTURE) : begin
        if(Fsm_Picture_Received) begin
          Fsm_nextState = TopCtrl_Enum_WAIT_COMPUTE_END;
        end else begin
          Fsm_nextState = TopCtrl_Enum_RECEIVE_PICTURE;
        end
      end
      (((Fsm_currentState) & TopCtrl_Enum_RECEIVE_MATRIX) == TopCtrl_Enum_RECEIVE_MATRIX) : begin
        if(Fsm_Matrix_Received) begin
          Fsm_nextState = TopCtrl_Enum_IDLE;
        end else begin
          Fsm_nextState = TopCtrl_Enum_RECEIVE_MATRIX;
        end
      end
      default : begin
        if(Fsm_Compute_End) begin
          Fsm_nextState = TopCtrl_Enum_IDLE;
        end else begin
          Fsm_nextState = TopCtrl_Enum_WAIT_COMPUTE_END;
        end
      end
    endcase
  end

  assign when_Compute_TopV2_l225 = (Fsm_WeightCached && Fsm_Switch_Conv);
  assign when_Compute_TopV2_l227 = (Fsm_WeightCached && (! Fsm_Switch_Conv));
  assign when_WaCounter_l19 = ((Fsm_currentState & TopCtrl_Enum_INIT) != 6'b000000);
  assign when_WaCounter_l14 = (InitCnt_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      InitCnt_valid = 1'b1;
    end else begin
      InitCnt_valid = 1'b0;
    end
  end

  assign Fsm_Inited = InitCnt_valid;
  assign s_axis_s2mm_tready = InputSwitch_s0_axis_s2mm_tready;
  assign when_Compute_TopV2_l316 = ((Fsm_currentState & TopCtrl_Enum_WEIGHT_CACHE) != 6'b000000);
  always @(*) begin
    if(when_Compute_TopV2_l316) begin
      InputSwitch_Switch = 2'b00;
    end else begin
      if(Control_Switch_Conv) begin
        InputSwitch_Switch = 2'b01;
      end else begin
        InputSwitch_Switch = 2'b10;
      end
    end
  end

  assign Fsm_Picture_Received = (Img2Col_Unit_LayerEnd || LH_Gemm_LayerEnd);
  assign Weight_Unit_Raddr_Valid = (Img2Col_Unit_Raddr_Valid || LH_Gemm_bvalid);
  assign Fsm_WeightCached = ConvQuant_1_QuantPara_Cached;
  assign Fsm_Compute_End = Control_LayerEnd;
  always @(*) begin
    InputSwitch_m_0_axis_mm2s_tready = Weight_Unit_s_axis_s2mm_tready;
    if(Weight_Unit_s_axis_s2mm_tready) begin
      InputSwitch_m_0_axis_mm2s_tready = Weight_Unit_s_axis_s2mm_tready;
    end else begin
      InputSwitch_m_0_axis_mm2s_tready = ConvQuant_1_sData_ready;
    end
  end

  assign Compute_Unit_OutChannel = Img2Col_OutFeature_Channel[9:0];
  assign Compute_Unit_signCount = (Img2Col_WeightMatrix_Row - 16'h0001);
  always @(*) begin
    if(Control_Switch_Conv) begin
      Compute_Unit_activate = Img2Col_Unit_mData;
    end else begin
      Compute_Unit_activate = LH_Gemm_mData;
    end
  end

  assign Compute_Unit_weight = Weight_Unit_mData;
  always @(*) begin
    Compute_Unit_b_Valid[0] = _zz_b_Valid[0];
    Compute_Unit_b_Valid[1] = _zz_b_Valid_1[0];
    Compute_Unit_b_Valid[2] = _zz_b_Valid_2[0];
    Compute_Unit_b_Valid[3] = _zz_b_Valid_3[0];
    Compute_Unit_b_Valid[4] = _zz_b_Valid_4[0];
    Compute_Unit_b_Valid[5] = _zz_b_Valid_5[0];
    Compute_Unit_b_Valid[6] = _zz_b_Valid_6[0];
    Compute_Unit_b_Valid[7] = _zz_b_Valid_7[0];
  end

  always @(*) begin
    if(Control_Switch_Conv) begin
      Compute_Unit_a_Valid = Img2Col_Unit_mValid;
    end else begin
      Compute_Unit_a_Valid[0] = LH_Gemm_validOut_0;
      Compute_Unit_a_Valid[1] = LH_Gemm_validOut_1;
      Compute_Unit_a_Valid[2] = LH_Gemm_validOut_2;
      Compute_Unit_a_Valid[3] = LH_Gemm_validOut_3;
      Compute_Unit_a_Valid[4] = LH_Gemm_validOut_4;
      Compute_Unit_a_Valid[5] = LH_Gemm_validOut_5;
      Compute_Unit_a_Valid[6] = LH_Gemm_validOut_6;
      Compute_Unit_a_Valid[7] = LH_Gemm_validOut_7;
    end
  end

  assign Fsm_Matrix_Received = LH_Gemm_LayerEnd;
  assign Fsm_Switch_Conv = Control_Switch_Conv;
  assign LH_Gemm_WIDTH = GemmInstru_WIDTH[11:0];
  assign LH_Gemm_HIGHT = GemmInstru_HEIGHT[11:0];
  assign LH_Gemm_WEIGHTCOL = Img2Col_OutFeature_Channel[7:0];
  assign mData_payload = ConvQuant_1_dataOut;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= TopCtrl_Enum_IDLE;
      InitCnt_count <= 3'b000;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        InitCnt_count <= (InitCnt_count + 3'b001);
        if(InitCnt_valid) begin
          InitCnt_count <= 3'b000;
        end
      end
    end
  end

  always @(posedge clk) begin
    toplevel_Weight_Unit_Weight_Cached_delay_1 <= Weight_Unit_Weight_Cached;
    toplevel_Weight_Unit_Weight_Cached_delay_2 <= toplevel_Weight_Unit_Weight_Cached_delay_1;
    toplevel_Weight_Unit_Weight_Cached_delay_3 <= toplevel_Weight_Unit_Weight_Cached_delay_2;
    _zz_start <= ((Fsm_nextState & TopCtrl_Enum_WEIGHT_CACHE) != 6'b000000);
    _zz_start_1 <= _zz_start;
    _zz_start_2 <= _zz_start_1;
    _zz_start_3 <= (((Fsm_nextState & TopCtrl_Enum_WEIGHT_CACHE) != 6'b000000) && Control_Switch_Conv);
    _zz_start_4 <= _zz_start_3;
    _zz_start_5 <= _zz_start_4;
  end


endmodule

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

module Img2ColStreamV2 (
  output reg [63:0]   mData,
  input               mReady,
  output reg [7:0]    mValid,
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  input               start,
  output              Raddr_Valid,
  output              LayerEnd,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutRow_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  input               clk,
  input               reset
);

  wire                SubModule_Fifo_Clear;
  wire       [15:0]   SubModule_Test_Generate_Period;
  wire                streamFifo_io_push_valid;
  wire                streamFifo_1_io_push_valid;
  wire                streamFifo_2_io_push_valid;
  wire                streamFifo_3_io_push_valid;
  wire                streamFifo_4_io_push_valid;
  wire                streamFifo_5_io_push_valid;
  wire                streamFifo_6_io_push_valid;
  wire                streamFifo_7_io_push_valid;
  wire                SubModule_sData_ready;
  wire       [63:0]   SubModule_mData;
  wire                SubModule_mValid;
  wire                SubModule_mLast;
  wire                SubModule_Test_Signal;
  wire                SubModule_Test_End;
  wire                SubModule_Raddr_Valid;
  wire                SubModule_LayerEnd;
  wire                SubModule_SA_Row_Cnt_Valid;
  wire                streamFifo_io_push_ready;
  wire                streamFifo_io_pop_valid;
  wire       [63:0]   streamFifo_io_pop_payload;
  wire       [4:0]    streamFifo_io_occupancy;
  wire       [4:0]    streamFifo_io_availability;
  wire                axisDataConverter_8_inStream_ready;
  wire                axisDataConverter_8_outStream_valid;
  wire       [7:0]    axisDataConverter_8_outStream_payload;
  wire                streamFifo_1_io_push_ready;
  wire                streamFifo_1_io_pop_valid;
  wire       [63:0]   streamFifo_1_io_pop_payload;
  wire       [4:0]    streamFifo_1_io_occupancy;
  wire       [4:0]    streamFifo_1_io_availability;
  wire                axisDataConverter_9_inStream_ready;
  wire                axisDataConverter_9_outStream_valid;
  wire       [7:0]    axisDataConverter_9_outStream_payload;
  wire                streamFifo_2_io_push_ready;
  wire                streamFifo_2_io_pop_valid;
  wire       [63:0]   streamFifo_2_io_pop_payload;
  wire       [4:0]    streamFifo_2_io_occupancy;
  wire       [4:0]    streamFifo_2_io_availability;
  wire                axisDataConverter_10_inStream_ready;
  wire                axisDataConverter_10_outStream_valid;
  wire       [7:0]    axisDataConverter_10_outStream_payload;
  wire                streamFifo_3_io_push_ready;
  wire                streamFifo_3_io_pop_valid;
  wire       [63:0]   streamFifo_3_io_pop_payload;
  wire       [4:0]    streamFifo_3_io_occupancy;
  wire       [4:0]    streamFifo_3_io_availability;
  wire                axisDataConverter_11_inStream_ready;
  wire                axisDataConverter_11_outStream_valid;
  wire       [7:0]    axisDataConverter_11_outStream_payload;
  wire                streamFifo_4_io_push_ready;
  wire                streamFifo_4_io_pop_valid;
  wire       [63:0]   streamFifo_4_io_pop_payload;
  wire       [4:0]    streamFifo_4_io_occupancy;
  wire       [4:0]    streamFifo_4_io_availability;
  wire                axisDataConverter_12_inStream_ready;
  wire                axisDataConverter_12_outStream_valid;
  wire       [7:0]    axisDataConverter_12_outStream_payload;
  wire                streamFifo_5_io_push_ready;
  wire                streamFifo_5_io_pop_valid;
  wire       [63:0]   streamFifo_5_io_pop_payload;
  wire       [4:0]    streamFifo_5_io_occupancy;
  wire       [4:0]    streamFifo_5_io_availability;
  wire                axisDataConverter_13_inStream_ready;
  wire                axisDataConverter_13_outStream_valid;
  wire       [7:0]    axisDataConverter_13_outStream_payload;
  wire                streamFifo_6_io_push_ready;
  wire                streamFifo_6_io_pop_valid;
  wire       [63:0]   streamFifo_6_io_pop_payload;
  wire       [4:0]    streamFifo_6_io_occupancy;
  wire       [4:0]    streamFifo_6_io_availability;
  wire                axisDataConverter_14_inStream_ready;
  wire                axisDataConverter_14_outStream_valid;
  wire       [7:0]    axisDataConverter_14_outStream_payload;
  wire                streamFifo_7_io_push_ready;
  wire                streamFifo_7_io_pop_valid;
  wire       [63:0]   streamFifo_7_io_pop_payload;
  wire       [4:0]    streamFifo_7_io_occupancy;
  wire       [4:0]    streamFifo_7_io_availability;
  wire                axisDataConverter_15_inStream_ready;
  wire                axisDataConverter_15_outStream_valid;
  wire       [7:0]    axisDataConverter_15_outStream_payload;
  reg        [7:0]    OutData_Switch;
  reg                 Switch_Reset;
  wire                TestValid_Signal_0;
  wire                TestValid_Signal_1;
  wire                TestValid_Signal_2;
  wire                TestValid_Signal_3;
  wire                TestValid_Signal_4;
  wire                TestValid_Signal_5;
  wire                TestValid_Signal_6;
  wire                TestValid_Signal_7;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_8_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_8_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_9_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_9_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_10_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_10_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_11_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_11_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_12_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_12_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_13_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_13_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_14_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_14_outStream_valid_regNext;
  reg        [7:0]    Img2Col_Unit_axisDataConverter_15_outStream_payload_regNext;
  reg                 Img2Col_Unit_axisDataConverter_15_outStream_valid_regNext;
  reg                 Img2Col_Unit_SubModule_LayerEnd_delay_1;
  reg                 Img2Col_Unit_SubModule_LayerEnd_delay_2;
  reg                 Img2Col_Unit_SubModule_LayerEnd_delay_3;

  Img2Col_Top SubModule (
    .start                          (start                               ), //i
    .sData_valid                    (s_axis_s2mm_tvalid                  ), //i
    .sData_ready                    (SubModule_sData_ready               ), //o
    .sData_payload                  (s_axis_s2mm_tdata[63:0]             ), //i
    .mData                          (SubModule_mData[63:0]               ), //o
    .mReady                         (streamFifo_io_push_ready            ), //i
    .mValid                         (SubModule_mValid                    ), //o
    .Fifo_Clear                     (SubModule_Fifo_Clear                ), //i
    .mLast                          (SubModule_mLast                     ), //o
    .Stride                         (Stride[4:0]                         ), //i
    .Kernel_Size                    (Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Window_Size[15:0]                   ), //i
    .InFeature_Size                 (InFeature_Size[15:0]                ), //i
    .InFeature_Channel              (InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (OutFeature_Channel[15:0]            ), //i
    .OutFeature_Size                (OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (InCol_Count_Times[15:0]             ), //i
    .OutRow_Count_Times             (OutRow_Count_Times[15:0]            ), //i
    .OutFeature_Channel_Count_Times (OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Sliding_Size[12:0]                  ), //i
    .Test_Signal                    (SubModule_Test_Signal               ), //o
    .Test_Generate_Period           (SubModule_Test_Generate_Period[15:0]), //i
    .Test_End                       (SubModule_Test_End                  ), //o
    .Raddr_Valid                    (SubModule_Raddr_Valid               ), //o
    .LayerEnd                       (SubModule_LayerEnd                  ), //o
    .SA_Row_Cnt_Valid               (SubModule_SA_Row_Cnt_Valid          ), //o
    .clk                            (clk                                 ), //i
    .reset                          (reset                               )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo (
    .io_push_valid   (streamFifo_io_push_valid          ), //i
    .io_push_ready   (streamFifo_io_push_ready          ), //o
    .io_push_payload (SubModule_mData[63:0]             ), //i
    .io_pop_valid    (streamFifo_io_pop_valid           ), //o
    .io_pop_ready    (axisDataConverter_8_inStream_ready), //i
    .io_pop_payload  (streamFifo_io_pop_payload[63:0]   ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_io_occupancy[4:0]      ), //o
    .io_availability (streamFifo_io_availability[4:0]   ), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  AxisDataConverter axisDataConverter_8 (
    .inStream_valid    (streamFifo_io_pop_valid                   ), //i
    .inStream_ready    (axisDataConverter_8_inStream_ready        ), //o
    .inStream_payload  (streamFifo_io_pop_payload[63:0]           ), //i
    .outStream_valid   (axisDataConverter_8_outStream_valid       ), //o
    .outStream_ready   (1'b1                                      ), //i
    .outStream_payload (axisDataConverter_8_outStream_payload[7:0]), //o
    .clk               (clk                                       ), //i
    .reset             (reset                                     )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_1 (
    .io_push_valid   (streamFifo_1_io_push_valid        ), //i
    .io_push_ready   (streamFifo_1_io_push_ready        ), //o
    .io_push_payload (SubModule_mData[63:0]             ), //i
    .io_pop_valid    (streamFifo_1_io_pop_valid         ), //o
    .io_pop_ready    (axisDataConverter_9_inStream_ready), //i
    .io_pop_payload  (streamFifo_1_io_pop_payload[63:0] ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_1_io_occupancy[4:0]    ), //o
    .io_availability (streamFifo_1_io_availability[4:0] ), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  AxisDataConverter axisDataConverter_9 (
    .inStream_valid    (streamFifo_1_io_pop_valid                 ), //i
    .inStream_ready    (axisDataConverter_9_inStream_ready        ), //o
    .inStream_payload  (streamFifo_1_io_pop_payload[63:0]         ), //i
    .outStream_valid   (axisDataConverter_9_outStream_valid       ), //o
    .outStream_ready   (1'b1                                      ), //i
    .outStream_payload (axisDataConverter_9_outStream_payload[7:0]), //o
    .clk               (clk                                       ), //i
    .reset             (reset                                     )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_2 (
    .io_push_valid   (streamFifo_2_io_push_valid         ), //i
    .io_push_ready   (streamFifo_2_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_2_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_10_inStream_ready), //i
    .io_pop_payload  (streamFifo_2_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_2_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_2_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_10 (
    .inStream_valid    (streamFifo_2_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_10_inStream_ready        ), //o
    .inStream_payload  (streamFifo_2_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_10_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_10_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_3 (
    .io_push_valid   (streamFifo_3_io_push_valid         ), //i
    .io_push_ready   (streamFifo_3_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_3_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_11_inStream_ready), //i
    .io_pop_payload  (streamFifo_3_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_3_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_3_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_11 (
    .inStream_valid    (streamFifo_3_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_11_inStream_ready        ), //o
    .inStream_payload  (streamFifo_3_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_11_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_11_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_4 (
    .io_push_valid   (streamFifo_4_io_push_valid         ), //i
    .io_push_ready   (streamFifo_4_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_4_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_12_inStream_ready), //i
    .io_pop_payload  (streamFifo_4_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_4_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_4_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_12 (
    .inStream_valid    (streamFifo_4_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_12_inStream_ready        ), //o
    .inStream_payload  (streamFifo_4_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_12_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_12_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_5 (
    .io_push_valid   (streamFifo_5_io_push_valid         ), //i
    .io_push_ready   (streamFifo_5_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_5_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_13_inStream_ready), //i
    .io_pop_payload  (streamFifo_5_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_5_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_5_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_13 (
    .inStream_valid    (streamFifo_5_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_13_inStream_ready        ), //o
    .inStream_payload  (streamFifo_5_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_13_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_13_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_6 (
    .io_push_valid   (streamFifo_6_io_push_valid         ), //i
    .io_push_ready   (streamFifo_6_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_6_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_14_inStream_ready), //i
    .io_pop_payload  (streamFifo_6_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_6_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_6_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_14 (
    .inStream_valid    (streamFifo_6_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_14_inStream_ready        ), //o
    .inStream_payload  (streamFifo_6_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_14_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_14_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  Img2Col_WidthConverter_Fifo streamFifo_7 (
    .io_push_valid   (streamFifo_7_io_push_valid         ), //i
    .io_push_ready   (streamFifo_7_io_push_ready         ), //o
    .io_push_payload (SubModule_mData[63:0]              ), //i
    .io_pop_valid    (streamFifo_7_io_pop_valid          ), //o
    .io_pop_ready    (axisDataConverter_15_inStream_ready), //i
    .io_pop_payload  (streamFifo_7_io_pop_payload[63:0]  ), //o
    .io_flush        (1'b0                               ), //i
    .io_occupancy    (streamFifo_7_io_occupancy[4:0]     ), //o
    .io_availability (streamFifo_7_io_availability[4:0]  ), //o
    .clk             (clk                                ), //i
    .reset           (reset                              )  //i
  );
  AxisDataConverter axisDataConverter_15 (
    .inStream_valid    (streamFifo_7_io_pop_valid                  ), //i
    .inStream_ready    (axisDataConverter_15_inStream_ready        ), //o
    .inStream_payload  (streamFifo_7_io_pop_payload[63:0]          ), //i
    .outStream_valid   (axisDataConverter_15_outStream_valid       ), //o
    .outStream_ready   (1'b1                                       ), //i
    .outStream_payload (axisDataConverter_15_outStream_payload[7:0]), //o
    .clk               (clk                                        ), //i
    .reset             (reset                                      )  //i
  );
  assign streamFifo_io_push_valid = (OutData_Switch[0] && SubModule_mValid);
  always @(*) begin
    mData[7 : 0] = Img2Col_Unit_axisDataConverter_8_outStream_payload_regNext;
    mData[15 : 8] = Img2Col_Unit_axisDataConverter_9_outStream_payload_regNext;
    mData[23 : 16] = Img2Col_Unit_axisDataConverter_10_outStream_payload_regNext;
    mData[31 : 24] = Img2Col_Unit_axisDataConverter_11_outStream_payload_regNext;
    mData[39 : 32] = Img2Col_Unit_axisDataConverter_12_outStream_payload_regNext;
    mData[47 : 40] = Img2Col_Unit_axisDataConverter_13_outStream_payload_regNext;
    mData[55 : 48] = Img2Col_Unit_axisDataConverter_14_outStream_payload_regNext;
    mData[63 : 56] = Img2Col_Unit_axisDataConverter_15_outStream_payload_regNext;
  end

  always @(*) begin
    mValid[0] = Img2Col_Unit_axisDataConverter_8_outStream_valid_regNext;
    mValid[1] = Img2Col_Unit_axisDataConverter_9_outStream_valid_regNext;
    mValid[2] = Img2Col_Unit_axisDataConverter_10_outStream_valid_regNext;
    mValid[3] = Img2Col_Unit_axisDataConverter_11_outStream_valid_regNext;
    mValid[4] = Img2Col_Unit_axisDataConverter_12_outStream_valid_regNext;
    mValid[5] = Img2Col_Unit_axisDataConverter_13_outStream_valid_regNext;
    mValid[6] = Img2Col_Unit_axisDataConverter_14_outStream_valid_regNext;
    mValid[7] = Img2Col_Unit_axisDataConverter_15_outStream_valid_regNext;
  end

  assign streamFifo_1_io_push_valid = (OutData_Switch[1] && SubModule_mValid);
  assign streamFifo_2_io_push_valid = (OutData_Switch[2] && SubModule_mValid);
  assign streamFifo_3_io_push_valid = (OutData_Switch[3] && SubModule_mValid);
  assign streamFifo_4_io_push_valid = (OutData_Switch[4] && SubModule_mValid);
  assign streamFifo_5_io_push_valid = (OutData_Switch[5] && SubModule_mValid);
  assign streamFifo_6_io_push_valid = (OutData_Switch[6] && SubModule_mValid);
  assign streamFifo_7_io_push_valid = (OutData_Switch[7] && SubModule_mValid);
  assign Raddr_Valid = axisDataConverter_8_outStream_valid;
  assign s_axis_s2mm_tready = SubModule_sData_ready;
  assign SubModule_Fifo_Clear = (! streamFifo_io_pop_valid);
  assign LayerEnd = Img2Col_Unit_SubModule_LayerEnd_delay_3;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      OutData_Switch <= 8'h01;
    end else begin
      if(Switch_Reset) begin
        OutData_Switch <= 8'h01;
      end else begin
        if(SubModule_mValid) begin
          OutData_Switch <= {OutData_Switch[6 : 0],OutData_Switch[7 : 7]};
        end
      end
    end
  end

  always @(posedge clk) begin
    Switch_Reset <= SubModule_SA_Row_Cnt_Valid;
    Img2Col_Unit_axisDataConverter_8_outStream_payload_regNext <= axisDataConverter_8_outStream_payload;
    Img2Col_Unit_axisDataConverter_8_outStream_valid_regNext <= axisDataConverter_8_outStream_valid;
    Img2Col_Unit_axisDataConverter_9_outStream_payload_regNext <= axisDataConverter_9_outStream_payload;
    Img2Col_Unit_axisDataConverter_9_outStream_valid_regNext <= axisDataConverter_9_outStream_valid;
    Img2Col_Unit_axisDataConverter_10_outStream_payload_regNext <= axisDataConverter_10_outStream_payload;
    Img2Col_Unit_axisDataConverter_10_outStream_valid_regNext <= axisDataConverter_10_outStream_valid;
    Img2Col_Unit_axisDataConverter_11_outStream_payload_regNext <= axisDataConverter_11_outStream_payload;
    Img2Col_Unit_axisDataConverter_11_outStream_valid_regNext <= axisDataConverter_11_outStream_valid;
    Img2Col_Unit_axisDataConverter_12_outStream_payload_regNext <= axisDataConverter_12_outStream_payload;
    Img2Col_Unit_axisDataConverter_12_outStream_valid_regNext <= axisDataConverter_12_outStream_valid;
    Img2Col_Unit_axisDataConverter_13_outStream_payload_regNext <= axisDataConverter_13_outStream_payload;
    Img2Col_Unit_axisDataConverter_13_outStream_valid_regNext <= axisDataConverter_13_outStream_valid;
    Img2Col_Unit_axisDataConverter_14_outStream_payload_regNext <= axisDataConverter_14_outStream_payload;
    Img2Col_Unit_axisDataConverter_14_outStream_valid_regNext <= axisDataConverter_14_outStream_valid;
    Img2Col_Unit_axisDataConverter_15_outStream_payload_regNext <= axisDataConverter_15_outStream_payload;
    Img2Col_Unit_axisDataConverter_15_outStream_valid_regNext <= axisDataConverter_15_outStream_valid;
    Img2Col_Unit_SubModule_LayerEnd_delay_1 <= SubModule_LayerEnd;
    Img2Col_Unit_SubModule_LayerEnd_delay_2 <= Img2Col_Unit_SubModule_LayerEnd_delay_1;
    Img2Col_Unit_SubModule_LayerEnd_delay_3 <= Img2Col_Unit_SubModule_LayerEnd_delay_2;
  end


endmodule

module WeightCache_Stream (
  input      [63:0]   s_axis_s2mm_tdata,
  input      [7:0]    s_axis_s2mm_tkeep,
  input               s_axis_s2mm_tlast,
  output              s_axis_s2mm_tready,
  input               s_axis_s2mm_tvalid,
  input               start,
  input      [15:0]   Matrix_Row,
  input      [15:0]   Matrix_Col,
  output     [63:0]   mData,
  input               Raddr_Valid,
  output              Weight_Cached,
  input               LayerEnd,
  output     [7:0]    MatrixCol_Switch,
  input               clk,
  input               reset
);

  wire                WeightCache_sData_ready;
  wire       [63:0]   WeightCache_mData;
  wire                WeightCache_Weight_Cached;
  wire       [7:0]    WeightCache_MatrixCol_Switch;

  Weight_Cache WeightCache (
    .start            (start                            ), //i
    .sData_valid      (s_axis_s2mm_tvalid               ), //i
    .sData_ready      (WeightCache_sData_ready          ), //o
    .sData_payload    (s_axis_s2mm_tdata[63:0]          ), //i
    .Matrix_Row       (Matrix_Row[15:0]                 ), //i
    .Matrix_Col       (Matrix_Col[15:0]                 ), //i
    .mData            (WeightCache_mData[63:0]          ), //o
    .Raddr_Valid      (Raddr_Valid                      ), //i
    .Weight_Cached    (WeightCache_Weight_Cached        ), //o
    .LayerEnd         (LayerEnd                         ), //i
    .MatrixCol_Switch (WeightCache_MatrixCol_Switch[7:0]), //o
    .clk              (clk                              ), //i
    .reset            (reset                            )  //i
  );
  assign mData = WeightCache_mData;
  assign Weight_Cached = WeightCache_Weight_Cached;
  assign MatrixCol_Switch = WeightCache_MatrixCol_Switch;
  assign s_axis_s2mm_tready = WeightCache_sData_ready;

endmodule

module SA_Conv (
  input      [63:0]   activate,
  input      [7:0]    a_Valid,
  input      [63:0]   weight,
  input      [7:0]    b_Valid,
  input      [15:0]   signCount,
  output              resultVaild_0,
  output              resultVaild_1,
  output              resultVaild_2,
  output              resultVaild_3,
  output              resultVaild_4,
  output              resultVaild_5,
  output              resultVaild_6,
  output              resultVaild_7,
  input      [11:0]   OutMatrix_Col,
  input      [15:0]   OutMatrix_Row,
  input      [9:0]    OutChannel,
  input      [15:0]   OutFeatureSize,
  input               Matrix2Img,
  input               start,
  output     [31:0]   mData_0,
  output     [31:0]   mData_1,
  output     [31:0]   mData_2,
  output     [31:0]   mData_3,
  output     [31:0]   mData_4,
  output     [31:0]   mData_5,
  output     [31:0]   mData_6,
  output     [31:0]   mData_7,
  input               clk,
  input               reset
);

  wire                Tile_1_a_Valid_0;
  wire                Tile_1_a_Valid_1;
  wire                Tile_1_a_Valid_2;
  wire                Tile_1_a_Valid_3;
  wire                Tile_1_a_Valid_4;
  wire                Tile_1_a_Valid_5;
  wire                Tile_1_a_Valid_6;
  wire                Tile_1_a_Valid_7;
  wire                Tile_1_b_Valid_0;
  wire                Tile_1_b_Valid_1;
  wire                Tile_1_b_Valid_2;
  wire                Tile_1_b_Valid_3;
  wire                Tile_1_b_Valid_4;
  wire                Tile_1_b_Valid_5;
  wire                Tile_1_b_Valid_6;
  wire                Tile_1_b_Valid_7;
  wire       [31:0]   Tile_1_PE_OUT_0;
  wire       [31:0]   Tile_1_PE_OUT_1;
  wire       [31:0]   Tile_1_PE_OUT_2;
  wire       [31:0]   Tile_1_PE_OUT_3;
  wire       [31:0]   Tile_1_PE_OUT_4;
  wire       [31:0]   Tile_1_PE_OUT_5;
  wire       [31:0]   Tile_1_PE_OUT_6;
  wire       [31:0]   Tile_1_PE_OUT_7;
  wire                Tile_1_resultVaild_0;
  wire                Tile_1_resultVaild_1;
  wire                Tile_1_resultVaild_2;
  wire                Tile_1_resultVaild_3;
  wire                Tile_1_resultVaild_4;
  wire                Tile_1_resultVaild_5;
  wire                Tile_1_resultVaild_6;
  wire                Tile_1_resultVaild_7;

  Tile Tile_1 (
    .activate      (activate[63:0]       ), //i
    .a_Valid_0     (Tile_1_a_Valid_0     ), //i
    .a_Valid_1     (Tile_1_a_Valid_1     ), //i
    .a_Valid_2     (Tile_1_a_Valid_2     ), //i
    .a_Valid_3     (Tile_1_a_Valid_3     ), //i
    .a_Valid_4     (Tile_1_a_Valid_4     ), //i
    .a_Valid_5     (Tile_1_a_Valid_5     ), //i
    .a_Valid_6     (Tile_1_a_Valid_6     ), //i
    .a_Valid_7     (Tile_1_a_Valid_7     ), //i
    .weight        (weight[63:0]         ), //i
    .b_Valid_0     (Tile_1_b_Valid_0     ), //i
    .b_Valid_1     (Tile_1_b_Valid_1     ), //i
    .b_Valid_2     (Tile_1_b_Valid_2     ), //i
    .b_Valid_3     (Tile_1_b_Valid_3     ), //i
    .b_Valid_4     (Tile_1_b_Valid_4     ), //i
    .b_Valid_5     (Tile_1_b_Valid_5     ), //i
    .b_Valid_6     (Tile_1_b_Valid_6     ), //i
    .b_Valid_7     (Tile_1_b_Valid_7     ), //i
    .signCount     (signCount[15:0]      ), //i
    .PE_OUT_0      (Tile_1_PE_OUT_0[31:0]), //o
    .PE_OUT_1      (Tile_1_PE_OUT_1[31:0]), //o
    .PE_OUT_2      (Tile_1_PE_OUT_2[31:0]), //o
    .PE_OUT_3      (Tile_1_PE_OUT_3[31:0]), //o
    .PE_OUT_4      (Tile_1_PE_OUT_4[31:0]), //o
    .PE_OUT_5      (Tile_1_PE_OUT_5[31:0]), //o
    .PE_OUT_6      (Tile_1_PE_OUT_6[31:0]), //o
    .PE_OUT_7      (Tile_1_PE_OUT_7[31:0]), //o
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
  assign Tile_1_a_Valid_0 = a_Valid[0];
  assign Tile_1_b_Valid_0 = b_Valid[0];
  assign Tile_1_a_Valid_1 = a_Valid[1];
  assign Tile_1_b_Valid_1 = b_Valid[1];
  assign Tile_1_a_Valid_2 = a_Valid[2];
  assign Tile_1_b_Valid_2 = b_Valid[2];
  assign Tile_1_a_Valid_3 = a_Valid[3];
  assign Tile_1_b_Valid_3 = b_Valid[3];
  assign Tile_1_a_Valid_4 = a_Valid[4];
  assign Tile_1_b_Valid_4 = b_Valid[4];
  assign Tile_1_a_Valid_5 = a_Valid[5];
  assign Tile_1_b_Valid_5 = b_Valid[5];
  assign Tile_1_a_Valid_6 = a_Valid[6];
  assign Tile_1_b_Valid_6 = b_Valid[6];
  assign Tile_1_a_Valid_7 = a_Valid[7];
  assign Tile_1_b_Valid_7 = b_Valid[7];
  assign mData_0 = Tile_1_PE_OUT_0;
  assign mData_1 = Tile_1_PE_OUT_1;
  assign mData_2 = Tile_1_PE_OUT_2;
  assign mData_3 = Tile_1_PE_OUT_3;
  assign mData_4 = Tile_1_PE_OUT_4;
  assign mData_5 = Tile_1_PE_OUT_5;
  assign mData_6 = Tile_1_PE_OUT_6;
  assign mData_7 = Tile_1_PE_OUT_7;
  assign resultVaild_0 = Tile_1_resultVaild_0;
  assign resultVaild_1 = Tile_1_resultVaild_1;
  assign resultVaild_2 = Tile_1_resultVaild_2;
  assign resultVaild_3 = Tile_1_resultVaild_3;
  assign resultVaild_4 = Tile_1_resultVaild_4;
  assign resultVaild_5 = Tile_1_resultVaild_5;
  assign resultVaild_6 = Tile_1_resultVaild_6;
  assign resultVaild_7 = Tile_1_resultVaild_7;

endmodule

module Compute_DataIn_Switch (
  input      [1:0]    Switch,
  input      [63:0]   s0_axis_s2mm_tdata,
  input      [7:0]    s0_axis_s2mm_tkeep,
  input               s0_axis_s2mm_tlast,
  output reg          s0_axis_s2mm_tready,
  input               s0_axis_s2mm_tvalid,
  output reg [63:0]   m_0_axis_mm2s_tdata,
  output     [7:0]    m_0_axis_mm2s_tkeep,
  output reg          m_0_axis_mm2s_tlast,
  input               m_0_axis_mm2s_tready,
  output reg          m_0_axis_mm2s_tvalid,
  output reg [63:0]   m_1_axis_mm2s_tdata,
  output     [7:0]    m_1_axis_mm2s_tkeep,
  output reg          m_1_axis_mm2s_tlast,
  input               m_1_axis_mm2s_tready,
  output reg          m_1_axis_mm2s_tvalid,
  output reg [63:0]   m_2_axis_mm2s_tdata,
  output     [7:0]    m_2_axis_mm2s_tkeep,
  output reg          m_2_axis_mm2s_tlast,
  input               m_2_axis_mm2s_tready,
  output reg          m_2_axis_mm2s_tvalid
);

  wire                when_Axis_Switch_l103;
  wire                when_Axis_Switch_l103_1;
  wire                when_Axis_Switch_l103_2;

  assign m_0_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_1_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  assign m_2_axis_mm2s_tkeep = s0_axis_s2mm_tkeep;
  always @(*) begin
    s0_axis_s2mm_tready = 1'b0;
    if(when_Axis_Switch_l103) begin
      s0_axis_s2mm_tready = m_0_axis_mm2s_tready;
    end
    if(when_Axis_Switch_l103_1) begin
      s0_axis_s2mm_tready = m_1_axis_mm2s_tready;
    end
    if(when_Axis_Switch_l103_2) begin
      s0_axis_s2mm_tready = m_2_axis_mm2s_tready;
    end
  end

  assign when_Axis_Switch_l103 = (Switch == 2'b00);
  always @(*) begin
    if(when_Axis_Switch_l103) begin
      m_0_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_0_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_Axis_Switch_l103) begin
      m_0_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_0_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_Axis_Switch_l103) begin
      m_0_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_0_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_Axis_Switch_l103_1 = (Switch == 2'b01);
  always @(*) begin
    if(when_Axis_Switch_l103_1) begin
      m_1_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_1_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_Axis_Switch_l103_1) begin
      m_1_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_1_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_Axis_Switch_l103_1) begin
      m_1_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_1_axis_mm2s_tvalid = 1'b0;
    end
  end

  assign when_Axis_Switch_l103_2 = (Switch == 2'b10);
  always @(*) begin
    if(when_Axis_Switch_l103_2) begin
      m_2_axis_mm2s_tdata = s0_axis_s2mm_tdata;
    end else begin
      m_2_axis_mm2s_tdata = 64'h0;
    end
  end

  always @(*) begin
    if(when_Axis_Switch_l103_2) begin
      m_2_axis_mm2s_tlast = s0_axis_s2mm_tlast;
    end else begin
      m_2_axis_mm2s_tlast = 1'b0;
    end
  end

  always @(*) begin
    if(when_Axis_Switch_l103_2) begin
      m_2_axis_mm2s_tvalid = s0_axis_s2mm_tvalid;
    end else begin
      m_2_axis_mm2s_tvalid = 1'b0;
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

//AxisDataConverter_7 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_6 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_5 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_4 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_3 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_2 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

//AxisDataConverter_1 replaced by AxisDataConverter

//Img2Col_WidthConverter_Fifo replaced by Img2Col_WidthConverter_Fifo

module AxisDataConverter (
  input               inStream_valid,
  output              inStream_ready,
  input      [63:0]   inStream_payload,
  output              outStream_valid,
  input               outStream_ready,
  output     [7:0]    outStream_payload,
  input               clk,
  input               reset
);

  wire       [2:0]    _zz__zz_outStream_payload_1;
  wire       [0:0]    _zz__zz_outStream_payload_1_1;
  wire       [63:0]   _zz__zz_outStream_payload_3;
  reg        [7:0]    _zz_outStream_payload_4;
  wire                outStream_fire;
  reg                 _zz_outStream_payload;
  reg        [2:0]    _zz_outStream_payload_1;
  reg        [2:0]    _zz_outStream_payload_2;
  wire                _zz_inStream_ready;
  wire       [63:0]   _zz_outStream_payload_3;

  assign _zz__zz_outStream_payload_1_1 = _zz_outStream_payload;
  assign _zz__zz_outStream_payload_1 = {2'd0, _zz__zz_outStream_payload_1_1};
  assign _zz__zz_outStream_payload_3 = inStream_payload;
  always @(*) begin
    case(_zz_outStream_payload_2)
      3'b000 : _zz_outStream_payload_4 = _zz_outStream_payload_3[7 : 0];
      3'b001 : _zz_outStream_payload_4 = _zz_outStream_payload_3[15 : 8];
      3'b010 : _zz_outStream_payload_4 = _zz_outStream_payload_3[23 : 16];
      3'b011 : _zz_outStream_payload_4 = _zz_outStream_payload_3[31 : 24];
      3'b100 : _zz_outStream_payload_4 = _zz_outStream_payload_3[39 : 32];
      3'b101 : _zz_outStream_payload_4 = _zz_outStream_payload_3[47 : 40];
      3'b110 : _zz_outStream_payload_4 = _zz_outStream_payload_3[55 : 48];
      default : _zz_outStream_payload_4 = _zz_outStream_payload_3[63 : 56];
    endcase
  end

  assign outStream_fire = (outStream_valid && outStream_ready);
  always @(*) begin
    _zz_outStream_payload = 1'b0;
    if(outStream_fire) begin
      _zz_outStream_payload = 1'b1;
    end
  end

  assign _zz_inStream_ready = (_zz_outStream_payload_2 == 3'b111);
  always @(*) begin
    _zz_outStream_payload_1 = (_zz_outStream_payload_2 + _zz__zz_outStream_payload_1);
    if(1'b0) begin
      _zz_outStream_payload_1 = 3'b000;
    end
  end

  assign outStream_valid = inStream_valid;
  assign _zz_outStream_payload_3 = _zz__zz_outStream_payload_3;
  assign outStream_payload = _zz_outStream_payload_4;
  assign inStream_ready = (outStream_ready && _zz_inStream_ready);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      _zz_outStream_payload_2 <= 3'b000;
    end else begin
      _zz_outStream_payload_2 <= _zz_outStream_payload_1;
    end
  end


endmodule

module Img2Col_WidthConverter_Fifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [63:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [63:0]   io_pop_payload,
  input               io_flush,
  output     [4:0]    io_occupancy,
  output     [4:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [63:0]   _zz_logic_ram_port0;
  wire       [3:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [3:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [63:0]   _zz_logic_ram_port_1;
  wire       [3:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [3:0]    logic_pushPtr_valueNext;
  reg        [3:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [3:0]    logic_popPtr_valueNext;
  reg        [3:0]    logic_popPtr_value;
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
  wire       [3:0]    logic_ptrDif;
  reg [63:0] logic_ram [0:15];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {3'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {3'd0, _zz_logic_popPtr_valueNext_1};
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 4'b1111);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 4'b0000;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 4'b1111);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 4'b0000;
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
      logic_pushPtr_value <= 4'b0000;
      logic_popPtr_value <= 4'b0000;
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

module Img2Col_Top (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  output     [63:0]   mData,
  input               mReady,
  output              mValid,
  input               Fifo_Clear,
  output              mLast,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutRow_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  output              Test_Signal,
  input      [15:0]   Test_Generate_Period,
  output              Test_End,
  output              Raddr_Valid,
  output              LayerEnd,
  output              SA_Row_Cnt_Valid,
  input               clk,
  input               reset
);
  localparam IMG2COL_ENUM_IDLE = 7'd1;
  localparam IMG2COL_ENUM_INIT = 7'd2;
  localparam IMG2COL_ENUM_INIT_ADDR = 7'd4;
  localparam IMG2COL_ENUM_DATA_CACHE = 7'd8;
  localparam IMG2COL_ENUM_WAIT_COMPUTE = 7'd16;
  localparam IMG2COL_ENUM_UPDATE_ADDR = 7'd32;
  localparam IMG2COL_ENUM_START_COMPUTE = 7'd64;

  reg                 AddrFifo_io_push_valid;
  reg                 AddrFifo_io_pop_ready;
  wire                AddrFifo_io_flush;
  reg                 RaddrFifo0_io_push_valid;
  reg        [15:0]   RaddrFifo0_io_push_payload;
  reg                 RaddrFifo0_io_pop_ready;
  wire                RaddrFifo0_io_flush;
  wire                Img2Col_SubModule_start;
  wire                Img2Col_SubModule_NewAddrIn_valid;
  wire       [13:0]   DGB_addra;
  wire       [13:0]   DGB_addrb;
  wire                AddrFifo_io_push_ready;
  wire                AddrFifo_io_pop_valid;
  wire       [15:0]   AddrFifo_io_pop_payload;
  wire       [5:0]    AddrFifo_io_occupancy;
  wire       [5:0]    AddrFifo_io_availability;
  wire                RaddrFifo0_io_push_ready;
  wire                RaddrFifo0_io_pop_valid;
  wire       [15:0]   RaddrFifo0_io_pop_payload;
  wire       [5:0]    RaddrFifo0_io_occupancy;
  wire       [5:0]    RaddrFifo0_io_availability;
  wire                Img2Col_SubModule_NewAddrIn_ready;
  wire                Img2Col_SubModule_SA_Idle;
  wire       [15:0]   Img2Col_SubModule_Raddr;
  wire                Img2Col_SubModule_Raddr_Valid;
  wire                Img2Col_SubModule_SA_End;
  wire                Img2Col_SubModule_AddrReceived;
  wire                Img2Col_SubModule_SA_Row_Cnt_Valid;
  wire       [63:0]   DGB_doutb;
  wire       [4:0]    _zz_Addr_Init_Cnt_valid;
  wire       [4:0]    _zz_Addr_Init_Cnt_valid_1;
  wire       [15:0]   _zz_In_Col_Cnt_valid;
  wire       [4:0]    _zz_Row_Cache_Cnt_valid;
  wire       [15:0]   _zz_In_Row_Cnt_valid;
  wire       [15:0]   _zz_when_Data_Generate_V2_l217;
  wire       [4:0]    _zz_when_Data_Generate_V2_l217_1;
  wire       [15:0]   _zz_Out_Row_Cnt_valid;
  wire       [15:0]   _zz_Test_Valid;
  reg                 start_regNext;
  wire                when_Data_Generate_V2_l59;
  reg        [6:0]    Fsm_currentState;
  reg        [6:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Addr_Inited;
  wire                Fsm_Data_Cached;
  wire                Fsm_Addr_Updated;
  wire                Fsm_SA_Ready;
  wire                Fsm_Cache_End;
  wire                Fsm_Layer_End;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l39;
  reg        [4:0]    Addr_Init_Cnt_count;
  wire                Addr_Init_Cnt_valid;
  reg        [15:0]   WaddrOffset;
  wire                when_Data_Generate_V2_l170;
  wire                when_Data_Generate_V2_l175;
  wire                SubModule_AddrFifo_io_pop_fire;
  wire                when_Data_Generate_V2_l179;
  wire                when_Data_Generate_V2_l183;
  reg        [15:0]   Raddr_Initialization;
  wire                when_Data_Generate_V2_l193;
  wire                when_Data_Generate_V2_l197;
  reg        [4:0]    Cache_Row_Num;
  reg        [4:0]    Raddr_Updata_Cnt_Num;
  wire                sData_fire;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [4:0]    Row_Cache_Cnt_count;
  wire                Row_Cache_Cnt_valid;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  wire                when_Data_Generate_V2_l217;
  reg                 CacheEnd_Flag;
  wire                when_Data_Generate_V2_l228;
  wire                Img2ColOutput_Module_Ready_Receive_Addr;
  wire                when_Data_Generate_V2_l245;
  wire                SubModule_RaddrFifo0_io_pop_fire;
  reg        [15:0]   Out_Row_Cnt_count;
  wire                Out_Row_Cnt_valid;
  wire       [15:0]   Waddr;
  wire                sData_fire_1;
  reg                 SubModule_Img2Col_SubModule_Raddr_Valid_regNext;
  reg                 Out_Row_Cnt_valid_regNext;
  reg        [15:0]   Out_Row_Cnt_count_regNext;
  wire                Test_Valid;
  reg                 Test_Valid_regNext;
  `ifndef SYNTHESIS
  reg [103:0] Fsm_currentState_string;
  reg [103:0] Fsm_nextState_string;
  `endif


  assign _zz_Addr_Init_Cnt_valid = (_zz_Addr_Init_Cnt_valid_1 - 5'h01);
  assign _zz_Addr_Init_Cnt_valid_1 = (Kernel_Size + Stride);
  assign _zz_In_Col_Cnt_valid = (InCol_Count_Times - 16'h0001);
  assign _zz_Row_Cache_Cnt_valid = (Cache_Row_Num - 5'h01);
  assign _zz_In_Row_Cnt_valid = (InFeature_Size - 16'h0001);
  assign _zz_when_Data_Generate_V2_l217_1 = (Kernel_Size - 5'h01);
  assign _zz_when_Data_Generate_V2_l217 = {11'd0, _zz_when_Data_Generate_V2_l217_1};
  assign _zz_Out_Row_Cnt_valid = (OutRow_Count_Times - 16'h0001);
  assign _zz_Test_Valid = (Test_Generate_Period - 16'h0001);
  WaddrOffset_Fifo_2 AddrFifo (
    .io_push_valid   (AddrFifo_io_push_valid       ), //i
    .io_push_ready   (AddrFifo_io_push_ready       ), //o
    .io_push_payload (WaddrOffset[15:0]            ), //i
    .io_pop_valid    (AddrFifo_io_pop_valid        ), //o
    .io_pop_ready    (AddrFifo_io_pop_ready        ), //i
    .io_pop_payload  (AddrFifo_io_pop_payload[15:0]), //o
    .io_flush        (AddrFifo_io_flush            ), //i
    .io_occupancy    (AddrFifo_io_occupancy[5:0]   ), //o
    .io_availability (AddrFifo_io_availability[5:0]), //o
    .clk             (clk                          ), //i
    .reset           (reset                        )  //i
  );
  WaddrOffset_Fifo_2 RaddrFifo0 (
    .io_push_valid   (RaddrFifo0_io_push_valid        ), //i
    .io_push_ready   (RaddrFifo0_io_push_ready        ), //o
    .io_push_payload (RaddrFifo0_io_push_payload[15:0]), //i
    .io_pop_valid    (RaddrFifo0_io_pop_valid         ), //o
    .io_pop_ready    (RaddrFifo0_io_pop_ready         ), //i
    .io_pop_payload  (RaddrFifo0_io_pop_payload[15:0] ), //o
    .io_flush        (RaddrFifo0_io_flush             ), //i
    .io_occupancy    (RaddrFifo0_io_occupancy[5:0]    ), //o
    .io_availability (RaddrFifo0_io_availability[5:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  Img2Col_OutPut Img2Col_SubModule (
    .start                          (Img2Col_SubModule_start             ), //i
    .NewAddrIn_valid                (Img2Col_SubModule_NewAddrIn_valid   ), //i
    .NewAddrIn_ready                (Img2Col_SubModule_NewAddrIn_ready   ), //o
    .NewAddrIn_payload              (RaddrFifo0_io_pop_payload[15:0]     ), //i
    .SA_Idle                        (Img2Col_SubModule_SA_Idle           ), //o
    .Raddr                          (Img2Col_SubModule_Raddr[15:0]       ), //o
    .Raddr_Valid                    (Img2Col_SubModule_Raddr_Valid       ), //o
    .SA_End                         (Img2Col_SubModule_SA_End            ), //o
    .Stride                         (Stride[4:0]                         ), //i
    .Kernel_Size                    (Kernel_Size[4:0]                    ), //i
    .Window_Size                    (Window_Size[15:0]                   ), //i
    .InFeature_Size                 (InFeature_Size[15:0]                ), //i
    .InFeature_Channel              (InFeature_Channel[15:0]             ), //i
    .OutFeature_Channel             (OutFeature_Channel[15:0]            ), //i
    .OutFeature_Size                (OutFeature_Size[15:0]               ), //i
    .OutCol_Count_Times             (OutCol_Count_Times[15:0]            ), //i
    .InCol_Count_Times              (InCol_Count_Times[15:0]             ), //i
    .OutFeature_Channel_Count_Times (OutFeature_Channel_Count_Times[15:0]), //i
    .Sliding_Size                   (Sliding_Size[12:0]                  ), //i
    .mReady                         (mReady                              ), //i
    .Fifo_Clear                     (Fifo_Clear                          ), //i
    .AddrReceived                   (Img2Col_SubModule_AddrReceived      ), //o
    .LayerEnd                       (Fsm_Layer_End                       ), //i
    .SA_Row_Cnt_Valid               (Img2Col_SubModule_SA_Row_Cnt_Valid  ), //o
    .clk                            (clk                                 ), //i
    .reset                          (reset                               )  //i
  );
  DataGen_Bram DGB (
    .clka  (clk                ), //i
    .addra (DGB_addra[13:0]    ), //i
    .dina  (sData_payload[63:0]), //i
    .ena   (sData_fire_1       ), //i
    .wea   (1'b1               ), //i
    .addrb (DGB_addrb[13:0]    ), //i
    .doutb (DGB_doutb[63:0]    ), //o
    .clkb  (clk                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      IMG2COL_ENUM_IDLE : Fsm_currentState_string = "IDLE         ";
      IMG2COL_ENUM_INIT : Fsm_currentState_string = "INIT         ";
      IMG2COL_ENUM_INIT_ADDR : Fsm_currentState_string = "INIT_ADDR    ";
      IMG2COL_ENUM_DATA_CACHE : Fsm_currentState_string = "DATA_CACHE   ";
      IMG2COL_ENUM_WAIT_COMPUTE : Fsm_currentState_string = "WAIT_COMPUTE ";
      IMG2COL_ENUM_UPDATE_ADDR : Fsm_currentState_string = "UPDATE_ADDR  ";
      IMG2COL_ENUM_START_COMPUTE : Fsm_currentState_string = "START_COMPUTE";
      default : Fsm_currentState_string = "?????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      IMG2COL_ENUM_IDLE : Fsm_nextState_string = "IDLE         ";
      IMG2COL_ENUM_INIT : Fsm_nextState_string = "INIT         ";
      IMG2COL_ENUM_INIT_ADDR : Fsm_nextState_string = "INIT_ADDR    ";
      IMG2COL_ENUM_DATA_CACHE : Fsm_nextState_string = "DATA_CACHE   ";
      IMG2COL_ENUM_WAIT_COMPUTE : Fsm_nextState_string = "WAIT_COMPUTE ";
      IMG2COL_ENUM_UPDATE_ADDR : Fsm_nextState_string = "UPDATE_ADDR  ";
      IMG2COL_ENUM_START_COMPUTE : Fsm_nextState_string = "START_COMPUTE";
      default : Fsm_nextState_string = "?????????????";
    endcase
  end
  `endif

  assign when_Data_Generate_V2_l59 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & IMG2COL_ENUM_IDLE) == IMG2COL_ENUM_IDLE) : begin
        if(when_Data_Generate_V2_l59) begin
          Fsm_nextState = IMG2COL_ENUM_INIT;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_INIT) == IMG2COL_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = IMG2COL_ENUM_INIT_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_INIT_ADDR) == IMG2COL_ENUM_INIT_ADDR) : begin
        if(Fsm_Addr_Inited) begin
          Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_INIT_ADDR;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_DATA_CACHE) == IMG2COL_ENUM_DATA_CACHE) : begin
        if(Fsm_Data_Cached) begin
          Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_WAIT_COMPUTE) == IMG2COL_ENUM_WAIT_COMPUTE) : begin
        if(Fsm_Layer_End) begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end else begin
          if(Fsm_SA_Ready) begin
            Fsm_nextState = IMG2COL_ENUM_UPDATE_ADDR;
          end else begin
            Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
          end
        end
      end
      (((Fsm_currentState) & IMG2COL_ENUM_UPDATE_ADDR) == IMG2COL_ENUM_UPDATE_ADDR) : begin
        if(Fsm_Addr_Updated) begin
          Fsm_nextState = IMG2COL_ENUM_START_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_ENUM_UPDATE_ADDR;
        end
      end
      default : begin
        if(Fsm_Layer_End) begin
          Fsm_nextState = IMG2COL_ENUM_IDLE;
        end else begin
          if(Fsm_Cache_End) begin
            Fsm_nextState = IMG2COL_ENUM_WAIT_COMPUTE;
          end else begin
            Fsm_nextState = IMG2COL_ENUM_DATA_CACHE;
          end
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & IMG2COL_ENUM_INIT) != 7'b0000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign when_WaCounter_l39 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign Addr_Init_Cnt_valid = ((Addr_Init_Cnt_count == _zz_Addr_Init_Cnt_valid) && when_WaCounter_l39);
  assign Fsm_Addr_Inited = Addr_Init_Cnt_valid;
  always @(*) begin
    AddrFifo_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l170) begin
      AddrFifo_io_push_valid = 1'b1;
    end
    if(In_Col_Cnt_valid) begin
      AddrFifo_io_push_valid = 1'b1;
    end
  end

  always @(*) begin
    AddrFifo_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l183) begin
      AddrFifo_io_pop_ready = 1'b1;
    end
    if(In_Col_Cnt_valid) begin
      AddrFifo_io_pop_ready = 1'b1;
    end
  end

  assign when_Data_Generate_V2_l170 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l175 = ((Fsm_currentState & IMG2COL_ENUM_INIT) != 7'b0000000);
  assign SubModule_AddrFifo_io_pop_fire = (AddrFifo_io_pop_valid && AddrFifo_io_pop_ready);
  assign when_Data_Generate_V2_l179 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l183 = (((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_ENUM_DATA_CACHE) != 7'b0000000));
  always @(*) begin
    RaddrFifo0_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l193) begin
      RaddrFifo0_io_push_valid = 1'b1;
    end
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_push_valid = SubModule_RaddrFifo0_io_pop_fire;
    end
  end

  always @(*) begin
    RaddrFifo0_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_pop_ready = Img2ColOutput_Module_Ready_Receive_Addr;
    end
  end

  always @(*) begin
    RaddrFifo0_io_push_payload = RaddrFifo0_io_pop_payload;
    if(when_Data_Generate_V2_l193) begin
      RaddrFifo0_io_push_payload = Raddr_Initialization;
    end
    if(when_Data_Generate_V2_l245) begin
      RaddrFifo0_io_push_payload = RaddrFifo0_io_pop_payload;
    end
  end

  assign when_Data_Generate_V2_l193 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign when_Data_Generate_V2_l197 = ((Fsm_currentState & IMG2COL_ENUM_INIT_ADDR) != 7'b0000000);
  assign sData_fire = (sData_valid && sData_ready);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == _zz_In_Col_Cnt_valid) && sData_fire);
  assign Row_Cache_Cnt_valid = ((Row_Cache_Cnt_count == _zz_Row_Cache_Cnt_valid) && In_Col_Cnt_valid);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == _zz_In_Row_Cnt_valid) && In_Col_Cnt_valid);
  assign when_Data_Generate_V2_l217 = (_zz_when_Data_Generate_V2_l217 < In_Row_Cnt_count);
  always @(*) begin
    if(when_Data_Generate_V2_l217) begin
      Cache_Row_Num = Stride;
    end else begin
      Cache_Row_Num = Kernel_Size;
    end
  end

  always @(*) begin
    if(when_Data_Generate_V2_l217) begin
      Raddr_Updata_Cnt_Num = Stride;
    end else begin
      Raddr_Updata_Cnt_Num = Kernel_Size;
    end
  end

  assign Fsm_Data_Cached = Row_Cache_Cnt_valid;
  assign when_Data_Generate_V2_l228 = ((Fsm_currentState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign Fsm_Cache_End = CacheEnd_Flag;
  assign sData_ready = ((Fsm_currentState & IMG2COL_ENUM_DATA_CACHE) != 7'b0000000);
  assign when_Data_Generate_V2_l245 = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign SubModule_RaddrFifo0_io_pop_fire = (RaddrFifo0_io_pop_valid && RaddrFifo0_io_pop_ready);
  assign Img2Col_SubModule_start = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign Fsm_SA_Ready = Img2Col_SubModule_SA_Idle;
  assign Img2ColOutput_Module_Ready_Receive_Addr = Img2Col_SubModule_NewAddrIn_ready;
  assign Img2Col_SubModule_NewAddrIn_valid = ((Fsm_currentState & IMG2COL_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign SA_Row_Cnt_Valid = Img2Col_SubModule_SA_Row_Cnt_Valid;
  assign LayerEnd = Fsm_Layer_End;
  assign Fsm_Addr_Updated = Img2Col_SubModule_AddrReceived;
  assign Out_Row_Cnt_valid = ((Out_Row_Cnt_count == _zz_Out_Row_Cnt_valid) && Img2Col_SubModule_SA_End);
  assign Fsm_Layer_End = Out_Row_Cnt_valid;
  assign Waddr = (WaddrOffset + In_Col_Cnt_count);
  assign DGB_addra = Waddr[13:0];
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign DGB_addrb = Img2Col_SubModule_Raddr[13:0];
  assign mData = DGB_doutb;
  assign mValid = SubModule_Img2Col_SubModule_Raddr_Valid_regNext;
  assign mLast = Out_Row_Cnt_valid_regNext;
  assign Test_Valid = (_zz_Test_Valid == Out_Row_Cnt_count_regNext);
  assign Test_Signal = Test_Valid;
  assign Test_End = ((! Test_Valid) && Test_Valid_regNext);
  assign AddrFifo_io_flush = ((Fsm_nextState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign RaddrFifo0_io_flush = ((Fsm_nextState & IMG2COL_ENUM_IDLE) != 7'b0000000);
  assign Raddr_Valid = Img2Col_SubModule_Raddr_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    SubModule_Img2Col_SubModule_Raddr_Valid_regNext <= Img2Col_SubModule_Raddr_Valid;
    Out_Row_Cnt_valid_regNext <= Out_Row_Cnt_valid;
    Out_Row_Cnt_count_regNext <= Out_Row_Cnt_count;
    Test_Valid_regNext <= Test_Valid;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= IMG2COL_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Addr_Init_Cnt_count <= 5'h0;
      WaddrOffset <= 16'h0;
      Raddr_Initialization <= 16'h0;
      In_Col_Cnt_count <= 16'h0;
      Row_Cache_Cnt_count <= 5'h0;
      In_Row_Cnt_count <= 16'h0;
      CacheEnd_Flag <= 1'b0;
      Out_Row_Cnt_count <= 16'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l39) begin
        if(Addr_Init_Cnt_valid) begin
          Addr_Init_Cnt_count <= 5'h0;
        end else begin
          Addr_Init_Cnt_count <= (Addr_Init_Cnt_count + 5'h01);
        end
      end
      if(when_Data_Generate_V2_l175) begin
        WaddrOffset <= 16'h0;
      end else begin
        if(SubModule_AddrFifo_io_pop_fire) begin
          WaddrOffset <= AddrFifo_io_pop_payload;
        end else begin
          if(when_Data_Generate_V2_l179) begin
            WaddrOffset <= (WaddrOffset + InCol_Count_Times);
          end
        end
      end
      if(when_Data_Generate_V2_l197) begin
        Raddr_Initialization <= (Raddr_Initialization + InCol_Count_Times);
      end else begin
        Raddr_Initialization <= 16'h0;
      end
      if(sData_fire) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= 16'h0;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count + 16'h0001);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(Row_Cache_Cnt_valid) begin
          Row_Cache_Cnt_count <= 5'h0;
        end else begin
          Row_Cache_Cnt_count <= (Row_Cache_Cnt_count + 5'h01);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 16'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 16'h0001);
        end
      end
      if(In_Row_Cnt_valid) begin
        CacheEnd_Flag <= 1'b1;
      end else begin
        if(when_Data_Generate_V2_l228) begin
          CacheEnd_Flag <= 1'b0;
        end
      end
      if(Img2Col_SubModule_SA_End) begin
        if(Out_Row_Cnt_valid) begin
          Out_Row_Cnt_count <= 16'h0;
        end else begin
          Out_Row_Cnt_count <= (Out_Row_Cnt_count + 16'h0001);
        end
      end
    end
  end


endmodule

module Weight_Cache (
  input               start,
  input               sData_valid,
  output              sData_ready,
  input      [63:0]   sData_payload,
  input      [15:0]   Matrix_Row,
  input      [15:0]   Matrix_Col,
  output reg [63:0]   mData,
  input               Raddr_Valid,
  output              Weight_Cached,
  input               LayerEnd,
  output     [7:0]    MatrixCol_Switch,
  input               clk,
  input               reset
);
  localparam WEIGHT_CACHE_STATUS_IDLE = 4'd1;
  localparam WEIGHT_CACHE_STATUS_INIT = 4'd2;
  localparam WEIGHT_CACHE_STATUS_CACHE_WEIGHT = 4'd4;
  localparam WEIGHT_CACHE_STATUS_SA_COMPUTE = 4'd8;

  wire       [10:0]   xil_SimpleDualBram_addra;
  wire                xil_SimpleDualBram_ena;
  wire       [13:0]   xil_SimpleDualBram_addrb;
  wire       [10:0]   xil_SimpleDualBram_1_addra;
  wire                xil_SimpleDualBram_1_ena;
  wire       [13:0]   xil_SimpleDualBram_1_addrb;
  wire       [10:0]   xil_SimpleDualBram_2_addra;
  wire                xil_SimpleDualBram_2_ena;
  wire       [13:0]   xil_SimpleDualBram_2_addrb;
  wire       [10:0]   xil_SimpleDualBram_3_addra;
  wire                xil_SimpleDualBram_3_ena;
  wire       [13:0]   xil_SimpleDualBram_3_addrb;
  wire       [10:0]   xil_SimpleDualBram_4_addra;
  wire                xil_SimpleDualBram_4_ena;
  wire       [13:0]   xil_SimpleDualBram_4_addrb;
  wire       [10:0]   xil_SimpleDualBram_5_addra;
  wire                xil_SimpleDualBram_5_ena;
  wire       [13:0]   xil_SimpleDualBram_5_addrb;
  wire       [10:0]   xil_SimpleDualBram_6_addra;
  wire                xil_SimpleDualBram_6_ena;
  wire       [13:0]   xil_SimpleDualBram_6_addrb;
  wire       [10:0]   xil_SimpleDualBram_7_addra;
  wire                xil_SimpleDualBram_7_ena;
  wire       [13:0]   xil_SimpleDualBram_7_addrb;
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
  wire       [15:0]   _zz_OutCol_Cnt_valid;
  wire       [15:0]   _zz_OutCol_Cnt_count_1;
  wire       [15:0]   _zz_Write_Row_Base_Addr;
  wire       [15:0]   _zz_addra;
  wire       [15:0]   _zz_addrb;
  wire       [0:0]    _zz_ena;
  wire       [15:0]   _zz_addra_1;
  wire       [15:0]   _zz_addrb_1;
  wire       [0:0]    _zz_ena_1;
  wire       [15:0]   _zz_addra_2;
  wire       [15:0]   _zz_addrb_2;
  wire       [0:0]    _zz_ena_2;
  wire       [15:0]   _zz_addra_3;
  wire       [15:0]   _zz_addrb_3;
  wire       [0:0]    _zz_ena_3;
  wire       [15:0]   _zz_addra_4;
  wire       [15:0]   _zz_addrb_4;
  wire       [0:0]    _zz_ena_4;
  wire       [15:0]   _zz_addra_5;
  wire       [15:0]   _zz_addrb_5;
  wire       [0:0]    _zz_ena_5;
  wire       [15:0]   _zz_addra_6;
  wire       [15:0]   _zz_addrb_6;
  wire       [0:0]    _zz_ena_6;
  wire       [15:0]   _zz_addra_7;
  wire       [15:0]   _zz_addrb_7;
  wire       [0:0]    _zz_ena_7;
  reg                 start_regNext;
  wire                when_Weight_CacheV1_l33;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Weight_All_Cached;
  wire                Fsm_SA_Computed;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  reg        [7:0]    InData_Switch;
  wire       [12:0]   Matrix_In_MaxCnt;
  wire                sData_fire;
  reg        [15:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;
  reg        [15:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [15:0]   Read_Row_Base_Addr;
  reg        [15:0]   Write_Row_Base_Addr;
  wire                when_WaCounter_l39;
  reg        [15:0]   OutRow_Cnt_count;
  wire                OutRow_Cnt_valid;
  wire       [3:0]    _zz_OutCol_Cnt_count;
  reg        [15:0]   OutCol_Cnt_count;
  reg                 OutCol_Cnt_valid;
  reg        [2:0]    Col_In_8_Cnt_count;
  wire                Col_In_8_Cnt_valid;
  wire                when_Weight_CacheV1_l124;
  wire                when_Weight_CacheV1_l129;
  wire                sData_fire_1;
  wire                sData_fire_2;
  wire                sData_fire_3;
  wire                sData_fire_4;
  wire                sData_fire_5;
  wire                sData_fire_6;
  wire                sData_fire_7;
  wire                sData_fire_8;
  reg        [7:0]    MatrixCol_Switch_1;
  reg        [7:0]    MatrixCol_Switch_1_regNext;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_In_Row_Cnt_valid_1 = (Matrix_In_MaxCnt - 13'h0001);
  assign _zz_In_Row_Cnt_valid = {3'd0, _zz_In_Row_Cnt_valid_1};
  assign _zz_In_Col_Cnt_valid = (Matrix_Col - 16'h0001);
  assign _zz_OutRow_Cnt_valid = (Matrix_Row - 16'h0001);
  assign _zz_OutCol_Cnt_valid = {12'd0, _zz_OutCol_Cnt_count};
  assign _zz_OutCol_Cnt_count_1 = {12'd0, _zz_OutCol_Cnt_count};
  assign _zz_Write_Row_Base_Addr = {3'd0, Matrix_In_MaxCnt};
  assign _zz_addra = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena = InData_Switch[0 : 0];
  assign _zz_addra_1 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_1 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_1 = InData_Switch[1 : 1];
  assign _zz_addra_2 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_2 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_2 = InData_Switch[2 : 2];
  assign _zz_addra_3 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_3 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_3 = InData_Switch[3 : 3];
  assign _zz_addra_4 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_4 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_4 = InData_Switch[4 : 4];
  assign _zz_addra_5 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_5 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_5 = InData_Switch[5 : 5];
  assign _zz_addra_6 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_6 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_6 = InData_Switch[6 : 6];
  assign _zz_addra_7 = (In_Row_Cnt_count + Write_Row_Base_Addr);
  assign _zz_addrb_7 = (Read_Row_Base_Addr + OutRow_Cnt_count);
  assign _zz_ena_7 = InData_Switch[7 : 7];
  Weight_Bram xil_SimpleDualBram (
    .clka  (clk                           ), //i
    .addra (xil_SimpleDualBram_addra[10:0]), //i
    .dina  (sData_payload[63:0]           ), //i
    .ena   (xil_SimpleDualBram_ena        ), //i
    .wea   (1'b1                          ), //i
    .addrb (xil_SimpleDualBram_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_doutb[7:0] ), //o
    .clkb  (clk                           )  //i
  );
  Weight_Bram xil_SimpleDualBram_1 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_1_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_1_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_1_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_1_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_2 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_2_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_2_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_2_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_2_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_3 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_3_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_3_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_3_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_3_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_4 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_4_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_4_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_4_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_4_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_5 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_5_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_5_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_5_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_5_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_6 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_6_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_6_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_6_addrb[13:0]), //i
    .doutb (xil_SimpleDualBram_6_doutb[7:0] ), //o
    .clkb  (clk                             )  //i
  );
  Weight_Bram xil_SimpleDualBram_7 (
    .clka  (clk                             ), //i
    .addra (xil_SimpleDualBram_7_addra[10:0]), //i
    .dina  (sData_payload[63:0]             ), //i
    .ena   (xil_SimpleDualBram_7_ena        ), //i
    .wea   (1'b1                            ), //i
    .addrb (xil_SimpleDualBram_7_addrb[13:0]), //i
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

  assign when_Weight_CacheV1_l33 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & WEIGHT_CACHE_STATUS_IDLE) == WEIGHT_CACHE_STATUS_IDLE) : begin
        if(when_Weight_CacheV1_l33) begin
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

  assign when_WaCounter_l19 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
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
  assign when_WaCounter_l39 = (Raddr_Valid && ((Fsm_currentState & WEIGHT_CACHE_STATUS_SA_COMPUTE) != 4'b0000));
  assign OutRow_Cnt_valid = ((OutRow_Cnt_count == _zz_OutRow_Cnt_valid) && when_WaCounter_l39);
  assign _zz_OutCol_Cnt_count = 4'b1000;
  always @(*) begin
    OutCol_Cnt_valid = ((OutCol_Cnt_count <= _zz_OutCol_Cnt_valid) && OutRow_Cnt_valid);
    if(start) begin
      OutCol_Cnt_valid = 1'b0;
    end
  end

  assign Col_In_8_Cnt_valid = ((Col_In_8_Cnt_count == 3'b111) && In_Row_Cnt_valid);
  assign when_Weight_CacheV1_l124 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign when_Weight_CacheV1_l129 = ((Fsm_currentState & WEIGHT_CACHE_STATUS_INIT) != 4'b0000);
  assign Fsm_Weight_All_Cached = In_Col_Cnt_valid;
  assign Weight_Cached = In_Col_Cnt_valid;
  assign xil_SimpleDualBram_addra = _zz_addra[10:0];
  assign xil_SimpleDualBram_addrb = _zz_addrb[13:0];
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_ena = (_zz_ena[0] && sData_fire_1);
  always @(*) begin
    mData[7 : 0] = xil_SimpleDualBram_doutb;
    mData[15 : 8] = xil_SimpleDualBram_1_doutb;
    mData[23 : 16] = xil_SimpleDualBram_2_doutb;
    mData[31 : 24] = xil_SimpleDualBram_3_doutb;
    mData[39 : 32] = xil_SimpleDualBram_4_doutb;
    mData[47 : 40] = xil_SimpleDualBram_5_doutb;
    mData[55 : 48] = xil_SimpleDualBram_6_doutb;
    mData[63 : 56] = xil_SimpleDualBram_7_doutb;
  end

  assign xil_SimpleDualBram_1_addra = _zz_addra_1[10:0];
  assign xil_SimpleDualBram_1_addrb = _zz_addrb_1[13:0];
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_1_ena = (_zz_ena_1[0] && sData_fire_2);
  assign xil_SimpleDualBram_2_addra = _zz_addra_2[10:0];
  assign xil_SimpleDualBram_2_addrb = _zz_addrb_2[13:0];
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_2_ena = (_zz_ena_2[0] && sData_fire_3);
  assign xil_SimpleDualBram_3_addra = _zz_addra_3[10:0];
  assign xil_SimpleDualBram_3_addrb = _zz_addrb_3[13:0];
  assign sData_fire_4 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_3_ena = (_zz_ena_3[0] && sData_fire_4);
  assign xil_SimpleDualBram_4_addra = _zz_addra_4[10:0];
  assign xil_SimpleDualBram_4_addrb = _zz_addrb_4[13:0];
  assign sData_fire_5 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_4_ena = (_zz_ena_4[0] && sData_fire_5);
  assign xil_SimpleDualBram_5_addra = _zz_addra_5[10:0];
  assign xil_SimpleDualBram_5_addrb = _zz_addrb_5[13:0];
  assign sData_fire_6 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_5_ena = (_zz_ena_5[0] && sData_fire_6);
  assign xil_SimpleDualBram_6_addra = _zz_addra_6[10:0];
  assign xil_SimpleDualBram_6_addrb = _zz_addrb_6[13:0];
  assign sData_fire_7 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_6_ena = (_zz_ena_6[0] && sData_fire_7);
  assign xil_SimpleDualBram_7_addra = _zz_addra_7[10:0];
  assign xil_SimpleDualBram_7_addrb = _zz_addrb_7[13:0];
  assign sData_fire_8 = (sData_valid && sData_ready);
  assign xil_SimpleDualBram_7_ena = (_zz_ena_7[0] && sData_fire_8);
  assign sData_ready = ((Fsm_currentState & WEIGHT_CACHE_STATUS_CACHE_WEIGHT) != 4'b0000);
  assign Fsm_SA_Computed = LayerEnd;
  always @(*) begin
    case(OutCol_Cnt_count)
      16'h0001 : begin
        MatrixCol_Switch_1[0 : 0] = 1'b1;
        MatrixCol_Switch_1[7 : 1] = 7'h0;
      end
      16'h0002 : begin
        MatrixCol_Switch_1[1 : 0] = 2'b11;
        MatrixCol_Switch_1[7 : 2] = 6'h0;
      end
      16'h0003 : begin
        MatrixCol_Switch_1[2 : 0] = 3'b111;
        MatrixCol_Switch_1[7 : 3] = 5'h0;
      end
      16'h0004 : begin
        MatrixCol_Switch_1[3 : 0] = 4'b1111;
        MatrixCol_Switch_1[7 : 4] = 4'b0000;
      end
      16'h0005 : begin
        MatrixCol_Switch_1[4 : 0] = 5'h1f;
        MatrixCol_Switch_1[7 : 5] = 3'b000;
      end
      16'h0006 : begin
        MatrixCol_Switch_1[5 : 0] = 6'h3f;
        MatrixCol_Switch_1[7 : 6] = 2'b00;
      end
      16'h0007 : begin
        MatrixCol_Switch_1[6 : 0] = 7'h7f;
        MatrixCol_Switch_1[7 : 7] = 1'b0;
      end
      default : begin
        MatrixCol_Switch_1 = 8'hff;
      end
    endcase
  end

  assign MatrixCol_Switch = MatrixCol_Switch_1_regNext;
  always @(posedge clk) begin
    start_regNext <= start;
    MatrixCol_Switch_1_regNext <= MatrixCol_Switch_1;
  end

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
      OutCol_Cnt_count <= Matrix_Col;
      Col_In_8_Cnt_count <= 3'b000;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
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
      if(when_WaCounter_l39) begin
        if(OutRow_Cnt_valid) begin
          OutRow_Cnt_count <= 16'h0;
        end else begin
          OutRow_Cnt_count <= (OutRow_Cnt_count + 16'h0001);
        end
      end
      if(OutRow_Cnt_valid) begin
        if(OutCol_Cnt_valid) begin
          OutCol_Cnt_count <= Matrix_Col;
        end else begin
          OutCol_Cnt_count <= (OutCol_Cnt_count - _zz_OutCol_Cnt_count_1);
        end
      end
      if(start) begin
        OutCol_Cnt_count <= Matrix_Col;
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
      if(when_Weight_CacheV1_l124) begin
        InData_Switch <= 8'h01;
      end else begin
        if(In_Row_Cnt_valid) begin
          InData_Switch <= {InData_Switch[6 : 0],InData_Switch[7 : 7]};
        end
      end
      if(when_Weight_CacheV1_l129) begin
        Write_Row_Base_Addr <= 16'h0;
      end else begin
        if(Col_In_8_Cnt_valid) begin
          Write_Row_Base_Addr <= (Write_Row_Base_Addr + _zz_Write_Row_Base_Addr);
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
  output     [31:0]   PE_OUT_0,
  output     [31:0]   PE_OUT_1,
  output     [31:0]   PE_OUT_2,
  output     [31:0]   PE_OUT_3,
  output     [31:0]   PE_OUT_4,
  output     [31:0]   PE_OUT_5,
  output     [31:0]   PE_OUT_6,
  output     [31:0]   PE_OUT_7,
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
  wire       [31:0]   pE_64_PE_OUT;
  wire                pE_64_finish;
  wire       [7:0]    left_acount;
  wire       [7:0]    left_bcount;
  wire       [31:0]   left_PE_OUT;
  wire                left_finish;
  wire       [7:0]    left_1_acount;
  wire       [7:0]    left_1_bcount;
  wire       [31:0]   left_1_PE_OUT;
  wire                left_1_finish;
  wire       [7:0]    left_2_acount;
  wire       [7:0]    left_2_bcount;
  wire       [31:0]   left_2_PE_OUT;
  wire                left_2_finish;
  wire       [7:0]    left_3_acount;
  wire       [7:0]    left_3_bcount;
  wire       [31:0]   left_3_PE_OUT;
  wire                left_3_finish;
  wire       [7:0]    left_4_acount;
  wire       [7:0]    left_4_bcount;
  wire       [31:0]   left_4_PE_OUT;
  wire                left_4_finish;
  wire       [7:0]    left_5_acount;
  wire       [7:0]    left_5_bcount;
  wire       [31:0]   left_5_PE_OUT;
  wire                left_5_finish;
  wire       [7:0]    left_6_acount;
  wire       [7:0]    left_6_bcount;
  wire       [31:0]   left_6_PE_OUT;
  wire                left_6_finish;
  wire       [7:0]    top_acount;
  wire       [7:0]    top_bcount;
  wire       [31:0]   top_PE_OUT;
  wire                top_finish;
  wire       [7:0]    top_1_acount;
  wire       [7:0]    top_1_bcount;
  wire       [31:0]   top_1_PE_OUT;
  wire                top_1_finish;
  wire       [7:0]    top_2_acount;
  wire       [7:0]    top_2_bcount;
  wire       [31:0]   top_2_PE_OUT;
  wire                top_2_finish;
  wire       [7:0]    top_3_acount;
  wire       [7:0]    top_3_bcount;
  wire       [31:0]   top_3_PE_OUT;
  wire                top_3_finish;
  wire       [7:0]    top_4_acount;
  wire       [7:0]    top_4_bcount;
  wire       [31:0]   top_4_PE_OUT;
  wire                top_4_finish;
  wire       [7:0]    top_5_acount;
  wire       [7:0]    top_5_bcount;
  wire       [31:0]   top_5_PE_OUT;
  wire                top_5_finish;
  wire       [7:0]    top_6_acount;
  wire       [7:0]    top_6_bcount;
  wire       [31:0]   top_6_PE_OUT;
  wire                top_6_finish;
  wire       [7:0]    mid_acount;
  wire       [7:0]    mid_bcount;
  wire       [31:0]   mid_PE_OUT;
  wire                mid_finish;
  wire       [7:0]    mid_1_acount;
  wire       [7:0]    mid_1_bcount;
  wire       [31:0]   mid_1_PE_OUT;
  wire                mid_1_finish;
  wire       [7:0]    mid_2_acount;
  wire       [7:0]    mid_2_bcount;
  wire       [31:0]   mid_2_PE_OUT;
  wire                mid_2_finish;
  wire       [7:0]    mid_3_acount;
  wire       [7:0]    mid_3_bcount;
  wire       [31:0]   mid_3_PE_OUT;
  wire                mid_3_finish;
  wire       [7:0]    mid_4_acount;
  wire       [7:0]    mid_4_bcount;
  wire       [31:0]   mid_4_PE_OUT;
  wire                mid_4_finish;
  wire       [7:0]    mid_5_acount;
  wire       [7:0]    mid_5_bcount;
  wire       [31:0]   mid_5_PE_OUT;
  wire                mid_5_finish;
  wire       [7:0]    mid_6_acount;
  wire       [7:0]    mid_6_bcount;
  wire       [31:0]   mid_6_PE_OUT;
  wire                mid_6_finish;
  wire       [7:0]    mid_7_acount;
  wire       [7:0]    mid_7_bcount;
  wire       [31:0]   mid_7_PE_OUT;
  wire                mid_7_finish;
  wire       [7:0]    mid_8_acount;
  wire       [7:0]    mid_8_bcount;
  wire       [31:0]   mid_8_PE_OUT;
  wire                mid_8_finish;
  wire       [7:0]    mid_9_acount;
  wire       [7:0]    mid_9_bcount;
  wire       [31:0]   mid_9_PE_OUT;
  wire                mid_9_finish;
  wire       [7:0]    mid_10_acount;
  wire       [7:0]    mid_10_bcount;
  wire       [31:0]   mid_10_PE_OUT;
  wire                mid_10_finish;
  wire       [7:0]    mid_11_acount;
  wire       [7:0]    mid_11_bcount;
  wire       [31:0]   mid_11_PE_OUT;
  wire                mid_11_finish;
  wire       [7:0]    mid_12_acount;
  wire       [7:0]    mid_12_bcount;
  wire       [31:0]   mid_12_PE_OUT;
  wire                mid_12_finish;
  wire       [7:0]    mid_13_acount;
  wire       [7:0]    mid_13_bcount;
  wire       [31:0]   mid_13_PE_OUT;
  wire                mid_13_finish;
  wire       [7:0]    mid_14_acount;
  wire       [7:0]    mid_14_bcount;
  wire       [31:0]   mid_14_PE_OUT;
  wire                mid_14_finish;
  wire       [7:0]    mid_15_acount;
  wire       [7:0]    mid_15_bcount;
  wire       [31:0]   mid_15_PE_OUT;
  wire                mid_15_finish;
  wire       [7:0]    mid_16_acount;
  wire       [7:0]    mid_16_bcount;
  wire       [31:0]   mid_16_PE_OUT;
  wire                mid_16_finish;
  wire       [7:0]    mid_17_acount;
  wire       [7:0]    mid_17_bcount;
  wire       [31:0]   mid_17_PE_OUT;
  wire                mid_17_finish;
  wire       [7:0]    mid_18_acount;
  wire       [7:0]    mid_18_bcount;
  wire       [31:0]   mid_18_PE_OUT;
  wire                mid_18_finish;
  wire       [7:0]    mid_19_acount;
  wire       [7:0]    mid_19_bcount;
  wire       [31:0]   mid_19_PE_OUT;
  wire                mid_19_finish;
  wire       [7:0]    mid_20_acount;
  wire       [7:0]    mid_20_bcount;
  wire       [31:0]   mid_20_PE_OUT;
  wire                mid_20_finish;
  wire       [7:0]    mid_21_acount;
  wire       [7:0]    mid_21_bcount;
  wire       [31:0]   mid_21_PE_OUT;
  wire                mid_21_finish;
  wire       [7:0]    mid_22_acount;
  wire       [7:0]    mid_22_bcount;
  wire       [31:0]   mid_22_PE_OUT;
  wire                mid_22_finish;
  wire       [7:0]    mid_23_acount;
  wire       [7:0]    mid_23_bcount;
  wire       [31:0]   mid_23_PE_OUT;
  wire                mid_23_finish;
  wire       [7:0]    mid_24_acount;
  wire       [7:0]    mid_24_bcount;
  wire       [31:0]   mid_24_PE_OUT;
  wire                mid_24_finish;
  wire       [7:0]    mid_25_acount;
  wire       [7:0]    mid_25_bcount;
  wire       [31:0]   mid_25_PE_OUT;
  wire                mid_25_finish;
  wire       [7:0]    mid_26_acount;
  wire       [7:0]    mid_26_bcount;
  wire       [31:0]   mid_26_PE_OUT;
  wire                mid_26_finish;
  wire       [7:0]    mid_27_acount;
  wire       [7:0]    mid_27_bcount;
  wire       [31:0]   mid_27_PE_OUT;
  wire                mid_27_finish;
  wire       [7:0]    mid_28_acount;
  wire       [7:0]    mid_28_bcount;
  wire       [31:0]   mid_28_PE_OUT;
  wire                mid_28_finish;
  wire       [7:0]    mid_29_acount;
  wire       [7:0]    mid_29_bcount;
  wire       [31:0]   mid_29_PE_OUT;
  wire                mid_29_finish;
  wire       [7:0]    mid_30_acount;
  wire       [7:0]    mid_30_bcount;
  wire       [31:0]   mid_30_PE_OUT;
  wire                mid_30_finish;
  wire       [7:0]    mid_31_acount;
  wire       [7:0]    mid_31_bcount;
  wire       [31:0]   mid_31_PE_OUT;
  wire                mid_31_finish;
  wire       [7:0]    mid_32_acount;
  wire       [7:0]    mid_32_bcount;
  wire       [31:0]   mid_32_PE_OUT;
  wire                mid_32_finish;
  wire       [7:0]    mid_33_acount;
  wire       [7:0]    mid_33_bcount;
  wire       [31:0]   mid_33_PE_OUT;
  wire                mid_33_finish;
  wire       [7:0]    mid_34_acount;
  wire       [7:0]    mid_34_bcount;
  wire       [31:0]   mid_34_PE_OUT;
  wire                mid_34_finish;
  wire       [7:0]    mid_35_acount;
  wire       [7:0]    mid_35_bcount;
  wire       [31:0]   mid_35_PE_OUT;
  wire                mid_35_finish;
  wire       [7:0]    mid_36_acount;
  wire       [7:0]    mid_36_bcount;
  wire       [31:0]   mid_36_PE_OUT;
  wire                mid_36_finish;
  wire       [7:0]    mid_37_acount;
  wire       [7:0]    mid_37_bcount;
  wire       [31:0]   mid_37_PE_OUT;
  wire                mid_37_finish;
  wire       [7:0]    mid_38_acount;
  wire       [7:0]    mid_38_bcount;
  wire       [31:0]   mid_38_PE_OUT;
  wire                mid_38_finish;
  wire       [7:0]    mid_39_acount;
  wire       [7:0]    mid_39_bcount;
  wire       [31:0]   mid_39_PE_OUT;
  wire                mid_39_finish;
  wire       [7:0]    mid_40_acount;
  wire       [7:0]    mid_40_bcount;
  wire       [31:0]   mid_40_PE_OUT;
  wire                mid_40_finish;
  wire       [7:0]    mid_41_acount;
  wire       [7:0]    mid_41_bcount;
  wire       [31:0]   mid_41_PE_OUT;
  wire                mid_41_finish;
  wire       [7:0]    mid_42_acount;
  wire       [7:0]    mid_42_bcount;
  wire       [31:0]   mid_42_PE_OUT;
  wire                mid_42_finish;
  wire       [7:0]    mid_43_acount;
  wire       [7:0]    mid_43_bcount;
  wire       [31:0]   mid_43_PE_OUT;
  wire                mid_43_finish;
  wire       [7:0]    mid_44_acount;
  wire       [7:0]    mid_44_bcount;
  wire       [31:0]   mid_44_PE_OUT;
  wire                mid_44_finish;
  wire       [7:0]    mid_45_acount;
  wire       [7:0]    mid_45_bcount;
  wire       [31:0]   mid_45_PE_OUT;
  wire                mid_45_finish;
  wire       [7:0]    mid_46_acount;
  wire       [7:0]    mid_46_bcount;
  wire       [31:0]   mid_46_PE_OUT;
  wire                mid_46_finish;
  wire       [7:0]    mid_47_acount;
  wire       [7:0]    mid_47_bcount;
  wire       [31:0]   mid_47_PE_OUT;
  wire                mid_47_finish;
  wire       [7:0]    mid_48_acount;
  wire       [7:0]    mid_48_bcount;
  wire       [31:0]   mid_48_PE_OUT;
  wire                mid_48_finish;
  reg        [31:0]   PE_OUT_0_1;
  reg        [31:0]   PE_OUT_1_1;
  reg        [31:0]   PE_OUT_2_1;
  reg        [31:0]   PE_OUT_3_1;
  reg        [31:0]   PE_OUT_4_1;
  reg        [31:0]   PE_OUT_5_1;
  reg        [31:0]   PE_OUT_6_1;
  reg        [31:0]   PE_OUT_7_1;
  reg                 resultVaild_0_1;
  reg                 resultVaild_1_1;
  reg                 resultVaild_2_1;
  reg                 resultVaild_3_1;
  reg                 resultVaild_4_1;
  reg                 resultVaild_5_1;
  reg                 resultVaild_6_1;
  reg                 resultVaild_7_1;
  reg        [31:0]   PE_OUT_0_1_delay_1;
  reg        [31:0]   PE_OUT_0_1_delay_2;
  reg        [31:0]   PE_OUT_0_1_delay_3;
  reg        [31:0]   PE_OUT_0_1_delay_4;
  reg        [31:0]   PE_OUT_0_1_delay_5;
  reg        [31:0]   PE_OUT_0_1_delay_6;
  reg        [31:0]   PE_OUT_0_1_delay_7;
  reg        [31:0]   PE_OUT_0_1_delay_8;
  reg                 resultVaild_0_1_delay_1;
  reg                 resultVaild_0_1_delay_2;
  reg                 resultVaild_0_1_delay_3;
  reg                 resultVaild_0_1_delay_4;
  reg                 resultVaild_0_1_delay_5;
  reg                 resultVaild_0_1_delay_6;
  reg                 resultVaild_0_1_delay_7;
  reg                 resultVaild_0_1_delay_8;
  reg        [31:0]   PE_OUT_1_1_delay_1;
  reg        [31:0]   PE_OUT_1_1_delay_2;
  reg        [31:0]   PE_OUT_1_1_delay_3;
  reg        [31:0]   PE_OUT_1_1_delay_4;
  reg        [31:0]   PE_OUT_1_1_delay_5;
  reg        [31:0]   PE_OUT_1_1_delay_6;
  reg        [31:0]   PE_OUT_1_1_delay_7;
  reg                 resultVaild_1_1_delay_1;
  reg                 resultVaild_1_1_delay_2;
  reg                 resultVaild_1_1_delay_3;
  reg                 resultVaild_1_1_delay_4;
  reg                 resultVaild_1_1_delay_5;
  reg                 resultVaild_1_1_delay_6;
  reg                 resultVaild_1_1_delay_7;
  reg        [31:0]   PE_OUT_2_1_delay_1;
  reg        [31:0]   PE_OUT_2_1_delay_2;
  reg        [31:0]   PE_OUT_2_1_delay_3;
  reg        [31:0]   PE_OUT_2_1_delay_4;
  reg        [31:0]   PE_OUT_2_1_delay_5;
  reg        [31:0]   PE_OUT_2_1_delay_6;
  reg                 resultVaild_2_1_delay_1;
  reg                 resultVaild_2_1_delay_2;
  reg                 resultVaild_2_1_delay_3;
  reg                 resultVaild_2_1_delay_4;
  reg                 resultVaild_2_1_delay_5;
  reg                 resultVaild_2_1_delay_6;
  reg        [31:0]   PE_OUT_3_1_delay_1;
  reg        [31:0]   PE_OUT_3_1_delay_2;
  reg        [31:0]   PE_OUT_3_1_delay_3;
  reg        [31:0]   PE_OUT_3_1_delay_4;
  reg        [31:0]   PE_OUT_3_1_delay_5;
  reg                 resultVaild_3_1_delay_1;
  reg                 resultVaild_3_1_delay_2;
  reg                 resultVaild_3_1_delay_3;
  reg                 resultVaild_3_1_delay_4;
  reg                 resultVaild_3_1_delay_5;
  reg        [31:0]   PE_OUT_4_1_delay_1;
  reg        [31:0]   PE_OUT_4_1_delay_2;
  reg        [31:0]   PE_OUT_4_1_delay_3;
  reg        [31:0]   PE_OUT_4_1_delay_4;
  reg                 resultVaild_4_1_delay_1;
  reg                 resultVaild_4_1_delay_2;
  reg                 resultVaild_4_1_delay_3;
  reg                 resultVaild_4_1_delay_4;
  reg        [31:0]   PE_OUT_5_1_delay_1;
  reg        [31:0]   PE_OUT_5_1_delay_2;
  reg        [31:0]   PE_OUT_5_1_delay_3;
  reg                 resultVaild_5_1_delay_1;
  reg                 resultVaild_5_1_delay_2;
  reg                 resultVaild_5_1_delay_3;
  reg        [31:0]   PE_OUT_6_1_delay_1;
  reg        [31:0]   PE_OUT_6_1_delay_2;
  reg                 resultVaild_6_1_delay_1;
  reg                 resultVaild_6_1_delay_2;
  reg        [31:0]   PE_OUT_7_1_delay_1;
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
  reg                 Tile_1_left_vaild_delay_1;
  reg                 Tile_1_top_vaild_delay_1;
  reg                 Tile_1_mid_vaild_delay_1;
  reg                 Tile_1_top_1_vaild_delay_1;
  reg                 Tile_1_mid_1_vaild_delay_1;
  reg                 Tile_1_top_2_vaild_delay_1;
  reg                 Tile_1_mid_2_vaild_delay_1;
  reg                 Tile_1_top_3_vaild_delay_1;
  reg                 Tile_1_mid_3_vaild_delay_1;
  reg                 Tile_1_top_4_vaild_delay_1;
  reg                 Tile_1_mid_4_vaild_delay_1;
  reg                 Tile_1_top_5_vaild_delay_1;
  reg                 Tile_1_mid_5_vaild_delay_1;
  reg                 Tile_1_top_6_vaild_delay_1;
  reg                 Tile_1_left_1_vaild_delay_1;
  reg                 Tile_1_mid_vaild_delay_1_1;
  reg                 Tile_1_mid_7_vaild_delay_1;
  reg                 Tile_1_mid_1_vaild_delay_1_1;
  reg                 Tile_1_mid_8_vaild_delay_1;
  reg                 Tile_1_mid_2_vaild_delay_1_1;
  reg                 Tile_1_mid_9_vaild_delay_1;
  reg                 Tile_1_mid_3_vaild_delay_1_1;
  reg                 Tile_1_mid_10_vaild_delay_1;
  reg                 Tile_1_mid_4_vaild_delay_1_1;
  reg                 Tile_1_mid_11_vaild_delay_1;
  reg                 Tile_1_mid_5_vaild_delay_1_1;
  reg                 Tile_1_mid_12_vaild_delay_1;
  reg                 Tile_1_mid_6_vaild_delay_1;
  reg                 Tile_1_left_2_vaild_delay_1;
  reg                 Tile_1_mid_7_vaild_delay_1_1;
  reg                 Tile_1_mid_14_vaild_delay_1;
  reg                 Tile_1_mid_8_vaild_delay_1_1;
  reg                 Tile_1_mid_15_vaild_delay_1;
  reg                 Tile_1_mid_9_vaild_delay_1_1;
  reg                 Tile_1_mid_16_vaild_delay_1;
  reg                 Tile_1_mid_10_vaild_delay_1_1;
  reg                 Tile_1_mid_17_vaild_delay_1;
  reg                 Tile_1_mid_11_vaild_delay_1_1;
  reg                 Tile_1_mid_18_vaild_delay_1;
  reg                 Tile_1_mid_12_vaild_delay_1_1;
  reg                 Tile_1_mid_19_vaild_delay_1;
  reg                 Tile_1_mid_13_vaild_delay_1;
  reg                 Tile_1_left_3_vaild_delay_1;
  reg                 Tile_1_mid_14_vaild_delay_1_1;
  reg                 Tile_1_mid_21_vaild_delay_1;
  reg                 Tile_1_mid_15_vaild_delay_1_1;
  reg                 Tile_1_mid_22_vaild_delay_1;
  reg                 Tile_1_mid_16_vaild_delay_1_1;
  reg                 Tile_1_mid_23_vaild_delay_1;
  reg                 Tile_1_mid_17_vaild_delay_1_1;
  reg                 Tile_1_mid_24_vaild_delay_1;
  reg                 Tile_1_mid_18_vaild_delay_1_1;
  reg                 Tile_1_mid_25_vaild_delay_1;
  reg                 Tile_1_mid_19_vaild_delay_1_1;
  reg                 Tile_1_mid_26_vaild_delay_1;
  reg                 Tile_1_mid_20_vaild_delay_1;
  reg                 Tile_1_left_4_vaild_delay_1;
  reg                 Tile_1_mid_21_vaild_delay_1_1;
  reg                 Tile_1_mid_28_vaild_delay_1;
  reg                 Tile_1_mid_22_vaild_delay_1_1;
  reg                 Tile_1_mid_29_vaild_delay_1;
  reg                 Tile_1_mid_23_vaild_delay_1_1;
  reg                 Tile_1_mid_30_vaild_delay_1;
  reg                 Tile_1_mid_24_vaild_delay_1_1;
  reg                 Tile_1_mid_31_vaild_delay_1;
  reg                 Tile_1_mid_25_vaild_delay_1_1;
  reg                 Tile_1_mid_32_vaild_delay_1;
  reg                 Tile_1_mid_26_vaild_delay_1_1;
  reg                 Tile_1_mid_33_vaild_delay_1;
  reg                 Tile_1_mid_27_vaild_delay_1;
  reg                 Tile_1_left_5_vaild_delay_1;
  reg                 Tile_1_mid_28_vaild_delay_1_1;
  reg                 Tile_1_mid_35_vaild_delay_1;
  reg                 Tile_1_mid_29_vaild_delay_1_1;
  reg                 Tile_1_mid_36_vaild_delay_1;
  reg                 Tile_1_mid_30_vaild_delay_1_1;
  reg                 Tile_1_mid_37_vaild_delay_1;
  reg                 Tile_1_mid_31_vaild_delay_1_1;
  reg                 Tile_1_mid_38_vaild_delay_1;
  reg                 Tile_1_mid_32_vaild_delay_1_1;
  reg                 Tile_1_mid_39_vaild_delay_1;
  reg                 Tile_1_mid_33_vaild_delay_1_1;
  reg                 Tile_1_mid_40_vaild_delay_1;
  reg                 Tile_1_mid_34_vaild_delay_1;
  reg                 Tile_1_left_6_vaild_delay_1;
  reg                 Tile_1_mid_35_vaild_delay_1_1;
  reg                 Tile_1_mid_42_vaild_delay_1;
  reg                 Tile_1_mid_36_vaild_delay_1_1;
  reg                 Tile_1_mid_43_vaild_delay_1;
  reg                 Tile_1_mid_37_vaild_delay_1_1;
  reg                 Tile_1_mid_44_vaild_delay_1;
  reg                 Tile_1_mid_38_vaild_delay_1_1;
  reg                 Tile_1_mid_45_vaild_delay_1;
  reg                 Tile_1_mid_39_vaild_delay_1_1;
  reg                 Tile_1_mid_46_vaild_delay_1;
  reg                 Tile_1_mid_40_vaild_delay_1_1;
  reg                 Tile_1_mid_47_vaild_delay_1;
  reg                 Tile_1_mid_41_vaild_delay_1;
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
    .PE_OUT    (pE_64_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_1_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_2_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_3_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_4_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_5_PE_OUT[31:0] ), //o
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
    .PE_OUT    (left_6_PE_OUT[31:0] ), //o
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
    .PE_OUT    (top_PE_OUT[31:0] ), //o
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
    .PE_OUT    (top_1_PE_OUT[31:0]), //o
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
    .PE_OUT    (top_2_PE_OUT[31:0]), //o
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
    .PE_OUT    (top_3_PE_OUT[31:0]), //o
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
    .PE_OUT    (top_4_PE_OUT[31:0]), //o
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
    .PE_OUT    (top_5_PE_OUT[31:0]), //o
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
    .PE_OUT    (top_6_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_1_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_2_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_3_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_4_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_5_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_6_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_7_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_8_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_9_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_10_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_11_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_12_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_13_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_14_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_15_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_16_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_17_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_18_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_19_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_20_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_21_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_22_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_23_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_24_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_25_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_26_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_27_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_28_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_29_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_30_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_31_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_32_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_33_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_34_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_35_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_36_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_37_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_38_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_39_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_40_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_41_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_42_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_43_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_44_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_45_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_46_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_47_PE_OUT[31:0]), //o
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
    .PE_OUT    (mid_48_PE_OUT[31:0]), //o
    .finish    (mid_48_finish      ), //o
    .clk       (clk                ), //i
    .reset     (reset              )  //i
  );
  always @(*) begin
    PE_OUT_0_1 = 32'h0;
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
    PE_OUT_1_1 = 32'h0;
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
    PE_OUT_2_1 = 32'h0;
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
    PE_OUT_3_1 = 32'h0;
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
    PE_OUT_4_1 = 32'h0;
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
    PE_OUT_5_1 = 32'h0;
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
    PE_OUT_6_1 = 32'h0;
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
    PE_OUT_7_1 = 32'h0;
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
  assign mid_vaild = (Tile_1_left_vaild_delay_1 && Tile_1_top_vaild_delay_1);
  assign mid_1_vaild = (Tile_1_mid_vaild_delay_1 && Tile_1_top_1_vaild_delay_1);
  assign mid_2_vaild = (Tile_1_mid_1_vaild_delay_1 && Tile_1_top_2_vaild_delay_1);
  assign mid_3_vaild = (Tile_1_mid_2_vaild_delay_1 && Tile_1_top_3_vaild_delay_1);
  assign mid_4_vaild = (Tile_1_mid_3_vaild_delay_1 && Tile_1_top_4_vaild_delay_1);
  assign mid_5_vaild = (Tile_1_mid_4_vaild_delay_1 && Tile_1_top_5_vaild_delay_1);
  assign mid_6_vaild = (Tile_1_mid_5_vaild_delay_1 && Tile_1_top_6_vaild_delay_1);
  assign mid_7_vaild = (Tile_1_left_1_vaild_delay_1 && Tile_1_mid_vaild_delay_1_1);
  assign mid_8_vaild = (Tile_1_mid_7_vaild_delay_1 && Tile_1_mid_1_vaild_delay_1_1);
  assign mid_9_vaild = (Tile_1_mid_8_vaild_delay_1 && Tile_1_mid_2_vaild_delay_1_1);
  assign mid_10_vaild = (Tile_1_mid_9_vaild_delay_1 && Tile_1_mid_3_vaild_delay_1_1);
  assign mid_11_vaild = (Tile_1_mid_10_vaild_delay_1 && Tile_1_mid_4_vaild_delay_1_1);
  assign mid_12_vaild = (Tile_1_mid_11_vaild_delay_1 && Tile_1_mid_5_vaild_delay_1_1);
  assign mid_13_vaild = (Tile_1_mid_12_vaild_delay_1 && Tile_1_mid_6_vaild_delay_1);
  assign mid_14_vaild = (Tile_1_left_2_vaild_delay_1 && Tile_1_mid_7_vaild_delay_1_1);
  assign mid_15_vaild = (Tile_1_mid_14_vaild_delay_1 && Tile_1_mid_8_vaild_delay_1_1);
  assign mid_16_vaild = (Tile_1_mid_15_vaild_delay_1 && Tile_1_mid_9_vaild_delay_1_1);
  assign mid_17_vaild = (Tile_1_mid_16_vaild_delay_1 && Tile_1_mid_10_vaild_delay_1_1);
  assign mid_18_vaild = (Tile_1_mid_17_vaild_delay_1 && Tile_1_mid_11_vaild_delay_1_1);
  assign mid_19_vaild = (Tile_1_mid_18_vaild_delay_1 && Tile_1_mid_12_vaild_delay_1_1);
  assign mid_20_vaild = (Tile_1_mid_19_vaild_delay_1 && Tile_1_mid_13_vaild_delay_1);
  assign mid_21_vaild = (Tile_1_left_3_vaild_delay_1 && Tile_1_mid_14_vaild_delay_1_1);
  assign mid_22_vaild = (Tile_1_mid_21_vaild_delay_1 && Tile_1_mid_15_vaild_delay_1_1);
  assign mid_23_vaild = (Tile_1_mid_22_vaild_delay_1 && Tile_1_mid_16_vaild_delay_1_1);
  assign mid_24_vaild = (Tile_1_mid_23_vaild_delay_1 && Tile_1_mid_17_vaild_delay_1_1);
  assign mid_25_vaild = (Tile_1_mid_24_vaild_delay_1 && Tile_1_mid_18_vaild_delay_1_1);
  assign mid_26_vaild = (Tile_1_mid_25_vaild_delay_1 && Tile_1_mid_19_vaild_delay_1_1);
  assign mid_27_vaild = (Tile_1_mid_26_vaild_delay_1 && Tile_1_mid_20_vaild_delay_1);
  assign mid_28_vaild = (Tile_1_left_4_vaild_delay_1 && Tile_1_mid_21_vaild_delay_1_1);
  assign mid_29_vaild = (Tile_1_mid_28_vaild_delay_1 && Tile_1_mid_22_vaild_delay_1_1);
  assign mid_30_vaild = (Tile_1_mid_29_vaild_delay_1 && Tile_1_mid_23_vaild_delay_1_1);
  assign mid_31_vaild = (Tile_1_mid_30_vaild_delay_1 && Tile_1_mid_24_vaild_delay_1_1);
  assign mid_32_vaild = (Tile_1_mid_31_vaild_delay_1 && Tile_1_mid_25_vaild_delay_1_1);
  assign mid_33_vaild = (Tile_1_mid_32_vaild_delay_1 && Tile_1_mid_26_vaild_delay_1_1);
  assign mid_34_vaild = (Tile_1_mid_33_vaild_delay_1 && Tile_1_mid_27_vaild_delay_1);
  assign mid_35_vaild = (Tile_1_left_5_vaild_delay_1 && Tile_1_mid_28_vaild_delay_1_1);
  assign mid_36_vaild = (Tile_1_mid_35_vaild_delay_1 && Tile_1_mid_29_vaild_delay_1_1);
  assign mid_37_vaild = (Tile_1_mid_36_vaild_delay_1 && Tile_1_mid_30_vaild_delay_1_1);
  assign mid_38_vaild = (Tile_1_mid_37_vaild_delay_1 && Tile_1_mid_31_vaild_delay_1_1);
  assign mid_39_vaild = (Tile_1_mid_38_vaild_delay_1 && Tile_1_mid_32_vaild_delay_1_1);
  assign mid_40_vaild = (Tile_1_mid_39_vaild_delay_1 && Tile_1_mid_33_vaild_delay_1_1);
  assign mid_41_vaild = (Tile_1_mid_40_vaild_delay_1 && Tile_1_mid_34_vaild_delay_1);
  assign mid_42_vaild = (Tile_1_left_6_vaild_delay_1 && Tile_1_mid_35_vaild_delay_1_1);
  assign mid_43_vaild = (Tile_1_mid_42_vaild_delay_1 && Tile_1_mid_36_vaild_delay_1_1);
  assign mid_44_vaild = (Tile_1_mid_43_vaild_delay_1 && Tile_1_mid_37_vaild_delay_1_1);
  assign mid_45_vaild = (Tile_1_mid_44_vaild_delay_1 && Tile_1_mid_38_vaild_delay_1_1);
  assign mid_46_vaild = (Tile_1_mid_45_vaild_delay_1 && Tile_1_mid_39_vaild_delay_1_1);
  assign mid_47_vaild = (Tile_1_mid_46_vaild_delay_1 && Tile_1_mid_40_vaild_delay_1_1);
  assign mid_48_vaild = (Tile_1_mid_47_vaild_delay_1 && Tile_1_mid_41_vaild_delay_1);
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
    Tile_1_left_vaild_delay_1 <= left_vaild;
    Tile_1_top_vaild_delay_1 <= top_vaild;
    Tile_1_mid_vaild_delay_1 <= mid_vaild;
    Tile_1_top_1_vaild_delay_1 <= top_1_vaild;
    Tile_1_mid_1_vaild_delay_1 <= mid_1_vaild;
    Tile_1_top_2_vaild_delay_1 <= top_2_vaild;
    Tile_1_mid_2_vaild_delay_1 <= mid_2_vaild;
    Tile_1_top_3_vaild_delay_1 <= top_3_vaild;
    Tile_1_mid_3_vaild_delay_1 <= mid_3_vaild;
    Tile_1_top_4_vaild_delay_1 <= top_4_vaild;
    Tile_1_mid_4_vaild_delay_1 <= mid_4_vaild;
    Tile_1_top_5_vaild_delay_1 <= top_5_vaild;
    Tile_1_mid_5_vaild_delay_1 <= mid_5_vaild;
    Tile_1_top_6_vaild_delay_1 <= top_6_vaild;
    Tile_1_left_1_vaild_delay_1 <= left_1_vaild;
    Tile_1_mid_vaild_delay_1_1 <= mid_vaild;
    Tile_1_mid_7_vaild_delay_1 <= mid_7_vaild;
    Tile_1_mid_1_vaild_delay_1_1 <= mid_1_vaild;
    Tile_1_mid_8_vaild_delay_1 <= mid_8_vaild;
    Tile_1_mid_2_vaild_delay_1_1 <= mid_2_vaild;
    Tile_1_mid_9_vaild_delay_1 <= mid_9_vaild;
    Tile_1_mid_3_vaild_delay_1_1 <= mid_3_vaild;
    Tile_1_mid_10_vaild_delay_1 <= mid_10_vaild;
    Tile_1_mid_4_vaild_delay_1_1 <= mid_4_vaild;
    Tile_1_mid_11_vaild_delay_1 <= mid_11_vaild;
    Tile_1_mid_5_vaild_delay_1_1 <= mid_5_vaild;
    Tile_1_mid_12_vaild_delay_1 <= mid_12_vaild;
    Tile_1_mid_6_vaild_delay_1 <= mid_6_vaild;
    Tile_1_left_2_vaild_delay_1 <= left_2_vaild;
    Tile_1_mid_7_vaild_delay_1_1 <= mid_7_vaild;
    Tile_1_mid_14_vaild_delay_1 <= mid_14_vaild;
    Tile_1_mid_8_vaild_delay_1_1 <= mid_8_vaild;
    Tile_1_mid_15_vaild_delay_1 <= mid_15_vaild;
    Tile_1_mid_9_vaild_delay_1_1 <= mid_9_vaild;
    Tile_1_mid_16_vaild_delay_1 <= mid_16_vaild;
    Tile_1_mid_10_vaild_delay_1_1 <= mid_10_vaild;
    Tile_1_mid_17_vaild_delay_1 <= mid_17_vaild;
    Tile_1_mid_11_vaild_delay_1_1 <= mid_11_vaild;
    Tile_1_mid_18_vaild_delay_1 <= mid_18_vaild;
    Tile_1_mid_12_vaild_delay_1_1 <= mid_12_vaild;
    Tile_1_mid_19_vaild_delay_1 <= mid_19_vaild;
    Tile_1_mid_13_vaild_delay_1 <= mid_13_vaild;
    Tile_1_left_3_vaild_delay_1 <= left_3_vaild;
    Tile_1_mid_14_vaild_delay_1_1 <= mid_14_vaild;
    Tile_1_mid_21_vaild_delay_1 <= mid_21_vaild;
    Tile_1_mid_15_vaild_delay_1_1 <= mid_15_vaild;
    Tile_1_mid_22_vaild_delay_1 <= mid_22_vaild;
    Tile_1_mid_16_vaild_delay_1_1 <= mid_16_vaild;
    Tile_1_mid_23_vaild_delay_1 <= mid_23_vaild;
    Tile_1_mid_17_vaild_delay_1_1 <= mid_17_vaild;
    Tile_1_mid_24_vaild_delay_1 <= mid_24_vaild;
    Tile_1_mid_18_vaild_delay_1_1 <= mid_18_vaild;
    Tile_1_mid_25_vaild_delay_1 <= mid_25_vaild;
    Tile_1_mid_19_vaild_delay_1_1 <= mid_19_vaild;
    Tile_1_mid_26_vaild_delay_1 <= mid_26_vaild;
    Tile_1_mid_20_vaild_delay_1 <= mid_20_vaild;
    Tile_1_left_4_vaild_delay_1 <= left_4_vaild;
    Tile_1_mid_21_vaild_delay_1_1 <= mid_21_vaild;
    Tile_1_mid_28_vaild_delay_1 <= mid_28_vaild;
    Tile_1_mid_22_vaild_delay_1_1 <= mid_22_vaild;
    Tile_1_mid_29_vaild_delay_1 <= mid_29_vaild;
    Tile_1_mid_23_vaild_delay_1_1 <= mid_23_vaild;
    Tile_1_mid_30_vaild_delay_1 <= mid_30_vaild;
    Tile_1_mid_24_vaild_delay_1_1 <= mid_24_vaild;
    Tile_1_mid_31_vaild_delay_1 <= mid_31_vaild;
    Tile_1_mid_25_vaild_delay_1_1 <= mid_25_vaild;
    Tile_1_mid_32_vaild_delay_1 <= mid_32_vaild;
    Tile_1_mid_26_vaild_delay_1_1 <= mid_26_vaild;
    Tile_1_mid_33_vaild_delay_1 <= mid_33_vaild;
    Tile_1_mid_27_vaild_delay_1 <= mid_27_vaild;
    Tile_1_left_5_vaild_delay_1 <= left_5_vaild;
    Tile_1_mid_28_vaild_delay_1_1 <= mid_28_vaild;
    Tile_1_mid_35_vaild_delay_1 <= mid_35_vaild;
    Tile_1_mid_29_vaild_delay_1_1 <= mid_29_vaild;
    Tile_1_mid_36_vaild_delay_1 <= mid_36_vaild;
    Tile_1_mid_30_vaild_delay_1_1 <= mid_30_vaild;
    Tile_1_mid_37_vaild_delay_1 <= mid_37_vaild;
    Tile_1_mid_31_vaild_delay_1_1 <= mid_31_vaild;
    Tile_1_mid_38_vaild_delay_1 <= mid_38_vaild;
    Tile_1_mid_32_vaild_delay_1_1 <= mid_32_vaild;
    Tile_1_mid_39_vaild_delay_1 <= mid_39_vaild;
    Tile_1_mid_33_vaild_delay_1_1 <= mid_33_vaild;
    Tile_1_mid_40_vaild_delay_1 <= mid_40_vaild;
    Tile_1_mid_34_vaild_delay_1 <= mid_34_vaild;
    Tile_1_left_6_vaild_delay_1 <= left_6_vaild;
    Tile_1_mid_35_vaild_delay_1_1 <= mid_35_vaild;
    Tile_1_mid_42_vaild_delay_1 <= mid_42_vaild;
    Tile_1_mid_36_vaild_delay_1_1 <= mid_36_vaild;
    Tile_1_mid_43_vaild_delay_1 <= mid_43_vaild;
    Tile_1_mid_37_vaild_delay_1_1 <= mid_37_vaild;
    Tile_1_mid_44_vaild_delay_1 <= mid_44_vaild;
    Tile_1_mid_38_vaild_delay_1_1 <= mid_38_vaild;
    Tile_1_mid_45_vaild_delay_1 <= mid_45_vaild;
    Tile_1_mid_39_vaild_delay_1_1 <= mid_39_vaild;
    Tile_1_mid_46_vaild_delay_1 <= mid_46_vaild;
    Tile_1_mid_40_vaild_delay_1_1 <= mid_40_vaild;
    Tile_1_mid_47_vaild_delay_1 <= mid_47_vaild;
    Tile_1_mid_41_vaild_delay_1 <= mid_41_vaild;
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

module Img2Col_OutPut (
  input               start,
  input               NewAddrIn_valid,
  output              NewAddrIn_ready,
  input      [15:0]   NewAddrIn_payload,
  output              SA_Idle,
  output     [15:0]   Raddr,
  output              Raddr_Valid,
  output              SA_End,
  input      [4:0]    Stride,
  input      [4:0]    Kernel_Size,
  input      [15:0]   Window_Size,
  input      [15:0]   InFeature_Size,
  input      [15:0]   InFeature_Channel,
  input      [15:0]   OutFeature_Channel,
  input      [15:0]   OutFeature_Size,
  input      [15:0]   OutCol_Count_Times,
  input      [15:0]   InCol_Count_Times,
  input      [15:0]   OutFeature_Channel_Count_Times,
  input      [12:0]   Sliding_Size,
  input               mReady,
  input               Fifo_Clear,
  output reg          AddrReceived,
  input               LayerEnd,
  output              SA_Row_Cnt_Valid,
  input               clk,
  input               reset
);
  localparam IMG2COL_OUTPUT_ENUM_IDLE = 7'd1;
  localparam IMG2COL_OUTPUT_ENUM_INIT = 7'd2;
  localparam IMG2COL_OUTPUT_ENUM_INIT_ADDR = 7'd4;
  localparam IMG2COL_OUTPUT_ENUM_SA_COMPUTE = 7'd8;
  localparam IMG2COL_OUTPUT_ENUM_UPDATE_ADDR = 7'd16;
  localparam IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY = 7'd32;
  localparam IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR = 7'd64;

  reg                 RaddrFifo1_io_push_valid;
  reg        [15:0]   RaddrFifo1_io_push_payload;
  reg                 RaddrFifo1_io_pop_ready;
  wire                RaddrFifo1_io_flush;
  wire                RaddrFifo1_io_push_ready;
  wire                RaddrFifo1_io_pop_valid;
  wire       [15:0]   RaddrFifo1_io_pop_payload;
  wire       [5:0]    RaddrFifo1_io_occupancy;
  wire       [5:0]    RaddrFifo1_io_availability;
  wire       [4:0]    _zz_Raddr_Init_Cnt_valid;
  wire       [4:0]    _zz_Raddr_Update_Cnt_valid;
  wire       [12:0]   _zz_In_Channel_Process_Cnt_valid;
  wire       [12:0]   _zz_In_Channel_Process_Cnt_valid_1;
  wire       [15:0]   _zz_Window_Col_Cnt_valid;
  wire       [4:0]    _zz_Window_Col_Cnt_valid_1;
  wire       [15:0]   _zz_Window_Row_Cnt_valid;
  wire       [4:0]    _zz_Window_Row_Cnt_valid_1;
  wire       [15:0]   _zz_Out_Channel_Cnt_valid;
  wire       [15:0]   _zz_Out_Col_Cnt_valid;
  wire       [15:0]   _zz_when_Data_Generate_V2_l498;
  wire       [15:0]   _zz_when_Data_Generate_V2_l498_1;
  wire       [15:0]   _zz_WindowSize_Cnt_valid;
  wire       [15:0]   _zz_WindowSize_Cnt_valid_1;
  wire       [31:0]   _zz_Kernel_Base_Addr;
  wire       [15:0]   _zz_Kernel_Base_Addr_1;
  wire       [31:0]   _zz_Kernel_Addr;
  wire       [15:0]   _zz_Kernel_Addr_1;
  wire       [31:0]   _zz_Kernel_Addr_2;
  wire       [31:0]   _zz_Kernel_Addr_3;
  wire       [31:0]   _zz_Kernel_Addr_4;
  wire       [31:0]   _zz_Raddr;
  wire       [31:0]   _zz_Raddr_1;
  reg                 start_regNext;
  wire                when_Data_Generate_V2_l344;
  reg        [6:0]    Fsm_currentState;
  reg        [6:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Addr_Inited;
  wire                Fsm_SA_Computed;
  wire                Fsm_Addr_Updated;
  wire                Fsm_LayerEnd;
  wire                Fsm_NextReady;
  wire                Fsm_Fifo_Clear;
  wire                when_Data_Generate_V2_l376;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  reg        [15:0]   Row_Base_Addr;
  wire                Img2Col_SubModule_RaddrFifo1_io_pop_fire;
  wire                Img2Col_SubModule_RaddrFifo1_io_push_fire;
  wire                when_WaCounter_l39;
  reg        [4:0]    Raddr_Init_Cnt_count;
  wire                Raddr_Init_Cnt_valid;
  wire                Img2Col_SubModule_RaddrFifo1_io_push_fire_1;
  wire                when_WaCounter_l39_1;
  reg        [4:0]    Raddr_Update_Cnt_count;
  wire                Raddr_Update_Cnt_valid;
  wire                when_Data_Generate_V2_l463;
  wire                when_WaCounter_l39_2;
  reg        [2:0]    SA_Row_Cnt_count;
  reg                 SA_Row_Cnt_valid_1;
  reg        [12:0]   In_Channel_Process_Cnt_count;
  wire                In_Channel_Process_Cnt_valid;
  reg        [15:0]   Window_Col_Cnt_count;
  wire                Window_Col_Cnt_valid;
  reg        [15:0]   Window_Row_Cnt_count;
  wire                Window_Row_Cnt_valid;
  reg        [15:0]   Out_Channel_Cnt_count;
  wire                Out_Channel_Cnt_valid;
  reg        [15:0]   Out_Col_Cnt_count;
  wire                Out_Col_Cnt_valid;
  reg        [15:0]   OutFeature_Col_Lefted;
  wire                when_Data_Generate_V2_l495;
  wire                when_Data_Generate_V2_l498;
  reg        [12:0]   WindowSize_Cnt_count;
  wire                WindowSize_Cnt_valid;
  reg        [31:0]   Kernel_Addr;
  reg        [31:0]   Kernel_Base_Addr;
  wire                when_Data_Generate_V2_l523;
  wire                when_Data_Generate_V2_l533;
  wire                Img2Col_SubModule_RaddrFifo1_io_push_fire_2;
  wire                when_Data_Generate_V2_l537;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif


  assign _zz_Raddr_Init_Cnt_valid = (Kernel_Size - 5'h01);
  assign _zz_Raddr_Update_Cnt_valid = (Stride - 5'h01);
  assign _zz_In_Channel_Process_Cnt_valid = (_zz_In_Channel_Process_Cnt_valid_1 - 13'h0001);
  assign _zz_In_Channel_Process_Cnt_valid_1 = (InFeature_Channel >>> 3);
  assign _zz_Window_Col_Cnt_valid_1 = (Kernel_Size - 5'h01);
  assign _zz_Window_Col_Cnt_valid = {11'd0, _zz_Window_Col_Cnt_valid_1};
  assign _zz_Window_Row_Cnt_valid_1 = (Kernel_Size - 5'h01);
  assign _zz_Window_Row_Cnt_valid = {11'd0, _zz_Window_Row_Cnt_valid_1};
  assign _zz_Out_Channel_Cnt_valid = (OutFeature_Channel_Count_Times - 16'h0001);
  assign _zz_Out_Col_Cnt_valid = (OutCol_Count_Times - 16'h0001);
  assign _zz_when_Data_Generate_V2_l498 = {13'd0, SA_Row_Cnt_count};
  assign _zz_when_Data_Generate_V2_l498_1 = (OutFeature_Col_Lefted - 16'h0001);
  assign _zz_WindowSize_Cnt_valid = {3'd0, WindowSize_Cnt_count};
  assign _zz_WindowSize_Cnt_valid_1 = (Window_Size - 16'h0001);
  assign _zz_Kernel_Base_Addr_1 = ({3'd0,Sliding_Size} <<< 3);
  assign _zz_Kernel_Base_Addr = {16'd0, _zz_Kernel_Base_Addr_1};
  assign _zz_Kernel_Addr_1 = ({3'd0,Sliding_Size} <<< 3);
  assign _zz_Kernel_Addr = {16'd0, _zz_Kernel_Addr_1};
  assign _zz_Kernel_Addr_2 = (Kernel_Base_Addr + _zz_Kernel_Addr_3);
  assign _zz_Kernel_Addr_3 = {19'd0, WindowSize_Cnt_count};
  assign _zz_Kernel_Addr_4 = {19'd0, Sliding_Size};
  assign _zz_Raddr = (Kernel_Addr + _zz_Raddr_1);
  assign _zz_Raddr_1 = {16'd0, Row_Base_Addr};
  WaddrOffset_Fifo_2 RaddrFifo1 (
    .io_push_valid   (RaddrFifo1_io_push_valid        ), //i
    .io_push_ready   (RaddrFifo1_io_push_ready        ), //o
    .io_push_payload (RaddrFifo1_io_push_payload[15:0]), //i
    .io_pop_valid    (RaddrFifo1_io_pop_valid         ), //o
    .io_pop_ready    (RaddrFifo1_io_pop_ready         ), //i
    .io_pop_payload  (RaddrFifo1_io_pop_payload[15:0] ), //o
    .io_flush        (RaddrFifo1_io_flush             ), //i
    .io_occupancy    (RaddrFifo1_io_occupancy[5:0]    ), //o
    .io_availability (RaddrFifo1_io_availability[5:0] ), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      IMG2COL_OUTPUT_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      IMG2COL_OUTPUT_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      IMG2COL_OUTPUT_ENUM_INIT_ADDR : Fsm_currentState_string = "INIT_ADDR      ";
      IMG2COL_OUTPUT_ENUM_SA_COMPUTE : Fsm_currentState_string = "SA_COMPUTE     ";
      IMG2COL_OUTPUT_ENUM_UPDATE_ADDR : Fsm_currentState_string = "UPDATE_ADDR    ";
      IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY : Fsm_currentState_string = "WAIT_NEXT_READY";
      IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR : Fsm_currentState_string = "WAIT_FIFO_CLEAR";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      IMG2COL_OUTPUT_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      IMG2COL_OUTPUT_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      IMG2COL_OUTPUT_ENUM_INIT_ADDR : Fsm_nextState_string = "INIT_ADDR      ";
      IMG2COL_OUTPUT_ENUM_SA_COMPUTE : Fsm_nextState_string = "SA_COMPUTE     ";
      IMG2COL_OUTPUT_ENUM_UPDATE_ADDR : Fsm_nextState_string = "UPDATE_ADDR    ";
      IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY : Fsm_nextState_string = "WAIT_NEXT_READY";
      IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR : Fsm_nextState_string = "WAIT_FIFO_CLEAR";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_Data_Generate_V2_l344 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_IDLE) == IMG2COL_OUTPUT_ENUM_IDLE) : begin
        if(when_Data_Generate_V2_l344) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_INIT) == IMG2COL_OUTPUT_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_INIT_ADDR) == IMG2COL_OUTPUT_ENUM_INIT_ADDR) : begin
        if(Fsm_Addr_Inited) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_INIT_ADDR;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) == IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) : begin
        if(Fsm_NextReady) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_SA_COMPUTE;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) == IMG2COL_OUTPUT_ENUM_SA_COMPUTE) : begin
        if(Fsm_LayerEnd) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_IDLE;
        end else begin
          if(Fsm_SA_Computed) begin
            Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR;
          end else begin
            if(when_Data_Generate_V2_l376) begin
              Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
            end else begin
              Fsm_nextState = IMG2COL_OUTPUT_ENUM_SA_COMPUTE;
            end
          end
        end
      end
      (((Fsm_currentState) & IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR) == IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR) : begin
        if(Fsm_Fifo_Clear) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_UPDATE_ADDR;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_FIFO_CLEAR;
        end
      end
      default : begin
        if(Fsm_Addr_Updated) begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY;
        end else begin
          Fsm_nextState = IMG2COL_OUTPUT_ENUM_UPDATE_ADDR;
        end
      end
    endcase
  end

  assign when_Data_Generate_V2_l376 = (! Fsm_NextReady);
  assign when_WaCounter_l19 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT) != 7'b0000000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Fifo_Clear = Fifo_Clear;
  assign NewAddrIn_ready = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) || ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000));
  always @(*) begin
    RaddrFifo1_io_push_valid = 1'b0;
    if(when_Data_Generate_V2_l533) begin
      RaddrFifo1_io_push_valid = NewAddrIn_valid;
    end else begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_push_valid = NewAddrIn_valid;
      end else begin
        RaddrFifo1_io_push_valid = Window_Col_Cnt_valid;
      end
    end
  end

  always @(*) begin
    RaddrFifo1_io_pop_ready = 1'b0;
    if(when_Data_Generate_V2_l463) begin
      RaddrFifo1_io_pop_ready = 1'b1;
    end
    if(!when_Data_Generate_V2_l533) begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_pop_ready = Img2Col_SubModule_RaddrFifo1_io_push_fire_2;
      end
    end
    if(Window_Col_Cnt_valid) begin
      RaddrFifo1_io_pop_ready = 1'b1;
    end
  end

  assign Img2Col_SubModule_RaddrFifo1_io_pop_fire = (RaddrFifo1_io_pop_valid && RaddrFifo1_io_pop_ready);
  assign Img2Col_SubModule_RaddrFifo1_io_push_fire = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_WaCounter_l39 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) && Img2Col_SubModule_RaddrFifo1_io_push_fire);
  assign Raddr_Init_Cnt_valid = ((Raddr_Init_Cnt_count == _zz_Raddr_Init_Cnt_valid) && when_WaCounter_l39);
  assign Fsm_Addr_Inited = Raddr_Init_Cnt_valid;
  assign Img2Col_SubModule_RaddrFifo1_io_push_fire_1 = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_WaCounter_l39_1 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000) && Img2Col_SubModule_RaddrFifo1_io_push_fire_1);
  assign Raddr_Update_Cnt_valid = ((Raddr_Update_Cnt_count == _zz_Raddr_Update_Cnt_valid) && when_WaCounter_l39_1);
  assign Fsm_Addr_Updated = Raddr_Update_Cnt_valid;
  assign Fsm_NextReady = mReady;
  always @(*) begin
    AddrReceived = 1'b0;
    if(when_Data_Generate_V2_l463) begin
      AddrReceived = 1'b1;
    end
  end

  assign when_Data_Generate_V2_l463 = ((((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) != 7'b0000000)) || (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000) && ((Fsm_nextState & IMG2COL_OUTPUT_ENUM_WAIT_NEXT_READY) != 7'b0000000)));
  assign when_WaCounter_l39_2 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  always @(*) begin
    SA_Row_Cnt_valid_1 = ((SA_Row_Cnt_count == 3'b111) && when_WaCounter_l39_2);
    if(when_Data_Generate_V2_l498) begin
      SA_Row_Cnt_valid_1 = 1'b1;
    end
  end

  assign SA_Row_Cnt_Valid = SA_Row_Cnt_valid_1;
  assign In_Channel_Process_Cnt_valid = ((In_Channel_Process_Cnt_count == _zz_In_Channel_Process_Cnt_valid) && SA_Row_Cnt_valid_1);
  assign Window_Col_Cnt_valid = ((Window_Col_Cnt_count == _zz_Window_Col_Cnt_valid) && In_Channel_Process_Cnt_valid);
  assign Window_Row_Cnt_valid = ((Window_Row_Cnt_count == _zz_Window_Row_Cnt_valid) && Window_Col_Cnt_valid);
  assign Out_Channel_Cnt_valid = ((Out_Channel_Cnt_count == _zz_Out_Channel_Cnt_valid) && Window_Row_Cnt_valid);
  assign Out_Col_Cnt_valid = ((Out_Col_Cnt_count == _zz_Out_Col_Cnt_valid) && Out_Channel_Cnt_valid);
  assign SA_End = Out_Col_Cnt_valid;
  assign when_Data_Generate_V2_l495 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT) != 7'b0000000);
  assign when_Data_Generate_V2_l498 = (((_zz_when_Data_Generate_V2_l498 == _zz_when_Data_Generate_V2_l498_1) && mReady) && ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000));
  assign WindowSize_Cnt_valid = ((_zz_WindowSize_Cnt_valid == _zz_WindowSize_Cnt_valid_1) && SA_Row_Cnt_valid_1);
  assign when_Data_Generate_V2_l523 = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  assign Raddr = _zz_Raddr[15:0];
  assign Fsm_SA_Computed = Out_Col_Cnt_valid;
  assign SA_Idle = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_IDLE) != 7'b0000000) || ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000));
  assign when_Data_Generate_V2_l533 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_INIT_ADDR) != 7'b0000000);
  always @(*) begin
    if(when_Data_Generate_V2_l533) begin
      RaddrFifo1_io_push_payload = NewAddrIn_payload;
    end else begin
      if(when_Data_Generate_V2_l537) begin
        RaddrFifo1_io_push_payload = NewAddrIn_payload;
      end else begin
        RaddrFifo1_io_push_payload = Row_Base_Addr;
      end
    end
  end

  assign Img2Col_SubModule_RaddrFifo1_io_push_fire_2 = (RaddrFifo1_io_push_valid && RaddrFifo1_io_push_ready);
  assign when_Data_Generate_V2_l537 = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_UPDATE_ADDR) != 7'b0000000);
  assign Raddr_Valid = (((Fsm_currentState & IMG2COL_OUTPUT_ENUM_SA_COMPUTE) != 7'b0000000) && mReady);
  assign Fsm_LayerEnd = LayerEnd;
  assign RaddrFifo1_io_flush = ((Fsm_currentState & IMG2COL_OUTPUT_ENUM_IDLE) != 7'b0000000);
  always @(posedge clk) begin
    start_regNext <= start;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= IMG2COL_OUTPUT_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Row_Base_Addr <= 16'h0;
      Raddr_Init_Cnt_count <= 5'h0;
      Raddr_Update_Cnt_count <= 5'h0;
      SA_Row_Cnt_count <= 3'b000;
      In_Channel_Process_Cnt_count <= 13'h0;
      Window_Col_Cnt_count <= 16'h0;
      Window_Row_Cnt_count <= 16'h0;
      Out_Channel_Cnt_count <= 16'h0;
      Out_Col_Cnt_count <= 16'h0;
      OutFeature_Col_Lefted <= 16'h0;
      WindowSize_Cnt_count <= 13'h0;
      Kernel_Addr <= 32'h0;
      Kernel_Base_Addr <= 32'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(Img2Col_SubModule_RaddrFifo1_io_pop_fire) begin
        Row_Base_Addr <= RaddrFifo1_io_pop_payload;
      end
      if(when_WaCounter_l39) begin
        if(Raddr_Init_Cnt_valid) begin
          Raddr_Init_Cnt_count <= 5'h0;
        end else begin
          Raddr_Init_Cnt_count <= (Raddr_Init_Cnt_count + 5'h01);
        end
      end
      if(when_WaCounter_l39_1) begin
        if(Raddr_Update_Cnt_valid) begin
          Raddr_Update_Cnt_count <= 5'h0;
        end else begin
          Raddr_Update_Cnt_count <= (Raddr_Update_Cnt_count + 5'h01);
        end
      end
      if(when_WaCounter_l39_2) begin
        if(SA_Row_Cnt_valid_1) begin
          SA_Row_Cnt_count <= 3'b000;
        end else begin
          SA_Row_Cnt_count <= (SA_Row_Cnt_count + 3'b001);
        end
      end
      if(SA_Row_Cnt_valid_1) begin
        if(In_Channel_Process_Cnt_valid) begin
          In_Channel_Process_Cnt_count <= 13'h0;
        end else begin
          In_Channel_Process_Cnt_count <= (In_Channel_Process_Cnt_count + 13'h0001);
        end
      end
      if(In_Channel_Process_Cnt_valid) begin
        if(Window_Col_Cnt_valid) begin
          Window_Col_Cnt_count <= 16'h0;
        end else begin
          Window_Col_Cnt_count <= (Window_Col_Cnt_count + 16'h0001);
        end
      end
      if(Window_Col_Cnt_valid) begin
        if(Window_Row_Cnt_valid) begin
          Window_Row_Cnt_count <= 16'h0;
        end else begin
          Window_Row_Cnt_count <= (Window_Row_Cnt_count + 16'h0001);
        end
      end
      if(Window_Row_Cnt_valid) begin
        if(Out_Channel_Cnt_valid) begin
          Out_Channel_Cnt_count <= 16'h0;
        end else begin
          Out_Channel_Cnt_count <= (Out_Channel_Cnt_count + 16'h0001);
        end
      end
      if(Out_Channel_Cnt_valid) begin
        if(Out_Col_Cnt_valid) begin
          Out_Col_Cnt_count <= 16'h0;
        end else begin
          Out_Col_Cnt_count <= (Out_Col_Cnt_count + 16'h0001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        OutFeature_Col_Lefted <= OutFeature_Size;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          OutFeature_Col_Lefted <= (OutFeature_Col_Lefted - 16'h0008);
        end else begin
          if(when_Data_Generate_V2_l495) begin
            OutFeature_Col_Lefted <= OutFeature_Size;
          end
        end
      end
      if(when_Data_Generate_V2_l498) begin
        SA_Row_Cnt_count <= 3'b000;
      end
      if(SA_Row_Cnt_valid_1) begin
        if(WindowSize_Cnt_valid) begin
          WindowSize_Cnt_count <= 13'h0;
        end else begin
          WindowSize_Cnt_count <= (WindowSize_Cnt_count + 13'h0001);
        end
      end
      if(Out_Col_Cnt_valid) begin
        Kernel_Base_Addr <= 32'h0;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          Kernel_Base_Addr <= (Kernel_Base_Addr + _zz_Kernel_Base_Addr);
        end
      end
      if(Out_Col_Cnt_valid) begin
        Kernel_Addr <= 32'h0;
      end else begin
        if(Out_Channel_Cnt_valid) begin
          Kernel_Addr <= (Kernel_Base_Addr + _zz_Kernel_Addr);
        end else begin
          if(Window_Row_Cnt_valid) begin
            Kernel_Addr <= Kernel_Base_Addr;
          end else begin
            if(WindowSize_Cnt_valid) begin
              Kernel_Addr <= Kernel_Base_Addr;
            end else begin
              if(SA_Row_Cnt_valid_1) begin
                Kernel_Addr <= (_zz_Kernel_Addr_2 + 32'h00000001);
              end else begin
                if(when_Data_Generate_V2_l523) begin
                  Kernel_Addr <= (Kernel_Addr + _zz_Kernel_Addr_4);
                end
              end
            end
          end
        end
      end
    end
  end


endmodule

//WaddrOffset_Fifo_1 replaced by WaddrOffset_Fifo_2

//WaddrOffset_Fifo replaced by WaddrOffset_Fifo_2

//PE_63 replaced by PE

//PE_62 replaced by PE

//PE_61 replaced by PE

//PE_60 replaced by PE

//PE_59 replaced by PE

//PE_58 replaced by PE

//PE_57 replaced by PE

//PE_56 replaced by PE

//PE_55 replaced by PE

//PE_54 replaced by PE

//PE_53 replaced by PE

//PE_52 replaced by PE

//PE_51 replaced by PE

//PE_50 replaced by PE

//PE_49 replaced by PE

//PE_48 replaced by PE

//PE_47 replaced by PE

//PE_46 replaced by PE

//PE_45 replaced by PE

//PE_44 replaced by PE

//PE_43 replaced by PE

//PE_42 replaced by PE

//PE_41 replaced by PE

//PE_40 replaced by PE

//PE_39 replaced by PE

//PE_38 replaced by PE

//PE_37 replaced by PE

//PE_36 replaced by PE

//PE_35 replaced by PE

//PE_34 replaced by PE

//PE_33 replaced by PE

//PE_32 replaced by PE

//PE_31 replaced by PE

//PE_30 replaced by PE

//PE_29 replaced by PE

//PE_28 replaced by PE

//PE_27 replaced by PE

//PE_26 replaced by PE

//PE_25 replaced by PE

//PE_24 replaced by PE

//PE_23 replaced by PE

//PE_22 replaced by PE

//PE_21 replaced by PE

//PE_20 replaced by PE

//PE_19 replaced by PE

//PE_18 replaced by PE

//PE_17 replaced by PE

//PE_16 replaced by PE

//PE_15 replaced by PE

//PE_14 replaced by PE

//PE_13 replaced by PE

//PE_12 replaced by PE

//PE_11 replaced by PE

//PE_10 replaced by PE

//PE_9 replaced by PE

//PE_8 replaced by PE

//PE_7 replaced by PE

//PE_6 replaced by PE

//PE_5 replaced by PE

//PE_4 replaced by PE

//PE_3 replaced by PE

//PE_2 replaced by PE

//PE_1 replaced by PE

module PE (
  input      [7:0]    activate,
  input      [7:0]    weight,
  input               vaild,
  input      [15:0]   signCount,
  output     [7:0]    acount,
  output     [7:0]    bcount,
  output reg [31:0]   PE_OUT,
  output              finish,
  input               clk,
  input               reset
);

  wire       [15:0]   dsp_P;
  wire       [31:0]   _zz_reg1;
  wire       [31:0]   _zz_reg1_1;
  wire       [31:0]   _zz_reg1_2;
  reg        [31:0]   reg1;
  reg                 vaild_regNext;
  reg                 vaild_regNext_1;
  reg                 vaild_regNext_1_regNext;
  reg        [15:0]   finishCnt_count;
  wire                finishCnt_valid;
  reg        [7:0]    activate_regNext;
  reg        [7:0]    weight_regNext;

  assign _zz_reg1 = {{16{dsp_P[15]}}, dsp_P};
  assign _zz_reg1_1 = {{16{dsp_P[15]}}, dsp_P};
  assign _zz_reg1_2 = 32'h0;
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
      PE_OUT = 32'h0;
    end
  end

  assign acount = activate_regNext;
  assign bcount = weight_regNext;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      reg1 <= 32'h0;
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

module WaddrOffset_Fifo_2 (
  input               io_push_valid,
  output              io_push_ready,
  input      [15:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [15:0]   io_pop_payload,
  input               io_flush,
  output reg [5:0]    io_occupancy,
  output reg [5:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [15:0]   _zz_logic_ram_port0;
  wire       [5:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [5:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [15:0]   _zz_logic_ram_port_1;
  wire       [5:0]    _zz_io_occupancy;
  wire       [5:0]    _zz_io_availability;
  wire       [5:0]    _zz_io_availability_1;
  wire       [5:0]    _zz_io_availability_2;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [5:0]    logic_pushPtr_valueNext;
  reg        [5:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [5:0]    logic_popPtr_valueNext;
  reg        [5:0]    logic_popPtr_value;
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
  wire       [5:0]    logic_ptrDif;
  reg [15:0] logic_ram [0:32];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {5'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {5'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_occupancy = (6'h21 + logic_ptrDif);
  assign _zz_io_availability = (6'h21 + _zz_io_availability_1);
  assign _zz_io_availability_1 = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_availability_2 = (logic_popPtr_value - logic_pushPtr_value);
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 6'h20);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    if(logic_pushPtr_willOverflow) begin
      logic_pushPtr_valueNext = 6'h0;
    end else begin
      logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    end
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 6'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 6'h20);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    if(logic_popPtr_willOverflow) begin
      logic_popPtr_valueNext = 6'h0;
    end else begin
      logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    end
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 6'h0;
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
  always @(*) begin
    if(logic_ptrMatch) begin
      io_occupancy = (logic_risingOccupancy ? 6'h21 : 6'h0);
    end else begin
      io_occupancy = ((logic_popPtr_value < logic_pushPtr_value) ? logic_ptrDif : _zz_io_occupancy);
    end
  end

  always @(*) begin
    if(logic_ptrMatch) begin
      io_availability = (logic_risingOccupancy ? 6'h0 : 6'h21);
    end else begin
      io_availability = ((logic_popPtr_value < logic_pushPtr_value) ? _zz_io_availability : _zz_io_availability_2);
    end
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 6'h0;
      logic_popPtr_value <= 6'h0;
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
