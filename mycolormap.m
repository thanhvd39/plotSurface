function cmap = mycolormap(middleValue,range_thresh,cmin,cmax)
% author: thanhvd18 
% middleValue: middle value - where no color
% range_thresh: from middleValue 0.1 => 10% from middle value 

n = 256;                %// resolution
% c = colorbar;
middle_index = dsearchn(linspace(cmin,cmax,n)',middleValue);
cmap(1,:) = [220,0,0]/255; %red
% cmap(1,:) = [245,245,245]/255; %gray
cmap(2,:) = [245,245,245]/255;   %gray
cmap(3,:) = [247,247,247]/255;   %gray
cmap(4,:) = [60,84,136]/255; % blue

% 
% % % cmap(1,:) = [220,0,0]/255; %red
% cmap(1,:) = [245,245,245]/255; %gray
% cmap(2,:) = [245,245,245]/255;   %gray
% cmap(3,:) = [247,247,247]/255;   %gray
% cmap(4,:) = [220,0,0]/255; % red

[X,Y] = meshgrid([1:3],[1:n]);  %// mesh of indices
cmap = interp2(X([1,middle_index-int32(n*range_thresh),middle_index+int32(n*range_thresh),n],:),Y([1,middle_index-int32(n*range_thresh),middle_index+int32(n*range_thresh),n],:),cmap,X,Y); %// interpolate colormap