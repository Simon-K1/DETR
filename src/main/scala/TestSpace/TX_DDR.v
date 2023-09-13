// Generator : SpinalHDL v1.8.1    git head : 2a7592004363e5b40ec43e1f122ed8641cd8965b
// Component : TX_DDR
// Git hash  : b2a922209f98818aa020387be356cd793579745a

`timescale 1ns/1ps

module TX_DDR (
  input      [11:0]   io_I_12bit,
  input      [11:0]   io_Q_12bit,
  input               io_Tx_Frame,
  output reg [5:0]    io_Tx_6bit,
  input               clk,
  input               reset
);

  wire       [0:0]    oDDR_Module_1_D1;
  wire       [0:0]    oDDR_Module_1_D2;
  wire       [0:0]    oDDR_Module_2_D1;
  wire       [0:0]    oDDR_Module_2_D2;
  wire       [0:0]    oDDR_Module_3_D1;
  wire       [0:0]    oDDR_Module_3_D2;
  wire       [0:0]    oDDR_Module_4_D1;
  wire       [0:0]    oDDR_Module_4_D2;
  wire       [0:0]    oDDR_Module_5_D1;
  wire       [0:0]    oDDR_Module_5_D2;
  wire       [0:0]    oDDR_Module_6_D1;
  wire       [0:0]    oDDR_Module_6_D2;
  wire       [0:0]    oDDR_Module_1_Q;
  wire       [0:0]    oDDR_Module_2_Q;
  wire       [0:0]    oDDR_Module_3_Q;
  wire       [0:0]    oDDR_Module_4_Q;
  wire       [0:0]    oDDR_Module_5_Q;
  wire       [0:0]    oDDR_Module_6_Q;
  reg        [5:0]    I_Lsb;
  reg        [5:0]    Q_Lsb;
  wire       [5:0]    ODDR_D1;
  wire       [5:0]    ODDR_D2;

  ODDR_Module oDDR_Module_1 (
    .Q  (oDDR_Module_1_Q ), //o
    .C  (clk             ), //i
    .CE (1'b1            ), //i
    .D1 (oDDR_Module_1_D1), //i
    .D2 (oDDR_Module_1_D2), //i
    .R  (1'b0            ), //i
    .S  (1'b0            )  //i
  );
  ODDR_Module oDDR_Module_2 (
    .Q  (oDDR_Module_2_Q ), //o
    .C  (clk             ), //i
    .CE (1'b1            ), //i
    .D1 (oDDR_Module_2_D1), //i
    .D2 (oDDR_Module_2_D2), //i
    .R  (1'b0            ), //i
    .S  (1'b0            )  //i
  );
  ODDR_Module oDDR_Module_3 (
    .Q  (oDDR_Module_3_Q ), //o
    .C  (clk             ), //i
    .CE (1'b1            ), //i
    .D1 (oDDR_Module_3_D1), //i
    .D2 (oDDR_Module_3_D2), //i
    .R  (1'b0            ), //i
    .S  (1'b0            )  //i
  );
  ODDR_Module oDDR_Module_4 (
    .Q  (oDDR_Module_4_Q ), //o
    .C  (clk             ), //i
    .CE (1'b1            ), //i
    .D1 (oDDR_Module_4_D1), //i
    .D2 (oDDR_Module_4_D2), //i
    .R  (1'b0            ), //i
    .S  (1'b0            )  //i
  );
  ODDR_Module oDDR_Module_5 (
    .Q  (oDDR_Module_5_Q ), //o
    .C  (clk             ), //i
    .CE (1'b1            ), //i
    .D1 (oDDR_Module_5_D1), //i
    .D2 (oDDR_Module_5_D2), //i
    .R  (1'b0            ), //i
    .S  (1'b0            )  //i
  );
  ODDR_Module oDDR_Module_6 (
    .Q  (oDDR_Module_6_Q ), //o
    .C  (clk             ), //i
    .CE (1'b1            ), //i
    .D1 (oDDR_Module_6_D1), //i
    .D2 (oDDR_Module_6_D2), //i
    .R  (1'b0            ), //i
    .S  (1'b0            )  //i
  );
  assign ODDR_D1 = (io_Tx_Frame ? io_I_12bit[11 : 6] : I_Lsb);
  assign ODDR_D2 = (io_Tx_Frame ? io_Q_12bit[11 : 6] : Q_Lsb);
  assign oDDR_Module_1_D1 = ODDR_D1[0 : 0];
  assign oDDR_Module_1_D2 = ODDR_D2[0 : 0];
  always @(*) begin
    io_Tx_6bit[0 : 0] = oDDR_Module_1_Q;
    io_Tx_6bit[1 : 1] = oDDR_Module_2_Q;
    io_Tx_6bit[2 : 2] = oDDR_Module_3_Q;
    io_Tx_6bit[3 : 3] = oDDR_Module_4_Q;
    io_Tx_6bit[4 : 4] = oDDR_Module_5_Q;
    io_Tx_6bit[5 : 5] = oDDR_Module_6_Q;
  end

  assign oDDR_Module_2_D1 = ODDR_D1[1 : 1];
  assign oDDR_Module_2_D2 = ODDR_D2[1 : 1];
  assign oDDR_Module_3_D1 = ODDR_D1[2 : 2];
  assign oDDR_Module_3_D2 = ODDR_D2[2 : 2];
  assign oDDR_Module_4_D1 = ODDR_D1[3 : 3];
  assign oDDR_Module_4_D2 = ODDR_D2[3 : 3];
  assign oDDR_Module_5_D1 = ODDR_D1[4 : 4];
  assign oDDR_Module_5_D2 = ODDR_D2[4 : 4];
  assign oDDR_Module_6_D1 = ODDR_D1[5 : 5];
  assign oDDR_Module_6_D2 = ODDR_D2[5 : 5];
  always @(posedge clk) begin
    if(io_Tx_Frame) begin
      I_Lsb <= io_I_12bit[5 : 0];
    end
    if(io_Tx_Frame) begin
      Q_Lsb <= io_Q_12bit[5 : 0];
    end
  end


endmodule

ODDR #(
.DDR_CLK_EDGE("SAME_EDGE"),
.INIT(1'b0),    
.SRTYPE("SYNC") 
) ODDR_inst (
.Q(Q),   
.C(C),   
.CE(CE), 
.D1(D1), 
.D2(D2), 
.R(R),   
.S(S)    
);
