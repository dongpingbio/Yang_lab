function [pks,locs,Firing_freq]=voltage_threshold_finding(raw_data,ts,tf,V_threshold,Sample_freq)
x1=raw_data(ts*Sample_freq+1:tf*Sample_freq,1);
y1=raw_data(ts*Sample_freq+1:tf*Sample_freq,2);
subplot(2,2,1)
plot(x1,y1)
title('selected time')

subplot(2,2,2)
y2=y1;
y2(y2<V_threshold)=0;
plot(x1,y2)
title('threshold')

subplot(2,2,3)
[pks,locs] = findpeaks(y2);
plot(x1,y1)
hold on
plot(x1(locs),y1(locs),'r*')
Firing_freq=mean(1./(diff(locs)/Sample_freq));
end