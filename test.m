camlight(80,-10);
camlight(-80,-10);
view([-90 0])
axis off
axis tight
axis equal
axis vis3d

ax2 = axes('Position',[0.01+(1/3) 0 .3 1]);

cmap = flipud(hot(130));

% Just make up some data for the example illustration. This represents some
% value for each ROI
random_data = normpdf(1:180,100,100);

plotSurfaceROIBoundary(surface,lh_HCPMMP1,random_data,'midpoint',cmap(1:100,:),2);
camlight(80,-10);
camlight(-80,-10);