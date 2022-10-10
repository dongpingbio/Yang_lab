clear all;
close all;
clc;
warning off;
%%
% load the tag file

[num,txt,raw] = xlsread('Tag_time.xlsx');
len1=length(raw(:,1));


for ii=1:len1
    data_sum(ii).name=raw(ii,1);
    tag_tmp=num(ii,:);
    tag_output=tag_tmp(~isnan(tag_tmp));
    data_sum(ii).tag=tag_output;
end

% load all the mat file from different sub folder
rootfolder='C:\Users\Ping Dong\Desktop\Hao Wang\';
filelist = dir(fullfile(rootfolder, '**', '*.mat'));
len=length(filelist);

for ii=1:len
    % for ii=1
    % prompt = "What is the mice tag? ";
    Mice_name = filelist(ii).folder(end-13:end-10);
    file_name=[filelist(ii).folder, '\trace.mat'];
    load(file_name)
    data_sum(ii).raw_Ca=trace;
end

% save('data_sum.mat','data_sum')

%%
% define analysis window time start/finish relative to the tag
ts=-2;
tf=10;
sample_freq=10; % 10 Hz

[m,n]=size(data_sum);
mice_num=n;
Ca_output_total_mice=[];

for ii=1:mice_num
    figure
    Raw_Ca_DataBase=data_sum(ii).raw_Ca;
    Trigger_timeStamp=data_sum(ii).tag;
    Ca_output_per_mice=Trigger_event_extract(Raw_Ca_DataBase,Trigger_timeStamp, ts, tf, sample_freq);
    imagesc(Ca_output_per_mice)

    title_txt=['Ca raw image',' Mice No. ', num2str(ii)];
    title(title_txt)
    
    colormap("hot")
    colorbar

    Ca_output_total_mice=[Ca_output_total_mice; Ca_output_per_mice];
    %     figure(ii)
    %     plot(Ca_output_per_mice')
end
% figure(100)
% plot(Ca_output_total_mice')


figure
imagesc(Ca_output_total_mice)
title('Ca_output_total_mice')
title('Raw Ca Image before normalization')
colormap("hot")
colorbar

% figure
normalized_data=Ca_data_normalization(Ca_output_total_mice,ts,tf,sample_freq);
% plot(normalized_data')

% figure
mean_normalized_data=mean(normalized_data);
% plot(mean_normalized_data);

figure
imagesc(normalized_data)
title('Normalized Data Before Sorting')
colormap("hot")
colorbar


% sort the data base on their value post trigger time
sort_ts=abs(ts);
sort_tf=sort_ts+4;

sort_intensity_mean=mean(normalized_data(:,sort_ts*sample_freq:sort_tf*sample_freq),2);
% figure
% hist(sort_intensity_mean)
% A=-0.4:0.1:1.6;
%
% edges = A;
% N = histcounts(sort_intensity_mean,edges);
% N= [N 0];
% figure
% plot(A,N);
% N_sum=sum(N);
%%
% Calculate ratio
% setting the up/down regulation Ca threshold

ratio_up_thres=0.1;
ratio_down_thres=-0.1;

Total_cell_number=length(sort_intensity_mean);

ratio_up_regulated=sum(sort_intensity_mean>ratio_up_thres)/Total_cell_number;
ratio_no_change=sum(sort_intensity_mean>=ratio_down_thres & sort_intensity_mean<=ratio_up_thres)/Total_cell_number;
ratio_down_regulated=sum(sort_intensity_mean<ratio_down_thres)/Total_cell_number;

ratio_output=[ratio_up_regulated; ratio_no_change; ratio_down_regulated];
ratio_output_txt={'ratio_up_regulated'; 'ratio_no_change';'ratio_down_regulated'};



normalized_data_rearranged_tmp=[sort_intensity_mean normalized_data];
normalized_data_rearranged = sortrows(normalized_data_rearranged_tmp,1,'descend') ;

normalized_data_rearranged=normalized_data_rearranged(:,2:end);

figure
imagesc(normalized_data_rearranged)
title('Normalized Data After Sorting')
xlabel('Frame of image')
% x_axis_range=0:1:(tf-ts);
% xticks(x_axis_range*sample_freq);
% xticklabels1=[];
% for jj=ts:1:tf
% xticklabels_tmp=num2str(jj);
% xticklabels1={xticklabels1;xticklabels_tmp};
% end

% xticklabels(xticklabels1)
ylabel('Cell No.')
colormap("hot")
colorbar

limits=[-0.1 1];
caxis (limits)

xlswrite('Data_summary.xlsx',normalized_data,'ori_norm_data');
xlswrite('Data_summary.xlsx',normalized_data_rearranged,'rear_norm_data');
xlswrite('Data_summary.xlsx',ratio_output_txt,'ratio','A1');
xlswrite('Data_summary.xlsx',ratio_output,'ratio','B1');


