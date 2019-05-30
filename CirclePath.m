clear all;

soundSpeed = 1540;
no_ele = 3; %total number of elements
channelSpacing = 0.2;%60/128;
fs = 40e6; %sample frequency
sampleSpacing = (1/fs)*soundSpeed*1e3; %sample number vs mm
times = 1;

CircleCoor
%rf_cumal = {};
out= zeros(2000,length(xCoor));
pre_bf = zeros(2000,length(xCoor));
for i = 1:length(xCoor)
[prebeam,t] =generateRF(xCoor(i),yCoor(i));

% for i = 1:size(prebeam,3)
rf_us = prebeam(:,2,2);
% end
rf_us2 = vertcat(zeros(round(t*fs-60),size(rf_us,2)),rf_us);
% if size(rf_us2, 1) < 1985
%     rf_us2 = vertcat(rf_us2, zeros(1985-size(rf_us2, 1),1));
% end

pre_bf(1:size(rf_us2,1),i) = rf_us2;
% out(:,i) = pre_bf(:,i);
%rf_cumal{i} = rf_us2;

end
out = DAS_ultrasound_circle(pre_bf, no_ele, fs, channelSpacing, soundSpeed, xCoor, yCoor);

%out = DAS_ultrasound(rf_cumal(:,1), no_ele, fs, channelSpacing, soundSpeed,times);


% imagesc(out);
env = abs(hilbert(out));
st = 1;
%ed = 2900;
ed = 1985;

x = [1 size(out,2)]*0.2;
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