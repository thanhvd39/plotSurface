clc,
close all;
clear;


load('mySurface_data.mat')
% load('D:\Thanh\Research\rePLS-figure\figure5\PQ_classification_3.mat')
% i = 1;
% difference_PQ = zeros(size(PQ));
% difference_PQ(:,1) = PQ(:,2) - PQ(:,1);
% difference_PQ(:,2) = PQ(:,3) - PQ(:,2);
% difference_PQ(:,3) = PQ(:,3) - PQ(:,1);
% difference_PQ = -difference_PQ;
% corticalThicknesses = difference_PQ(:,i);

corticalThicknesses = randn(202,1);
cmin = min(corticalThicknesses);
cmax = max(corticalThicknesses);
corticalThicknesses(1) = NaN;
corticalThicknesses(2) = NaN;


[left_cdata, lh_vertex_id, right_cdata, rh_vertex_id,final_cdata,vertex_id]  = convertCorticalThickness2VertexData(corticalThicknesses);
data_label = "";
middleValue = 0;
range_thresh = 0.1;
cmap = mycolormap(middleValue,range_thresh,cmin,cmax);


% surface_all.both = g_mesh;
% surface_all.lh = g_lh;
% surface_all.rh = g_rh;
% 
% id_all.both = vertex_id;
% id_all.lh = lh_vertex_id;
% id_all.rh = rh_vertex_id;

data_all.both = final_cdata;
data_all.lh = left_cdata;
data_all.rh = right_cdata;

MyExampleSurfacePlotFunction(surface_all,id_all,data_all,cmap,data_label);
% ExampleSurfacePlotFunction(g_lh,lh_vertex_id,left_cdata,cmap,data_label);
% ExampleSurfacePlotFunction(g_rh,rh_vertex_id,right_cdata,cmap,data_label);
% ExampleSurfacePlotFunction(g_mesh,vertex_id,final_cdata,cmap,data_label);
