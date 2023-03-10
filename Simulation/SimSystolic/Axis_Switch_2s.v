// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Axis_Switch_2s
// Git hash  : 3f47e2272714eaadc4903fce7d57faff55e9534d

`timescale 1ns/1ps

module Axis_Switch_2s (
  input      [1:0]    Switch,
  output reg [63:0]   m0_axis_mm2s_tdata,
  output reg [7:0]    m0_axis_mm2s_tkeep,
  output reg          m0_axis_mm2s_tlast,
  input               m0_axis_mm2s_tready,
  output reg          m0_axis_mm2s_tvalid,
  input      [63:0]   s_0_axis_s2mm_tdata,
  input      [7:0]    s_0_axis_s2mm_tkeep,
  input               s_0_axis_s2mm_tlast,
  output reg          s_0_axis_s2mm_tready,
  input               s_0_axis_s2mm_tvalid,
  input      [63:0]   s_1_axis_s2mm_tdata,
  input      [7:0]    s_1_axis_s2mm_tkeep,
  input               s_1_axis_s2mm_tlast,
  output reg          s_1_axis_s2mm_tready,
  input               s_1_axis_s2mm_tvalid,
  input      [63:0]   s_2_axis_s2mm_tdata,
  input      [7:0]    s_2_axis_s2mm_tkeep,
  input               s_2_axis_s2mm_tlast,
  output reg          s_2_axis_s2mm_tready,
  input               s_2_axis_s2mm_tvalid
);

  wire                when_Axis_Switch_l141;
  wire                when_Axis_Switch_l141_1;
  wire                when_Axis_Switch_l141_2;

  always @(*) begin
    s_0_axis_s2mm_tready = 1'b0;
    if(when_Axis_Switch_l141) begin
      s_0_axis_s2mm_tready = m0_axis_mm2s_tready;
    end
  end

  always @(*) begin
    s_1_axis_s2mm_tready = 1'b0;
    if(when_Axis_Switch_l141_1) begin
      s_1_axis_s2mm_tready = m0_axis_mm2s_tready;
    end
  end

  always @(*) begin
    s_2_axis_s2mm_tready = 1'b0;
    if(when_Axis_Switch_l141_2) begin
      s_2_axis_s2mm_tready = m0_axis_mm2s_tready;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tdata = 64'h0;
    if(when_Axis_Switch_l141) begin
      m0_axis_mm2s_tdata = s_0_axis_s2mm_tdata;
    end
    if(when_Axis_Switch_l141_1) begin
      m0_axis_mm2s_tdata = s_1_axis_s2mm_tdata;
    end
    if(when_Axis_Switch_l141_2) begin
      m0_axis_mm2s_tdata = s_2_axis_s2mm_tdata;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tkeep = 8'h0;
    if(when_Axis_Switch_l141) begin
      m0_axis_mm2s_tkeep = s_0_axis_s2mm_tkeep;
    end
    if(when_Axis_Switch_l141_1) begin
      m0_axis_mm2s_tkeep = s_1_axis_s2mm_tkeep;
    end
    if(when_Axis_Switch_l141_2) begin
      m0_axis_mm2s_tkeep = s_2_axis_s2mm_tkeep;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tlast = 1'b0;
    if(when_Axis_Switch_l141) begin
      m0_axis_mm2s_tlast = s_0_axis_s2mm_tlast;
    end
    if(when_Axis_Switch_l141_1) begin
      m0_axis_mm2s_tlast = s_1_axis_s2mm_tlast;
    end
    if(when_Axis_Switch_l141_2) begin
      m0_axis_mm2s_tlast = s_2_axis_s2mm_tlast;
    end
  end

  always @(*) begin
    m0_axis_mm2s_tvalid = 1'b0;
    if(when_Axis_Switch_l141) begin
      m0_axis_mm2s_tvalid = s_0_axis_s2mm_tvalid;
    end
    if(when_Axis_Switch_l141_1) begin
      m0_axis_mm2s_tvalid = s_1_axis_s2mm_tvalid;
    end
    if(when_Axis_Switch_l141_2) begin
      m0_axis_mm2s_tvalid = s_2_axis_s2mm_tvalid;
    end
  end

  assign when_Axis_Switch_l141 = (Switch == 2'b00);
  assign when_Axis_Switch_l141_1 = (Switch == 2'b01);
  assign when_Axis_Switch_l141_2 = (Switch == 2'b10);

endmodule
