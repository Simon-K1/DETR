// Generator : SpinalHDL v1.7.0    git head : eca519e78d4e6022e34911ec300a432ed9db8220
// Component : ConvOutput
// Git hash  : 3effca4221ff53210d664d66c9a27381fe9a5421

`timescale 1ns/1ps

module ConvOutput (
  input               sData_0_valid,
  output              sData_0_ready,
  input      [7:0]    sData_0_payload,
  input               sData_1_valid,
  output              sData_1_ready,
  input      [7:0]    sData_1_payload,
  input               sData_2_valid,
  output              sData_2_ready,
  input      [7:0]    sData_2_payload,
  input               sData_3_valid,
  output              sData_3_ready,
  input      [7:0]    sData_3_payload,
  input               sData_4_valid,
  output              sData_4_ready,
  input      [7:0]    sData_4_payload,
  input               sData_5_valid,
  output              sData_5_ready,
  input      [7:0]    sData_5_payload,
  input               sData_6_valid,
  output              sData_6_ready,
  input      [7:0]    sData_6_payload,
  input               sData_7_valid,
  output              sData_7_ready,
  input      [7:0]    sData_7_payload,
  input      [11:0]   Matrix_Col,
  input      [11:0]   Matrix_Row,
  output              mData_valid,
  input               mData_ready,
  output reg [63:0]   mData_payload,
  input               clk,
  input               reset
);

  wire                streamFifo_io_push_ready;
  wire                streamFifo_io_pop_valid;
  wire       [7:0]    streamFifo_io_pop_payload;
  wire       [10:0]   streamFifo_io_occupancy;
  wire       [10:0]   streamFifo_io_availability;
  wire                streamFifo_1_io_push_ready;
  wire                streamFifo_1_io_pop_valid;
  wire       [7:0]    streamFifo_1_io_pop_payload;
  wire       [10:0]   streamFifo_1_io_occupancy;
  wire       [10:0]   streamFifo_1_io_availability;
  wire                streamFifo_2_io_push_ready;
  wire                streamFifo_2_io_pop_valid;
  wire       [7:0]    streamFifo_2_io_pop_payload;
  wire       [10:0]   streamFifo_2_io_occupancy;
  wire       [10:0]   streamFifo_2_io_availability;
  wire                streamFifo_3_io_push_ready;
  wire                streamFifo_3_io_pop_valid;
  wire       [7:0]    streamFifo_3_io_pop_payload;
  wire       [10:0]   streamFifo_3_io_occupancy;
  wire       [10:0]   streamFifo_3_io_availability;
  wire                streamFifo_4_io_push_ready;
  wire                streamFifo_4_io_pop_valid;
  wire       [7:0]    streamFifo_4_io_pop_payload;
  wire       [10:0]   streamFifo_4_io_occupancy;
  wire       [10:0]   streamFifo_4_io_availability;
  wire                streamFifo_5_io_push_ready;
  wire                streamFifo_5_io_pop_valid;
  wire       [7:0]    streamFifo_5_io_pop_payload;
  wire       [10:0]   streamFifo_5_io_occupancy;
  wire       [10:0]   streamFifo_5_io_availability;
  wire                streamFifo_6_io_push_ready;
  wire                streamFifo_6_io_pop_valid;
  wire       [7:0]    streamFifo_6_io_pop_payload;
  wire       [10:0]   streamFifo_6_io_occupancy;
  wire       [10:0]   streamFifo_6_io_availability;
  wire                streamFifo_7_io_push_ready;
  wire                streamFifo_7_io_pop_valid;
  wire       [7:0]    streamFifo_7_io_pop_payload;
  wire       [10:0]   streamFifo_7_io_occupancy;
  wire       [10:0]   streamFifo_7_io_availability;
  wire                sData_0_fire;
  reg        [11:0]   In_Col_Cnt_count;
  wire                In_Col_Cnt_valid;
  reg        [11:0]   In_Row_Cnt_count;
  wire                In_Row_Cnt_valid;

  ConvOutput_Fifo streamFifo (
    .io_push_valid   (sData_0_valid                   ), //i
    .io_push_ready   (streamFifo_io_push_ready        ), //o
    .io_push_payload (sData_0_payload[7:0]            ), //i
    .io_pop_valid    (streamFifo_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                            ), //i
    .io_pop_payload  (streamFifo_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                            ), //i
    .io_occupancy    (streamFifo_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_io_availability[10:0]), //o
    .clk             (clk                             ), //i
    .reset           (reset                           )  //i
  );
  ConvOutput_Fifo streamFifo_1 (
    .io_push_valid   (sData_1_valid                     ), //i
    .io_push_ready   (streamFifo_1_io_push_ready        ), //o
    .io_push_payload (sData_1_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_1_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_1_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_1_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_1_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  ConvOutput_Fifo streamFifo_2 (
    .io_push_valid   (sData_2_valid                     ), //i
    .io_push_ready   (streamFifo_2_io_push_ready        ), //o
    .io_push_payload (sData_2_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_2_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_2_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_2_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_2_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  ConvOutput_Fifo streamFifo_3 (
    .io_push_valid   (sData_3_valid                     ), //i
    .io_push_ready   (streamFifo_3_io_push_ready        ), //o
    .io_push_payload (sData_3_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_3_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_3_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_3_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_3_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  ConvOutput_Fifo streamFifo_4 (
    .io_push_valid   (sData_4_valid                     ), //i
    .io_push_ready   (streamFifo_4_io_push_ready        ), //o
    .io_push_payload (sData_4_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_4_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_4_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_4_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_4_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  ConvOutput_Fifo streamFifo_5 (
    .io_push_valid   (sData_5_valid                     ), //i
    .io_push_ready   (streamFifo_5_io_push_ready        ), //o
    .io_push_payload (sData_5_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_5_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_5_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_5_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_5_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  ConvOutput_Fifo streamFifo_6 (
    .io_push_valid   (sData_6_valid                     ), //i
    .io_push_ready   (streamFifo_6_io_push_ready        ), //o
    .io_push_payload (sData_6_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_6_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_6_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_6_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_6_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  ConvOutput_Fifo streamFifo_7 (
    .io_push_valid   (sData_7_valid                     ), //i
    .io_push_ready   (streamFifo_7_io_push_ready        ), //o
    .io_push_payload (sData_7_payload[7:0]              ), //i
    .io_pop_valid    (streamFifo_7_io_pop_valid         ), //o
    .io_pop_ready    (1'b0                              ), //i
    .io_pop_payload  (streamFifo_7_io_pop_payload[7:0]  ), //o
    .io_flush        (1'b0                              ), //i
    .io_occupancy    (streamFifo_7_io_occupancy[10:0]   ), //o
    .io_availability (streamFifo_7_io_availability[10:0]), //o
    .clk             (clk                               ), //i
    .reset           (reset                             )  //i
  );
  assign sData_0_fire = (sData_0_valid && sData_0_ready);
  assign In_Col_Cnt_valid = ((In_Col_Cnt_count == Matrix_Col) && sData_0_fire);
  assign In_Row_Cnt_valid = ((In_Row_Cnt_count == Matrix_Row) && In_Col_Cnt_valid);
  assign sData_0_ready = streamFifo_io_push_ready;
  always @(*) begin
    if(streamFifo_io_pop_valid) begin
      mData_payload[7 : 0] = streamFifo_io_pop_payload;
    end else begin
      mData_payload[7 : 0] = 8'h0;
    end
    if(streamFifo_1_io_pop_valid) begin
      mData_payload[15 : 8] = streamFifo_1_io_pop_payload;
    end else begin
      mData_payload[15 : 8] = 8'h0;
    end
    if(streamFifo_2_io_pop_valid) begin
      mData_payload[23 : 16] = streamFifo_2_io_pop_payload;
    end else begin
      mData_payload[23 : 16] = 8'h0;
    end
    if(streamFifo_3_io_pop_valid) begin
      mData_payload[31 : 24] = streamFifo_3_io_pop_payload;
    end else begin
      mData_payload[31 : 24] = 8'h0;
    end
    if(streamFifo_4_io_pop_valid) begin
      mData_payload[39 : 32] = streamFifo_4_io_pop_payload;
    end else begin
      mData_payload[39 : 32] = 8'h0;
    end
    if(streamFifo_5_io_pop_valid) begin
      mData_payload[47 : 40] = streamFifo_5_io_pop_payload;
    end else begin
      mData_payload[47 : 40] = 8'h0;
    end
    if(streamFifo_6_io_pop_valid) begin
      mData_payload[55 : 48] = streamFifo_6_io_pop_payload;
    end else begin
      mData_payload[55 : 48] = 8'h0;
    end
    if(streamFifo_7_io_pop_valid) begin
      mData_payload[63 : 56] = streamFifo_7_io_pop_payload;
    end else begin
      mData_payload[63 : 56] = 8'h0;
    end
  end

  assign sData_1_ready = streamFifo_1_io_push_ready;
  assign sData_2_ready = streamFifo_2_io_push_ready;
  assign sData_3_ready = streamFifo_3_io_push_ready;
  assign sData_4_ready = streamFifo_4_io_push_ready;
  assign sData_5_ready = streamFifo_5_io_push_ready;
  assign sData_6_ready = streamFifo_6_io_push_ready;
  assign sData_7_ready = streamFifo_7_io_push_ready;
  assign mData_valid = 1'b0;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      In_Col_Cnt_count <= 12'h0;
      In_Row_Cnt_count <= 12'h0;
    end else begin
      if(sData_0_fire) begin
        if(In_Col_Cnt_valid) begin
          In_Col_Cnt_count <= 12'h0;
        end else begin
          In_Col_Cnt_count <= (In_Col_Cnt_count + 12'h001);
        end
      end
      if(In_Col_Cnt_valid) begin
        if(In_Row_Cnt_valid) begin
          In_Row_Cnt_count <= 12'h0;
        end else begin
          In_Row_Cnt_count <= (In_Row_Cnt_count + 12'h001);
        end
      end
    end
  end


endmodule

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Fifo replaced by ConvOutput_Fifo

//ConvOutput_Fifo replaced by ConvOutput_Fifo

module ConvOutput_Fifo (
  input               io_push_valid,
  output              io_push_ready,
  input      [7:0]    io_push_payload,
  output              io_pop_valid,
  input               io_pop_ready,
  output     [7:0]    io_pop_payload,
  input               io_flush,
  output     [10:0]   io_occupancy,
  output     [10:0]   io_availability,
  input               clk,
  input               reset
);

  reg        [7:0]    _zz_logic_ram_port0;
  wire       [9:0]    _zz_logic_pushPtr_valueNext;
  wire       [0:0]    _zz_logic_pushPtr_valueNext_1;
  wire       [9:0]    _zz_logic_popPtr_valueNext;
  wire       [0:0]    _zz_logic_popPtr_valueNext_1;
  wire                _zz_logic_ram_port;
  wire                _zz_io_pop_payload;
  wire       [7:0]    _zz_logic_ram_port_1;
  wire       [9:0]    _zz_io_availability;
  reg                 _zz_1;
  reg                 logic_pushPtr_willIncrement;
  reg                 logic_pushPtr_willClear;
  reg        [9:0]    logic_pushPtr_valueNext;
  reg        [9:0]    logic_pushPtr_value;
  wire                logic_pushPtr_willOverflowIfInc;
  wire                logic_pushPtr_willOverflow;
  reg                 logic_popPtr_willIncrement;
  reg                 logic_popPtr_willClear;
  reg        [9:0]    logic_popPtr_valueNext;
  reg        [9:0]    logic_popPtr_value;
  wire                logic_popPtr_willOverflowIfInc;
  wire                logic_popPtr_willOverflow;
  wire                logic_ptrMatch;
  reg                 logic_risingOccupancy;
  wire                logic_pushing;
  wire                logic_popping;
  wire                logic_empty;
  wire                logic_full;
  reg                 _zz_io_pop_valid;
  wire                when_Stream_l1021;
  wire       [9:0]    logic_ptrDif;
  reg [7:0] logic_ram [0:1023];

  assign _zz_logic_pushPtr_valueNext_1 = logic_pushPtr_willIncrement;
  assign _zz_logic_pushPtr_valueNext = {9'd0, _zz_logic_pushPtr_valueNext_1};
  assign _zz_logic_popPtr_valueNext_1 = logic_popPtr_willIncrement;
  assign _zz_logic_popPtr_valueNext = {9'd0, _zz_logic_popPtr_valueNext_1};
  assign _zz_io_availability = (logic_popPtr_value - logic_pushPtr_value);
  assign _zz_io_pop_payload = 1'b1;
  assign _zz_logic_ram_port_1 = io_push_payload;
  always @(posedge clk) begin
    if(_zz_io_pop_payload) begin
      _zz_logic_ram_port0 <= logic_ram[logic_popPtr_valueNext];
    end
  end

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_pushPtr_value] <= _zz_logic_ram_port_1;
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_pushing) begin
      _zz_1 = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willIncrement = 1'b0;
    if(logic_pushing) begin
      logic_pushPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_pushPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_pushPtr_willClear = 1'b1;
    end
  end

  assign logic_pushPtr_willOverflowIfInc = (logic_pushPtr_value == 10'h3ff);
  assign logic_pushPtr_willOverflow = (logic_pushPtr_willOverflowIfInc && logic_pushPtr_willIncrement);
  always @(*) begin
    logic_pushPtr_valueNext = (logic_pushPtr_value + _zz_logic_pushPtr_valueNext);
    if(logic_pushPtr_willClear) begin
      logic_pushPtr_valueNext = 10'h0;
    end
  end

  always @(*) begin
    logic_popPtr_willIncrement = 1'b0;
    if(logic_popping) begin
      logic_popPtr_willIncrement = 1'b1;
    end
  end

  always @(*) begin
    logic_popPtr_willClear = 1'b0;
    if(io_flush) begin
      logic_popPtr_willClear = 1'b1;
    end
  end

  assign logic_popPtr_willOverflowIfInc = (logic_popPtr_value == 10'h3ff);
  assign logic_popPtr_willOverflow = (logic_popPtr_willOverflowIfInc && logic_popPtr_willIncrement);
  always @(*) begin
    logic_popPtr_valueNext = (logic_popPtr_value + _zz_logic_popPtr_valueNext);
    if(logic_popPtr_willClear) begin
      logic_popPtr_valueNext = 10'h0;
    end
  end

  assign logic_ptrMatch = (logic_pushPtr_value == logic_popPtr_value);
  assign logic_pushing = (io_push_valid && io_push_ready);
  assign logic_popping = (io_pop_valid && io_pop_ready);
  assign logic_empty = (logic_ptrMatch && (! logic_risingOccupancy));
  assign logic_full = (logic_ptrMatch && logic_risingOccupancy);
  assign io_push_ready = (! logic_full);
  assign io_pop_valid = ((! logic_empty) && (! (_zz_io_pop_valid && (! logic_full))));
  assign io_pop_payload = _zz_logic_ram_port0;
  assign when_Stream_l1021 = (logic_pushing != logic_popping);
  assign logic_ptrDif = (logic_pushPtr_value - logic_popPtr_value);
  assign io_occupancy = {(logic_risingOccupancy && logic_ptrMatch),logic_ptrDif};
  assign io_availability = {((! logic_risingOccupancy) && logic_ptrMatch),_zz_io_availability};
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_pushPtr_value <= 10'h0;
      logic_popPtr_value <= 10'h0;
      logic_risingOccupancy <= 1'b0;
      _zz_io_pop_valid <= 1'b0;
    end else begin
      logic_pushPtr_value <= logic_pushPtr_valueNext;
      logic_popPtr_value <= logic_popPtr_valueNext;
      _zz_io_pop_valid <= (logic_popPtr_valueNext == logic_pushPtr_value);
      if(when_Stream_l1021) begin
        logic_risingOccupancy <= logic_pushing;
      end
      if(io_flush) begin
        logic_risingOccupancy <= 1'b0;
      end
    end
  end


endmodule
