% function [w_left_cdata, lh_vertex_id, w_right_cdata, rh_vertex_id,final_cdata,vertex_id] = convertCorticalThickness2VertexData(corticalThicknesses)
% % create vertex id
path_annot_lh = 'lh.Schaefer2018_200Parcels_7Networks_order.annot';
path_annot_rh = 'rh.Schaefer2018_200Parcels_7Networks_order.annot';

[~,gg_lh_cdata,a] = read_annotation(path_annot_lh);
lh_atlas_id = a.table(:,5);
lh_vertex_id  = gg_lh_cdata;

[~,gg_rh_cdata,a] = read_annotation(path_annot_rh);
rh_atlas_id = a.table(:,5);
rh_vertex_id  = gg_rh_cdata;


vertex_id = [lh_vertex_id; rh_vertex_id];
