clc;
clear all;
close all;

Sample_freq=200; % 200Hz
% unit = uV

raw_data=xlsread('20221027.xlsx');
x=raw_data(:,1);
y=raw_data(:,2);
figure(01)
plot(x,y)
xlabel('Time (s)')
ylabel('Voltage (uV)')
ts=0;
tf=5200;
V_threshold=1.5;

% figure(05)
% [pks,locs,Firing_freq_pre_drug]=voltage_threshold_finding(raw_data,ts,tf,V_threshold,Sample_freq);



% pre-drug
ts=0;
tf=1000;
V_threshold=1.5;

figure(02)
[pks1,locs1,Firing_freq_pre_drug]=voltage_threshold_finding(raw_data,ts,tf,V_threshold,Sample_freq);

% during drug
ts=1500;
tf=3000;
V_threshold=1.5;

figure(03)
[pks2,locs2,Firing_freq_during_drug]=voltage_threshold_finding(raw_data,ts,tf,V_threshold,Sample_freq);

% after drug
ts=3500;
tf=5200;
V_threshold=1.5;

figure(04)
[pks3,locs3,Firing_freq_after_drug]=voltage_threshold_finding(raw_data,ts,tf,V_threshold,Sample_freq);







