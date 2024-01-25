import torch
import numpy as np
import math


def gen_B(S1, S2, S3):  # 第一组  β即N_REAL  +++++求shitf++++
    M = (S1 * S2) / S3
    M.squeeze()
    M=M.cpu()#先将tensor放到cpu上
    M = M.numpy()
    
    daxiao = S2.shape[0]  # 第一层权重的shape[0]是32 shape[0]表示行数 是一维大小位32的列向量
    SCALE = np.zeros(daxiao, dtype=np.uint32, order='C')  # 相当于32个输出通道 每个对应一组shift
    N_REAL = np.zeros(daxiao, dtype=np.uint32, order='C')
    for i, ii in enumerate(M):  # enumerate() 函数用于将一个可遍历的数据对象(如列表、元组或字符串)组合为一个索引序列，同时列出数据和数据下标

        while not (ii >= 0.5 and ii <= 1.0):  # 左移到（0.5，1） 左移一次相当于*2
            ii *= 2
        pass
        mmmm = ii * (2 ** 32)  # 乘2^32  真他妈服了，这地方存在溢出的问题

        SCALE[i] = mmmm.astype(np.int32)

    for i, ii in enumerate(M):
        N_REAL[i] = round(math.log(SCALE[i] / ii, 2)) - 32   # fpga加了1这里要减1,  β值也是m维 相当于存的mmmm
        if int(N_REAL[i])<0:
            print("error\n")
        if N_REAL[i] !=0:
            N_REAL[i]=N_REAL[i]-1

    return N_REAL


def gen_M_N(S1, S2, S3):  # 第二组求M'即M  ++++++返回scale和shift+++++
    daxiao = S2.shape[0]
    M = np.zeros(daxiao, dtype=np.uint32, order='C')
    N_REAL = gen_B(S1, S2, S3)
    M = np.zeros(S2.shape[0])
    
    for i, ii in enumerate(M):
        Scale=(S1*S2[i]/S3).cpu()
        # Scale=Scale.numpy
        M[i] = (torch.round(Scale * (2 ** (32 + N_REAL[i] + 1)))).numpy()  # s1s2/s3 *2^(32+β+1)
    M = M.astype(np.uint32)
    # exit()
    return M, N_REAL


# r_b=s1*s2*q_b
# r_b是量化前的bias,q_b是量化后的bias
def gen_int_bias(s1, s2, bias_float):  # 求bias/s1s2即bb
    aa = bias_float / s1
    # print(bias_float)
    # exit()
    bb = torch.div(aa, s2)  # 对应元素做除法

    # for i, m in enumerate(bb):
    #     bb[i] = round(m.item())
    # bias = bb.int()
    return bb


def gen_M(s1, s2, s3):
    aa = s1 * s2
    M = aa / s3
    return M


def new_bias(z1, q2, bias):  # 求最终的bias=bias/s1s2-q2z1
    q2 = q2.type(torch.float64)
    bias1 = z1 * q2
    shape = bias1.shape
    n_bias = np.zeros(shape[0], dtype=np.float64, order='C')
    for m in range(shape[0]):  # bias1的维度是M C K K 将C K K 做累加 变成M维
        n_bias[m] = bias1[m, :, :, :].sum()  # 从第一组开始一直有m组，m是输出通道数
        # print()
        n_bias[m] = (bias[m] - n_bias[m])  # 做减法
    # print(n_bias) 第一层n_bias是一维32个
    # exit()
    daxiao = shape[0]  # 第一层是32
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


def get_add_bias(new, shape, old):  # 补0
    for kernel_num in range(shape):
        new[kernel_num] = old[kernel_num]
    return new


def get_add_SCALE(new, shape, old):  # 补0
    for kernel_num in range(shape):
        new[kernel_num] = old[kernel_num]
    return new


def get_add_NREAL(new, shape, old):  # 补0
    for kernel_num in range(shape):
        new[kernel_num] = old[kernel_num]
    return new


def get_weight(new_weight, shape, weight, inchannel):  # 八入八出操作 输入通道inchannel不固定 输出通道outchannel为8
    j = 0

    shift_num = 0
    for index in range(inchannel):
        if (inchannel == (1 << index)):  # index不停左移一位直到与inchannel相等 来判断移了几位   2的shift_num次方=inchannel
            shift_num = index
            break
    # if shape[0] == 32 and shape[1] == 64 and shape[2] == 1:
    #     # print("shape:",new_weight.shape)
    #     with open('weight_1x1_8i8o(2).txt', 'a')as f:
    #         f.write('-' * 40 + '\n')
    #         f.write(str(shape) + '\n')
    for i in range(shape[2]):  # mckk  K
        for ii in range(shape[3]):  # K
            for kernel_times in range(shape[0] >> 3):  # >>右移三位 因为输出通道outchannel默认为8 卷积核个数
                for channel_in_times in range(shape[1] >> shift_num):  # 右移shift_num 输入通道数
                    for iii in range(8):  # shape[0] >> 3 右移了3次即2^3 要补8次
                        for iiii in range(
                                inchannel):  # shape[1] >> shift_num 右移了shift_num即2^shift_num 要补inchannel次(2^shift_num =inchannel)
                            # print('++++++++++++++++++')
                            weight[j] = new_weight[kernel_times * 8 + iii][channel_in_times * inchannel + iiii][i][ii]
                            # if shape[0] == 32 and shape[1] == 64 and shape[2] == 1:
                            # with open('weight_1x1_8i8o(2).txt', 'a')as f:
                            #     f.write(str(kernel_times * 8 + iii) + ',')
                            #     f.write(str(channel_in_times * inchannel + iiii) + ',')
                            #     f.write(str(i) + ',')
                            #     f.write(str(ii) + '\n')
                            #
                            j += 1
    # exit()
    return weight


