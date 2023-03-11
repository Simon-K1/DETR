// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : Axis_Switch_1s
// Git hash  : 38ca0002442a53854501226aaa32895051626a31

`timescale 1ns/1ps

module Axis_Switch_1s (
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
