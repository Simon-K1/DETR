// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : LoopTest
// Git hash  : 72a3ba00bf8112f87f4c70cf56c4d31a0db88aa8

`timescale 1ns/1ps

module LoopTest (
  input               io_valid,
  input               io_restart,
  input      [31:0]   io_start,
  input               clk,
  input               reset
);

  wire       [31:0]   _zz_SubLoop_valid;
  wire       [31:0]   _zz_SubLoop_count_1;
  wire       [3:0]    _zz_SubLoop_count;
  reg        [31:0]   SubLoop_count;
  reg                 SubLoop_valid;

  assign _zz_SubLoop_valid = {28'd0, _zz_SubLoop_count};
  assign _zz_SubLoop_count_1 = {28'd0, _zz_SubLoop_count};
  assign _zz_SubLoop_count = 4'b1000;
  always @(*) begin
    SubLoop_valid = ((SubLoop_count <= _zz_SubLoop_valid) && io_valid);
    if(io_restart) begin
      SubLoop_valid = 1'b0;
    end
  end

  always @(posedge clk) begin
    if(io_valid) begin
      if(SubLoop_valid) begin
        SubLoop_count <= io_start;
      end else begin
        SubLoop_count <= (SubLoop_count - _zz_SubLoop_count_1);
      end
    end
    if(io_restart) begin
      SubLoop_count <= io_start;
    end
  end


endmodule
