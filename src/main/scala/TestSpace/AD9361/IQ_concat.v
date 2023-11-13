// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : IQ_concat
// Git hash  : b2a922209f98818aa020387be356cd793579745a

`timescale 1ns/1ps

module IQ_concat (
  input      [5:0]    I_6bit,
  input      [5:0]    Q_6bit,
  input               Rx_Frame,
  output     [11:0]   I_12bit,
  output     [11:0]   Q_12bit,
  input               clk,
  input               reset
);

  reg        [5:0]    I_Msb;
  reg        [5:0]    Q_Msb;
  reg                 Flag;
  reg                 Rx_Frame_regNext;
  reg        [11:0]   _zz_I_12bit;
  reg                 Rx_Frame_regNext_1;
  reg        [11:0]   _zz_Q_12bit;

  assign I_12bit = _zz_I_12bit;
  assign Q_12bit = _zz_Q_12bit;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      I_Msb <= 6'h0;
      Q_Msb <= 6'h0;
    end else begin
      if(Rx_Frame) begin
        I_Msb <= I_6bit;
      end
      if(Rx_Frame) begin
        Q_Msb <= Q_6bit;
      end
    end
  end

  always @(posedge clk) begin
    Flag <= Rx_Frame;
    Rx_Frame_regNext <= Rx_Frame;
    if(Rx_Frame_regNext) begin
      _zz_I_12bit <= {I_Msb,I_6bit};
    end
    Rx_Frame_regNext_1 <= Rx_Frame;
    if(Rx_Frame_regNext_1) begin
      _zz_Q_12bit <= {Q_Msb,Q_6bit};
    end
  end


endmodule