def add_weight_channel(new_weig, weig, shape):  # 补0 把weig存入new_weig；new_weig是全0，
    for kernel_num in range(shape[0]):
        for channel_in_num in range(shape[1]):
            for row in range(shape[2]):
                for col in range(shape[3]):
                    new_weig[kernel_num][channel_in_num][row][col] = weig[kernel_num][channel_in_num][row][col]
    return new_weig


def tensorr(x):
    tensor_py = torch.from_numpy(np.load(x))  # 创建tensor
    return tensor_py


def get_weight2(new_weight, shape, weight):  # 四维权重写成一维
    j = 0
    for kernel_times in range(shape[0]):
        for channel_in_times in range(shape[1]):
            for i in range(shape[2]):
                for ii in range(shape[3]):
                    # print('++++++++++++++++++')
                    weight[j] = new_weight[kernel_times][channel_in_times][i][ii]
                    j += 1
    return weight

from OnBoard import Generate_Bin
if __name__ == '__main__':

    Image=torch.randint(0,255,[1,3,224,224])
    print(Image[0,:,0,0])
    print(Image[0,:,0,1])
    Generate_Bin(Image,"Image","BinPath")
    # 创建一个示例矩阵
    # matrix = torch.randn(197, 768)
    # # 使用plt.imshow()显示热度图
    # plt.imshow(matrix, cmap='hot', interpolation='nearest')
    # # 添加颜色条
    # plt.colorbar()
    # # 显示图像
    # plt.show()
    
    exit()
    OC=768
    Q1Q2=123
    for i in range(1):
        S1=torch.rand(1)*0.499+0.001
        S2=torch.rand(OC)*0.499+0.001
        S3=torch.rand(1)*0.499+0.001
        Zero=torch.randint(0,255,(1,))
        weight=torch.randint(0, 6, (OC,8,3,3))

        # print("[",i,"]",S1,S2,S3)
        SCALE, N_REAL = gen_M_N(S1, S2, S3)
        bias=torch.rand(OC)*0.499+0.001
        Z1=torch.rand(1)*0.499+0.001
        Bias_Tmp=gen_int_bias(S1,S2,bias)#获取bias/(S1S2)
        
        [Bias,out_bias_bin] = new_bias(Z1, weight, Bias_Tmp)#Bias也需要被放大
        BiasAdd=torch.zeros(OC)
        for i in range(OC):#计算Bias_Add
            Bias_Bin = bin(Bias[i])[2:].zfill(32)#需要注意的是，这里直接用bin函数，会包含0b这种字符
            #↑这里直接截取2：end而不考虑“-0b”这种情况是因为我们自己再new_bias里面重新定义了Bias的格式，仔细看看就明白了
            #当然这里也能直接用out_bias_bin
            #zfill好像只会补零

            # assert(len(Bias_Bin)==32)
            Sign=Bias_Bin[0]
            print(Sign)
            Bias_Shift=int(Bias_Bin[1:7],2)#二进制转化为十进制
            Bias_Tmp=Sign*(8+Bias_Shift)+Bias_Bin[9:31]
            # 补码转十进制
            if Bias_Tmp[0] == "1":
                # 将二进制字符串作为无符号整数解释，然后减去2的补码位数次方
                Bias_Tmp = int(Bias_Tmp, 2) - (1 << len(Bias_Tmp))
            else:
                # 直接将二进制字符串作为无符号整数解释
                Bias_Tmp = int(Bias_Tmp, 2)
            BiasAdd[i]=Bias_Tmp+Q1Q2*2^16
        


        #接下来开始计算Scale*Bias_Add
        ScaleMul=torch.mul(torch.tensor(SCALE.astype(np.float32)),BiasAdd)

        #乘完SCALE后再Shift
        DataShift_Result=torch.zeros(OC)
        negnum=0;
        for i in range(OC):
            #先获取二进制值
            ScaleMul_Bin=bin(int(ScaleMul[i]))#python的bin函数可以记录正数还是负数
            length=len(ScaleMul_Bin)
            if ScaleMul_Bin[0]=='-':#如果是负数
                DataShift_Result[i]=int('-0b'+ScaleMul_Bin[3:length-N_REAL[i]][0:15],2)+int(ScaleMul_Bin[3:length-N_REAL[i]][15],2)#取高15位
                print("Detect negative","[",i,"]:",DataShift_Result[i])
                negnum+=1#负数有多少个
            else:
                DataShift_Result[i]=int(ScaleMul_Bin[2:length-N_REAL[i]][0:15],2)+int(ScaleMul_Bin[2:length-N_REAL[i]][15],2)#取高15位，并且四舍五入，看要不要加一
        #shift完后拿得到的16bit继续和zeropoint相加并且做clip(0,255)
        AddZero=[]
        for i in range(OC):
            AddZero.append(torch.clamp(DataShift_Result[i]+Zero,0,255))
        # exit()
        print(AddZero)


