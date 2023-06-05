clear
%% 卷积层
image=rand(224,224,32);
Conv1=convolution3dLayer([3,3,32],32);
checkLayer(Conv1,[1,224,224,32])