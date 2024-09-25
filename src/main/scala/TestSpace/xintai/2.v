module test(
	input	clk		,//100MHz
	input	rst_n	,//
	input	signal_in	,//输入的信号
	
	output	signal_out
);
	parameter CNT_1US = 8'd100;//100M时钟下，1us需要数100下

	reg [7:0] cnt_delay;//设计一个计数器
	
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_delay <= 0;
		else if(signal_in)begin//如果输入信号有效
			if(cnt_delay >= CNT_1US)//如果超过这个时间，就保持即可
				cnt_delay <= cnt_delay;
			else//开始计数
				cnt_delay <= cnt_delay + 1'b1;
		end
		else
			cnt_delay <= 0;
	end
	
	assign signal_out = (cnt_delay == CNT_1US - 1'b1);
	
endmodule 
