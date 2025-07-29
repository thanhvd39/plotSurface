function rh_lateral(surface_all,id_all,data_all,cmap,data_label,climits)


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


figure('Position',[107.5,144.5,889,558.5],'Color',[1 1 1])
delta_left = -0.07;
delta_bottom = -0.02;

lh_left = -0.2397;
lh_up = 0.3;
lh_down = -0.1262;

rh_left = 0.3;
rh_up = lh_up;
rh_down = lh_down;

plotSurfaceROIBoundary(surface_all.rh,id_all.rh,data_all.rh ,'faces',cmap,linewidth,climits);
camlight(80,-10);
camlight(-80,-10);
view([-90 0])
caxis(gca,climits)
% set(gca,'CameraViewAngle', scale)
axis off
axis image
