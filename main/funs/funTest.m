Weight=rand(10,10);
Scale=rand_range([0.00001,0.0001],[1,10])
Zp=rand_range([0.00001,0.0001],[1,10]);
ConvQuant(Weight,Scale,Zp)



a=rand(100,100);
b=rand(100,100);
lp_loss(a,b,2,"NONE")



%% 
Fixed_Length_Hex(-15,4)