Mlp=Mlp(1,[197,384],6,4,8,64,200,16)
c=Encoder(1,[197,384],6,4,8,64,200,16)

Vit_Tiny=Encoder(1,[197,192],6,4,8,64,200,16)

Vit_Base=Encoder(1,[197,768],12,4,8,64,200,16,0,1)

c=Attn(1,[197,384],6,4,8,64,16,200)

Embed=Embedding(1,8,384,14,16,200,16,4,8,64)
Embed.PlotGant


Vit_Base=Attn(1,[197,768],12,4,8,64,200,16,0,0)
Vit_Tiny=Attn(1,[197,384],6,4,8,64,200,16,0,1)

Vit_Small=Attn(1,[197,384],6,4,8,64,200,16,0,1)
Vit_Small_Encoder=Encoder(1,[197,384],6,4,8,64,200,16,0,0)
Vit_Small.PlotGant


Vit_Base_Attn=Attn(1,[197,768],12,4,8,64,200,16,0,0)
Vit_BAse_Encoder=Encoder(1,[197,768],12,4,8,64,200,16,0,0)
Embed=Embedding(1,8,768,14,16,200,16,4,8,64)


%% 
Conv=0.827
Conv_Add=0.095
0.827+0.095+(0.101+3.15+0.38+0.556+0.095+0.101+1.27+.44)*12+0.101+0.058


%% tiny
Embed=Embedding(1,8,192,14,16,200,16,4,8,64)
Vit_Tiny_Attn=Attn(1,[197,192],3,4,8,64,200,16,0,0)
Vit_Tiny_Encoder=Encoder(1,[197,192],3,4,8,64,200,16,0,0)

%% Base
Embed=Embedding(1,8,768,14,16,200,16,4,8,64)
Vit_Base_Attn=Attn(1,[197,768],12,4,8,64,200,32,0,0)
Vit_Base_Encoder=Encoder(1,[197,768],12,4,8,64,200,16,0,0)
%% small
Embed=Embedding(1,8,384,14,16,200,16,4,8,64)
Vit_Small_Attn=Attn(1,[197,384],6,4,8,64,200,16,0,1)
Vit_Small_Encoder=Encoder(1,[197,384],6,4,8,64,200,16,0,0)


Vit_Small_Attn=Attn(1,[197,256],6,4,8,64,200,16,0,1)