% This programe is used to analyze the calcium data for Yang Lab
% If you have any question, please contact Ping Dong by
% superdongping@gmail.com

clc;
clear all;
close all;

png_file=dir('*.png');
png_number=size(png_file,1);

% figure (1)
% imshow(png_file(1).name)

% Load the png files
for i=1:1:png_number
    png_stack {i} = imread(png_file(i).name) ; % read in first image
end

% quickly display the raw figure
for i=1:10:png_number
    
    imshow(png_stack{i});
    % pause(0.01)
    %     display(i)
end



% to select the target cell from the background, I can sum 4 figures and
% increase the intensity for each cell.

for i=1:1:10
    png_tmp {i} = imread(png_file(i).name) ; % read in first image
    
end
a1=png_tmp {1};
a2=png_tmp {2};
a3=png_tmp {3};
a4=png_tmp {4};
sum_png=[a1+a2+a3+a4];
h_fig=figure;

figure(h_fig)
imshow(sum_png)




I_s_BW = ~im2bw(sum_png, 0.3); % Gray to BW,  to be set
% figure(6);
% imshow(I_s_BW);

I_s_BW_m = ~medfilt2(I_s_BW,[10,10]); % Medium Filter, get rid of pepper noise, invert the image from whie to black
% figure(7);
% imshow(I_s_BW_m);




% Count the connected area
L = bwlabeln(I_s_BW_m, 8);
S = regionprops(L, 'Area');

% To be set the area threshold
pos = ([S.Area] <= 3000) & ([S.Area] >= 10);
pos_ex = ~pos;

bw2 = ismember(L, find(pos));
bw2_ex = ismember(L, find(pos_ex));

S1 = [S.Area];
S1 = S1(pos);
C = regionprops(bw2, 'Centroid');  % to be processed

% Get the center of connected areas
C1 = [C.Centroid];
C1 = reshape(C1, 2, length(C1)/2)';
c_pos=C1;

% For exception
C_ex = regionprops(bw2_ex, 'Centroid');  % to be processed
C1_ex = [C_ex.Centroid];
C1_ex = reshape(C1_ex, 2, length(C1_ex)/2)';

% Mark the connected region on the orignal picture
for m=1:length(C1)
figure(h_fig); hold on;
plot(C1(m,1), C1(m,2), 'r+', 'MarkerSize', 10);
cell_number=num2str(m);
text(C1(m,1), C1(m,2),cell_number,'Color','c','FontSize',10)
% plot(C1_ex(:,1), C1_ex(:,2), 'g+', 'MarkerSize', 10);
hold off;
end

% get the intensity value from a specific point

% figure(102);
% imshow(sum_png)
% hold on;

C0=round(C1);

start_frame=1;

end_frame=png_number;
sum_output_Ca=[];
% figure(300)
for j=1:length(C1)
%     plot(C1(j,1), C1(j,2), 'y+', 'MarkerSize', 10);
    rect=[C0(j,1)-8 C0(j,2)-8 15 15];
%     rectangle('Position',rect,'EdgeColor','w')
%     pause(0.1) 

%     I=sum_png;
%     J = imcrop(I,rect) ;
    
    output_Ca=time_curve(start_frame, end_frame,png_stack,rect);
    sum_output_Ca=[sum_output_Ca; output_Ca];
%     plot(output_Ca)
%     hold on
%     pause(0.1)
end



% to calculate the Ca2+ spike frequency
sample_acquisition_interval=10; %sample_acquisition_interval is 10s
Ca_threshold=0.6;
figure(105)
Ca_event_time_point={};

for j=1:length(C1)
    % for j=11:20
    % for j=[2]
    plot(sum_output_Ca(j,:))
    hold on
    
    e1=sum_output_Ca(j,:);
    
    % to exclude abnormal value
    if max(e1)>4
        e1(:)=0;
    end
    
    e1(e1<=Ca_threshold)=0;
    [b1,c1]=findpeaks(e1);
    e1=sum_output_Ca(j,:);
    plot(start_frame:end_frame,e1,c1,b1,'m*')
    Ca_no_output(j)=length(b1);
    
    if length(c1)>=2
        Ca_event_interval=diff(c1);
        Ca_freq=mean(1./(Ca_event_interval*sample_acquisition_interval));
    else
        Ca_event_interval=0;
        Ca_freq=0;
    end
    output_Ca_freq(j)=Ca_freq;    
end

xlswrite('Ca_freq_for_Individual_Cell.xlsx',output_Ca_freq)
xlswrite('Individual_Cell_Ca_spike_number.xlsx',Ca_no_output)
xlswrite('Individual_Cell_Ca_value_raw_data.xlsx',sum_output_Ca)

