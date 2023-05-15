// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : LayerNorm_Module
// Git hash  : d45a44ec854aee90045e156b055ecf91042c178d

`timescale 1ns/1ps

module LayerNorm_Module (
  input               sData_valid,
  output              sData_ready,
  input      [127:0]  sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Bias_Read_Addr,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  input               clk,
  input               reset
);

  wire       [10:0]   Stage1_0_sData_payload;
  wire                Stage1_0_mData_ready;
  wire       [10:0]   Stage1_1_sData_payload;
  wire                Stage1_1_mData_ready;
  wire       [10:0]   Stage1_2_sData_payload;
  wire                Stage1_2_mData_ready;
  wire       [10:0]   Stage1_3_sData_payload;
  wire                Stage1_3_mData_ready;
  wire       [10:0]   Stage1_4_sData_payload;
  wire                Stage1_4_mData_ready;
  wire       [10:0]   Stage1_5_sData_payload;
  wire                Stage1_5_mData_ready;
  wire       [10:0]   Stage1_6_sData_payload;
  wire                Stage1_6_mData_ready;
  wire       [10:0]   Stage1_7_sData_payload;
  wire                Stage1_7_mData_ready;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_0;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_2;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_3;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_4;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_5;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_6;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_7;
  wire                Stage2_Recipro_Sqrt_Result_Valid;
  wire       [8:0]    Stage2_Bias_Read_Addr;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_0_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_1_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_2_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_3_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_4_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_5_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_6_1;
  wire       [31:0]   Stage2_Recipro_Sqrt_Result_Latch_7_1;
  wire                Stage1_0_sData_ready;
  wire       [8:0]    Stage1_0_Scale_Read_Addr;
  wire                Stage1_0_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_0_Sqrt_In_Truncated;
  wire                Stage1_0_ScaleA_Fifo_Popfire;
  wire                Stage1_0_mData_valid;
  wire       [7:0]    Stage1_0_mData_payload;
  wire                Stage1_1_sData_ready;
  wire       [8:0]    Stage1_1_Scale_Read_Addr;
  wire                Stage1_1_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_1_Sqrt_In_Truncated;
  wire                Stage1_1_ScaleA_Fifo_Popfire;
  wire                Stage1_1_mData_valid;
  wire       [7:0]    Stage1_1_mData_payload;
  wire                Stage1_2_sData_ready;
  wire       [8:0]    Stage1_2_Scale_Read_Addr;
  wire                Stage1_2_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_2_Sqrt_In_Truncated;
  wire                Stage1_2_ScaleA_Fifo_Popfire;
  wire                Stage1_2_mData_valid;
  wire       [7:0]    Stage1_2_mData_payload;
  wire                Stage1_3_sData_ready;
  wire       [8:0]    Stage1_3_Scale_Read_Addr;
  wire                Stage1_3_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_3_Sqrt_In_Truncated;
  wire                Stage1_3_ScaleA_Fifo_Popfire;
  wire                Stage1_3_mData_valid;
  wire       [7:0]    Stage1_3_mData_payload;
  wire                Stage1_4_sData_ready;
  wire       [8:0]    Stage1_4_Scale_Read_Addr;
  wire                Stage1_4_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_4_Sqrt_In_Truncated;
  wire                Stage1_4_ScaleA_Fifo_Popfire;
  wire                Stage1_4_mData_valid;
  wire       [7:0]    Stage1_4_mData_payload;
  wire                Stage1_5_sData_ready;
  wire       [8:0]    Stage1_5_Scale_Read_Addr;
  wire                Stage1_5_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_5_Sqrt_In_Truncated;
  wire                Stage1_5_ScaleA_Fifo_Popfire;
  wire                Stage1_5_mData_valid;
  wire       [7:0]    Stage1_5_mData_payload;
  wire                Stage1_6_sData_ready;
  wire       [8:0]    Stage1_6_Scale_Read_Addr;
  wire                Stage1_6_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_6_Sqrt_In_Truncated;
  wire                Stage1_6_ScaleA_Fifo_Popfire;
  wire                Stage1_6_mData_valid;
  wire       [7:0]    Stage1_6_mData_payload;
  wire                Stage1_7_sData_ready;
  wire       [8:0]    Stage1_7_Scale_Read_Addr;
  wire                Stage1_7_Sqrt_Out_Valid;
  wire       [31:0]   Stage1_7_Sqrt_In_Truncated;
  wire                Stage1_7_ScaleA_Fifo_Popfire;
  wire                Stage1_7_mData_valid;
  wire       [7:0]    Stage1_7_mData_payload;
  reg        [7:0]    Bias_delay_1;
  reg        [7:0]    Bias_delay_2;
  reg        [7:0]    Bias_delay_3;
  reg        [7:0]    Bias_delay_4;
  reg        [7:0]    Bias_delay_1_1;
  reg        [7:0]    Bias_delay_2_1;
  reg        [7:0]    Bias_delay_3_1;
  reg        [7:0]    Bias_delay_4_1;
  reg        [7:0]    Bias_delay_1_2;
  reg        [7:0]    Bias_delay_2_2;
  reg        [7:0]    Bias_delay_3_2;
  reg        [7:0]    Bias_delay_4_2;
  reg        [7:0]    Bias_delay_1_3;
  reg        [7:0]    Bias_delay_2_3;
  reg        [7:0]    Bias_delay_3_3;
  reg        [7:0]    Bias_delay_4_3;
  reg        [7:0]    Bias_delay_1_4;
  reg        [7:0]    Bias_delay_2_4;
  reg        [7:0]    Bias_delay_3_4;
  reg        [7:0]    Bias_delay_4_4;
  reg        [7:0]    Bias_delay_1_5;
  reg        [7:0]    Bias_delay_2_5;
  reg        [7:0]    Bias_delay_3_5;
  reg        [7:0]    Bias_delay_4_5;
  reg        [7:0]    Bias_delay_1_6;
  reg        [7:0]    Bias_delay_2_6;
  reg        [7:0]    Bias_delay_3_6;
  reg        [7:0]    Bias_delay_4_6;
  reg        [7:0]    Bias_delay_1_7;
  reg        [7:0]    Bias_delay_2_7;
  reg        [7:0]    Bias_delay_3_7;
  reg        [7:0]    Bias_delay_4_7;

  Reci_Sqrt_Compute Stage2 (
    .Sqrt_In_Valid_0               (Stage1_0_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_1               (Stage1_1_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_2               (Stage1_2_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_3               (Stage1_3_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_4               (Stage1_4_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_5               (Stage1_5_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_6               (Stage1_6_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Valid_7               (Stage1_7_Sqrt_Out_Valid                   ), //i
    .Sqrt_In_Truncated_0           (Stage1_0_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_1           (Stage1_1_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_2           (Stage1_2_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_3           (Stage1_3_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_4           (Stage1_4_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_5           (Stage1_5_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_6           (Stage1_6_Sqrt_In_Truncated[31:0]          ), //i
    .Sqrt_In_Truncated_7           (Stage1_7_Sqrt_In_Truncated[31:0]          ), //i
    .ScaleA_Fifo_Popfire           (Stage1_0_ScaleA_Fifo_Popfire              ), //i
    .Recipro_Sqrt_Result_Latch_0   (Stage2_Recipro_Sqrt_Result_Latch_0[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_1   (Stage2_Recipro_Sqrt_Result_Latch_1[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_2   (Stage2_Recipro_Sqrt_Result_Latch_2[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_3   (Stage2_Recipro_Sqrt_Result_Latch_3[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_4   (Stage2_Recipro_Sqrt_Result_Latch_4[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_5   (Stage2_Recipro_Sqrt_Result_Latch_5[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_6   (Stage2_Recipro_Sqrt_Result_Latch_6[31:0]  ), //o
    .Recipro_Sqrt_Result_Latch_7   (Stage2_Recipro_Sqrt_Result_Latch_7[31:0]  ), //o
    .Recipro_Sqrt_Result_Valid     (Stage2_Recipro_Sqrt_Result_Valid          ), //o
    .Bias_Read_Addr                (Stage2_Bias_Read_Addr[8:0]                ), //o
    .clk                           (clk                                       ), //i
    .Recipro_Sqrt_Result_Latch_0_1 (Stage2_Recipro_Sqrt_Result_Latch_0_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_1_1 (Stage2_Recipro_Sqrt_Result_Latch_1_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_2_1 (Stage2_Recipro_Sqrt_Result_Latch_2_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_3_1 (Stage2_Recipro_Sqrt_Result_Latch_3_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_4_1 (Stage2_Recipro_Sqrt_Result_Latch_4_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_5_1 (Stage2_Recipro_Sqrt_Result_Latch_5_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_6_1 (Stage2_Recipro_Sqrt_Result_Latch_6_1[31:0]), //o
    .Recipro_Sqrt_Result_Latch_7_1 (Stage2_Recipro_Sqrt_Result_Latch_7_1[31:0]), //o
    .reset                         (reset                                     )  //i
  );
  Sum_Xq Stage1_0 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_0_sData_ready                    ), //o
    .sData_payload             (Stage1_0_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_0_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4[7:0]                       ), //i
    .Sqrt_Out_Valid            (Stage1_0_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_0_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_0_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_0[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_0_mData_valid                    ), //o
    .mData_ready               (Stage1_0_mData_ready                    ), //i
    .mData_payload             (Stage1_0_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_1 Stage1_1 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_1_sData_ready                    ), //o
    .sData_payload             (Stage1_1_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_1_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_1[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_1_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_1_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_1_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_1[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_1_mData_valid                    ), //o
    .mData_ready               (Stage1_1_mData_ready                    ), //i
    .mData_payload             (Stage1_1_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_2 Stage1_2 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_2_sData_ready                    ), //o
    .sData_payload             (Stage1_2_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_2_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_2[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_2_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_2_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_2_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_2[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_2_mData_valid                    ), //o
    .mData_ready               (Stage1_2_mData_ready                    ), //i
    .mData_payload             (Stage1_2_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_3 Stage1_3 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_3_sData_ready                    ), //o
    .sData_payload             (Stage1_3_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_3_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_3[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_3_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_3_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_3_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_3[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_3_mData_valid                    ), //o
    .mData_ready               (Stage1_3_mData_ready                    ), //i
    .mData_payload             (Stage1_3_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_4 Stage1_4 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_4_sData_ready                    ), //o
    .sData_payload             (Stage1_4_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_4_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_4[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_4_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_4_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_4_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_4[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_4_mData_valid                    ), //o
    .mData_ready               (Stage1_4_mData_ready                    ), //i
    .mData_payload             (Stage1_4_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_5 Stage1_5 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_5_sData_ready                    ), //o
    .sData_payload             (Stage1_5_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_5_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_5[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_5_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_5_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_5_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_5[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_5_mData_valid                    ), //o
    .mData_ready               (Stage1_5_mData_ready                    ), //i
    .mData_payload             (Stage1_5_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_6 Stage1_6 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_6_sData_ready                    ), //o
    .sData_payload             (Stage1_6_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_6_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_6[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_6_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_6_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_6_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_6[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_6_mData_valid                    ), //o
    .mData_ready               (Stage1_6_mData_ready                    ), //i
    .mData_payload             (Stage1_6_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  Sum_Xq_7 Stage1_7 (
    .sData_valid               (sData_valid                             ), //i
    .sData_ready               (Stage1_7_sData_ready                    ), //o
    .sData_payload             (Stage1_7_sData_payload[10:0]            ), //i
    .start                     (start                                   ), //i
    .Channel_Nums              (Channel_Nums[11:0]                      ), //i
    .Scale_Read_Addr           (Stage1_7_Scale_Read_Addr[8:0]           ), //o
    .Scale                     (Scale[7:0]                              ), //i
    .Bias                      (Bias_delay_4_7[7:0]                     ), //i
    .Sqrt_Out_Valid            (Stage1_7_Sqrt_Out_Valid                 ), //o
    .Sqrt_In_Truncated         (Stage1_7_Sqrt_In_Truncated[31:0]        ), //o
    .ScaleA_Fifo_Popfire       (Stage1_7_ScaleA_Fifo_Popfire            ), //o
    .Recipro_Sqrt_Result       (Stage2_Recipro_Sqrt_Result_Latch_7[31:0]), //i
    .Recipro_Sqrt_Result_Valid (Stage2_Recipro_Sqrt_Result_Valid        ), //i
    .mData_valid               (Stage1_7_mData_valid                    ), //o
    .mData_ready               (Stage1_7_mData_ready                    ), //i
    .mData_payload             (Stage1_7_mData_payload[7:0]             ), //o
    .clk                       (clk                                     ), //i
    .reset                     (reset                                   )  //i
  );
  assign Stage1_0_sData_payload = sData_payload[10 : 0];
  always @(*) begin
    mData_payload[7 : 0] = Stage1_0_mData_payload;
    mData_payload[15 : 8] = Stage1_1_mData_payload;
    mData_payload[23 : 16] = Stage1_2_mData_payload;
    mData_payload[31 : 24] = Stage1_3_mData_payload;
    mData_payload[39 : 32] = Stage1_4_mData_payload;
    mData_payload[47 : 40] = Stage1_5_mData_payload;
    mData_payload[55 : 48] = Stage1_6_mData_payload;
    mData_payload[63 : 56] = Stage1_7_mData_payload;
  end

  assign Stage1_1_sData_payload = sData_payload[26 : 16];
  assign Stage1_2_sData_payload = sData_payload[42 : 32];
  assign Stage1_3_sData_payload = sData_payload[58 : 48];
  assign Stage1_4_sData_payload = sData_payload[74 : 64];
  assign Stage1_5_sData_payload = sData_payload[90 : 80];
  assign Stage1_6_sData_payload = sData_payload[106 : 96];
  assign Stage1_7_sData_payload = sData_payload[122 : 112];
  assign sData_ready = Stage1_0_sData_ready;
  assign Scale_Read_Addr = Stage1_0_Scale_Read_Addr;
  assign Bias_Read_Addr = Stage2_Bias_Read_Addr;
  assign mData_valid = Stage1_0_mData_valid;
  always @(posedge clk) begin
    Bias_delay_1 <= Bias;
    Bias_delay_2 <= Bias_delay_1;
    Bias_delay_3 <= Bias_delay_2;
    Bias_delay_4 <= Bias_delay_3;
    Bias_delay_1_1 <= Bias;
    Bias_delay_2_1 <= Bias_delay_1_1;
    Bias_delay_3_1 <= Bias_delay_2_1;
    Bias_delay_4_1 <= Bias_delay_3_1;
    Bias_delay_1_2 <= Bias;
    Bias_delay_2_2 <= Bias_delay_1_2;
    Bias_delay_3_2 <= Bias_delay_2_2;
    Bias_delay_4_2 <= Bias_delay_3_2;
    Bias_delay_1_3 <= Bias;
    Bias_delay_2_3 <= Bias_delay_1_3;
    Bias_delay_3_3 <= Bias_delay_2_3;
    Bias_delay_4_3 <= Bias_delay_3_3;
    Bias_delay_1_4 <= Bias;
    Bias_delay_2_4 <= Bias_delay_1_4;
    Bias_delay_3_4 <= Bias_delay_2_4;
    Bias_delay_4_4 <= Bias_delay_3_4;
    Bias_delay_1_5 <= Bias;
    Bias_delay_2_5 <= Bias_delay_1_5;
    Bias_delay_3_5 <= Bias_delay_2_5;
    Bias_delay_4_5 <= Bias_delay_3_5;
    Bias_delay_1_6 <= Bias;
    Bias_delay_2_6 <= Bias_delay_1_6;
    Bias_delay_3_6 <= Bias_delay_2_6;
    Bias_delay_4_6 <= Bias_delay_3_6;
    Bias_delay_1_7 <= Bias;
    Bias_delay_2_7 <= Bias_delay_1_7;
    Bias_delay_3_7 <= Bias_delay_2_7;
    Bias_delay_4_7 <= Bias_delay_3_7;
  end


endmodule

module Sum_Xq_7 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_7_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_7_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_7_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_7_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_7_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_7_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_6 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_6_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_6_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_6_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_6_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_6_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_6_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_5 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_5_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_5_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_5_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_5_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_5_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_5_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_4 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_4_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_4_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_4_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_4_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_4_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_4_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_3 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_3_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_3_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_3_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_3_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_3_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_3_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_2 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_2_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_2_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_2_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_2_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_2_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_2_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq_1 (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_1_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_1_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_1_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_1_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_1_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_1_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Sum_Xq (
  input               sData_valid,
  output              sData_ready,
  input      [10:0]   sData_payload,
  input               start,
  input      [11:0]   Channel_Nums,
  output     [8:0]    Scale_Read_Addr,
  input      [7:0]    Scale,
  input      [7:0]    Bias,
  output              Sqrt_Out_Valid,
  output     [31:0]   Sqrt_In_Truncated,
  output              ScaleA_Fifo_Popfire,
  input      [31:0]   Recipro_Sqrt_Result,
  input               Recipro_Sqrt_Result_Valid,
  output              mData_valid,
  input               mData_ready,
  output     [7:0]    mData_payload,
  input               clk,
  input               reset
);
  localparam SUM_XQ_ENUM_IDLE = 5'd1;
  localparam SUM_XQ_ENUM_INIT = 5'd2;
  localparam SUM_XQ_ENUM_LOAD_FIRST_ROW = 5'd4;
  localparam SUM_XQ_ENUM_ACCUMU = 5'd8;
  localparam SUM_XQ_ENUM_FINISH_LAST_ROW = 5'd16;

  wire       [22:0]   Xq2C_Module_A;
  wire       [39:0]   ScaleMulA_Fifo_io_push_payload;
  wire       [23:0]   ScaleA_Mul_ReSqrt_B;
  reg        [22:0]   _zz_Row_Mem_port0;
  wire       [22:0]   XqC_Module_P;
  wire       [33:0]   Xq2C_Module_P;
  wire       [39:0]   XqSum_Pow_P;
  wire       [39:0]   Scale_Mul_A_P;
  wire                ScaleMulA_Fifo_io_push_ready;
  wire                ScaleMulA_Fifo_io_pop_valid;
  wire       [39:0]   ScaleMulA_Fifo_io_pop_payload;
  wire       [7:0]    ScaleMulA_Fifo_io_occupancy;
  wire       [7:0]    ScaleMulA_Fifo_io_availability;
  wire       [63:0]   ScaleA_Mul_ReSqrt_P;
  wire       [22:0]   _zz_Row_Mem_port;
  wire       [19:0]   _zz_Xq_Sum;
  wire       [33:0]   _zz_Xq2C_Sum;
  wire       [47:0]   _zz_Xq2C_Sum_1;
  wire       [33:0]   _zz_Xq2C_Sum_2;
  wire       [31:0]   _zz_XqC_Substract_M2;
  wire       [31:0]   _zz_XqC_Substract_M2_1;
  wire       [47:0]   _zz_Sqrt_In;
  wire       [39:0]   _zz_Sqrt_In_1;
  wire       [47:0]   _zz_Truncated_Success;
  wire       [63:0]   _zz_SAB_Add_Bias;
  wire       [63:0]   _zz_SAB_Add_Bias_1;
  reg                 start_regNext;
  wire                when_SumXq_Stage1_l132;
  reg        [4:0]    Fsm_currentState;
  reg        [4:0]    Fsm_nextState;
  wire                Fsm_Init_End;
  wire                Fsm_Load_Firts_Row_End;
  wire                Fsm_Accumu_End;
  wire                Fsm_Last_Row_Finished;
  wire                when_WaCounter_l19;
  reg        [2:0]    Init_Count_count;
  reg                 Init_Count_valid;
  wire                when_WaCounter_l14;
  wire                when_WaCounter_l19_1;
  reg        [8:0]    Col_Cnt_count;
  reg                 Col_Cnt_valid;
  wire                when_WaCounter_l14_1;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_2;
  wire                sData_fire;
  wire                _zz_Read_Row_Mem_Data;
  wire       [22:0]   Read_Row_Mem_Data;
  wire                sData_fire_1;
  reg                 Read_Row_Mem_Data_Valid;
  wire                sData_fire_2;
  reg                 sData_fire_2_delay_1;
  reg                 sData_fire_2_delay_2;
  reg                 XqC_Valid;
  wire       [22:0]   Write_Row_Mem_Data;
  reg        [8:0]    Col_Cnt_count_delay_1;
  reg        [8:0]    Col_Cnt_count_delay_2;
  reg        [8:0]    Write_Row_Mem_Addr;
  reg        [19:0]   Xq_Sum;
  reg                 Xq_Sum_Clear;
  wire                sData_fire_3;
  reg        [10:0]   sData_payload_delay_1;
  reg        [10:0]   sData_payload_delay_2;
  reg        [10:0]   sData_payload_delay_3;
  reg        [47:0]   Xq2C_Sum;
  reg                 XqC_Valid_delay_1;
  reg                 XqC_Valid_delay_2;
  reg                 Xq2C_Valid;
  reg                 Xq_Sum_Clear_delay_1;
  reg                 Xq_Sum_Clear_delay_2;
  reg                 Xq_Sum_Clear_delay_3;
  reg                 Xq_Sum_Clear_delay_4;
  reg                 Xq_Sum_Clear_delay_5;
  reg                 Xq2C_Sum_Clear;
  reg        [19:0]   Xq_Sum_Old;
  wire       [31:0]   XqC_Substract_M2;
  reg                 Xq_Sum_Clear_delay_1_1;
  reg                 Xq_Sum_Clear_delay_2_1;
  reg                 Xq_Sum_Clear_delay_3_1;
  reg                 Xq_Sum_Clear_delay_4_1;
  reg                 Xq_Sum_Pow_Valid;
  reg                 Sqrt_Out_Valid_1;
  reg        [47:0]   Sqrt_In;
  wire       [31:0]   Sqrt_In_Truncated_1;
  wire                Truncated_Success;
  reg                 Read_Row_Mem_Data_Valid_delay_1;
  reg                 Read_Row_Mem_Data_Valid_delay_2;
  reg                 Read_Row_Mem_Data_Valid_delay_3;
  reg                 Scale_Mul_A_Valid;
  wire                Stage1_0_ScaleMulA_Fifo_io_pop_fire;
  wire                Stage1_0_ScaleMulA_Fifo_io_pop_fire_1;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
  reg                 Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
  reg                 ScaleA_Mul_ReSqrt_Result_Valid;
  wire       [7:0]    Exp_Part;
  wire       [7:0]    Right_Shift_Num0;
  reg        [7:0]    Right_Shift_Num0_delay_1;
  reg        [7:0]    Right_Shift_Num0_delay_2;
  reg        [7:0]    Right_Shift_Num0_delay_3;
  reg        [7:0]    Right_Shift_Num0_delay_4;
  reg        [7:0]    Right_Shift_Num0_delay_5;
  wire       [63:0]   SAB_Shifted;
  wire       [63:0]   SAB_Add_Bias;
  wire       [7:0]    SAB_Add_Bias_Truncated;
  `ifndef SYNTHESIS
  reg [119:0] Fsm_currentState_string;
  reg [119:0] Fsm_nextState_string;
  `endif

  reg [22:0] Row_Mem [0:383];

  assign _zz_Xq_Sum = {{9{sData_payload[10]}}, sData_payload};
  assign _zz_Xq2C_Sum = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_2 = Xq2C_Module_P;
  assign _zz_Xq2C_Sum_1 = {14'd0, _zz_Xq2C_Sum_2};
  assign _zz_XqC_Substract_M2 = {{9{Read_Row_Mem_Data[22]}}, Read_Row_Mem_Data};
  assign _zz_XqC_Substract_M2_1 = {{12{Xq_Sum_Old[19]}}, Xq_Sum_Old};
  assign _zz_Sqrt_In_1 = XqSum_Pow_P;
  assign _zz_Sqrt_In = {8'd0, _zz_Sqrt_In_1};
  assign _zz_Truncated_Success = {16'd0, Sqrt_In_Truncated_1};
  assign _zz_SAB_Add_Bias = SAB_Shifted;
  assign _zz_SAB_Add_Bias_1 = {{56{Bias[7]}}, Bias};
  assign _zz_Row_Mem_port = Write_Row_Mem_Data;
  always @(posedge clk) begin
    if(_zz_Read_Row_Mem_Data) begin
      _zz_Row_Mem_port0 <= Row_Mem[Col_Cnt_count];
    end
  end

  always @(posedge clk) begin
    if(XqC_Valid) begin
      Row_Mem[Write_Row_Mem_Addr] <= _zz_Row_Mem_port;
    end
  end

  XqC XqC_Module (
    .A   (sData_payload[10:0]), //i
    .B   (Channel_Nums[11:0] ), //i
    .P   (XqC_Module_P[22:0] ), //o
    .CLK (clk                )  //i
  );
  Xq2C Xq2C_Module (
    .A   (Xq2C_Module_A[22:0]        ), //i
    .B   (sData_payload_delay_3[10:0]), //i
    .P   (Xq2C_Module_P[33:0]        ), //o
    .CLK (clk                        )  //i
  );
  Xq_Sum_Pow XqSum_Pow (
    .A   (Xq_Sum_Old[19:0] ), //i
    .B   (Xq_Sum_Old[19:0] ), //i
    .P   (XqSum_Pow_P[39:0]), //o
    .CLK (clk              )  //i
  );
  Scale_Multiply_A Scale_Mul_A (
    .A   (XqC_Substract_M2[31:0]), //i
    .B   (Scale[7:0]            ), //i
    .P   (Scale_Mul_A_P[39:0]   ), //o
    .CLK (clk                   )  //i
  );
  Scale_A_Fifo_7 ScaleMulA_Fifo (
    .io_push_valid   (Scale_Mul_A_Valid                   ), //i
    .io_push_ready   (ScaleMulA_Fifo_io_push_ready        ), //o
    .io_push_payload (ScaleMulA_Fifo_io_push_payload[39:0]), //i
    .io_pop_valid    (ScaleMulA_Fifo_io_pop_valid         ), //o
    .io_pop_ready    (Recipro_Sqrt_Result_Valid           ), //i
    .io_pop_payload  (ScaleMulA_Fifo_io_pop_payload[39:0] ), //o
    .io_flush        (1'b0                                ), //i
    .io_occupancy    (ScaleMulA_Fifo_io_occupancy[7:0]    ), //o
    .io_availability (ScaleMulA_Fifo_io_availability[7:0] ), //o
    .clk             (clk                                 ), //i
    .reset           (reset                               )  //i
  );
  Scale_A_ReciproSqrt ScaleA_Mul_ReSqrt (
    .A   (ScaleMulA_Fifo_io_pop_payload[39:0]), //i
    .B   (ScaleA_Mul_ReSqrt_B[23:0]          ), //i
    .P   (ScaleA_Mul_ReSqrt_P[63:0]          ), //o
    .CLK (clk                                )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      SUM_XQ_ENUM_IDLE : Fsm_currentState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_currentState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_currentState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_currentState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_currentState_string = "FINISH_LAST_ROW";
      default : Fsm_currentState_string = "???????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      SUM_XQ_ENUM_IDLE : Fsm_nextState_string = "IDLE           ";
      SUM_XQ_ENUM_INIT : Fsm_nextState_string = "INIT           ";
      SUM_XQ_ENUM_LOAD_FIRST_ROW : Fsm_nextState_string = "LOAD_FIRST_ROW ";
      SUM_XQ_ENUM_ACCUMU : Fsm_nextState_string = "ACCUMU         ";
      SUM_XQ_ENUM_FINISH_LAST_ROW : Fsm_nextState_string = "FINISH_LAST_ROW";
      default : Fsm_nextState_string = "???????????????";
    endcase
  end
  `endif

  assign when_SumXq_Stage1_l132 = (start && (! start_regNext));
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & SUM_XQ_ENUM_IDLE) == SUM_XQ_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l132) begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_INIT) == SUM_XQ_ENUM_INIT) : begin
        if(Fsm_Init_End) begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_INIT;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_LOAD_FIRST_ROW) == SUM_XQ_ENUM_LOAD_FIRST_ROW) : begin
        if(Fsm_Load_Firts_Row_End) begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_LOAD_FIRST_ROW;
        end
      end
      (((Fsm_currentState) & SUM_XQ_ENUM_ACCUMU) == SUM_XQ_ENUM_ACCUMU) : begin
        if(Fsm_Accumu_End) begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_ACCUMU;
        end
      end
      default : begin
        if(Fsm_Last_Row_Finished) begin
          Fsm_nextState = SUM_XQ_ENUM_IDLE;
        end else begin
          Fsm_nextState = SUM_XQ_ENUM_FINISH_LAST_ROW;
        end
      end
    endcase
  end

  assign when_WaCounter_l19 = ((Fsm_currentState & SUM_XQ_ENUM_INIT) != 5'b00000);
  assign when_WaCounter_l14 = (Init_Count_count == 3'b101);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Init_Count_valid = 1'b1;
    end else begin
      Init_Count_valid = 1'b0;
    end
  end

  assign when_WaCounter_l19_1 = ((sData_valid && sData_ready) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign when_WaCounter_l14_1 = (Col_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      Col_Cnt_valid = 1'b1;
    end else begin
      Col_Cnt_valid = 1'b0;
    end
  end

  assign when_WaCounter_l14_2 = (Row_Cnt_count == 5'h19);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign Fsm_Init_End = Init_Count_valid;
  assign Fsm_Load_Firts_Row_End = ((Row_Cnt_count == 5'h0) && Col_Cnt_valid);
  assign Fsm_Accumu_End = Row_Cnt_valid;
  assign Fsm_Last_Row_Finished = Col_Cnt_valid;
  assign sData_ready = ((((Fsm_currentState & SUM_XQ_ENUM_IDLE) == 5'b00000) && ((Fsm_currentState & SUM_XQ_ENUM_INIT) == 5'b00000)) && ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) == 5'b00000));
  assign sData_fire = (sData_valid && sData_ready);
  assign _zz_Read_Row_Mem_Data = (sData_fire || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
  assign Read_Row_Mem_Data = _zz_Row_Mem_port0;
  assign sData_fire_1 = (sData_valid && sData_ready);
  assign sData_fire_2 = (sData_valid && sData_ready);
  assign Write_Row_Mem_Data = XqC_Module_P;
  assign sData_fire_3 = (sData_valid && sData_ready);
  assign Xq2C_Module_A = XqC_Module_P;
  assign XqC_Substract_M2 = ($signed(_zz_XqC_Substract_M2) - $signed(_zz_XqC_Substract_M2_1));
  assign Sqrt_Out_Valid = Sqrt_Out_Valid_1;
  assign Sqrt_In_Truncated_1 = Sqrt_In[31 : 0];
  assign Truncated_Success = (Sqrt_In == _zz_Truncated_Success);
  assign Sqrt_In_Truncated = Sqrt_In_Truncated_1;
  assign Scale_Read_Addr = Col_Cnt_count;
  assign ScaleMulA_Fifo_io_push_payload = Scale_Mul_A_P;
  assign Stage1_0_ScaleMulA_Fifo_io_pop_fire = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign ScaleA_Fifo_Popfire = Stage1_0_ScaleMulA_Fifo_io_pop_fire;
  assign ScaleA_Mul_ReSqrt_B = {1'b1,Recipro_Sqrt_Result[22 : 0]};
  assign Stage1_0_ScaleMulA_Fifo_io_pop_fire_1 = (ScaleMulA_Fifo_io_pop_valid && Recipro_Sqrt_Result_Valid);
  assign Exp_Part = Recipro_Sqrt_Result[30 : 23];
  assign Right_Shift_Num0 = (8'h96 - Exp_Part);
  assign SAB_Shifted = (ScaleA_Mul_ReSqrt_P >>> Right_Shift_Num0_delay_5);
  assign SAB_Add_Bias = ($signed(_zz_SAB_Add_Bias) + $signed(_zz_SAB_Add_Bias_1));
  assign SAB_Add_Bias_Truncated = SAB_Add_Bias[7 : 0];
  assign mData_payload = SAB_Add_Bias_Truncated;
  assign mData_valid = ScaleA_Mul_ReSqrt_Result_Valid;
  always @(posedge clk) begin
    start_regNext <= start;
    Read_Row_Mem_Data_Valid <= ((sData_fire_1 && ((Fsm_currentState & SUM_XQ_ENUM_ACCUMU) != 5'b00000)) || ((Fsm_currentState & SUM_XQ_ENUM_FINISH_LAST_ROW) != 5'b00000));
    sData_fire_2_delay_1 <= sData_fire_2;
    sData_fire_2_delay_2 <= sData_fire_2_delay_1;
    XqC_Valid <= sData_fire_2_delay_2;
    Col_Cnt_count_delay_1 <= Col_Cnt_count;
    Col_Cnt_count_delay_2 <= Col_Cnt_count_delay_1;
    Write_Row_Mem_Addr <= Col_Cnt_count_delay_2;
    Xq_Sum_Clear <= Col_Cnt_valid;
    sData_payload_delay_1 <= sData_payload;
    sData_payload_delay_2 <= sData_payload_delay_1;
    sData_payload_delay_3 <= sData_payload_delay_2;
    XqC_Valid_delay_1 <= XqC_Valid;
    XqC_Valid_delay_2 <= XqC_Valid_delay_1;
    Xq2C_Valid <= XqC_Valid_delay_2;
    Xq_Sum_Clear_delay_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2 <= Xq_Sum_Clear_delay_1;
    Xq_Sum_Clear_delay_3 <= Xq_Sum_Clear_delay_2;
    Xq_Sum_Clear_delay_4 <= Xq_Sum_Clear_delay_3;
    Xq_Sum_Clear_delay_5 <= Xq_Sum_Clear_delay_4;
    Xq2C_Sum_Clear <= Xq_Sum_Clear_delay_5;
    Xq_Sum_Clear_delay_1_1 <= Xq_Sum_Clear;
    Xq_Sum_Clear_delay_2_1 <= Xq_Sum_Clear_delay_1_1;
    Xq_Sum_Clear_delay_3_1 <= Xq_Sum_Clear_delay_2_1;
    Xq_Sum_Clear_delay_4_1 <= Xq_Sum_Clear_delay_3_1;
    Xq_Sum_Pow_Valid <= Xq_Sum_Clear_delay_4_1;
    Sqrt_Out_Valid_1 <= Xq2C_Sum_Clear;
    Read_Row_Mem_Data_Valid_delay_1 <= Read_Row_Mem_Data_Valid;
    Read_Row_Mem_Data_Valid_delay_2 <= Read_Row_Mem_Data_Valid_delay_1;
    Read_Row_Mem_Data_Valid_delay_3 <= Read_Row_Mem_Data_Valid_delay_2;
    Scale_Mul_A_Valid <= Read_Row_Mem_Data_Valid_delay_3;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_1 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_2 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_1;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_3 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_2;
    Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_4 <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_3;
    ScaleA_Mul_ReSqrt_Result_Valid <= Stage1_0_ScaleMulA_Fifo_io_pop_fire_1_delay_4;
    Right_Shift_Num0_delay_1 <= Right_Shift_Num0;
    Right_Shift_Num0_delay_2 <= Right_Shift_Num0_delay_1;
    Right_Shift_Num0_delay_3 <= Right_Shift_Num0_delay_2;
    Right_Shift_Num0_delay_4 <= Right_Shift_Num0_delay_3;
    Right_Shift_Num0_delay_5 <= Right_Shift_Num0_delay_4;
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= SUM_XQ_ENUM_IDLE;
      Init_Count_count <= 3'b000;
      Col_Cnt_count <= 9'h0;
      Row_Cnt_count <= 5'h0;
      Xq_Sum <= 20'h0;
      Xq2C_Sum <= 48'h0;
      Xq_Sum_Old <= 20'h0;
      Sqrt_In <= 48'h0;
    end else begin
      Fsm_currentState <= Fsm_nextState;
      if(when_WaCounter_l19) begin
        Init_Count_count <= (Init_Count_count + 3'b001);
        if(Init_Count_valid) begin
          Init_Count_count <= 3'b000;
        end
      end
      if(when_WaCounter_l19_1) begin
        Col_Cnt_count <= (Col_Cnt_count + 9'h001);
        if(Col_Cnt_valid) begin
          Col_Cnt_count <= 9'h0;
        end
      end
      if(Col_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
      if(sData_fire_3) begin
        if(Xq_Sum_Clear) begin
          Xq_Sum <= {{9{sData_payload[10]}}, sData_payload};
        end else begin
          Xq_Sum <= ($signed(Xq_Sum) + $signed(_zz_Xq_Sum));
        end
      end
      if(Xq2C_Valid) begin
        if(Xq2C_Sum_Clear) begin
          Xq2C_Sum <= {14'd0, _zz_Xq2C_Sum};
        end else begin
          Xq2C_Sum <= (Xq2C_Sum + _zz_Xq2C_Sum_1);
        end
      end
      if(Xq_Sum_Clear) begin
        Xq_Sum_Old <= Xq_Sum;
      end
      if(Xq2C_Sum_Clear) begin
        Sqrt_In <= (Xq2C_Sum - _zz_Sqrt_In);
      end
    end
  end


endmodule

module Reci_Sqrt_Compute (
  input               Sqrt_In_Valid_0,
  input               Sqrt_In_Valid_1,
  input               Sqrt_In_Valid_2,
  input               Sqrt_In_Valid_3,
  input               Sqrt_In_Valid_4,
  input               Sqrt_In_Valid_5,
  input               Sqrt_In_Valid_6,
  input               Sqrt_In_Valid_7,
  input      [31:0]   Sqrt_In_Truncated_0,
  input      [31:0]   Sqrt_In_Truncated_1,
  input      [31:0]   Sqrt_In_Truncated_2,
  input      [31:0]   Sqrt_In_Truncated_3,
  input      [31:0]   Sqrt_In_Truncated_4,
  input      [31:0]   Sqrt_In_Truncated_5,
  input      [31:0]   Sqrt_In_Truncated_6,
  input      [31:0]   Sqrt_In_Truncated_7,
  input               ScaleA_Fifo_Popfire,
  output     [31:0]   Recipro_Sqrt_Result_Latch_0,
  output     [31:0]   Recipro_Sqrt_Result_Latch_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_2,
  output     [31:0]   Recipro_Sqrt_Result_Latch_3,
  output     [31:0]   Recipro_Sqrt_Result_Latch_4,
  output     [31:0]   Recipro_Sqrt_Result_Latch_5,
  output     [31:0]   Recipro_Sqrt_Result_Latch_6,
  output     [31:0]   Recipro_Sqrt_Result_Latch_7,
  output              Recipro_Sqrt_Result_Valid,
  output     [8:0]    Bias_Read_Addr,
  input               clk,
  output     [31:0]   Recipro_Sqrt_Result_Latch_0_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_1_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_2_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_3_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_4_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_5_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_6_1,
  output     [31:0]   Recipro_Sqrt_Result_Latch_7_1,
  input               reset
);
  localparam SQRT_COMPUTE_ENUM_COMPUTE_0 = 9'd1;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_1 = 9'd2;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_2 = 9'd4;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_3 = 9'd8;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_4 = 9'd16;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_5 = 9'd32;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_6 = 9'd64;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_7 = 9'd128;
  localparam SQRT_COMPUTE_ENUM_COMPUTE_8 = 9'd256;
  localparam SCALEA_MUL_RESQRT_ENUM_IDLE = 3'd1;
  localparam SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID = 3'd2;
  localparam SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN = 3'd4;

  reg                 Fi32_2_Single_s_axis_a_tvalid;
  wire                Fi32_2_Single_s_axis_a_tready;
  wire       [31:0]   Fi32_2_Single_m_axis_result_tdata;
  wire                Fi32_2_Single_m_axis_result_tvalid;
  wire                Reci_Sqrt_s_axis_a_tready;
  wire       [31:0]   Reci_Sqrt_m_axis_result_tdata;
  wire                Reci_Sqrt_m_axis_result_tvalid;
  reg        [8:0]    Sqrt_Compute_Fsm_currentState;
  reg        [8:0]    Sqrt_Compute_Fsm_nextState;
  wire                Sqrt_Compute_Fsm_Data_Sended;
  wire                Sqrt_Compute_Fsm_Send_Data_0;
  wire                Sqrt_Compute_Fsm_Send_Data_1;
  wire                Sqrt_Compute_Fsm_Send_Data_2;
  wire                Sqrt_Compute_Fsm_Send_Data_3;
  wire                Sqrt_Compute_Fsm_Send_Data_4;
  wire                Sqrt_Compute_Fsm_Send_Data_5;
  wire                Sqrt_Compute_Fsm_Send_Data_6;
  wire                Sqrt_Compute_Fsm_Send_Data_7;
  wire                Sqrt_Compute_Fsm_Send_Data_8;
  reg        [2:0]    Recipro_Pointer_Result_count;
  reg                 Recipro_Pointer_Result_valid;
  wire                when_WaCounter_l14;
  wire                when_SumXq_Stage1_l219;
  reg        [2:0]    SAB_Fsm_currentState;
  reg        [2:0]    SAB_Fsm_nextState;
  wire                SAB_Fsm_ScaleA_Mul_ReSqrt_End;
  wire                SAB_Fsm_Row_All_Computed;
  wire                when_SumXq_Stage1_l228;
  reg        [8:0]    SAB_Cnt_count;
  reg                 SAB_Cnt_valid;
  wire                when_WaCounter_l14_1;
  wire                when_WaCounter_l19;
  reg        [8:0]    _zz_Bias_Read_Addr;
  reg                 _zz_1;
  wire                when_WaCounter_l14_2;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_0_1_regNext;
  reg                 SAB_Cnt_valid_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_0_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_1_1_regNext;
  reg                 SAB_Cnt_valid_regNext_1;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_1_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_2_1_regNext;
  reg                 SAB_Cnt_valid_regNext_2;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_2_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_3_1_regNext;
  reg                 SAB_Cnt_valid_regNext_3;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_3_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_4_1_regNext;
  reg                 SAB_Cnt_valid_regNext_4;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_4_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_5_1_regNext;
  reg                 SAB_Cnt_valid_regNext_5;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_5_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_6_1_regNext;
  reg                 SAB_Cnt_valid_regNext_6;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_6_regNext;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_7_1_regNext;
  reg                 SAB_Cnt_valid_regNext_7;
  reg        [31:0]   Recipro_Sqrt_Result_Latch_7_regNext;
  wire                when_WaCounter_l19_1;
  reg        [2:0]    Recipro_Pointer_DataIn_count;
  reg                 Recipro_Pointer_DataIn_valid;
  wire                when_WaCounter_l14_3;
  reg        [31:0]   _zz_s_axis_a_tdata;
  reg        [4:0]    Row_Cnt_count;
  reg                 Row_Cnt_valid;
  wire                when_WaCounter_l14_4;
  `ifndef SYNTHESIS
  reg [71:0] Sqrt_Compute_Fsm_currentState_string;
  reg [71:0] Sqrt_Compute_Fsm_nextState_string;
  reg [143:0] SAB_Fsm_currentState_string;
  reg [143:0] SAB_Fsm_nextState_string;
  `endif


  Fi32_to_Single Fi32_2_Single (
    .s_axis_a_tdata       (_zz_s_axis_a_tdata[31:0]               ), //i
    .s_axis_a_tready      (Fi32_2_Single_s_axis_a_tready          ), //o
    .s_axis_a_tvalid      (Fi32_2_Single_s_axis_a_tvalid          ), //i
    .aclk                 (clk                                    ), //i
    .m_axis_result_tdata  (Fi32_2_Single_m_axis_result_tdata[31:0]), //o
    .m_axis_result_tready (Reci_Sqrt_s_axis_a_tready              ), //i
    .m_axis_result_tvalid (Fi32_2_Single_m_axis_result_tvalid     )  //o
  );
  Reciprocal_Sqrt Reci_Sqrt (
    .s_axis_a_tdata       (Fi32_2_Single_m_axis_result_tdata[31:0]), //i
    .s_axis_a_tready      (Reci_Sqrt_s_axis_a_tready              ), //o
    .s_axis_a_tvalid      (Fi32_2_Single_m_axis_result_tvalid     ), //i
    .aclk                 (clk                                    ), //i
    .m_axis_result_tdata  (Reci_Sqrt_m_axis_result_tdata[31:0]    ), //o
    .m_axis_result_tready (1'b1                                   ), //i
    .m_axis_result_tvalid (Reci_Sqrt_m_axis_result_tvalid         )  //o
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(Sqrt_Compute_Fsm_currentState)
      SQRT_COMPUTE_ENUM_COMPUTE_0 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_0";
      SQRT_COMPUTE_ENUM_COMPUTE_1 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_1";
      SQRT_COMPUTE_ENUM_COMPUTE_2 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_2";
      SQRT_COMPUTE_ENUM_COMPUTE_3 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_3";
      SQRT_COMPUTE_ENUM_COMPUTE_4 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_4";
      SQRT_COMPUTE_ENUM_COMPUTE_5 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_5";
      SQRT_COMPUTE_ENUM_COMPUTE_6 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_6";
      SQRT_COMPUTE_ENUM_COMPUTE_7 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_7";
      SQRT_COMPUTE_ENUM_COMPUTE_8 : Sqrt_Compute_Fsm_currentState_string = "COMPUTE_8";
      default : Sqrt_Compute_Fsm_currentState_string = "?????????";
    endcase
  end
  always @(*) begin
    case(Sqrt_Compute_Fsm_nextState)
      SQRT_COMPUTE_ENUM_COMPUTE_0 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_0";
      SQRT_COMPUTE_ENUM_COMPUTE_1 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_1";
      SQRT_COMPUTE_ENUM_COMPUTE_2 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_2";
      SQRT_COMPUTE_ENUM_COMPUTE_3 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_3";
      SQRT_COMPUTE_ENUM_COMPUTE_4 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_4";
      SQRT_COMPUTE_ENUM_COMPUTE_5 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_5";
      SQRT_COMPUTE_ENUM_COMPUTE_6 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_6";
      SQRT_COMPUTE_ENUM_COMPUTE_7 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_7";
      SQRT_COMPUTE_ENUM_COMPUTE_8 : Sqrt_Compute_Fsm_nextState_string = "COMPUTE_8";
      default : Sqrt_Compute_Fsm_nextState_string = "?????????";
    endcase
  end
  always @(*) begin
    case(SAB_Fsm_currentState)
      SCALEA_MUL_RESQRT_ENUM_IDLE : SAB_Fsm_currentState_string = "IDLE              ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID : SAB_Fsm_currentState_string = "RESQRT_VALID      ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN : SAB_Fsm_currentState_string = "RESQRT_VALID_AGAIN";
      default : SAB_Fsm_currentState_string = "??????????????????";
    endcase
  end
  always @(*) begin
    case(SAB_Fsm_nextState)
      SCALEA_MUL_RESQRT_ENUM_IDLE : SAB_Fsm_nextState_string = "IDLE              ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID : SAB_Fsm_nextState_string = "RESQRT_VALID      ";
      SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN : SAB_Fsm_nextState_string = "RESQRT_VALID_AGAIN";
      default : SAB_Fsm_nextState_string = "??????????????????";
    endcase
  end
  `endif

  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_0) == SQRT_COMPUTE_ENUM_COMPUTE_0) : begin
        if(Sqrt_Compute_Fsm_Send_Data_0) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_1;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_0;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_1) == SQRT_COMPUTE_ENUM_COMPUTE_1) : begin
        if(Sqrt_Compute_Fsm_Send_Data_1) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_2;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_1;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_2) == SQRT_COMPUTE_ENUM_COMPUTE_2) : begin
        if(Sqrt_Compute_Fsm_Send_Data_2) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_3;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_2;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_3) == SQRT_COMPUTE_ENUM_COMPUTE_3) : begin
        if(Sqrt_Compute_Fsm_Send_Data_3) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_4;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_3;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_4) == SQRT_COMPUTE_ENUM_COMPUTE_4) : begin
        if(Sqrt_Compute_Fsm_Send_Data_4) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_5;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_4;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_5) == SQRT_COMPUTE_ENUM_COMPUTE_5) : begin
        if(Sqrt_Compute_Fsm_Send_Data_5) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_6;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_5;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_6) == SQRT_COMPUTE_ENUM_COMPUTE_6) : begin
        if(Sqrt_Compute_Fsm_Send_Data_6) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_7;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_6;
        end
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_7) == SQRT_COMPUTE_ENUM_COMPUTE_7) : begin
        if(Sqrt_Compute_Fsm_Send_Data_7) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_8;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_7;
        end
      end
      default : begin
        if(Sqrt_Compute_Fsm_Send_Data_8) begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_0;
        end else begin
          Sqrt_Compute_Fsm_nextState = SQRT_COMPUTE_ENUM_COMPUTE_8;
        end
      end
    endcase
  end

  assign Sqrt_Compute_Fsm_Send_Data_0 = (Sqrt_In_Valid_0 && Fi32_2_Single_s_axis_a_tready);
  assign Sqrt_Compute_Fsm_Send_Data_1 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_2 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_3 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_4 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_5 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_6 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_7 = Fi32_2_Single_s_axis_a_tready;
  assign Sqrt_Compute_Fsm_Send_Data_8 = Fi32_2_Single_s_axis_a_tready;
  assign when_WaCounter_l14 = (Recipro_Pointer_Result_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l14) begin
      Recipro_Pointer_Result_valid = 1'b1;
    end else begin
      Recipro_Pointer_Result_valid = 1'b0;
    end
  end

  assign when_SumXq_Stage1_l219 = (Recipro_Pointer_Result_count == 3'b111);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((SAB_Fsm_currentState) & SCALEA_MUL_RESQRT_ENUM_IDLE) == SCALEA_MUL_RESQRT_ENUM_IDLE) : begin
        if(when_SumXq_Stage1_l219) begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
        end else begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
        end
      end
      (((SAB_Fsm_currentState) & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) == SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) : begin
        if(SAB_Fsm_Row_All_Computed) begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
        end else begin
          if(when_SumXq_Stage1_l228) begin
            SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
          end else begin
            if(when_SumXq_Stage1_l219) begin
              SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN;
            end else begin
              if(SAB_Fsm_ScaleA_Mul_ReSqrt_End) begin
                SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
              end else begin
                SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
              end
            end
          end
        end
      end
      default : begin
        if(SAB_Fsm_Row_All_Computed) begin
          SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_IDLE;
        end else begin
          if(SAB_Fsm_ScaleA_Mul_ReSqrt_End) begin
            SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID;
          end else begin
            SAB_Fsm_nextState = SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN;
          end
        end
      end
    endcase
  end

  assign when_SumXq_Stage1_l228 = (when_SumXq_Stage1_l219 && SAB_Fsm_ScaleA_Mul_ReSqrt_End);
  assign when_WaCounter_l14_1 = (SAB_Cnt_count == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_1) begin
      SAB_Cnt_valid = 1'b1;
    end else begin
      SAB_Cnt_valid = 1'b0;
    end
  end

  assign SAB_Fsm_ScaleA_Mul_ReSqrt_End = SAB_Cnt_valid;
  assign Recipro_Sqrt_Result_Valid = (((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID_AGAIN) != 3'b000));
  assign when_WaCounter_l19 = ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000);
  assign when_WaCounter_l14_2 = (_zz_Bias_Read_Addr == 9'h17f);
  always @(*) begin
    if(when_WaCounter_l14_2) begin
      _zz_1 = 1'b1;
    end else begin
      _zz_1 = 1'b0;
    end
  end

  assign Bias_Read_Addr = _zz_Bias_Read_Addr;
  assign Recipro_Sqrt_Result_Latch_0_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b000)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_0_1_regNext);
  assign Recipro_Sqrt_Result_Latch_0 = (((SAB_Cnt_valid_regNext && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_0_1 : Recipro_Sqrt_Result_Latch_0_regNext);
  assign Recipro_Sqrt_Result_Latch_1_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b001)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_1_1_regNext);
  assign Recipro_Sqrt_Result_Latch_1 = (((SAB_Cnt_valid_regNext_1 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_1_1 : Recipro_Sqrt_Result_Latch_1_regNext);
  assign Recipro_Sqrt_Result_Latch_2_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b010)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_2_1_regNext);
  assign Recipro_Sqrt_Result_Latch_2 = (((SAB_Cnt_valid_regNext_2 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_2_1 : Recipro_Sqrt_Result_Latch_2_regNext);
  assign Recipro_Sqrt_Result_Latch_3_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b011)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_3_1_regNext);
  assign Recipro_Sqrt_Result_Latch_3 = (((SAB_Cnt_valid_regNext_3 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_3_1 : Recipro_Sqrt_Result_Latch_3_regNext);
  assign Recipro_Sqrt_Result_Latch_4_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b100)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_4_1_regNext);
  assign Recipro_Sqrt_Result_Latch_4 = (((SAB_Cnt_valid_regNext_4 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_4_1 : Recipro_Sqrt_Result_Latch_4_regNext);
  assign Recipro_Sqrt_Result_Latch_5_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b101)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_5_1_regNext);
  assign Recipro_Sqrt_Result_Latch_5 = (((SAB_Cnt_valid_regNext_5 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_5_1 : Recipro_Sqrt_Result_Latch_5_regNext);
  assign Recipro_Sqrt_Result_Latch_6_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b110)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_6_1_regNext);
  assign Recipro_Sqrt_Result_Latch_6 = (((SAB_Cnt_valid_regNext_6 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_6_1 : Recipro_Sqrt_Result_Latch_6_regNext);
  assign Recipro_Sqrt_Result_Latch_7_1 = ((Reci_Sqrt_m_axis_result_tvalid && (Recipro_Pointer_Result_count == 3'b111)) ? Reci_Sqrt_m_axis_result_tdata : Recipro_Sqrt_Result_Latch_7_1_regNext);
  assign Recipro_Sqrt_Result_Latch_7 = (((SAB_Cnt_valid_regNext_7 && ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_RESQRT_VALID) != 3'b000)) || ((SAB_Fsm_currentState & SCALEA_MUL_RESQRT_ENUM_IDLE) != 3'b000)) ? Recipro_Sqrt_Result_Latch_7_1 : Recipro_Sqrt_Result_Latch_7_regNext);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_1) == SQRT_COMPUTE_ENUM_COMPUTE_1) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_2) == SQRT_COMPUTE_ENUM_COMPUTE_2) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_3) == SQRT_COMPUTE_ENUM_COMPUTE_3) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_4) == SQRT_COMPUTE_ENUM_COMPUTE_4) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_5) == SQRT_COMPUTE_ENUM_COMPUTE_5) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_6) == SQRT_COMPUTE_ENUM_COMPUTE_6) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_7) == SQRT_COMPUTE_ENUM_COMPUTE_7) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      (((Sqrt_Compute_Fsm_currentState) & SQRT_COMPUTE_ENUM_COMPUTE_8) == SQRT_COMPUTE_ENUM_COMPUTE_8) : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b1;
      end
      default : begin
        Fi32_2_Single_s_axis_a_tvalid = 1'b0;
      end
    endcase
  end

  assign when_WaCounter_l19_1 = (Fi32_2_Single_s_axis_a_tvalid && Fi32_2_Single_s_axis_a_tready);
  assign when_WaCounter_l14_3 = (Recipro_Pointer_DataIn_count == 3'b111);
  always @(*) begin
    if(when_WaCounter_l14_3) begin
      Recipro_Pointer_DataIn_valid = 1'b1;
    end else begin
      Recipro_Pointer_DataIn_valid = 1'b0;
    end
  end

  always @(*) begin
    case(Recipro_Pointer_DataIn_count)
      3'b000 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_0;
      end
      3'b001 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_1;
      end
      3'b010 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_2;
      end
      3'b011 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_3;
      end
      3'b100 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_4;
      end
      3'b101 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_5;
      end
      3'b110 : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_6;
      end
      default : begin
        _zz_s_axis_a_tdata = Sqrt_In_Truncated_7;
      end
    endcase
  end

  assign when_WaCounter_l14_4 = (Row_Cnt_count == 5'h18);
  always @(*) begin
    if(when_WaCounter_l14_4) begin
      Row_Cnt_valid = 1'b1;
    end else begin
      Row_Cnt_valid = 1'b0;
    end
  end

  assign SAB_Fsm_Row_All_Computed = (Row_Cnt_valid && SAB_Cnt_valid);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Sqrt_Compute_Fsm_currentState <= SQRT_COMPUTE_ENUM_COMPUTE_0;
      Recipro_Pointer_Result_count <= 3'b000;
      SAB_Fsm_currentState <= SCALEA_MUL_RESQRT_ENUM_IDLE;
      SAB_Cnt_count <= 9'h0;
      _zz_Bias_Read_Addr <= 9'h0;
      Recipro_Pointer_DataIn_count <= 3'b000;
      Row_Cnt_count <= 5'h0;
    end else begin
      Sqrt_Compute_Fsm_currentState <= Sqrt_Compute_Fsm_nextState;
      if(Reci_Sqrt_m_axis_result_tvalid) begin
        Recipro_Pointer_Result_count <= (Recipro_Pointer_Result_count + 3'b001);
        if(Recipro_Pointer_Result_valid) begin
          Recipro_Pointer_Result_count <= 3'b000;
        end
      end
      SAB_Fsm_currentState <= SAB_Fsm_nextState;
      if(ScaleA_Fifo_Popfire) begin
        SAB_Cnt_count <= (SAB_Cnt_count + 9'h001);
        if(SAB_Cnt_valid) begin
          SAB_Cnt_count <= 9'h0;
        end
      end
      if(when_WaCounter_l19) begin
        _zz_Bias_Read_Addr <= (_zz_Bias_Read_Addr + 9'h001);
        if(_zz_1) begin
          _zz_Bias_Read_Addr <= 9'h0;
        end
      end
      if(when_WaCounter_l19_1) begin
        Recipro_Pointer_DataIn_count <= (Recipro_Pointer_DataIn_count + 3'b001);
        if(Recipro_Pointer_DataIn_valid) begin
          Recipro_Pointer_DataIn_count <= 3'b000;
        end
      end
      if(SAB_Cnt_valid) begin
        Row_Cnt_count <= (Row_Cnt_count + 5'h01);
        if(Row_Cnt_valid) begin
          Row_Cnt_count <= 5'h0;
        end
      end
    end
  end

  always @(posedge clk) begin
    Recipro_Sqrt_Result_Latch_0_1_regNext <= Recipro_Sqrt_Result_Latch_0_1;
    SAB_Cnt_valid_regNext <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_0_regNext <= Recipro_Sqrt_Result_Latch_0;
    Recipro_Sqrt_Result_Latch_1_1_regNext <= Recipro_Sqrt_Result_Latch_1_1;
    SAB_Cnt_valid_regNext_1 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_1_regNext <= Recipro_Sqrt_Result_Latch_1;
    Recipro_Sqrt_Result_Latch_2_1_regNext <= Recipro_Sqrt_Result_Latch_2_1;
    SAB_Cnt_valid_regNext_2 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_2_regNext <= Recipro_Sqrt_Result_Latch_2;
    Recipro_Sqrt_Result_Latch_3_1_regNext <= Recipro_Sqrt_Result_Latch_3_1;
    SAB_Cnt_valid_regNext_3 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_3_regNext <= Recipro_Sqrt_Result_Latch_3;
    Recipro_Sqrt_Result_Latch_4_1_regNext <= Recipro_Sqrt_Result_Latch_4_1;
    SAB_Cnt_valid_regNext_4 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_4_regNext <= Recipro_Sqrt_Result_Latch_4;
    Recipro_Sqrt_Result_Latch_5_1_regNext <= Recipro_Sqrt_Result_Latch_5_1;
    SAB_Cnt_valid_regNext_5 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_5_regNext <= Recipro_Sqrt_Result_Latch_5;
    Recipro_Sqrt_Result_Latch_6_1_regNext <= Recipro_Sqrt_Result_Latch_6_1;
    SAB_Cnt_valid_regNext_6 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_6_regNext <= Recipro_Sqrt_Result_Latch_6;
    Recipro_Sqrt_Result_Latch_7_1_regNext <= Recipro_Sqrt_Result_Latch_7_1;
    SAB_Cnt_valid_regNext_7 <= SAB_Cnt_valid;
    Recipro_Sqrt_Result_Latch_7_regNext <= Recipro_Sqrt_Result_Latch_7;
  end


endmodule

//Scale_A_Fifo replaced by Scale_A_Fifo_7

//Scale_A_Fifo_1 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_2 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_3 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_4 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_5 replaced by Scale_A_Fifo_7

//Scale_A_Fifo_6 replaced by Scale_A_Fifo_7

module Scale_A_Fifo_7 (
  input               io_push_valid,
  output              io_push_ready,
  input      [39:0]   io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [39:0]   io_pop_payload,
  input               io_flush,
  output     [7:0]    io_occupancy,
  output     [7:0]    io_availability,
  input               clk,
  input               reset
);

  reg        [39:0]   _zz_logic_ram_port0;
  wire       [6:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [6:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [39:0]   _zz_logic_ram_port_1;
  wire       [6:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [6:0]    logic_pushPtr_valueNext;
  reg        [6:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [6:0]    logic_popPtr_valueNext;
  reg        [6:0]    logic_popPtr_value;
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
  wire       [6:0]    logic_ptrDif;
  reg [39:0] logic_ram [0:127];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {6'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {6'd0, _zz_logic_popPtr_valueNext_1};
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

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 7'h7f);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 7'h0;
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

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 7'h7f);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 7'h0;
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
      logic_pushPtr_value <= 7'h0;
      logic_popPtr_value <= 7'h0;
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
