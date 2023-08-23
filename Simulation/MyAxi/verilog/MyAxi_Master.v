// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : MyAxi_Master
// Git hash  : 001457f364b32e3a6ebb98728ad5983e8c6fe8dd

`timescale 1ns/1ps

module MyAxi_Master (
  input               M_AXI_ACLK,
  input               M_AXI_ARESETN,
  input               io_INIT_AXI_TXN,
  output     [0:0]    io_M_AXI_AWID,
  output     [31:0]   io_M_AXI_AWADDR,
  output     [7:0]    io_M_AXI_AWLEN,
  output     [2:0]    io_M_AXI_AWSIZE,
  output     [1:0]    io_M_AXI_AWBURST,
  output              io_M_AXI_AWLOCK,
  output     [3:0]    io_M_AXI_AWCACHE,
  output     [2:0]    io_M_AXI_AWPROT,
  output     [3:0]    io_M_AXI_AWQOS,
  output              io_M_AXI_AWVALID,
  input               io_M_AXI_AWREADY,
  input               clk,
  input               reset
);
  localparam M_AXI_STATUS_IDLE = 4'd1;
  localparam M_AXI_STATUS_INIT_WRITE = 4'd2;
  localparam M_AXI_STATUS_INIT_READ = 4'd4;
  localparam M_AXI_STATUS_INIT_COMPARE = 4'd8;

  wire       [31:0]   _zz_axi_awaddr;
  wire       [31:0]   C_M_TARGET_SLAVE_BASE_ADDR;
  reg                 init_txn_ff;
  wire                init_txn_ff2;
  reg                 _zz_init_txn_pulse;
  wire                init_txn_pulse;
  reg        [3:0]    Fsm_currentState;
  reg        [3:0]    Fsm_nextState;
  wire                Fsm_writes_done;
  wire                Fsm_reads_done;
  reg        [31:0]   axi_awaddr;
  wire       [6:0]    burst_size_bytes;
  reg                 axi_awvalid;
  wire                when_MyAxi_l92;
  wire                start_single_burst_write;
  wire                when_MyAxi_l104;
  wire                when_MyAxi_l106;
  `ifndef SYNTHESIS
  reg [95:0] Fsm_currentState_string;
  reg [95:0] Fsm_nextState_string;
  `endif


  assign _zz_axi_awaddr = {25'd0, burst_size_bytes};
  `ifndef SYNTHESIS
  always @(*) begin
    case(Fsm_currentState)
      M_AXI_STATUS_IDLE : Fsm_currentState_string = "IDLE        ";
      M_AXI_STATUS_INIT_WRITE : Fsm_currentState_string = "INIT_WRITE  ";
      M_AXI_STATUS_INIT_READ : Fsm_currentState_string = "INIT_READ   ";
      M_AXI_STATUS_INIT_COMPARE : Fsm_currentState_string = "INIT_COMPARE";
      default : Fsm_currentState_string = "????????????";
    endcase
  end
  always @(*) begin
    case(Fsm_nextState)
      M_AXI_STATUS_IDLE : Fsm_nextState_string = "IDLE        ";
      M_AXI_STATUS_INIT_WRITE : Fsm_nextState_string = "INIT_WRITE  ";
      M_AXI_STATUS_INIT_READ : Fsm_nextState_string = "INIT_READ   ";
      M_AXI_STATUS_INIT_COMPARE : Fsm_nextState_string = "INIT_COMPARE";
      default : Fsm_nextState_string = "????????????";
    endcase
  end
  `endif

  assign C_M_TARGET_SLAVE_BASE_ADDR = 32'h40000000;
  assign init_txn_ff2 = 1'b0;
  assign init_txn_pulse = (init_txn_ff && _zz_init_txn_pulse);
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (((Fsm_currentState) & M_AXI_STATUS_IDLE) == M_AXI_STATUS_IDLE) : begin
        if(init_txn_pulse) begin
          Fsm_nextState = M_AXI_STATUS_INIT_WRITE;
        end else begin
          Fsm_nextState = M_AXI_STATUS_INIT_READ;
        end
      end
      (((Fsm_currentState) & M_AXI_STATUS_INIT_WRITE) == M_AXI_STATUS_INIT_WRITE) : begin
        if(Fsm_writes_done) begin
          Fsm_nextState = M_AXI_STATUS_INIT_READ;
        end else begin
          Fsm_nextState = M_AXI_STATUS_INIT_WRITE;
        end
      end
      (((Fsm_currentState) & M_AXI_STATUS_INIT_READ) == M_AXI_STATUS_INIT_READ) : begin
        if(Fsm_reads_done) begin
          Fsm_nextState = M_AXI_STATUS_INIT_COMPARE;
        end else begin
          Fsm_nextState = M_AXI_STATUS_INIT_READ;
        end
      end
      default : begin
        Fsm_nextState = M_AXI_STATUS_IDLE;
      end
    endcase
  end

  assign Fsm_reads_done = 1'b0;
  assign Fsm_writes_done = 1'b0;
  assign io_M_AXI_AWID = 1'b0;
  assign burst_size_bytes = 7'h40;
  assign when_MyAxi_l92 = (io_M_AXI_AWREADY && axi_awvalid);
  assign start_single_burst_write = 1'b0;
  assign when_MyAxi_l104 = ((! axi_awvalid) && start_single_burst_write);
  assign when_MyAxi_l106 = (axi_awvalid && io_M_AXI_AWREADY);
  assign io_M_AXI_AWADDR = (C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr);
  assign io_M_AXI_AWLEN = 8'h0f;
  assign io_M_AXI_AWSIZE = 3'b010;
  assign io_M_AXI_AWBURST = 2'b01;
  assign io_M_AXI_AWLOCK = 1'b0;
  assign io_M_AXI_AWCACHE = 4'b0010;
  assign io_M_AXI_AWPROT = 3'b000;
  assign io_M_AXI_AWQOS = 4'b0000;
  assign io_M_AXI_AWVALID = axi_awvalid;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      init_txn_ff <= 1'b0;
      Fsm_currentState <= M_AXI_STATUS_IDLE;
      axi_awaddr <= 32'h0;
      axi_awvalid <= 1'b0;
    end else begin
      init_txn_ff <= io_INIT_AXI_TXN;
      Fsm_currentState <= Fsm_nextState;
      if(init_txn_pulse) begin
        axi_awaddr <= 32'h0;
      end else begin
        if(when_MyAxi_l92) begin
          axi_awaddr <= (axi_awaddr + _zz_axi_awaddr);
        end else begin
          axi_awaddr <= axi_awaddr;
        end
      end
      if(init_txn_pulse) begin
        axi_awvalid <= 1'b0;
      end else begin
        if(when_MyAxi_l104) begin
          axi_awvalid <= 1'b1;
        end else begin
          if(when_MyAxi_l106) begin
            axi_awvalid <= 1'b0;
          end else begin
            axi_awvalid <= axi_awvalid;
          end
        end
      end
    end
  end

  always @(posedge clk) begin
    _zz_init_txn_pulse <= (! init_txn_ff);
  end


endmodule
