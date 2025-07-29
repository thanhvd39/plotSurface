function cmap = mycolormap_blue(cmin,cmax)
% author: thanhvd18 
% middleValue: middle value - where no color
% range_thresh: from middleValue 0.1 => 10% from middle value 

n = 256;                %// resolution
% c = colorbar;
% range_thresh = 0.2;
% middleValue = cmin + (-cmin+cmax)*0.21;
range_thresh = 0.01;
middleValue = cmin + (-cmin+cmax)*0.7;
% middleValue = 0.0
middle_index = dsearchn(linspace(cmin,cmax,n)',middleValue);
cmap(1,:) = [255,255,255]/255; %white
cmap(2,:) = [247,247,247]/255;   %gray
cmap(3,:) = [230,230,230]/255;   %gray
cmap(4,:) = [60,84,136]/255; % blue

[X,Y] = meshgrid([1:3],[1:n]);  %// mesh of indices
cmap = interp2(X([1,middle_index-int32(n*range_thresh),middle_index+int32(n*range_thresh),n],:),Y([1,middle_index-int32(n*range_thresh),middle_index+int32(n*range_thresh),n],:),cmap,X,Y); %// interpolate colormap