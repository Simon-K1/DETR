package utils

import spinal.core.log2Up

case class TopConfig(){
//layernorm config============================================================
    val MAX_CHANNEL_NUMS=1024//用于控制片上存储的使用
    val CHANNEL_NUMS_WIDTH=log2Up(MAX_CHANNEL_NUMS)
    
    val TOKEN_NUMS_WIDTH=20//token 因为单并行度的话就是197，但是8并行度这里需要改为25，矩阵需要被补0
        //TokenNums也就是矩阵的行数,最大支持1024*1024的图片展开
    val LAYERNORM_PIPELINE=1//8并行度
    
    val XQ_DATA_WIDTH=19//Xq-Zp，也就是处理了Ptf之后可以直接参与计算的Xq-Zp，因为数据需要移位0，1，2，3，8bit<<3-->所以最终的量化数据位宽是11bit
    //2023/5/51修正：因为(Xq-Zp)为16bit，不能用8bit来表示
    // val IN_DATA_WIDTH=PIPELINE*XQ_DATA_WIDTH//输入数据位宽64bit,上层输入的是8bit定点，之后才使用PTF因子进行移位操作变成11bit然后参与接下来的计算

    //乘法器相关配置
        //Xq*C--P=A*B
    val XQC_A_WIDTH=XQ_DATA_WIDTH//19
    val XQC_B_WIDTH=CHANNEL_NUMS_WIDTH//12
    val XQC_P_WIDTH=XQC_A_WIDTH+XQC_B_WIDTH//23
    val XQC_PIPELINE=3//这地方必须对照vivado Ip
    
    assert(XQC_P_WIDTH<=48,"XQC_P_WIDTH<=48")//如果使用Dsp48的话，输出位宽需要小于48
    

        //XQ2C--P=(Xq*C)*Xq
    val XQ2C_A_WIDTH=XQC_P_WIDTH//23
    val XQ2C_B_WIDTH=XQC_A_WIDTH//11
    val XQ2C_P_WIDTH=XQC_P_WIDTH+XQC_A_WIDTH//34,只做乘法，在外面累加
    val XQ2C_PIPELINE=3//这地方必须对照vivado Ip

    // assert(XQ2C_P_WIDTH<=48,s"XQ2C_P_WIDTH<=48,XQ2C_P_WIDTH is {$XQ2C_P_WIDTH}")//如果使用Dsp48的话，输出位宽需要小于48
    printf(s"警告,位宽好像优点大:XQ2C_P_WIDTH<=48,XQ2C_P_WIDTH is {$XQ2C_P_WIDTH}")//如果使用Dsp48的话，输出位宽需要小于48
    
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

    //Scale*A*Recipro_Sqrt,Scale_A_ReciproSqrt==========最后Scale*A*B的计算===============
    val SCALE_A_RECIPROSQRT_Aport_WIDTH=40//XQ_SUBSTRACT_M2_WIDTH+SCALE_WIDTH
    val SCALE_A_RECIPROSQRT_Bport_WIDTH=24//23+1
    val SCALE_A_RECIPROSQRT_Pport_WIDTH=SCALE_A_RECIPROSQRT_Aport_WIDTH+SCALE_A_RECIPROSQRT_Bport_WIDTH
    val SCALE_A_RECIPROSQRT_PIPELINE=5
    
//================================================================================================
    //Embedding layer部分，仅供参考
    val PICTURE_CHANNEL=3//3个输入通道
    val PICTURE_SIZE=224//图片大小224*224
    val PATCH_SIZE=16//Patch的大小，也就是卷积核的大小，16*16,用这个来指导图片Buff的创建
    val EMBEDDING_DIm=384//也就是卷积核的输出通道数
    val PATCH_PARALLEL=8//并行度为8，1入8出
    val PATCH_PIXEL_WIDTH=8//8bit的图片像素点
        //有关Bram的配置
            //入位宽64bit对于dma 的axis的数据位宽，
    val PATCH_BRAM_IN_WIDTH=64//Bram一下进64bit
    val PATCH_BRAM_OUT_WIDTH=PATCH_PIXEL_WIDTH//要求PATCH_BRAM_OUT_WIDTH与PATCH_BRAM_IN_WIDTH为8倍数关系
    val PATCH_BRAM_OUT_DEPTH=PICTURE_CHANNEL*PICTURE_SIZE//每个Bram的存储一行的数据，需要考虑输入通道
    val PATCH_BRAM_IN_DEPTH=PATCH_BRAM_OUT_DEPTH/(PATCH_BRAM_IN_WIDTH/PATCH_BRAM_OUT_WIDTH)
//===================================================================================================
    //脉动阵列相关配置(暂时写死,之后写成可配置)
    val SA_ROW=8//阵列行数
    val SA_COL=8//阵列列数



    //Data_Generate 部分
    val DATA_GENERATE_IN_DATA_NUM=8//一下进8个点
    val DATA_GENERATE_BRAM_IN_WIDTH=64//入128bit
    val DATA_GENERATE_BRAM_OUT_WIDTH=64//出64bit

    val MAX_IN_KERNELSIZE=16//可支持的最大卷积核
    val MAX_IN_PICTURE_SIZE=256//可支持的最大图片尺寸
    val MAX_IN_CHANNEL=16//可支持的最大输入通道

    val DATA_GENERATE_BRAM_IN_ADDR_DEPTH=MAX_IN_KERNELSIZE*MAX_IN_PICTURE_SIZE*MAX_IN_CHANNEL*2/8//224*32，Bram用于缓存输入图片数据，这个Bram的深度必须确保能存够KernelSize*KernelSize*InChannel*2的数据
    val DATA_GENERATE_BRAM_OUT_ADDR_DEPTH=DATA_GENERATE_BRAM_IN_ADDR_DEPTH*(DATA_GENERATE_BRAM_IN_WIDTH/DATA_GENERATE_BRAM_OUT_WIDTH)
    //Conv相关
        //由于卷积核大小,步长都是可以在计算过程中动态配置,所以这里的配置只需要设置位宽大小即可
    val DATA_GENERATE_CONV_STRIDE_WIDTH=5//8 bit的stride，可配置，通过axi lite配置
    val DATA_GENERATE_CONV_KERNELSIZE_WIDTH=5//卷积核大小,最大可支持的卷积核大小为31，不能是0
    val DATA_GENERATE_CONV_IN_CHANNEL_WIDTH=10//最大可支持的输入通道是1024,多了就得拆或者加大Bram的存储深度
    val DATA_GENERATE_CONV_OUT_CHANNEL_WIDTH=10//输出通道同样也是1024
    

    //weight cache部分,权重缓存部分
    val WEIGHT_CACHE_BRAM_IN_DATA_WIDTH=64//入64 bit,也可以认为是连接权重缓存模块DMA的位宽
    val WEIGHT_CACHE_BRAM_OUT_DATA_WIDTH=8//出8 bit,8个Bram拼起来满足脉动阵列所需的64bit输入位宽
    

    val WEIGHT_CACHE_MATRIX_COL_WIDTH=16//权重缓存模块支持的权重矩阵的最大列数为2^16(一般达不到这么大，以后可以改小一点)
    val WEIGHT_CACHE_MATRIX_ROW_WIDTH=16//最大行数，也是2^16,最大输出图片大小为512*512

    val WEIGHT_CACHE_MATRIX_MAX_ROW=2048//最大可支持的权重矩阵的行数
    val WEIGHT_CACHE_MATRIX_MAX_COL=64//最大可支持的权重矩阵的列数
        //可以推出每个权重缓存bram的深度就是MAX_ROW*MAX_COL/8,这里的8是脉动阵列的列数

    //用于卷积之后的数据排列模块===================================================================================
    val MATRIXC_COL_WIDTH=12//最大可支持的输出矩阵大小为2^12=4096列，也可以认为是4096个输出通道
    val MATRIXC_ROW_WIDTH=20//输出矩阵的行数可能会很大，比如1024*1024，2048*2048
    //卷积和矩阵量化==============================================================================================
    val QUAN_MAX_MATRIX_COL=512//目前先拿一个Bram存Scale，Bias这些信息

    val QUANT_FACTOR_WIDTH=32   
    //以下配置来源于刘炜的卷积加速器
        val addChannelTimesWidth=32//通道累加后的脉动阵列输出位宽
        
}