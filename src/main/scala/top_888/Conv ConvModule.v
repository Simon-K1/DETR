//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2.2 (win64) Build 2348494 Mon Oct  1 18:25:44 MDT 2018
//Date        : Tue May  9 16:08:51 2023
//Host        : DESKTOP-5L5R6GM running 64-bit major release  (build 9200)
//Command     : generate_target PS_RW_PL_DDR_wrapper.bd
//Design      : PS_RW_PL_DDR_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Top
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb


);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
//  output [31:0]M01_AXI_0_araddr;
//  output [2:0]M01_AXI_0_arprot;
//  input [0:0]M01_AXI_0_arready;
//  output [0:0]M01_AXI_0_arvalid;
//  output [31:0]M01_AXI_0_awaddr;
//  output [2:0]M01_AXI_0_awprot;
//  input [0:0]M01_AXI_0_awready;
//  output [0:0]M01_AXI_0_awvalid;
//  output [0:0]M01_AXI_0_bready;
//  input [1:0]M01_AXI_0_bresp;
//  input [0:0]M01_AXI_0_bvalid;
//  input [31:0]M01_AXI_0_rdata;
//  output [0:0]M01_AXI_0_rready;
//  input [1:0]M01_AXI_0_rresp;
//  input [0:0]M01_AXI_0_rvalid;
//  output [31:0]M01_AXI_0_wdata;
//  input [0:0]M01_AXI_0_wready;
//  output [3:0]M01_AXI_0_wstrb;
//  output [0:0]M01_AXI_0_wvalid;
//  output [63:0]M_AXIS_MM2S_0_tdata;
//  output [7:0]M_AXIS_MM2S_0_tkeep;
//  output M_AXIS_MM2S_0_tlast;
//  input M_AXIS_MM2S_0_tready;
//  output M_AXIS_MM2S_0_tvalid;
//  input [63:0]S_AXIS_S2MM_0_tdata;
//  input [7:0]S_AXIS_S2MM_0_tkeep;
//  input S_AXIS_S2MM_0_tlast;
//  output S_AXIS_S2MM_0_tready;
//  input S_AXIS_S2MM_0_tvalid;
  output clk;
  output [0:0]rst;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [31:0]M01_AXI_0_araddr;
  wire [2:0]M01_AXI_0_arprot;
  wire [0:0]M01_AXI_0_arready;
  wire [0:0]M01_AXI_0_arvalid;
  wire [31:0]M01_AXI_0_awaddr;
  wire [2:0]M01_AXI_0_awprot;
  wire [0:0]M01_AXI_0_awready;
  wire [0:0]M01_AXI_0_awvalid;
  wire [0:0]M01_AXI_0_bready;
  wire [1:0]M01_AXI_0_bresp;
  wire [0:0]M01_AXI_0_bvalid;
  wire [31:0]M01_AXI_0_rdata;
  wire [0:0]M01_AXI_0_rready;
  wire [1:0]M01_AXI_0_rresp;
  wire [0:0]M01_AXI_0_rvalid;
  wire [31:0]M01_AXI_0_wdata;
  wire [0:0]M01_AXI_0_wready;
  wire [3:0]M01_AXI_0_wstrb;
  wire [0:0]M01_AXI_0_wvalid;
  wire [63:0]M_AXIS_MM2S_0_tdata;
  wire [7:0]M_AXIS_MM2S_0_tkeep;
  wire M_AXIS_MM2S_0_tlast;
  wire M_AXIS_MM2S_0_tready;
  wire M_AXIS_MM2S_0_tvalid;
  wire [63:0]S_AXIS_S2MM_0_tdata;
  wire [7:0]S_AXIS_S2MM_0_tkeep;
  wire S_AXIS_S2MM_0_tlast;
  wire S_AXIS_S2MM_0_tready;
  wire S_AXIS_S2MM_0_tvalid;
  wire clk;
  wire [0:0]rst;

  PS_RW_PL_DDR PS_RW_PL_DDR_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .M01_AXI_0_araddr(M01_AXI_0_araddr),
        .M01_AXI_0_arprot(M01_AXI_0_arprot),
        .M01_AXI_0_arready(M01_AXI_0_arready),
        .M01_AXI_0_arvalid(M01_AXI_0_arvalid),
        .M01_AXI_0_awaddr(M01_AXI_0_awaddr),
        .M01_AXI_0_awprot(M01_AXI_0_awprot),
        .M01_AXI_0_awready(M01_AXI_0_awready),
        .M01_AXI_0_awvalid(M01_AXI_0_awvalid),
        .M01_AXI_0_bready(M01_AXI_0_bready),
        .M01_AXI_0_bresp(M01_AXI_0_bresp),
        .M01_AXI_0_bvalid(M01_AXI_0_bvalid),
        .M01_AXI_0_rdata(M01_AXI_0_rdata),
        .M01_AXI_0_rready(M01_AXI_0_rready),
        .M01_AXI_0_rresp(M01_AXI_0_rresp),
        .M01_AXI_0_rvalid(M01_AXI_0_rvalid),
        .M01_AXI_0_wdata(M01_AXI_0_wdata),
        .M01_AXI_0_wready(M01_AXI_0_wready),
        .M01_AXI_0_wstrb(M01_AXI_0_wstrb),
        .M01_AXI_0_wvalid(M01_AXI_0_wvalid),
        .M_AXIS_MM2S_0_tdata(M_AXIS_MM2S_0_tdata),
        .M_AXIS_MM2S_0_tkeep(M_AXIS_MM2S_0_tkeep),
        .M_AXIS_MM2S_0_tlast(M_AXIS_MM2S_0_tlast),
        .M_AXIS_MM2S_0_tready(M_AXIS_MM2S_0_tready),
        .M_AXIS_MM2S_0_tvalid(M_AXIS_MM2S_0_tvalid),
        .S_AXIS_S2MM_0_tdata(S_AXIS_S2MM_0_tdata),
        .S_AXIS_S2MM_0_tkeep(S_AXIS_S2MM_0_tkeep),
        .S_AXIS_S2MM_0_tlast(S_AXIS_S2MM_0_tlast),
        .S_AXIS_S2MM_0_tready(S_AXIS_S2MM_0_tready),
        .S_AXIS_S2MM_0_tvalid(S_AXIS_S2MM_0_tvalid),
        .clk(clk),
        .rst(rst));
        
