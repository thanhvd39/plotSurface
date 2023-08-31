clc,close all;


addpath('gifti') %change to your gifti toolbox path
addpath('D:\Thanh\Research\plot-cortical-thickness-matlab')
path_annot_lh = 'D:\Thanh\Research\plot-cortical-thickness-matlab/brainspace/lh.Schaefer2018_200Parcels_7Networks_order.annot';
path_annot_rh = 'D:\Thanh\Research\plot-cortical-thickness-matlab/brainspace/rh.Schaefer2018_200Parcels_7Networks_order.annot';



% create vertex id
[~,gg_lh_cdata,a] = read_annotation(path_annot_lh);
atlas_id = a.table(:,5);
lh_vertex_id  = gg_lh_cdata;

[~,gg_rh_cdata,a] = read_annotation(path_annot_lh);
atlas_id = a.table(:,5);
rh_vertex_id  = gg_rh_cdata;

vertex_id = [lh_vertex_id; rh_vertex_id];
save('vertecID.mat', 'vertex_id')

