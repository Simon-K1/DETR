// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Timer_Cnt
// Git hash  : 9b3f3b284dc799eeff84e7e785c00305e9c6f3db

`timescale 1ns/1ps

module Timer_Cnt (
  input      [3:0]    gpio_in,
  output     [31:0]   cnt,
  output              Intc,
  output     [31:0]   Interrupt_cnt,
  output              Waiting_Detect_interrupt,
  input               clk,
  input               reset
);

  wire                valid;
  wire                restart;
  reg                 Waiting_Detect_interrupt_1;
  reg        [31:0]   Interrupt_cnt_1;
  reg                 Intc_1;
  wire                when_LoopTest_l50;
  wire                when_LoopTest_l52;
  reg                 Interrupt_prepare;
  wire                Start_generate_Interrupt;
  wire                when_LoopTest_l62;
  wire                when_LoopTest_l66;
  reg        [31:0]   cnt_1;
  wire                when_LoopTest_l84;

  assign valid = gpio_in[0];
  assign restart = gpio_in[1];
  assign Waiting_Detect_interrupt = Waiting_Detect_interrupt_1;
  assign when_LoopTest_l50 = (Interrupt_cnt_1 == 32'h05f5e100);
  assign when_LoopTest_l52 = (Interrupt_cnt_1 == 32'h05f5e164);
  assign Interrupt_cnt = Interrupt_cnt_1;
  assign Intc = Intc_1;
  assign Start_generate_Interrupt = gpio_in[3];
  assign when_LoopTest_l62 = (Interrupt_cnt_1 == 32'h05f5e100);
  assign when_LoopTest_l66 = (Interrupt_cnt_1 == 32'h05f5e164);
  assign when_LoopTest_l84 = (restart || gpio_in[2]);
  assign cnt = cnt_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Waiting_Detect_interrupt_1 <= 1'b0;
      Interrupt_cnt_1 <= 32'h0;
      Intc_1 <= 1'b0;
      Interrupt_prepare <= 1'b0;
      cnt_1 <= 32'h0;
    end else begin
      if(when_LoopTest_l50) begin
        Intc_1 <= 1'b1;
      end else begin
        if(when_LoopTest_l52) begin
          Intc_1 <= 1'b0;
        end
      end
      if(Start_generate_Interrupt) begin
        Interrupt_prepare <= 1'b1;
      end else begin
        if(when_LoopTest_l62) begin
          Interrupt_prepare <= 1'b0;
        end
      end
      if(when_LoopTest_l66) begin
        Interrupt_cnt_1 <= 32'h0;
      end else begin
        if(Interrupt_prepare) begin
          Interrupt_cnt_1 <= (Interrupt_cnt_1 + 32'h00000001);
        end
      end
      if(Intc_1) begin
        Waiting_Detect_interrupt_1 <= 1'b1;
      end else begin
        if(restart) begin
          Waiting_Detect_interrupt_1 <= 1'b0;
        end
      end
      if(valid) begin
        cnt_1 <= (cnt_1 + 32'h00000001);
      end else begin
        if(Waiting_Detect_interrupt_1) begin
          cnt_1 <= (cnt_1 + 32'h00000001);
        end else begin
          if(when_LoopTest_l84) begin
            cnt_1 <= 32'h0;
          end
        end
      end
    end
  end


endmodule