ConvTop COnvTop(
.regSData_awvalid(M01_AXI_0_awvalid),
          .regSData_awready(M01_AXI_0_awready),
          .regSData_awaddr(M01_AXI_0_awaddr),
          .regSData_awprot(M01_AXI_0_awprot),
          .regSData_wvalid(M01_AXI_0_wvalid),
          .regSData_wready(M01_AXI_0_wready),
          .regSData_wdata(M01_AXI_0_wdata),
          .regSData_wstrb(M01_AXI_0_wstrb),
          .regSData_bvalid(M01_AXI_0_bvalid),
          .regSData_bready(M01_AXI_0_bready),
          .regSData_bresp(M01_AXI_0_bresp),
          .regSData_arvalid(M01_AXI_0_arvalid),
          .regSData_arready(M01_AXI_0_arready),
          .regSData_araddr(M01_AXI_0_araddr),
          .regSData_arprot(M01_AXI_0_arprot),
          .regSData_rvalid(M01_AXI_0_rvalid),
          .regSData_rready(M01_AXI_0_rready),
          .regSData_rdata(M01_AXI_0_rdata),
          .regSData_rresp(M01_AXI_0_rresp),
          .clk(clk),
          .s_axis_s2mm_tdata(S_AXIS_S2MM_0_tdata),
          .s_axis_s2mm_tkeep(S_AXIS_S2MM_0_tkeep),
          .s_axis_s2mm_tlast(S_AXIS_S2MM_0_tlast),
          .s_axis_s2mm_tready(S_AXIS_S2MM_0_tready),
          .s_axis_s2mm_tvalid(S_AXIS_S2MM_0_tvalid),
          .m_axis_mm2s_tdata(M_AXIS_MM2S_0_tdata),
          .m_axis_mm2s_tkeep(M_AXIS_MM2S_0_tkeep),
          .m_axis_mm2s_tlast(M_AXIS_MM2S_0_tlast),
          .m_axis_mm2s_tready(M_AXIS_MM2S_0_tready),
          .m_axis_mm2s_tvalid(M_AXIS_MM2S_0_tvalid),
          .reset(!rst)
        );
endmodule
