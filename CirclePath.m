clear all;

soundSpeed = 1540;
no_ele = 3; %total number of elements
channelSpacing = 0.1;
fs = 40e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1e3; %sample number vs mm
times = 1;
radius = 15; %radius of circular path;
phantom_pos = [7,0,7*sqrt(3)]; %set phantom position(x,y,z)
cut_angle_roll = pi/2; % reconstruction cut angle
cut_angle_yaw = pi/6; % reconstruction cut angle


Coor = CircleCoor(0.02, radius, phantom_pos(1), phantom_pos(2));
xCoor = Coor(1,:);
yCoor = Coor(2,:);

%rf_cumal = {};
out = zeros(2000,length(xCoor));
pre_bf = zeros(2000,length(xCoor));
for i = 1:length(xCoor)
[prebeam,t] =generateRF(xCoor(i), yCoor(i), phantom_pos(3));

rf_us = prebeam(:,2,2);
rf_us2 = vertcat(zeros(round(t*fs-60),size(rf_us,2)),rf_us);

pre_bf(1:size(rf_us2,1),i) = rf_us2;
end

out = DAS_ultrasound_circle(pre_bf, radius, fs, channelSpacing, soundSpeed, xCoor, yCoor, phantom_pos, cut_angle_roll, cut_angle_yaw);

%out = DAS_ultrasound(rf_cumal(:,1), no_ele, fs, channelSpacing, soundSpeed,times);


% imagesc(out);
env = abs(hilbert(out));
st = 1;
%ed = 2900;
ed = 2000;

x = [1 size(out,2)]*channelSpacing;
% x = [1 size(out,2)]*0.5/times-size(out)*0.5/times/2;
% y = [st size(postBF_F,1)]*sampleSpacing;
y = [st ed]*sampleSpacing/2;
env = env/max(max(env(st:ed,:)));
figure
imagesc(x,y,db(env(st:ed,:)),[-40 0]);
% imagesc(abs(env(3000:end-500,:)));
colormap(gray)
axis image
colorbar
%}