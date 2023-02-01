import torch.nn as nn
import torch
import collections.abc
import math
import os
import re
import warnings
from collections import OrderedDict
from functools import partial
from itertools import repeat

import torch.nn.functional as F


#=============================================
class Test_Net(nn.Module):
    def __init__(self,In_Channels:int=1):
        super(Test_Net,self).__init__()
        self.conv1=nn.Conv2d(in_channels=In_Channels,out_channels=768, kernel_size=16,stride=16,)
        self.linear=nn.Linear(768,768*3)
        
    def forward(self,x):
        x=self.conv1(x)#Conv的输出[B,C,H,W]
        x=x.flatten(2)#[B,C,H*W]
        x=torch.transpose(x,1,2)
        x=self.linear(x)
        x=torch.softmax(x,dim=2)
        return x
def Test_Test_Net():
    model_fp = Test_Net(In_Channels=3)
    outPut=model_fp(torch.rand(1,3,224,224))
    print(outPut)


#Trasnforemr相关组件====================================
def _ntuple(n):
    def parse(x):
        if isinstance(x, collections.abc.Iterable):
            return x
        return tuple(repeat(x, n))

    return parse
to_2tuple = _ntuple(2)

class PatchEmbed(nn.Module):#默认为vit—base
    # patch_size=16,
    # embed_dim=768,
    # depth=12,
    # num_heads=12,
    # mlp_ratio=4,

    def __init__(self,In_Channels:int=1,Out_Channels:int=768,img_size:int=224,patch_size:int=16):
        super(PatchEmbed,self).__init__()
        self.proj=nn.Conv2d(in_channels=In_Channels,out_channels=Out_Channels, kernel_size=patch_size,stride=patch_size,)
        img_size = to_2tuple(img_size)
        patch_size = to_2tuple(patch_size)
        self.img_size = img_size
        self.patch_size = patch_size
        self.grid_size = (img_size[0] // patch_size[0],
                          img_size[1] // patch_size[1])
        self.num_patches = self.grid_size[0] * self.grid_size[1]
    def forward(self,x):
        x = self.proj(x).flatten(2).transpose(1, 2)
        return x
def Test_PatchEmbed():
    model=PatchEmbed(In_Channels=1,Out_Channels=384)
    model(torch.rand(1,1,224,224))

#=====================================================================================================
class VisionTransformer(nn.Module):
    """Vision Transformer
    A PyTorch impl of : `An Image is Worth 16x16 Words: Transformers for Image Recognition at Scale`  -
        https://arxiv.org/abs/2010.11929
    """

    def __init__(self,
                 img_size=224,
                 patch_size=16,
                 in_chans=3,
                 num_classes=1000,
                 embed_dim=768,
                 depth=12,
                 num_heads=12,
                 mlp_ratio=4.0,
                 qkv_bias=True,
                 qk_scale=None,
                 representation_size=None,
                 drop_rate=0.0,
                 attn_drop_rate=0.0,
                 drop_path_rate=0.0,
                 hybrid_backbone=None,
                 norm_layer=None,
                 quant=False,
                 calibrate=False,
                 input_quant=False,
                 cfg=None):
        super().__init__()
        self.num_classes = num_classes
        self.num_features = (
            self.embed_dim
        ) = embed_dim  # num_features for consistency with other models
        norm_layer = norm_layer or partial(nn.LayerNorm, eps=1e-6)

        self.cfg = cfg
        self.input_quant = input_quant
        # if input_quant:
        #     self.qact_input = QAct(quant=quant,
        #                            calibrate=calibrate,
        #                            bit_type=cfg.BIT_TYPE_A,
        #                            calibration_mode=cfg.CALIBRATION_MODE_A,
        #                            observer_str=cfg.OBSERVER_A,
        #                            quantizer_str=cfg.QUANTIZER_A)

        # if hybrid_backbone is not None:
        #     self.patch_embed = HybridEmbed(
        #         hybrid_backbone,
        #         img_size=img_size,
        #         in_chans=in_chans,
        #         embed_dim=embed_dim,
        #     )
        # else:
        self.patch_embed = PatchEmbed(img_size=img_size,
                                      patch_size=patch_size,
                                      In_Channels=in_chans,
                                      Out_Channels=embed_dim)
        num_patches = self.patch_embed.num_patches

        self.cls_token = nn.Parameter(torch.zeros(1, 1, embed_dim))
        self.pos_embed = nn.Parameter(
            torch.zeros(1, num_patches + 1, embed_dim))
        self.pos_drop = nn.Dropout(p=drop_rate)

        dpr = [x.item() for x in torch.linspace(0, drop_path_rate, depth)
               ]  # stochastic depth decay rule
        self.blocks = nn.ModuleList([
            Block(dim=embed_dim,
                  num_heads=num_heads,
                  mlp_ratio=mlp_ratio,
                  qkv_bias=qkv_bias,
                  qk_scale=qk_scale,
                  drop=drop_rate,
                  attn_drop=attn_drop_rate,
                  drop_path=dpr[i],
                  norm_layer=norm_layer,
                  quant=quant,
                  calibrate=calibrate,
                  cfg=cfg) for i in range(depth)
        ])
        self.blocks=nn.Transformer(nhead=16, num_encoder_layers=12)
        self.norm = norm_layer(embed_dim)
        self.qact2 = QAct(quant=quant,
                          calibrate=calibrate,
                          bit_type=cfg.BIT_TYPE_A,
                          calibration_mode=cfg.CALIBRATION_MODE_A,
                          observer_str=cfg.OBSERVER_A,
                          quantizer_str=cfg.QUANTIZER_A)

        # Representation layer
        if representation_size:
            self.num_features = representation_size
            self.pre_logits = nn.Sequential(
                OrderedDict([
                    ('fc', nn.Linear(embed_dim, representation_size)),
                    ('act', nn.Tanh()),
                ]))
        else:
            self.pre_logits = nn.Identity()

        # Classifier head
        self.head = (QLinear(self.num_features,
                             num_classes,
                             quant=quant,
                             calibrate=calibrate,
                             bit_type=cfg.BIT_TYPE_W,
                             calibration_mode=cfg.CALIBRATION_MODE_W,
                             observer_str=cfg.OBSERVER_W,
                             quantizer_str=cfg.QUANTIZER_W)
                     if num_classes > 0 else nn.Identity())
        self.act_out = QAct(quant=quant,
                            calibrate=calibrate,
                            bit_type=cfg.BIT_TYPE_A,
                            calibration_mode=cfg.CALIBRATION_MODE_A,
                            observer_str=cfg.OBSERVER_A,
                            quantizer_str=cfg.QUANTIZER_A)
        trunc_normal_(self.pos_embed, std=0.02)
        trunc_normal_(self.cls_token, std=0.02)
        self.apply(self._init_weights)

    def _init_weights(self, m):
        if isinstance(m, nn.Linear):
            trunc_normal_(m.weight, std=0.02)
            if isinstance(m, nn.Linear) and m.bias is not None:
                nn.init.constant_(m.bias, 0)
        elif isinstance(m, nn.LayerNorm):
            nn.init.constant_(m.bias, 0)
            nn.init.constant_(m.weight, 1.0)

    @torch.jit.ignore
    def no_weight_decay(self):
        return {'pos_embed', 'cls_token'}

    def get_classifier(self):
        return self.head

    def reset_classifier(self, num_classes, global_pool=''):
        self.num_classes = num_classes
        self.head = (nn.Linear(self.embed_dim, num_classes)
                     if num_classes > 0 else nn.Identity())

    def model_quant(self):
        for m in self.modules():
            if type(m) in [QConv2d, QLinear, QAct, QIntSoftmax]:
                m.quant = True
            if self.cfg.INT_NORM:
                if type(m) in [QIntLayerNorm]:
                    m.mode = 'int'

    def model_dequant(self):
        for m in self.modules():
            if type(m) in [QConv2d, QLinear, QAct, QIntSoftmax]:
                m.quant = False

    def model_open_calibrate(self):
        for m in self.modules():
            if type(m) in [QConv2d, QLinear, QAct, QIntSoftmax]:
                m.calibrate = True

    def model_open_last_calibrate(self):
        for m in self.modules():
            if type(m) in [QConv2d, QLinear, QAct, QIntSoftmax]:
                m.last_calibrate = True

    def model_close_calibrate(self):
        for m in self.modules():
            if type(m) in [QConv2d, QLinear, QAct, QIntSoftmax]:
                m.calibrate = False

    def forward_features(self, x):
        B = x.shape[0]

        if self.input_quant:
            x = self.qact_input(x)

        x = self.patch_embed(x)

        cls_tokens = self.cls_token.expand(
            B, -1, -1)  # stole cls_tokens impl from Phil Wang, thanks
        x = torch.cat((cls_tokens, x), dim=1)
        x = self.qact_embed(x)
        x = x + self.qact_pos(self.pos_embed)
        x = self.qact1(x)#这里用的是layernorm观察者

        x = self.pos_drop(x)#drop rate=0

        for i, blk in enumerate(self.blocks):
            last_quantizer = self.qact1.quantizer if i == 0 else self.blocks[
                i - 1].qact4.quantizer
            x = blk(x, last_quantizer)

        x = self.norm(x, self.blocks[-1].qact4.quantizer,
                      self.qact2.quantizer)[:, 0]
        x = self.qact2(x)
        x = self.pre_logits(x)
        return x

    def forward(self, x):
        x = self.forward_features(x)
        x = self.head(x)
        x = self.act_out(x)
        return x