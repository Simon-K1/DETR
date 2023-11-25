Sramwidth=64//Sram的输出位宽
ByteNums=Sramwidth/8
WindowSize=K*K*C/ByteNums
for OutRow=1:H'
    initial FIFO2 With FIFO1//用FIFO1的数据初始化FIFO2
    for OutCol=1:W'/Scol
        for OutChannel=1:C'/Scol
    		for Window_Row=1:K
    			for Window_Col=1:K
    				for InChannel=1:C/ByteNums
    				    for s=1:Srow//
    					    Systolic_s←ReadSram(rAddr)
                            rAddr=rAddr+WindowSize
    				    end
        			end
        		end
    	    end
        end
    end
end


%% windowflatten
rowbase_addr=(rowNum-1)*W*C
for row=0:K-1
    
    for windowcol=0:k-1
        for InChannelcnt=0:C/M
            for SA_row=0:N-1
                raddr=(row+rowNum-1)*W*C/M+windowcol*C/M+(S*C/M)*SA_row+InChannelcnt
                output=readmem(
                
            end
        end
        
    end
end