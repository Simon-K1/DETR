ila_2 ilaCheck(
    .clk(clk),
    .probe0(Fsm_currentState),//状态
    .probe1(wr_cnt_count),
    .probe2(rd_cnt_count),
    .probe3(wr_data),
    .probe4(rd_data),
    .probe5(rd_valid),
    .probe6(wr_valid),
    .probe7(rd_opt),
    .probe8(device_ready),
    .probe9(Check_Addr1),
    .probe10(Check_Addr2),
    .probe11(Error_Flag),
    .probe12(wdata_cahce_doutb),
    .probe13(rdata_cahce_doutb)
);