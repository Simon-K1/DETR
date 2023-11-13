
module test (
  input               clk,
  input               reset
);
  localparam STATE_ON = 2'd1;
  localparam STATE_OFF = 2'd2;

  reg        [1:0]    Fsm_currentState;
  reg        [1:0]    Fsm_nextState;
  wire                Fsm_j;
  wire                Fsm_k;
  `ifndef SYNTHESIS
  reg [31:0] Fsm_currentState_string;
  reg [31:0] Fsm_nextState_string;
  `endif



  always @(*) begin
    case(1)
      (((Fsm_currentState) & STATE_OFF) == STATE_OFF) : begin
        if(Fsm_j) begin
          Fsm_nextState = STATE_ON;
        end else begin
          Fsm_nextState = STATE_OFF;
        end
      end
      default : begin
        if(Fsm_k) begin
          Fsm_nextState = STATE_OFF;
        end else begin
          Fsm_nextState = STATE_ON;
        end
      end
    endcase
  end

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      Fsm_currentState <= STATE_OFF;
    end else begin
      Fsm_currentState <= Fsm_nextState;
    end
  end


endmodule

    
    