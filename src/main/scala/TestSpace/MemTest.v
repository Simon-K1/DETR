// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : MemTest
// Git hash  : cb73c1d03e6f2bcfd7eeee91a2245d4910c61e19

`timescale 1ns/1ps

module MemTest (
  input               io_writeValid,
  input      [11:0]   io_writeAddress,
  input      [31:0]   io_writeData,
  output     [31:0]   io_readData,
  input               clk,
  input               reset
);

  reg        [31:0]   _zz_mem_port1;
  wire       [11:0]   _zz_mem_port;
  wire                _zz_mem_port_1;
  wire       [11:0]   _zz_io_readData;
  wire                _zz_io_readData_1;
  (* ram_style = "block" *) reg [31:0] mem [0:4095];

  assign _zz_io_readData = 12'h0;
  assign _zz_io_readData_1 = 1'b1;
  always @(posedge clk) begin
    if(io_writeValid) begin
      mem[io_writeAddress] <= io_writeData;
    end
  end

  always @(posedge clk) begin
    if(_zz_io_readData_1) begin
      _zz_mem_port1 <= mem[_zz_io_readData];
    end
  end

  assign io_readData = _zz_mem_port1;

endmodule
