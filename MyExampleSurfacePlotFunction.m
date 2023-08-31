function [p_left,p_right,c] = MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits)


g_mesh          = surface_all.both;
g_lh            = surface_all.lh;
g_rh            = surface_all.rh;

vertex_id       = id_all.both;
lh_vertex_id    = id_all.lh;
rh_vertex_id    = id_all.rh;

final_cdata     = data_all.both;
left_cdata      = data_all.lh;
right_cdata     = data_all.rh;



scale = 18;
linewidth = 1;




% if nargin < 6 
%     climits = [nanmin(data) nanmax(data)];
% end
% climits = [nanmin(final_cdata) nanmax(final_cdata)];
% figure('Position',[461   462   560   325])
figure('Position',[107.5,310.5,1237,392.5])
% 1,1,1129.5,335.5
delta_left = 0.25;
delta_bottom = 0.05;
ax_sub1 = axes('Position',[delta_left+-0.3637,delta_bottom + 0.2566,1,1]); %2446
plotSurfaceROIBoundary(surface_all.lh,id_all.lh,data_all.lh ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
view([-90 0])

set(gca,'CameraViewAngle', scale)
axis off
axis image


ax_sub2 = axes('Position',[delta_left+-0.3637,delta_bottom + -0.1735,1,1]);
plotSurfaceROIBoundary(surface_all.lh,id_all.lh,data_all.lh ,'faces',cmap,linewidth);
% plotSurfaceROIBoundary(g_lh,lh_vertex_id,left_cdata,'faces',cmap,1,climits);
camlight(80,-10);
camlight(-80,-10);
view([90 0])

% 
set(gca,'CameraViewAngle', scale)
axis off
axis image



ax_sub3 = axes('Position',[delta_left+-0.077,delta_bottom+-0.178,1,1]);
plotSurfaceROIBoundary(surface_all.rh,id_all.rh,data_all.rh ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
view([-90 0])

set(gca,'CameraViewAngle', scale)
axis off
axis image



ax_sub4 = axes('Position',[delta_left+ -0.077,delta_bottom+ 0.2566,1,1] );
plotSurfaceROIBoundary(surface_all.rh,id_all.rh,data_all.rh ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
view([90 0])
% 
set(gca,'CameraViewAngle', scale)
axis off
axis image


ax_sub5 = axes('Position',[delta_left+-0.22,delta_bottom+ -0.005,1,1]);
plotSurfaceROIBoundary(surface_all.both,id_all.both,data_all.both ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
% view([0 0])
% 
set(gca,'CameraViewAngle', scale)
axis off
axis image


colormap(cmap)
caxis(climits)
c = colorbar('Location','southoutside');
% c = colorbar;
% set(c, 'xlim', [nanmin(final_cdata) nanmax(final_cdata)],'Position',[delta_left+0.17,0.07+delta_bottom,0.223,0.0367],'FontSize',10);
set(c, 'Position',[delta_left+0.17,0.07+delta_bottom,0.223,0.0367],'FontSize',10);
if exist('data_label','var')
    c.Label.String = data_label;
end