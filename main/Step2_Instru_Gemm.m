%% GEMM指令生成（有没有更方便的生成方法？）
clear
load("matlab.mat");
%先去Step7中看一下

Start=1;
InSwitch_Weight=1;
InSwitch_Img2col=0;
InSwitch_Quant=0;
InSwitch_Layernorm=0;
InSwitch_Gemm=0;