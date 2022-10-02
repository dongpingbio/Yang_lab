% This programe is used to analyze the c.elegan data for Yang Lab
% If you have any question, please contact Ping Dong by
% superdongping@gmail.com

clc;
clear all;
close all;

image_file=dir('*.jpg');
image_number=size(image_file,1);

% figure (1)
% imshow(png_file(1).name)

% Load the png files
for i=1:1:image_number
    image_stack {i} = imread(image_file(i).name) ; % read in first image
end

% quickly display the raw figure
for i=1:10:image_number
    
    imshow(image_stack{i});
    % pause(0.01)
    %     display(i)
end