function normalized_data=Ca_data_normalization(Ca_raw_data,ts,tf,sample_freq)
[m,n]=size(Ca_raw_data);
normalized_data=[];
for ii=1:m
    tmp=Ca_raw_data(ii,:);
            baseline_mean=mean(tmp(1:(ts*-1)*sample_freq));
%     baseline_mean=min(tmp);
    normalized_data_tmp=(tmp-baseline_mean)/baseline_mean;
    %         plot(normalized_data)
    %         hold on
    normalized_data=[normalized_data;normalized_data_tmp];
end
end