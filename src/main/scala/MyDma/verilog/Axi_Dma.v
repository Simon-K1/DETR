
`timescale 1 ns / 1 ps

	module Axi_Dma_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Master Bus Interface s2mm
		parameter  C_s2mm_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_s2mm_BURST_LEN	= 16,
		parameter integer C_s2mm_ID_WIDTH	= 1,
		parameter integer C_s2mm_ADDR_WIDTH	= 32,
		parameter integer C_s2mm_DATA_WIDTH	= 32,
		parameter integer C_s2mm_AWUSER_WIDTH	= 0,
		parameter integer C_s2mm_ARUSER_WIDTH	= 0,
		parameter integer C_s2mm_WUSER_WIDTH	= 0,
		parameter integer C_s2mm_RUSER_WIDTH	= 0,
		parameter integer C_s2mm_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Master Bus Interface s2mm
		input wire  s2mm_init_axi_txn,
		output wire  s2mm_txn_done,
		output wire  s2mm_error,
		input wire  s2mm_aclk,
		input wire  s2mm_aresetn,
		output wire [C_s2mm_ID_WIDTH-1 : 0] s2mm_awid,
		output wire [C_s2mm_ADDR_WIDTH-1 : 0] s2mm_awaddr,
		output wire [7 : 0] s2mm_awlen,
		output wire [2 : 0] s2mm_awsize,
		output wire [1 : 0] s2mm_awburst,
		output wire  s2mm_awlock,
		output wire [3 : 0] s2mm_awcache,
		output wire [2 : 0] s2mm_awprot,
		output wire [3 : 0] s2mm_awqos,
		output wire [C_s2mm_AWUSER_WIDTH-1 : 0] s2mm_awuser,
		output wire  s2mm_awvalid,
		input wire  s2mm_awready,
		output wire [C_s2mm_DATA_WIDTH-1 : 0] s2mm_wdata,
		output wire [C_s2mm_DATA_WIDTH/8-1 : 0] s2mm_wstrb,
		output wire  s2mm_wlast,
		output wire [C_s2mm_WUSER_WIDTH-1 : 0] s2mm_wuser,
		output wire  s2mm_wvalid,
		input wire  s2mm_wready,
		input wire [C_s2mm_ID_WIDTH-1 : 0] s2mm_bid,
		input wire [1 : 0] s2mm_bresp,
		input wire [C_s2mm_BUSER_WIDTH-1 : 0] s2mm_buser,
		input wire  s2mm_bvalid,
		output wire  s2mm_bready,
		output wire [C_s2mm_ID_WIDTH-1 : 0] s2mm_arid,
		output wire [C_s2mm_ADDR_WIDTH-1 : 0] s2mm_araddr,
		output wire [7 : 0] s2mm_arlen,
		output wire [2 : 0] s2mm_arsize,
		output wire [1 : 0] s2mm_arburst,
		output wire  s2mm_arlock,
		output wire [3 : 0] s2mm_arcache,
		output wire [2 : 0] s2mm_arprot,
		output wire [3 : 0] s2mm_arqos,
		output wire [C_s2mm_ARUSER_WIDTH-1 : 0] s2mm_aruser,
		output wire  s2mm_arvalid,
		input wire  s2mm_arready,
		input wire [C_s2mm_ID_WIDTH-1 : 0] s2mm_rid,
		input wire [C_s2mm_DATA_WIDTH-1 : 0] s2mm_rdata,
		input wire [1 : 0] s2mm_rresp,
		input wire  s2mm_rlast,
		input wire [C_s2mm_RUSER_WIDTH-1 : 0] s2mm_ruser,
		input wire  s2mm_rvalid,
		output wire  s2mm_rready
	);
// Instantiation of Axi Bus Interface s2mm
	Axi_Dma_v1_0_s2mm # ( 
		.C_M_TARGET_SLAVE_BASE_ADDR(C_s2mm_TARGET_SLAVE_BASE_ADDR),
		.C_M_AXI_BURST_LEN(C_s2mm_BURST_LEN),
		.C_M_AXI_ID_WIDTH(C_s2mm_ID_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_s2mm_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_s2mm_DATA_WIDTH),
		.C_M_AXI_AWUSER_WIDTH(C_s2mm_AWUSER_WIDTH),
		.C_M_AXI_ARUSER_WIDTH(C_s2mm_ARUSER_WIDTH),
		.C_M_AXI_WUSER_WIDTH(C_s2mm_WUSER_WIDTH),
		.C_M_AXI_RUSER_WIDTH(C_s2mm_RUSER_WIDTH),
		.C_M_AXI_BUSER_WIDTH(C_s2mm_BUSER_WIDTH)
	) Axi_Dma_v1_0_s2mm_inst (
		.INIT_AXI_TXN(s2mm_init_axi_txn),
		.TXN_DONE(s2mm_txn_done),
		.ERROR(s2mm_error),
		.M_AXI_ACLK(s2mm_aclk),
		.M_AXI_ARESETN(s2mm_aresetn),
		.M_AXI_AWID(s2mm_awid),
		.M_AXI_AWADDR(s2mm_awaddr),
		.M_AXI_AWLEN(s2mm_awlen),
		.M_AXI_AWSIZE(s2mm_awsize),
		.M_AXI_AWBURST(s2mm_awburst),
		.M_AXI_AWLOCK(s2mm_awlock),
		.M_AXI_AWCACHE(s2mm_awcache),
		.M_AXI_AWPROT(s2mm_awprot),
		.M_AXI_AWQOS(s2mm_awqos),
		.M_AXI_AWUSER(s2mm_awuser),
		.M_AXI_AWVALID(s2mm_awvalid),
		.M_AXI_AWREADY(s2mm_awready),
		.M_AXI_WDATA(s2mm_wdata),
		.M_AXI_WSTRB(s2mm_wstrb),
		.M_AXI_WLAST(s2mm_wlast),
		.M_AXI_WUSER(s2mm_wuser),
		.M_AXI_WVALID(s2mm_wvalid),
		.M_AXI_WREADY(s2mm_wready),
		.M_AXI_BID(s2mm_bid),
		.M_AXI_BRESP(s2mm_bresp),
		.M_AXI_BUSER(s2mm_buser),
		.M_AXI_BVALID(s2mm_bvalid),
		.M_AXI_BREADY(s2mm_bready),
		.M_AXI_ARID(s2mm_arid),
		.M_AXI_ARADDR(s2mm_araddr),
		.M_AXI_ARLEN(s2mm_arlen),
		.M_AXI_ARSIZE(s2mm_arsize),
		.M_AXI_ARBURST(s2mm_arburst),
		.M_AXI_ARLOCK(s2mm_arlock),
		.M_AXI_ARCACHE(s2mm_arcache),
		.M_AXI_ARPROT(s2mm_arprot),
		.M_AXI_ARQOS(s2mm_arqos),
		.M_AXI_ARUSER(s2mm_aruser),
		.M_AXI_ARVALID(s2mm_arvalid),
		.M_AXI_ARREADY(s2mm_arready),
		.M_AXI_RID(s2mm_rid),
		.M_AXI_RDATA(s2mm_rdata),
		.M_AXI_RRESP(s2mm_rresp),
		.M_AXI_RLAST(s2mm_rlast),
		.M_AXI_RUSER(s2mm_ruser),
		.M_AXI_RVALID(s2mm_rvalid),
		.M_AXI_RREADY(s2mm_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
