function cmap = mycolormap(middleValue,range_thresh,cmin,cmax)
% author: thanhvd18 


n = 256;                %// resolution
middle_index = dsearchn(linspace(cmin,cmax,n)',middleValue)
cmap(1,:) = [220,0,0]/255; %red
cmap(3,:) = [245,245,245]/255;   %gray
cmap(2,:) = [247,247,247]/255;   %gray
cmap(4,:) = [60,84,136]/255; % blue
[X,Y] = meshgrid([1:3],[1:n]);  %// mesh of indices
cmap = interp2(X([1,middle_index-int32(n*range_thresh),middle_index+int32(n*range_thresh),n],:),Y([1,middle_index-int32(n*range_thresh),middle_index+int32(n*range_thresh),n],:),cmap,X,Y); %// interpolate colormap