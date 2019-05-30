xCenter = 0;
yCenter = 0;
% theta = 0 : 0.013339 : 2*pi;
theta = 0 : 0.02 : 2*pi;
radius = 15;
xCoor = radius * cos(theta) + xCenter;
yCoor = radius * sin(theta) + yCenter;
xCoor(end+1) = xCoor(1);
yCoor(end+1) = yCoor(1);
xCoor = round(xCoor,4);
yCoor = round(yCoor,4);
plot(xCoor, yCoor);
% grid on;
% axis([-50 50 -50 50])