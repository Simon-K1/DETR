#构建完整的一个transformer
import torch
from torchvision.models import AlexNet
import torch.nn as nn
from torchviz import make_dot
from collections import OrderedDict
from functools import partial
from itertools import repeat
import collections.abc
import torch.optim as optim
import time
#Trasnforemr相关组件====================================
def _ntuple(n):
    def parse(x):
        if isinstance(x, collections.abc.Iterable):
            return x
        return tuple(repeat(x, n))

    return parse
to_2tuple = _ntuple(2)

class proj(nn.Module):#默认为vit—base
    # patch_size=16,
    # embed_dim=768,
    # depth=12,
    # num_heads=12,
    # mlp_ratio=4,

    def __init__(self,In_Channels:int=1,Out_Channels:int=768,img_size:int=224,patch_size:int=16):
        super(proj,self).__init__()
        self.proj=nn.Conv2d(in_channels=In_Channels,out_channels=Out_Channels, kernel_size=patch_size,stride=patch_size,)
        # img_size = to_2tuple(img_size)
        # patch_size = to_2tuple(patch_size)
        self.img_size = img_size
        self.patch_size = patch_size
        self.grid_size = (img_size // patch_size,
                          img_size // patch_size)
        self.num_patches = self.grid_size[0] * self.grid_size[1]
        self.cls_token = nn.Parameter(torch.randn(1, 1, Out_Channels))
        self.pos_embedding = nn.Parameter(torch.randn(1, self.num_patches + 1, Out_Channels))
    def forward(self,x):
        # print(x.shape)
        Input_Shape=x.shape
        x = self.proj(x)
        x=torch.flatten(x,2).transpose(1, 2)
        cls_token=self.cls_token.expand(Input_Shape[0],-1,-1)
        x=torch.cat((cls_token,x),dim=1)
        x+=self.pos_embedding

        return x

#搭建Vit
class Vit(nn.Module):
    #example:
    # In_Channels=3
    # Embed_Dim=384
    # Picture_Size=224
    # Patch_Size=16
    # Num_Class=3
    # Num_Heads=6
    # Encoder_Layers=6
    # model=Vit(In_Channels=In_Channels,Out_Channels=Embed_Dim,Picture_Size=Picture_Size,Patch_Size=Patch_Size
    # ,Num_Class=Num_Class,Num_Heads=Num_Heads,Encoder_Layers=Encoder_Layers)
    def __init__(self,In_Channels:int=3,Out_Channels:int=768,Picture_Size:int=224,Patch_Size:int=16,Num_Class:int=1,Num_Heads:int=8,Encoder_Layers:int=12):
        super(Vit,self).__init__()
        self.In_Channels=In_Channels
        # self.Batch_Size=2
        self.Embed_Dim=Out_Channels
        self.Picture_Size=Picture_Size
        # self.x=torch.rand(Batch_Size,In_Channels,Picture_Size,Picture_Size)
        self.patch_embed=proj(In_Channels=self.In_Channels,Out_Channels=self.Embed_Dim)
        # self.Embedding_Out=Embedding_Layer(x)

        self.Num_Heads=Num_Heads
        self.Encoder_layers=Encoder_Layers
        #开始构建Encoder
        #[B,H,W]
        # self.cls_token = nn.Parameter(torch.zeros(1, 1, self.Embed_Dim))
        # num_patches = self.patch_embed.num_patches
        # self.pos_embed = nn.Parameter(
        #     torch.zeros(1, num_patches + 1, self.Embed_Dim))
        
        

        self.Single_Encoder = nn.TransformerEncoderLayer(d_model=self.Embed_Dim, nhead=self.Num_Heads,batch_first=True,norm_first=True)#在Vit中的norm需要位于atten和FF之前
        self.Encoders= nn.TransformerEncoder(self.Single_Encoder,num_layers=self.Encoder_layers,norm=None)#构建多个连在一起的Encoder
                                                                            #nomrm 就是在末尾加一个normlization

        self.norm=nn.LayerNorm(self.Embed_Dim,)
        
        self.Num_Class=Num_Class
        self.head=nn.Linear(self.Embed_Dim,self.Num_Class)
        self.pre_logits = nn.Identity()


        self.emb_dropout=0.1
        self.dropout = nn.Dropout(self.emb_dropout)
        # print(Class_Out.shape)
                
                                                    
    def forward(self,x):
        x=self.patch_embed(x)
        
        B=x.shape[0]
        H=x.shape[1]
        W=x.shape[2]
        Encoder_Out=self.Encoders(x)

        # cls_tokens = self.cls_token.expand(
        #     B, -1, -1)  # stole cls_tokens impl from Phil Wang, thanks
        # # print(Encoder_Out.shape)
        # Encoder_Out = torch.cat((cls_tokens, Encoder_Out), dim=1)
        # Encoder_Out = Encoder_Out + self.pos_embed

        Norm_Out=self.norm(Encoder_Out)
        Norm_Out=Norm_Out[:,0]
        Class_Out=self.head(Norm_Out)
        return Class_Out
# Layer0=Vit(In_Channels,Embed_Dim,Picture_Size,Patch_Size=Patch_Size)
# export_onnx(Picture,Layer0)