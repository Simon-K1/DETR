% Weight=rand(10,10);
% Scale=rand_range([0.00001,0.0001],[1,10])
% Zp=rand_range([0.00001,0.0001],[1,10]);
% ConvQuant(Weight,Scale,Zp)
% 
% 
% 
% a=rand(100,100);
% b=rand(100,100);
% lp_loss(a,b,2,"NONE")



% %% 
% Fixed_Length_Hex(-15,4)
% %% 
% subplot(2,2,1);
% AbsError(randi(10,10),randi(10,10))

%% 匿名函数
a=@(~,~)Nmhs(1,2)
a(3,4)%可以看出，永远输出的都是1，2
function Nmhs(a,b)
    a
    b
end