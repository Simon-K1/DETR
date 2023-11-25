module Axilite_Vip(
    input clk,
    input rst,
    input start,
    output reg          regSData_awvalid,
    input               regSData_awready,
    output     [19:0]regSData_awaddr,
    output reg     [2:0]regSData_awprot,

    output reg         regSData_wvalid,
    input              regSData_wready,
    output reg   [31:0]regSData_wdata,
    output reg   [3:0] regSData_wstrb,
    input              regSData_bvalid,
    output reg         regSData_bready,
    input     [1:0]    regSData_bresp,
    output reg         regSData_arvalid,
    output reg         regSData_arready,
    output reg   [19:0]regSData_araddr,
    output reg    [2:0]regSData_arprot,
    input              regSData_rvalid,
    output reg         regSData_rready,
    input     [31:0]   regSData_rdata,
    input     [1:0]    regSData_rresp

);
//向A寄存器里写一个数，将A寄存器的输出连到B寄存器的输入，然后再从B寄存器中读出来，检查对不对。
// reg Write_Finish;
// assign regSData_awvalid=~Write_Finish;
assign regSData_awaddr='d0;
//首先控制AWValid,向从机写入一个读地址
always@(posedge clk or posedge rst)begin
    if(rst)begin
        regSData_awvalid<='d0;
        // regSData_awaddr<='d0;
        regSData_awprot<='d0;
        regSData_wvalid<='d0;
        regSData_wdata<='d0;
        regSData_wstrb<='d0;
        regSData_bready<='d0;
        regSData_arvalid<='d0;
        regSData_arready<='d0;
        regSData_araddr<='d0;
        regSData_arprot<='d0;
        regSData_rready<='d0;
        // LD4567<='d0;

        //Write_Finish<=1'b1;//写完成
    end
    else begin
        if(start)begin//外部给一个start信号，开始写0号寄存器
            regSData_awvalid<=1'b1;
        end
        else if(regSData_awvalid&&regSData_awready)begin //当从机接收到写地址后，写地址拉低，同时写数据拉高，
            regSData_awvalid<=~regSData_awvalid;
            regSData_wvalid<=1'b1;
        end
        else if(regSData_wvalid&&regSData_wready)begin
            regSData_wvalid<=1'b0; //发完数据后即可拉低写valid信号，然后写数据加1
            regSData_wdata<=regSData_wdata+1'b1;
        end
    end
    
end
endmodule