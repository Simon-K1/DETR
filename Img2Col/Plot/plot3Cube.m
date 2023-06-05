function plot3Cube(centerLoc,edgeLen,thisColor)
% format compact
% h(1) = axes('Position',[0.2 0.2 0.6 0.6]);
vert = [1 1 1; 1 2 1; 2 2 1; 2 1 1 ; ...
    1 1 2; 1 2 2; 2 2 2; 2 1 2];
fac = [1 2 3 4; ...
    2 6 7 3; ...
    4 3 7 8; ...
    1 5 8 4; ...
    1 2 6 5; ...
    5 6 7 8];
vert0=vert-1.5;
vert1=vert0*edgeLen;    % 先放大
vert2=vert1+centerLoc;  % 再平移
patch('Faces',fac,'Vertices',vert2,'FaceColor',thisColor);
% view(30,30);
view(3)
% view(45,30);
alpha(0.2);
% material shiny;
% alpha('color');
% alphamap('rampdown');
end