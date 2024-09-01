
clc,
% close all;
clear;
load('mySurface_data.mat')

N_vertices = 163842;

% % corticalThicknesses = rand(202,1);
% % corticalThicknesses = reshape(corticalThicknesses,[202,1]);
run("import_csv")
corticalThicknesses = mean(table2array(thicknessdata),2);
corticalThicknesses(1) = NaN;
corticalThicknesses(2) = NaN;

surface = surface_all.both;
vertex_id = id_all.both;
data = corticalThicknesses;
data_label = "";
middleValue = 0;
range_thresh = 0.1;
cmin = min(corticalThicknesses(:));
cmax = max(corticalThicknesses(:));
climits = [cmin, cmax];
% cmap = mycolormap(middleValue,range_thresh,cmin,cmax);

cmap = jet(100);
linewidth = 1;


% axis off
% axis tight
% axis equal
% axis vis3d
lh_region = id_all.lh;
rh_region = id_all.rh;
lh_atlas_id = anotation_lh.table(:,5);
rh_atlas_id = anotation_rh.table(:,5);

w_left_cdata = zeros(N_vertices,1);
w_right_cdata = zeros(N_vertices,1);

for j = 1:size(corticalThicknesses, 1) / 2
  % Vlookup mapping table
  w_left_cdata(find(lh_region == lh_atlas_id(j))) = corticalThicknesses(2*j-1);
  w_right_cdata(find(rh_region == rh_atlas_id(j))) = corticalThicknesses(2*j);
end

final_cdata = [w_left_cdata; w_right_cdata];
data_all.both = final_cdata;
data_all.lh = w_left_cdata;
data_all.rh = w_right_cdata;

MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label,climits);

