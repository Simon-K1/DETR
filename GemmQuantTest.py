import torch 
import numpy as np
def new_bias_ForMM(z1, q2, bias):  #这里是针对矩阵计算的量化
    #输入数据格式：q2：二维矩阵，如果是一个展开的卷积权重，那么q2的列数就是卷积核的个数

    q2 = q2.type(torch.float64)
    bias1 = z1 * q2
    shape = bias1.shape
    n_bias = np.zeros(shape[1], dtype=np.float64, order='C')#遍历全部通道，权重矩阵的列数也就是通道数
    for m in range(shape[1]):  # bias1的维度是M C K K 将C K K 做累加 变成M维
        n_bias[m] = bias1[:,m].sum()  # 从第一组开始一直有m组，m是输出通道数
        # print()
        n_bias[m] = (bias[m] - n_bias[m])  # 做减法
    # print(n_bias) 第一层n_bias是一维32个
    # exit()
    daxiao = shape[1]  # 第一层是32
    SCALE = np.zeros(daxiao, dtype=np.float64, order='C')
    # N_REAL = np.zeros(daxiao, dtype=np.float32, order='C')
    N_REAL = []
    for i, ii in enumerate(n_bias):  # i和ii就是从n_bias中取值
        index = 0

        while not (abs(ii) >= (2 ** 23) and abs(ii) <= (2 ** 24)):
            if index >= 16:  # fpga里面最多移动16位,所有成到16就停止了,这样精度也够了
                break
            else:
                ii *= 2
                index = index + 1

        N_REAL.append(index)
        SCALE[i] = round(ii)
    out_bias = []
    out_bias_bin=[]
    for index in range(shape[0]):
        data_integer_old = ('{:024b}'.format(int(SCALE[index]) & 0xffffff))  # {:024b} 24位2二进制不足补0；& 0xffffff按位与
        n = N_REAL[index]
        symbol = '0'
        if n_bias[index] < 0:  # 符号位
            symbol = '1'#这里也不是多此一举，因为如果你给一个uint24，MSB=1，那么你在FPGA那边如何分辨这是正数还是负数，所以还是需要1bit的符号位来帮助fpga做判断的
        elif n_bias[index] > 0:
            symbol = '0'
        data_integer = data_integer_old[8:]
        data_decimal = '{:07b}'.format(int(n))
        out_bias1 = symbol + str(data_decimal) + str(data_integer_old)  # 1bit+7bit+24bit
        a = int(out_bias1, 2)  # 转成int型 out_bias1为二进制 ；a是十进制
        out_bias.append(a)  # 一个一个写入out_bias
        out_bias_bin.append(out_bias1)
    # print(out_bias)
    # exit()
    return out_bias,out_bias_bin



if __name__== '__main__':
    z1=torch.rand(1)
    q2=torch.rand(2304,768)
    Bias=torch.rand(2304)
    [Bias,Bias_Bin]=new_bias_ForMM(z1,q2,Bias)
    print("End")