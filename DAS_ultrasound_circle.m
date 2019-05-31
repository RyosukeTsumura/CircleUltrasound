
function out = DAS_ultrasound_circle(pre_bf, radius, Fs, channelSpacing, speedSound, xCoor, yCoor, phantom_pos, cut_angle_roll, cut_angle_yaw)

%%

ns = size(pre_bf,1);   % number of samples
nl = 2*radius/channelSpacing;   % number of lines

sampleSpacing = (1/Fs*speedSound)*1000/2; % spacing between samples in photoacoustic imaging

postBF = zeros(ns,nl);

xCoor2 = xCoor + phantom_pos(1) + radius; %modified coordinate
yCoor2 = yCoor + phantom_pos(2);
% hlfapt = round(no_ele/2);
RF = pre_bf;
% win = hamming(round(hlfapt)*2+1)';

for r = 1:nl % line number of recostruction plane
    for j = 1:ns % sample number of each line
        %           for i = r-hlfapt:r+hlfapt
        for i = 1:length(xCoor2) % signal processing of each channel
            width = (radius - (radius - r*channelSpacing)*cos(cut_angle_roll)) + r*channelSpacing*sin(cut_angle_roll)*sin(cut_angle_yaw) - xCoor2(i);
            depth = j*(sampleSpacing*1)*cos(cut_angle_yaw);
            elevation = (radius-r*channelSpacing)*sin(cut_angle_roll) + r*channelSpacing*cos(cut_angle_roll)*sin(cut_angle_yaw) - yCoor2(i);
            distance = sqrt(width^2 + depth^2 + elevation^2);
            delay = distance/sampleSpacing;
            
            %% No processing version

            if delay < ns
                y = RF(round(delay),i);
                postBF(j,r) = postBF(j,r) + y;
            end

            %% Linear regression
%             value = j+delay;
%             f_value = floor(value);
%             c_value = ceil(value);
%             
%             if delay == 0
%                 postBF(j,r) = postBF(j,r) + RF(j,ceil(i));
%             elseif c_value < ns
%                 y_c = RF(c_value,ceil(i));
%                 y_f = RF(f_value,ceil(i));
%                 alpha = (value - f_value)/(c_value - f_value);
%                 if alpha >0 && alpha <1
%                     y = (1-alpha)*y_f + alpha*y_c;
%                     postBF(j,r) = postBF(j,r) + y;
%                 else
%                     postBF(j,r) = postBF(j,r) + RF(j,ceil(i));
%                 end
%             end
%{
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
%}
        end
    end
end


out = postBF;