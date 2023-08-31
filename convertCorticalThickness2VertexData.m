function [w_left_cdata, lh_vertex_id, w_right_cdata, rh_vertex_id,final_cdata,vertex_id] = convertCorticalThickness2VertexData(corticalThicknesses)
% create vertex id
path_annot_lh = 'D:\Thanh\Research\plot-cortical-thickness-matlab/brainspace/lh.Schaefer2018_200Parcels_7Networks_order.annot';
path_annot_rh = 'D:\Thanh\Research\plot-cortical-thickness-matlab/brainspace/rh.Schaefer2018_200Parcels_7Networks_order.annot';

[~,gg_lh_cdata,a] = read_annotation(path_annot_lh);
lh_atlas_id = a.table(:,5);
lh_vertex_id  = gg_lh_cdata;

[~,gg_rh_cdata,a] = read_annotation(path_annot_rh);
rh_atlas_id = a.table(:,5);
rh_vertex_id  = gg_rh_cdata;

w_left_cdata = zeros(size(gg_lh_cdata));
w_right_cdata = zeros(size(gg_rh_cdata));

for j = 1:size(corticalThicknesses, 1) / 2
  % Vlookup mapping table
  w_left_cdata(find(gg_lh_cdata == lh_atlas_id(j))) = corticalThicknesses(2*j-1);
  w_right_cdata(find(gg_rh_cdata == rh_atlas_id(j))) = corticalThicknesses(2*j);
end

final_cdata = [w_left_cdata; w_right_cdata];
vertex_id = [lh_vertex_id; rh_vertex_id];