function output_Ca=time_curve(start_frame, end_frame,png_stack,rect)
% figure(300)
for i=start_frame:end_frame 
    
    B=imcrop(png_stack{i},rect);    
    F(i)=sum(B(:));

end
G=F;
G=(G-min(G))./min(G);
output_Ca=smooth(G)';
% % filename = 'int1.xlsx';
% % xlswrite(filename,(G'));

% 
% plot(smooth(G))
% hold on
% ylabel('\bfIntensity[a.u.]','FontSize',14);
% xlabel('\bfFrame','FontSize',14);
end
