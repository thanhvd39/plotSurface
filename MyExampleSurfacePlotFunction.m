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
figure('Position',[107.5,144.5,889,558.5],'Color',[1 1 1])
delta_left = -0.07;
delta_bottom = -0.02;

lh_left = -0.2397;
lh_up = 0.3;
lh_down = -0.1262;

rh_left = 0.3;
rh_up = lh_up;
rh_down = lh_down;

midle_left = 0.03;
midle_bottom = 0.045;
ax_sub1 = axes('Position',[delta_left+lh_left ,delta_bottom + lh_up,1,1]); %2446
plotSurfaceROIBoundary(surface_all.lh,id_all.lh,data_all.lh ,'faces',cmap,linewidth);
% patch('FaceLighting','gouraud','Clipping','off',...
%     'Vertices',surface_all.lh.vertices,...
%     'SpecularStrength',0,...
%     'DiffuseStrength',0.8,...
%     'Faces',surface_all.lh.faces,...
%     'FaceColor','flat',...
%     'EdgeColor','none',...
%     'FaceVertexCData',data_all.lh);

camlight(80,-10);
camlight(-80,-10);
view([-90 0])

set(gca,'CameraViewAngle', scale)
axis off
axis image


ax_sub2 = axes('Position',[delta_left+lh_left,delta_bottom + lh_down,1,1]);
plotSurfaceROIBoundary(surface_all.lh,id_all.lh,data_all.lh ,'faces',cmap,linewidth);
% plotSurfaceROIBoundary(g_lh,lh_vertex_id,left_cdata,'faces',cmap,1,climits);
camlight(80,-10);
camlight(-80,-10);
view([90 0])

% 
set(gca,'CameraViewAngle', scale)
axis off
axis image



ax_sub3 = axes('Position',[delta_left+rh_left  ,delta_bottom + rh_down,1,1]);
plotSurfaceROIBoundary(surface_all.rh,id_all.rh,data_all.rh ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
view([-90 0])

set(gca,'CameraViewAngle', scale)
axis off
axis image



ax_sub4 = axes('Position',[delta_left+ rh_left,delta_bottom+lh_up,1,1] );
plotSurfaceROIBoundary(surface_all.rh,id_all.rh,data_all.rh ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
view([90 0])
% 
set(gca,'CameraViewAngle', scale)
axis off
axis image


ax_sub5 = axes('Position',[delta_left+midle_left ,delta_bottom+ midle_bottom,1,1]);
plotSurfaceROIBoundary(surface_all.both,id_all.both,data_all.both ,'faces',cmap,linewidth);
camlight(80,-10);
camlight(-80,-10);
% view([0 0])
% 
% set(gca,'CameraViewAngle', scale)
axis off
axis image


colormap(cmap)
caxis(climits)

% location = 'southoutside';
location = 'default';
if strcmp(location,'southoutside')
    c = colorbar('Location',location);
    set(c, 'Position',[delta_left+0.41917520363574,0.12354521038496+delta_bottom,0.223,0.0367],'FontSize',10);
elseif strcmp(location,'default')
    c = colorbar;
%     set(c, 'Position',[delta_left+0.9771 0.3638+delta_bottom 0.020059992500933 0.291629340901834]);
    set(c, 'Position',[0.914411586051746 0.389458012533572 0.020059992500933 0.291629340901834]);

set(gca,'CameraViewAngle', scale-2.5)   
end
if exist('data_label','var')
    c.Label.String = data_label;
end
