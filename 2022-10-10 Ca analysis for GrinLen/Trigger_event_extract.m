function Ca_output=Trigger_event_extract(Raw_Ca_DataBase,Trigger_timeStamp, ts, tf, sample_freq)
Trigger_timeStamp_len=length(Trigger_timeStamp);
[m,n]=size(Raw_Ca_DataBase);

neuron_number=m;
Ca_output=[];
for ii=1:Trigger_timeStamp_len
    t0=Trigger_timeStamp(ii)/sample_freq;
    start_frame = (t0+ts)*sample_freq;
    end_frame = (t0+tf)*sample_freq;
    Ca_output_tmp=Raw_Ca_DataBase(:,start_frame:end_frame);
    Ca_output=[Ca_output;Ca_output_tmp];
end


end