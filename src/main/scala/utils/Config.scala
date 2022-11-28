package utils

case class TopConfig(){
//layernorm config============================================================
    val CHANNEL_NUMS=384//通道数
    val CHANNEL_NUMS_WIDTH=12
    val TOKEN_NUMS=197//token 数
    val PIPELINE=8//8并行度


    val IN_DATA_WIDTH=64//输入数据位宽64bit

    //乘法器相关配置
        //Xq*C--P=A*B
    val XQC_A_WIDTH=8//
    val XQC_B_WIDTH=CHANNEL_NUMS_WIDTH//12
    val XQC_P_WIDTH=XQC_A_WIDTH+XQC_B_WIDTH//20
    val XQC_PIPELINE=3//这地方必须对照vivado Ip
    
    assert(XQC_P_WIDTH<=48)//如果使用Dsp48的话，输出位宽需要小于48
    

        //XQ2C--P=A*B+C==================
    val XQ2C_A_WIDTH=XQC_P_WIDTH//20
    val XQ2C_B_WIDTH=XQC_A_WIDTH//8
    val XQ2C_P_WIDTH=XQC_P_WIDTH+XQC_A_WIDTH//28,只做乘法，在外面累加
    val XQ2C_PIPELINE=3//这地方必须对照vivado Ip

    assert(XQ2C_P_WIDTH<=48)//如果使用Dsp48的话，输出位宽需要小于48
    
    val XQ2C_SUM_WIDTH=48//之前选的是32bit,但是32bit的位宽存在不用的可能

    
        //SUMXQ累加和位宽===========================
    val XQ_SUM_WIDTH=20//M2=sum(Xq)---20bit，与XqC位宽一样


        //Xq_Sum_Pow----M2=Sum(Xq)========
    val XQ_SUM_POW_PIPELINE=4//乘法器流水线级数

}