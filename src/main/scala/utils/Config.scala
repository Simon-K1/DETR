package utils

case class TopConfig(){
//layernorm config============================================================
    val CHANNEL_NUMS=384//通道数
    val CHANNEL_NUMS_WIDTH=12
    val TOKEN_NUMS=197//token 数
    val PIPELINE=8//8并行度

    val XQ_DATA_WIDTH=11//Xq即量化后的数据，也就是处理了Ptf之后的数，因为数据需要移位0，1，2，3，8bit<<3-->所以最终的量化数据位宽是11bit
    val IN_DATA_WIDTH=PIPELINE*XQ_DATA_WIDTH//输入数据位宽64bit,上层输入的是8bit定点，之后才使用PTF因子进行移位操作变成11bit然后参与接下来的计算

    //乘法器相关配置
        //Xq*C--P=A*B
    val XQC_A_WIDTH=XQ_DATA_WIDTH//11
    val XQC_B_WIDTH=CHANNEL_NUMS_WIDTH//12
    val XQC_P_WIDTH=XQC_A_WIDTH+XQC_B_WIDTH//23
    val XQC_PIPELINE=3//这地方必须对照vivado Ip
    
    assert(XQC_P_WIDTH<=48)//如果使用Dsp48的话，输出位宽需要小于48
    

        //XQ2C--P=(Xq*C)*Xq
    val XQ2C_A_WIDTH=XQC_P_WIDTH//23
    val XQ2C_B_WIDTH=XQC_A_WIDTH//11
    val XQ2C_P_WIDTH=XQC_P_WIDTH+XQC_A_WIDTH//34,只做乘法，在外面累加
    val XQ2C_PIPELINE=3//这地方必须对照vivado Ip

    assert(XQ2C_P_WIDTH<=48)//如果使用Dsp48的话，输出位宽需要小于48
    
    val XQ2C_SUM_WIDTH=48//之前选的是32bit,但是32bit的位宽存在不用的可能，其实48bit已经够用了

    
        //SUMXQ累加和位宽
    val XQ_SUM_WIDTH=20//M2=sum(Xq)---20bit，与XqC位宽一样,目前暂时使用20bit，因为有正有负累加


        //Xq_Sum_Pow----M2=Sum(Xq)
    val XQ_SUM_POW_PIPELINE=4//乘法器流水线级数
//根号下分之一计算====================================================================
        //定点转浮点延时
    val FI32_2_SINGLE_PIPELINE=6
        //根号下分支一延时
    val RECIPROCAL_SQRT_PIPELINE=33
//Scale*A计算，Scale_Multiply_A
    val XQ_SUBSTRACT_M2_WIDTH=32//有符号20bit
    val SCALE_WIDTH=8//直接取整变成8bit输入
    val SCALE_A_PIPELINE=4//乘法器流水线级数
    
}