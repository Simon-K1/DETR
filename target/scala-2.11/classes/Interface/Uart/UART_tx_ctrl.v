module UART_tx_ctrl(readdy,uart_tx,send,data,clk);
    input send,clk;
    input [7:0]data;
    output ready,uart_tx;
    parameter baud =9600 ;
    parameter bit_index_max =10 ;
    localparam[31:0] baud_timer=100000000/baud;
    localparam RDY=2'b00,LOAD_BIT=2'b01,SEND_BIT=2'b10;
    reg [1:0]   state=RDY;
    reg [31:0]  timer=0;
    reg [9:0]   txData;
    reg [3:0]   bitIndex;
    reg txBit=  1'b1;

    case (state)
        RDY:begin
            if(send)begin
                txData<={1'b1,data,1'b0};
            
            end

        end

    endcase


endmodule