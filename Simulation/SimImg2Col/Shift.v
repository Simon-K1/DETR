// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Shift
// Git hash  : 65274c824c17f2bbb1351900968c613abe7e8bef

`timescale 1ns/1ps

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
