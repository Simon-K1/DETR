% plot3(0,0,0,['.'])
% 
% hold on
% 
% plot3(0,0,2,['.'])
% 
% hold on
% 
% plot3(2,2,2,['o'])
% 
% hold on
% 
% plot3(0,2,0,['o'])
% 
% hold on
% 
% plot3(2,0,2,['o'])
% 
% hold on
% 
% plot3(0,2,2,['o'])
% 
% hold on
% 
% plot3(2,2,0,['o'])
% 
% hold on
% 
% plot3(2,2,0,['o'])
% 
% hold on
% 
% plot3(2,0,0,['o'])
% 
% axis([0 3 0 3 0 3])
% 
% plot3([0,0],[0,0],[0,2])
% 
% plot3([0,0],[0,2],[0,0])
% 
% plot3([0,2],[0,0],[0,0])
% 
% plot3([0,2],[0,0],[2,2])
% 
% plot3([0,0],[0,2],[2,2])
% 
% plot3([0,0],[2,2],[0,2])
% 
% plot3([2,2],[0,0],[0,2])
% 
% plot3([2,2],[2,2],[2,0])
% 
% plot3([2,2],[2,0],[2,2])
% 
% plot3([2,0],[2,2],[2,2])
% 
% plot3([2,0],[2,2],[0,0])
% 
% plot3([2,2],[2,0],[0,0])
% 
% plot3([2,2],[0,0],[2,0])
% 
% plot3([0,0],[2,2],[2,0])
%% 构建一个立方体
clear
centerLoc=[1,0,0];
edgeLen=1;
thisColor='r';
plot3Cube(centerLoc,edgeLen,thisColor);
axis equal
% plot3Cube([6 3.5 3],0.5,thisColor);
% plot3Cube([2 3 3],0.8,thisColor);
% grid on
