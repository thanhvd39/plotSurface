clc,close all;


addpath('gifti') %change to your gifti toolbox path
addpath('D:\Thanh\Research\plot-cortical-thickness-matlab')
path_annot_lh = 'lh.Schaefer2018_200Parcels_7Networks_order.annot';
path_annot_rh = 'rh.Schaefer2018_200Parcels_7Networks_order.annot';



% create vertex id
[~,gg_lh_cdata,anotation_lh] = read_annotation(path_annot_lh);
atlas_id = anotation_lh.table(:,5);
lh_vertex_id  = gg_lh_cdata;

[~,gg_rh_cdata,anotation_rh] = read_annotation(path_annot_rh);
atlas_id = anotation_rh.table(:,5);
rh_vertex_id  = gg_rh_cdata;

vertex_id = [lh_vertex_id; rh_vertex_id];
% save('vertecID.mat', 'vertex_id')

%%
save("mySurface_data.mat","anotation_lh", "anotation_rh","-append")