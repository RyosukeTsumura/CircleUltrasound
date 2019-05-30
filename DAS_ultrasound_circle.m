
function out = DAS_ultrasound_circle(pre_bf, no_ele, Fs, channelSpacing, speedSound, xCoor, yCoor)

% load('pre_bfrf.mat')
% load('Corr.mat')
% soundSpeed = 1540;
% % no_ele = 3; %total number of elements
% channelSpacing = 0.2;%60/128;
% Fs = 40e6; %sample frequency
% sampleSpacing = (1/Fs)*soundSpeed*1e3/2; %sample number vs mm

%%

ns = size(pre_bf,1);   % number of samples
nl = 30/0.3;   % number of lines

sampleSpacing = (1/Fs*speedSound)*1000/2; % spacing between samples in photoacoustic imaging

postBF = zeros(ns,nl);
xCoor2 = xCoor+15;

% hlfapt = round(no_ele/2);
RF = pre_bf;
% win = hamming(round(hlfapt)*2+1)';
for r = 1:nl % final line
    for j = 1:ns
        %           for i = r-hlfapt:r+hlfapt
        for i = 1:length(xCoor2)
            
            width = r*0.3 - xCoor2(i);
            depth = j*(sampleSpacing*1);
            elevation = yCoor(i);
            distance = sqrt(width^2 + depth^2 + elevation^2);
            delay = distance/sampleSpacing;
                if delay < ns
                    y = RF(round(delay),i);
                    postBF(j,r) = postBF(j,r) + y;
                end
            % %             if i > 0 && i <= nl
            %                 depth = j*(sampleSpacing*1);
            %                 width = (r-(i)) * channelSpacing;
            %                 rad = sqrt((depth)^2 + width^2);
            %                 delay = (rad - depth)/(sampleSpacing);
            %                 value = j+delay;
            %                 f_value = floor(value);
            %                 c_value = ceil(value);
            %                 if delay == 0
            %                     postBF(j,r) = postBF(j,r) + RF(j,ceil(i));
            %                 elseif c_value < ns
            %                     y_c = RF(c_value,ceil(i));
            %                     y_f = RF(f_value,ceil(i));
            %                     alpha = (value - f_value)/(c_value - f_value);
            %                     if alpha >0 && alpha <1
            %                         y = (1-alpha)*y_f + alpha*y_c;
            %                         postBF(j,r) = postBF(j,r) + y;
            %                     else
            %                         postBF(j,r) = postBF(j,r) + RF(j,ceil(i));
            %                     end
            % %                 end
        end
    end
end


out = postBF;