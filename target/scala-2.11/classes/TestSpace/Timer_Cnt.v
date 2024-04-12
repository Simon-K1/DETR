// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : Timer_Cnt
// Git hash  : 3303a8b78a0825be55263ff31a4fd2253e08de19

`timescale 1ns/1ps

module Timer_Cnt (
  input      [3:0]    gpio_in,
  output     [31:0]   cnt,
  output              Intc,
  output     [31:0]   Interrupt_Coming,
  output              Waiting_Detect_interrupt,
  input               clk,
  input               reset
);

  wire                valid;
  wire                restart;
  reg                 Waiting_Detect_interrupt_1;
  reg        [31:0]   Interrupt_Coming_1;
  reg                 Intc_1;
  wire                when_LoopTest_l50;
  wire                when_LoopTest_l52;
  reg                 Interrupt_prepare;
  wire                Start_generate_Interrupt;
  wire                when_LoopTest_l62;
  wire                when_LoopTest_l66;
  reg                 Intc_1_regNext;
  wire                when_LoopTest_l72;
  reg        [31:0]   cnt_1;
  wire                when_LoopTest_l84;

  assign valid = gpio_in[0];
  assign restart = gpio_in[1];
  assign Waiting_Detect_interrupt = Waiting_Detect_interrupt_1;
  assign when_LoopTest_l50 = (Interrupt_Coming_1 == 32'h05f5e100);
  assign when_LoopTest_l52 = (Interrupt_Coming_1 == 32'h05f5e163);
  assign Interrupt_Coming = Interrupt_Coming_1;
  assign Intc = Intc_1;
  assign Start_generate_Interrupt = gpio_in[3];
  assign when_LoopTest_l62 = (Interrupt_Coming_1 == 32'h05f5e163);
  assign when_LoopTest_l66 = (Interrupt_Coming_1 == 32'h05f5e163);
  assign when_LoopTest_l72 = (Intc_1 && (! Intc_1_regNext));
  assign when_LoopTest_l84 = (restart || gpio_in[2]);
  assign cnt = cnt_1;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Waiting_Detect_interrupt_1 <= 1'b0;
      Interrupt_Coming_1 <= 32'h0;
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
        Interrupt_Coming_1 <= 32'h0;
      end else begin
        if(Interrupt_prepare) begin
          Interrupt_Coming_1 <= (Interrupt_Coming_1 + 32'h00000001);
        end
      end
      if(when_LoopTest_l72) begin
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

  always @(posedge clk) begin
    Intc_1_regNext <= Intc_1;
  end


endmodule
