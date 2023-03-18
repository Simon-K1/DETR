// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : RegTable
// Git hash  : 529b64cfc1fb3cac1e141c2162cd226166390d88

`timescale 1ns/1ps

module RegTable (
  input               regSData_awvalid,
  output reg          regSData_awready,
  input      [19:0]   regSData_awaddr,
  input      [2:0]    regSData_awprot,
  input               regSData_wvalid,
  output reg          regSData_wready,
  input      [31:0]   regSData_wdata,
  input      [3:0]    regSData_wstrb,
  output              regSData_bvalid,
  input               regSData_bready,
  output     [1:0]    regSData_bresp,
  input               regSData_arvalid,
  output reg          regSData_arready,
  input      [19:0]   regSData_araddr,
  input      [2:0]    regSData_arprot,
  output              regSData_rvalid,
  input               regSData_rready,
  output     [31:0]   regSData_rdata,
  output     [1:0]    regSData_rresp,
  output     [3:0]    LD0123,
  output     [3:0]    LD4567,
  output     [0:0]    Start,
  output     [1:0]    Switch,
  input               clk,
  input               reset
);

  reg                 bus_readError;
  reg        [31:0]   bus_readData;
  wire                bus_axiAr_valid;
  wire                bus_axiAr_ready;
  wire       [19:0]   bus_axiAr_payload_addr;
  wire       [2:0]    bus_axiAr_payload_prot;
  reg                 regSData_ar_rValid;
  reg        [19:0]   regSData_ar_rData_addr;
  reg        [2:0]    regSData_ar_rData_prot;
  wire                when_Stream_l368;
  wire                bus_axiR_valid;
  wire                bus_axiR_ready;
  wire       [31:0]   bus_axiR_payload_data;
  wire       [1:0]    bus_axiR_payload_resp;
  reg                 bus_axiRValid;
  wire                bus_axiAw_valid;
  wire                bus_axiAw_ready;
  wire       [19:0]   bus_axiAw_payload_addr;
  wire       [2:0]    bus_axiAw_payload_prot;
  reg                 regSData_aw_rValid;
  reg        [19:0]   regSData_aw_rData_addr;
  reg        [2:0]    regSData_aw_rData_prot;
  wire                when_Stream_l368_1;
  wire                bus_axiW_valid;
  wire                bus_axiW_ready;
  wire       [31:0]   bus_axiW_payload_data;
  wire       [3:0]    bus_axiW_payload_strb;
  reg                 regSData_w_rValid;
  reg        [31:0]   regSData_w_rData_data;
  reg        [3:0]    regSData_w_rData_strb;
  wire                when_Stream_l368_2;
  wire                bus_axiB_valid;
  wire                bus_axiB_ready;
  wire       [1:0]    bus_axiB_payload_resp;
  reg                 bus_axiBValid;
  wire                bus_doWrite;
  wire                bus_doRead;
  wire                when_RegInst_l281;
  reg        [3:0]    _zz_bus_readData;
  reg        [3:0]    _zz_bus_readData_1;
  wire                when_RegInst_l281_1;
  reg        [0:0]    _zz_bus_readData_2;
  reg        [1:0]    _zz_bus_readData_3;

  always @(*) begin
    regSData_arready = bus_axiAr_ready;
    if(when_Stream_l368) begin
      regSData_arready = 1'b1;
    end
  end

  assign when_Stream_l368 = (! bus_axiAr_valid);
  assign bus_axiAr_valid = regSData_ar_rValid;
  assign bus_axiAr_payload_addr = regSData_ar_rData_addr;
  assign bus_axiAr_payload_prot = regSData_ar_rData_prot;
  always @(*) begin
    regSData_awready = bus_axiAw_ready;
    if(when_Stream_l368_1) begin
      regSData_awready = 1'b1;
    end
  end

  assign when_Stream_l368_1 = (! bus_axiAw_valid);
  assign bus_axiAw_valid = regSData_aw_rValid;
  assign bus_axiAw_payload_addr = regSData_aw_rData_addr;
  assign bus_axiAw_payload_prot = regSData_aw_rData_prot;
  always @(*) begin
    regSData_wready = bus_axiW_ready;
    if(when_Stream_l368_2) begin
      regSData_wready = 1'b1;
    end
  end

  assign when_Stream_l368_2 = (! bus_axiW_valid);
  assign bus_axiW_valid = regSData_w_rValid;
  assign bus_axiW_payload_data = regSData_w_rData_data;
  assign bus_axiW_payload_strb = regSData_w_rData_strb;
  assign bus_axiAr_ready = ((! bus_axiRValid) || bus_axiR_ready);
  assign bus_axiR_payload_resp = 2'b00;
  assign bus_axiR_valid = bus_axiRValid;
  assign bus_axiR_payload_data = bus_readData;
  assign bus_axiAw_ready = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_axiW_ready = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_axiB_payload_resp = 2'b00;
  assign bus_axiB_valid = bus_axiBValid;
  assign regSData_rvalid = bus_axiR_valid;
  assign bus_axiR_ready = regSData_rready;
  assign regSData_rdata = bus_axiR_payload_data;
  assign regSData_rresp = bus_axiR_payload_resp;
  assign regSData_bvalid = bus_axiB_valid;
  assign bus_axiB_ready = regSData_bready;
  assign regSData_bresp = bus_axiB_payload_resp;
  assign bus_doWrite = (bus_axiAw_valid && bus_axiW_valid);
  assign bus_doRead = (bus_axiAr_valid && bus_axiAr_ready);
  assign when_RegInst_l281 = ((bus_axiAw_payload_addr == 20'h0) && bus_doWrite);
  assign LD0123 = _zz_bus_readData;
  assign LD4567 = _zz_bus_readData_1;
  assign when_RegInst_l281_1 = ((bus_axiAw_payload_addr == 20'h00004) && bus_doWrite);
  assign Start = _zz_bus_readData_2;
  assign Switch = _zz_bus_readData_3;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      bus_readError <= 1'b0;
      bus_readData <= 32'h0;
      regSData_ar_rValid <= 1'b0;
      bus_axiRValid <= 1'b0;
      regSData_aw_rValid <= 1'b0;
      regSData_w_rValid <= 1'b0;
      bus_axiBValid <= 1'b0;
      _zz_bus_readData <= 4'b0000;
      _zz_bus_readData_1 <= 4'b0000;
      _zz_bus_readData_2 <= 1'b0;
      _zz_bus_readData_3 <= 2'b00;
    end else begin
      if(regSData_arready) begin
        regSData_ar_rValid <= regSData_arvalid;
      end
      if(regSData_awready) begin
        regSData_aw_rValid <= regSData_awvalid;
      end
      if(regSData_wready) begin
        regSData_w_rValid <= regSData_wvalid;
      end
      bus_axiRValid <= bus_doRead;
      bus_axiBValid <= bus_doWrite;
      if(when_RegInst_l281) begin
        _zz_bus_readData <= bus_axiW_payload_data[3 : 0];
      end
      if(when_RegInst_l281) begin
        _zz_bus_readData_1 <= bus_axiW_payload_data[7 : 4];
      end
      if(when_RegInst_l281_1) begin
        _zz_bus_readData_2 <= bus_axiW_payload_data[0 : 0];
      end
      if(when_RegInst_l281_1) begin
        _zz_bus_readData_3 <= bus_axiW_payload_data[2 : 1];
      end
      if(bus_axiAr_valid) begin
        case(bus_axiAr_payload_addr)
          20'h0 : begin
            bus_readData <= {24'h0,{_zz_bus_readData_1,_zz_bus_readData}};
            bus_readError <= 1'b1;
          end
          20'h00004 : begin
            bus_readData <= {29'h0,{_zz_bus_readData_3,_zz_bus_readData_2}};
            bus_readError <= 1'b1;
          end
          default : begin
            bus_readData <= 32'h0;
            bus_readError <= 1'b1;
          end
        endcase
      end
    end
  end

  always @(posedge clk) begin
    if(regSData_arready) begin
      regSData_ar_rData_addr <= regSData_araddr;
      regSData_ar_rData_prot <= regSData_arprot;
    end
    if(regSData_awready) begin
      regSData_aw_rData_addr <= regSData_awaddr;
      regSData_aw_rData_prot <= regSData_awprot;
    end
    if(regSData_wready) begin
      regSData_w_rData_data <= regSData_wdata;
      regSData_w_rData_strb <= regSData_wstrb;
    end
  end


endmodule
