// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : WidthConvert
// Git hash  : 4d8d30214f19f846ea29697bc4a8c9ccb188f4ed

`timescale 1ns/1ps

module WidthConvert (
  input               io_InData_valid,
  output              io_InData_ready,
  input      [63:0]   io_InData_payload,
  output     [7:0]    io_OutData,
  input               clk,
  input               reset
);

  reg        [7:0]    Regs_0;
  reg        [7:0]    Regs_1;
  reg        [7:0]    Regs_2;
  reg        [7:0]    Regs_3;
  reg        [7:0]    Regs_4;
  reg        [7:0]    Regs_5;
  reg        [7:0]    Regs_6;
  reg        [7:0]    Regs_7;
  reg        [7:0]    Regs_1_regNext;
  reg        [7:0]    Regs_2_regNext;
  reg        [7:0]    Regs_3_regNext;
  reg        [7:0]    Regs_4_regNext;
  reg        [7:0]    Regs_5_regNext;
  reg        [7:0]    Regs_6_regNext;
  reg        [7:0]    Regs_7_regNext;

  assign io_OutData = Regs_0;
  assign io_InData_ready = 1'b1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Regs_0 <= 8'h0;
      Regs_1 <= 8'h0;
      Regs_2 <= 8'h0;
      Regs_3 <= 8'h0;
      Regs_4 <= 8'h0;
      Regs_5 <= 8'h0;
      Regs_6 <= 8'h0;
      Regs_7 <= 8'h0;
    end else begin
      if(io_InData_valid) begin
        Regs_0 <= io_InData_payload[7 : 0];
        Regs_1 <= io_InData_payload[15 : 8];
        Regs_2 <= io_InData_payload[23 : 16];
        Regs_3 <= io_InData_payload[31 : 24];
        Regs_4 <= io_InData_payload[39 : 32];
        Regs_5 <= io_InData_payload[47 : 40];
        Regs_6 <= io_InData_payload[55 : 48];
        Regs_7 <= io_InData_payload[63 : 56];
      end else begin
        Regs_0 <= Regs_1_regNext;
        Regs_1 <= Regs_2_regNext;
        Regs_2 <= Regs_3_regNext;
        Regs_3 <= Regs_4_regNext;
        Regs_4 <= Regs_5_regNext;
        Regs_5 <= Regs_6_regNext;
        Regs_6 <= Regs_7_regNext;
      end
    end
  end

  always @(posedge clk) begin
    Regs_1_regNext <= Regs_1;
    Regs_2_regNext <= Regs_2;
    Regs_3_regNext <= Regs_3;
    Regs_4_regNext <= Regs_4;
    Regs_5_regNext <= Regs_5;
    Regs_6_regNext <= Regs_6;
    Regs_7_regNext <= Regs_7;
  end


endmodule
